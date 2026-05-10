function MenuPersonnalMain()
    Separator('Gestion personnel')
    if YveltHelper:getAcces(player, 'noclip') then
        RageUI.Checkbox("Activer le mode vole", nil, noclipActive, {}, {
            onChecked = function()
                ExecuteCommand('YveltNoclip')
            end,
            onUnChecked = function()
                ExecuteCommand('YveltNoclip')
            end
        })
    else
        RageUI.Button('Activer le mode vole', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'pseudos') then
        RageUI.Checkbox("Affichage des pseudos", nil, adminPseudo, {}, {
            onSelected = function(Index)
                adminPseudo = Index
            end,
            onChecked = function()
                YveltHelper:displayNames(true)
            end,
            onUnChecked = function()
                YveltHelper:displayNames(false)
            end
        })	
    else
        RageUI.Button('Affichage des pseudos', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'blips') then
        RageUI.Checkbox("Afficher les blips", nil, adminShowBlipsPlayers, { }, {
            onSelected = function(Index)
                adminShowBlipsPlayers = Index
            end,
            onChecked = function()
                adminBlips()
            end,
            onUnChecked = function()
                adminBlips()
            end
        })
    else
        RageUI.Button('Afficher les blips', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'invisible') then
        RageUI.Checkbox("Se rendre invisible", nil, adminInvisibility, { }, {
            onSelected = function(Index)
                adminInvisibility = Index
                if adminInvisibility then
                    SetEntityVisible(PlayerPedId(), false)
                else
                    SetEntityVisible(PlayerPedId(), true)
                end
            end
        })
    else
        RageUI.Button('Se rendre invisible', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'invincible') then
        RageUI.Checkbox("Se rendre invincible", nil, adminInvinsible, { }, {
            onSelected = function(Index)
                adminInvinsible = Index
            end,
            onChecked = function()
                if type(boolInvincibleyvelt) == 'function' then
                    boolInvincibleyvelt()
                else
                    boolInvincible = true
                    CreateThread(function()
                        while boolInvincible do
                            Wait(1)
                            SetEntityInvincible(PlayerPedId(), true)
                        end
                    end)
                end
            end,
            onUnChecked = function()
                boolInvincible = false
            end
        })
    else
        RageUI.Button('Se rendre invincible', nil, {}, false, {})
    end
    RageUI.Checkbox("Afficher les informations", nil, adminHud, { }, {
        onSelected = function(Index)
            adminHud = Index
        end,
        onChecked = function()
            YveltHelper:showHudInfos()
        end,
        onUnChecked = function()
            boolHud = false
        end
    })
    if YveltHelper:getAcces(player, 'superpower') then
        RageUI.Checkbox("Activer le super saut", nil, adminJump, { }, {
            onSelected = function(Index)
                adminJump = Index
            end,
            onChecked = function()
                if type(boolSuperjumpyvelt) == 'function' then
                    boolSuperjumpyvelt()
                else
                    boolSuperjump = true
                    CreateThread(function()
                        while boolSuperjump do
                            Wait(0)
                            SetSuperJumpThisFrame(PlayerId())
                        end
                    end)
                end
            end,
            onUnChecked = function()
                boolSuperjump = false
            end
        })
    else
        RageUI.Button('Activer le super saut', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'superpower') then
        RageUI.Checkbox("Activer le super sprint", nil, adminSprint, { }, {
            onSelected = function(Index)
                adminSprint = Index
            end,
            onChecked = function()
                if type(boolSupersprintyvelt) == 'function' then
                    boolSupersprintyvelt()
                else
                    boolSupersprint = true
                    CreateThread(function()
                        while boolSupersprint do
                            Wait(0)
                            SetPedMoveRateOverride(PlayerPedId(), 2.4)
                        end
                    end)
                end
            end,
            onUnChecked = function()
                boolSupersprint = false
            end
        })
    else
        RageUI.Button('Activer le super sprint', nil, {}, false, {})
    end
    -- if YveltHelper:getAcces(player, 'delgun') then
    --     RageUI.Checkbox("Delgun", nil, delgun, { }, {
    --         onSelected = function(Index)
    --             delgun = Index
    --         end,
    --         onChecked = function()
    --             boolDelgunyvelt()
    --         end,
    --         onUnChecked = function()
    --             boolDelgun = false
    --         end
    --     })
    -- else
    --     RageUI.Button('Delgun', nil, {}, false, {})
    -- end
    if YveltHelper:getAcces(player, 'coords') then
        RageUI.Checkbox("Afficher les coordonnées", nil, adminCoords, { }, {
            onSelected = function(Index)
                adminCoords = Index
            end,
            onChecked = function()
                if type(boolCoordsyvelt) == 'function' then
                    boolCoordsyvelt()
                else
                    boolCoords = true
                    CreateThread(function()
                        while boolCoords do
                            Wait(3)
                            local plyPed = PlayerPedId()
                            local plyCoords = GetEntityCoords(plyPed)
                            local text = ''..YveltConfig.ColorMenu..'X : ~s~' .. ESX.Math.Round(plyCoords.x, 2) .. '\n'..YveltConfig.ColorMenu..'Y : ~s~' .. ESX.Math.Round(plyCoords.y, 2) .. '\n'..YveltConfig.ColorMenu..'Z : ~s~' .. ESX.Math.Round(plyCoords.z, 2) .. '\n'..YveltConfig.ColorMenu..'H : ~s~' .. ESX.Math.Round(GetEntityPhysicsHeading(plyPed), 2)
                            SetTextColour(186, 186, 186, 255)
                            SetTextFont(0)
                            SetTextScale(0.500, 0.500)
                            SetTextWrap(0.0, 1.0)
                            SetTextCentre(false)
                            SetTextDropshadow(0, 0, 0, 0, 255)
                            SetTextEdge(1, 0, 0, 0, 205)
                            BeginTextCommandDisplayText('STRING')
                            AddTextComponentSubstringPlayerName(text)
                            EndTextCommandDisplayText(0.175, 0.81)
                        end
                    end)
                end
            end,
            onUnChecked = function()
                boolCoords = false
            end
        })
    else
        RageUI.Button('Afficher les coordonnées', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'fantome') then
    RageUI.Checkbox("Se rendre en mode fantôme", nil, adminGhostMode, {}, {
        onSelected = function(Index)
            adminGhostMode = Index
        end,
        onChecked = function()
            TriggerEvent('YveltAdmin:toggleGhostMode', true)
        end,
        onUnChecked = function()
            TriggerEvent('YveltAdmin:toggleGhostMode', false)
        end
    })
else
    RageUI.Button('Se rendre en mode fantôme', nil, {}, false, {})
end
    Separator('Gestion téléportation')
    if YveltHelper:getAcces(player, 'teleportation') then
        RageUI.Button('Se téléporer au marker', nil, { RightLabel = YveltConfig.RightLabel }, true, {
            onSelected = function()
                plyPed = PlayerPedId()
                local waypointHandle = GetFirstBlipInfoId(8)

                if DoesBlipExist(waypointHandle) then
                    Citizen.CreateThread(function()
                        local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
                        local foundGround, zCoords, zPos = false, -500.0, 0.0

                        while not foundGround do
                            zCoords = zCoords + 10.0
                            RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
                            Wait(10)
                            foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)

                            if not foundGround and zCoords >= 2000.0 then
                                foundGround = true
                            end
                        end

                        SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
                        YveltHelper:clientNotification("~g~Vous avez été téléporté !")
                    end)
                else
                    YveltHelper:clientNotification("~r~Aucun marker sur la carte !")
                end
            end
        })
        RageUI.List('Téléportations rapide', YveltConfig.FastTravel, IndexFasttravel, nil, {}, true, {
            onListChange = function(Index, Item)
                IndexFasttravel = Index;
            end,
            onSelected = function(Index, Item)
                SetEntityCoords(PlayerPedId(), Item.Position)
            end
        })    
        RageUI.Button('Téléportations custom', nil, { RightLabel = YveltConfig.RightLabel }, true, {
            onSelected = function()
                Callback.triggerServerCallback('YveltAdmin:getTP', function(tp)
                    TpList = tp
                end)
            end
        }, adminMyTeleports)
    else
        RageUI.Button('Se téléporer au marker', nil, {}, false, {})
        RageUI.Button('Téléportations rapide', nil, {}, false, {})
        RageUI.Button('Téléportations custom', nil, {}, false, {})
    end
end