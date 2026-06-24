require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_dailyrecipe_sign.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"collapse_small",
}

local function OnHammered(inst, worker)
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:DropLoot()
	end

	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")

	inst:Remove()
end

local function OnHit(inst)
	inst.AnimState:PlayAnimation("hit")
end

local function OnDrawn(inst, image, src, atlas, bgimage, bgatlas)
	if image ~= nil then
		local build = atlas or GetInventoryItemAtlas(image..".tex")
		local symbol = image..".tex"

		inst.AnimState:OverrideSymbol("recipe", build, symbol)

		if bgimage ~= nil then -- Spiced Food.
			inst.AnimState:OverrideSymbol("recipebg", bgatlas or GetInventoryItemAtlas(bgimage..".tex"), bgimage..".tex")
		end

		inst._imagename:set(src ~= nil and (src.drawnameoverride or src:GetBasicDisplayName()) or "")
	else
		inst.AnimState:OverrideSymbol("recipe", "kyno_dailyrecipe_sign", "recipe")
		inst._imagename:set("")
	end

	inst.SoundEmitter:PlaySound("dontstarve/common/together/draw")
end

local function GetDescription(inst, viewer)
	local recipe = inst._imagename:value() or "Unknown"
	local CHARACTER = STRINGS.CHARACTERS[string.upper(viewer.prefab)]
	local DESCRIBE = CHARACTER and CHARACTER.DESCRIBE.KYNO_DAILYRECIPE_SIGN
	or STRINGS.CHARACTERS.GENERIC.DESCRIBE.KYNO_DAILYRECIPE_SIGN

	if recipe ~= nil then
		return string.format(DESCRIBE.GENERIC, recipe)
	end

	return DESCRIBE.NONE
end

local function OnSave(inst, data)
	data.imagename = inst.components.drawable:GetImage() ~= nil
	and #inst._imagename:value() > 0
	and inst._imagename:value() ~= STRINGS.NAMES[string.upper(inst.components.drawable:GetImage())]
	and inst._imagename:value() or nil
end

local function OnLoad(inst, data)
	inst._imagename:set(inst.components.drawable:GetImage() ~= nil and (
	data ~= nil and data.imagename ~= nil and #data.imagename > 0 and data.imagename
	or STRINGS.NAMES[string.upper(inst.components.drawable:GetImage())]) or "")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_dailyrecipe_sign.tex")

	MakeObstaclePhysics(inst, .4)

	inst.AnimState:SetBank("kyno_dailyrecipe_sign")
	inst.AnimState:SetBuild("kyno_dailyrecipe_sign")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("card")

	inst:AddTag("drawable")
	inst:AddTag("structure")
	inst:AddTag("dailyrecipe_sign_decor")

	inst._imagename = net_string(inst.GUID, "dailyrecipe_sign._imagename")

	MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.descriptionfn = GetDescription

	inst:AddComponent("drawable")
	inst.components.drawable:SetOnDrawnFn(OnDrawn)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(3)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	MakeSnowCovered(inst)
	SetLunarHailBuildupAmountSmall(inst)

	return inst
end

return Prefab("kyno_dailyrecipe_sign_decor", fn, assets, prefabs)