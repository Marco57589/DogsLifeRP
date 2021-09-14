RegisterServerEvent('LIND')
AddEventHandler('LIND', function(l_light_status)
	local netID = source
	TriggerClientEvent('update_indicators', -1, netID, 'left', l_light_status)
end)

RegisterServerEvent('RIND')
AddEventHandler('RIND', function(r_light_status)
	local netID = source
	TriggerClientEvent('update_indicators', -1, netID, 'right', r_light_status)
end)

RegisterServerEvent('HAZARD')
AddEventHandler('HAZARD', function(haz_light_status)
	local netID = source
	TriggerClientEvent('update_indicators', -1, netID, 'left_right', haz_light_status)
end)
