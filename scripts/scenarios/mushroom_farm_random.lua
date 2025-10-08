local MUSHROOMS = 
{ 
	"red_cap", 
	"green_cap", 
	"blue_cap" 
}

local function DoMushroomOverrideSymbol(inst, product)
    inst.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..(string.split(product, "_")[1]).."_build", "swap_mushroom")
end

local function OnCreate(inst, scenariorunner)
	if inst.components.trader.enabled == false then
		return
	end

	local mushroom_prefab = MUSHROOMS[math.random(#MUSHROOMS)]
	local max_produce = 4
		
	inst.components.harvestable:SetProduct(mushroom_prefab, max_produce)
	inst.components.harvestable:SetGrowTime(1)
	inst.components.harvestable:Grow()
	
	-- inst.components.harvestable.produce = max_produce
	
	DoMushroomOverrideSymbol(inst, mushroom_prefab)
end

return 
{
	OnCreate = OnCreate,
}