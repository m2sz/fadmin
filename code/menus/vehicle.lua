local colour_index= {
	primary = {1,5},
	secondary = {1,5}
}

local selectedPrimaryColor = {
	r = 0,
	g = 0,
	b = 0,
}

function MenuVehicle()
    if IsControlPressed(0, 19) then
        SetMouseCursorActiveThisFrame()
    end
    if YveltHelper:getAcces(player, 'spawnVeh') then
        RageUI.Button("Spawn avec le nom", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                local modelName = KeyboardInput('YveltCreateVehicle', "Veuillez entrer le "..YveltConfig.ColorMenu.."nom~s~ du véhicule", '', 30)
                
                if modelName and modelName ~= "" then
                    -- Spawn du véhicule
                    YveltHelper:spawnVehicle(modelName)
                    
                    -- Récupérer les informations du joueur
                    local playerName = GetPlayerName(PlayerId()) -- Nom du joueur
                    local playerId = GetPlayerServerId(PlayerId()) -- Identifiant serveur
    
                    -- Envoyer l'événement au serveur pour le log
                    TriggerServerEvent('server:logVehicleSpawnToDiscord', playerName, playerId, modelName)
    
                    ESX.ShowNotification("Véhicule spawné et log envoyé.")
                else
                    ESX.ShowNotification("Nom du véhicule invalide.")
                end
            end
        })
    else
        RageUI.Button('Spawn avec le nom', nil, {}, false, {})
    end  
    if YveltHelper:getAcces(player, 'delVeh') then
        RageUI.Button("Supprimer le véhicule", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            end,
            onSelected = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)

                if DoesEntityExist(vehicle) then
                    deleteVeh(vehicle)
                end
            end
        })
    else
        RageUI.Button('Supprimer le véhicule', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'repairVeh') then
        RageUI.Button("Réparer le véhicule", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            end,
            onSelected = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)

                if DoesEntityExist(vehicle) then
                    repairVeh(vehicle)
                end
            end
        })
    else
        RageUI.Button('Réparer le véhicule', nil, {}, false, {})
    end
    Separator('Gestion véhicule')
    if YveltHelper:getAcces(player, 'plateVeh') then
        RageUI.Button("Changer la plaque", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            end,
            onSelected = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local modelName = KeyboardInput('YveltPlate', "Veuillez entrer la "..c.."plaque~s~ du véhicule", '', 8)

                if DoesEntityExist(vehicle) then
                    plateVeh(vehicle, modelName)
                end
            end
        })
    else
        RageUI.Button('Changer la plaque', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'fuelVeh') then
        RageUI.Button("Faire le plein du véhicule", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            end,
            onSelected = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                --local modelName = KeyboardInput('YveltPlate', "Veuillez entrer la "..c.."plaque~s~ du véhicule", '', 8)

                if DoesEntityExist(vehicle) then
                    gazVeh(vehicle, modelName)
                end
            end
        })
    else
        RageUI.Button('Faire le plein du véhicule', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'colorVeh') then
        RageUI.Button('Couleur primaire', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function(Index)
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local targetVeh = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            
            end
        })
        RageUI.ColourPanel("primaire", RageUI.PanelColour.Lscustom, colour_index.primary[1], colour_index.primary[2], {
            onColorChange = function(MinimumIndex, CurrentIndex)
                colour_index.primary[1] = MinimumIndex
                colour_index.primary[2] = CurrentIndex

                selectedPrimaryColor.r = RageUI.PanelColour.Lscustom[CurrentIndex][1]
                selectedPrimaryColor.g = RageUI.PanelColour.Lscustom[CurrentIndex][2]
                selectedPrimaryColor.b = RageUI.PanelColour.Lscustom[CurrentIndex][3]
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local targetVeh = ESX.Game.GetClosestVehicle(playerCoords)
                SetVehicleCustomPrimaryColour(targetVeh, selectedPrimaryColor.r, selectedPrimaryColor.g, selectedPrimaryColor.b)
            end
        }, 7, {})
        RageUI.Button('Couleur secondaire', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function(Index)
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local targetVeh = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            
            end
        })
        RageUI.ColourPanel("secondaire", RageUI.PanelColour.Lscustom, colour_index.primary[1], colour_index.primary[2], {
            onColorChange = function(MinimumIndex, CurrentIndex)
                colour_index.primary[1] = MinimumIndex
                colour_index.primary[2] = CurrentIndex

                selectedPrimaryColor.r = RageUI.PanelColour.Lscustom[CurrentIndex][1]
                selectedPrimaryColor.g = RageUI.PanelColour.Lscustom[CurrentIndex][2]
                selectedPrimaryColor.b = RageUI.PanelColour.Lscustom[CurrentIndex][3]
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local targetVeh = ESX.Game.GetClosestVehicle(playerCoords)
                SetVehicleCustomSecondaryColour(targetVeh, selectedPrimaryColor.r, selectedPrimaryColor.g, selectedPrimaryColor.b)
            end
        }, 8, {})
    else
        RageUI.Button('Couleur primaire', nil, {}, false, {})
        RageUI.Button('Couleur secondaire', nil, {}, false, {})
    end
    if YveltHelper:getAcces(player, 'retournerVeh') then
        RageUI.Button("Retourner le véhicule", nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onActive = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                local vehiclePos = GetEntityCoords(vehicle)
                DrawMarker(21, vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.3, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)
            end,
            onSelected = function()
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicle = ESX.Game.GetClosestVehicle(playerCoords)
                --local modelName = KeyboardInput('YveltPlate', "Veuillez entrer la "..c.."plaque~s~ du véhicule", '', 8)

                if DoesEntityExist(vehicle) then
                    retournerVeh(vehicle, modelName)
                end
            end
        })
    else
        RageUI.Button('Retourner le véhicule', nil, {}, false, {})
    end
    --Separator('Gestion véhicule(s)')
    YveltHelper:CustomMenuVehicle()
    for k, v in pairs(YveltMenus.vehicle) do
        if v.type == 'button' then
            if perm then
                if YveltHelper:getAcces(player, perm) then
                    if subMenu then
                        RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                            onActive = function()
                                v.onActive()
                            end,
                            onSelected = function()
                                v.onSelected()
                            end
                        }, subMenu)
                    else
                        RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                            onActive = function()
                                v.onActive()
                            end,
                            onSelected = function()
                                v.onSelected()
                            end
                        })
                    end
                else
                    RageUI.Button(v.name, v.desc, {}, false, {})
                end
            else
                if subMenu then
                    RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                        onActive = function()
                            v.onActive()
                        end,
                        onSelected = function()
                            v.onSelected()
                        end
                    }, subMenu)
                else
                    RageUI.Button(v.name, v.desc, v.rightLabel, true, {
                        onActive = function()
                            v.onActive()
                        end,
                        onSelected = function()
                            v.onSelected()
                        end
                    })
                end
            end
        elseif v.type == 'separator' then
            RageUI.Separator(v.name)
        else
            RageUI.Button('~r~Erreur de configuration', nil, {}, false, {})
        end
    end
end