local assets =
{
	Asset("ANIM", "anim/spices.zip"),
	Asset("ANIM", "anim/kyno_spices.zip"),
}

local bankbuild = "kyno_spices"
local atlasbuild = "images/inventoryimages/hof_inventoryimages"

local function MakeSpice(name, spicedata)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst, "med", nil, spicedata.floatable or 0.7)

        inst.AnimState:SetBank("kyno_spices")
        inst.AnimState:SetBuild("kyno_spices")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_spice", spicedata.animname or "spices", spicedata.imagename or name)

        inst:AddTag("spice")
        inst:AddTag("spice_hof")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		
        inst:AddComponent("inspectable")

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = spicedata.imageatlas..".xml"
        inst.components.inventoryitem:ChangeImageName(spicedata.imagename)

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

local HOF_SPICES   = 
{
	SPICE_CURE     = 
	{
		animname   = bankbuild,
		imageatlas = atlasbuild,
		imagename  = "spice_cure", 
		floatable  = 0.85,
	},
	
	SPICE_COLD     =
	{
		animname   = bankbuild,
		imageatlas = atlasbuild,
		imagename  = "spice_cold",
		floatable  = 0.85,
	},
	
	SPICE_FIRE     =
	{
		animname   = bankbuild,
		imageatlas = atlasbuild,
		imagename  = "spice_fire",
		floatable  = 0.85,
	},
	
	SPICE_FED      =
	{
		animname   = bankbuild,
		imageatlas = atlasbuild,
		imagename  = "spice_fed",
		floatable  = 0.85,
	},
	
	SPICE_MIND     =
	{
		animname   = bankbuild,
		imageatlas = atlasbuild,
		imagename  = "spice_mind",
		floatable  = 0.85,
	},
	
	--[[
	SPICE_MOON     =
	{
		animname   = bankbuild,
		imageatlas = atlasbuild,
		imagename  = "spice_moon",
		floatable  = 0.85,
	},
	]]--
}

local prefs = {}

for k, v in pairs(HOF_SPICES) do
	table.insert(prefs, MakeSpice(string.lower(k), v))
end

return unpack(prefs)