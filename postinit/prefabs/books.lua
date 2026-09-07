local _G = GLOBAL

local function BookBirdsPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.book ~= nil then
		local _OnRead = inst.components.book.onread

		inst.components.book.onread = function(inst, reader, ...)
			if not _G.TheWorld.state.isnight then
				if _OnRead ~= nil then
					_OnRead(inst, reader, ...)
				end
			else
				local nightbirdspawner = _G.TheWorld.components.nightbirdspawner

				if nightbirdspawner == nil then
					return false
				end

				local pt = reader:GetPosition()

				if _G.TheWorld.Map:IsPointInWagPunkArenaAndBarrierIsUp(pt.x, pt.y, pt.z) then
					return false, "BIRDSBLOCKED"
				end

				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 10, { "magicalbird" })

				if #ents > 30 then
					return false, "WAYTOOMANYBIRDS"
				elseif #ents > 20 then
					return false, "TOOMANYBIRDS"
				end

				local num = math.random(10, 20)

				if _G.TheWorld.state.islunarhailing then
					local function SpawnCorpse()
						local corpse = nightbirdspawner:SpawnCorpseForPlayer(reader)

						if corpse ~= nil then
							corpse:StartFadeTimer(GetRandomWithVariance(5, 2))
						end
					end

					for k = 1, num do
						inst:DoTaskInTime(0.34 + 0.33 * math.random() * k, SpawnCorpse)
					end

					inst.components.book:DoReadPenalties(reader)
					return false, "DEADBIRDS"
				end

				if #ents <= 10 then
					num = num + 10
				end

				local post_hail_mult = nightbirdspawner:GetPostHailEasingMult()

				if post_hail_mult < 1 then
					num = math.ceil(num * post_hail_mult)
				end

				local success = false
				local delay = 0

				for k = 1, num do
					local pos = nightbirdspawner:GetSpawnPoint(pt)

					if pos ~= nil then
						local bird = nightbirdspawner:SpawnBird(pos, true)

						if bird ~= nil then
							bird:AddTag("magicalbird")
							bird.sg:GoToState("delay_glide", delay)

							delay = delay + .034 + .033 * math.random()
							success = true
						end
					end
				end

				return success
			end
		end
	end
end

AddPrefabPostInit("book_birds", BookBirdsPostInit)