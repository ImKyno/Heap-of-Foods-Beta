local function MakeCoin(data)
	local assets = 
	{
		Asset("ANIM", "anim/kyno_pigcoin.zip"),
		
		Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
		Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
		Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	}

	local function OnCoinTossed(inst)
		inst:DoTaskInTime(0.5, function()
			local bounce = math.random() < 0.50 and "bounce1" or "bounce1"

			inst.AnimState:PlayAnimation(bounce)
			inst.AnimState:PushAnimation("idle", true)

			inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/coins/drop")
		end)
	end

	local function OnDropped(inst)
		inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/coins/drop")
	end

	local function fn()
		local inst = CreateEntity()
	
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
	
		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)
		
		inst.AnimState:SetScale(data.scale or 1, data.scale or 1, data.scale or 1)
	
		inst.AnimState:SetBank("kyno_pigcoin")
		inst.AnimState:SetBuild("kyno_pigcoin")
		inst.AnimState:PlayAnimation("idle", true)
		inst.AnimState:OverrideSymbol("coin01", "kyno_pigcoin", data.type)

		inst:AddTag("molebait")
		inst:AddTag("pigcoin")
	
		if data.tags ~= nil then
			for i, v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end
		
		inst.pickupsound = "gem"
	
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
	
		inst:AddComponent("bait")
		inst:AddComponent("inspectable")
		inst:AddComponent("tradable")
	
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_PELLET -- 120

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
		inst.components.inventoryitem.imagename = data.inventoryimage

		inst:ListenForEvent("oncointossed", OnCoinTossed)
		inst:ListenForEvent("ondropped", OnDropped)

		MakeHauntableLaunchAndSmash(inst)
	
		return inst
	end
	
	return Prefab("kyno_"..data.name, fn, assets)
end

local coins =
{
	-- Koin.
	{
		name            = "pigcoin1",
		type            = "coin01",
		inventoryimage  = "kyno_pigcoin1",
	},

	-- Emerald Medallion.
	{
		name            = "pigcoin2",
		type            = "coin02",
		inventoryimage  = "kyno_pigcoin2",
	},

	-- Cerulean Mark.
	{
		name            = "pigcoin3",
		type            = "coin03",
		inventoryimage  = "kyno_pigcoin3",
	},
}

local prefabs = {}

for i, v in ipairs(coins) do
	table.insert(prefabs, MakeCoin(v))
end

return unpack(prefabs)