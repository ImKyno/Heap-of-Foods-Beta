local function makeassetlist(bankname, buildname)
	return 
	{
		Asset("ANIM", "anim/"..buildname..".zip"),
		Asset("ANIM", "anim/"..bankname..".zip"),
	}
end

local function makefn(bankname, buildname, animname, tag)
	return function()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		inst.AnimState:SetBank(bankname)
		inst.AnimState:SetBuild(buildname)
		inst.AnimState:PlayAnimation(animname)
		
        if tag ~= nil then
            inst:AddTag(tag)
        end
		
		inst:SetPrefabNameOverride("ROCKS")
        
		inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

		inst:AddComponent("inspectable")

        return inst
    end
end

local function item(name, bankname, buildname, animname, tag)
	return Prefab(name, makefn(bankname, buildname, animname, tag), makeassetlist(bankname, buildname))
end

return item("kyno_fishfarmplot_rock1", "farm_decor", "farm_decor", "1"),
item("kyno_fishfarmplot_rock2", "farm_decor", "farm_decor", "2"),
item("kyno_fishfarmplot_rock3", "farm_decor", "farm_decor", "8")