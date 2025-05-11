ESX = exports.es_extended:getSharedObject()

function DumpTable(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

exports("DumpTable", DumpTable)

function Shuffly(tbl)
	local size = #tbl
	for i = size, 2, -1 do
		-- Get a random index between 1 and i
		local j = math.random(1, i)
		-- Swap the elements at indices i and j
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end

exports("Shuffly", Shuffly)

function getLastDayOfMonth(year, month)
    return os.date("*t", os.time({year = year, month = month + 1, day = 0})).day
end

exports("getLastDayOfMonth", getLastDayOfMonth)

-- AddEventHandler("esx:setAccountMoney", function(source, accountName, money, reason)
-- 	if accountName == "bank" then
-- 		exports["lb-phone"]:AddTransaction(exports["lb-phone"]:GetEquippedPhoneNumber(source), money, reason)
-- 	end
-- end)

-- AddEventHandler("esx:addAccountMoney", function(source, accountName, money, reason)
-- 	if accountName == "bank" then
-- 		exports["lb-phone"]:AddTransaction(exports["lb-phone"]:GetEquippedPhoneNumber(source), money, reason)
-- 	end
-- end)

-- AddEventHandler("esx:removeAccountMoney", function(source, accountName, money, reason)
-- 	if accountName == "bank" then
-- 		exports["lb-phone"]:AddTransaction(exports["lb-phone"]:GetEquippedPhoneNumber(source), math.abs(money)*-1, reason)
-- 	end
-- end)
