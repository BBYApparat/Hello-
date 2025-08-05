---@class CexAccount
---@field id number
---@field char_id string
---@field balance number
---@field crypto table<string, number>[] -- key: crypto name, value: amount
---@field address string

local function createRandomAddress()
      local address = '0x'
      for i = 1, 40 do
            address = address .. string.char(math.random(97, 102))
      end
      return address
end

---@class CexUtils
local CexUtils = {}

---@param char_id string
function CexUtils.createAccount(char_id)
      local address = createRandomAddress()

      MySQL.prepare.await("INSERT INTO luxucex_accounts (char_id, balance, crypto, address) VALUES (?, ?, ?, ?)",
            { char_id, 0, '{}', address })
end

---@param char_id string
function CexUtils.getBalance(char_id)
      local result = MySQL.prepare.await("SELECT balance FROM luxucex_accounts WHERE char_id = ? LIMIT 1", { char_id })
      return result --[[ @as number? ]]
end

---@param char_id string
function CexUtils.getCrypto(char_id)
      local result = MySQL.prepare.await("SELECT crypto FROM luxucex_accounts WHERE char_id = ? LIMIT 1", { char_id }) --[[ @as string ]]
      return result and json.decode(result) --[[ @as table<string, number> ]] or false
end

---@param char_id string
function CexUtils.getAccount(char_id)
      local result = MySQL.prepare.await("SELECT * FROM luxucex_accounts WHERE char_id = ? LIMIT 1", { char_id })
      if result then
            result.crypto = json.decode(result.crypto)
      end
      return result --[[ @as CexAccount? ]]
end

function CexUtils.updateAddress(char_id, address)
      MySQL.prepare.await("UPDATE luxucex_accounts SET address = ? WHERE char_id = ?", { address, char_id })
end

---@param char_id string
---@param balance number
function CexUtils.updateBalance(char_id, balance)
      MySQL.prepare.await("UPDATE luxucex_accounts SET balance = ? WHERE char_id = ?", { balance, char_id })
end

---@param char_id string
---@param crypto table<string, number>
function CexUtils.updateCrypto(char_id, crypto)
      MySQL.prepare.await("UPDATE luxucex_accounts SET crypto = ? WHERE char_id = ?", { json.encode(crypto), char_id })
end

return CexUtils
