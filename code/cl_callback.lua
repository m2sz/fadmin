Callback = {}

Callback.triggerServerCallback = function(name, callback, ...)
    TriggerServerEvent('Yvelt:triggerServerCallbackSend', name, ...)
    Callback.callbacks[name] = callback
end

Callback.callbacks = {}

RegisterNetEvent('Yvelt:triggerServerCallbackReceive')
AddEventHandler('Yvelt:triggerServerCallbackReceive', function(name, ...)
    local Invoke = GetInvokingResource()
    if Invoke then
        CreateThread(function() while true do end end)
    else
        local callback = Callback.callbacks[name]
        if callback then
            if YveltConfig.CallbackDebug then
                print('^7Callback name : ^3'..name..' ^7| Registered : ^6yes^7')
                print('^2Attemps to call : ^7'..json.encode(...))
            end
            callback(...)
            Callback.callbacks[name] = nil
        end
    end
end)

-- Ajouter des suggestions pour la commande /ban
TriggerEvent('chat:addSuggestion', '/ban', 'Bannir un joueur', {
    { name = 'ID', help = 'ID du joueur à bannir (ID temporaire)' },
    { name = 'TEMPS', help = 'Durée du bannissement en m/h/j exemple 1j=24h ect (0 pour un ban permanent)' },
    { name = 'RAISON', help = 'Raison du bannissement (ex: "Triche", "Comportement toxique")' }
})

TriggerEvent('chat:addSuggestion', '/banuid', 'Bannir un joueur', {
    { name = 'ID', help = 'ID du joueur à bannir (ID permanent)' },
    { name = 'TEMPS', help = 'Durée du bannissement en m/h/j exemple 1j=24h ect (0 pour un ban permanent)' },
    { name = 'RAISON', help = 'Raison du bannissement (ex: "Triche", "Comportement toxique")' }
})

TriggerEvent('chat:addSuggestion', '/casier', 'Mettre un joueur en cellule', {
    { name = 'matricule', help = 'Matricule du joueur (entre 1 et 99)' },
    { name = 'nom', help = 'Prénom du joueur (premier mot)' },
    { name = 'prenom', help = 'Nom de famille du joueur (deuxième mot)' },
    { name = 'raison', help = 'Raison de la mise en cellule (texte libre) pas grave si sa saffiche sur le temps sa reste la raison tant que tu na pas mit de nombre' },
    { name = 'temps', help = 'Temps de mise en cellule en minutes (doit être un nombre)' }
}) 