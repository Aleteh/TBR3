function barbarian_taunt( event )
	event.target:SetForceAttackTarget(event.caster)
	

	<BMD> you can issue an attack order
	<BMD> and set MODIFIER_STATE_COMMAND_RESTRICTED via a modifier
	<BMD> then remove it when the taunt it done

	-- 8 second delayed, run once using gametime (respect pauses)
  	Timers:CreateTimer({
    endTime = 8,
    callback = function()
      event.target:SetForceAttackTarget(nil)
    end
  	})

end