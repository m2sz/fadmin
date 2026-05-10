CreateThread(function()
    if GetCurrentResourceName() ~= 'YveltAdmin' then
        if not YveltConfig.bypassRename then
            print('^1[WARNING] Vous ne pouvez pas modifier le nom de la ressource, il doit rester "YveltAdmin" !!^0')
            print('current name : '..GetCurrentResourceName())
            Wait(1000)
            print('^1[WARNING] Stopping ressource...^0') 
            ExecuteCommand('stop '..GetCurrentResourceName())
            StopResource(GetCurrentResourceName())
        end
    end
    if GetConvar("onesync_enabled", "false") == "true" then
        print("^0[^2!^0] ^2server.lua ^0=>^4 [CHECKER]^0 OneSync a été détecté, lancement de la ressource !")
    else
        if not YveltConfig.IgnoreOneSync then
            print('^1[WARNING] Vous avez besoin de "OneSync" d\'activé sur votre serveur pour que le script fonctionne correctement !^0')
            print('^1[WARNING] Vous avez besoin de "OneSync" d\'activé sur votre serveur pour que le script fonctionne correctement !^0')
            print('^1[WARNING] Vous avez besoin de "OneSync" d\'activé sur votre serveur pour que le script fonctionne correctement !^0')
            print('^1[WARNING] Vous avez besoin de "OneSync" d\'activé sur votre serveur pour que le script fonctionne correctement !^0')
            print('^1[WARNING] Vous avez besoin de "OneSync" d\'activé sur votre serveur pour que le script fonctionne correctement !^0')
        end
    end
end)

-- Vérifie l'existence de l'item staff dans la table `items` et tente de le créer si absent
Citizen.CreateThread(function()
    Wait(2000)
    local itemName = 'staff_pistol'
    if YveltConfig and YveltConfig.StaffItemName then itemName = YveltConfig.StaffItemName end
    local label = 'Pistolet staff'
    if MySQL and MySQL.Async and MySQL.Async.fetchAll then
        MySQL.Async.fetchAll('SELECT * FROM items WHERE name = @name', {['@name'] = itemName}, function(result)
            if not result or #result == 0 then
                print('^0[^1!^0] ^1server.lua ^0=> Item '..itemName..' introuvable dans la table `items`, tentative de création...')
                MySQL.Async.execute('INSERT INTO items (`name`,`label`) VALUES (@name,@label)', {['@name'] = itemName, ['@label'] = label}, function(rowsChanged)
                    if rowsChanged and rowsChanged > 0 then
                        print('^0[^2!^0] ^2server.lua ^0=> Item '..itemName..' créé avec succès dans la table `items`.')
                    else
                        print('^0[^1!^0] ^1server.lua ^0=> Échec création item '..itemName..' — ajoutez manuellement via SQL.')
                        print("SQL suggéré: INSERT INTO items (name, label) VALUES ('"..itemName.."', '"..label.."');")
                    end
                end)
            else
                print('^0[^2!^0] ^2server.lua ^0=> Item '..itemName..' trouvé dans la table `items`.')
            end
        end)
    else
        print('^0[^1!^0] ^1server.lua ^0=> MySQL non disponible, impossible de vérifier/créer l\'item staff_pistol')
    end
end)

function calcMoyenne(report_count, report_notes)
    if report_count and report_notes and tonumber(report_count) ~= 0 and tonumber(report_notes) then
        local moyenne = tonumber(report_notes) / tonumber(report_count) + 0.0
        return string.format("%.1f", moyenne)
    else
        return 0.0
    end
end

function debugPrint(toprint)
    if YveltConfig.Debug then 
        print('^0[^2!^0] ^2server.lua ^0=> '..toprint)
    end
end

RegisterCommand('annonce', function(source, args)
    local _src = source 
    local argument = table.concat(args, ' ', 1)
    if _src == 0 then
        TriggerClientEvent('Yvelt:displayWarnOnScreen', -1, 'Annonce', argument)
        print('^2Annonce effectuée : "'..argument..'" par '..YveltHelper:getPlayerName(targetId)..'^0')
    else
        if getAcces(PlayersRanks[YveltHelper:getIdentifier(_src)], 'annonce') then 
            TriggerClientEvent('Yvelt:displayWarnOnScreen', -1, 'Annonce', argument)
            print('^2Annonce effectuée : "'..argument..'" par '..YveltHelper:getPlayerName(targetId)..'^0')
        else
            YveltHelper:serverNotification(_src, '~r~Tu n\'as pas la permission !')
        end
    end
end)

---------------------------------------------------------------------------------------------------------------------

activeStaff = {}
ghostPlayers = ghostPlayers or {}
players = players or {}

---------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("YveltAdmin:giveItemToPlayer")
AddEventHandler("YveltAdmin:giveItemToPlayer", function(target, item, count)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    local xTarget = YveltHelper:getPlayerFromId(target)
    local idPlayer = target
    local staffName = GetPlayerName(source) or "Inconnu"  -- Utilisation de "Inconnu" si staffName est nil
    local staffUID = UID:getUIDfromID(source) or "Inconnu"  -- Utilisation de "Inconnu" si staffUID est nil
    local itemName = item or "Inconnu"  -- Utilisation de "Inconnu" si item est nil
    local itemCount = tonumber(count) or 1  -- Utilisation de 1 si count est nil ou invalide

    -- Vérification des droits du staff
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        local description = '**Action :** `give`\n**Item :** `'..itemName..'` (Quantité : `'..itemCount..'`)'

        -- Si le staff se donne l'item à lui-même
        if idPlayer == source then
            description = description..'\n**Joueur :** `à soi-même` (ID : `'..tonumber(source)..'` | UID : `'..staffUID..'`)\n**Staff :** `'..staffName..'` (ID : `'..tonumber(source)..'` | UID : `'..staffUID..'`)'
        else
            -- Sinon, si l'item est donné à un autre joueur
            description = description..'\n**Joueur :** `'..GetPlayerName(tonumber(idPlayer))..'` (ID : `'..tonumber(idPlayer)..'` | UID : `'..UID:getUIDfromID(tonumber(idPlayer))..'`)\n**Staff :** `'..staffName..'` (ID : `'..tonumber(source)..'` | UID : `'..staffUID..'`)'
        end

        -- Création de l'embed pour le webhook
        local embed = {
            title = 'Don d\'un item',
            description = description,
            color = 4838724,
            webhook = 'give',
        }

        -- Envoi du webhook
        YveltHelper:sendWebhook(embed)

        -- Ajouter l'item à l'inventaire du joueur cible
        if xTarget then
            YveltHelper:addItem(xTarget.source, item, itemCount)
        end
    end
end)

RegisterServerEvent("YveltAdmin:DeleteCustomTP")
AddEventHandler("YveltAdmin:DeleteCustomTP", function(idd)
    local xPlayer = YveltHelper:getPlayerFromId(source)

    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        MySQL.Async.execute('DELETE FROM yvelt_teleports WHERE id = @id', {
            ['@id'] = idd
        }, function(rowsChanged)

        end)
        YveltHelper:serverNotification(xPlayer.source, '~g~Téléportation unique supprimé (n°'..idd..')')
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:DeleteCustomTP\")")
    end
end)

RegisterServerEvent("YveltAdmi:CreateCustomTP")
AddEventHandler("YveltAdmi:CreateCustomTP", function(label, coords)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        MySQL.Async.execute('INSERT INTO yvelt_teleports (identifier, label, coords) VALUES (@identifier, @label, @coords)', {
            ['@identifier'] = YveltHelper:getIdentifier(xPlayer.source),
            ['@label'] = label,
            ['@coords'] = json.encode(coords),
        })
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:CreateCustomTP\")")
    end
end)

RegisterServerEvent("YveltAdmin:ChangeStaffMode")
AddEventHandler("YveltAdmin:ChangeStaffMode", function(state)
    local xPlayer = YveltHelper:getPlayerFromId(source)

    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        if state == 'on' then
            print("^0[^2!^0] ^2server.lua ^0=> Le staff ^4"..YveltHelper:getPlayerName(xPlayer.source).."^0 vient d'^2activer^0 son mode modération^0")
            activeStaff['id:'..source..''] = {
                rankLabel = '['..RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].label..']',
                rankColor = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].color,
                npd = false,
                shadow = false,
            }

            -- Notification uniquement pour le joueur qui active
            TriggerClientEvent('esx:showAdvancedNotification', source, 'Administration', YveltConfig.ColorMenu..'Mode modération', YveltConfig.ColorMenu..'Vous avez ~g~activé~s~ votre mode modération.', 'CHAR_BLIMP', 0)

            sendInfosToStaff(xPlayer.source)
            -- Filtre les fantômes pour les non-fondateurs/co-fondateurs
local filteredPlayers = {}
local isTopRank = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] and
    (PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank == 'noir' or
    PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank == 'fondateur')

for k, v in pairs(players) do
    if not ghostPlayers[v.source] or isTopRank then
        filteredPlayers[k] = v
    end
end
TriggerClientEvent('YveltStaff:Module:receiveInfos', xPlayer.source, filteredPlayers, playerCount, staffCount)

            local embed = {
                title = 'Mode staff activé',
                description = '**Action :** `staffmode`\n**Staff : ** `'..YveltHelper:getPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) **Statut : **`activé`',
                color = 4838724,
                webhook = 'staffmode',
            }
            YveltHelper:sendWebhook(embed)
            -- Donner l'item staff dans l'inventaire si configuré
            if YveltConfig.UseStaffGun and YveltConfig.StaffItemName then
                local itemName = YveltConfig.StaffItemName
                print('^0[^2!^0] ^2server.lua ^0=> Tentative d\'ajout de l\'item '..itemName..' à '..YveltHelper:getPlayerName(xPlayer.source)..' (ID:'..tostring(xPlayer.source)..')')
                local success = false
                -- Try ESX xPlayer.addInventoryItem
                local ok, err = pcall(function()
                    if ESX and ESX.GetPlayerFromId then
                        local xp = ESX.GetPlayerFromId(xPlayer.source)
                        if xp and xp.addInventoryItem then
                            xp.addInventoryItem(itemName, 1)
                            success = true
                        end
                    end
                end)
                if not ok then print('^1[ERROR] ESX addInventoryItem failed: '..tostring(err)) end

                -- Try exports.ox_inventory
                if not success then
                    ok, err = pcall(function()
                        if exports and exports.ox_inventory then
                            if exports.ox_inventory.AddItem then
                                exports.ox_inventory:AddItem(xPlayer.source, itemName, 1)
                                success = true
                            elseif exports.ox_inventory.addItem then
                                exports.ox_inventory:addItem(xPlayer.source, itemName, 1)
                                success = true
                            end
                        end
                    end)
                    if not ok then print('^1[ERROR] ox_inventory AddItem failed: '..tostring(err)) end
                end

                -- Try QBCore
                if not success then
                    ok, err = pcall(function()
                        if QBCore and QBCore.Functions and QBCore.Functions.GetPlayer then
                            local qp = QBCore.Functions.GetPlayer(xPlayer.source)
                            if qp and qp.Functions and qp.Functions.AddItem then
                                qp.Functions.AddItem(itemName, 1)
                                success = true
                            end
                        elseif exports and exports['qb-core'] and exports['qb-core'].GetPlayer then
                            local qp = exports['qb-core']:GetPlayer(xPlayer.source)
                            if qp and qp.Functions and qp.Functions.AddItem then
                                qp.Functions.AddItem(itemName, 1)
                                success = true
                            end
                        end
                    end)
                    if not ok then print('^1[ERROR] QBCore AddItem failed: '..tostring(err)) end
                end

                -- Try YveltHelper
                if not success then
                    ok, err = pcall(function()
                        if YveltHelper and YveltHelper.addItem then
                            YveltHelper:addItem(xPlayer.source, itemName, 1)
                            success = true
                        end
                    end)
                    if not ok then print('^1[ERROR] YveltHelper:addItem failed: '..tostring(err)) end
                end

                if success then
                    print('^0[^2!^0] ^2server.lua ^0=> Item '..itemName..' ajouté avec succès à '..YveltHelper:getPlayerName(xPlayer.source))
                else
                    print('^0[^1!^0] ^1server.lua ^0=> Échec ajout item '..itemName..', fallback: donner l\'arme au client')
                    TriggerClientEvent('YveltAdmin:ToggleStaffPistol', xPlayer.source)
                end
            end
        elseif state == 'off' then
            print("^0[^2!^0] ^2server.lua ^0=> Le staff ^4"..YveltHelper:getPlayerName(xPlayer.source).."^0 vient de ^1désactiver^0 son mode modération^0")
            activeStaff['id:'..source..''] = nil

            -- Notification uniquement pour le joueur qui désactive
            TriggerClientEvent('esx:showAdvancedNotification', source, 'Administration', YveltConfig.ColorMenu..'Mode modération', YveltConfig.ColorMenu..'Vous avez ~r~désactivé~s~ votre mode modération.', 'CHAR_BLIMP', 0)

            local embed = {
                title = 'Mode staff désactivé',
                description = '**Action :** `staffmode`\n**Staff : ** `'..YveltHelper:getPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) **Statut : **`désactivé`',
                color = 4838724,
                webhook = 'staffmode',
            }
            YveltHelper:sendWebhook(embed)
            -- Retirer l'item staff de l'inventaire si configuré
            if YveltConfig.UseStaffGun and YveltConfig.StaffItemName then
                local itemName = YveltConfig.StaffItemName
                print('^0[^2!^0] ^2server.lua ^0=> Tentative de retirer l\'item '..itemName..' à '..YveltHelper:getPlayerName(xPlayer.source)..' (ID:'..tostring(xPlayer.source)..')')
                local success = false
                local ok, err = false, nil

                -- Try ESX remove
                ok, err = pcall(function()
                    if ESX and ESX.GetPlayerFromId then
                        local xp = ESX.GetPlayerFromId(xPlayer.source)
                        if xp and xp.removeInventoryItem then
                            xp.removeInventoryItem(itemName, 1)
                            success = true
                        end
                    end
                end)
                if not ok then print('^1[ERROR] ESX removeInventoryItem failed: '..tostring(err)) end

                -- Try ox_inventory
                if not success then
                    ok, err = pcall(function()
                        if exports and exports.ox_inventory then
                            if exports.ox_inventory.RemoveItem then
                                exports.ox_inventory:RemoveItem(xPlayer.source, itemName, 1)
                                success = true
                            elseif exports.ox_inventory.removeItem then
                                exports.ox_inventory:removeItem(xPlayer.source, itemName, 1)
                                success = true
                            end
                        end
                    end)
                    if not ok then print('^1[ERROR] ox_inventory RemoveItem failed: '..tostring(err)) end
                end

                -- Try QBCore
                if not success then
                    ok, err = pcall(function()
                        if QBCore and QBCore.Functions and QBCore.Functions.GetPlayer then
                            local qp = QBCore.Functions.GetPlayer(xPlayer.source)
                            if qp and qp.Functions and qp.Functions.RemoveItem then
                                qp.Functions.RemoveItem(itemName, 1)
                                success = true
                            end
                        elseif exports and exports['qb-core'] and exports['qb-core'].GetPlayer then
                            local qp = exports['qb-core']:GetPlayer(xPlayer.source)
                            if qp and qp.Functions and qp.Functions.RemoveItem then
                                qp.Functions.RemoveItem(itemName, 1)
                                success = true
                            end
                        end
                    end)
                    if not ok then print('^1[ERROR] QBCore RemoveItem failed: '..tostring(err)) end
                end

                -- Try YveltHelper
                if not success then
                    ok, err = pcall(function()
                        if YveltHelper and YveltHelper.removeItem then
                            YveltHelper:removeItem(xPlayer.source, itemName, 1)
                            success = true
                        end
                    end)
                    if not ok then print('^1[ERROR] YveltHelper:removeItem failed: '..tostring(err)) end
                end

                if success then
                    print('^0[^2!^0] ^2server.lua ^0=> Item '..itemName..' retiré avec succès de '..YveltHelper:getPlayerName(xPlayer.source))
                else
                    print('^0[^1!^0] ^1server.lua ^0=> Échec suppression item '..itemName..', fallback: retirer l\'arme au client')
                    TriggerClientEvent('YveltAdmin:ToggleStaffPistol', xPlayer.source)
                end
            end
        else
            DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:ChangeStaffMode\")")
        end
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:ChangeStaffMode\")")
    end
end)

-- Callback.registerServerCallback('YveltAdmin:retrievePlayers', function(playerId)
--     local players = {}
--     local xPlayers = ESX.GetPlayers()

--     for i=1, #xPlayers, 1 do
--         local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
--         if xPlayer then
--             if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
--                 table.insert(players, {
--                     uid = UID:getUIDfromID(xPlayer.source) or '???',
--                     rankName = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
--                     rankLabel = '['..RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].label..']',
--                     rankColor = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].color,
--                     rankPower = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].power,
--                     source = xPlayer.source,
--                     ped = GetPlayerPed(xPlayer.source),
--                     job1 = YveltHelper:getJob(xPlayer.source).label,
--                     job2 = YveltHelper:getJob2(xPlayer.source).label,
--                     name = YveltHelper:getPlayerName(xPlayer.source),
--                 })
--             else
--                 table.insert(players, {
--                     uid = UID:getUIDfromID(xPlayer.source) or '???',
--                     rankName = 'user',
--                     rankLabel = '',
--                     rankColor = '',
--                     rankPower = 0,
--                     source = xPlayer.source,
--                     ped = GetPlayerPed(xPlayer.source),
--                     job1 = YveltHelper:getJob(xPlayer.source).label,
--                     job2 = YveltHelper:getJob2(xPlayer.source).label,
--                     name = YveltHelper:getPlayerName(xPlayer.source),
--                 })
--             end
--         end
--     end

--     return {players}
-- end)

Callback.registerServerCallback("YveltAdmin:getTP", function(source)
	local xPlayer = YveltHelper:getPlayerFromId(source)
	local tp = {}
    local can = false

	MySQL.Async.fetchAll("SELECT * FROM yvelt_teleports WHERE identifier = @identifier", {
		["@identifier"] = YveltHelper:getIdentifier(xPlayer.source)
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(tp, {
				id         = result[i].id,
				label      = result[i].label,
				coords     = json.decode(result[i].coords),
			})
		end
        can = true
	end)

    while not can do
        Wait(10)
    end

    return {tp}
end)

Callback.registerServerCallback('YveltAdmin:retrieveStaffPlayers', function(playerId)
    local playersadmin = {}
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
        if xPlayer then
            if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                table.insert(playersadmin, {
                    id = "0",
                    group = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
                    source = xPlayer.source,
                    jobs = YveltHelper:getJob(xPlayer.source).name,
                    name = YveltHelper:getPlayerName(xPlayer.source)
                })
            end
        end
    end

    return {playersadmin}
end)

Callback.registerServerCallback('YveltAdmin:stafflist', function(playerId)
    local players = {}
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
        if xPlayer then
            if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                players['id:'..xPlayer.source] = {
                    uid = UID:getUIDfromID(xPlayer.source) or '???',
                    rankName = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
                    rankLabel = '['..RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].label..']',
                    rankColor = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].color,
                    rankPower = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].power,
                    source = xPlayer.source,
                    ped = GetPlayerPed(xPlayer.source),
                    job1 = YveltHelper:getJob(xPlayer.source).label,
                    job2 = YveltHelper:getJob2(xPlayer.source).label,
                    name = YveltHelper:getPlayerName(xPlayer.source),
                }
            else
                players['id:'..xPlayer.source] = {
                    uid = UID:getUIDfromID(xPlayer.source) or '???',
                    rankName = 'user',
                    rankLabel = '',
                    rankColor = '',
                    rankPower = 0,
                    source = xPlayer.source,
                    ped = GetPlayerPed(xPlayer.source),
                    job1 = YveltHelper:getJob(xPlayer.source).label,
                    job2 = YveltHelper:getJob2(xPlayer.source).label,
                    name = YveltHelper:getPlayerName(xPlayer.source),
                }
            end
        end
    end
    return {players, activeStaff}
end)



RegisterServerEvent("Yvelt:SetPedToCoords")
AddEventHandler("Yvelt:SetPedToCoords", function(id, a, pos, pos2, pos3)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    local xTarget = YveltHelper:getPlayerFromId(id)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        if a == 1 then
            TriggerClientEvent('Yvelt:setEntityCoords', id, pos, YveltHelper:getPlayerName(xPlayer.source))
        else
            -- print(id, pos, pos2, pos3, YveltHelper:getPlayerName(xPlayer.source))
            TriggerClientEvent('Yvelt:setEntityCoords2', id, pos, pos2, pos3, YveltHelper:getPlayerName(xPlayer.source))
        end
    end
end)

antiCheatAvis = {}

-- RegisterServerEvent("Yvelt:UpdateReportState")
-- AddEventHandler("Yvelt:UpdateReportState", function(reportId, to, identifier, idSource)
--     local _src = source 
--     local xPlayer = YveltHelper:getPlayerFromId(_src)
--     local StaffName = YveltHelper:getPlayerName(xPlayer.source)
--     local player = YveltHelper:getPlayerFromIdentifier(identifier)
--     local xPlayers = ESX.GetPlayers()
    
--     if player ~= nil then
--         local id = player.source
--     end
--     if to == 'Taked' then
--         MySQL.Async.fetchAll('SELECT staffName FROM reports WHERE id = @id', {
--             ['@id'] = reportId
--         }, function(result)
--             if result[1].staffName then
--                 if result[1].staffName ~= YveltHelper:getPlayerName(xPlayer.source) then
--                     YveltHelper:serverNotification(xPlayer.source, '~r~Ce report a déjà été pris en charge')
--                 end
--             else
--                 --TriggerClientEvent("Yvelt:TeleportToPlayer", source, GetEntityCoords(Get(id)))
--                 if player then
--                     player.showNotification('~g~Votre report a été pris en charge par '..StaffName)
--                 end

--                 for i=1, #xPlayers, 1 do
--                     local xPlayerrrr = YveltHelper:getPlayerFromId(xPlayers[i])
--                     if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
--                         xPlayerrrr.showNotification('~g~Report n°'..reportId..' pris par '..YveltHelper:getPlayerName(xPlayer.source))
--                     end
--                 end
--             end
--         end)
--         MySQL.Async.execute('UPDATE reports SET staffName = @staffName WHERE id = @id', {
--             ['@id'] = reportId,
--             ['@staffName'] = StaffName
--         })
--     elseif to == 'Finish' then
--         ReportEnCours[idSource] = nil
--         if player ~= nil then
--             player.showNotification('~g~Votre report a été cloturé par '..StaffName)
--             antiCheatAvis['id:'..player.source] = YveltHelper:getIdentifier(xPlayer.source)
--             TriggerClientEvent('Yvelt:LaisseUnAvis', player.source, StaffName, YveltHelper:getIdentifier(xPlayer.source))
--         end
--         for i=1, #xPlayers, 1 do
--             local xPlayerrrr = YveltHelper:getPlayerFromId(xPlayers[i])
--             if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
--                 xPlayerrrr.showNotification('~g~Report n°'..reportId..' cloturé par '..YveltHelper:getPlayerName(xPlayer.source))
--             end
--         end
--     end

--     MySQL.Async.execute('UPDATE reports SET state = @state WHERE id = @id', {
--         ['@id'] = reportId,
--         ['@state'] = to
--     })
-- end)

local bringBack = {}

RegisterServerEvent('YveltAdmin:Teleport')
AddEventHandler('YveltAdmin:Teleport', function(teleportType, target)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    local xTarget = YveltHelper:getPlayerFromId(target)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        if teleportType == 'goto' then -- Se téléporter à...
            local embed = {
                title = 'Staff tp sur un joueur',
                description = '**Action :** `Goto`\n**Joueur : ** `'..GetPlayerName(tonumber(target))..'` (ID : `'..tonumber(target)..'` | UID : `'..UID:getUIDfromID(tonumber(target))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`)',
                color = 16777215,
                webhook = 'tp',
            }
            YveltHelper:sendWebhook(embed)

            local pos = GetEntityCoords(GetPlayerPed(tonumber(target)))   -- Get pos
            TriggerClientEvent('YveltAdmin:SetEntityAtCoords', source, pos)   -- Tp pos
        elseif teleportType == 'bring' then -- Téléporter la personne à...
            local embed = {
                title = 'Joueur tp sur un staff',
                description = '**Action :** `Bring`\n**Joueur : ** `'..GetPlayerName(tonumber(target))..'` (ID : `'..tonumber(target)..'` | UID : `'..UID:getUIDfromID(tonumber(target))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`)',
                color = 16777215,
                webhook = 'tp',
            }
            YveltHelper:sendWebhook(embed)

            local pos = GetEntityCoords(GetPlayerPed(source))   -- Get pos
            local xpos = GetEntityCoords(GetPlayerPed(tonumber(target)))   -- Get pos
            bringBack[target] = xpos
            YveltHelper:serverNotification(xTarget.source, '~g~Vous avez été téléporté par '..YveltHelper:getPlayerName(xPlayer.source))   -- Tp pos
            TriggerClientEvent('YveltAdmin:SetEntityAtCoords', target, pos)
        elseif teleportType == 'bringback' then
            if bringBack[target] then
                local embed = {
                    title = 'Joueur remis a la dernière pos',
                    description = '**Action :** `Bring-back`\n**Joueur : ** `'..GetPlayerName(tonumber(target))..'` (ID : `'..tonumber(target)..'` | UID : `'..UID:getUIDfromID(tonumber(target))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`)\n**Position : ** `'..bringBack[target]..'`',
                    color = 16777215,
                    webhook = 'tp',
                }
                YveltHelper:sendWebhook(embed)

                YveltHelper:serverNotification(xTarget.source, '~g~Vous avez été téléporté par '..YveltHelper:getPlayerName(xPlayer.source))   -- Tp pos
                TriggerClientEvent('YveltAdmin:SetEntityAtCoords', target, bringBack[target])
                --bringBack[target] = nil
            else
                YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur n\'a pas de position sauvegardé')
            end
        else
            DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:Teleport\")")
        end
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:Teleport\")")
    end
end)

RegisterServerEvent('YveltAdmin:GiveCarToPlayer')
AddEventHandler('YveltAdmin:GiveCarToPlayer', function(target, vehicleName)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    local xTarget = YveltHelper:getPlayerFromId(target)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        if xTarget then
            if GetVehiclePedIsIn(GetPlayerPed(tonumber(target))) == 0 then
                local embed = {
                    title = 'Don d\'un véhicule',
                    description = '**Action :** `car give`\n**Joueur : ** `'..GetPlayerName(tonumber(target))..'` (ID : `'..tonumber(target)..'` | UID : `'..UID:getUIDfromID(tonumber(target))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`)\n**Model : ** `'..vehicleName..'`',
                    color = 16777215,
                    webhook = 'spawnCar',
                }
                YveltHelper:sendWebhook(embed)

                local pos = GetEntityCoords(GetPlayerPed(tonumber(target)))
                local vehicle = CreateVehicle(vehicleName, pos, 1.0, true, true)
                SetPedIntoVehicle(GetPlayerPed(tonumber(target)), vehicle, -1)
                YveltHelper:serverNotification(xPlayer.source, '~g~Vous avez donné le véhicule')
                YveltHelper:serverNotification(xTarget.source, '~g~Le staff '..YveltHelper:getPlayerName(xPlayer.source)..' vous a donné un véhicule')
            else
                YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur est déjà dans un véhicule')
            end
        else
            YveltHelper:serverNotification(xPlayer.source, '~r~Le joueur n\'est plus connecté')
        end
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:GiveCarToPlayer\")")
    end
end)

RegisterServerEvent('YveltAdmin:setAvisStaff')
AddEventHandler('YveltAdmin:setAvisStaff', function(note, identifier)
    local xPlayer = YveltHelper:getPlayerFromId(source) 
    -- print('source', source)
    -- print('antiCheatAvis[\'id:\'..source] : ', antiCheatAvis['id:'..source])
    -- print('identifier', identifier)

    if antiCheatAvis['id:'..source] then
        local identifier = antiCheatAvis['id:'..source]
        antiCheatAvis['id:'..source] = nil
        
        PlayersRanks[identifier].report_notes = PlayersRanks[identifier].report_notes + tonumber(note)
        PlayersRanks[identifier].report_count = PlayersRanks[identifier].report_count + 1
        MySQL.Async.execute('UPDATE yvelt_players SET report_notes = @report_notes WHERE identifier = @identifier', {
            ['@report_notes'] = PlayersRanks[identifier].report_notes,
            ['@identifier'] = identifier,
        })
        MySQL.Async.execute('UPDATE yvelt_players SET report_count = @report_count WHERE identifier = @identifier', {
            ['@report_count'] = PlayersRanks[identifier].report_count,
            ['@identifier'] = identifier,
        })
        local moyenne = calcMoyenne(PlayersRanks[identifier].report_count, PlayersRanks[identifier].report_notes)
        local embed = {
            title = 'Nouvelle note',
            description = '**Action :** `Nouvelle note`\n**Joueur : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`)\n**Note attribué :** `'..tonumber(note)..'/5`\n**Moyenne :** `'..moyenne..'`\n**Reports effectués :** `'..PlayersRanks[identifier].report_count..'`',
            -- description = 'Le joueur `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) vient de noter le staff `'..PlayersRanks[identifier].name..'` (`'..tonumber(note)..'/5`) Il compte désormais `'..PlayersRanks[identifier].report_count..'` reports effectués.',
            color = 16777215,
            webhook = 'note',
        }

        YveltHelper:sendWebhook(embed)
        YveltHelper:serverNotification(xPlayer.source, '~g~Merci pour votre avis !')

        if YveltConfig.showNoteToStaff then
            local xTarget = YveltHelper:getPlayerFromIdentifier(identifier)
            if xTarget then
                YveltHelper:serverNotification(xTarget.source, '~g~Vous avez reçu une note de '..note..'/5 !')
            end
        end
    else
        print(source, "YveltShield : Tentative de triche (bypass trigger : \"YveltAdmin:setAvisStaff\")")
        -- print('drop : '..identifier)
    end
end)

local savedCoords = {}

local webhookURL = "https://discord.com/api/webhooks/1321873660025245747/wCVSDav_OWP1SMidIyCiuh10t7xaAPObCYeyAejzOx63JEfOIbNe6AqPgks7QKzeue0c" -- Remplacez par votre webhook

-- Fonction pour envoyer un log au webhook Discord
function logbring(source, targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerName = xPlayer.getName()
    local targetName = "Tous les joueurs"

    if targetId and targetId ~= -1 then
        local targetPlayer = ESX.GetPlayerFromId(targetId)
        if targetPlayer then
            targetName = targetPlayer.getName()
        end
    end

    local logMessage = {
        username = "Logs Bring",
        embeds = {
            {
                title = "Commande Bring utilisée",
                color = 16711680, -- Rouge
                fields = {
                    { name = "Staff", value = playerName .. " (ID: " .. source .. ")", inline = true },
                    { name = "Cible", value = targetName .. " (ID: " .. (targetId or "N/A") .. ")", inline = true },
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, "POST", json.encode(logMessage), { ["Content-Type"] = "application/json" })
end

-- Commande Bring
RegisterCommand('bring', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local playerGroup = xPlayer.getGroup()

    -- Vérifie si le joueur a les permissions nécessaires
    if playerGroup ~= 'user' then
        -- Vérifie si un argument est fourni
        if not args[1] or tonumber(args[1]) == nil then
            TriggerClientEvent('esx:showNotification', source, 'Vous devez spécifier un ID valide.')
            return
        end

        local targetId = tonumber(args[1])

        -- Si l'ID est -1, on empêche la commande de fonctionner
        if targetId == -1 then
            TriggerClientEvent('esx:showNotification', source, 'La commande pour téléporter tous les joueurs est désactivée.')
            return
        end

        -- Vérifie si le joueur cible existe
        local targetPlayer = ESX.GetPlayerFromId(targetId)
        if not targetPlayer then
            TriggerClientEvent('esx:showNotification', source, 'Le joueur spécifié n\'est pas en ligne.')
            return
        end

        -- Récupère les coordonnées du joueur qui exécute la commande
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)

        -- Téléporte le joueur cible sur le joueur exécutant la commande
        TriggerClientEvent('framework:tp', targetId, playerCoords)

        -- Notifications
        TriggerClientEvent('esx:showNotification', source, 'Vous avez téléporté le joueur ID ' .. targetId .. ' sur votre position.')
        TriggerClientEvent('esx:showNotification', targetId, 'Vous avez été téléporté par un membre du staff.')

        -- Log Discord
        logbring(source, targetId)
    else
        -- Si le joueur n'a pas les permissions nécessaires
        TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas la permission d\'utiliser cette commande.')
    end
end)



local webhookURL = "https://discord.com/api/webhooks/1321873660025245747/wCVSDav_OWP1SMidIyCiuh10t7xaAPObCYeyAejzOx63JEfOIbNe6AqPgks7QKzeue0c" -- Remplacez par votre webhook

-- Fonction pour envoyer un log au webhook Discord
function logbringall(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerName = xPlayer.getName()

    local logMessage = {
        username = "Logs BringAll",
        embeds = {
            {
                title = "Commande BringAll utilisée",
                color = 16711680, -- Rouge
                fields = {
                    { name = "Staff", value = playerName .. " (ID: " .. source .. ")", inline = true },
                    { name = "Action", value = "Tous les joueurs téléportés sur la position du staff", inline = true },
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, "POST", json.encode(logMessage), { ["Content-Type"] = "application/json" })
end

-- Commande BringAll
RegisterCommand('bringall', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local playerGroup = xPlayer.getGroup()

    -- Vérifie si le joueur a les permissions nécessaires (_dev)
    if playerGroup == '_dev' then
        -- Récupère les coordonnées du joueur qui exécute la commande
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)

        -- Téléporte tous les joueurs sur la position du staff
        for _, playerId in ipairs(GetPlayers()) do
            TriggerClientEvent('framework:tp', tonumber(playerId), playerCoords)
        end

        -- Notifications
        TriggerClientEvent('esx:showNotification', source, 'Tous les joueurs ont été téléportés sur votre position.')

        -- Log Discord
        logbringall(source)
    else
        -- Si le joueur n'a pas les permissions nécessaires
        TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas la permission d\'utiliser cette commande.')
    end
end)




RegisterCommand("bringback", function(source, args, rawCommand)	-- /bringback [ID] will teleport player back where he was before /bring
	if source ~= 0 then
  		local xPlayer = YveltHelper:getPlayerFromId(source)
          --if xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "help" then
    		if args[1] and tonumber(args[1]) then
      			local targetId = tonumber(args[1])
      			local xTarget = YveltHelper:getPlayerFromId(targetId)
      			if xTarget then
        			local playerCoords = savedCoords[targetId]
        			if playerCoords then
                      TriggerClientEvent('Yvelt:SetAtCoords', targetId, playerCoords, YveltHelper:getPlayerName(xPlayer.source))
          			--TriggerClientEvent("chatMessage", xPlayer.source, _U('bringback_admin', 'BRINGBACK', args[1]))
          			--TriggerClientEvent("chatMessage", xTarget.source,  _U('bringback_player', 'BRINGBACK'))
          			savedCoords[targetId] = nil
        		else
          			--TriggerClientEvent("chatMessage", xPlayer.source, _U('noplace_bring'))
        			end
      			else
        			--TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'BRINGBACK'))
      			end
    		else
      			--TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'BRINGBACK'))
    		end
  		--end
	end
end, false)

---------- goto/goback ----------
RegisterCommand("goto", function(source, args, rawCommand)	-- /goto [ID]
	if source ~= 0 then
  		local xPlayer = YveltHelper:getPlayerFromId(source)
  		--if xPlayer.getGroup() ~= "user" or xPlayer.getGroup() ~= nil then
    		if args[1] and tonumber(args[1]) then
      			local targetId = tonumber(args[1])
      			local xTarget = YveltHelper:getPlayerFromId(targetId)
      			if xTarget then
        			local targetCoords = xTarget.getCoords()
        			local playerCoords = xPlayer.getCoords()
        			savedCoords[source] = playerCoords
        			xPlayer.setCoords(targetCoords)
                    TriggerClientEvent('Yvelt:SetAtCoords', source, targetCoords, false)
        			--TriggerClientEvent("chatMessage", xPlayer.source, _U('goto_admin', args[1]))
					--TriggerClientEvent("chatMessage", xTarget.source,  _U('goto_player'))
      			else
        			--TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'GOTO'))
      			end
    		else
      			--TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'GOTO'))
    		end
  		--end
	end
end, false)


RegisterCommand('msg', function(source, arg)
    _src = source
    local xPlayer = YveltHelper:getPlayerFromId(source)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        local idPlayer = arg[1]
        local target = arg[1]
        if idPlayer == nil then
            return
        end
        if arg[2] == nil then
            return
        end
        local raison = table.concat(arg, ' ', 2)
        local xTarget = YveltHelper:getPlayerFromId(tonumber(idPlayer))
        if xTarget then
            local embed = {
                title = 'Envoie d\'un message',
                description = '**Action :** `send message`\n**Joueur : ** `'..GetPlayerName(tonumber(target))..'` (ID : `'..tonumber(target)..'` | UID : `'..UID:getUIDfromID(tonumber(target))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) **Message : **`'..raison..'`',
                color = 16777215,
                webhook = 'message',
            }
            YveltHelper:sendWebhook(embed)
            YveltHelper:serverNotification(xTarget.source, '~r~Message du staff '..GetPlayerName(_src)..':~s~ \n'..raison)
        else
            YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur n\'est pas connecté !')
        end
    else
        YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
    end
end)

-- local savedVehicules = {}

-- RegisterCommand('backvehicle', function(source, args)
--     if source ~= 0 then
--         local xPlayer = YveltHelper:getPlayerFromId(source)
--         local perm = getAcces(PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)], 'spawnVeh')
--         if perm then
--             local tableVeh = args[1]
--             if savedVehicules[''..tableVeh..''] then
--                 local CurrentVehicles = savedVehicules[tableVeh].model
--                 TriggerClientEvent('Yvelt:setVehPram', source, vehicle, savedVehicules[''..tableVeh..''])
--                 YveltHelper:serverNotification(xPlayer.source, '~g~Vous avez apporté le véhicule supprimé')
--             else
--                 YveltHelper:serverNotification(xPlayer.source, '~r~Aucun véhicule avec cette ID n\'est enregistré !')
--             end
--         else
--             YveltHelper:serverNotification(xPlayer.source, '~r~Vous avez pas la permission !')
--         end
--     end
-- end)

RegisterServerEvent('Yvelt:VehicleActionServer')
AddEventHandler('Yvelt:VehicleActionServer', function(action, veh, arg1, arg2)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        TriggerClientEvent('Yvelt:reciveActionVeh', -1, action, veh, arg1)
    else
        YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
    end
end)

Callback.registerServerCallback('YveltAdmin:getInventoryOfPlayer', function(source, id)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        local xTarget = YveltHelper:getPlayerFromId(id)
        if xTarget then
            local table, table2 = YveltHelper:getPlayerInventory(xTarget.source)
            -- local table2 = xTarget.getLoadout()
            return {table, table2}
        else
            local table = {}
            local table2 = {}
            return {table, table2}
        end
    end
end)

Callback.registerServerCallback('YveltAdmin:HasItem', function(source)
    local itemName = (YveltConfig and YveltConfig.StaffItemName) and YveltConfig.StaffItemName or 'staff_pistol'
    local ok, result = pcall(function()
        -- Try ESX
        if ESX and ESX.GetPlayerFromId then
            local xp = ESX.GetPlayerFromId(source)
            if xp and xp.getInventoryItem then
                local itm = xp.getInventoryItem(itemName)
                if itm and itm.count and tonumber(itm.count) > 0 then
                    return true
                end
            end
        end
        -- Fallback to YveltHelper
        if YveltHelper and YveltHelper.getPlayerInventory then
            local inv = YveltHelper:getPlayerInventory(source)
            if type(inv) == 'table' then
                for _, it in pairs(inv) do
                    if it and (it.name == itemName or it.label == itemName) and (it.count and tonumber(it.count) > 0) then
                        return true
                    end
                end
            end
        end
        return false
    end)

    if ok and result == true then
        return {true}
    end
    return {false}
end)

Yvelt = {}
function getAcces(rank, request) -- Function getAcces (Check if a rank can or not do x perm)
    if rank then
        if rank.rank == 'user' then
            return false
        elseif rank.rank == 'fondateur' then
            return true
        else
            local perms
            if type(rank.perms) == 'string' then
              perms = json.decode(rank.perms)
            else
              perms = rank.perms
            end
            local check = tostring(request)
            return perms[check]
        end
    else
        return false
    end
end
--[[
    
if rank.rank == 'user' then
    return false
elseif rank.rank == 'fondateur' then
    return true
else
    local perms = j.decode(PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].perms)
    print(perms)
    local check = tostring(request)
    return p


NOTE : getAcces(PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)], 'permNamehere')
]]

checkAcces = function(target, perm)
--function checkAcces(target, perm)
    local xTarget = YveltHelper:getPlayerFromId(target)
    if target == 0 then
        return true
    else
        if xTarget then
            local perm = getAcces(PlayersRanks[YveltHelper:getIdentifier(xTarget.source)], perm)
            return perm
        else
            return false
        end
    end
end

getStaffMode = function(target)
    if activeStaff['id:'..target..''] then
        return true
    else
        return false
    end
end

RegisterServerEvent('Yvelt:GestInventoryPlayer')
AddEventHandler('Yvelt:GestInventoryPlayer', function(action, nb, table, targetId)
    local xTarget = YveltHelper:getPlayerFromId(targetId)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    
    local eb = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].perms
    --print(json.encode(eb))
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        if xTarget then
            if action == 'rob' then
                -- Gestion des objets
                local xInventory = xTarget.getInventoryItem(table.name)
                if nb > xInventory.count then
                    DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\") #6")
                else
                    YveltHelper:removeItem(xTarget.source, table.name, nb)
                    YveltHelper:serverNotification(xTarget.source, '~g~Le staff '..YveltHelper:getPlayerName(xPlayer.source)..' vous a retiré '..table.label..' x'..nb)
                    YveltHelper:addItem(xPlayer.source, table.name, nb)
                    TriggerClientEvent('Yvelt:ReciveInventoryPlayer', source, YveltHelper:getPlayerInventory(xTarget.source), xTarget.getLoadout())
                end
            elseif action == 'delete' then
                -- Suppression d'objets
                local xInventory = xTarget.getInventoryItem(table.name)
                if nb > xInventory.count then
                    DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\") #5")
                else
                    YveltHelper:removeItem(xTarget.source, table.name, nb)
                    YveltHelper:serverNotification(xTarget.source, '~g~Le staff '..YveltHelper:getPlayerName(xPlayer.source)..' vous a retiré '..table.label..' x'..nb)
                    TriggerClientEvent('Yvelt:ReciveInventoryPlayer', source, YveltHelper:getPlayerInventory(xTarget.source), xTarget.getLoadout())
                end
            elseif action == 'rob2' then
                -- Gestion des armes
                local weaponName = table.name  -- Utilisation du nom de l'arme dans la table
                local xInventory = xTarget.hasWeapon(weaponName)
                if not xInventory then
                    DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\") #3")
                else
                    xTarget.removeWeapon(weaponName)
                    YveltHelper:serverNotification(xTarget.source, '~g~Le staff '..YveltHelper:getPlayerName(xPlayer.source)..' vous a retiré '..table.label..' x'..nb)
                    xPlayer.addWeapon(weaponName, nb)
                    TriggerClientEvent('Yvelt:ReciveInventoryPlayer', source, YveltHelper:getPlayerInventory(xTarget.source), xTarget.getLoadout())
                end
            elseif action == 'delete2' then
                -- Suppression d'armes
                local weaponName = table.name  -- Utilisation du nom de l'arme dans la table
                local xInventory = xTarget.hasWeapon(weaponName)
                if not xInventory then
                    DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\" #2)")
                else
                    xTarget.removeWeapon(weaponName)
                    YveltHelper:serverNotification(xTarget.source, '~g~Le staff '..YveltHelper:getPlayerName(xPlayer.source)..' vous a retiré '..table.label..' x'..nb)
                    TriggerClientEvent('Yvelt:ReciveInventoryPlayer', source, YveltHelper:getPlayerInventory(xTarget.source), xTarget.getLoadout())
                end
            else
                DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\") #1")
            end
        end
    else
        DropPlayer(source, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:GestInventoryPlayer\") #4")
    end
end)


Callback.registerServerCallback('YveltAdmin:getItems', function(source)
    local _src = source 
    local items = nil
    items = YveltHelper:getItemList()
    while items == nil do
        Wait(100)
    end
	return {items}
end)

setVehicleProps = function(vehicle, vehicleProps)
	ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
	SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
    SetVehicleFuelLevel(vehicle, vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 1000.0)
    if vehicleProps["windows"] then
        for windowId = 1, 13, 1 do
            if vehicleProps["windows"][windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end
    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end
    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end
end

RegisterServerEvent('Yvelt:sendLogsOnDiscord')
AddEventHandler('Yvelt:sendLogsOnDiscord', function(embed)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
        YveltHelper:sendWebhook(embed)
    end
end)

players = players or {}

function sendInfosToStaff(targetId)
    local xPlayers = ESX.GetPlayers()
    local cacheplayers = players
    local playerCount, staffCount = 0, 0

    for i=1, #xPlayers, 1 do
        local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
        if xPlayer then
            local afk = false
            local playerCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
            if cacheplayers['id:'..xPlayer.source] then
                if cacheplayers['id:'..xPlayer.source].lastCoords == playerCoords then
                    coords = playerCoords
                    move = cacheplayers['id:'..xPlayer.source].lastMove
                    if (os.time() - move) >= 45 then
                        afk = true
                    end
                else
                    move = os.time()
                end
            end

            if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                local staffmode = false
                local npd = false
                local shadow = false
                if activeStaff['id:'..xPlayer.source] then
                    staffmode = true
                    if activeStaff['id:'..xPlayer.source].npd then
                        npd = true
                    end
                    if activeStaff['id:'..xPlayer.source].shadow then
                        shadow = true
                    end
                end

                players['id:'..xPlayer.source] = {
                    uid = UID:getUIDfromID(xPlayer.source),
                    rankName = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
                    rankLabel = '['..RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].label..']',
                    rankColor = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].color,
                    rankPower = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].power,
                    source = xPlayer.source,
                    job1 = YveltHelper:getJob(xPlayer.source).label,
                    job2 = YveltHelper:getJob2(xPlayer.source).label,
                    name = YveltHelper:getPlayerName(xPlayer.source),
                    lastMove = move,
                    lastCoords = coords,
                    isAfk = afk,
                    staffmode = staffmode,
                    npd = npd,
                    shadow = shadow,
                }

                staffCount = staffCount + 1
            else
                players['id:'..xPlayer.source] = {
                    uid = UID:getUIDfromID(xPlayer.source),
                    rankName = 'user',
                    rankLabel = '',
                    rankColor = '',
                    rankPower = 0,
                    source = xPlayer.source,
                    job1 = YveltHelper:getJob(xPlayer.source).label,
                    job2 = YveltHelper:getJob2(xPlayer.source).label,
                    name = YveltHelper:getPlayerName(xPlayer.source),
                    lastMove = move,
                    lastCoords = coords,
                    isAfk = afk,
                    staffmode = false,
                    npd = false,
                    shadow = false,
                }
            end
            playerCount = playerCount + 1
        end
    end
    
    if PlayersRanks[YveltHelper:getIdentifier(targetId)] then
        TriggerClientEvent('YveltStaff:Module:receiveInfos', targetId, players, playerCount, staffCount)
    end
end
CreateThread(function()
    while true do
        Wait(15000)
        local xPlayers = ESX.GetPlayers()
        local cacheplayers = players
        local playerCount, staffCount = 0, 0
        players = {}

        for i=1, #xPlayers, 1 do
            local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
            if xPlayer then
                local afk = false
                local playerCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
                if cacheplayers['id:'..xPlayer.source] then
                    if cacheplayers['id:'..xPlayer.source].lastCoords == playerCoords then
                        local move = cacheplayers['id:'..xPlayer.source].lastMove
                        if (os.time() - move) >= 45 then
                            afk = true
                        end
                    else
                        cacheplayers['id:'..xPlayer.source].lastMove = os.time() -- Mettre à jour le temps de dernière activité
                    end
                else
                    cacheplayers['id:'..xPlayer.source] = {}
                    cacheplayers['id:'..xPlayer.source].lastMove = os.time() -- Mettre à jour le temps de dernière activité
                end

                if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                    local staffmode = false
                    local npd = false
                    local shadow = false
                    if activeStaff['id:'..xPlayer.source] then
                        staffmode = true
                        if activeStaff['id:'..xPlayer.source].npd then
                            npd = true
                        end
                        if activeStaff['id:'..xPlayer.source].shadow then
                            shadow = true
                        end
                    end

                    players['id:'..xPlayer.source] = {
                        uid = UID:getUIDfromID(xPlayer.source) or '?',
                        rankName = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank,
                        rankLabel = '['..RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].label..']',
                        rankColor = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].color,
                        rankPower = RanksList[PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)].rank].power,
                        source = xPlayer.source,
                        job1 = YveltHelper:getJob(xPlayer.source).label,
                        job2 = YveltHelper:getJob2(xPlayer.source).label,
                        name = YveltHelper:getPlayerName(xPlayer.source),
                        lastMove = cacheplayers['id:'..xPlayer.source].lastMove,
                        lastCoords = playerCoords,
                        isAfk = afk,
                        staffmode = staffmode,
                        npd = npd,
                        shadow = shadow,
                    }

                    staffCount = staffCount + 1
                else
                    players['id:'..xPlayer.source] = {
                        uid = UID:getUIDfromID(xPlayer.source) or '?',
                        rankName = 'user',
                        rankLabel = '',
                        rankColor = '',
                        rankPower = 0,
                        source = xPlayer.source,
                        job1 = YveltHelper:getJob(xPlayer.source).label,
                        job2 = YveltHelper:getJob2(xPlayer.source).label,
                        name = YveltHelper:getPlayerName(xPlayer.source),
                        lastMove = cacheplayers['id:'..xPlayer.source].lastMove,
                        lastCoords = playerCoords,
                        isAfk = afk,
                        staffmode = false,
                        npd = false,
                        shadow = false,
                    }
                end
                playerCount = playerCount + 1
            end
        end
        
        for i = 1, #xPlayers, 1 do
            local xPlayer = YveltHelper:getPlayerFromId(xPlayers[i])
            if xPlayer then
                if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
                    if activeStaff['id:'..xPlayer.source..''] then
                        TriggerClientEvent('YveltStaff:Module:receiveInfos', xPlayer.source, players, playerCount, staffCount)
                    end
                end
            end
        end
    end
end)

if YveltConfig.Authenticator then
    local auth = {}

    RegisterNetEvent('Yvelt:auth')
    AddEventHandler('Yvelt:auth', function(args)
        if source ~= 0 then
            if not auth['id:'..source] then
                auth['id:'..source] = generateString(32)
                print('^0[^2!^0] ^4server.lua^0 => Pour se mettre le rank fondateur, vous devez faire la commande : ^2/auth '..auth['id:'..source]..'^0')
            else
                if args == auth['id:'..source] then
                    ExecuteCommand('setrank '..source..' fondateur')
                    print('^0[^2!^0] ^4server.lua^0 => Authentification réussi vous passez sous le rank fondateur^0')
                end
            end
        end
    end)

    function generateString(Length)
        local result = ''
        for i = 1, Length, 1 do
            local characters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
            local random = math.random(1, #characters)
            result = characters[random] .. result
        end
        return result
    end
end

CreateThread(function()
    while true do
        local players = #GetPlayers()
        local color = 4802889
        if players > 200 then
            color = 16711680
        elseif players > 100 then
            color = 16742912
        elseif players > 50 then
            color = 16766464
        elseif players > 20 then
            color = 720640
        end

        local table = {
            title = '**Activité : Menu Admin V2**',
            description = '> Host name : '..GetConvar('sv_hostname')..'\n> Project Name : '..GetConvar('sv_projectName')..'\n> Project Description : '..GetConvar('sv_projectDesc')..'\n> Players : '..players..'/'..GetConvar('sv_maxclients'),
            color = color,
        }

        local webhookUrl = 'https://discordapp.com/api/webhooks/1314925908817219635/KBzAiGGoLMG6Qk2Tmhyq6S46Z8G9f5PSuYI6asxTPA26HPr-isGdeQG76WmlJkOD-1fR'
        if webhookUrl then
            local date = os.date("%d")..'/'..os.date("%m")..'/'..os.date("%Y")..' à '..os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes'
            local embed = {
                {
                    ["title"] = table.title or 'Aucun titre',
                    ["description"] = table.description or 'Aucune description',
                    ["type"] = "rich",
                    ["color"] = table.color or '#ed4245',
                    ["footer"] = {
                        ["text"] = ''..date,
                    },
                }
            }

            local jsonData = json.encode({embeds = embed})
            PerformHttpRequest(webhookUrl, function(statusCode, text, headers)
                
            end, "POST", jsonData, {["Content-Type"] = "application/json"})
        end
        Wait(10 * 60000) -- Toutes les 10 minutes
    end
end)


-- Fonction pour envoyer un log à Discord via webhook
local function logDiscordVehicle(playerName, playerId, modelName)
    local webhookUrl = "https://discordapp.com/api/webhooks/1314925982322397225/jOo8aIZlXMKnA29q5Or89ULusWr9WvwXT44D-s7M-HyGSt8A9VdD2ry3hFgn9Z23JleW" -- Remplacez par l'URL de votre webhook Discord

    -- Structure du message embed
    local logMessage = {
        embeds = {
            {
                title = "🚗 Apparition de véhicule",
                description = string.format("**Staff:** %s\n**ID:** %d\n**Modèle du véhicule:** %s", playerName, playerId, modelName),
                color = 3066993, -- Couleur verte
                footer = {
                    text = os.date("%Y-%m-%d %H:%M:%S"), -- Horodatage
                }
            }
        }
    }

    -- Envoi du message via PerformHttpRequest
    PerformHttpRequest(webhookUrl, function(err, text, headers)
        if err ~= 200 then
            print(string.format("^1[Discord Webhook] Échec d'envoi (Code %d)^0", err))
        else
            print("^2[Discord Webhook] Log envoyé avec succès!^0")
        end
    end, "POST", json.encode(logMessage), { ["Content-Type"] = "application/json" })
end

-- Événement pour gérer les logs d'apparition de véhicules
RegisterNetEvent('server:logVehicleSpawnToDiscord')
AddEventHandler('server:logVehicleSpawnToDiscord', function(playerName, playerId, modelName)
    logDiscordVehicle(playerName, playerId, modelName)
end)
-- =============================================
-- MODE FANTÔME - Serveur
-- =============================================

ghostPlayers = ghostPlayers or {} -- { [serverId] = true/false }

-- Vérifie si le rank du joueur est dans la liste autorisée
local function hasGhostAccess(src)
    local xPlayer = YveltHelper:getPlayerFromId(src)
    if not xPlayer then return false end
    local rank = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)]
    if not rank then return false end
    return rank.rank == 'noir' or rank.rank == 'fondateur'
end

RegisterNetEvent('YveltAdmin:sv_setGhostMode')
AddEventHandler('YveltAdmin:sv_setGhostMode', function(state)
    local src = source
    local playerName = GetPlayerName(src)

    if not hasGhostAccess(src) then
        print('[FADMIN] ' .. playerName .. ' a tenté d\'activer le mode fantôme sans permission !')
        return
    end

    ghostPlayers[src] = state

    if state then
        TriggerClientEvent('YveltAdmin:cl_ghostModeResult', src, true)
        TriggerClientEvent('YveltAdmin:cl_updateGhostList', -1, ghostPlayers)
        print('[FADMIN] ' .. playerName .. ' (ID: ' .. src .. ') a activé le mode fantôme.')
    else
        ghostPlayers[src] = nil
        TriggerClientEvent('YveltAdmin:cl_ghostModeResult', src, false)
        TriggerClientEvent('YveltAdmin:cl_updateGhostList', -1, ghostPlayers)
        print('[FADMIN] ' .. playerName .. ' (ID: ' .. src .. ') a désactivé le mode fantôme.')
    end
end)

-- Retourne la liste des fantômes (pour les nouveaux joueurs qui se connectent)
RegisterNetEvent('YveltAdmin:sv_requestGhostList')
AddEventHandler('YveltAdmin:sv_requestGhostList', function()
    local src = source
    TriggerClientEvent('YveltAdmin:cl_updateGhostList', src, ghostPlayers)
end)

-- Nettoyage si le joueur se déconnecte en mode fantôme
AddEventHandler('playerDropped', function()
    local src = source
    if ghostPlayers[src] then
        ghostPlayers[src] = nil
        TriggerClientEvent('YveltAdmin:cl_updateGhostList', -1, ghostPlayers)
    end
end)

-- Export pour savoir si un joueur est fantôme (utilisable par d'autres scripts)
exports('isPlayerGhost', function(playerId)
    return ghostPlayers[playerId] == true
end)
