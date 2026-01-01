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
		
		inst:AddTag("FX")
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			inst.OnEntityReplicated = function(inst) -- To hook up highlightchildren on clients.
				local parent = inst.entity:GetParent()
				
				if parent ~= nil and parent.prefab == "kyno_fishfarmplot" then
					parent.highlightchildren = parent.highlightchildren or {}
					table.insert(parent.highlightchildren, inst)
				end
			end

			return inst
		end
		
		inst.persists = false

        return inst
    end
end

local function item(name, bankname, buildname, animname, tag)
	return Prefab(name, makefn(bankname, buildname, animname, tag), makeassetlist(bankname, buildname))
end

return item("kyno_fishfarmplot_rock1", "farm_decor", "farm_decor", "1"),
item("kyno_fishfarmplot_rock2", "farm_decor", "farm_decor", "2"),
item("kyno_fishfarmplot_rock3", "farm_decor", "farm_decor", "8"),
item("kyno_fishfarmplot_plant", "marsh_plant", "marsh_plant", "idle")