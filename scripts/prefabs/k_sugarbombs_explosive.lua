local assets =
{
    Asset("ANIM", "anim/sugarbombs.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"explode_small",
	"spoiled_food",
}

local function OnIgniteFn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
    DefaultBurnFn(inst)
end

local function OnExtinguishFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    DefaultExtinguishFn(inst)
end

local function OnExplodeFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function OnPutInInv(inst, owner)
    if owner.prefab == "mole" then
        inst.components.explosive:OnBurnt()
    end
end

local function OnEaten(inst, eater)
	-- Incredible! An astonishing 10% chance of being blown up.
	if math.random() < .10 then
		inst.components.explosive:OnBurnt()
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", 0.65)
	
	inst.AnimState:SetScale(1.1, 1.1, 1.1)

    inst.AnimState:SetBank("sugarbombs")
    inst.AnimState:SetBuild("sugarbombs")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("preparedfood")
	inst:AddTag("preparedfood_hof")
	inst:AddTag("molebait")
    inst:AddTag("explosive")
	
	inst.pickupsound = "grainy"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SUGARBOMBS"

    inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive.explosivedamage = TUNING.SUGARBOMBS_DAMAGE

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "sugarbombs_explosive"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("edible")
    inst.components.edible.healthvalue = 5
	inst.components.edible.hungervalue = 20
	inst.components.edible.sanityvalue = 15
	inst.components.edible.foodtype = FOODTYPE.GOODIES
	inst.components.edible:SetOnEatenFn(OnEaten)
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(9000000)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	MakeSmallBurnable(inst, 3 + math.random() * 3)
	inst.components.burnable:SetOnBurntFn(nil)
    inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguishFn)
    MakeSmallPropagator(inst)
	
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("sugarbombs_explosive", fn, assets, prefabs)