-- =============================================
-- MODE FANTÔME - GgigSpace
-- Pseudo en blanc, invisible dans la liste joueurs/staff
-- =============================================

local isGhostMode = false
local originalName = GetPlayerName(PlayerId())

-- Variable globale pour le menu
adminGhostMode = false

-- Vérifie si le rank du joueur est autorisé
local function hasGhostRankAccess()
    -- La permission est déjà gérée par YveltHelper:getAcces(player, 'fantome')
    -- Cette fonction sert de double vérification côté serveur
    return true
end

-- Active / désactive le mode fantôme
AddEventHandler('YveltAdmin:toggleGhostMode', function(state)
    isGhostMode = state
    adminGhostMode = state

    if state then
        -- Notifie le serveur d'activer le mode fantôme
        TriggerServerEvent('YveltAdmin:sv_setGhostMode', true)
        YveltHelper:clientNotification("~w~Mode fantôme ~g~activé~w~ ! Vous êtes invisible aux autres.")
    else
        -- Notifie le serveur de désactiver le mode fantôme
        TriggerServerEvent('YveltAdmin:sv_setGhostMode', false)
        YveltHelper:clientNotification("~w~Mode fantôme ~r~désactivé~w~ !")
    end
end)

-- Reçoit la confirmation du serveur et applique les effets visuels
AddEventHandler('YveltAdmin:cl_ghostModeResult', function(state)
    isGhostMode = state
    adminGhostMode = state

    if state then
        -- Change la couleur du pseudo en blanc dans les gamertags
        -- Le pseudo affiché aux autres devient blanc via NetworkOverridePlayerName
        NetworkOverridePlayerName("~w~" .. originalName)
    else
        -- Remet le pseudo original
        NetworkOverridePlayerName(originalName)
    end
end)

-- Quand le mode staff est désactivé, on coupe le mode fantôme automatiquement
AddEventHandler('YveltAdmin:onStaffModeDisabled', function()
    if isGhostMode then
        TriggerEvent('YveltAdmin:toggleGhostMode', false)
    end
end)

-- Expose l'état pour d'autres scripts si besoin
exports('isGhostMode', function()
    return isGhostMode
end)
-- Liste locale des joueurs en mode fantôme
local ghostList = {}

-- Reçoit la liste mise à jour depuis le serveur
RegisterNetEvent('YveltAdmin:cl_updateGhostList')
AddEventHandler('YveltAdmin:cl_updateGhostList', function(list)
    ghostList = list

    -- Masque les blips des joueurs fantômes pour les non-staff
    -- (les staff voient quand même les fantômes avec un blip blanc)
    for serverId, isGhost in pairs(ghostList) do
        local playerId = GetPlayerFromServerId(serverId)
        if playerId ~= -1 then
            local blip = GetBlipFromEntity(GetPlayerPed(playerId))
            if DoesBlipExist(blip) then
                if isGhost then
                    -- Staff : blip blanc semi-transparent
                    -- Non-staff : blip supprimé (géré dans adminBlips() existant)
                    SetBlipColour(blip, 4) -- Blanc
                    SetBlipAlpha(blip, 100) -- Semi-transparent
                else
                    SetBlipColour(blip, 2) -- Couleur normale
                    SetBlipAlpha(blip, 255)
                end
            end
        end
    end
end)

-- Au chargement du client, demande la liste des fantômes existants
Citizen.CreateThread(function()
    Wait(3000) -- Attend que le joueur soit bien chargé
    TriggerServerEvent('YveltAdmin:sv_requestGhostList')
end)

-- Fonction utilisable par les autres menus pour savoir si un joueur est fantôme
function IsPlayerGhost(serverId)
    return ghostList[serverId] == true
end
