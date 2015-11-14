require 'timers'

function avatar_of_earth_meteor_effect(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	
	local meteor_origin = caster:GetOrigin() + Vector(0,0,1000)
	local meteor_target = target

--	local meteor_dummy = CreateUnitByName("dummy_unit_movecap", meteor_origin, true, caster, nil, caster:GetTeam())
--	meteor_dummy:FindAbilityByName("dummy_passive"):SetLevel(1)
	
	--local track_path = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield_mark.vpcf"
	local track_path = "particles/items/aura_vlads.vpcf"
	local track_attach = target + Vector(0, 0, 100)
	caster.track_effect = ParticleManager:CreateParticle(track_path, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(caster.track_effect, 0, track_attach)
	
	Timers:CreateTimer(4, function()
		local effect_path = "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf"
		caster.meteor_effect = ParticleManager:CreateParticle(effect_path, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(caster.meteor_effect, 0, meteor_origin)
		ParticleManager:SetParticleControl(caster.meteor_effect, 1, meteor_target)
		ParticleManager:SetParticleControl(caster.meteor_effect, 2, Vector(1.3, 0, 0))
	end)
	
	-- I am currently unaware of the delay before the meteor lands
	Timers:CreateTimer(5.5, function()
		avatar_of_earth_meteor_effect_land(keys)
	end)
end

function avatar_of_earth_meteor_effect_land(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = caster:FindAbilityByName("tbr_avatar_of_earth_meteor")
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local damages = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	
	ParticleManager:DestroyParticle(caster.meteor_effect, false)
	
	local fire_path = "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fire.vpcf"
	local burnt_path = "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burnt.vpcf"
	local glow_path = "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fire_trail_glow.vpcf"
	
	caster.meteor_land_burnt = ParticleManager:CreateParticle(burnt_path, PATTACH_ABSORIGIN, caster)
	caster.meteor_land_fire = ParticleManager:CreateParticle(fire_path, PATTACH_ABSORIGIN, caster)
	caster.meteor_land_glow = ParticleManager:CreateParticle(glow_path, PATTACH_ABSORIGIN, caster)
	
	ParticleManager:SetParticleControl(caster.meteor_land_burnt, 3, target)
	ParticleManager:SetParticleControl(caster.meteor_land_fire, 3, target)
	ParticleManager:SetParticleControl(caster.meteor_land_glow, 3, target)
	
	local targets = FindUnitsInRadius(caster:GetTeam(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local count = 1
	
	while true do
		if targets[count] then
			local damageTable = {
				victim = targets[count],
				damage = damages,
				damage_type = DAMAGE_TYPE_MAGICAL,
				attacker = caster,
				ability = abilitys
			}
			
			ApplyDamage(damageTable)
			count = count + 1
		else
			break
		end
	end
	
	Timers:CreateTimer(3, function()
		destroyAll(keys)
	end)
end

function destroyAll(keys)
	local caster = keys.caster
	
	ParticleManager:DestroyParticle(caster.meteor_land_burnt, false)
	ParticleManager:DestroyParticle(caster.meteor_land_fire, false)
	ParticleManager:DestroyParticle(caster.meteor_land_glow, false)
	ParticleManager:DestroyParticle(caster.track_effect, false)
end