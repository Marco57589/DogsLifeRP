local l_light_status = false
local r_light_status = false 
local haz_light_status = false

RegisterNetEvent('update_indicators')
AddEventHandler('update_indicators', function(PID, dir, switch)

--	GET_VEHICLE_PED_IS_IN (ped,lastVehicle)
--	ped = source
--	lastVehicle = false (currentVehicle)

-- 	SET_VEHICLE_INDICATOR_LIGHTS (vehicle,turnSignal,toggle)
-- 	vehicle = vehicle
-- 	0/1: right-left
-- 	switch: true-false

	local currentVehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(PID)), false)

	if dir == 'left' then
		SetVehicleIndicatorLights(currentVehicle, 1, switch)
	elseif dir == 'right' then
		SetVehicleIndicatorLights(currentVehicle, 0, switch)
	elseif dir == 'left_right' then
		SetVehicleIndicatorLights(currentVehicle, 0, switch)	
		SetVehicleIndicatorLights(currentVehicle, 1, switch)
	end
	
end)

Citizen.CreateThread(function()

--	307: INPUT_REPLAY_ADVANCE |-| ARROW RIGHT |-| DPAD RIGHT
-- 	308:	INPUT_REPLAY_BACK |-| ARROW LEFT |-| DPAD LEFT
-- 	299: INPUT_REPLAY_REWIND |-| ARROW DOWN |-| LB

	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 308) then 
			if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
				TriggerEvent('vehicle_indicator', 'left_indicator')
			end
		end
		if IsControlJustPressed(1, 307) then 
			if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
				TriggerEvent('vehicle_indicator', 'right_indicator')
			end
		end
		if IsControlJustPressed(1, 299) then
			if IsPedInAnyVehicle(GetPlayerPed(-1),true) then
				TriggerEvent('vehicle_indicator', 'hazard_lights')
			end
		end
    end	
end)


AddEventHandler('vehicle_indicator', function(dir)
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		
		if IsPedInAnyVehicle(ped, true) then
			local veh = GetVehiclePedIsIn(ped, false)

			if GetPedInVehicleSeat(veh, -1) == ped then
				if dir == 'left_indicator' then
					l_light_status = not l_light_status
					r_light_status = false
					haz_light_status = false
					
					TriggerServerEvent('LIND', l_light_status)	
					TriggerServerEvent('RIND', false)
					
				elseif dir == 'right_indicator' then	
					r_light_status = not r_light_status	
					l_light_status = false
					haz_light_status = false
					
					TriggerServerEvent('LIND', false)
					TriggerServerEvent('RIND', r_light_status)
					
				elseif dir == 'hazard_lights' then
					haz_light_status = not haz_light_status
					l_light_status = false
					r_light_status = false
					
					TriggerServerEvent('LIND', false)
					TriggerServerEvent('RIND', false)
					TriggerServerEvent('HAZARD', haz_light_status)
					
				end
			end
		end
	end)
end)