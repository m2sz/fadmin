function MenuMain()
    RageUI.Checkbox("Activer le mode modération", nil, adminStaffmode, {}, {
        onSelected = function(Index)
            adminStaffmode = Index
        end,
        onChecked = function()
            --functionBoolRefresh()
            YveltStaffMode = true
            TriggerServerEvent('YveltAdmin:ChangeStaffMode', 'on')
            YveltHelper:onStaffModeON()
        end,
        onUnChecked = function()
            YveltHelper:onStaffModeOFF()
            if noclipActive then
                ExecuteCommand('Noclip')
            end
            YveltStaffMode = false
            isNameShown = false
            TriggerServerEvent('YveltAdmin:ChangeStaffMode', 'off')
            adminPseudo = false
            boolPseudo = false
            for i, v in pairs(YVELT.GamerTags) do
                RemoveMpGamerTag(v.tags)
            end
            YVELT.GamerTags = {};
            SetEntityVisible(PlayerPedId(), true)
            boolHud = false
            boolInvincible = false
            boolSuperjump = false
            boolCoords = false
            boolSupersprint = false
        end
    })
    if adminStaffmode then
        RageUI.Checkbox("Utiliser le Gun", nil, GunsTaf, {}, {
            onSelected = function(Index)
                GunsTaf = Index
            end,
            onChecked = function()
                -- Vérifie côté serveur si le joueur possède l'item staff avant d'équiper
                Callback.triggerServerCallback('YveltAdmin:HasItem', function(has)
                    if has then
                        TriggerEvent('YveltAdmin:ToggleStaffPistol')
                    else
                        TriggerEvent('esx:showNotification', 'Vous n\'avez pas l\'item Pistolet staff dans votre inventaire')
                    end
                end)
            end,
            onUnChecked = function()
                -- Retire l'arme via l'événement déjà implémenté
                TriggerEvent('YveltAdmin:ToggleStaffPistol')
            end
        })
end
    if adminStaffmode then
        Separator('Gestion administratif')
        if YveltHelper:getAcces(player, 'subReports') then
            RageUI.Button('Liste des reports '..c..'('..ReportsInfos.Waiting..')', nil, {RightLabel = YveltConfig.RightLabel}, true, {}, adminReports)
        else
            RageUI.Button('Liste des reports '..c..'('..ReportsInfos.Waiting..')', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'subPlayers') then
            RageUI.Button('Liste des joueurs', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    -- YveltAdmin:retrievePlayers OLD
                end
            }, adminPlayers)
        else
            RageUI.Button('Liste des joueurs', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'subPersonnel') then
            RageUI.Button('Gestion personnel', nil, { RightLabel = YveltConfig.RightLabel }, true, {}, adminPerso)
        else
            RageUI.Button('Gestion personnel', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'subVehicle') then
            RageUI.Button('Gestion vehicule(s)', nil, { RightLabel = YveltConfig.RightLabel }, true, {}, adminVehicle)
        else
            RageUI.Button('Gestion vehicule(s)', nil, {}, false, {})
        end

        if player.rank == 'fondateur' then
            RageUI.Button('Gestion des ranks', nil, { RightLabel = YveltConfig.RightLabel }, true, {
                onSelected = function()
                    loadRanksAdminData(false)
                end
            }, adminRanks)
        else
            RageUI.Button('Gestion des ranks', nil, {}, false, {})
        end
        
        if player.rank == 'fondateur' then
            Separator('Gestion')    
            -- Staff Liste
            RageUI.Button('Staff Liste', nil, { RightLabel = YveltConfig.RightLabel }, true, {
                onSelected = function()
                    Callback.triggerServerCallback('YveltAdmin:getStaffs', function(cb, cb2)
                        StaffListtt = cb
                        Identifier = cb2
                    end)
                end
            }, adminStaffs)
            -- Gérer les permissions
        end
        if player.rank == 'fondateur' or player.rank == 'noir' then
            Separator('Builder')
            RageUI.Button('GangsBuilder', nil, { RightLabel = YveltConfig.RightLabel }, true, {
                onSelected = function()
                    RageUI.CloseAll() -- Ferme tous les menus ouverts
                    ExecuteCommand('gangs') -- Exécute la commande
                end
            })
              
            RageUI.Button('JobsBuilder (juste le job)', nil, { RightLabel = YveltConfig.RightLabel }, true, {
                onSelected = function()
                    RageUI.CloseAll() -- Ferme tous les menus ouverts
                    ExecuteCommand('jobsbuilder') -- Exécute la commande
                end
            })               
        end
        if player.rank == 'fondateur' then
            Separator('Builder haut grader')
            RageUI.Button('DoorBuilder', nil, { RightLabel = YveltConfig.RightLabel }, true, {
                onSelected = function()
                    RageUI.CloseAll() -- Ferme tous les menus ouverts
                    ExecuteCommand('createdoor') -- Exécute la commande
                end
            })
            RageUI.Button('FarmingBuilder (tout les joueur)', nil, { RightLabel = YveltConfig.RightLabel }, true, {
                onSelected = function()
                    RageUI.CloseAll() -- Ferme tous les menus ouverts
                    ExecuteCommand('createfarming') -- Exécute la commande
                end
            })            
        end
    end
end




