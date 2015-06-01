BASE_TIME_UNTIL_ATTACK = 10 -- 10 minutes
TIME_BETWEEN_SPAWNS = 3 -- How much time between each 4 mob pack spawn
BASE_SPAWN_SIZE = 10 -- Minimum amount of demons spawned, for each player
MAX_SPAWN_TIER = 6 -- From demon_waves.kv

-- Test commands
Convars:RegisterCommand( "SpawnDemonWave", function(p, tier, size) return SpawnDemonWave(tonumber(tier), tonumber(size)) end, "Test a Demon Wave", FCVAR_CHEAT )

-- Called after everyone finished picking and loading their heroes.
-- Time until city attack = 10 minutes + math.floor(Average Party Level/10) * 30 seconds.
function StartFirstAttackTimer()
	print("Starting First Attack Timer")
	local levels = GetPlayersPowerLevel()	

	GameRules.AveragePartyLevel = math.floor(levels / GameRules.PLAYER_COUNT)
	local party_tier = math.ceil(GameRules.AveragePartyLevel/10)
	local time_until_attack = BASE_TIME_UNTIL_ATTACK + party_tier * 30

	FireGameEvent('cgm_timer_display', { timerMsg = "Attack in", timerSeconds = time_until_attack, timerWarning = 0, timerEnd = 0, timerPosition = 2})

	Timers:CreateTimer(time_until_attack, function()
		-- Decide the tier and size
		local wave_size = (10 + party_tier ) * GameRules.PLAYER_COUNT
		SpawnDemonWave(party_tier, wave_size)
	end)
end

-- Start spawning units by packs
function SpawnDemonWave(tier, size)
	-- Cap the tier to the max table entry
	if tier > MAX_SPAWN_TIER then
		tier = MAX_SPAWN_TIER
	end
	print("Spawning a wave. Tier "..tier.." , Size: "..size)

	local tier_table = GameRules.DemonWaves[tostring(tier)]
	print("Tier "..tier.." units:")
	DeepPrintTable(tier_table)

	-- Quest Start
	GameRules.DefendCityQuest = SpawnEntityFromTableSynchronous( "quest", { name = "QuestName", title = "#DefendCityQuest" } )
	GameRules.DefendCitySubQuest = SpawnEntityFromTableSynchronous( "subquest_base", { show_progress_bar = true, progress_bar_hue_shift = -119 } )
	GameRules.DefendCityQuest.UnitsKilled = 0
	GameRules.DefendCityQuest.KillLimit = size
	GameRules.DefendCityQuest:AddSubquest( GameRules.DefendCitySubQuest )

	-- Quest Text
	GameRules.DefendCitySubQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 0 )
	GameRules.DefendCitySubQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, GameRules.DefendCityQuest.KillLimit )

	local melee_spawns = math.ceil(size/2)
	local ranged_spawns = math.ceil(size/2)

	-- Spawner names on the map:
	--	demon_wave_melee1 _melee2
	-- 	demon_wave_ranged1 demon_wave_ranged2
	--	demon_wave_champion

	local melee_spawn1 = Entities:FindByName(nil, "demon_wave_melee1"):GetAbsOrigin()
	local melee_spawn2 = Entities:FindByName(nil, "demon_wave_melee2"):GetAbsOrigin()
	local ranged_spawn1 = Entities:FindByName(nil, "demon_wave_ranged1"):GetAbsOrigin()
	local ranged_spawn2 = Entities:FindByName(nil, "demon_wave_ranged2"):GetAbsOrigin()
	local champion_spawn = Entities:FindByName(nil, "demon_wave_champion"):GetAbsOrigin()
	GameRules.demonSpawns = {}

	-- Every TIME_BETWEEN_SPAWNS, spawn 2 melee and 2 ranged, until the size is reached (spawns sizes will then be multiple of 4)
	Timers:CreateTimer(function() 

		local ranged_name = tier_table["1"]
		local melee_name = tier_table["2"]
		local caster_name = tier_table["3"]

		local melee1 = CreateUnitByName(melee_name, melee_spawn1, true, nil, nil, DOTA_TEAM_NEUTRALS)
		local melee2 = CreateUnitByName(melee_name, melee_spawn2, true, nil, nil, DOTA_TEAM_NEUTRALS)
		local ranged = CreateUnitByName(ranged_name, ranged_spawn1, true, nil, nil, DOTA_TEAM_NEUTRALS)
		local caster = CreateUnitByName(caster_name, ranged_spawn2, true, nil, nil, DOTA_TEAM_NEUTRALS)

		table.insert(GameRules.demonSpawns, melee1)
		table.insert(GameRules.demonSpawns, melee2)
		table.insert(GameRules.demonSpawns, ranged)
		table.insert(GameRules.demonSpawns, caster)

		print("Demons spawned: "..#GameRules.demonSpawns)

		if #GameRules.demonSpawns < size then
			return TIME_BETWEEN_SPAWNS
		else
			-- Finished spawning, start checking for next spawner
			local champion = CreateUnitByName("champion_of_hades", champion_spawn, true, nil, nil, DOTA_TEAM_NEUTRALS)
			champion:CreatureLevelUp( GameRules.AveragePartyLevel - 1 )
			table.insert(GameRules.demonSpawns, champion)
			GameRules.TimeoutNextWave = GameRules:GetGameTime() + 180 --This is to force the next wave in case players manage to get some units stuck

			-- Update quest 
			GameRules.DefendCityQuest.KillLimit = #GameRules.demonSpawns
			GameRules.DefendCitySubQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, GameRules.DefendCityQuest.KillLimit )

			StartNextWaveAttackTimer()
		end
	end)
end

-- After an attack is launched, the next attack will start counting down after all the units are killed Or after 3 minutes have passed.
function StartNextWaveAttackTimer()
	print("Wave finished spawning, checking for next attack")

	Timers:CreateTimer(function() 
		if not DemonsRemaining() or GameRules:GetGameTime() >= GameRules.TimeoutNextWave then
			local levels = GetPlayersPowerLevel()	

			GameRules.AveragePartyLevel = math.floor(levels / GameRules.PLAYER_COUNT)
			local party_tier = math.ceil(GameRules.AveragePartyLevel/10)
			local time_until_attack = BASE_TIME_UNTIL_ATTACK + party_tier * 30

			FireGameEvent('cgm_timer_display', { timerMsg = "Attack in", timerSeconds = time_until_attack, timerWarning = 0, timerEnd = 0, timerPosition = 2})

			print("Next Attack in "..time_until_attack.." seconds")

			-- End the quest
			GameRules.DefendCityQuest:CompleteQuest()

			Timers:CreateTimer(time_until_attack, function()
				-- Decide the tier and size
				local wave_size = (10 + party_tier ) * GameRules.PLAYER_COUNT
				SpawnDemonWave(party_tier, wave_size)
			end)
		else
			UpdateDefendCityQuest()
			return 1
		end
	end)
end

function UpdateDefendCityQuest()
	-- Fill the quest bar and substract one from the quest remaining text
    GameRules.DefendCityQuest.UnitsKilled = GameRules.DefendCityQuest.KillLimit - #GameRules.demonSpawns
    GameRules.DefendCitySubQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, GameRules.DefendCityQuest.UnitsKilled )
end

function DemonsRemaining()
	local demons_alive = {}
	for _,unit in pairs(GameRules.demonSpawns) do
		if IsValidEntity(unit) and unit:IsAlive() then
			table.insert(demons_alive, unit)
		end
	end
	GameRules.demonSpawns = demons_alive
	if #GameRules.demonSpawns > 0 then 
		return true
	else
		return false
	end
end

function Pause( event )
	FireGameEvent('cgm_timer_pause', { timePaused = true})
end

function UnPause( event )
	FireGameEvent('cgm_timer_pause', { timePaused = false})
end

function GetPlayersPowerLevel()
	local level = 0
	for pID = 0, DOTA_MAX_PLAYERS-1 do
	    if PlayerResource:IsValidPlayer(pID) and not PlayerResource:IsBroadcaster(pID) then
	    	level = level + PlayerResource:GetSelectedHeroEntity(pID):GetLevel()
	    end
	end
	return level
end