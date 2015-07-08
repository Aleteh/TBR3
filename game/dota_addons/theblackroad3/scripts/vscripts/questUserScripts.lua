-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('quest/interact')
require('quest/quest')

SetupQuests = function()
  quest_setup = true
  local npc = NPC.create("therin")
  npc:apply(NPC.named("therin"))

  --npc:apply(NPC.firstOf("npc_dota_dire_eidolon"))
  local camp1 = Quest.create("1ChargetheFrontlines")
  local camp2 = Quest.create("2KilltheSteeds")
  local camp3 = Quest.create("8FieldTerrors")
  local camp4 = Quest.create("3InvadetheirBase")
  local camp5 = Quest.create("4NukachatheCursed")
end

if quest_setup then
  SetupQuests()
end