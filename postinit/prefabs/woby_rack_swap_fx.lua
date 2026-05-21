local _G = GLOBAL

local function WobyRackSwapFXPostInit(inst)
	local CS =
	{
		r = 0.4,
		g = 0.4,
		b = 0.6,
		a = 0.5,
	}

	local function ApplyColourToSlot(slotfx, r, g, b, a)
		if slotfx and slotfx.AnimState then
			slotfx.AnimState:SetMultColour(r, g, b, a)
			slotfx.AnimState:SetSymbolMultColour("rope", r, g, b, a)
			slotfx.AnimState:SetSymbolMultColour("rope_empty", r, g, b, a)
			slotfx.AnimState:SetSymbolMultColour("swap_dried", r, g, b, a)
		end
	end

	local function StealthMultColour(inst)
		inst.AnimState:SetMultColour(CS.r, CS.g, CS.b, CS.a)
		inst.AnimState:SetSymbolMultColour("rack", CS.r, CS.g, CS.b, CS.a)

		if inst.slots ~= nil then
			for _, v in ipairs(inst.slots) do
				if v.fx ~= nil then
					ApplyColourToSlot(v.fx, CS.r, CS.g, CS.b, CS.a)
				end
			end
		end
	end

	local function DefaultMultColour(inst)
		inst.AnimState:SetMultColour(1, 1, 1, 1)
		inst.AnimState:SetSymbolMultColour("rack", 1, 1, 1, 1)

		if inst.slots ~= nil then
			for _, v in ipairs(inst.slots) do
				if v.fx ~= nil then
					ApplyColourToSlot(v.fx, 1, 1, 1, 1)
				end
			end
		end
	end

	local function RackStealth(inst)
		local parent = inst.entity:GetParent()

		if parent and parent:HasTag("mimicmosa_stealthed") then
			StealthMultColour(inst)
		else
			DefaultMultColour(inst)
		end
	end

	inst:DoPeriodicTask(0, RackStealth)
end

AddPrefabPostInit("woby_rack_swap_fx", WobyRackSwapFXPostInit)