local rock1_assets =
{
    Asset("ANIM", "anim/rock.zip"),
    Asset("MINIMAP_IMAGE", "rock"),
}

local rock2_assets =
{
    Asset("ANIM", "anim/rock2.zip"),
    Asset("MINIMAP_IMAGE", "rock_gold"),
}

local rock_flintless_assets =
{
    Asset("ANIM", "anim/rock_flintless.zip"),
    Asset("MINIMAP_IMAGE", "rock"),
}

local prefabs =
{
    "rocks",
    "nitre",
    "flint",
    "goldnugget",
    "moonrocknugget",
    "moonglass",
    "moonrockseed",
    "rock_break_fx",
    "collapse_small",
}

SetSharedLootTable("kyno_serenityisland_rock1",
{
    {"rocks",  1.00},
    {"rocks",  1.00},
    {"rocks",  1.00},
    {"nitre",  1.00},
    {"flint",  1.00},
    {"nitre",  0.25},
    {"flint",  0.60},
})

SetSharedLootTable("kyno_serenityisland_rock2",
{
    {"rocks",       1.00},
    {"rocks",       1.00},
    {"rocks",       1.00},
    {"goldnugget",  1.00},
    {"flint",       1.00},
    {"goldnugget",  0.25},
    {"flint",       0.60},
})

SetSharedLootTable("kyno_serenityisland_rock3",
{
    {"rocks",   1.0},
    {"rocks",   1.0},
    {"rocks",   1.0},
    {"rocks",   1.0},
    {"rocks",   0.6},
})

local function OnWork(inst, worker, workleft)
    if workleft <= 0 then
        local pt = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
        inst.components.lootdropper:DropLoot(pt)

        if inst.showCloudFXwhenRemoved then
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end

		if not inst.doNotRemoveOnWorkDone then
	        inst:Remove()
		end
    else
        inst.AnimState:PlayAnimation(
            (workleft < TUNING.ROCKS_MINE / 3 and "low") or
            (workleft < TUNING.ROCKS_MINE * 2 / 3 and "med") or
            "full"
        )
    end
end

local function baserock_fn(bank, build, anim, icon, tag, multcolour)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    if icon ~= nil then
        inst.MiniMapEntity:SetIcon(icon)
    end

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)

    if type(anim) == "table" then
        for i, v in ipairs(anim) do
            if i == 1 then
                inst.AnimState:PlayAnimation(v)
            else
                inst.AnimState:PushAnimation(v, false)
            end
        end
    else
        inst.AnimState:PlayAnimation(anim)
    end

    MakeSnowCoveredPristine(inst)

    inst:AddTag("boulder")
    if tag ~= nil then
        inst:AddTag(tag)
    end

	-- inst:SetPrefabNameOverride("rock1")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
    inst.components.workable:SetOnWorkCallback(OnWork)

    if multcolour == nil or (0 <= multcolour and multcolour < 1) then
        if multcolour == nil then
            multcolour = 0.5
        end

        local color = multcolour + math.random() * (1.0 - multcolour)
        inst.AnimState:SetMultColour(color, color, color, 1)
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "ROCK"
    
	MakeSnowCovered(inst)
    MakeHauntableWork(inst)

    return inst
end

local function rock1_fn()
    local inst = baserock_fn("rock", "rock", "full", "rock.png")

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inspectable.nameoverride = "ROCK"
    inst.components.lootdropper:SetChanceLootTable("kyno_serenityisland_rock1")

    return inst
end

local function rock2_fn()
    local inst = baserock_fn("rock2", "rock2", "full", "rock_gold.png")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.inspectable.nameoverride = "ROCK"
    inst.components.lootdropper:SetChanceLootTable("kyno_serenityisland_rock2")

    return inst
end

local function rock_flintless_fn()
    local inst = baserock_fn("rock_flintless", "rock_flintless", "full", "rock_flintless.png")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.inspectable.nameoverride = "ROCK"
    inst.components.lootdropper:SetChanceLootTable("kyno_serenityisland_rock3")

    return inst
end

local function rock_flintless_med()
    local inst = baserock_fn("rock_flintless", "rock_flintless", "med", "rock_flintless.png")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.inspectable.nameoverride = "ROCK"
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE_MED)
    inst.components.lootdropper:SetChanceLootTable("kyno_serenityisland_rock3")

    return inst
end

local function rock_flintless_low()
    local inst = baserock_fn("rock_flintless", "rock_flintless", "low", "rock_flintless.png")

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inspectable.nameoverride = "ROCK"
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE_LOW)
    inst.components.lootdropper:SetChanceLootTable("kyno_serenityisland_rock3")

    return inst
end

return Prefab("kyno_serenityisland_rock1", rock1_fn, rock1_assets, prefabs),
Prefab("kyno_serenityisland_rock2", rock2_fn, rock2_assets, prefabs),
Prefab("kyno_serenityisland_rock3", rock_flintless_fn, rock_flintless_assets, prefabs),
Prefab("kyno_serenityisland_rock3_med", rock_flintless_med, rock_flintless_assets, prefabs),
Prefab("kyno_serenityisland_rock3_low", rock_flintless_low, rock_flintless_assets, prefabs)
