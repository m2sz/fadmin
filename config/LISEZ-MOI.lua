-- Salut ! Voici la liste des commandes utilisable par vos staffs et vos joueurs : 

-- Commandes utilisable par tout le monde : 

    --- Permet d'avertir les staffs en cas de soucis dans votre rôleplay / jeu
    --- @param a string Description de votre report
    - '/report'
    
-- Commandes utilisable par certains staffs et la console (Vous devez créer vos permissions) : 

    --- Permet d'ouvrir le menu d'administration (Configurez votre keybind dans vos paramètres > Configuration des touches > FiveM)
    - '/YveltAdminmenu'

    --- Permet d'activer ou désactiver son noclip (Configurez votre keybind dans vos paramètres > Configuration des touches > FiveM)
    - '/YveltNoclip'

    --- Permet de mettre un avertissement a un joueur
    --- @param a number ID Temporaire d'un joueur
    --- @param b string Raison de l'avertissement
    - '/warn'

    --- Permet de mettre un avertissement a un joueur
    --- @param a number ID Unique d'un joueur
    --- @param b string Raison de l'avertissement
    - '/warnuid'

    --- Permet d'expulser un joueur de votre serveur
    --- @param a number ID Temporaire d'un joueur
    --- @param b string Raison de l'explusion du serveur
    - '/kick'

    --- Permet d'expulser un joueur de votre serveur
    --- @param a number ID Unique d'un joueur
    --- @param b string Raison de l'explusion du serveur
    - '/kickuid'
    
-- Commandes utilisable uniquement par la console : 

    --- Permet de regarder le rank d'un joueur
    --- @param a number ID Temporaire d'un joueur
    - '/getrank'

    --- Permet de modifier le rank d'un joueur
    --- @param a number ID Temporaire d'un joueur
    --- @param b string Nom du rank que vous souhaitez lui donner
    - '/setrank'