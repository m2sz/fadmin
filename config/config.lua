YveltConfig = {} -- Version 2.5

-- Configuration : Menu d'administration
YveltConfig.Debug = true ---@return boolean Si les prints de debug doient apparaitre (Par defaut : true)
YveltConfig.UltimeDebug = true ---@return boolean Si les prints de ultime debug doient apparaitre (Par defaut : true)
YveltConfig.CallbackDebug = false ---@return boolean Afficher les debugs des callbacks

YveltConfig.IgnoreOneSync = false ---@return boolean Masquer les prints pour le warning de onesync
YveltConfig.UseJob1 = true ---@return boolean Activer ou désactiver le job2 (les métiers)
YveltConfig.UseJob2 = true ---@return boolean Activer ou désactiver le job2 (les gangs)
YveltConfig.showNoteToStaff = true ---@return boolean Montrer la note qu'il a reçu de la part d'un joueur ?
YveltConfig.bypassRename = true ---@return boolean Pouvoir changer le nom du script
YveltConfig.Authenticator = true ---@return boolean Activer la commande /auth pour se mettre les permissions sans faire de commande depuis la console ?
YveltConfig.ReportRaison = true ---@return boolean Besoin d'une raison pour faire un report ?
YveltConfig.NoclipType = 2 ---@return number Type de NoClip (1 : vMenu, 2 : vue première personne)
YveltConfig.UseStaffGun = true ---@return boolean Give une arme lorsque le mode modération est activé ? Permet de faire des actions avec le joueur et les véhicules (Staffgun Dynasty)
YveltConfig.StaffGunName = 'weapon_snspistol_mk2' ---@return string Si l'option au dessus est actif, quel arme donner ?
YveltConfig.StaffItemName = 'staff_pistol' ---@return string Nom de l'item dans l'inventaire qui permet d'équiper le pistolet staff
YveltConfig.UniqueIdFormat = 'lllccc' ---@return string 'l' = lettre 'c' = chiffre (format des UID)
YveltConfig.staffActive = {
    setPed = false, ---@return boolean Mettre un ped lorsque le mode staff est activé ?
    ped = 'u_m_y_ushi', ---@return string Si l'option au dessus est actif, quel ped mettre ? (Hash) => https://docs.fivem.net/docs/game-references/ped-models/
    showInfos = true, ---@return boolean Afficher les informations en bas de l'ecran par défaut ? Joueurs connectés / Reports
    showBlips = true, ---@return boolean Afficher les blips lorsque l'on active le mode staff ?
    staffSkin = true, ---@return boolean Mettre un skin au staff lorsque l'on active le mode staff ?
    showGamertags = true, ---@return boolean Afficher les pseudos lorsque l'on active le mode staff ?
}

YveltConfig.staffSkins = {
    ['noir'] = {
        sex = 0,
        tshirt_1 = 15,
        tshirt_2 = 0,
        torso_1 = 178,
        torso_2 = 9,
        arms = 4,
        pants_1 = 77,
        pants_2 = 9,
        shoes_1 = 55,
        shoes_2 = 9,
    },
    ['rouge'] = {
        sex = 0,
        tshirt_1 = 15,
        tshirt_2 = 0,
        torso_1 = 178,
        torso_2 = 5,
        arms = 4,
        pants_1 = 77,
        pants_2 = 5,
        shoes_1 = 55,
        shoes_2 = 5,
    },['orange'] = {
        sex = 0,
        tshirt_1 = 15,
        tshirt_2 = 0,
        torso_1 = 178,
        torso_2 = 2,
        arms = 4,
        pants_1 = 77,
        pants_2 = 2,
        shoes_1 = 55,
        shoes_2 = 2,
    },['jaune'] = {
        sex = 0,
        tshirt_1 = 15,
        tshirt_2 = 0,
        torso_1 = 178,
        torso_2 = 0,
        arms = 4,
        pants_1 = 77,
        pants_2 = 0,
        shoes_1 = 55,
        shoes_2 = 0,
    },['bleu'] = {
        sex = 0,
        tshirt_1 = 15,
        tshirt_2 = 0,
        torso_1 = 178,
        torso_2 = 3,
        arms = 4,
        pants_1 = 77,
        pants_2 = 3,
        shoes_1 = 55,
        shoes_2 = 3,
    },
}

-- Configuration : Menus et titres
YveltConfig.MenuTitle = "" ---@return string Retourne le texte affiché sur la bannière du menu RageUI
YveltConfig.MenuSubTitle = "MENU STAFF" ---@return string Retourne le texte affiché sous la bannière du menu RageUI (Sur la ligne fondateur par defaut)
YveltConfig.ServerTitle = "GtaSpace" ---@return string Retourne le titre du serveur (Affiché lors de la connexion, lors du ban ou d'une sanction)
YveltConfig.ColorMenu = "~s~" ---@return string Retourne la couleur de certaines choses dans le menu
YveltConfig.RightLabel = "→→" ---@return string Retourne la couleur de certaines choses dans le menu

-- Configuration : Jail / Prison
YveltConfig.PrisonPos = vec3(1642.0, 2570.0, 46.0) ---@return vector3 Retourne la position de la prison de votre serveur (Jail)
YveltConfig.PrisonExit = vec3(1850.5, 2608.3, 45.5) ---@return vector3 Retourne la position de sorti (Jail)
YveltConfig.Distance = 10.0 ---@return number Retourne la distance maximal a la quelle le joueur peut partir de la position indiqué au dessus (=> YveltConfig.PrisonPos)
YveltConfig.GiveVehicleOnExit = 'faggio' ---@return number Donner un véhicule lorsque la personne sort de jail ? nil = ne pas donner

-- Configuration : Ban
YveltConfig.BanScreen = {
    bouton = 'Rejoindre le serveur Discord', ---@return string Texte qui apparait sur le bouton
    discord = 'discord.gg/gtaspace', ---@return string Lien qui revoit vers votre Discord pour contester les sanctions
    image = 'https://zupimages.net/up/23/27/kn9n.png', ---@return string Lien de l'image que vous souhaitez afficher sur l'ecran de ban
    image2 = 'https://zupimages.net/up/23/27/kn9n.png', ---@return string Lien de l'image que vous souhaitez afficher sur l'ecran d'échec de connexion lors d'un emoji dans un pseudo !
}

-- Configuration : Téléportations rapide
YveltConfig.FastTravel = {
    {
        Name = "Parking Central", ---@return string Label sur le RageUI.List
        Position = vec3(216, -810, 30), ---@return vector3 Position lors de la téléportation
    },
    {
        Name = "Poste de police", ---@return string Label sur le RageUI.List
        Position = vec3(-1064.21, -881.85, 4.93), ---@return vector3 Position lors de la téléportation
    },  
}

YveltConfig.GhostMode = {
    allowedRanks = { 'noir', 'fondateur' }, -- Co Fondateur + Fondateur
}