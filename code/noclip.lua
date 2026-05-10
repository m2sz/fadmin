--==--==--==--
-- configNoClipNoClip
--==--==--==--
NoClipSpeed = 0.5
local firstopen = true
configNoClip = {
    Locale = 'en',

    Controls = {
        -- FiveM Controls: https://docs.fivem.net/game-references/controls/
        openKey = 170, -- CANC
        goUp = 22, -- Q
        goDown = 61, -- Z
        turnLeft = 34, -- A
        turnRight = 35, -- D
        goForward = 32,  -- W
        goBackward = 33, -- S
        changeSpeed = 335, -- Souris vers le haut
        changeSpeedDown = 336 , -- Souris vers le bas
        camMode = 74, -- H
    },

    Speeds = {
        -- You can add or edit existing speeds with relative label
        { label = 'Very Slow', speed = 0},
        { label = 'Slow', speed = 0.5},
        { label = 'Normal', speed = 2},
        { label = 'Fast', speed = 5},
        { label = 'Very Fast', speed = 10},
        { label = 'Max', speed = 15},
    },

    Offsets = {
        y = 0.5, -- Forward and backward movement speed multiplier
        z = 0.2, -- Upward and downward movement speed multiplier
        h = 3, -- Rotation movement speed multiplier
    },

    EnableHUD = true,

    FrozenPosition = false, -- Toggle "frozen" position while noclip is active

    DisableWeaponWheel = true, -- Disable weapon wheel while noclip is active
}




local acces = false
local playerGroup = nil
noclipActive = false
local firstTime = true


RegisterCommand('YveltNoclip', function()
    if firstopen then
        Callback.triggerServerCallback('YveltAdmin:getRank', function(group)
            playerGroup = group
            player = playerGroup
        end)
        
        while playerGroup == nil do
            Wait(1)
        end
        if YveltHelper:getAcces(player, 'noclip') then
            if YveltStaffMode then
                toggleNoClip()
            else
                YveltHelper:clientNotification('~r~Le mode staff n\'est pas actif !')
            end
        else
            YveltHelper:clientNotification("~r~Vous n'avez pas la permission")
        end
        firstopen = false
    else
        if YveltHelper:getAcces(player, 'noclip') then
            if YveltStaffMode then
                toggleNoClip()
            else
                YveltHelper:clientNotification('~r~Le mode staff n\'est pas actif !')
            end
        else
            YveltHelper:clientNotification("~r~Vous n'avez pas la permission")
        end
    end
end)

local index = 1
local currentSpeed = configNoClip.Speeds[index].speed
local followCamMode = true
local showHelpCommands = true

local closestPlayer = nil
local closestDistance = -1

local removeInvisibility = nil

if YveltConfig.NoclipType == 1 then
    function toggleNoClip(args)
        removeInvisibility = args
        noclipActive = not noclipActive
        --ChangeNoClipIntoMenu(noclipActive)
        if spectate then
            return YveltHelper:clientNotification('~r~Vous êtes en mode spectateur')
        end
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            noclipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
        else
            noclipEntity = PlayerPedId()
        end
        
        if noclipActive then
            SetEntityVisible(noclipEntity, false, false);
            SetEntityAlpha(PlayerPedId(), 150, false)
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                SetEntityAlpha(noclipEntity, 150, false)
            else
                GiveWeaponToPed(PlayerPedId(), YveltConfig.StaffGunName, 255, false, true)
            end
        else
            SetEntityVisible(noclipEntity, true, false);
            ResetEntityAlpha(PlayerPedId())
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                ResetEntityAlpha(noclipEntity)
            else
                GiveWeaponToPed(PlayerPedId(), YveltConfig.StaffGunName, 255, false, true)
            end
        end

        if configNoClip.DisableWeaponWheel and noclipActive then
            DisableControlAction(0, 37, true)
            -- if(IsPedArmed(GetPlayerPed(-1), 1 | 2 | 4)) then 
            --     SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), 1)
            -- end
        end

        if configNoClip.FrozenPosition then SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)+180) end
        SetEntityCollision(noclipEntity, not noclipActive, not noclipActive)
        FreezeEntityPosition(noclipEntity, noclipActive)
        SetEntityInvincible(noclipEntity, noclipActive)
        SetVehicleRadioEnabled(noclipEntity, not noclipActive)
        SetEveryoneIgnorePlayer(noclipEntity, noclipActive);
        SetPoliceIgnorePlayer(noclipEntity, noclipActive);

        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
            ClearPedTasksImmediately(PlayerPedId())
        end


        if noclipActive then
            while noclipActive do

                local playersInCamera = GetPlayersInCameraView()
                if #playersInCamera > 1 then
                    for _, playerId in ipairs(playersInCamera) do
                        if GetPlayerServerId(playerId) ~= GetPlayerServerId(PlayerId()) then
                            local playerPed = GetPlayerPed(playerId)
                            local playerCoords = GetEntityCoords(playerPed)
                            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), playerCoords, true)

                            if closestDistance == -1 or distance < closestDistance then
                                closestPlayer = GetPlayerServerId(playerId)
                                -- DrawMarker(21, playerCoords.x, playerCoords.y, playerCoords.z + 1.0, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, true, true)
                                closestDistance = distance
                            end
                        end
                    end
                else
                    closestPlayer = nil
                    closestDistance = -1
                end

                if showHelpCommands then
                    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
                    EndScaleformMovieMethod()
                    
                    if YveltHelper:getAcces(player, 'pseudos') then
                        if IsControlJustPressed(2, 23) then
                            if adminPseudo then
                                adminPseudo = false
                                YveltHelper:displayNames(adminPseudo)
                            else
                                adminPseudo = true
                                YveltHelper:displayNames(adminPseudo)
                            end
                        end
                        if closestPlayer ~= 0 and closestPlayer then
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(7)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 38, true))
                            PushScaleformMovieMethodParameterString("Gérer ce joueur ("..closestPlayer..")")
                            EndScaleformMovieMethod()
                
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(6)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 45, true))
                            PushScaleformMovieMethodParameterString("Spactate ce joueur ("..closestPlayer..")")
                            EndScaleformMovieMethod()
                            
                            
                        else
                            BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
                            EndScaleformMovieMethod()
                        end
                        if adminPseudo then
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(5)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 23, true))
                            PushScaleformMovieMethodParameterString("Cacher les pseudos")
                            EndScaleformMovieMethod()
                        else
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(5)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 23, true))
                            PushScaleformMovieMethodParameterString("Afficher les pseudos")
                            EndScaleformMovieMethod()
                        end
                    else
                        if closestPlayer ~= 0 and closestPlayer then
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(6)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 38, true))
                            PushScaleformMovieMethodParameterString("Gérer ce joueur ("..closestPlayer..")")
                            EndScaleformMovieMethod()
                
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(5)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 45, true))
                            PushScaleformMovieMethodParameterString("Spactate ce joueur ("..closestPlayer..")")
                            EndScaleformMovieMethod()
                            
                        else
                            BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
                            EndScaleformMovieMethod()
                        end
                    end

                    
                    -- BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                    -- ScaleformMovieMethodAddParamInt(7)
                    -- PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, configNoClip.Controls.openKey, true))
                    -- PushScaleformMovieMethodParameterString("Désactiver le noclip")
                    -- EndScaleformMovieMethod()

                    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                    ScaleformMovieMethodAddParamInt(4)
                    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, configNoClip.Controls.camMode, true))
                    PushScaleformMovieMethodParameterString("Mode de caméra")
                    EndScaleformMovieMethod()

                    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                    ScaleformMovieMethodAddParamInt(3)
                    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 56, true))
                    PushScaleformMovieMethodParameterString("Cacher ceci")
                    EndScaleformMovieMethod()

                    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                    ScaleformMovieMethodAddParamInt(2)
                    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, configNoClip.Controls.goDown, true))
                    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, configNoClip.Controls.goUp, true))
                    PushScaleformMovieMethodParameterString("Monter / descendre")
                    EndScaleformMovieMethod()

                    -- BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                    -- ScaleformMovieMethodAddParamInt(3)
                    -- PushScaleformMovieMethodParameterString(GetControlInstructionalButton(1, configNoClip.Controls.turnRight, true))
                    -- PushScaleformMovieMethodParameterString(GetControlInstructionalButton(1, configNoClip.Controls.turnLeft, true))
                    -- PushScaleformMovieMethodParameterString("Gauche / droite")
                    -- EndScaleformMovieMethod()

                    -- BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                    -- ScaleformMovieMethodAddParamInt(2)
                    -- PushScaleformMovieMethodParameterString(GetControlInstructionalButton(1, configNoClip.Controls.goBackward, true))
                    -- PushScaleformMovieMethodParameterString(GetControlInstructionalButton(1, configNoClip.Controls.goForward, true))
                    -- PushScaleformMovieMethodParameterString("Avancer / reculer")
                    -- EndScaleformMovieMethod()

                    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                    ScaleformMovieMethodAddParamInt(1)
                    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, configNoClip.Controls.changeSpeed, true))
                    PushScaleformMovieMethodParameterString("Vitesse du noclip ("..currentSpeed..")", currentSpeed)
                    EndScaleformMovieMethod()

                    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
                    ScaleformMovieMethodAddParamInt(0)
                    EndScaleformMovieMethod()

                    DrawScaleformMovieFullscreen(scaleform)            
                end

                local yoff = 0.0
                local zoff = 0.0

                if IsDisabledControlJustPressed(0, configNoClip.Controls.camMode) then
                    followCamMode = not followCamMode
                end

                if IsDisabledControlJustPressed(0, 56) then
                    if showHelpCommands then
                        showHelpCommands = false
                    else
                        showHelpCommands = true
                    end
                end




                HideHudComponentThisFrame(19)
                HideHudComponentThisFrame(20)
                HideHudComponentThisFrame(21)
                HideHudComponentThisFrame(22)

                if IsControlJustPressed(0, configNoClip.Controls.changeSpeed) then
                    if currentSpeed > 19 then
                        currentSpeed = 20
                    else
                        currentSpeed = currentSpeed + 1
                    end
                end

                if IsControlJustPressed(0, configNoClip.Controls.changeSpeedDown) then
                    if currentSpeed < 1 then
                        currentSpeed = 0
                    else
                        currentSpeed = currentSpeed - 1
                    end
                end
                    
                DisableControlAction(0, 30, true)
                DisableControlAction(0, 31, true)
                DisableControlAction(0, 32, true)
                DisableControlAction(0, 33, true)
                DisableControlAction(0, 34, true)
                DisableControlAction(0, 35, true)
                DisableControlAction(0, 266, true)
                DisableControlAction(0, 267, true)
                DisableControlAction(0, 268, true)
                DisableControlAction(0, 269, true)
                DisableControlAction(0, 44, true)
                DisableControlAction(0, 20, true)
                DisableControlAction(0, 75, true)
                DisableControlAction(0, 74, true)

                if IsDisabledControlPressed(0, configNoClip.Controls.goForward) then
                    if configNoClip.FrozenPosition then
                        yoff = -configNoClip.Offsets.y
                    else 
                        yoff = configNoClip.Offsets.y
                    end
                end
                
                if IsDisabledControlPressed(0, configNoClip.Controls.goBackward) then
                    if configNoClip.FrozenPosition then
                        yoff = configNoClip.Offsets.y
                    else
                        yoff = -configNoClip.Offsets.y
                    end
                end

                if not followCamMode and IsDisabledControlPressed(0, configNoClip.Controls.turnLeft) then
                    SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())+configNoClip.Offsets.h)
                end
                
                if not followCamMode and IsDisabledControlPressed(0, configNoClip.Controls.turnRight) then
                    SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())-configNoClip.Offsets.h)
                end
                
                if IsDisabledControlPressed(0, configNoClip.Controls.goUp) then
                    zoff = configNoClip.Offsets.z
                end
                
                if IsDisabledControlPressed(0, configNoClip.Controls.goDown) then
                    zoff = -configNoClip.Offsets.z
                end
                
                local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))
                local heading = GetEntityHeading(noclipEntity)
                SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
                if configNoClip.FrozenPosition then
                    SetEntityRotation(noclipEntity, 0.0, 0.0, 180.0, 0, false)
                else 
                    SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
                end
                if(followCamMode) then
                    SetEntityHeading(noclipEntity, GetGameplayCamRelativeHeading());
                else
                    SetEntityHeading(noclipEntity, heading);
                end
                if configNoClip.FrozenPosition then
                    SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, not noclipActive, not noclipActive, not noclipActive)
                else 
                    SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, noclipActive, noclipActive, noclipActive)
                end
                SetLocalPlayerVisibleLocally(true);
                Wait(0)

                if IsControlJustPressed(2, 45) then
                    selectedPlayer = nil
                    if PlayersList then
                        for k, v in pairs(PlayersList) do
                            if v.source == closestPlayer then
                                selectedPlayer = k
                            end
                        end
                        if selectedPlayer then
                            spectate = true
                            boolSpect(closestPlayer, selectedPlayer, PlayersList[selectedPlayer].name)
                        end
                    -- else
                    --     Callback.triggerServerCallback('YveltAdmin:retrievePlayers', function(players)
                    --         PlayersList = players
                    --     end)
                    --     while PlayersList == nil do
                    --         Wait(1)
                    --     end
                    --     for k, v in pairs(PlayersList) do
                    --         if v.source == closestPlayer then
                    --             selectedPlayer = v
                    --         end
                    --     end
                    --     if selectedPlayer then
                    --         spectate = true
                    --         boolSpect(closestPlayer, selectedPlayer, selectedPlayer.name)
                        -- end
                    -- end
                elseif IsControlJustPressed(2, 38) then
                    selectedPlayer = nil
                    if PlayersList then
                        for k, v in pairs(PlayersList) do
                            if v.source == closestPlayer then
                                selectedPlayer = k
                            end
                        end
                        if PlayersList then
                            if open then
                                RageUI.NextMenu = adminGestPlayer
                            else
                                open = false
                                RageUI.NextMenu = adminGestPlayer
                                OpenMenu()
                            end
                        end
                    -- else
                    --     Callback.triggerServerCallback('YveltAdmin:retrievePlayers', function(players)
                    --         PlayersList = players
                    --     end)
                    --     while PlayersList == nil do
                    --         Wait(1)
                    --     end
                    --     for k, v in pairs(PlayersList) do
                    --         if v.source == closestPlayer then
                    --             selectedPlayer = v
                    --         end
                    --     end
                    --     if PlayersList then
                    --         if open then
                    --             RageUI.NextMenu = adminGestPlayer
                    --         else
                    --             open = false
                    --             RageUI.NextMenu = adminGestPlayer
                    --             OpenMenu()
                    --         end
                        end
                    end
                end
            end
        end
        if not removeInvisibility then
            SetEntityVisible(PlayerPedId(), true)
            Wait(10)
            if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                ClearPedTasksImmediately(PlayerPedId())
            end
        end
    end
else
    function toggleNoClip(args)
        removeInvisibility = args
        noclipActive = not noclipActive
        --ChangeNoClipIntoMenu(noclipActive)
        if spectate then
            return YveltHelper:clientNotification('~r~Vous êtes en mode spectateur')
        end
        SetEntityInvincible(PlayerPedId(), true)
        Citizen.CreateThread(function()
            while noclipActive do
                Wait(1)
                HideHudComponentThisFrame(19)
                HideHudComponentThisFrame(20)
                HideHudComponentThisFrame(21)
                HideHudComponentThisFrame(22)
                local pCoords = GetEntityCoords(PlayerPedId(), false)
                local camCoords = getCamDirection()
                SetEntityVelocity(PlayerPedId(), 0.01, 0.01, 0.01)
                SetEntityCollision(PlayerPedId(), 0, 1)
                FreezeEntityPosition(PlayerPedId(), true)

                if IsControlPressed(0, 32) then
                    pCoords = pCoords + (NoClipSpeed * camCoords)
                end

                if IsControlPressed(0, 269) then
                    pCoords = pCoords - (NoClipSpeed * camCoords)
                end
                if IsDisabledControlJustPressed(0, 56) then
                    if showHelpCommands then
                        showHelpCommands = false
                    else
                        showHelpCommands = true
                    end
                end
                if IsDisabledControlJustPressed(1, 15) then
                    if NoClipSpeed < 10.0 then
                        NoClipSpeed = NoClipSpeed + 0.3
                    end
                end
                if IsDisabledControlJustPressed(1, 14) then
                    NoClipSpeed = NoClipSpeed - 0.3
                    if NoClipSpeed < 0 then
                        NoClipSpeed = 0.1
                    end
                end
                SetEntityCoordsNoOffset(PlayerPedId(), pCoords, true, true, true)
                SetEntityVisible(PlayerPedId(), 0, 0)

                if IsControlJustPressed(2, 45) then
                    selectedPlayer = nil
                    if PlayersList then
                        for k, v in pairs(PlayersList) do
                            if v.source == closestPlayer then
                                selectedPlayer = k
                            end
                        end
                        if selectedPlayer then 
                            spectate = true
                            boolSpect(closestPlayer, selectedPlayer, PlayersList[selectedPlayer].name)
                        end
                    -- else
                    --     Callback.triggerServerCallback('YveltAdmin:retrievePlayers', function(players)
                    --         PlayersList = players
                    --     end)
                    --     while PlayersList == nil do
                    --         Wait(1)
                    --     end
                    --     for k, v in pairs(PlayersList) do
                    --         if v.source == closestPlayer then
                    --             selectedPlayer = v
                    --         end
                    --     end
                    --     if selectedPlayer then 
                    --         spectate = true
                    --         boolSpect(closestPlayer, selectedPlayer, selectedPlayer.name)
                    --     end
                    end
                elseif IsControlJustPressed(2, 38) then
                    selectedPlayer = nil
                    if PlayersList then
                        for k, v in pairs(PlayersList) do
                            if v.source == closestPlayer then
                                selectedPlayer = k
                            end
                        end
                        if selectedPlayer then 
                            if open then
                                RageUI.NextMenu = adminGestPlayer
                            else
                                open = false
                                RageUI.NextMenu = adminGestPlayer
                                OpenMenu()
                            end
                        end
                    -- else
                    --     Callback.triggerServerCallback('YveltAdmin:retrievePlayers', function(players)
                    --         PlayersList = players
                    --     end)
                    --     while PlayersList == nil do
                    --         Wait(1)
                    --     end
                    --     for k, v in pairs(PlayersList) do
                    --         if v.source == closestPlayer then
                    --             selectedPlayer = v
                    --         end
                    --     end
                    --     if selectedPlayer then 
                    --         if open then
                    --             RageUI.NextMenu = adminGestPlayer
                    --         else
                    --             open = false
                    --             RageUI.NextMenu = adminGestPlayer
                    --             OpenMenu()
                    --         end
                    --     end
                    end
                end
                local playersInCamera = GetPlayersInCameraView()
                if #playersInCamera > 1 then
                    for _, playerId in ipairs(playersInCamera) do
                        if GetPlayerServerId(playerId) ~= GetPlayerServerId(PlayerId()) then
                            local playerPed = GetPlayerPed(playerId)
                            local playerCoords = GetEntityCoords(playerPed)
                            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), playerCoords, true)

                            if closestDistance == -1 or distance < closestDistance then
                                closestPlayer = GetPlayerServerId(playerId)
                                -- DrawMarker(21, playerCoords.x, playerCoords.y, playerCoords.z + 1.0, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3,0.3, 0.3, 255, 0, 0, 255, true, true, true, true)
                                closestDistance = distance
                            end
                        end
                    end
                else
                    closestPlayer = nil
                    closestDistance = -1
                end

                if showHelpCommands then
                    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
                    EndScaleformMovieMethod()
                    if YveltHelper:getAcces(player, 'pseudos') then
                        if IsControlJustPressed(2, 23) then
                            if adminPseudo then
                                adminPseudo = false
                                YveltHelper:displayNames(adminPseudo)
                            else
                                adminPseudo = true
                                YveltHelper:displayNames(adminPseudo)
                            end
                        end
                        if closestPlayer ~= 0 and closestPlayer then
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(5)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 38, true))
                            PushScaleformMovieMethodParameterString("Gérer ce joueur ("..closestPlayer..")")
                            EndScaleformMovieMethod()
                
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(4)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 45, true))
                            PushScaleformMovieMethodParameterString("Spactate ce joueur ("..closestPlayer..")")
                            EndScaleformMovieMethod()
                        end
                        
                        if adminPseudo then
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(3)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 23, true))
                            PushScaleformMovieMethodParameterString("Cacher les pseudos")
                            EndScaleformMovieMethod()
                        else
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(3)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 23, true))
                            PushScaleformMovieMethodParameterString("Afficher les pseudos")
                            EndScaleformMovieMethod()
                        end
                    else
                        if closestPlayer ~= 0 and closestPlayer then
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(4)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 38, true))
                            PushScaleformMovieMethodParameterString("Gérer ce joueur ("..closestPlayer..")")
                            EndScaleformMovieMethod()
                
                            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                            ScaleformMovieMethodAddParamInt(3)
                            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 45, true))
                            PushScaleformMovieMethodParameterString("Spactate ce joueur ("..closestPlayer..")")
                            EndScaleformMovieMethod()
                        end
                    end
                    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                    ScaleformMovieMethodAddParamInt(2)
                    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 56, true))
                    PushScaleformMovieMethodParameterString("Cacher ceci")
                    EndScaleformMovieMethod()

                    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                    ScaleformMovieMethodAddParamInt(1)
                    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, configNoClip.Controls.changeSpeed, true))
                    PushScaleformMovieMethodParameterString("Vitesse du noclip ("..NoClipSpeed..")", NoClipSpeed)
                    EndScaleformMovieMethod()

                    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
                    ScaleformMovieMethodAddParamInt(0)
                    EndScaleformMovieMethod()

                    DrawScaleformMovieFullscreen(scaleform)            
                end
            end
            if not removeInvisibility then
                ClearPedTasksImmediately(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                SetEntityInvincible(PlayerPedId(), false)
                SetEntityVisible(PlayerPedId(), 1, 0)
                SetEntityCollision(PlayerPedId(), 1, 1)
            end
            removeInvisibility = nil
        end)
    end
end

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
    local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

    if len ~= 0 then
        coords = coords / len
    end

    return coords
end

RegisterKeyMapping('YveltNoclip', 'Activer / désactiver le noclip', 'keyboard', 'F3')

function GetPlayersInCameraView()
    local playersInCamera = {}
    local cameraCoords = GetGameplayCamCoord()
    local cameraRotation = GetGameplayCamRot(2)

    for _, playerId in ipairs(GetActivePlayers()) do
        local playerPed = GetPlayerPed(playerId)
        local playerCoords = GetEntityCoords(playerPed)

        -- Vérifiez si le joueur est dans le champ de la caméra
        if HasEntityClearLosToEntity(playerPed, PlayerPedId(), 17) and
            IsEntityOnScreen(playerPed) then
            table.insert(playersInCamera, playerId)
        end
    end

    return playersInCamera
end

function IsPlayerInCameraView(playerCoords, cameraCoords, cameraRotation)
    local vector = vector3(playerCoords.x - cameraCoords.x, playerCoords.y - cameraCoords.y, playerCoords.z - cameraCoords.z)
    local camForward = vector3(math.cos(cameraRotation.z * math.pi / 180.0), math.sin(cameraRotation.z * math.pi / 180.0), 0.0)
    local dotProduct = camForward.x * vector.x + camForward.y * vector.y + camForward.z * vector.z
    local cosAngle = dotProduct / #(camForward * vector)

    return cosAngle > 0.5
end

