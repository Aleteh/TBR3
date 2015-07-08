require('tbr')
require('timers')
require('physics')
require('xp_table')
require('popups')
require('spawn')
require('utilities')
require('items')
require('crafting')
require('rpg')
require('demon_wave')
require('quest/interact')
require('quest/quest')
require('questUserScripts')

function Precache( context )
		print("Performing pre-load precache")

		-- Particles can be precached individually or by folder
		PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
		PrecacheResource("particle_folder", "particles/test_particle", context)

		-- Models can also be precached by folder or individually
		-- PrecacheModel should generally used over PrecacheResource for individual models
		PrecacheResource("model_folder", "particles/heroes/antimage", context)
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_ember_spirit", context)
		PrecacheResource( "particle_folder", "particles/econ/items", context)
		  PrecacheResource("particle", "particles/quest_handin_green.vpcf", context)
		  PrecacheResource("particle", "particles/quest_mark_yellow.vpcf", context)
		PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
		PrecacheModel("models/heroes/viper/viper.vmdl", context)

		-- Sounds can precached here like anything else
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)

		-- Entire items can be precached by name
		-- Abilities can also be precached in this way despite the name
		--PrecacheItemByNameSync("example_ability", context)
		--PrecacheItemByNameSync("item_example_item", context)

		-- Units
		PrecacheUnitByNameSync("champion_of_hades", context)
		PrecacheUnitByNameSync("demonic_carrion", context)
		PrecacheUnitByNameSync("demonic_pillager", context)
		PrecacheUnitByNameSync("demon_thrall", context)
		PrecacheUnitByNameSync("npc_demon_hound", context)
		PrecacheUnitByNameSync("npc_forest_bear", context)


		PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
		PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end