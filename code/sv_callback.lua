local registeredCallbacks = {}
Callback = {}

Callback.registerServerCallback = function(name, event)
    if registeredCallbacks[name] then
        print('Ce callback déjà enregistré ! ('..name..')')
    else
        registeredCallbacks[name] = event
    end
end

RegisterNetEvent('Yvelt:triggerServerCallbackSend')
AddEventHandler('Yvelt:triggerServerCallbackSend', function(name, ...)
    if not registeredCallbacks[name] then
        print('Callback n\'existe pas ! ('..name..')')
    else
        local _src = source
        local fnct = registeredCallbacks[name]
        local toReturn
        local toReturn = fnct(_src, ...)
        if YveltConfig.CallbackDebug then
            print('^7Callback name : ^3'..name..' ^7| Registered : ^6yes^7')
            print('^2Attemps to return : ^7'..json.encode(toReturn))
        end
        TriggerClientEvent('Yvelt:triggerServerCallbackReceive', _src, name, table.unpack(toReturn))
    end
end)