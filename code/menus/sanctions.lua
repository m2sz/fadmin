function menuGestPlayerSantions()
    RageUI.List("Crée une nouvelle sanction", YveltAdminSanctions, (YveltAdminSanctions.Index or 1), "Vous permet de mettre une sanction à "..sanctionSelectedName, {}, true, {
        onListChange = function(Index)
            YveltAdminSanctions.Index = Index
        end,
        onSelected = function(Index)
            if YveltAdminSanctions.Index == 1 then
                YveltSanction = KeyboardInput('YveltSanction', "Entrez la ~r~raison~s~ du warn sur le joueur "..sanctionSelectedName, '', 30)
                --Warn
                if YveltSanction then
                    ExecuteCommand('warn '..PlayersList[selectedPlayer].source..' '..YveltSanction)
                else
                    YveltHelper:clientNotification('~r~L\'action a été annulé')
                end
            elseif YveltAdminSanctions.Index == 2 then
                YveltSanction = KeyboardInput('YveltSanction', "Entrez la ~r~raison~s~ du kick sur le joueur "..sanctionSelectedName, '', 30)
                --Kick
                if YveltSanction then
                    ExecuteCommand('kick '..PlayersList[selectedPlayer].source..' '..YveltSanction)
                else
                    YveltHelper:clientNotification('~r~L\'action a été annulé')
                end
            elseif YveltAdminSanctions.Index == 3 then
                YveltSanction = KeyboardInput('YveltSanction', "Entrez le ~r~temps~s~ du jail sur le joueur "..sanctionSelectedName, '', 30)
                YveltSanction2 = KeyboardInput('YveltSanction2', "Entrez le ~r~raison~s~ du jail sur le joueur "..sanctionSelectedName, '', 30)
                --Jail
                if YveltSanction and YveltSanction2 then
                    ExecuteCommand('jail '..PlayersList[selectedPlayer].source..' '..YveltSanction..' '..YveltSanction2)
                else
                    YveltHelper:clientNotification('~r~L\'action a été annulé')
                end
            elseif YveltAdminSanctions.Index == 4 then
                YveltSanction = KeyboardInput('YveltSanction', "Entrez le ~r~temps~s~ du ban (1j / 1h / 0)", '', 30)
                YveltSanction2 = KeyboardInput('YveltSanction', "Entrez la ~r~raison~s~ du ban sur le joueur "..sanctionSelectedName, '', 30)
                --Ban
                if YveltSanction and YveltSanction2 then
                    ExecuteCommand('ban '..PlayersList[selectedPlayer].source..' '..YveltSanction..' '..YveltSanction2)
                else
                    YveltHelper:clientNotification('~r~L\'action a été annulé')
                end
            end
        end
    })
    Separator('Sanction(s) du joueur')
    if adminSanctions == nil then
        RageUI.Separator()
        RageUI.Separator('~r~Chargement des données...')
        RageUI.Separator()
    else
        if #adminSanctions ~= 0 then
            for k, v in pairs(adminSanctions) do
                RageUI.Button(v.sanctionType..' par le staff "'..v.staff..'"', "Raison : "..v.sanctionDesc.."\nLe "..v.date, {RightLabel = '(ID : '..v.id..')'}, true, {
                    onSelected = function()
                        --A FINIR FDP
                    end		
                })
            end
        else
            RageUI.Separator()
            RageUI.Separator('~g~Aucune sanction pour ce joueur')
            RageUI.Separator()
        end
    end
end