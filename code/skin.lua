local playerSkin = nil
local currentRank = nil -- Stocker le rang actuel pour éviter des rechargements inutiles
local resetTimer = nil -- Référence pour le timer

function applySkin(table)
    if YveltStaffMode then -- Vérifie si le mode staff est actif
        if table and table.rank then
            local rankSkin = YveltConfig.staffSkins[table.rank]
            if rankSkin then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    -- Sauvegarde le skin actuel avant de changer
                    playerSkin = {
                        sex = skin.sex,
                        tshirt_1 = skin.tshirt_1,
                        tshirt_2 = skin.tshirt_2,
                        torso_1 = skin.torso_1,
                        torso_2 = skin.torso_2,
                        arms = skin.arms,
                        pants_1 = skin.pants_1,
                        pants_2 = skin.pants_2,
                        shoes_1 = skin.shoes_1,
                        shoes_2 = skin.shoes_2,
                    }

                    -- Applique le skin lié au rang
                    TriggerEvent('skinchanger:loadSkin', rankSkin)
                    currentRank = table.rank -- Met à jour le rang actuel
                end)

                -- Si un timer existe déjà, le supprimer avant d'en recréer un
                if resetTimer then
                    ResetTimer(resetTimer)
                end

                -- Configurer le timer pour réappliquer la tenue toutes les 5 secondes
                resetTimer = StartTimer(function()
                    if YveltStaffMode then -- Réapplique uniquement si le mode staff est actif
                        TriggerEvent('skinchanger:loadSkin', rankSkin)
                    else
                        resetSkin() -- Restaure la tenue normale si le mode staff est désactivé
                    end
                end, 1000) -- 5000 ms = 5 secondes
            end
        end
    else
        YveltHelper:clientNotification('~r~Le mode staff n\'est pas actif !')
    end
end

function resetSkin()
    if playerSkin then
        -- Restaure le skin d'origine
        TriggerEvent('skinchanger:loadSkin', playerSkin)
        playerSkin = nil
        currentRank = nil -- Réinitialise le rang actuel
        if resetTimer then
            ResetTimer(resetTimer) -- Arrête le timer si nécessaire
            resetTimer = nil
        end
    end
end

-- Helper pour démarrer un timer
function StartTimer(callback, interval)
    local timer = Citizen.CreateThread(function()
        while true do
            Citizen.Wait(interval)
            callback()
        end
    end)
    return timer
end

-- Helper pour arrêter un timer
function ResetTimer(timer)
    if timer then
        Citizen.KillThread(timer)
    end
end
