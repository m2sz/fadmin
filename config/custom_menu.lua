function YveltHelper:CustomMenuPlayers(selectedPlayer)
    YveltMenus = {
        
        players = { --- Je vous conseille de faire un bouton de test, et de mettre dans la fonction onSelected : print(json.encode(selectedPlayer))
            -- {
            --     type = 'separator', -- Le type de bouton / separateur
            --     name = 'Mes boutons personnalisés',
            -- },
            -- {
            --     type = 'button', -- Le type de bouton / separateur
            --     name = 'Exemple title (ID : '..selectedPlayer.source..')', -- Le titre du bouton
            --     desc = 'Exemple description', -- La description du bouton
            --     rightLabel = {RightLabel = YveltConfig.RightLabel}, -- Le RightLabel du bouton
            --     perm = nil, -- La permission requise pour accéder au bouton
            --     subMenu = nil, -- Accéder a un autre menu ?
            --     onSelected = function() -- Fonction lors que le bouton est appuyé
            --         print('Table joueur sélectionné : '..json.encode(selectedPlayer))
            --     end,
            --     onActive = function() -- Fonction lors que le bouton est selectionner
            --         print('Table joueur sélectionné : '..json.encode(selectedPlayer))
            --     end,
            -- },
        },
    }
end

function YveltHelper:CustomMenuVehicle(selectedPlayer)
    YveltMenus = {
        vehicle = {
            --[[
            {
                type = 'separator', -- Le type de bouton / separateur
                name = 'Mes boutons personnalisés',
            },
            {
                type = 'button', -- Le type de bouton / separateur
                name = 'Voir le custom_menu.lua', -- Le titre du bouton
                desc = 'Exemple description', -- La description du bouton
                rightLabel = {RightLabel = YveltConfig.RightLabel}, -- Le RightLabel du bouton
                perm = nil, -- La permission requise pour accéder au bouton
                subMenu = nil, -- Accéder a un autre menu ?
                onSelected = function() -- Fonction lors que le bouton est appuyé
                    print('pressed')
                end,
                onActive = function() -- Fonction lors que le bouton est selectionner
                    
                end,
            },]]
        },
    }
end
