function InsertLogsSanction(uid, staff, name, sanctionType, sanctionDesc)
    local date = os.date("%d")..'/'..os.date("%m")..'/'..os.date("%Y")..' à '..os.date("%H")..'h'..os.date("%M")..' et '..os.date("%S")..' secondes'
    MySQL.Async.execute('INSERT INTO yvelt_sanctions (uid, staff, name, sanctionType, sanctionDesc, date) VALUES (@uid, @staff, @name, @sanctionType, @sanctionDesc, @date)', {
        ['@uid'] = uid,
        ['@staff'] = staff,
        ['@name'] = name,
        ['@sanctionType'] = sanctionType,
        ['@sanctionDesc'] = sanctionDesc,
        ['@date'] = date
    }) 
end


Callback.registerServerCallback('YveltAdmin:getSanctionsOfPlayer', function(source, uid)
    local _src = source
    local uid = uid
	local xPlayer = YveltHelper:getPlayerFromId(source)
	local sanc = {}
    local can = false

	MySQL.Async.fetchAll("SELECT * FROM yvelt_sanctions WHERE uid = @uid", {
		["@uid"] = uid
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(sanc, {
				id                  = result[i].id,
				uid                 = result[i].uid,
				staff               = YveltHelper:getTextFromAscii(result[i].staff),
				name	            = YveltHelper:getTextFromAscii(result[i].name),
				sanctionType	    = result[i].sanctionType,
				sanctionDesc	    = result[i].sanctionDesc,
				date	            = result[i].date,
			})
		end
        can = true
	end)

    while not can do
        Wait(10)
    end

    return {sanc}
end)

RegisterCommand('warn', function(source, arg)
    local idPlayer = arg[1]
    local raison = table.concat(arg, ' ', 2)

    local xTarget = YveltHelper:getPlayerFromId(idPlayer)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    if source == 0 then
        if xTarget then
            local uid = UID:getUIDfromID(xTarget.source)
            InsertLogsSanction(uid, YveltHelper:getPlayerName(xPlayer.source), YveltHelper:getPlayerName(xTarget.source), 'Warn', raison)
            YveltHelper:serverNotification(xPlayer.source, '~g~La sanction a été appliqué')
            local embed = {
                title = 'Warn',
                description = '**Action :** `warn`\n**Joueur : ** `'..GetPlayerName(tonumber(idPlayer))..'` (ID : `'..tonumber(idPlayer)..'` | UID : `'..UID:getUIDfromID(tonumber(idPlayer))..'`)\n**Staff : ** `/` (ID : `/` | UID : `/`) **Raison : **`'..raison..'',
                color = 4838724,
                webhook = 'warn',
            }
            YveltHelper:sendWebhook(embed)
            TriggerClientEvent('Yvelt:displayWarnOnScreen', xTarget.source, 'Warn', raison)
        end
    else
        if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
            if xTarget then
                local uid = UID:getUIDfromID(xTarget.source)
                InsertLogsSanction(uid, YveltHelper:getPlayerName(xPlayer.source), YveltHelper:getPlayerName(xTarget.source), 'Warn', raison)
                TriggerClientEvent('Yvelt:displayWarnOnScreen', xTarget.source, 'Warn', raison)
                local embed = {
                    title = 'Warn',
                    description = '**Action :** `Warn`\n**Joueur : ** `'..GetPlayerName(tonumber(idPlayer))..'` (ID : `'..tonumber(idPlayer)..'` | UID : `'..UID:getUIDfromID(tonumber(idPlayer))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) **Raison : **`'..raison..'',
                    color = 4838724,
                    webhook = 'warn',
                }
                YveltHelper:sendWebhook(embed)
            else
                YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur n\'est pas connecté !')
            end
        else
            YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
        end
    end
end)

RegisterCommand('warnuid', function(source, arg)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    local raison = table.concat(arg, ' ', 2)
    if not raison then
        raison = 'Aucune raison'
    end

    local idUnique = arg[1]

    MySQL.Async.fetchAll('SELECT identifier FROM yvelt_uniqueid WHERE uid = @uid', {
        ['@uid'] = idUnique
    }, function(result)
        if result then
            if result[1].identifier then
                if source == 0 then
                    -- Boucle à travers tous les joueurs en ligne pour trouver le joueur avec l'identifiant spécifié
                    local players = {}
                    local xPlayers = ESX.GetPlayers()
                    local playerID = nil
                    for i=1, #xPlayers, 1 do
                        local xPlayerrrrrr = YveltHelper:getPlayerFromId(xPlayers[i])
                        if xPlayerrrrrr then
                            if YveltHelper:getIdentifier(xPlayerrrrrr.source) == result[1].identifier then
                                playerID = xPlayerrrrrr.source
                            end
                        end
                    end
                    if playerID then
                        local xTarget = YveltHelper:getPlayerFromId(playerID)
                        local uid = idUnique
                        InsertLogsSanction(uid, YveltHelper:getPlayerName(xPlayer.source), YveltHelper:getPlayerName(xTarget.source), 'Warn', raison)
                        TriggerClientEvent('Yvelt:displayWarnOnScreen', xTarget.source, 'Warn', raison)
                        print('^2La sanction a été appliqué')
                    else
                        local uid = idUnique
                        InsertLogsSanction(uid, 'Console', 'Warn offline', 'Warn (offline)', raison)
                        print('^2La sanction a été appliqué (Joueur déconnecté)')
                    end
                else
                    if getAcces(PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)], 'warn') then
                        -- Boucle à travers tous les joueurs en ligne pour trouver le joueur avec l'identifiant spécifié
                        local players = {}
                        local xPlayers = ESX.GetPlayers()
                        local playerID = nil
                        for i=1, #xPlayers, 1 do
                            local xPlayerrrrrr = YveltHelper:getPlayerFromId(xPlayers[i])
                            if xPlayerrrrrr then
                                if YveltHelper:getIdentifier(xPlayerrrrrr.source) == result[1].identifier then
                                    playerID = xPlayerrrrrr.source
                                end
                            end
                        end
                        if playerID then
                            local xTarget = YveltHelper:getPlayerFromId(playerID)
                            local uid = idUnique
                            InsertLogsSanction(uid, YveltHelper:getPlayerName(xPlayer.source), YveltHelper:getPlayerName(xTarget.source), 'Warn', raison)
                            TriggerClientEvent('Yvelt:displayWarnOnScreen', xTarget.source, 'Warn', raison)
                            YveltHelper:serverNotification(xPlayer.source, '~g~La sanction a été appliqué')
                        else
                            local uid = idUnique
                            InsertLogsSanction(uid, YveltHelper:getPlayerName(xPlayer.source), 'Warn offline', 'Warn (offline)', raison)
                            YveltHelper:serverNotification(xPlayer.source, '~g~La sanction a été appliqué (Joueur déconnecté)')
                        end
                    else
                        YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
                    end
                end
            else
                if source == 0 then
                    print('^1Cette UID n\'est pas attribué (2)')
                else
                    YveltHelper:serverNotification(xPlayer.source, '~r~Cette UID n\'est pas attribué')
                end
            end
        else
            if source == 0 then
                print('^1Cette UID n\'est pas attribué (1)')
            else
                YveltHelper:serverNotification(xPlayer.source, '~r~Cette UID n\'est pas attribué')
            end
        end
    end)
end)

RegisterCommand('kick', function(source, arg)
    local idPlayer = arg[1]
    local raison = table.concat(arg, ' ', 2)

    local xTarget = YveltHelper:getPlayerFromId(idPlayer)
    local xPlayer = YveltHelper:getPlayerFromId(source)
    if source == 0 then
        if xTarget then
            local uid = UID:getUIDfromID(xTarget.source)
            InsertLogsSanction(uid, 'Console', YveltHelper:getPlayerName(xTarget.source), 'Kick', raison)
            DropPlayer(idPlayer, 'YveltAdmin : Vous avez été kick par la console pour la raison suivante : '..raison)
            local embed = {
                title = 'Kick',
                description = '**Action :** `kick`\n**Joueur : ** `'..GetPlayerName(tonumber(idPlayer))..'` (ID : `'..tonumber(idPlayer)..'` | UID : `'..UID:getUIDfromID(tonumber(idPlayer))..'`)\n**Staff : ** `Console` (ID : `/` | UID : `/`) **Raison : **`'..raison..'',
                color = 4838724,
                webhook = 'kick',
            }
            YveltHelper:sendWebhook(embed)
        else
            YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur n\'est pas connecté !')
        end
    else
        if PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)] then
            if xTarget then
                local uid = UID:getUIDfromID(xTarget.source)
                InsertLogsSanction(uid, YveltHelper:getPlayerName(xPlayer.source), YveltHelper:getPlayerName(xTarget.source), 'Kick', raison)
                YveltHelper:serverNotification(xPlayer.source, '~g~La sanction a été appliqué')
                DropPlayer(idPlayer, 'YveltAdmin : Vous avez été kick par '..YveltHelper:getPlayerName(xPlayer.source)..' pour la raison suivante : '..raison)
                local embed = {
                    title = 'Kick',
                    description = '**Action :** `kick`\n**Joueur : ** `'..GetPlayerName(tonumber(idPlayer))..'` (ID : `'..tonumber(idPlayer)..'` | UID : `'..UID:getUIDfromID(tonumber(idPlayer))..'`)\n**Staff : ** `'..GetPlayerName(source)..'` (ID : `'..source..'` | UID : `'..UID:getUIDfromID(source)..'`) **Raison : **`'..raison..'',
                    color = 4838724,
                    webhook = 'kick',
                }
                YveltHelper:sendWebhook(embed)
            else
                YveltHelper:serverNotification(xPlayer.source, '~r~Ce joueur n\'est pas connecté !')
            end
        else
            YveltHelper:serverNotification(xPlayer.source, '~r~Tu n\'as pas la permission !')
        end
    end
end)