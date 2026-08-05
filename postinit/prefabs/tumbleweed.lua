local _G = GLOBAL

local function TumbleweedPostInit(inst)
	local function OnInitBrewingCard(inst)
		if math.random() < TUNING.KYNO_BREWINGRECIPECARD_CHANCE then
			inst.loot = inst.loot or {}
			table.insert(inst.loot, "kyno_brewingrecipecard")

			if inst.lootaggro ~= nil then
				table.insert(inst.lootaggro, false)
			end
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:DoTaskInTime(0, OnInitBrewingCard)
end

AddPrefabPostInit("tumbleweed", TumbleweedPostInit)