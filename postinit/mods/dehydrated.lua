local _G      = GLOBAL
local require = _G.require

-- This is stupid as fuck. Unfortunately Dehydrated Mod is not updated regularly
-- and their patches for HoF are not compatible anymore, I guess...
-- They are overriding some of the ingredients (I did too but fixed now :P) and making recipes unable to cook.
-- Current workaround is to re-apply these stuff if their mod is enabled.
if TUNING.HOF_IS_DHD_ENABLED then
	print("Heap of Foods Mod - WARNING: Dehydrated Mod is enabled!")
	print("Heap of Foods Mod - WARNING: Dehydrated Mod has incompatible patches for this mod.")

	-- Unfortunately this doesn't update properly for Craft Pot Mods and still shows
	-- incorrect recipes despite them being valid in the server-side.
	-- The real fix lies on their side by correcting the ingredient tags, for now this will do.
	AddSimPostInit(function()
		print("Heap of Foods Mod - WARNING: Dehydrated Mod is overriding key ingredients.")
		print("Heap of Foods Mod - WARNING: Trying to re-apply patches...")

		local cooking = require("cooking")

		local patches =
		{
			foliage          = "foliage",
			succulent_picked = "succulent",
			firenettles      = "fireweed",
			tillweed         = "tillweed",
			forgetmelots     = "forgetweed",
		}

		local success = true

		for prefab, tag in pairs(patches) do
			local ingredient = cooking.ingredients[prefab]

			if ingredient and ingredient.tags then
				ingredient.tags[tag] = 1
			else
				success = false
				print(string.format("Heap of Foods Mod - WARNING: Failed to patch %s", prefab))
			end
		end

		print(success and "Heap of Foods Mod - Successfully re-applied all patches for Dehydrated Mod."
		or "Heap of Foods Mod - WARNING: Failed to re-apply patches for Dehydrated Mod!")
	end)
end