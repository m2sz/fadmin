function MenuPlayers()
    if YveltHelper:getAcces(player, 'subStaffs') then
        RageUI.Button('Voir la liste des staffs', nil, { RightLabel = YveltConfig.RightLabel }, true, {
            onSelected = function()
                Callback.triggerServerCallback('YveltAdmin:getStaffs', function(cb, cb2)
                    StaffListtt = cb
                    Identifier = cb2
                end)
            end
        }, adminStaffs)
    end
    if playersList ~= nil and playersStaffsList ~= nil then
        RageUI.Separator('Joueur(s) en ligne : '..YveltConfig.ColorMenu..''..playersCount..' ~s~| Staff(s) en ligne : '..YveltConfig.ColorMenu..''..staffsCount)
    else
        RageUI.Separator('Joueur(s) en ligne : '..YveltConfig.ColorMenu..'/ ~s~| Staff(s) en ligne : '..YveltConfig.ColorMenu..'/')
    end
    RageUI.Checkbox("Restreindre à ma zone", nil, YveltShowInZone, {}, {
        onSelected = function(Index)
            YveltShowInZone = Index
        end
    })
    RageUI.Checkbox("Afficher uniquement les staffs", nil, YveltShowStaff, {}, {
        onSelected = function(Index)
            YveltShowStaff = Index
        end
    })
    RageUI.List("Rechercher un joueur par", YveltRechercheSys, YveltRechercheSysIndex, nil, {RightLabel = ""}, true, {
        onListChange = function(Index)
            YveltRechercheSysIndex = Index
            YveltRecherche = YveltRechercheSysIndex
        end,
        onSelected = function(Index)
            if YveltRecherche == 1 then
                YveltRechercheEcrit = KeyboardInput('YVELT_RECHERCHE_SYS', "Entrez le ~r~pseudo~s~ du joueur que vous souhaitez rechercher", '', 20)
            elseif YveltRecherche == 2 then
                YveltRechercheEcrit = KeyboardInput('YVELT_RECHERCHE_SYS', "Entrezr le ~r~l'id~s~ du joueur que vous souhaitez rechercher", '', 20)
            elseif YveltRecherche == 3 then
                YveltRechercheEcrit = KeyboardInput('YVELT_RECHERCHE_SYS', "Entrezr le ~r~métier~s~ du joueur que vous souhaitez rechercher", '', 20)
            elseif YveltRecherche == 4 then
                YveltRechercheEcrit = KeyboardInput('YVELT_RECHERCHE_SYS', "Entrezr le ~r~l'id unique~s~ du joueur que vous souhaitez rechercher", '', 20)
            end
            if not YveltRechercheEcrit then
                YveltRechercheEcrit = nil
                YveltHelper:clientNotification('~g~La recherche a été annulé !')
            end
            if YveltRechercheEcrit ~= nil then
                YveltHelper:clientNotification('~g~Recherche configuré sur "'..YveltRechercheEcrit..'"')
            end
        end
    })
    if YveltRechercheEcrit then
        RageUI.Button('~r~Annuler la recherche', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                YveltRechercheEcrit = nil
            end		
        })
    end
    if YveltRechercheEcrit then
        Separator('Résulatat(s) de votre recherche')
    elseif YveltShowStaff then
        Separator('Staff(s) connecté(s)')
    else
        Separator('Joueur(s) connecté(s)')
    end

    -- Helper local pour construire le RightLabel avec badge "En Service"
    local function buildRightLabel(v)
        local dutyBadge = v.staffmode and '~g~En Service ~s~| ' or ''
        return dutyBadge..v.source..' '..YveltConfig.RightLabel
    end

    local function buildPlayerName(v)
        local prefix = colorsText[v.rankColor] or ''
        local reset = prefix ~= '' and '~s~' or ''
        return prefix..v.name..' '..(v.rankLabel or '')..reset
    end

    if PlayersList then
        for k, v in pairs(PlayersList) do
            if YveltShowInZone then
                for _, player in ipairs(GetActivePlayers()) do
                    if GetPlayerServerId(player) == v.source then
                        if YveltRechercheEcrit then
                            local fieldValue = nil
                            if YveltRecherche == 1 then fieldValue = v.name
                            elseif YveltRecherche == 2 then fieldValue = v.source
                            elseif YveltRecherche == 3 then fieldValue = v.job1
                            elseif YveltRecherche == 4 then fieldValue = v.uid
                            end
                            if fieldValue and string.find(fieldValue, YveltRechercheEcrit) then
                                local btnName = buildPlayerName(v)
                                RageUI.Button(btnName, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = buildRightLabel(v)}, true, {
                                    onSelected = function()
                                        selectedPlayer = k
                                    end
                                }, adminGestPlayer)
                            end
                        else
                            local btnName = buildPlayerName(v)
                            RageUI.Button(btnName, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = buildRightLabel(v)}, true, {
                                onSelected = function()
                                    selectedPlayer = k
                                end
                            }, adminGestPlayer)
                        end
                    end
                end
            elseif YveltShowStaff then
                if v.rankName ~= 'user' then
                    local show = false
                    if YveltRechercheEcrit then
                        local fieldValue = nil
                        if YveltRecherche == 1 then fieldValue = v.name
                        elseif YveltRecherche == 2 then fieldValue = v.source
                        elseif YveltRecherche == 3 then fieldValue = v.job1
                        elseif YveltRecherche == 4 then fieldValue = v.uid
                        end
                        if fieldValue and string.find(fieldValue, YveltRechercheEcrit) then
                            show = true
                        end
                    else
                        show = true
                    end
                    if show then
                        local btnName = buildPlayerName(v)
                        RageUI.Button(btnName, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = buildRightLabel(v)}, true, {
                            onSelected = function()
                                selectedPlayer = k
                            end
                        }, adminGestPlayer)
                    end
                end
            else
                local show = false
                if YveltRechercheEcrit then
                    local fieldValue = nil
                    if YveltRecherche == 1 then fieldValue = v.name
                    elseif YveltRecherche == 2 then fieldValue = v.source
                    elseif YveltRecherche == 3 then fieldValue = v.job1
                    elseif YveltRecherche == 4 then fieldValue = v.uid
                    end
                    if fieldValue and string.find(fieldValue, YveltRechercheEcrit) then
                        show = true
                    end
                else
                    show = true
                end
                if show then
                    local btnName = buildPlayerName(v)
                    RageUI.Button(btnName, 'Métier : '..c..''..v.job1..'~s~\nOrganisation : '..c..''..v.job2..'~s~\nUnique ID : '..c..''..v.uid..'', {RightLabel = buildRightLabel(v)}, true, {
                        onSelected = function()
                            selectedPlayer = k
                        end
                    }, adminGestPlayer)
                end
            end
        end
    end
end

function MenuPlayerRank()
    local target = rankAssignTarget
    if not target then
        RageUI.Separator('~r~Aucun joueur sélectionné')
        return
    end

    if not RanksAdminData or next(RanksAdminData) == nil then
        if not rankDataLoading then
            loadRanksAdminData(false)
        end
        RageUI.Separator('~r~Chargement des ranks...')
        return
    end

    RageUI.Separator('Joueur : '..target.name..' ~c~('..target.source..')')
    RageUI.Separator('Rank actuel : '..(target.rankLabel or '[Joueur]'))
    Separator('Attribuer un rank')
    for _, rank in pairs(RanksAdminData) do
        local rightLabel = (rank.rank == target.rankName) and 'Déjà attribué' or ('#'..tostring(rank.color or 'cfbe83')..' '..YveltConfig.RightLabel)
        RageUI.Button('['..(rank.label or rank.rank or '?')..']', 'Rank : '..tostring(rank.rank or '?')..'\nPower : '..tostring(rank.power or '?')..'\nCouleur : #'..tostring(rank.color or 'cfbe83')..'\nPermissions : '..tostring(#(rank.permsList or {})), {RightLabel = rightLabel}, rank.rank ~= target.rankName, {
            onSelected = function()
                TriggerServerEvent('Yvelt:assignPlayerRank', target.source, rank.rank)
                refreshRankDataAfterAction()
                YveltHelper:clientNotification('~g~Rank attribué à '..target.name)
            end
        })
    end
end

function menuGestPlayer()
    local s = PlayersList[selectedPlayer]
    if s then
        RageUI.Button('Gérer son rank', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                rankAssignTarget = s
                selectedAdminRank = nil
                loadRanksAdminData(false)
            end
        }, adminPlayerRank)
        if s.rankColor then
            local prefix = colorsText[s.rankColor] or ''
            RageUI.Separator(prefix..s.name..' '..(s.rankLabel or '')..'~s~')
            RageUI.Separator('ID Temporaire : '..c..''..s.source..'~s~ | ID Unique : '..c..''..s.uid..'') 
        else
            RageUI.Separator(s.name..' ~s~[Joueur]')
            RageUI.Separator('ID Temporaire : '..c..''..s.source..'~s~ | ID Unique : '..c..''..s.uid..'') 
        end
        RageUI.List("Action sur le joueur", YveltAction, (YveltAction.Index or 1), false, {}, true, {
            onListChange = function(Index)
                YveltAction.Index = Index
            end,
            onSelected = function(Index)
                if YveltAction.Index == 1 then
                    YveltHelper:revivePlayer(s.source, s.name)
                elseif YveltAction.Index == 2 then
                    YveltHelper:healPlayer(s.source, s.name)
                end
            end
        })
        if YveltHelper:getAcces(player, 'teleportation') then
            RageUI.List("Téléportation", YveltTeleportation, (YveltTeleportation.Index or 1), false, {}, true, {
                onListChange = function(Index)
                    YveltTeleportation.Index = Index
                end,
                onSelected = function(Index)
                    if YveltTeleportation.Index == 1 then
                        TriggerServerEvent('YveltAdmin:Teleport', 'goto', s.source)
                    elseif YveltTeleportation.Index == 2 then
                        TriggerServerEvent('YveltAdmin:Teleport', 'bring', s.source)
                    else
                        TriggerServerEvent('YveltAdmin:Teleport', 'bringback', s.source)
                    end
                end
            })
            RageUI.Button('Téléportation(s) custom', nil, { RightLabel = YveltConfig.RightLabel }, true, {
                onSelected = function()
                    sanctionSelectedId = s.source
                    sanctionSelectedName = s.name
                    Callback.triggerServerCallback('YveltAdmin:getTP', function(tp)
                        TpList = tp
                    end)
                end
            }, adminMyTeleports2)
        else
            RageUI.Button('Téléportation', nil, {}, false, {})
            RageUI.Button('Téléportation(s) custom', nil, {}, false, {})
        end
        Separator('Options utilitaire')
        if YveltHelper:getAcces(player, 'spectate') then
            RageUI.Checkbox("Spectate le joueur", nil, spectate, {}, {
                onSelected = function(Index)
                    spectate = Index
                end,
                onChecked = function()
                    spectate = true
                    boolSpect(s.source, PlayersList[selectedPlayer], s.name)
                end,
                onUnChecked = function()
                    spectate = false
                end
            })
        else
            RageUI.Button('Spectate le joueur', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'spawnVeh') then
            RageUI.Button('Donner un véhicule au joueur', nil, {RightBadge = RageUI.BadgeStyle.Car}, true, {
                onSelected = function()
                    local car = KeyboardInput('YveltMsg', "Entrez le "..c.."nom~s~ du véhicule", '', 32)
                    if car and car ~= '' then
                        if not IsModelInCdimage(car) then
                            YveltHelper:clientNotification('~r~Ce véhicule n\'existe pas !')
                        else
                            TriggerServerEvent('YveltAdmin:GiveCarToPlayer', s.source, car)
                        end
                    else
                        YveltHelper:clientNotification('~r~Vous avez annulé l\'action')
                    end
                end		
            })
        else
            RageUI.Button('Donner un véhicule au joueur', nil, {}, false, {})
        end
        if YveltHelper:getAcces(player, 'sendMsg') then
            RageUI.Button('Envoyer un message', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    local YveltMsg = KeyboardInput('YveltMsg', "Entrez le "..c.."message~s~ que vous souhaitez envoyer", '', 70)
                    if YveltMsg and YveltMsg ~= '' then
                        ExecuteCommand('msg '..s.source..' '..YveltMsg)
                    else
                        YveltHelper:clientNotification('~r~Vous avez annulé l\'action')
                    end
                end		
            })
        else
            RageUI.Button('Envoyer un message', nil, {}, false, {})
        end
        RageUI.Button('Sanction(s) du joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                sanctionSelectedId = s.source
                sanctionSelectedName = s.name
                Callback.triggerServerCallback('YveltAdmin:getSanctionsOfPlayer', function(list)
                    adminSanctions = list
                end, s.uid)
            end		
        }, adminGestPlayerSanctions)
        Separator('Gestion avancé')
        RageUI.Button('Voir l\'inventaire du joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                sanctionSelectedId = s.source
                sanctionSelectedName = s.name
                Callback.triggerServerCallback('YveltAdmin:getInventoryOfPlayer', function(list, list2)
                    adminInventory = list
                    adminInventory2 = list2
                    OpenInventoryMenu(adminInventory, adminInventory2)
                end, s.source)
            end
        }, adminGestPlayerInventory)
        
        function OpenInventoryMenu(inventory, inventory2)
            RageUI.IsVisible(RMenu:Get('admin', 'inventory'), true, true, true, function()
                for i = 1, #inventory do
                    RageUI.Button(inventory[i].label, nil, {RightLabel = 'x'..inventory[i].count}, true, {
                        onSelected = function()
                        end
                    })
                end
                for i = 1, #inventory2 do
                    RageUI.Button(inventory2[i].label, nil, {RightLabel = 'x'..inventory2[i].count}, true, {
                        onSelected = function()
                        end
                    })
                end
            end)
        end        
        if YveltHelper:getAcces(player, 'give') then
            RageUI.Button('Donner un item au joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    sanctionSelectedId = s.source
                    sanctionSelectedName = s.name
                    Callback.triggerServerCallback('YveltAdmin:getItems', function(list)
                        itemsList = list
                    end)
                    givePlayer(s.source, YveltMsg, YveltMsg2)
                end		
            }, adminGestPlayerItems)
        else
            RageUI.Button('Donner un item au joueur', nil, {}, false, {})
        end
        YveltHelper:CustomMenuPlayers(PlayersList[selectedPlayer])
        for k, v in pairs(YveltMenus.players) do
            if v.type == 'button' then
                if v.perm then
                    if YveltHelper:getAcces(player, v.perm) then
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
    else
        RageUI.Separator()
        RageUI.Separator('~r~Ce joueur n\'est plus connecté')
        RageUI.Separator()
    end
end

function menuGestPlayerItems()
    if YveltHelper:getAcces(player, 'give') then
        RageUI.Button('Donner un item au joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                local YveltMsg = KeyboardInput('YveltMsg', "Entrez le nom de l'item", '', 20)
                local YveltMsg2 = KeyboardInput('YveltMsg', "Entrez la quantité que vous souhaitez give", '', 3)
                if YveltMsg and YveltMsg2 and tonumber(YveltMsg2) > 0 then
                    givePlayer(sanctionSelectedId, YveltMsg, tonumber(YveltMsg2))
                else
                    print("Quantité invalide ou nom d'item vide.")
                end
            end		
        })
        
        if itemsList then
            RageUI.List("Filtrer par lettre", LettresItems, LettresItemsIndex, nil, {}, true, {
                onListChange = function(Index)
                    LettresItemsIndex = Index
                end
            })
            Separator('Liste des items')
            
            if LettresItemsIndex == 1 then
                for k, v in pairs(itemsList) do
                    RageUI.Button(v.label..' ~c~('..v.name..')', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                        onSelected = function()
                            local YveltMsg2 = KeyboardInput('YveltMsg', "Entrez la quantité que vous souhaitez give", '', 3)
                            if YveltMsg2 and tonumber(YveltMsg2) > 0 then
                                givePlayer(sanctionSelectedId, v.name, tonumber(YveltMsg2))
                            else
                                print("Quantité invalide.")
                            end
                        end
                    })
                end
            else
                for k, v in pairs(itemsList) do
                    local premierCaractere = string.sub(v.label, 1, 1)
                    if string.lower(premierCaractere) == LettresItems[LettresItemsIndex] then
                        RageUI.Button(v.label..' ~c~('..v.name..')', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                            onSelected = function()
                                local YveltMsg2 = KeyboardInput('YveltMsg', "Entrez la quantité que vous souhaitez give", '', 3)
                                if YveltMsg2 and tonumber(YveltMsg2) > 0 then
                                    givePlayer(sanctionSelectedId, v.name, tonumber(YveltMsg2))
                                else
                                    print("Quantité invalide.")
                                end
                            end
                        })
                    end
                end 
            end
        else
            RageUI.Button('Filtrer par lettre', nil, {}, false, {})
            Separator('Liste des items')
            RageUI.Separator('~r~Chargement des items...')
        end
    else
        RageUI.Separator('Anti-triche YveltAdmin :)')
    end
end


function menuGestPlayerInventory()
    local s = PlayersList[selectedPlayer]
    if s then
        if colorsText[s.rankColor] then
            RageUI.Separator(s.name..' ~s~'..colorsText[s.rankColor]..''..s.rankLabel)
            RageUI.Separator('ID Temporaire : '..c..''..s.source..'~s~ | ID Unique : '..c..''..s.uid..'') 
        else
            RageUI.Separator(s.name..' ~s~[Joueur]')
            RageUI.Separator('ID Temporaire : '..c..''..s.source..'~s~ | ID Unique : '..c..''..s.uid..'') 
        end
        Separator('Inventaire du joueur')
        if adminInventory and adminInventory2 then
            for k, v in pairs(adminInventory) do
                if v.count ~= 0 then
                    RageUI.List(v.label..' '..c..'x'..v.count..' ~c~('..v.name..')', YveltGestinventory, (YveltGestinventory.Index or 1), false, {}, true, {
                        onListChange = function(Index)
                            YveltGestinventory.Index = Index
                        end,
                        onSelected = function(Index)
                            if YveltGestinventory.Index == 1 then
                                if YveltHelper:getAcces(player, 'prendre') then
                                    local YveltInventory = KeyboardInput('YveltMsg', "Entrez le "..c.."nombre~s~ de "..v.label.." que vous voulez prendre", '', 5)
                                    if tonumber(YveltInventory) then
                                        if tonumber(YveltInventory) > v.count then
                                            YveltHelper:clientNotification('~r~Impossible de prendre plus de '..v.label)
                                        else
                                            TriggerServerEvent('Yvelt:GestInventoryPlayer', 'rob', tonumber(YveltInventory), v, sanctionSelectedId)
                                        end
                                    else
                                        YveltHelper:clientNotification('~r~Vous devez entrer un nombre !')
                                    end
                                else
                                    YveltHelper:clientNotification('~r~Vous avez pas la permission !')
                                end
                            else
                                if YveltHelper:getAcces(player, 'delete') then
                                    local YveltInventory = KeyboardInput('YveltMsg', "Entrez le "..c.."nombre~s~ de "..v.label.." que vous voulez supprimer", '', 5)
                                    if tonumber(YveltInventory) then
                                        if tonumber(YveltInventory) > v.count then
                                            YveltHelper:clientNotification('~r~Impossible de prendre plus de '..v.label)
                                        else
                                            TriggerServerEvent('Yvelt:GestInventoryPlayer', 'delete', tonumber(YveltInventory), v, sanctionSelectedId)
                                        end
                                    else
                                        YveltHelper:clientNotification('~r~Vous devez entrer un nombre !')
                                    end
                                else
                                    YveltHelper:clientNotification('~r~Vous avez pas la permission !')
                                end
                            end
                        end
                    })
                end
            end
            for k, v in pairs(adminInventory2) do
                if v.name then
                    RageUI.List(v.label..' '..c..'x'..v.ammo..' ~c~('..v.name..')', YveltGestinventory, (YveltGestinventory.Index or 1), false, {}, true, {
                        onListChange = function(Index)
                            YveltGestinventory.Index = Index
                        end,
                        onSelected = function(Index)
                            if YveltGestinventory.Index == 1 then
                                if YveltHelper:getAcces(player, 'prendre') then
                                    TriggerServerEvent('Yvelt:GestInventoryPlayer', 'rob2', v.ammo, v, sanctionSelectedId)
                                else
                                    YveltHelper:clientNotification('~r~Vous avez pas la permission !')
                                end
                            else
                                if YveltHelper:getAcces(player, 'delete') then
                                    TriggerServerEvent('Yvelt:GestInventoryPlayer', 'delete2', v.ammo, v, sanctionSelectedId)
                                else
                                    YveltHelper:clientNotification('~r~Vous avez pas la permission !')
                                end
                            end
                        end
                    })
                else
                    RageUI.Button('Arme inconnue ?', 'Cette arme n\'a pas été reconnu', {}, false, {})
                end
            end
        else
            RageUI.Separator()
            RageUI.Separator('~r~Chargement de l\'inventaire')
            RageUI.Separator()
        end
    else
        RageUI.Separator()
        RageUI.Separator('~r~Ce joueur n\'est plus connecté')
        RageUI.Separator()
    end
end