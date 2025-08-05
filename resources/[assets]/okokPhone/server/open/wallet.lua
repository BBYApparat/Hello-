---@class OKOKTransaction
---@field date string
---@field type string
---@field amount number
---@field sender string
---@field receiver string

local ACCOUNT_NAME = Config.Wallet.account or 'bank'

--- Local Database Used when okokBanking is not running
local db = {}

---@param charId string
function db.getPath(charId)
  return ("wallet:%s:transactions"):format(charId)
end

---@param charId string
---@return OKOKTransaction[]
function db:getTxs(charId)
  local txs = GetResourceKvpString(self.getPath(charId))
  return txs and json.decode(txs) or {}
end

---@param charId string
---@param tx OKOKTransaction
function db:storeTx(charId, tx)
  local txs = db:getTxs(charId)
  table.insert(txs, tx)
  SetResourceKvp(self.getPath(charId), json.encode(txs))
end

---@param playerObj table
---@return string | false
local function getIban(playerObj)
  if CurrentFramework == 'qb' or CurrentFramework == 'qbx' then
    return playerObj.PlayerData.charinfo.account -- iban
  else
    return xpcall(function()
      local identifier = Utils:getCharacterId(playerObj)
      return MySQL.prepare.await('SELECT iban FROM users WHERE identifier = ? LIMIT 1', { identifier }) --[[ @as string | false ]]
    end, function()
      return false
    end)
  end
end

---@param identifier string @character identifier
---@param amount number
---@return boolean
local function addAccountMoneyViaDB(identifier, amount)
  if CurrentFramework == "qb" then
    local accounts = MySQL.prepare.await("SELECT money FROM players WHERE citizenid = ? LIMIT 1", { identifier }) --[[ @as string? ]]
    accounts = accounts and json.decode(accounts)
    if not accounts then return false end

    accounts.bank += amount

    local result = MySQL.prepare.await("UPDATE players SET money = ? WHERE citizenid = ?",
      { json.encode(accounts), identifier }) --[[ @as number ]]

    return result == 1
  elseif CurrentFramework == 'esx' then
    local accounts = MySQL.prepare.await("SELECT accounts FROM users WHERE identifier = ? LIMIT 1",
      { identifier }) --[[ @as string? ]]
    accounts = accounts and json.decode(accounts)
    if not accounts then return false end

    for _, account in ipairs(accounts) do
      if account.name == ACCOUNT_NAME then
        account.money += amount
        break
      end
    end

    local result = MySQL.prepare.await("UPDATE users SET accounts = ? WHERE identifier = ?",
      { json.encode(accounts), identifier }) --[[ @as number ]]

    return result == 1
  end
  return false
end

---@return OKOKTransaction[]?
local function getTransactions(identifier)
  if isResourceRunning("okokBanking") then
    local result = MySQL.rawExecute.await(
      'SELECT * FROM okokbanking_transactions WHERE receiver_identifier = ? OR sender_identifier = ? ORDER BY id DESC',
      { identifier, identifier }) --[[ @as table ]]

    local transactions = {}
    for _, t in ipairs(result) do
      table.insert(transactions, {
        date = t.date,
        type = t.type,
        amount = t.value,
        sender = t.sender_name == identifier and 'self' or t.sender_name,
        receiver = t.receiver_name == identifier and 'self' or t.receiver_name,
      })
    end
    return transactions
  else
    return db:getTxs(identifier)
  end
end

---@return OKOKTransaction
local function storeTransaction(senderName, senderIdentifier, receiverName, receiverIdentifier, value)
  local now = os.date('%Y-%m-%d %H:%M:%S')

  if isResourceRunning("okokBanking") then
    MySQL.prepare(
      'INSERT INTO okokbanking_transactions (receiver_identifier,receiver_name,sender_identifier,sender_name,value,type,date) VALUES (?,?,?,?,?,?,?)',
      { receiverIdentifier, receiverName, senderIdentifier, senderName, value, "transfer", now })

    return {
      date = now,
      type = "transfer",
      amount = value,
      sender = senderName,
      receiver = receiverName
    }
  else
    -- Store in our database
    local tx = {
      date = now,
      type = "transfer",
      amount = value,
      sender = senderName,
      receiver = receiverName
    }

    db:storeTx(senderIdentifier, tx)

    return tx
  end
end

--- This function assumes that the sender has enough money
---@param playerObj table
---@param iban string
---@param amount number
---@return {status:boolean, name:string, identifier:string}
local function sendMoneyViaIban(playerObj, iban, amount)
  if CurrentFramework == 'qb' or CurrentFramework == 'qbx' then
    --[[ Get Target Identifier from IBAN ]]
    local targetData = MySQL.prepare.await(
      "SELECT * FROM players WHERE JSON_EXTRACT(charinfo, '$.account') = ? LIMIT 1",
      { iban })

    if not targetData then return { status = false, name = '' } end

    local targetCharInfo = json.decode(targetData.charinfo)
    local targetObject = Utils:getPlayerObjectFromCharIdentifier(targetData.citizenid)


    --[[ If player is offline ]]
    if not targetObject then
      local targetAccounts = json.decode(targetData.money)
      targetAccounts.bank = targetAccounts.bank + amount

      MySQL.prepare.await("UPDATE players SET money = ? WHERE citizenid = ?",
        { json.encode(targetAccounts), targetData.citizenid })
    else
      --[[ If player is online ]]
      targetObject.Functions.AddMoney(ACCOUNT_NAME, amount)
    end

    --[[ Remove money from sender ]]
    playerObj.Functions.RemoveMoney(ACCOUNT_NAME, amount)


    local name = ("%s %s"):format(targetCharInfo.firstname, targetCharInfo.lastname)
    return {
      status = true,
      name = name,
      identifier = targetData.citizenid
    }
  elseif CurrentFramework == "esx" then
    --[[ Get Target Identifier from IBAN ]]
    local targetData = MySQL.prepare.await("SELECT * FROM users WHERE iban = ?", { iban })
    if not targetData then return { status = false, name = '' } end


    local targetObject = Utils:getPlayerObjectFromCharIdentifier(targetData.identifier)

    --[[ If player is offline ]]
    if not targetObject then
      local targetAccounts = json.decode(targetData.accounts)
      for _, a in ipairs(targetAccounts) do
        if a.name == ACCOUNT_NAME then
          a.money = a.money + amount
          break
        end
      end
      MySQL.prepare.await("UPDATE users SET accounts = ? WHERE identifier = ?",
        { json.encode(targetAccounts), targetData.identifier })
    else
      --[[ If player is online ]]
      targetObject.addAccountMoney(ACCOUNT_NAME, amount)
    end
    --[[ Remove money from sender ]]
    playerObj.removeAccountMoney(ACCOUNT_NAME, amount)


    local name = ("%s %s"):format(targetData.firstname, targetData.lastname)
    return {
      status = true,
      name = name,
      identifier = targetData.identifier
    }
  end
  return { status = false, name = '' }
end

--- Gets the players accounts transactions, iban and char name
---@return any result
RegisterServerCallback('getWallet', function(source, data)
  local playerObj = Utils:getPlayerObject(source)
  if not playerObj then return false end
  local accounts = Utils:getPlayerAccounts(playerObj)
  local transactions = getTransactions(Utils:getCharacterId(playerObj))
  local iban = getIban(playerObj)
  local name = Utils:getCharacterName(playerObj)
  return { accounts = accounts, transactions = transactions, okok = iban, name = name }
end)


local transfer = {}

---@param playerObj table
---@param iban string
---@param amount number
---@return {name:string, identifier:string} | false
function transfer.iban(playerObj, iban, amount)
  if not isResourceRunning('okokBanking') then return false end
  local result = sendMoneyViaIban(playerObj, iban, amount)
  okDebug(result)
  if result.status then
    return {
      name = result.name,
      identifier = result.identifier
    }
  end
  return false
end

---@param playerObj table
---@param targetId number
---@param amount number
---@return {name:string, identifier:string} | false
function transfer.playerId(playerObj, targetId, amount)
  -- Check if player is online and get the object
  local targetObj = GetPlayerName(targetId) and Utils:getPlayerObject(targetId)
  if not targetObj then return false end

  --- Transfer money
  local targetIdentifier = Utils:getCharacterId(targetObj) --[[ @as string ]]
  local targetName = Utils:getCharacterName(targetObj) --[[ @as string ]]

  Utils:addAccountMoney(ACCOUNT_NAME, amount, targetObj)
  Utils:removeAccountMoney(ACCOUNT_NAME, amount, playerObj)

  return { name = targetName, identifier = targetIdentifier }
end

---@param playerObj table
---@param phoneNumber string
---@param amount number
---@return {name:string, identifier:string} | false
function transfer.phoneNumber(playerObj, phoneNumber, amount)
  local player = Phones:getSourceByPhoneNumber(phoneNumber)

  local targetName = ''
  local targetIdentifier = ''


  ---@param src number
  local function performTransfer(src)
    local targetObj = Utils:getPlayerObject(src)
    if not targetObj then return false end
    targetIdentifier = Utils:getCharacterId(targetObj) --[[ @as string ]]
    targetName = Utils:getCharacterName(targetObj) --[[ @as string ]]

    Utils:addAccountMoney(ACCOUNT_NAME, amount, targetObj)
    Utils:removeAccountMoney(ACCOUNT_NAME, amount, playerObj)
  end

  --[[ If the player is found with the phone number ]]
  if player then
    performTransfer(player)
  else
    --[[ Get the identifier of the phone number ]]
    local result = MySQL.prepare.await(
      "SELECT owner,name FROM okokphone_phones WHERE phone_number = ? LIMIT 1", { phoneNumber }) --[[ @as  {owner:string, name:string} | false]]
    if not result then return false end


    --- Find player by charId
    for _, playerObj in pairs(Utils:getPlayersList()) do
      if Utils:getCharacterId(playerObj) == result.owner then
        player = Utils:getPlayerSource(playerObj)
        break
      end
    end

    targetIdentifier = result.owner --[[ @as string ]]
    targetName = result.name --[[ @as string ]]

    --[[ Player is online ]]
    if player then
      performTransfer(player)

      --[[ Player is not online , but identifier is found ]]
    else
      addAccountMoneyViaDB(result.owner, amount)
      Utils:removeAccountMoney(ACCOUNT_NAME, amount, playerObj)
    end
  end

  return { name = targetName, identifier = targetIdentifier }
end

---@param data {target:string, method:"iban" | "player_id" | "phoneNumber", amount:number}
---@return {balance:number, transaction:OKOKTransaction} | false
RegisterServerCallback('sendBankMoney', function(source, data)
  local playerObj = Utils:getPlayerObject(source)
  if not playerObj then return false end

  local myIdentifier = Utils:getCharacterId(playerObj)
  local myName = Utils:getCharacterName(playerObj)

  --[[ Check if player has enough money ]]
  local balance = Utils:getAccountMoney(ACCOUNT_NAME, playerObj)
  if balance < data.amount then return false end

  local finalBalance = balance - data.amount

  if data.method == 'iban' then
    local result = transfer.iban(playerObj, data.target, data.amount)
    if result then
      local tx = storeTransaction(myName, myIdentifier, result.name, result.identifier, data.amount)
      return { balance = finalBalance, transaction = tx }
    end
  elseif data.method == "player_id" then
    local targetId = tonumber(data.target) --[[ @as number ]]
    if source == targetId then return false end
    local result = transfer.playerId(playerObj, targetId, data.amount)
    if result then
      local tx = storeTransaction(myName, myIdentifier, result.name, result.identifier, data.amount)
      CreateThread(function()
        local imei = Phones:getEquippedImei(targetId)
        if not imei then return end
        Phones:pushNotifyViaImei(imei, {
          app = "wallet",
          title = Locales.received_money,
          message = (Locales.sent_you_money):format(myName, Config.formatting.currencySymbol, data.amount)
        })
      end)
      return { balance = finalBalance, transaction = tx }
    end
  elseif data.method == 'phoneNumber' then
    local result = transfer.phoneNumber(playerObj, data.target, data.amount)
    if result then
      local tx = storeTransaction(myName, myIdentifier, result.name, result.identifier, data.amount)


      CreateThread(function()
        local imei = Phones:getImeiFromPhoneNumber(data.target)
        if not imei then return end
        Phones:pushNotifyViaImei(imei, {
          app = "wallet",
          title = Locales.received_money,
          message = (Locales.sent_you_money):format(myName, Config.formatting.currencySymbol, data.amount)
        })
      end)

      return { balance = finalBalance, transaction = tx }
    end
  end
  return false
end)


RegisterServerCallback("wallet:getInvoices", function(source)
  local playerObj = Utils:getPlayerObject(source)
  local identifier = playerObj and Utils:getCharacterId(playerObj)
  if not identifier then return false end

  local invoices = MySQL.rawExecute.await(
    "SELECT * FROM okokbilling WHERE receiver_identifier = ? AND status = 'unpaid'", { identifier })

  return { invoices = invoices, vatRate = exports["okokBilling"]:getConfig()?.VATPercentage or 0 }
end)

RegisterServerCallback("wallet:payInvoice", function(source, refId)
  if not refId then return end

  local invoice = MySQL.prepare.await("SELECT * FROM okokbilling WHERE ref_id = ? AND status = 'unpaid' LIMIT 1",
    { refId })
  if not invoice then return end

  local playerObj = Utils:getPlayerObject(source)
  if not playerObj then return false end
  local balance = Utils:getAccountMoney(ACCOUNT_NAME, playerObj)
  local name = Utils:getCharacterName(playerObj)
  local identifier = Utils:getCharacterId(playerObj)

  if balance < invoice.invoice_value then return false end

  local result = exports["okokBilling"]:payInvoice(invoice)

  if result then
    local total = invoice.invoice_value
    local tx = storeTransaction(name, identifier, invoice.author_name, invoice.author_identifier, total)

    return { balance = balance - total, transaction = tx }
  end

  return false
end)


--[[ QBCore and QBox ]]

local function balanceChangeNotify(source, amount, add)
  local title = Locales.balance_updated
  local text = amount
  if add then
    text = ("%s: %s%s"):format(Locales.received, Config.formatting.currencySymbol, amount)
  else
    text = ("%s: %s%s"):format(Locales.sent, Config.formatting.currencySymbol, amount)
  end

  local imei = Phones:getEquippedImei(source)
  if not imei then return end
  Phones:pushNotifyViaImei(imei, {
    app = "wallet",
    title = title,
    message = text
  })
end

if Config.Wallet.balance_change_notification then
  ---@param operation "set" | "add" | "remove"
  AddEventHandler("QBCore:Server:OnMoneyChange", function(source, account, amount, operation, reason)
    if amount == 0 or account ~= ACCOUNT_NAME then return end
    balanceChangeNotify(source, amount, operation == "add")
  end)


  --[[ ESX ]]

  AddEventHandler("esx:setAccountMoney", function(source, account, amount, reason)
    if amount == 0 or account ~= ACCOUNT_NAME then return end
  end)
  AddEventHandler("esx:addAccountMoney", function(source, account, amount, reason)
    if amount == 0 or account ~= ACCOUNT_NAME then return end
    balanceChangeNotify(source, amount, true)
  end)
  AddEventHandler("esx:removeAccountMoney", function(source, account, amount, reason)
    if amount == 0 or account ~= ACCOUNT_NAME then return end
    balanceChangeNotify(amount, false)
  end)
end
