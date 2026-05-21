local _G = GLOBAL

-- Setup the container for the Potato Sack.
local function PotatoSackPostInit(inst)
	local function OnHammered(inst, worker)
		if inst:HasTag("fire") and inst.components.burnable ~= nil then
			inst.components.burnable:Extinguish()
		end

		if inst.components.lootdropper ~= nil then
			inst.components.lootdropper:DropLoot()
		end

		if inst.components.container ~= nil then
			inst.components.container:DropEverything()
		end

		_G.SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())

		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")

		inst:Remove()
	end

	local function OnOpen(inst)
		if not inst:HasTag("burnt") then
			inst.SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
		end
	end

	local function OnClose(inst, doer)
		if not inst:HasTag("burnt") then
			inst.SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
		end
	end

	local function OnHit(inst, worker)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("hit")
			inst.AnimState:PushAnimation("idle_full")

			if inst.components.container ~= nil then
				inst.components.container:DropEverything()
				inst.components.container:Close()
			end
		end
	end

	local function OnPickup(inst)
		if inst.components.container ~= nil and inst.components.container:IsOpen() then
			inst.components.container:Close()
		end
	end

	if not _G.TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("potatosack")
		end

		return inst
	end

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)

	if inst.components.workable ~= nil then
		inst.components.workable:SetOnFinishCallback(OnHammered)
		inst.components.workable:SetOnWorkCallback(OnHit)
	end

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("potatosack")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	inst:ListenForEvent("onputininventory", OnPickup)
end

AddPrefabPostInit("potatosack", PotatoSackPostInit)

-- Items that can go inside the Potato Sack.
local POTATOSACK_ITEMS =
{
	"potato",
	"potato_cooked",

	"sweetpotato",
	"sweetpotato_cooked",

	"kyno_sweetpotato",
	"kyno_sweetpotato_cooked",

	"potato_seeds",
	"sweetpotato_seeds",
	"kyno_sweetpotato_seeds",
}

local function PotatoSackItemsPostInit(inst)
	inst:AddTag("potatosack_valid")
end

for k, v in pairs(POTATOSACK_ITEMS) do
	AddPrefabPostInit(v, PotatoSackItemsPostInit)
end