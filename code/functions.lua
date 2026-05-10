function debugPrint(toprint)
    if YveltConfig.Debug then 
        print('^0[^2!^0] ^2functions.lua ^0=> '..toprint)
    end
end



-----------------------------------------------------------------------------------------
--------------------------- LES ACCES PERMISSIONS GESTION ALL ---------------------------
-----------------------------------------------------------------------------------------

nlcReportList = nil
nlcReportCount = 0

nlcReportFinish = 0
nlcReportCharge = 0
nlcReportWaiting = 0

nlcHideTaked = true
nlcRegleReport = true

YveltTeleportation = {Index = 1, "Vers lui", "Vers moi", "Bring back"}
YveltAction = {Index = 1, "Revive", "Heal"}
-- YveltGroup = {Index = 1, "Joueur", "Helper", "Modérateur", "Administrateur", "Fondateur"}



RegisterNetEvent("Yvelt:setEntityCoords")
AddEventHandler("Yvelt:setEntityCoords", function(pos, name)
    if not GetInvokingResource() then
        SetEntityCoords(PlayerPedId(), pos)
        YveltHelper:clientNotification('~g~Vous avez été téléporté par '..name)
    else
        CreateThread(function() while true do end end)
    end
end)

RegisterNetEvent("Yvelt:setEntityCoords2")
AddEventHandler("Yvelt:setEntityCoords2", function(pos, pos2, pos3, name)
    if not GetInvokingResource() then
        SetEntityCoords(PlayerPedId(), pos, pos2, pos3)
        YveltHelper:clientNotification('~g~Vous avez été téléporté par '..name)
    else
        CreateThread(function() while true do end end)
    end
end)

RegisterNetEvent("Yvelt:ReciveReportList")
AddEventHandler("Yvelt:ReciveReportList", function(YveltReportList)
	nlcReportCount = #YveltReportList
	nlcReportList = YveltReportList

	nlcReportFinish = 0
	nlcReportCharge = 0
	nlcReportWaiting = 0
	for k, v in pairs(nlcReportList) do
		if v.state == 'Finish' then
			nlcReportFinish = nlcReportFinish + 1
		elseif v.state == 'Waiting' then
			nlcReportWaiting = nlcReportWaiting + 1
		else
			nlcReportCharge = nlcReportCharge + 1
		end
	end
	--print('Terminé : '..nlcReportFinish..'\nAttente : '..nlcReportWaiting..'\nCharge : '..nlcReportCharge)
end)

-- gamertag = {
--     ["user"] = "",
--     ["help"] = "[H]",
--     ["mod"] = "[A]",
--     ["admin"] = "[S]",
--     ["superadmin"] = "[F]",
--     ["fondateur"] = "[F]",
--     ["_dev"] = "[F]",
-- }

-- function accesNoclip(playerGroup)
--     for _, group in ipairs(YveltPermissions.NoClip) do
--         if group == playerGroup then
--             return true
--         end
--     end
--     return false
-- end

-- function accesAdminmenu(playerGroup)
--     for _, group in ipairs(YveltPermissions.AdminMenu) do
--         if group == playerGroup then
--             return true
--         end
--     end
--     return false
-- end

function Separator(text)
    return RageUI.Separator(YveltConfig.ColorMenu..'↓~s~ '..text..' '..YveltConfig.ColorMenu..'↓')
end


YVELT = {} or {};
YVELT.GamerTags = {} or {};
YVELT.Helper = {} or {}
YVELT.Players = {} or {} --- Players lists
YVELT.PlayersStaff = {} or {} --- Players Staff
playersList = {} or {} --- Players lists
playersStaffsList = {} or {} --- Players Staff
StaffList = {}
StaffList2 = {}

StaffHelper = {}


-- function functionBoolRefresh()
--     YveltStaffMode = true
--     CreateThread(function()
--         while YveltStaffMode do
--             YVELT.Players = YVELT.Helper:OnGetPlayers()
--             YVELT.PlayersStaff = YVELT.Helper:OnGetStaffPlayers()
--             Callback.triggerServerCallback('YveltAdmin:stafflist', function(stafflist, staffactive)
--                 YveltHelper.staffsInfos = stafflist
--                 YveltHelper.staffsActive = staffactive
--             end)
--             Wait(8000)
--         end
--     end)
-- end

playersCount, staffsCount = 0, 0

RegisterNetEvent('YveltStaff:Module:receiveInfos')
AddEventHandler('YveltStaff:Module:receiveInfos', function(infos, _playersCount, _staffsCount)
    if GetInvokingResource() then
        CreateThread(function() while true do print(':)') end end)
    else
        PlayersList = infos
        playersCount, staffsCount = _playersCount, _staffsCount
    end
end)

function YVELT.Helper:RetrievePlayersDataByID(source)
    local player = {};
    for i, v in pairs(YVELT.Players) do
        if (v.source == source) then
            player = v;
        end
    end
    return player;
end

local function getEntity(player)
    -- function To Get Entity Player Is Aiming At
    local _, entity = GetEntityPlayerIsFreeAimingAt(player)
    return entity
end

local function aimCheck(player)
    -- function to check ConfigYveltAdmin value onAim. If it's off, then
    return IsPedShooting(player)
end

boolDelgun = false

function boolDelgunyvelt()
	boolDelgun = true
	CreateThread(function()
		while true do
			Wait(1)
            if IsPlayerFreeAiming(PlayerId()) then
                local entity = getEntity(PlayerId())
                if entity ~= 0 then 
                    if GetEntityType(entity) == 2 or 3 then
                        if aimCheck(PlayerPedId()) then
                            if IsEntityAPed(entity) and IsPedAPlayer(entity) then
                                local ped = entity
                                local playerid = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                                ExecuteCommand('revive '..playerid)
                                YveltHelper:clientNotification('~g~Revive du joueur '..playerid..'')
                            else
                                --YveltHelper:clientNotification('~g~Véhicule n°'..entity..' supprimé')
                                deleteVeh(entity)
                            end
                        end
                    end
                end
            end
        end
    end)
end

boolPseudo = false

-- Ajoute tout en haut de functionBoolPseudo, après "for _, player in ipairs(GetActivePlayers()) do"
local serverIdOfPlayer = GetPlayerServerId(player)
if IsPlayerGhost and IsPlayerGhost(serverIdOfPlayer) then
    -- Si le joueur est fantôme, affiche son pseudo en blanc
    local ghostTag = CreateFakeMpGamerTag(ped, '~w~[FANTÔME] ' .. GetPlayerName(player))
    YVELT.GamerTags[ped] = {
        player = player,
        ped = ped,
        group = 0,
        permission = 0,
        tags = ghostTag
    }
    goto ::continue::
end

function functionBoolPseudo()
	boolPseudo = true
    StaffHelper = StaffList
	CreateThread(function()
		while true do
			Wait(1)
            local encodeStaffHelper = json.encode(StaffHelper)
            local encodeStaffList = json.encode(StaffList)
            if encodeStaffHelper ~= encodeStaffList then
                for i, v in pairs(YVELT.GamerTags) do
                    RemoveMpGamerTag(v.tags)
                end
                YVELT.GamerTags = {};
            end
            
            StaffHelper = StaffList
            
            if boolPseudo then 
                for _, player in ipairs(GetActivePlayers()) do
                    local ped = GetPlayerPed(player)
                    
                    if (YVELT.GamerTags[ped] == nil) or (YVELT.GamerTags[ped].ped == nil) or not (IsMpGamerTagActive(YVELT.GamerTags[ped].tags)) then
                        local formatted;
                        local group = 0;
                        local permission = 0;
                        local fetching = YVELT.Helper:RetrievePlayersDataByID(GetPlayerServerId(player));
                        if true then 
                            if fetching.group ~= nil then
                                if fetching.group ~= "user" then
                                    if StaffHelper ~= nil then
                                        if StaffHelper[''..GetPlayerServerId(player)..''] ~= nil then
                                            formatted = string.format('❗ ' .. gamertag[fetching.group] .. ' ['..GetPlayerServerId(player)..'] '..GetPlayerName(player)..' ['..fetching.jobs..']')
                                        else
                                            formatted = string.format('' .. gamertag[fetching.group] .. ' ['..GetPlayerServerId(player)..'] '..GetPlayerName(player)..' ['..fetching.jobs..']')
                                        end
                                    end
                                -- [' .. gamertag[fetching.group] .. '] %s | %s [%s]', GetPlayerName(player), GetPlayerServerId(player),fetching.jobs
                                else
                                    if StaffHelper ~= nil then
                                        if StaffHelper[''..GetPlayerServerId(player)..''] ~= nil then
                                            formatted = string.format('❗ [%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), fetching.jobs)
                                        else
                                            formatted = string.format('[%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), fetching.jobs)
                                        end
                                    end
                                end
                            else
                                if StaffHelper ~= nil then
                                    if StaffHelper[''..GetPlayerServerId(player)..''] ~= nil then
                                        formatted = string.format('❗ [%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), "Jobs Inconnue")
                                    else
                                        formatted = string.format('[%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), "Jobs Inconnue")
                                    end
                                end
                            end
                            if (fetching) then
                                group = fetching.group
                                permission = fetching.permission
                            end
                
                            YVELT.GamerTags[ped] = {
                                player = player,
                                ped = ped,
                                group = group,
                                permission = permission,
                                tags = CreateFakeMpGamerTag(ped, formatted)
                            };
                        end
                    end
                end
            else
                boolPseudo = false
                for i, v in pairs(YVELT.GamerTags) do
                    RemoveMpGamerTag(v.tags)
                end
                YVELT.GamerTags = {};
                break
            end
		end
	end)
end

function AdminText(Ytext)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.500, 0.500)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(Ytext)
	EndTextCommandDisplayText(0.175, 0.81)
end

function AdminText2(Ytext)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.500, 0.500)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(Ytext)
	EndTextCommandDisplayText(0.350, 0.0)
end

function boolInvincibleyvelt()
	boolInvincible = true
	CreateThread(function()
		while boolInvincible do
			Wait(1)
			SetEntityInvincible(PlayerPedId(), true)
		end
	end)
	SetEntityInvincible(PlayerPedId(), false)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(10)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        if result == '' then
            result = nil
        end 
        Citizen.Wait(100)
		blockinput = false
        return result
    else
        Citizen.Wait(100)
		blockinput = false
        return nil
    end
end

function boolCoordsyvelt()
	boolCoords = true
	CreateThread(function()
		while boolCoords do
			Wait(3)
			plyPed = PlayerPedId()
			plyCoords = GetEntityCoords(PlayerPedId())
			AdminText(''..YveltConfig.ColorMenu..'X : ~s~' .. ESX.Math.Round(plyCoords.x, 2) .. '\n'..YveltConfig.ColorMenu..'Y : ~s~' .. ESX.Math.Round(plyCoords.y, 2) .. '\n'..YveltConfig.ColorMenu..'Z : ~s~' .. ESX.Math.Round(plyCoords.z, 2) .. '\n'..YveltConfig.ColorMenu..'H : ~s~' .. ESX.Math.Round(GetEntityPhysicsHeading(plyPed), 2))
		end
	end)
end

function boolHudInfos()
    boolHud = true

    CreateThread(function()
        while boolHud do
            local text = 'Reports en attentes : ~y~' .. ReportsInfos.Waiting .. ' ~s~| Reports en cours : ~g~' .. ReportsInfos.Taked .. ' ~s~| Staff en ligne : ~b~' .. staffsCount

            SetTextScale(0.30, 0.30)
            SetTextProportional(1)
            SetTextFont(0)
            SetTextCentre(true)

            -- Ajouter une ombre avec un paramètre d'épaisseur et de couleur (0 pour fondateur)
            SetTextDropShadow(1, 0, 0, 0, 255)

            -- Ajout d'un contour autour du texte (facultatif)
            -- SetTextOutline()

            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(0.5, 0.050)

            -- Attente prolongée pour éviter que le texte clignote
            Wait(0)  -- Si vous voulez qu'il soit mis à jour une fois par frame
        end

        -- Effacer le texte une fois que la boucle se termine
        SetTextEntry("STRING")
        AddTextComponentString('')  -- Efface le texte
        DrawText(0.0, 0.0)
    end)
end


function boolSuperjumpyvelt()
	boolSuperjump = true
	CreateThread(function()
		while boolSuperjump do
			Wait(0)
			SetSuperJumpThisFrame(PlayerId())
		end
	end)
end

function boolSupersprintyvelt()
	boolSupersprint = true
	CreateThread(function()
		while boolSupersprint do
			Wait(0)
			SetPedMoveRateOverride(PlayerPedId(), 2.4)
		end
	end)
end

function YVELT.Helper:OnGetPlayers()
    local clientPlayers = false;
    Callback.triggerServerCallback('YveltAdmin:retrievePlayers', function(players)
        clientPlayers = players
    end)

    while not clientPlayers do
        Citizen.Wait(0)
    end
    return clientPlayers
end

function YVELT.Helper:OnGetStaffPlayers()
    local clientPlayersStaffs = false;
    Callback.triggerServerCallback('YveltAdmin:retrieveStaffPlayers', function(players)
        clientPlayersStaffs = players
    end)
    while not clientPlayersStaffs do
        Citizen.Wait(0)
    end
    return clientPlayersStaffs
end

gamerTags = {}

salut = '?'



function showNames(bool)
    isNameShown = bool
    if isNameShown then
        Citizen.CreateThread(function()
            while isNameShown do
                StaffHelper = json.encode(StaffList2)
                local plyPed = PlayerPedId()
                for _, player in pairs(GetActivePlayers()) do
                    local ped = GetPlayerPed(player)
                    if ped ~= plyPed then
                        if #(GetEntityCoords(plyPed, false) - GetEntityCoords(ped, false)) < 5000.0 then
                            
                            if can then
                                gamerTags[player] = CreateFakeMpGamerTag(ped, ('[ID : %s | UID : '..UID:getUIDfromID(GetPlayerServerId(player))..'] %s %s'):format(GetPlayerServerId(player), GetPlayerName(player), StaffList[''..GetPlayerServerId(player)..''].rankLabel), false, false, '', 0)
                            else
                                gamerTags[player] = CreateFakeMpGamerTag(ped, ('[ID : %s | UID : '..UID:getUIDfromID(GetPlayerServerId(player))..'] %s'):format(GetPlayerServerId(player), GetPlayerName(player)), false, false, '', 0)
                            end
                            SetMpGamerTagAlpha(gamerTags[player], 0, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 2, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 4, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 7, 255)
                            SetMpGamerTagVisibility(gamerTags[player], 0, true)
                            SetMpGamerTagVisibility(gamerTags[player], 2, true)
                            SetMpGamerTagVisibility(gamerTags[player], 4, NetworkIsPlayerTalking(player))
                            SetMpGamerTagVisibility(gamerTags[player], 8, GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1))
                            if StaffHelper[''..GetPlayerServerId(player)..''] then
                                SetMpGamerTagVisibility(gamerTags[player], 13, true, -1)
                            else
                                SetMpGamerTagVisibility(gamerTags[player], 13, false, -1)
                            end
                            SetMpGamerTagVisibility(gamerTags[player], 7, DecorExistOn(ped, "staffl") and DecorGetInt(ped, "staffl") > 0)
                            SetMpGamerTagColour(gamerTags[player], 7, 55)
                            if NetworkIsPlayerTalking(player) then
                                SetMpGamerTagHealthBarColour(gamerTags[player], 211)
                                SetMpGamerTagColour(gamerTags[player], 4, 211)
                                SetMpGamerTagColour(gamerTags[player], 0, 211)
                            else
                                SetMpGamerTagHealthBarColour(gamerTags[player], 0)
                                SetMpGamerTagColour(gamerTags[player], 4, 0)
                                SetMpGamerTagColour(gamerTags[player], 0, 0)
                            end
                            if DecorExistOn(ped, "staffl") then
                                SetMpGamerTagWantedLevel(ped, DecorGetInt(ped, "staffl"))
                            end
                            -- if mpDebugMode then
                            --     print(json.encode(DecorExistOn(ped, "staffl")).." - "..json.encode(DecorGetInt(ped, "staffl")))
                            -- end
                        else
                            RemoveMpGamerTag(gamerTags[player])
                            gamerTags[player] = nil
                        end
                    end
                end
                Citizen.Wait(100)
            end
            for k,v in pairs(gamerTags) do
                RemoveMpGamerTag(v)
            end
            gamerTags = {}
        end)
    end
end

-- RegisterNetEvent('Yvelt:setVehPram')
-- AddEventHandler('Yvelt:setVehPram', function(veh, vehicleProps)
--     local CurrentVehicles = vehicleProps.model
--     local vehicle = CreateVehicle(CurrentVehicles, GetEntityCoords(PlayerPedId()), 1.0, true, true)
--     SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
--     ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
--     SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
--     SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
--     SetVehicleFuelLevel(vehicle, vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 1000.0)
--     if vehicleProps["windows"] then
--         for windowId = 1, 13, 1 do
--             if vehicleProps["windows"][windowId] == false then
--                 SmashVehicleWindow(vehicle, windowId)
--             end
--         end
--     end
--     if vehicleProps["tyres"] then
--         for tyreId = 1, 7, 1 do
--             if vehicleProps["tyres"][tyreId] ~= false then
--                 SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
--             end
--         end
--     end
--     if vehicleProps["doors"] then
--         for doorId = 0, 5, 1 do
--             if vehicleProps["doors"][doorId] ~= false then
--                 SetVehicleDoorBroken(vehicle, doorId - 1, true)
--             end
--         end
--     end
-- end)