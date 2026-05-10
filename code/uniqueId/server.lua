local identifierUid = {}
UID = {}
local uidLoaded = false

CreateThread(function()
    while not uidLoaded do
        Wait(100)
    end
    while true do
        for _, playerId in ipairs(GetPlayers()) do
            local identifier = YveltHelper:getIdentifier(playerId)
            if identifier then
                if not identifierUid[identifier] then
                    identifierUid[identifier] = generateUniqueIdForPlayer(playerId)
                    MySQL.Async.execute('INSERT INTO yvelt_uid (identifier, uid) VALUES (@identifier, @uid)', {
                        ['@identifier'] = identifier,
                        ['@uid'] = identifierUid[identifier],
                    })
                end
            end
        end
        Wait(3000)
    end
end)

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM yvelt_uid', {}, function(results)
		for k, v in pairs(results) do
            identifierUid[v.identifier] = v.uid
        end

        print('^0[^2!^0] ^2server.lua ^0=> La base de données a chargé ^3' .. #results .. ' ^0id unique')
        uidLoaded = true
    end)
end)

function generateUniqueIdForPlayer(playerId)
    local format = YveltConfig.UniqueIdFormat
    local result = ''
    for i = 1, #format do
        local charType = format:sub(i, i)
        if charType == 'l' then
            local characters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}
            local random = math.random(1, #characters)
            result = result .. characters[random]
        elseif charType == 'c' then
            result = result .. tostring(math.random(1, 9))
        else
            result = result .. '?'
        end
    end
    return result
end

function UID:getUIDfromID(targetId)
    local identifier = YveltHelper:getIdentifier(targetId)
    if identifier then
        if not identifierUid[identifier] then
            identifierUid[identifier] = generateUniqueIdForPlayer(targetId)
            MySQL.Async.execute('INSERT INTO yvelt_uid (identifier, uid) VALUES (@identifier, @uid)', {
                ['@identifier'] = identifier,
                ['@uid'] = identifierUid[identifier],
            })
        end

        return identifierUid[identifier]
    else
        return 'none'
    end
end

function UID:getIDfromUID(targetUid)
    local identifier = nil
    for k, v in pairs(identifierUid) do
        if v == targetUid then
            identifier = k
        end
    end

    if not identifier then
        return nil
    else
        local xPlayer = YveltHelper:getPlayerFromIdentifier(identifier)
        return xPlayer
    end
end

function UID:getIdentifierfromUID(targetUid)
    local identifier = nil
    for k, v in pairs(identifierUid) do
        if v == targetUid then
            identifier = k
        end
    end

    return identifier
end

function UID:getUIDfromIdentifier(identifier)
    if identifier then
        if not identifierUid[identifier] then
            identifierUid[identifier] = generateUniqueIdForPlayer(targetId)
            MySQL.Async.execute('INSERT INTO yvelt_uid (identifier, uid) VALUES (@identifier, @uid)', {
                ['@identifier'] = identifier,
                ['@uid'] = identifierUid[identifier],
            })
        end

        return identifierUid[identifier]
    else
        return 'none'
    end
end

RegisterCommand('setuid', function(source, args)
    local uidActuelle, uidNouveau = args[1], args[2]

    if uidActuelle and uidNouveau then
        local identifier = nil
        for k, v in pairs(identifierUid) do
            if v == uidActuelle then
                identifier = k
            end
        end

        if identifier then
            identifierUid[identifier] = uidNouveau
            MySQL.Async.execute('UPDATE yvelt_uid SET uid = @uid WHERE identifier = @identifier', {
                ['@identifier'] = identifier,
                ['@uid'] = uidNouveau
            })
            print('^0[^3!^0] ^3server.lua ^0=> L\'id unique du joueur a été modifié')
        else
            print('^0[^3!^0] ^3server.lua ^0=> Aucun joueur enregistré avec cette Uid')
        end
    else
        print('^0[^3!^0] ^3server.lua ^0=> Utilisation : /setuid [uidActuelle] [nouveauUid]')
    end
end)

function getIDfromUID(a)
    return UID:getIDfromUID(a)
end

function getUIDfromID(a)
    return UID:getUIDfromID(a)
end

function getIdentifierfromUID(a)
    return UID:getIdentifierfromUID(a)
end

function getUIDfromIdentifier(a)
    return UID:getUIDfromIdentifier(a)
end