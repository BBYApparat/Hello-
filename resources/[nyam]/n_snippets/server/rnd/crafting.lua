CreateThread(function()
	for craftingTableId, table in pairs(Config.Crafting) do
		local jobs = table.jobs
		Config.Crafting[craftingTableId].jobs = {}

		if table.jobGrades and type(table.jobGrades) == "table" then
			for jobIndex, job in pairs(jobs) do
				for gradeIndex, grade in pairs(table.jobGrades) do
					if not Config.Crafting[craftingTableId].jobs[job] then Config.Crafting[craftingTableId].jobs[job] = {} end
					Config.Crafting[craftingTableId].jobs[job][grade] = true
				end 
			end
			Config.Crafting[craftingTableId].jobGrades = "locked"
		elseif table.jobGrades and table.jobGrades == "all" then
			for jobIndex, job in pairs(jobs) do
				Config.Crafting[craftingTableId].jobs[job] = true
			end
			Config.Crafting[craftingTableId].jobGrades = "open"
		else
			Config.Crafting[craftingTableId].jobs = nil
		end

		exports.ox_inventory:createCraftingBench(craftingTableId, {items = table.items})
	end
end)

lib.callback.register('n_snippets:getCrafting', function(source)
    return Config.Crafting
end)