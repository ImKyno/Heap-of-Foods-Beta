-- Common Dependencies.
local _G       = GLOBAL
local require  = _G.require

-- Display Stand.
_G.kyno_itemshowcaser_init_fn = function(inst, build_name)
	_G.basic_init_fn(inst, build_name, "kyno_itemshowcaser")
	
	inst.AnimState:SetBank(build_name)
end

_G.kyno_itemshowcaser_clear_fn = function(inst)
	_G.basic_clear_fn(inst, "kyno_itemshowcaser")
	
	inst.AnimState:SetBank("kyno_itemshowcaser")
end