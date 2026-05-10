Yvelt = {}
ReportsInfos = {
    Waiting = 0,
    Taked = 0,
}

-- function YveltHelper:getAcces(rank, request) -- Function getAcces (Check if a rank can or not do x perm)
--     if rank.rank == 'user' then
--         return false
--     elseif rank.rank == 'fondateur' then
--         return true
--     else
--         local perms = j.decode(rank.perms)
--         local check = tostring(request)
--         if perms then
--             return perms[check]
--         else
--             Callback.triggerServerCallback('YveltAdmin:getRank', function(group)
--                 playerGroup = group
--                 player = playerGroup
--             end)
--             while playerGroup == nil do
--                 Wait(1)
--             end
--             rank = player
--             if rank.rank == 'user' then
--                 return false
--             elseif rank.rank == 'fondateur' then
--                 return true
--             else
--                 local perms = j.decode(rank.perms)
--                 local check = tostring(request)
--                 if perms[check] then
--                     return perms[check]
--                 end
--             end
--         end
--     end
-- end

-- exports('checkPerms', checkPerms)
-- checkPerms = function(perm)
--     return YveltHelper:getAcces(player, perm)
-- end

-- getStaffMode = function()
--     return YveltStaffMode
-- end

function compare(a, b)
    return a.power > b.power
end

blips = {}
adminShowBlipsPlayers = false
function adminBlips()
    if booladminShowBlipsPlayers then
		booladminShowBlipsPlayers = false
		for k,v in pairs(blips) do
			RemoveBlip(v)
		end
		blips = {}
	else
		booladminShowBlipsPlayers = true

		Citizen.CreateThread(function()
			while booladminShowBlipsPlayers do

                local myID = GetPlayerServerId(PlayerId())

				for k,v in pairs(GetActivePlayers()) do
					local pPed = GetPlayerPed(v)
                    if GetPlayerServerId(pPed) ~= myID then
                        if blips[v] == nil then
                            local blip = AddBlipForEntity(pPed)
                            SetBlipScale(blip, 0.75)
                            SetBlipCategory(blip, 2)
                            blips[v] = blip
                        else
                            local blip = GetBlipFromEntity(pPed)
                            RemoveBlip(blip)
                            RemoveBlip(blips[v])
                            local blip = AddBlipForEntity(pPed)
                            SetBlipScale(blip, 0.75)
                            SetBlipCategory(blip, 2)
                            blips[v] = blip
                        end
                        SetBlipNameToPlayerName(blips[v], v)
                        SetBlipSprite(blips[v], 1)
                        SetBlipRotation(blips[v], math.ceil(GetEntityHeading(pPed)))
                        if not IsEntityVisible(pPed) or 250 >= GetEntityAlpha(pPed) then
                            if GetDistanceBetweenCoords(GetEntityCoords(pPed), GetEntityCoords(PlayerPedId())) <= 190 then
                                SetBlipSprite(blips[v], 364)
                                SetBlipColour(blips[v], 1)
                            end
                        elseif IsPedInAnyVehicle(pPed, false) then
                            ShowHeadingIndicatorOnBlip(blips[v], false)
                            local pVeh = GetVehiclePedIsIn(pPed, false)
                            SetBlipRotation(blips[v], math.ceil(GetEntityHeading(pVeh)))

                            if DecorExistOn(pVeh, "esc_siren_enabled") or IsPedInAnyPoliceVehicle(pPed) then
                                SetBlipSprite(blips[v], 56)
                                SetBlipColour(blips[v], 68)
                            else
                                SetBlipSprite(blips[v], 227)
                                SetBlipColour(blips[v], 0)
                            end
                        else
                            ShowHeadingIndicatorOnBlip(blips[v], true)
                            HideNumberOnBlip(blips[v])
                        end
                    end
				end
				Wait(500)
			end
		end)
	end
end

function calcMoyenne(report_count, report_notes)
    if report_count and report_notes and tonumber(report_count) ~= 0 and tonumber(report_notes) then
        local moyenne = tonumber(report_notes) / tonumber(report_count) + 0.0
        return string.format("%.1f", moyenne)
    else
        return 0.0
    end
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength) -- Function KeyboardInput on screen
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(10)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

RegisterNetEvent('YveltAdmin:SetEntityAtCoords')
AddEventHandler('YveltAdmin:SetEntityAtCoords', function(pos)
    SetEntityCoords(PlayerPedId(), pos)
end)

RegisterNetEvent('Yvelt:ReciveInventoryPlayer')
AddEventHandler('Yvelt:ReciveInventoryPlayer', function(table)
    adminInventory = table
end)

function repairVeh(veh)
    netId = NetworkGetNetworkIdFromEntity(veh)
    TriggerServerEvent("Yvelt:VehicleActionServer", 'repair', netId)
end

function gazVeh(veh)
    netId = NetworkGetNetworkIdFromEntity(veh)
    TriggerServerEvent("Yvelt:VehicleActionServer", 'gaz', netId)
end

function retournerVeh(veh)
    netId = NetworkGetNetworkIdFromEntity(veh)
    TriggerServerEvent("Yvelt:VehicleActionServer", 'retourner', netId)
end

function plateVeh(veh, arg1)
    netId = NetworkGetNetworkIdFromEntity(veh)
    TriggerServerEvent("Yvelt:VehicleActionServer", 'plate', netId, arg1)
end

function deleteVeh(veh)
    netId = NetworkGetNetworkIdFromEntity(veh)
    TriggerServerEvent("Yvelt:VehicleActionServer", 'del', netId)
end

RegisterNetEvent('Yvelt:ReceiveReportsList')
AddEventHandler('Yvelt:ReceiveReportsList', function(table)
    Reports = table
    ReportsInfos.Waiting = 0
    ReportsInfos.Taked = 0

    for k, v in pairs(Reports) do
        if v.state == 'waiting' then
            ReportsInfos.Waiting = ReportsInfos.Waiting + 1
        elseif v.state == 'taked' then
            ReportsInfos.Taked = ReportsInfos.Taked + 1
        end
    end
end)

RegisterNetEvent('Yvelt:reciveActionVeh')
AddEventHandler('Yvelt:reciveActionVeh', function(action, veh, arg1)
    local target = NetworkGetEntityFromNetworkId(veh)
    if action == 'del' then
        SetEntityAsMissionEntity(target, false, false)
        DeleteEntity(target)
    elseif action == 'plate' then
        SetVehicleNumberPlateText(target, arg1)
    elseif action == 'gaz' then
        SetVehicleFuelLevel(target, 200.0)
    elseif action == 'retourner' then
        local pos = GetEntityCoords(target)
        SetEntityCoords(target, pos)
    elseif action == 'flip' then
    elseif action == 'clean' then
        SetVehicleDirtLevel(target, 0.1)
    elseif action == 'repair' then
        FixVehicleWindow(target, 0)
        SetVehicleFixed(target)
        SetVehicleDirtLevel(target, 0.0)
        SetVehicleUndriveable(target, false)
        SetVehicleEngineOn(target, true, true)
        SetVehicleEngineHealth(target, 1000.0)
        SetVehiclePetrolTankHealth(target, 1000.0)
        SetVehicleBodyHealth(target, 1000.0)
    end
end)