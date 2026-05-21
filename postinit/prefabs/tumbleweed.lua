local _G = GLOBAL

-- Include the Brewing Recipe Card to the Tumbleweed.
-- I'm not sure if this is the best way to do it, I'll change it later, maybe...
local function TumbleweedPostInit(inst)
	local function OnInitBrewingCard(inst)
		if math.random() < TUNING.KYNO_BREWINGRECIPECARD_CHANCE then
			table.insert(inst.loot, "kyno_brewingrecipecard")
			table.insert(inst.lootaggro, false)
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:DoTaskInTime(0, OnInitBrewingCard)
end

AddPrefabPostInit("tumbleweed", TumbleweedPostInit)