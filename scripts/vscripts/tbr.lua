print ('[TBR] tbr.lua' )

ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = true        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 10                -- How long should we let people select their hero?
PRE_GAME_TIME = 5                       -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 60.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 100                     -- How much gold should players get per tick?
GOLD_TICK_TIME = 5                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = false     -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
CAMERA_DISTANCE_OVERRIDE = 1500         -- How far out should we allow the camera to go?  1134 is the default in Dota

MINIMAP_ICON_SIZE = 1                 -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1            -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                   -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = true      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- Should we use a custom buyback time?
BUYBACK_ENABLED = false                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = true      -- Should we disable fog of war entirely for both teams?
--USE_STANDARD_DOTA_BOT_THINKING = false  -- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = true                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 50         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 200                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = true             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

if GameMode == nil then
	GameMode = class({})
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
	GameMode = self
	print('[TBR] Starting to load TBR gamemode...')

	-- Setup rules
	self:ReadGameConfiguration()
	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME)
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
	GameRules:SetGoldPerTick(GOLD_PER_TICK)
	GameRules:SetGoldTickTime(GOLD_TICK_TIME)
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )


	print('[TBR] GameRules set')

	InitLogFile( "log/barebones.txt","")

	-- Event Hooks

	-- Must Use
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
	ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
	ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent( 'dota_player_pick_hero', Dynamic_Wrap( GameMode, 'OnPlayerPicked' ), self )

	--[[ Possible Use	
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
	ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
	ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
	ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)
	ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
	ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
	]]

	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(timeTxt))

	-- Initialized tables for tracking state
	self.vUserIds = {}
	self.vSteamIds = {}

	self.vPlayers = {}
	self.vRadiant = {}
	self.vDire = {}

	self.nRadiantKills = 0
	self.nDireKills = 0

	self.bSeenWaitForPlayers = false

	self.nPlayerCount = 0

	-- Spawn Locations and Area Activations

	-- Make separate lists based on creepName to randomize spawn locations later
	-- These lists store the entity handles of every spawn location on the map (actual location is accessed via :GetOrigin())
	-- Spawn name entity format guide: creepName_spawner
	-- Dont repeat creepNames, just make new copies of the unit if thats the case

	-- Spawner entities named: creepName_spawner
	-- Also, they are fricking Satyrs, not golins, what the hell :D

	 -- Demon Area
	GameMode.demon_imp_spawnLocations = Entities:FindAllByName("demon_imp_spawner")
	GameMode.demon_hound_spawnLocations = Entities:FindAllByName("demon_hound_spawner")
	GameMode.demon_fire_spawnLocations = Entities:FindAllByName("demon_fire_spawner")
	GameMode.forest_bear_spawnLocations = Entities:FindAllByName("forest_bear_spawner")
	GameMode.DemonAreaCreeps = {} -- Keep a list of all creeps in the area

	-- Goblin Area
	GameMode.goblin_spawnLocations = Entities:FindAllByName("goblin_spawner")
	GameMode.shaman_spawnLocations = Entities:FindAllByName("shaman_spawner")
	GameMode.GoblinAreaActive = false

	-- Black Goblin Area
	GameMode.black_goblin_spawnLocations = Entities:FindAllByName("black_goblin_spawner")
	GameMode.ogre_spawnLocations = Entities:FindAllByName("ogre_spawner")
	GameMode.black_shaman_spawnLocations = Entities:FindAllByName("black_shaman_spawner")
	GameMode.BlackGoblinAreaCreeps = {}

	-- Bandit Area
	GameMode.bandit_spawnLocations = Entities:FindAllByName("bandit_spawner")
	GameMode.BanditAreaCreeps = {}


	print('[TBR] Done loading the gamemode!\n\n')
end

mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:CaptureGameMode()
	if mode == nil then
		-- Set GameMode parameters
		mode = GameRules:GetGameModeEntity()        
		mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
		mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
		mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
		
		mode:SetAnnouncerDisabled(true)
		mode:SetBuybackEnabled(false)
		mode:SetFixedRespawnTime(45)

		--mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

		mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
		mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
		mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

		--GameRules:GetGameModeEntity():SetThink( "Think", self, "GlobalThink", 2 )

		--self:SetupMultiTeams()
		self:OnFirstPlayerLoaded()
	end 
end

--[[
	This function should be used to set up Async precache calls at the beginning of the game.  The Precache() function 
	in addon_game_mode.lua used to and may still sometimes have issues with client's appropriately precaching stuff.
	If this occurs it causes the client to never precache things configured in that block.
	]]
function GameMode:PostLoadPrecache()
	print("[TBR] Performing Post-Load precache")    
	PrecacheItemByNameAsync("item_wraithblade", function(...) end)
	--PrecacheItemByNameAsync("example_ability", function(...) end)
	--PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
	PrecacheUnitByNameAsync("npc_bank", function(...) end)
	PrecacheUnitByNameAsync("player_gravestone", function(...) end)
	PrecacheUnitByNameAsync("npc_demon_fire", function(...) end)
end


-- Read and assign configurable keyvalues if applicable
function GameMode:ReadGameConfiguration()
	self.SpawnInfoKV = LoadKeyValues( "scripts/maps/spawn_info.kv" )
	self.ItemInfoKV = LoadKeyValues( "scripts/maps/item_info.kv" )

	DeepPrintTable(self.ItemInfoKV)

	-- separate in different lists to make it more manageable (not needed)
	--[[self:ReadGoblinAreaSpawnConfiguration( self.SpawnInfoKV["GoblinArea"] )]]
end

--[[function GameMode:ReadGoblinAreaSpawnConfiguration( kvSpawns )
	
	self.GoblinAreaInfoList = {}
	if type( kvSpawns ) ~= "table" then
		print("NO TABLE")
		return
	end

	for _,unit in pairs( kvSpawns ) do
		DeepPrintTable(unit)	
		table.insert( self.GoblinAreaInfoList, {
			RespawnTime = tonumber( unit.RespawnTime or 0 ),
			MaxSpawn = tonumber( unit.MaxSpawn or 0 ),
			GoldBounty = tonumber( unit.GoldBounty or 0 ),
			MatBounty = tonumber( unit.MatBounty or 0 )
		})
	end

	DeepPrintTable(self.GoblinAreaInfoList)

end]]

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
	--print("[TBR] NPC Spawned")
	local index = keys.entindex
	local unit = EntIndexToHScript(index)
	local npc = EntIndexToHScript(keys.entindex)
	
	-- Print a message every time an NPC spawns
	if Convars:GetBool("developer") then
		--print("Index: "..index.." Name: "..unit:GetName().." Created time: "..GameRules:GetGameTime().." at x= "..unit:GetOrigin().x.." y= "..unit:GetOrigin().y)
	end

	if npc:IsHero() then
		npc.strBonus = 0
        npc.intBonus = 0
        npc.agilityBonus = 0
    end

	if npc:IsRealHero() and npc.bFirstSpawned == nil then
			npc.bFirstSpawned = true
			GameMode:OnHeroInGame(npc)
	elseif npc:IsRealHero() and npc.grave then
		-- remove the player grave
		UTIL_Remove(npc.grave)
	end
end

--This function is called once and only once for every player when they spawn into the game for the first time. 
function GameMode:OnHeroInGame(hero)
	print("[TBR] Hero spawned in game for first time -- " .. hero:GetUnitName())

	local player = PlayerResource:GetPlayer(hero:GetPlayerID())

	-- update the player count
	if not player.addedToCount then 
		self.nPlayerCount = self.nPlayerCount + 1
		player.addedToCount = true 
	end
	print(self.nPlayerCount)

	-- Starting Gold
	hero:SetGold(322, false)

	-- Initialize custom stats
	hero.spellPower = 0
	hero.healingPower = 0

	-- Initialize custom resources
	hero.materials = 0

	-- Give Item
	--local item = CreateItem("item_searing_flame_of_prometheus", hero, hero)
	--hero:AddItem(item)

	local item = CreateItem("item_ares_bloodthirsty_spear_recipe", hero, hero)
	Timers:CreateTimer(1,function() CreateItemOnPositionSync(hero:GetAbsOrigin()+RandomVector(100), item) end )

	local item = CreateItem("item_blade_of_ares", hero, hero)
	hero:AddItem(item)

	local item = CreateItem("item_shadow_blade", hero, hero)
	hero:AddItem(item)

	local item = CreateItem("item_burning_hand_of_the_war_god", hero, hero)
	hero:AddItem(item)

	local item = CreateItem("item_heartstone_ring_of_agility", hero, hero)
	hero:AddItem(item)

	--[[local item = CreateItem("item_blazing_sword_of_helios", hero, hero)
	hero:AddItem(item)]]

	--Abilities
	local abil1 = hero:GetAbilityByIndex(0)
	local abil2 = hero:GetAbilityByIndex(1)
	local abil3 = hero:GetAbilityByIndex(2)
	local abil4 = hero:GetAbilityByIndex(3)
	local abil5 = hero:GetAbilityByIndex(4)
	local abil6 = hero:GetAbilityByIndex(5)
	if abil1 ~= nil then abil1:SetLevel(1) end
	if abil2 ~= nil then abil2:SetLevel(1) end
	if abil3 ~= nil then abil3:SetLevel(1) end
	if abil4 ~= nil then abil4:SetLevel(1) end
	if abil5 ~= nil then abil5:SetLevel(1) end
	if abil6 ~= nil then abil6:SetLevel(1) end
	--hero:AddAbility("example_ability")

	-- Give 2 extra stat points to spend
	hero:SetAbilityPoints(3)

	local heroName = hero:GetUnitName()

	-- Set Class
	if heroName == "npc_dota_hero_beastmaster" then
		print("BARBARIAN IN GAME")
		hero.class = "barbarian"
		hero:AddAbility("barbarian_rage")
		hero:FindAbilityByName("barbarian_rage"):SetLevel(1)
	elseif heroName == "npc_dota_hero_axe" then
		print("WARLORD IN GAME")
		hero.class = "warlord"
		hero:AddAbility("warlord_focus")
		hero:FindAbilityByName("warlord_focus"):SetLevel(1)
	elseif heroName == "npc_dota_hero_skeleton_king" then
		print("KHAOS CHAMPION IN GAME")
		hero.class = "khaos_champion"
		hero:AddAbility("kc_hatred")
		hero:FindAbilityByName("kc_hatred"):SetLevel(1)
	elseif heroName == "npc_dota_hero_bounty_hunter" then
		print("ASSASSIN IN GAME")
		hero.class = "assassin"
		hero:AddAbility("assassin_energy")
		hero:FindAbilityByName("assassin_energy"):SetLevel(1)
	end

	if GameMode:IsWarriorClass(hero) then
		AdjustWarriorClassMana(hero)
	end

	GameMode:ModifyStatBonuses(hero)

	-- Profession placeholder
	hero.profession = "None"

end

function AdjustWarriorClassMana( hero )
	Timers:CreateTimer(0.1,function() 
		local heroLevel = hero:GetLevel()
		--Adjust Warrior class Mana rules
		if hero.class == "barbarian" then
			hero:SetBaseManaRegen( -(0.01 * heroLevel) - 0.25)
		elseif hero.class == "warlord" then
			hero:SetBaseManaRegen( (0.02 * heroLevel + 0.5) )	
		elseif hero.class == "khaos_champion" then
			hero:SetBaseManaRegen( (0.01 * heroLevel + 0.15) + 0.75)
		elseif hero.class == "assassin" then
			hero:SetBaseManaRegen( (0.06 * heroLevel + 0.6) + 0.75)
		else 
			print("ERROR, Not a Warrior Class")
		end
		print(hero.class.." mana regen adjusted to ".. hero:GetConstantBasedManaRegen() )
	end)
end

function GameMode:IsWarriorClass(hero)
	if hero.class == "barbarian" or hero.class == "warlord" or hero.class == "khaos_champion" or hero.class == "assassin" then
		return true
	else
		return false
	end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive operations here
function GameMode:OnEntityHurt(keys)
	--print("[TBR] Entity Hurt")
	--DeepPrintTable(keys)
	local entCause = EntIndexToHScript(keys.entindex_attacker)
	local entVictim = EntIndexToHScript(keys.entindex_killed)
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
	print ( '[TBR] OnItemPickedUp' )
	--DeepPrintTable(keys)

	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
	print ( '[TBR] OnItemPurchased' )
	DeepPrintTable(keys)

	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end

	-- The name of the item purchased
	local itemName = keys.itemname 
	
	-- The cost of the item purchased
	local itemcost = keys.itemcost
	
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
	print('[TBR] AbilityUsed')
	DeepPrintTable(keys)

	local player = EntIndexToHScript(keys.PlayerID)
	local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
	print('[TBR] OnNonPlayerUsedAbility')
	DeepPrintTable(keys)

	local abilityname=  keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
	print('[TBR] OnPlayerChangedName')
	DeepPrintTable(keys)

	local newName = keys.newname
	local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
	--print ('[TBR] OnPlayerLearnedAbility')
	--DeepPrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local hero = player:GetAssignedHero()
	local abilityname = keys.abilityname
	local level = hero:FindAbilityByName(abilityname):GetLevel()

	if abilityname == "templeguardian_pray" then
		print("Updating Prays")
		local ares = hero:FindAbilityByName("pray_ares")
		local athena = hero:FindAbilityByName("pray_athena")
		local zeus = hero:FindAbilityByName("pray_zeus")
		ares:SetLevel(level)
		athena:SetLevel(level)
		zeus:SetLevel(level)
	end

end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
	--print ('[TBR] OnPlayerLevelUp')
	--DeepPrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local level = keys.level


	--get the player's ID
    local pID = player:GetPlayerID()

    --get the hero handle
    local hero = player:GetAssignedHero()
    
    --get the players current stat points
    local statsUnspent = hero:GetAbilityPoints()

    --[[ Rules to assign stat points:
		1-19 = 3
		20-39 = 4
		40-59 = 5
		60-79 = 6
		80-99 = 7
		100-119 = 8
		120-139 = 9
		140-159 = 10
		160-179 = 11
		180-199 = 12
		200 = 13 (Maybe more for the last level)
	]]

	-- check the current Level of the hero and assign points accordingly
	-- we do 1 less than what we want, because the game automatically gives 1
	local heroLevel = hero:GetLevel()
	if heroLevel <= 19 then
		hero:SetAbilityPoints(statsUnspent+2)
	elseif heroLevel <= 39 then
		hero:SetAbilityPoints(statsUnspent+3)
	elseif heroLevel <= 59 then
		hero:SetAbilityPoints(statsUnspent+4)
    elseif heroLevel <= 79 then
		hero:SetAbilityPoints(statsUnspent+5)
	elseif heroLevel <= 99 then
		hero:SetAbilityPoints(statsUnspent+6)
	elseif heroLevel <= 119 then
		hero:SetAbilityPoints(statsUnspent+7)
	elseif heroLevel <= 139 then
		hero:SetAbilityPoints(statsUnspent+8)
	elseif heroLevel <= 159 then
		hero:SetAbilityPoints(statsUnspent+9)
	elseif heroLevel <= 179 then
		hero:SetAbilityPoints(statsUnspent+10)
	elseif heroLevel <= 199 then
		hero:SetAbilityPoints(statsUnspent+11)
	elseif heroLevel == 200 then
		hero:SetAbilityPoints(statsUnspent+12)
	end

	--update the statsUnspent variable to send
	statsUnspent = hero:GetAbilityPoints()

    --Fire Game Event to our UI
    print("Got " .. statsUnspent .. " Ability Points to spend! Firing game event")
	FireGameEvent('cgm_player_stat_points_changed', { player_ID = pID, stat_points = statsUnspent })

	--Fully heal Health & Mana of the player
	hero:SetHealth(hero:GetMaxHealth())
	hero:SetMana(hero:GetMaxMana())

	AdjustWarriorClassMana(hero)

end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
	--print ('[TBR] OnLastHit')
	--DeepPrintTable(keys)

	local isFirstBlood = keys.FirstBlood == 1
	local isHeroKill = keys.HeroKill == 1
	local isTowerKill = keys.TowerKill == 1
	local player = PlayerResource:GetPlayer(keys.PlayerID)
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	--print( '[BAREBONES] OnEntityKilled Called' )
	--DeepPrintTable( keys )
	
	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local unitName = killedUnit:GetUnitName()
	-- The Killing entity
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	if killedUnit and ( killedUnit:GetTeamNumber()==DOTA_TEAM_NEUTRALS or killedUnit:GetTeamNumber()==DOTA_TEAM_BADGUYS ) and killedUnit:IsCreature() then
		local level = killedUnit:GetLevel()
		-- Increase by 10% for each party member
		local party_bonus = 1 + ( self.nPlayerCount * 0.1 )
		local xp = ( 20 + level * 5 ) * party_bonus

		--Popup XP
		PopupExperience(killedUnit,math.floor(xp))

		--Popup Gold
		PopupGoldGain(killedUnit,GameMode:GetBountyFor(unitName))

		-- Grant XP in AoE
		local heroesNearby = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, killedUnit:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER,false)
		for _,hero in pairs(heroesNearby) do
			if hero:IsRealHero() then
				hero:AddExperience(math.floor(xp), false)
			end
		end

	elseif killedUnit and killedUnit:IsRealHero() then 

		print ("KILLEDKILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
		local grave = CreateUnitByName("player_gravestone", killedUnit:GetAbsOrigin(), true, killedUnit, killedUnit, killedUnit:GetTeamNumber())
		killedUnit.grave = grave

		if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS and killerEntity:GetTeam() == DOTA_TEAM_GOODGUYS then
			self.nRadiantKills = self.nRadiantKills + 1
			if END_GAME_ON_KILLS and self.nRadiantKills >= KILLS_TO_END_GAME_FOR_TEAM then
				GameRules:SetSafeToLeave( true )
				GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
			end
		elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS and killerEntity:GetTeam() == DOTA_TEAM_BADGUYS then
			self.nDireKills = self.nDireKills + 1
			if END_GAME_ON_KILLS and self.nDireKills >= KILLS_TO_END_GAME_FOR_TEAM then
				GameRules:SetSafeToLeave( true )
				GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
			end
		end

		if SHOW_KILLS_ON_TOPBAR then
			GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, self.nDireKills )
			GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, self.nRadiantKills )
		end
	end

end

-- go through the self.SpawnInfoKV and return the bounty
function GameMode:GetBountyFor( unitName )
	for k,v in pairs(self.SpawnInfoKV) do
		print(k,v)
		for key,value in pairs(self.SpawnInfoKV[k]) do
			if key == unitName then 
				return RandomInt(value.BountyGoldMin, value.BountyGoldMax)
			end
		end
	end

	return 0
	
end


--This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
function GameMode:OnFirstPlayerLoaded()
	print("[TBR] First Player has loaded")
end

--This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
function GameMode:OnAllPlayersLoaded()
	print("[TBR] All Players have loaded into the game")
end

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
	print("[TBR] GameRules State Changed")
	--DeepPrintTable(keys)

	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		self.bSeenWaitForPlayers = true
		elseif newState == DOTA_GAMERULES_STATE_INIT then
			Timers:RemoveTimer("alljointimer")
			elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
				local et = 6
				if self.bSeenWaitForPlayers then
					et = .01
			end
			Timers:CreateTimer("alljointimer", {
					useGameTime = true,
					endTime = et,
					callback = function()
					if PlayerResource:HaveAllPlayersJoined() then
						GameMode:PostLoadPrecache()
						GameMode:OnAllPlayersLoaded()
						return 
				end
				return 1
		end
		})
			elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
					GameMode:OnGameInProgress()
			end
	end


--[[
	This function is called once and only once when the game completely begins (about 0:00 on the clock).
	This function is useful for starting any game logic timers/thinkers, beginning the first round, etc.
	]]
	function GameMode:OnGameInProgress()
	--print("[TBR] The game has officially begun")

	Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
		function()
		--print("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
		return 30.0 -- Rerun this timer every 30 game-time seconds 
		end)
end

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
	print('[TBR] Player Disconnected ' .. tostring(keys.userid))
	DeepPrintTable(keys)

	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid

end

-- A player has reconnected to the game.  
-- This function can be used to repaint Player-based particles or change state as necessary
function GameMode:OnPlayerReconnect(keys)
	print ( '[TBR] OnPlayerReconnect' )
	--DeepPrintTable(keys) 
end

-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
	print('[TBR] PlayerConnect')
	DeepPrintTable(keys)
	
	if keys.bot == 1 then
		-- This user is a Bot, so add it to the bots table
		self.vBots[keys.userid] = 1
	end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	print ('[TBR] OnConnectFull')
	--DeepPrintTable(keys)
	GameMode:CaptureGameMode()
	
	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)
	
	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()
	
	-- Update the user ID table with this user
	self.vUserIds[keys.userid] = ply

	-- Update the Steam ID table
	self.vSteamIds[PlayerResource:GetSteamAccountID(playerID)] = ply
	
end

-- unnecessary (?)
-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
	print ('[TBR] OnTreeCut')
	DeepPrintTable(keys)

	local treeX = keys.tree_x
	local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
	print ('[TBR] OnRuneActivated')
	DeepPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local rune = keys.rune

	--[[ Rune Can be one of the following types
	DOTA_RUNE_DOUBLEDAMAGE
	DOTA_RUNE_HASTE
	DOTA_RUNE_HAUNTED
	DOTA_RUNE_ILLUSION
	DOTA_RUNE_INVISIBILITY
	DOTA_RUNE_MYSTERY
	DOTA_RUNE_RAPIER
	DOTA_RUNE_REGENERATION
	DOTA_RUNE_SPOOKY
	DOTA_RUNE_TURBO
	]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
	print ('[BAREBONES] OnPlayerTakeTowerDamage')
	DeepPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local damage = keys.damage
end

-- A player picked a hero and pressed Play
function GameMode:OnPlayerPicked( event )
	local spawnedUnitIndex = EntIndexToHScript(event.heroindex)
	-- Apply timer to update stats
	GameMode:ModifyStatBonuses(spawnedUnitIndex)
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
	print ('[TBR] OnAbilityChannelFinished')
	DeepPrintTable(keys)

	local abilityname = keys.abilityname
	local interrupted = keys.interrupted == 1
end
-- Multiteam support is unfinished currently
-- function GameMode:SetupMultiTeams()
-- MultiTeam:start()
 -- MultiTeam:CreateTeam("team1")
 -- MultiTeam:CreateTeam("team2")
--end

function GameMode:ModifyStatBonuses(unit)
	local spawnedUnitIndex = unit
	print("modifying stat bonuses")
		Timers:CreateTimer(DoUniqueString("updateHealth_" .. spawnedUnitIndex:GetPlayerID()), {
		endTime = 0.25,
		callback = function()

			GameMode:AdjustSpellPower(spawnedUnitIndex)

			-- ==================================
			-- Adjust health based on strength
			-- ==================================
 
			-- Get player strength
			local strength = spawnedUnitIndex:GetStrength()
 
			--Check if strBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.strBonus == nil then
				spawnedUnitIndex.strBonus = 0
			end
 
			-- If player strength is different this time around, start the adjustment
			if strength ~= spawnedUnitIndex.strBonus then
				-- Modifier values
				local bitTable = {4096,2048,1024,512,256,128,64,32,16,8,4,2,1}
 
				-- Gets the list of modifiers on the hero and loops through removing and health modifier
				local modCount = spawnedUnitIndex:GetModifierCount()
				for i = 0, modCount do
					for u = 1, #bitTable do
						local val = bitTable[u]
						if spawnedUnitIndex:GetModifierNameByIndex(i) == "modifier_health_mod_" .. val  then
							spawnedUnitIndex:RemoveModifierByName("modifier_health_mod_" .. val)
						end
					end
				end
 
				-- Creates temporary item to steal the modifiers from
				local healthUpdater = CreateItem("item_health_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(strength / val)
					if count >= 1 then
						healthUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_health_mod_" .. val, {})
						strength = strength - val
					end
				end
				-- Cleanup
				UTIL_RemoveImmediate(healthUpdater)
				healthUpdater = nil
			end
			-- Updates the stored strength bonus value for next timer cycle
			spawnedUnitIndex.strBonus = spawnedUnitIndex:GetStrength()

			-- ==================================
			-- Adjust mana based on intellect
			-- ==================================
 
			-- Get player intellect
			local intellect = spawnedUnitIndex:GetIntellect()
 
			--Check if intBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.intBonus == nil then
				spawnedUnitIndex.intBonus = 0
			end
 
			-- If player intellect is different this time around, start the adjustment
			if intellect ~= spawnedUnitIndex.intBonus then

				-- Modifier values
				local bitTable = {4096,2048,1024,512,256,128,64,32,16,8,4,2,1}
 
				-- Gets the list of modifiers on the hero and loops through removing and mana modifier
				local modCount = spawnedUnitIndex:GetModifierCount()
				for i = 0, modCount do
					for u = 1, #bitTable do
						local val = bitTable[u]
						if spawnedUnitIndex:GetModifierNameByIndex(i) == "modifier_mana_mod_" .. val  then
							spawnedUnitIndex:RemoveModifierByName("modifier_mana_mod_" .. val)
						end
					end
				end
 
				-- Creates temporary item to steal the modifiers from
				local manaUpdater = CreateItem("item_mana_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(intellect / val)
					if count >= 1 then
						manaUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_mana_mod_" .. val, {})
						intellect = intellect - val
					end
				end
				-- Cleanup
				UTIL_RemoveImmediate(healthUpdater)
				manaUpdater = nil
			end
			-- Updates the stored intellect bonus value for next timer cycle
			spawnedUnitIndex.intBonus = spawnedUnitIndex:GetIntellect()

			-- ==================================
			-- Adjust armor based on agi 
			-- Added as +Armor and not Base Armor because there's no BaseArmor modifier (please...)
			-- ==================================

			-- Get player primary stat value
			local agility = spawnedUnitIndex:GetAgility()

			--Check if primaryStatBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.agilityBonus == nil then
				spawnedUnitIndex.agilityBonus = 0
			end

			-- If player int is different this time around, start the adjustment
			if agility ~= spawnedUnitIndex.agilityBonus then
				-- Modifier values
				local bitTable = {1024,512,256,128,64,32,16,8,4,2,1}

				-- Gets the list of modifiers on the hero and loops through removing and armor modifier
				for u = 1, #bitTable do
					local val = bitTable[u]
					if spawnedUnitIndex:HasModifier( "modifier_armor_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_armor_mod_" .. val)
					end
					
					if spawnedUnitIndex:HasModifier( "modifier_negative_armor_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_negative_armor_mod_" .. val)
					end
				end
				--print("========================")
				agility = agility / 7
				--print("Agi / 7: "..agility)
				-- Remove Armor
				-- Creates temporary item to steal the modifiers from
				local armorUpdater = CreateItem("item_armor_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(agility / val)
					if count >= 1 then
						armorUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_negative_armor_mod_" .. val, {})
						--print("Adding modifier_negative_armor_mod_" .. val)
						agility = agility - val
					end
				end

				agility = spawnedUnitIndex:GetAgility()
				agility = agility / 5
				--print("Agi / 5: "..agility)
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(agility / val)
					if count >= 1 then
						armorUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_armor_mod_" .. val, {})
						agility = agility - val
						--print("Adding modifier_armor_mod_" .. val)
					end
				end

				-- Cleanup
				UTIL_RemoveImmediate(armorUpdater)
				armorUpdater = nil
			end
			-- Updates the stored Int bonus value for next timer cycle
			spawnedUnitIndex.agilityBonus = spawnedUnitIndex:GetAgility()


			return 0.25
		end
	})
end


function GameMode:AdjustSpellPower( hero )

	-- Loop though all the hero items checking a table
	hero.spellPower = 0
	hero.healingPower = 0
	hero.PowerMultiplier = 1
	for itemSlot = 0, 5, 1 do
		local Item = hero:GetItemInSlot( itemSlot )
		if Item ~= nil then
			itemName = Item:GetName()
			if self.ItemInfoKV[itemName] ~= nil then
				local itemTable = self.ItemInfoKV[itemName]

				-- if the item has spell power, add it
				if itemTable.spellPower then
					hero.spellPower = hero.spellPower + itemTable.spellPower
				end

				-- if the item has healing power, add it
				if itemTable.healingPower then
					hero.healingPower = hero.healingPower + itemTable.healingPower
				end

				-- if the item has power multiplier, add it
				if itemTable.Multiplier then
					hero.PowerMultiplier = hero.PowerMultiplier + ( itemTable.Multiplier * 0.01)
				end
				
			end
		end
	end

	-- Add Int based Spell Power bonus from Int
	local powerFromIntBonus = hero:GetIntellect() * 3

	-- Warrior Class doesnt get Power from Int
	if not GameMode:IsWarriorClass(hero) then
		hero.spellPower = hero.spellPower + powerFromIntBonus
		hero.healingPower = hero.healingPower + powerFromIntBonus
	end

	-- Multiply the spell & healing power for the stacked PowerMultiplier, after all the spell power sources are adjusted
	hero.spellPower = hero.spellPower * hero.PowerMultiplier
	hero.healingPower = hero.healingPower * hero.PowerMultiplier

	--[[print("=========================")
	print(hero.spellPower,hero.healingPower)
	print("Spell - Healing Powah")]]

end			



-- TESTING COMMANDS
Convars:RegisterCommand("test", function(cmdname, unitname) make(cmdname, unitname) end, "Test", 0)
Convars:RegisterCommand("bank", function(...) return SpawnBank() end, "Test Bank", FCVAR_CHEAT )

function test(cmdname, unitname)
	print("Created unit " .. unitname)
	local player = Convars:GetCommandClient()
	local hero = player:GetAssignedHero()
	hero:SetAbilityPoints( tonumber(numPoints) )
end

function SpawnBank()
	hero = PlayerResource:GetSelectedHeroEntity(0)
	local bank = CreateUnitByName("npc_bank", hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber() )
	bank:SetControllableByPlayer(hero:GetPlayerID(), true)

		-- add some test items to the bank
		local newItem = CreateItem( "item_wraithblade", hero, hero )
		bank:AddItem(newItem)
		local newItem = CreateItem( "item_regal_helm_of_sparkling_crystal", hero, hero )
		bank:AddItem(newItem)
		local newItem = CreateItem( "item_mighty_chestguard_of_the_olympians", hero, hero )
		bank:AddItem(newItem)
		local newItem = CreateItem( "item_mighty_helm_of_the_olympians", hero, hero )
		bank:AddItem(newItem)
		local newItem = CreateItem( "item_biting_blade", hero, hero )
		bank:AddItem(newItem)
end

-- Flash UI
-- register the 'AllocateStats' command in our console
Convars:RegisterCommand( "AllocateStats", function(name, p)
    --get the player that sent the command
    local cmdPlayer = Convars:GetCommandClient()
    if cmdPlayer then 
        --if the player is valid, execute the appropiate ModifyStats
        return GameMode:ModifyStats( cmdPlayer , p)
    end
end, "A player uses an ability point", 0 )

function GameMode:ModifyStats( player, p )
    --p is str/agi/int depending on which button of the ui was pressed

    --get the player's ID
    local pID = player:GetPlayerID()

    --get the hero handle
    local hero = player:GetAssignedHero()
    
    --get the players current stat points
    local statsUnspent = hero:GetAbilityPoints()
    
    --check if the player has stats to spend
    if statsUnspent > 0 then
        --spend the stat point
        hero:SetAbilityPoints(statsUnspent-1)
        --give the corresponding stat point
        if p=="str" then
	        hero:ModifyStrength(1)
	        print("+1 STR Allocated")
	    elseif p=="agi" then
	    	hero:ModifyAgility(1)
	        print("+1 AGI Allocated")
	    elseif p=="int" then
	    	hero:ModifyIntellect(1)
	        print("+1 INT Allocated")
	    end
    end

    --Fire the event. The second parameter is an object with all the event's parameters as properties
    --We have to get the player's unspent stats again, because we have deducted 1 from it since the last time we got it.
    FireGameEvent('cgm_player_stat_points_changed', { player_ID = pID, stat_points = hero:GetAbilityPoints() })
end

-- register the 'ChangeMaterials' command in our console
Convars:RegisterCommand( "ChangeMaterials", function(name, p)
    --get the player that sent the command
    local cmdPlayer = Convars:GetCommandClient()
    if cmdPlayer then 
        --if the player is valid, execute UpdateMaterials
        return GameMode:UpdateMaterials( cmdPlayer , p)
    end
end, "A player spends or adquires crafting materials", 0 )

function GameMode:UpdateMaterials( player, amount )
	--amount can be negative or positive
    
    --get the player's ID
    local pID = player:GetPlayerID()

    --get the hero handle
    local hero = player:GetAssignedHero()
    
    --materials were already added/substracted internally on the function that called this, print it here
    local heroMaterials = hero.materials + amount
    print("Updating materials for player " .. pID .. " , new ammount: " .. heroMaterials)

    --Fire the event. The second parameter is an object with all the event's parameters as properties
    --We send the total material number to update the UI of the player
    FireGameEvent('cgm_player_materials_changed', { player_ID = pID, materials = heroMaterials })
end
