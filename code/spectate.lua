function boolSpect(id, v, name)
    CreateThread(function()
        local oldPos = GetEntityCoords(PlayerPedId())
        local s = v
        local noclip = noclipActive
        -- local first = true
        if noclipActive then
            toggleNoClip(true)
        end
        TriggerServerEvent('YveltAdmin:Teleport', 'goto', id)
        Wait(100)
        while spectate do
            Wait(0)

            SetEntityCollision(PlayerPedId(), false)

            for _, player in ipairs(GetActivePlayers()) do
                if GetPlayerServerId(player) == tonumber(id) then
                    local ped = GetPlayerPed(player)
                    local coords = GetEntityCoords(ped)
                    local heading = GetEntityHeading(ped)
                    SetEntityNoCollisionEntity(PlayerPedId(), ped, true)
                    SetEntityVisible(PlayerPedId(), false)
                    SetEntityHeading(PlayerPedId(), heading)
                    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
                end
            end
            Visual.Subtitle('Vous regardez '..c..''..name)
            
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
            end
            
            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
            ScaleformMovieMethodAddParamInt(2)
            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 38, true))
            PushScaleformMovieMethodParameterString("Gérer ce joueur")
            EndScaleformMovieMethod()

            BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
            ScaleformMovieMethodAddParamInt(1)
            PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, 45, true))
            PushScaleformMovieMethodParameterString("Quitter le mode spectateur")
            EndScaleformMovieMethod()

            BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
            ScaleformMovieMethodAddParamInt(0)
            EndScaleformMovieMethod()

            DrawScaleformMovieFullscreen(scaleform) 
            if IsControlJustPressed(0, 45) then
                spectate = false
            elseif IsControlJustPressed(0, 38) then
                --RageUI.Visible(adminGestPlayer, true)
                if open then
                    RageUI.NextMenu = adminGestPlayer
                else
                    open = false
                    RageUI.NextMenu = adminGestPlayer
                    OpenMenu()
                end
                selectedPlayer = s
            end
        end
        
        SetEntityCollision(PlayerPedId(), true)

        if noclip then
            toggleNoClip(true)
            BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
            EndScaleformMovieMethod()
            oldPos = nil
        else
            BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
            EndScaleformMovieMethod()
            SetEntityCoords(PlayerPedId(), oldPos)
            SetEntityVisible(PlayerPedId(), true)
            SetEntityCollision(GetPlayerPed(PlayerId()), true, true)
            oldPos = nil
        end
    end)
end