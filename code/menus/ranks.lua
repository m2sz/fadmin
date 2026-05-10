local edition = nil
local permissions = nil
local first = true
local saved = false
local colorToNb = {
    ["ff0000"] = 1,
    ["ff7f00"] = 2,
    ["ffff00"] = 3,
    ["00ff00"] = 4,
    ["0000ff"] = 5,
    ["ff4d6d"] = 6,
    ["ff8c42"] = 7,
    ["fff95b"] = 8,
    ["39ff14"] = 9,
    ["00e5ff"] = 10,
    ["ffe66d"] = 11,
    ["a6a6a6"] = 12,
    ["f8fbff"] = 13,
    ["121212"] = 14,
}

local function getColorIndexFromHex(value)
    if not value then
        return 1
    end

    local normalized = tostring(value):gsub('#', ''):lower()
    return colorToNb[normalized] or 6
end

function loadRanksAdminData(force)
    if rankDataLoading then
        return
    end

    if RanksAdminData and not force then
        return
    end

    rankDataLoading = true
    Callback.triggerServerCallback('YveltAdmin:getRanksAdminData', function(data)
        RanksAdminData = data or {}
        if RanksAdminData[1] and RanksAdminData[1].rank then
            RanksAdminData = data
        else
            RanksAdminData = data and data[1] or {}
        end
        rankDataLoading = false
        rankDataLoaded = true
    end)
end

local function getCurrentRankPerms(rankData)
    local perms = {}
    if rankData and rankData.perms then
        local decoded
        if type(rankData.perms) == 'string' then
          decoded = j.decode(rankData.perms)
        else
          decoded = rankData.perms
        end
        if decoded then
            for permName, enabled in pairs(decoded) do
                if enabled then
                    table.insert(perms, permName)
                end
            end
        end
    end
    table.sort(perms)
    return perms
end

function refreshRankDataAfterAction()
    RanksAdminData = nil
    rankDataLoaded = false
    rankDataLoading = false
end

RegisterNetEvent('Yvelt:refreshClientSideRanks')
AddEventHandler('Yvelt:refreshClientSideRanks', function(refreshTable)
    RanksList = refreshTable
end)

function MenuRanksHub()
    RageUI.Button('Créer un rank', nil, { RightLabel = YveltConfig.RightLabel }, true, {
        onSelected = function()
            first = false
            edition = nil
            paramRank = {
                rank = nil,
                label = nil,
                power = nil,
                perms = nil,
                color = 'ffe66d',
            }
            permissions = {}
            for k, v in pairs(paramList) do
                v.default = false
            end
        end,
    }, adminRankscreate)

    RageUI.Button('Voir et gérer les ranks', nil, { RightLabel = YveltConfig.RightLabel }, true, {
        onSelected = function()
            loadRanksAdminData(false)
        end,
    }, adminRanksList)

    Separator('Vue rapide')
    RageUI.Separator('Crée ou gère les ranks depuis ici')
end

function MenuRankList()
    if not rankDataLoaded and not rankDataLoading then
        loadRanksAdminData(false)
    end

    RageUI.Button('Actualiser la liste des ranks', nil, { RightLabel = YveltConfig.RightLabel }, true, {
        onSelected = function()
            loadRanksAdminData(true)
            YveltHelper:clientNotification('~g~Liste des ranks actualisée')
        end,
    })
    Separator('Voir les ranks existants')
    if not RanksAdminData or j.encode(RanksAdminData) == '[]' then
        RageUI.Separator()
        RageUI.Separator('~r~Chargement des ranks...')
        RageUI.Separator()
    else
        for _, b in pairs(RanksAdminData) do
            local holdersCount = b.holdersCount or 0
            local permsCount = #(b.permsList or {})
            local rightLabel = holdersCount..' porteur(s) '..YveltConfig.RightLabel
            local colorHex = b.color or 'cfbe83'

            RageUI.Button('['..(b.label or b.rank or '?')..']', 'Nom du rank : '..(b.rank or '?')..'\nLabel : '..(b.label or '?')..'\nPower : '..tostring(b.power or '?')..'\nCouleur hex : #'..colorHex..'\nPermissions actives : '..permsCount, { RightLabel = rightLabel }, true, {
                onSelected = function()
                    selectedAdminRank = b
                    first = true
                    edition = b
                    permissions = (type(b.perms) == 'string' and j.decode(b.perms) or b.perms) or {}
                    paramRank = {
                        rank = b.rank,
                        label = b.label,
                        power = b.power,
                        color = b.color,
                    }
                    paraColorList.Index = getColorIndexFromHex(b.color)
                end,
            }, adminRankManage)
        end
    end
end

function MenuRankManage()
    local rank = selectedAdminRank
    if not rank then
        RageUI.Separator('~r~Aucun rank sélectionné')
        return
    end

    RageUI.Separator('Gestion : '..(rank.label or rank.rank or '?'))
    
    RageUI.Button('Modifier ce rank', 'Éditer les propriétés du rank', {RightLabel = YveltConfig.RightLabel}, true, {
        onSelected = function()
            first = true
            edition = rank
            permissions = j.decode(rank.perms) or {}
            paramRank = {
                rank = rank.rank,
                label = rank.label,
                power = rank.power,
                color = rank.color,
            }
            paraColorList.Index = getColorIndexFromHex(rank.color)
        end,
    }, adminRankscreate)
    
    RageUI.Button('Attribuer à un joueur', 'Donner ce rank à un joueur en ligne', {RightLabel = YveltConfig.RightLabel}, true, {
        onSelected = function()
            loadRanksAdminData(false)
        end,
    }, adminRankAssign)
    
    RageUI.Button('Voir permissions / porteurs', 'Consulter les droits et les joueurs avec ce rank', {RightLabel = YveltConfig.RightLabel}, true, {
        onSelected = function()
            -- On affiche directement les infos sans changer de menu
        end,
    }, adminRankDetails)
end

function MenuRankDetails()
    local rank = selectedAdminRank
    if not rank then
        RageUI.Separator('~r~Aucun rank sélectionné')
        return
    end

    RageUI.Separator('Rank : '..(rank.label or rank.rank or '?'))
    RageUI.Button('Modifier ce rank', nil, {RightLabel = YveltConfig.RightLabel}, true, {
        onSelected = function()
            first = true
            edition = rank
            permissions = j.decode(rank.perms) or {}
            paramRank = {
                rank = rank.rank,
                label = rank.label,
                power = rank.power,
                color = rank.color,
            }
            paraColorList.Index = getColorIndexFromHex(rank.color)
        end,
    }, adminRankscreate)
    RageUI.Button('Attribuer ce rank à un joueur', nil, {RightLabel = YveltConfig.RightLabel}, true, {
        onSelected = function()
            loadRanksAdminData(false)
        end,
    }, adminRankAssign)
    
    Separator('Porteurs')
    if rank.holders and #rank.holders > 0 then
        for _, holder in ipairs(rank.holders) do
            RageUI.Button(holder.name..' ~c~('..tostring(holder.source or '?')..')', nil, {}, false, {})
        end
    else
        RageUI.Button('Aucun porteur en ligne', nil, {}, false, {})
    end
end

function MenuRankAssign()
    local rank = selectedAdminRank
    if not rank then
        RageUI.Separator('~r~Aucun rank sélectionné')
        return
    end

    if not PlayersList or next(PlayersList) == nil then
        RageUI.Separator('~r~Aucun joueur disponible')
        return
    end

    Separator('Attribuer '..(rank.label or rank.rank or '?'))
    for k, v in pairs(PlayersList) do
        local current = v.rankName or 'user'
        local canAssign = current ~= rank.rank
        local rightLabel = canAssign and 'Attribuer '..YveltConfig.RightLabel or 'Déjà '..YveltConfig.RightLabel
        RageUI.Button(v.name..' '..(v.rankLabel or ''), 'ID : '..v.source..'\nRank actuel : '..tostring(current), {RightLabel = rightLabel}, canAssign, {
            onSelected = function()
                TriggerServerEvent('Yvelt:assignPlayerRank', v.source, rank.rank)
                refreshRankDataAfterAction()
                YveltHelper:clientNotification('~g~Rank attribué à '..v.name)
            end,
        })
    end
end

function MenuCreateRank()
    RageUI.Button('Restaurer les paramètres', nil, {RightLabel = "🗑"}, true, {
        onSelected = function()
            for k, v in pairs(paramList) do
                v.default = false
            end
            paramRank = {
                rank = nil,
                label = nil,
                perms = nil,
                color = 'ffe66d',
            }
        end
    })
    if not edition then
        if paramRank.rank ~= nil and paramRank.label ~= nil and paramRank.power ~= nil then
            RageUI.Button('Créer le nouveau rank', nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                onSelected = function()
                    TriggerServerEvent('Yvelt:createNewRank', paramRank, paramList)
                end
            })
        else
            RageUI.Button('Créer le nouveau rank', nil, {RightBadge = RageUI.BadgeStyle.Tick}, false, {})
        end
        Separator('Créer un nouveau rank')
    else
        RageUI.Button('~g~Enregistrer les modifications', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                YveltHelper:clientNotification('~g~Modifications sauvegardés')
                TriggerServerEvent('Yvelt:saveRank', paramRank, permissions)
            end
        })
        RageUI.Button('~r~Supprimer ce rank', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                local text = KeyboardInput('YVELT', "Entrez \"~r~confirmer~s~\" pour supprimer le rank", '', 20)
                if text == 'confirmer' then
                    YveltHelper:clientNotification('~g~Suppression effectué !')
                    TriggerServerEvent('Yvelt:deleteRank', edition.rank)
                    RageUI.GoBack()
                else
                    YveltHelper:clientNotification('~r~Vous avez annulé la supression')
                end
            end
        })
        Separator('Édition du rank : '..edition.label)
    end
    if paramRank.rank then
        if not edition then
            RageUI.Button('Définir le nom du rank', nil, {RightLabel = paramRank.rank}, true, {
                onSelected = function()
                    paramRank.rank = KeyboardInput('YveltMsg', "Entrez le ~r~nom~s~ du rank ~c~(Pas de maj, pas d'espace)", '', 16)
                end
            })
        else
            RageUI.Button('Définir le nom du rank', 'Impossible de modifier le nom du rank', {RightLabel = YveltConfig.RightLabel}, false, {})
        end
    else
        if not edition then
            RageUI.Button('Définir le nom du rank', nil, {RightLabel = YveltConfig.RightLabel}, true, {
                onSelected = function()
                    paramRank.rank = KeyboardInput('YveltMsg', "Entrez le ~r~nom~s~ du rank ~c~(Pas de maj, pas d'espace)", '', 16)
                end
            })
        else
            RageUI.Button('Définir le nom du rank', 'Impossible de modifier le nom du rank', {RightLabel = YveltConfig.RightLabel}, false, {})
        end
    end
    if paramRank.label then
        RageUI.Button('Définir le label du rank', nil, {RightLabel = paramRank.label}, true, {
            onSelected = function()
                paramRank.label = KeyboardInput('YveltMsg', "Entrez le ~r~label~s~ du rank", '', 32)
            end
        })
    else
        RageUI.Button('Définir le label du rank', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                paramRank.label = KeyboardInput('YveltMsg', "Entrez le ~r~label~s~ du rank", '', 32)
            end
        })
    end
    if paramRank.power then
        RageUI.Button('Définir le power du rank', nil, {RightLabel = paramRank.power}, true, {
            onSelected = function()
                paramRank.power = KeyboardInput('YveltMsg', "Entrez le ~r~power~s~ du rank ~c~(1 - 99)", '', 2)
                if tonumber(paramRank.power) > 100 then
                    paramRank.power = nil
                    YveltHelper:clientNotification('~r~Le grade le plus haut doit être fondateur !')
                else
                    if tonumber(paramRank.power) == 0 then
                        paramRank.power = nil
                        YveltHelper:clientNotification('~r~Le minimum de power est de 1 !')
                    end
                end
            end
        })
    else
        RageUI.Button('Définir le power du rank', nil, {RightLabel = YveltConfig.RightLabel}, true, {
            onSelected = function()
                paramRank.power = KeyboardInput('YveltMsg', "Entrez le ~r~power~s~ du rank ~c~(1 - 99)", '', 2)
                if tonumber(paramRank.power) then
                    if tonumber(paramRank.power) > 100 then
                        paramRank.power = nil
                        YveltHelper:clientNotification('~r~Le grade le plus haut doit être fondateur !')
                    else
                        if tonumber(paramRank.power) == 0 then
                            paramRank.power = nil
                            YveltHelper:clientNotification('~r~Le minimum de power est de 1 !')
                        end
                    end
                else
                    paramRank.power = nil
                end
            end
        })
    end
    RageUI.Button('Attribuer la couleur', 'Saisie hex uniquement, ex : ffe66d', {RightLabel = '#'..tostring(paramRank.color or 'ffe66d')}, true, {
        onSelected = function()
            local hex = KeyboardInput('YveltMsg', "Entrez la couleur hex ~r~(ex : ffe66d)", '', 6)
            if hex then
                hex = tostring(hex):gsub('#', ''):lower()
                if hex:match('^%x%x%x%x%x%x$') then
                    paramRank.color = hex
                else
                    YveltHelper:clientNotification('~r~Couleur hex invalide')
                end
            end
        end
    })
    Separator('Gestion des permissions')
    if not edition then
        RageUI.Button('Attribuer toutes les permissions', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                for k, v in pairs(paramList) do
                    v.default = true
                end
            end
        })
    else
        RageUI.Button('Attribuer toutes les permissions', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                for k, v in pairs(paramList) do
                    permissions[v.name] = true
                end
            end
        })
    end
    if not edition then
        for k, v in pairs(paramList) do
            if v.label ~= nil then
                if v.default then
                    RageUI.Checkbox('~g~'..v.label, nil, v.default, {}, {
                        onSelected = function(Index)
                            v.default = Index
                        end
                    })
                else
                    RageUI.Checkbox(v.label, nil, v.default, {}, {
                        onSelected = function(Index)
                            v.default = Index
                        end
                    })
                end
            end
        end
    else
        for k, v in pairs(paramList) do
            if permissions then
                if v.label ~= nil then
                    local request = v.name
                    local check = tostring(request)
                    if permissions[check] then
                        RageUI.Checkbox('~g~'..v.label, nil, permissions[check], {}, {
                            onSelected = function(Index)
                                permissions[check] = Index
                            end
                        })
                    else
                        RageUI.Checkbox(v.label, nil, permissions[check], {}, {
                            onSelected = function(Index)
                                permissions[check] = Index
                            end
                        })
                    end
                end
            end
        end
    end
    --[[
            paramRank = {
                rank = nil,
                label = nil,
                power = nil,
                perms = nil,
                color = 'ffe66d',
            }
    ]]
    if not edition then
        if paramRank.rank ~= nil and paramRank.label ~= nil and paramRank.power ~= nil then
            RageUI.Button('Créer le nouveau rank', nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                onSelected = function()
                    TriggerServerEvent('Yvelt:createNewRank', paramRank, paramList)
                end
            })
        else
            RageUI.Button('Créer le nouveau rank', nil, {RightBadge = RageUI.BadgeStyle.Tick}, false, {})
        end
    else
        RageUI.Button('~r~Enregistrer les modifications', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
            onSelected = function()
                YveltHelper:clientNotification('~g~Modifications sauvegardés')
                TriggerServerEvent('Yvelt:saveRank', paramRank, paramList)
            end
        })
    end
end