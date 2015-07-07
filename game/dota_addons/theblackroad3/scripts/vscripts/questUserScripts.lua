-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('quest/interact')
require('quest/quest')

SetupQuests = function()
  quest_setup = true
  local npc = NPC.create("flyingpig")
  NPC.firstOf("")
  npc:apply(NPC.firstOf("npc_dota_flying_courier"))
  npc = NPC.create("eidelon")
  npc:apply(NPC.firstOf("npc_dota_dire_eidolon"))

  --npc:apply(NPC.firstOf("npc_dota_dire_eidolon"))
  local testQuest = Quest.create("sampleQuest2")
  local test2 = Quest.create("sampleQuest")
end

if quest_setup then
  SetupQuests()
end