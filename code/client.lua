YveltStaffMode = false

RegisterKeyMapping('YveltAdminmenu', 'Ouvrir le menu de modération', 'keyboard', 'F10')

open = false
player = false
j = json
adminPseudo = false
TpList = nil
Staffs = nil
PlayersList = {}
RanksList = {}
RanksAdminData = nil
local firstopen = true
spectate = false
delgun = false
LettresItems = {"Aucun", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
LettresItemsIndex = 1
YveltTeleportation = {Index = 1, "Vers lui", "Vers moi", "Bring back"}
YveltGestinventory = {Index = 1, "Prendre", "Supprimer"}
IndexFasttravel = 1
YveltRechercheSys = {"Pseudo", "ID", "Métier", "ID Unique"}   
YveltRechercheSysIndex = 1
YveltRecherche = 1
paramList = YveltPermissions
playerGroup = nil
adminReportsWaiting = false
YveltAdminSanctions = {Index = 1, "Warn", "Kick", "Jail", "Ban"}
sanctionSelectedName = '?'
sanctionSelectedId = '?'
Identifier = ''
YveltShowInZone = false
YveltShowStaff = false
c = YveltConfig.ColorMenu
selectedAdminRank = nil
rankAssignTarget = nil
rankDataLoading = false
rankDataLoaded = false
-- colorsNb now stores hex color strings (RRGGBB). Avoid using named colors.
colorsNb = {
    ["1"] = 'ff4d6d', -- rouge néon
    ["2"] = 'ff8c42', -- orange néon
    ["3"] = 'fff95b', -- jaune néon
    ["4"] = '39ff14', -- vert néon
    ["5"] = '00e5ff', -- bleu néon
    ["6"] = 'ffe66d', -- fondateur néon
    ["7"] = 'a6a6a6', -- gris clair
    ["8"] = 'f8fbff', -- blanc froid
    ["9"] = '121212', -- noir profond
}
-- colorsText kept for backwards compatibility with older rank entries (named colors).
colorsText = {
    ['red'] = '~r~',
    ['orange'] = '~o~',
    ['yellow'] = '~y~',
    ['green'] = '~g~',
    ['blue'] = '~b~',
    ['purple'] = '~p~',
    ['gray'] = '~m~',
    ['white'] = '~s~',
    ['black'] = '~u~',
    ['cfbe83'] = '~y~',
    ['fondateur'] = '~y~',
    ['ffe66d'] = '~y~',
}

paraColorList = {Index = 1, "Rouge", "Orange", "Jaune", "Vert", "Bleu", "Fondateur", "Gris", "Blanc", "fondateur"}

local function hexIndexFromValue(value)
    for index, hex in pairs(colorsNb) do
        if hex == value then
            return tonumber(index)
        end
    end
    return 1
end

paramRank = {
    rank = nil,
    label = nil,
    power = nil,
    perms = nil,
    color = 'ffe66d', -- default to hex (fondateur néon)
}

RegisterNetEvent('Yvelt:receiveStaffInfosRanks')
AddEventHandler('Yvelt:receiveStaffInfosRanks', function(group)
    playerGroup = group
    player = playerGroup
end)

RegisterNetEvent('Yvelt:RefreshClientInfos')
AddEventHandler('Yvelt:RefreshClientInfos', function(perms, desacAll)
    firstopen = true
    YveltHelper:onStaffModeOFF()
    if noclipActive then
        ExecuteCommand('YveltNoclip')
    end
    Callback.triggerServerCallback('YveltAdmin:getRank', function(group)
        playerGroup = group
        player = playerGroup
    end)

    adminStaffmode = false
    YveltStaffMode = false
    isNameShown = false
    
    adminPseudo = false
    boolPseudo = false
    for i, v in pairs(YVELT.GamerTags) do
        RemoveMpGamerTag(v.tags)
    end
    YVELT.GamerTags = {};
    SetEntityVisible(PlayerPedId(), true)
    boolHud = false
    boolInvincible = false
    boolSuperjump = false
    boolCoords = false
    boolSupersprint = false

    playerGroup = perms
    player = playerGroup
    RageUI.CloseAll()
    open = false

    YveltHelper:clientNotification('~g~Vos permissions ont été refresh !')
end)

mainMenu = RageUI.CreateMenu(YveltConfig.MenuTitle, YveltConfig.MenuSubTitle, nil, nil, "commonmenu", "interaction_bgd")
adminPerso = RageUI.CreateSubMenu(mainMenu, YveltConfig.MenuTitle, 'MENU GESTION PERSONNEL')
adminRanks = RageUI.CreateSubMenu(mainMenu, YveltConfig.MenuTitle, 'MENU GESTION DES RANKS')
adminRanksList = RageUI.CreateSubMenu(adminRanks, YveltConfig.MenuTitle, 'LISTE DES RANKS')
adminRankManage = RageUI.CreateSubMenu(adminRanksList, YveltConfig.MenuTitle, 'GESTION DU RANK')
adminRankscreate = RageUI.CreateSubMenu(adminRanks, YveltConfig.MenuTitle, 'MENU GESTION DES RANKS')
adminRankDetails = RageUI.CreateSubMenu(adminRanks, YveltConfig.MenuTitle, 'DÉTAILS DU RANK')
adminRankAssign = RageUI.CreateSubMenu(adminRankDetails, YveltConfig.MenuTitle, 'ATTRIBUER LE RANK')
adminMyTeleports = RageUI.CreateSubMenu(adminPerso, YveltConfig.MenuTitle, 'MENU TELEPORTATIONS')
adminReports = RageUI.CreateSubMenu(mainMenu, YveltConfig.MenuTitle, 'MENU GESTION REPORTS')
adminReportsActions = RageUI.CreateSubMenu(adminReports, YveltConfig.MenuTitle, 'MENU GESTION DU REPORT')
adminPlayers = RageUI.CreateSubMenu(mainMenu, YveltConfig.MenuTitle, 'MENU GESTION DES JOUEURS')
adminStaffs = RageUI.CreateSubMenu(mainMenu, YveltConfig.MenuTitle, 'MENU GESTION DES STAFFS')
adminVehicle = RageUI.CreateSubMenu(mainMenu, YveltConfig.MenuTitle, 'MENU GESTION VEHICULE')
adminGestPlayer = RageUI.CreateSubMenu(adminPlayers, YveltConfig.MenuTitle, 'MENU GESTION DU JOUEUR')
adminPlayerRank = RageUI.CreateSubMenu(adminGestPlayer, YveltConfig.MenuTitle, 'GESTION DU RANK')
adminGestPlayerSanctions = RageUI.CreateSubMenu(adminGestPlayer, YveltConfig.MenuTitle, 'MENU GESTION DES SANCTIONS')
adminGestPlayerInventory = RageUI.CreateSubMenu(adminGestPlayer, YveltConfig.MenuTitle, 'MENU GESTION INVENTAIRE')
adminGestPlayerItems = RageUI.CreateSubMenu(adminGestPlayer, YveltConfig.MenuTitle, 'MENU GESTION ITEMS')
adminMyTeleports2 = RageUI.CreateSubMenu(adminGestPlayer, YveltConfig.MenuTitle, 'MENU GESTION ITEMS')

mainMenu.Closed = function()
	open = false
end

adminReportsActions.Closed = function()
	nlcReportList = nil
	TriggerServerEvent('Yvelt:GetReportList')
end

RegisterCommand('YveltAdminmenu', function()
    scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end
    if firstopen then
        Callback.triggerServerCallback('YveltAdmin:getRank', function(group)
            playerGroup = group
            player = playerGroup
        end)
        while playerGroup == nil do
            Wait(1)
        end
        if YveltHelper:getAcces(player, 'menu') then
            OpenMenu()
        else
            YveltHelper:clientNotification("~r~Vous n'avez pas la permission")
        end
        firstopen = false
    else
        if YveltHelper:getAcces(player, 'menu') then
            OpenMenu()
        else
            YveltHelper:clientNotification("~r~Vous n'avez pas la permission")
        end
    end
end)



function OpenMenu()
    if open then
        open = false
        RageUI.CloseAll()
        RageUI.Visible(mainMenu, false)
        return
    else
        open = true
        RageUI.Visible(mainMenu, true)
        -- YVELT.Players = YVELT.Helper:OnGetPlayers()
        -- YVELT.PlayersStaff = YVELT.Helper:OnGetStaffPlayers()
        CreateThread(function()
            while open do
                RageUI.IsVisible(mainMenu, function()
                    MenuMain()
                end)
                RageUI.IsVisible(adminRanks, function()
                    MenuRanksHub()
                end)
                RageUI.IsVisible(adminRanksList, function()
                    MenuRankList()
                end)
                RageUI.IsVisible(adminRankManage, function()
                    MenuRankManage()
                end)
                RageUI.IsVisible(adminRankscreate, function()
                    MenuCreateRank()                
                end)
                RageUI.IsVisible(adminRankDetails, function()
                    MenuRankDetails()
                end)
                RageUI.IsVisible(adminRankAssign, function()
                    MenuRankAssign()
                end)
                RageUI.IsVisible(adminReports, function()
                    MenuReportsMain()
                end)
                RageUI.IsVisible(adminPlayers, function()
                    MenuPlayers()
                end)
                RageUI.IsVisible(adminReportsActions, function()
                    MenuReportsActions()
                end)
                RageUI.IsVisible(adminMyTeleports, function()
                    MenuTeleport()
                end)
                RageUI.IsVisible(adminMyTeleports2, function()
                    MenuTeleport2()
                end)
                RageUI.IsVisible(adminPerso, function()
                    MenuPersonnalMain()
                end)
                RageUI.IsVisible(adminStaffs, function()
                    MenuStaffs()
                end)
                RageUI.IsVisible(adminVehicle, function()
                    MenuVehicle()
                end)
                RageUI.IsVisible(adminGestPlayer, function()
                    menuGestPlayer()
                end)
                RageUI.IsVisible(adminPlayerRank, function()
                    MenuPlayerRank()
                end)
                RageUI.IsVisible(adminGestPlayerSanctions, function()
                    menuGestPlayerSantions()
                end)
                RageUI.IsVisible(adminGestPlayerInventory, function()
                    menuGestPlayerInventory()
                end)
                RageUI.IsVisible(adminGestPlayerItems, function()
                    menuGestPlayerItems()
                end)
                Wait(1)
            end
        end)
    end
end




if YveltConfig.Authenticator then
    RegisterCommand('auth', function(source, args)
        print('Check server console')
        TriggerServerEvent('Yvelt:auth', args[1])
    end)
end


