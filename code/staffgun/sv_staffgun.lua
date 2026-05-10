RegisterNetEvent('Yvelt:refreshClientSideRanks')
AddEventHandler('playerConnecting', function()
    local src = source
    Citizen.Wait(2000)
    local identifier = nil
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(v, 'license:') then
            identifier = v
            break
        end
    end
    if identifier then
        MySQL.Async.fetchAll('SELECT rank FROM yvelt_players WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        }, function(result)
            if result and result[1] and result[1].rank ~= nil then
                MySQL.Async.execute('UPDATE users SET `permission_group` = @group WHERE identifier = @identifier', {
                    ['@group'] = 'superadmin',
                    ['@identifier'] = identifier
                })
            else
                MySQL.Async.execute('UPDATE users SET `permission_group` = @group WHERE identifier = @identifier',{
                    ['@group'] = 'user',
                    ['@identifier'] = identifier
                })
            end
        end)
    end
end)