local _G = GLOBAL

local function SaddleShadowFXPostInit(inst)
	local CS =
	{
		r = 0.4,
		g = 0.4,
		b = 0.6,
		a = 0.5,
	}

	local function StealthMultColour(inst)
		if inst.fx then
			for i, fx in ipairs(inst.fx) do
				if fx.AnimState then
					fx.AnimState:SetMultColour(CS.r, CS.g, CS.b, CS.a)
				end
			end
		end
	end

	local function DefaultMultColour(inst)
		if inst.fx then
			for i, fx in ipairs(inst.fx) do
				if fx.AnimState then
					fx.AnimState:SetMultColour(1, 1, 1, 1)
				end
			end
		end
	end

	local function SaddleStealth(inst)
		local parent = inst.entity:GetParent()

		if parent:HasTag("mimicmosa_stealthed") then
			StealthMultColour(inst)
		else
			DefaultMultColour(inst)
		end
	end

	inst:DoPeriodicTask(0, SaddleStealth)
end

AddPrefabPostInit("saddle_shadow_fx", SaddleShadowFXPostInit)