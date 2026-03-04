-- This file is used to store and load stuff that doesn't belong anywhere or doesn't have a proper place.
-- Also any retard and useless stuff I want to add too. :)
require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_turfs_hof.zip"),
	Asset("ANIM", "anim/kyno_sisturn_build.zip"),
	Asset("ANIM", "anim/kyno_tree_rock_swaps.zip"),
	Asset("ANIM", "anim/kyno_farmplot_scrapbook.zip"),
	
	-- Everything else.
	Asset("ANIM", "anim/kyno_gloomypeach.zip"),
}

local prefabs = 
{
	"ash",
}

STRINGS.NAMES.KYNO_GLOOMYPEACH = "Gloomy's Poorly Drawn Peach"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KYNO_GLOOMYPEACH = "Mod author I drew this peach can u add it into game"

-- Blank function to crash the game.
local function OnEaten(inst, eater)
	if eater:HasTag("player") then
		eater:DoTaskInTime(0, CrashThisRetard)
	end
end

local function peachfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("kyno_gloomypeach")
	inst.AnimState:SetBuild("kyno_gloomypeach")
	inst.AnimState:PlayAnimation("IMSCREAMING")

	inst.pickupsound = "vegetation_firm"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_goldenapple" -- Not wasting an icon slot for this...
	inst.components.inventoryitem:SetSinks(true)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM
	
	inst:AddComponent("edible")
	inst.components.edible:SetOnEatenFn(OnEaten)
    inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = 0
	inst.components.edible.sanityvalue = 0
	inst.components.edible.foodtype = FOODTYPE.GOODIES

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndSmash(inst)

	return inst
end

return Prefab("kyno_gloomypeach", peachfn, assets, prefabs)