local _G = GLOBAL

-- This makes the giver learn the dish stats on the Cookbook.
local function AntlionPostInit(inst)
	local _OnGivenItem

	local function OnGivenItem(inst, giver, item, ...)
		if item.prefab == "lazydessert" then
			if giver ~= nil and giver:IsValid() then
				giver:PushEvent("learncookbookstats", item.prefab)
			end
		end

		return _OnGivenItem(inst, giver, item, ...)
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.trader ~= nil then
		_OnGivenItem = inst.components.trader.onaccept
		inst.components.trader.onaccept = OnGivenItem
	end
end

AddPrefabPostInit("antlion", AntlionPostInit)