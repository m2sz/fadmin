YveltHelper = {} --- Ne pas toucher, don't touch
YveltHelper.staffsInfos = {} --- Ne pas toucher, don't touch
YveltHelper.staffsActive = {} --- Ne pas toucher, don't touch

YveltAction = {Index = 1, 'Réanimer', 'Soigner'}
YveltTeleportation = {'Aller vers', 'Ramener', 'Renvoyer'}
YveltRechercheSys = {'Pseudo', 'ID', 'Métier', 'ID Unique'}
YveltRechercheSysIndex = 1
YveltRecherche = 1
YveltRechercheEcrit = nil
YveltShowInZone = false
YveltShowStaff = false
YveltGestinventory = {'Prendre', 'Supprimer'}
LettresItems = {'Tous', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}
LettresItemsIndex = 1

YVELT = YVELT or {}
YVELT.GamerTags = YVELT.GamerTags or {}

ghostList = ghostList or {}

gamerTags = gamerTags or {}
local lastPlayersListFetch = 0

--- Modifier les couleurs utilisé par les gamertags (Affichage des pseudos)
--- Documentation : https://docs.fivem.net/docs/game-references/hud-colors/
YveltHelper.colorsNames = {
    ["red"] = 6,
    ["orange"] = 148,
    ["yellow"] = 147,
    ["green"] = 30,
    ["blue"] = 26,
    ["purple"] = 49,
    ["gray"] = 62,
    ["white"] = 59,
    ["black"] = 2,
    ["pink"] = 30,
}

YveltHelper.colorsNames["bleu"] = YveltHelper.colorsNames["blue"]
YveltHelper.colorsNames["vert"] = YveltHelper.colorsNames["green"]
YveltHelper.colorsNames["jaune"] = YveltHelper.colorsNames["yellow"]
YveltHelper.colorsNames["rouge"] = YveltHelper.colorsNames["red"]
YveltHelper.colorsNames["gris"] = YveltHelper.colorsNames["gray"]
YveltHelper.colorsNames["blanc"] = YveltHelper.colorsNames["white"]
YveltHelper.colorsNames["noir"] = YveltHelper.colorsNames["black"]
YveltHelper.colorsNames["rose"] = YveltHelper.colorsNames["pink"]
YveltHelper.colorsNames["fondateur"] = YveltHelper.colorsNames["purple"]

local textColorToName = {
    ["~r~"] = "red",
    ["~o~"] = "orange",
    ["~y~"] = "yellow",
    ["~g~"] = "green",
    ["~b~"] = "blue",
    ["~p~"] = "purple",
    ["~m~"] = "gray",
    ["~c~"] = "gray",
    ["~s~"] = "white",
    ["~u~"] = "black",
}

function YveltHelper:resolveHudColor(rankColor, rankName)
    if type(rankColor) == "number" then
        return rankColor
    end

    if type(rankColor) == "string" then
        local trimmed = rankColor:gsub("%s+", "")
        local lower = string.lower(trimmed)
        local textCode = lower:match("~%a~")
        -- Accept hex colors like "#cfbe83" or "cfbe83"
        local hex = lower:match("#?%x%x%x%x%x%x")
        if hex then
            hex = hex:gsub("#", "")
            local dec = tonumber(hex, 16)
            if dec then
                return dec
            end
        end
        if textCode and textColorToName[textCode] then
            return self.colorsNames[textColorToName[textCode]]
        end
        local numeric = tonumber(lower)
        if numeric then
            return numeric
        end
        if self.colorsNames[lower] then
            return self.colorsNames[lower]
        end
    end

    if rankName then
        local name = string.lower(tostring(rankName))
        if self.colorsNames[name] then
            return self.colorsNames[name]
        end
    end

    return nil
end

-- Convertit un hex "RRGGBB" ou "#RRGGBB" en composants 0-255
function YveltHelper:hexToRGB(hex)
    if not hex then return nil end
    local h = tostring(hex):gsub('#','')
    if #h ~= 6 then return nil end
    local r = tonumber(h:sub(1,2), 16)
    local g = tonumber(h:sub(3,4), 16)
    local b = tonumber(h:sub(5,6), 16)
    if r and g and b then
        return r, g, b
    end
    return nil
end

-- Dessine un petit carré coloré (utilisé pour forcer l'affichage des couleurs hex dans les menus)
function YveltHelper:drawColorBox(centerX, centerY, width, height, hex)
    local r,g,b = self:hexToRGB(hex)
    if not r then return end
    -- DrawRect prend les valeurs r,g,b 0-255
    DrawRect(centerX, centerY, width, height, r, g, b, 255)
end

function YveltHelper:drawText3D(coords, text, hexColor, scale)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then return end

    local camCoords = GetGameplayCamCoords()
    local dist = #(coords - camCoords)
    local finalScale = (scale or 0.30) / math.max(dist, 1.0) * 2.0

    local r, g, b = 255, 255, 255
    if hexColor then
        local rr, gg, bb = self:hexToRGB(hexColor)
        if rr then
            r, g, b = rr, gg, bb
        end
    end

    SetTextScale(0.0, finalScale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(r, g, b, 255)
    SetTextCentre(true)
    SetTextOutline()
    SetTextDropShadow(1, 0, 0, 0, 120)
    SetTextColour(r, g, b, 255)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

if type(Separator) ~= "function" then
    function Separator(text)
        return RageUI.Separator(YveltConfig.ColorMenu..'↓~s~ '..text..' '..YveltConfig.ColorMenu..'↓')
    end
end

function YveltHelper:showHudInfos()
    if type(boolHudInfos) == "function" then
        boolHudInfos()
    end
end

--- Permet de faire une action client lorsque le mode modération devient activé
function YveltHelper:onStaffModeON()
    TriggerEvent('Yvelt:onStaffMode', true, playerGroup)
    if YveltConfig.staffActive.setPed then
        local model = YveltConfig.staffActive.ped
        if IsModelInCdimage(model) and IsModelValid(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
        end
    end
    if YveltConfig.staffActive.showInfos then
        adminHud = true
        YveltHelper:showHudInfos()
    end
    if YveltConfig.staffActive.showGamertags then
        adminPseudo = true
        YveltHelper:displayNames(true)
    end
    if YveltConfig.staffActive.showBlips then
        adminShowBlipsPlayers = true
        adminBlips()
    end
    if YveltConfig.staffActive.staffSkin then
        applySkin(playerGroup)
    end
    if YveltConfig.UseStaffGun then
        delGunStaffActive = true
        local Player = PlayerPedId()
        GiveWeaponToPed(Player, YveltConfig.StaffGunName, 255, false, true)
        GiveWeaponComponentToPed(Player, YveltConfig.StaffGunName, "COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE")
        GiveWeaponComponentToPed(Player, YveltConfig.StaffGunName, "COMPONENT_AT_PI_SUPP_02")
        GiveWeaponComponentToPed(Player, YveltConfig.StaffGunName, "COMPONENT_SNSPISTOL_MK2_CLIP_02")
        GiveWeaponComponentToPed(Player, YveltConfig.StaffGunName, "COMPONENT_AT_PI_RAIL_02")
        GiveWeaponComponentToPed(Player, YveltConfig.StaffGunName, "COMPONENT_AT_PI_FLSH_03")
        SetPedInfiniteAmmo(Player, true, YveltConfig.StaffGunName)
        boolStaffGun()
    end
end


--- Permet de faire une action client lorsque le mode modération devient désactivé
function YveltHelper:onStaffModeOFF()
    TriggerEvent('Yvelt:onStaffMode', false, playerGroup)
    if YveltConfig.staffActive.setPed then
        Callback.triggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            local isMale = skin.sex == 0
            Callback.triggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end) 
    end
    if YveltConfig.UseStaffGun then
        delGunStaffActive = false
        local Player = PlayerPedId()
        SetPedInfiniteAmmo(Player, false, YveltConfig.StaffGunName)
        RemoveWeaponFromPed(Player, YveltConfig.StaffGunName)
    end
    if YveltConfig.staffActive.staffSkin then
        resetSkin()
    end
end

--- Permet de revive une personne (client)
---@param a number ID Temporaire d'un joueur
function YveltHelper:revivePlayer(targetId, playerName)
    if YveltHelper:getAcces(player, 'revive') then
        ExecuteCommand('revive '..targetId)
        local embed = {
            title = 'Revive',
            description = '**Action :** `Revive`\n**Joueur : ** `'..playerName..'` (ID : `'..targetId..'` | UID : `'..UID:getUIDfromID(targetId)..'`)\n**Staff : ** `'..GetPlayerName(PlayerId())..'` (ID : `'..GetPlayerServerId(PlayerId())..'` | UID : `'..UID:getUIDfromID(GetPlayerServerId(PlayerId()))..'`)',
            color = 16777215,
            webhook = 'actions',
        }
        TriggerServerEvent('Yvelt:sendLogsOnDiscord', embed)
    else
        YveltHelper:clientNotification('~r~Vous n\'avez pas la permission')
    end
end

--- Permet de heal une personne (client)
---@param a number ID Temporaire d'un joueur
function YveltHelper:healPlayer(targetId, playerName)
    if YveltHelper:getAcces(player, 'heal') then
        ExecuteCommand('heal '..targetId)
        local embed = {
            title = 'Heal',
            description = '**Action :** `Heal`\n**Joueur : ** `'..playerName..'` (ID : `'..targetId..'` | UID : `'..UID:getUIDfromID(targetId)..'`)\n**Staff : ** `'..GetPlayerName(PlayerId())..'` (ID : `'..GetPlayerServerId(PlayerId())..'` | UID : `'..UID:getUIDfromID(GetPlayerServerId(PlayerId()))..'`)',
            color = 16777215,
            webhook = 'actions',
        }
        TriggerServerEvent('Yvelt:sendLogsOnDiscord', embed)
    else
        YveltHelper:clientNotification('~r~Vous n\'avez pas la permission')
    end
end

--- Permet de créer un véhicule (client)
function YveltHelper:spawnVehicle(modelName)
    if not IsModelInCdimage(modelName) then
        YveltHelper:clientNotification('~r~Ce véhicule n\'existe pas !')
    else
        local pos = GetEntityCoords(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        RequestModel(modelName)
        while not HasModelLoaded(modelName) do
            Wait(10)
        end 
        local vehicle = CreateVehicle(modelName, pos, heading, true, false)
        local id = NetworkGetNetworkIdFromEntity(vehicle)
        SetNetworkIdCanMigrate(id, true)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleOnGroundProperly(vehicle)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetModelAsNoLongerNeeded(modelName)
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end
end

--- Permet d'avoir l'identifiant rockstar d'un joueur
---@param a number ID Temporaire d'un joueur
---@return string License du joueur avec l'ID indiqué en @param a 
function YveltHelper:getIdentifier(targetId)
    for k,v in ipairs(GetPlayerIdentifiers(targetId)) do
        if string.match(v, 'license:') then
            return v
        end
    end
    return nil
end

--- Permet d'afficher une notitication a un joueur (client)
---@param a string Texte affiché lors de la notification
function YveltHelper:clientNotification(text)
    ESX.ShowNotification(text)
end

--- Permet d'afficher une notitication a un joueur (server)
---@param a string Texte affiché lors de la notification
function YveltHelper:serverNotification(targetId, text)
    if targetId and targetId ~= 0 then
        local xPlayer = YveltHelper:getPlayerFromId(targetId)
        if xPlayer then
            TriggerClientEvent('esx:showNotification', xPlayer.source, text)
        end
    end
end

--- Permet de get le joueur grâce a ESX avec son ID Temporaire
---@param a number ID Temporaire d'un joueur
function YveltHelper:getPlayerFromId(targetId)
    local GetPlayerFromId = ESX.GetPlayerFromId(targetId)
    return GetPlayerFromId
end

--- Permet de get le joueur grâce a ESX avec sa license rockstar (=> YveltHelper.getIdentifier)
---@param a number ID Temporaire d'un joueur
function YveltHelper:getPlayerFromIdentifier(targetId)
    local GetPlayerFromIdentifier = ESX.GetPlayerFromIdentifier(targetId)
    return GetPlayerFromIdentifier
end

--- Permet de refresh les ID uniques coté client
function YveltHelper:getUniqueId()
    while true do
        Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent('YveltAdmin:GetInfoUniqueId')
            break
        end
    end
end

--- Permet d'obtenir le pseudo d'un joueur
---@param a number ID Temporaire d'un joueur
function YveltHelper:getPlayerName(targetId)
    if targetId == 0 then
        return 'Console'
    else
        return GetPlayerName(targetId) or 'Inconnue'
    end
end

--- Permet d'avoir la liste des items (requires : name, label)
function YveltHelper:getItemList()
    local items = nil
    MySQL.Async.fetchAll('SELECT * FROM items', {}, function(results)
		items = results
    end)
    while not items do
        Wait(1)
    end
    return items
end

--- Permet d'avoir le power de X rank
exports('checkPerms', checkPerms)
checkPerms = function(perm)
    return YveltHelper:getAcces(player, perm)
end

--- Permet de savoir si X rank a accès ou non a X perm
exports('checkPower', checkPower)
checkPower = function(perm)
    return YveltHelper:getPower(player)
end

--- Permet de savoir si le joueur a le mode staff d'activé ou non (Client)
getStaffMode = function()
    return YveltStaffMode
end

--- Permet d'avoir le power de X rank
---@param a table Rank du joueur
function YveltHelper:getPower(rank)
    if rank.power == 'user' then
        return 0
    elseif rank.power == 'fondateur' then
        return 100
    else
        local power = rank.power
        if power then
            return power
        else
            Callback.triggerServerCallback('YveltAdmin:getRank', function(group)
                playerGroup = group
                player = playerGroup
            end)
            while playerGroup == nil do
                Wait(1)
            end
            rank = player
            if rank.power == 'user' then
                return 0
            elseif rank.power == 'fondateur' then
                return 100
            else
                local power = rank.power
                if power then
                    return power
                end
            end
        end
    end
end

--- Permet de savoir si X rank a accès ou non a X perm
---@param a table Rank du joueur
---@param b string La permission a check
function YveltHelper:getAcces(rank, request)
    if rank.rank == 'user' then
        return false
    elseif rank.rank == 'fondateur' then
        return true
        else
        local perms = (type(rank.perms) == 'string' and j.decode(rank.perms) or rank.perms) or {}
        local check = tostring(request)
        if perms then
            return perms[check]
        else
            Callback.triggerServerCallback('YveltAdmin:getRank', function(group)
                playerGroup = group
                player = playerGroup
            end)
            while playerGroup == nil do
                Wait(1)
            end
            rank = player
            if rank.rank == 'user' then
                return false
            elseif rank.rank == 'fondateur' then
                return true
                else
                local perms = (type(rank.perms) == 'string' and j.decode(rank.perms) or rank.perms) or {}
                local check = tostring(request)
                if perms[check] then
                    return perms[check]
                end
            end
        end
    end
end

--- Permet d'affciher les pseudos et informations des joueurs
---@param a boolean Activer la boucle
function YveltHelper:displayNames(bool)
    isNameShown = bool
    _cacheGamertags = {}
    if isNameShown then
        CreateThread(function()
            while isNameShown do
                local now = GetGameTimer()
                if now - lastPlayersListFetch > 5000 then
                    lastPlayersListFetch = now
                    Callback.triggerServerCallback('YveltAdmin:stafflist', function(players, activeStaff)
                        PlayersList = players or {}
                        YveltHelper.staffsActive = activeStaff or {}
                    end)
                end
                PlayersList = PlayersList or {}
                local playerPos = GetEntityCoords(PlayerPedId())
                local _players = GetActivePlayers()
                for _, player in pairs(_players) do
                    local ped = GetPlayerPed(player)
                    -- if ped ~= PlayerPedId() then
                        if #(playerPos - GetEntityCoords(ped)) < 100.0 then
                            local playerRank = ''
                            local shadowMode = false
                            local playerEntry = PlayersList['id:'..GetPlayerServerId(player)]
                            if playerEntry then
                                shadowMode = playerEntry.shadow
                                if playerEntry.rankLabel then
                                    playerRank = playerEntry.rankLabel
                                end
                            end
                            
                            if not shadowMode then

                                local name
                                if playerEntry then
                                    name = ('%s - %s | %s'):format(playerEntry.uid or '?', GetPlayerServerId(player) or '?', playerEntry.name or GetPlayerName(player) or 'Chargement...')
                                else
                                    name = ('%s'):format(GetPlayerName(player) or 'Chargement...')
                                end
                                if name ~= _cacheGamertags[player] then
                                    _cacheGamertags[player] = name
                                    if gamerTags[player] then
                                        RemoveMpGamerTag(gamerTags[player])
                                        Wait(100)
                                    end
                                end
                                gamerTags[player] = CreateFakeMpGamerTag(ped, '', false, false, '', 0)

                                SetMpGamerTagAlpha(gamerTags[player], 0, 255)
                                SetMpGamerTagAlpha(gamerTags[player], 2, 255)
                                SetMpGamerTagAlpha(gamerTags[player], 4, 255)
                                SetMpGamerTagAlpha(gamerTags[player], 7, 255)
                                SetMpGamerTagVisibility(gamerTags[player], 0, true)
                                SetMpGamerTagVisibility(gamerTags[player], 2, true)
                                SetMpGamerTagVisibility(gamerTags[player], 4, NetworkIsPlayerTalking(player))
                                SetMpGamerTagVisibility(gamerTags[player], 8, GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1))
                                SetMpGamerTagVisibility(gamerTags[player], 7, DecorExistOn(ped, "staffl") and DecorGetInt(ped, "staffl") > 0)
                                SetMpGamerTagColour(gamerTags[player], 7, 55)
                                if playerEntry then
                                    if playerEntry.staffmode then
                                        SetMpGamerTagVisibility(gamerTags[player], 14, true)
                                        if playerEntry.npd then
                                            SetMpGamerTagVisibility(gamerTags[player], 19, true)
                                        else
                                            SetMpGamerTagVisibility(gamerTags[player], 19, false)
                                        end
                                    else
                                        SetMpGamerTagVisibility(gamerTags[player], 14, false)
                                    end

                                    if playerEntry.isAfk then
                                        SetMpGamerTagVisibility(gamerTags[player], 6, true)
                                    else
                                        SetMpGamerTagVisibility(gamerTags[player], 6, false)
                                    end
                                end

                                if NetworkIsPlayerTalking(player) then
                                    -- SetMpGamerTagHealthBarColour(gamerTags[player], 1)
                                    SetMpGamerTagColour(gamerTags[player], 4, 141)
                                    SetMpGamerTagHealthBarColour(gamerTags[player], 141)
                                    -- SetMpGamerTagColour(gamerTags[player], 0, 1)
                                else
if playerEntry then
    local rankColorId = YveltHelper:resolveHudColor(playerEntry.rankColor, playerEntry.rankName)
    local serverId = GetPlayerServerId(player)
    local isGhost = (ghostList and ghostList[serverId] == true) or (playerEntry and playerEntry.shadow == true)
    local colorId = isGhost and 59 or rankColorId or 0
    SetMpGamerTagHealthBarColour(gamerTags[player], 0)
    SetMpGamerTagColour(gamerTags[player], 4, colorId)
    SetMpGamerTagColour(gamerTags[player], 0, colorId)
    local headCoords = GetEntityCoords(ped)
    local rankText = playerEntry.rankLabel or ''
    local rankHex = isGhost and 'ffffff' or (type(playerEntry.rankColor) == 'string' and playerEntry.rankColor or 'ffffff')
    local fullText = rankText ~= '' and (name .. ' ' .. rankText) or name
    YveltHelper:drawText3D(vector3(headCoords.x, headCoords.y, headCoords.z + 1.05), fullText, rankHex, 0.55)
                                    else
                                        SetMpGamerTagHealthBarColour(gamerTags[player], 0)
                                        SetMpGamerTagColour(gamerTags[player], 4, 0)
                                        SetMpGamerTagColour(gamerTags[player], 0, 0)
                                    end
                                end
                            end
                        else
                            RemoveMpGamerTag(gamerTags[player])
                            gamerTags[player] = nil
                        end
                    -- end
                end
                Wait(0)
            end
            for k,v in pairs(gamerTags) do
                RemoveMpGamerTag(v)
            end
            gamerTags = {}
        end)
    end
end

function YveltHelper:getJob(targetId)
    if YveltConfig.UseJob1 then
        if targetId and targetId ~= 0 then
            local xPlayer = YveltHelper:getPlayerFromId(targetId)
            if xPlayer then
                return xPlayer.getJob()
            end
        end
    else
        return {label = 'Inconnu', name = 'Inconnu'}
    end
end

function YveltHelper:getJob2(targetId)
    if YveltConfig.UseJob2 then
        if targetId and targetId ~= 0 then
            local xPlayer = YveltHelper:getPlayerFromId(targetId)
            if xPlayer then
                return xPlayer.getJob2()
            end
        end
    else
        return {label = 'Inconnu', name = 'Inconnu'}
    end
end

function YveltHelper:addItem(targetId, item, count)
    local xPlayer = YveltHelper:getPlayerFromId(targetId)
    return xPlayer.addInventoryItem(item, count)
end

function YveltHelper:removeItem(targetId, item, count)
    local xPlayer = YveltHelper:getPlayerFromId(targetId)
    return xPlayer.removeInventoryItem(item, count)
end

function YveltHelper:getPlayerInventory(targetId)
    local xPlayer = YveltHelper:getPlayerFromId(targetId)
    local table = xPlayer.getInventory()
    local table2 = xPlayer.getLoadout()
    return table, table2
end

--- Permet de send un webhook
---@param a number ID Temporaire d'un joueur
function YveltHelper:sendWebhook(table)
    if YveltLogs.Enable then
        local webhookUrl = YveltLogs.LogsWebhook[table.webhook]
        if webhookUrl then
            local date = os.date("%d")..'/'..os.date("%m")..'/'..os.date("%Y")..' à '..os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes'
            local embed = {
                {
                    ["title"] = table.title or 'Aucun titre',
                    ["description"] = table.description or 'Aucune description',
                    ["type"] = "rich",
                    ["color"] = table.color or '#ed4245',
                    ["footer"] = {
                        ["text"] = YveltConfig.ServerTitle..'・'..date,
                    },
                }
            }

            local jsonData = json.encode({embeds = embed})
            PerformHttpRequest(webhookUrl, function(statusCode, text, headers)
                if statusCode == 204 then
                    print("Message avec embed envoyé avec succès au webhook!")
                else
                    print("Erreur lors de l'envoi du message au webhook - Code de statut : " .. statusCode)
                end
            end, "POST", jsonData, {["Content-Type"] = "application/json"})
        else
            print('ERREUR : webhookUrl n\'exiset pas !')
        end
    end
end

function YveltHelper:getTextFromAscii(ascii)
    local string = ""

    for k, v in ipairs(ascii) do
        string = string .. string.char(v)
    end

    return string
end