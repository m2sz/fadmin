local L0_1, L1_1, L2_1, L3_1
L0_1 = false
L1_1 = {}
RegisteredRanks = L1_1
L1_1 = {}
RanksList = L1_1
L1_1 = {}
Yvelt = L1_1
L1_1 = RegisterNetEvent
L2_1 = "Yvelt:refreshClientSideRanks"
L1_1(L2_1)
L1_1 = AddEventHandler
L2_1 = "Yvelt:refreshClientSideRanks"
function L3_1(A0_2)
  local L1_2
  RanksList = A0_2
end
L1_1(L2_1, L3_1)
function L1_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = MySQL
  L0_2 = L0_2.Async
  L0_2 = L0_2.fetchAll
  L1_2 = "SELECT * FROM yvelt_ranks"
  L2_2 = {}
  function L3_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L1_3 = pairs
    L2_3 = A0_3
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
      L7_3 = RanksList
      L8_3 = L6_3.rank
      L9_3 = {}
      L10_3 = L6_3.rank
      L9_3.rank = L10_3
      L10_3 = L6_3.power
      L9_3.power = L10_3
      L10_3 = L6_3.color
      L9_3.color = L10_3
      L10_3 = L6_3.label
      L9_3.label = L10_3
      L10_3 = L6_3.perms
      L9_3.perms = L10_3
      L7_3[L8_3] = L9_3
      L7_3 = debugPrint
      L8_3 = "^0Le rank ^3"
      L9_3 = L6_3.rank
      L10_3 = " ^0a \195\169t\195\169 charg\195\169"
      L8_3 = L8_3 .. L9_3 .. L10_3
      L7_3(L8_3)
      L7_3 = L6_3.rank
      if "fondateur" == L7_3 then
        L7_3 = true
        L0_1 = L7_3
      end
    end
    L1_3 = L0_1
    if L1_3 then
      L1_3 = #A0_3
      if 0 == L1_3 then
        L1_3 = debugPrint
        L2_3 = "^1Une erreur est surevenue, aucun rank n'a \195\169t\195\169 charg\195\169 !"
        L1_3(L2_3)
      else
        RegisteredRanks = A0_3
        L1_3 = debugPrint
        L2_3 = "^3"
        L3_3 = #A0_3
        L4_3 = " ^0ranks ont \195\169t\195\169 charg\195\169"
        L2_3 = L2_3 .. L3_3 .. L4_3
        L1_3(L2_3)
        L1_3 = loadPlayers
        L1_3()
      end
    else
      L1_3 = debugPrint
      L2_3 = "^1Une erreur est surevenue, le rank fondateur n'existe pas !^0"
      L1_3(L2_3)
      L1_3 = Wait
      L2_3 = 1000
      L1_3(L2_3)
      L1_3 = debugPrint
      L2_3 = "^3Tentative de r\195\169paration en cours...^0"
      L1_3(L2_3)
      L1_3 = MySQL
      L1_3 = L1_3.Async
      L1_3 = L1_3.execute
      L2_3 = "INSERT INTO yvelt_ranks (label, `rank`, perms, power, color) VALUES (@label, @rank, @perms, @power, @color)"
      L3_3 = {}
      L3_3["@label"] = "fondateur"
      L3_3["@rank"] = "fondateur"
      do
        local perms_tbl = {}
        for _, p in ipairs(YveltPermissions) do
          perms_tbl[p.name] = true
        end
        L3_3["@perms"] = json.encode(perms_tbl)
      end
      L3_3["@power"] = "100"
      L3_3["@color"] = "cfbe83"
      L1_3(L2_3, L3_3)
      L1_3 = Wait
      L2_3 = 100
      L1_3(L2_3)
      L1_3 = debugPrint
      L2_3 = "^3Cr\195\169ation du rank \"fondateur\" ...^0"
      L1_3(L2_3)
      L1_3 = Wait
      L2_3 = 2000
      L1_3(L2_3)
      L1_3 = MySQL
      L1_3 = L1_3.Async
      L1_3 = L1_3.fetchAll
      L2_3 = "SELECT * FROM yvelt_ranks"
      L3_3 = {}
      function L4_3(A0_4)
        local L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4, L9_4, L10_4
        L1_4 = pairs
        L2_4 = A0_4
        L1_4, L2_4, L3_4, L4_4 = L1_4(L2_4)
        for L5_4, L6_4 in L1_4, L2_4, L3_4, L4_4 do
          L7_4 = debugPrint
          L8_4 = "^0Le rank ^3"
          L9_4 = L6_4.rank
          L10_4 = " ^0a \195\169t\195\169 charg\195\169"
          L8_4 = L8_4 .. L9_4 .. L10_4
          L7_4(L8_4)
          L7_4 = L6_4.rank
          if "fondateur" == L7_4 then
            L7_4 = true
            L0_1 = L7_4
          end
        end
        L1_4 = L0_1
        if L1_4 then
          L1_4 = debugPrint
          L2_4 = "^3Nouvelle tentative de mise en place des ranks...^0"
          L1_4(L2_4)
          L1_4 = loadRanks
          L1_4()
        else
          L1_4 = debugPrint
          L2_4 = "^1Une erreur est surevenue, contactez le support pour obtenir de l'aide si le probl\195\168me persiste !^0"
          L1_4(L2_4)
        end
      end
      L1_3(L2_3, L3_3, L4_3)
    end
  end
  L0_2(L1_2, L2_2, L3_2)
end
loadRanks = L1_1
  Callback.registerServerCallback('YveltAdmin:getRanksAdminData', function(A0_2)
    local ranksData = {}
    local holdersByRank = {}

    for identifier, playerRank in pairs(PlayersRanks) do
      if playerRank and playerRank.rank then
        holdersByRank[playerRank.rank] = holdersByRank[playerRank.rank] or {}
        table.insert(holdersByRank[playerRank.rank], {
          identifier = identifier,
          name = playerRank.name or identifier,
          source = playerRank.source or nil,
        })
      end
    end

    for rankName, rankInfo in pairs(RanksList) do
      local holders = holdersByRank[rankName] or {}
      local perms = {}
      if rankInfo.perms then
        local decoded
        if type(rankInfo.perms) == 'string' then
          decoded = json.decode(rankInfo.perms)
        else
          decoded = rankInfo.perms
        end
        if decoded then
          for permName, enabled in pairs(decoded) do
            if enabled then
              table.insert(perms, permName)
            end
          end
        end
      end

      table.insert(ranksData, {
        rank = rankInfo.rank,
        label = rankInfo.label,
        power = rankInfo.power,
        color = rankInfo.color,
        perms = rankInfo.perms,
        permsList = perms,
        holders = holders,
        holdersCount = #holders,
      })
    end

    table.sort(ranksData, function(a, b)
      return tonumber(a.power or 0) > tonumber(b.power or 0)
    end)

    return {ranksData}
  end)

  RegisterNetEvent('Yvelt:assignPlayerRank')
  AddEventHandler('Yvelt:assignPlayerRank', function(targetId, rankName)
    local src = source
    local xPlayer = YveltHelper:getPlayerFromId(src)
    local targetPlayer = YveltHelper:getPlayerFromId(tonumber(targetId))

    if not xPlayer or not targetPlayer then
      return
    end

    local currentRank = PlayersRanks[YveltHelper:getIdentifier(xPlayer.source)]
    if not currentRank or not currentRank.perms then
      return
    end

    local perms
    if type(currentRank.perms) == 'string' then
      perms = json.decode(currentRank.perms)
    else
      perms = currentRank.perms
    end
    if not perms or not perms['setrank'] then
      YveltHelper:serverNotification(src, '~r~Vous n\'avez pas la permission')
      return
    end

    if not RanksList[rankName] then
      YveltHelper:serverNotification(src, '~r~Ce rank n\'existe pas')
      return
    end

    local identifier = YveltHelper:getIdentifier(targetPlayer.source)
    if not identifier then
      return
    end

    PlayersRanks[identifier] = PlayersRanks[identifier] or {}
    PlayersRanks[identifier].rank = rankName
    PlayersRanks[identifier].power = RanksList[rankName].power
    PlayersRanks[identifier].color = RanksList[rankName].color
    PlayersRanks[identifier].label = RanksList[rankName].label
    PlayersRanks[identifier].perms = RanksList[rankName].perms

    MySQL.Async.execute('UPDATE yvelt_players SET `rank` = @rank WHERE identifier = @identifier', {
      ['@identifier'] = identifier,
      ['@rank'] = rankName,
    })

    TriggerEvent('YveltAdmin:refreshRanksCache')
    TriggerClientEvent('Yvelt:RefreshClientInfos', targetPlayer.source, PlayersRanks[identifier], false)
    YveltHelper:serverNotification(targetPlayer.source, '~g~Vous êtes désormais '..RanksList[rankName].label)
    YveltHelper:serverNotification(src, '~g~Rank mis à jour pour '..YveltHelper:getPlayerName(targetPlayer.source))
  end)
L1_1 = RegisterCommand
L2_1 = "getrank"
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  if 0 == A0_2 then
    L2_2 = A1_2[1]
    L3_2 = YveltHelper
    L4_2 = L3_2
    L3_2 = L3_2.getPlayerFromId
    L5_2 = tonumber
    L6_2 = L2_2
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L5_2(L6_2)
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
    if L3_2 then
      L4_2 = PlayersRanks
      L5_2 = YveltHelper
      L6_2 = L5_2
      L5_2 = L5_2.getIdentifier
      L7_2 = L3_2.source
      L5_2 = L5_2(L6_2, L7_2)
      L4_2 = L4_2[L5_2]
      if L4_2 then
        L4_2 = debugPrint
        L5_2 = "^2Le joueur \""
        L6_2 = YveltHelper
        L7_2 = L6_2
        L6_2 = L6_2.getPlayerName
        L8_2 = L3_2.source
        L6_2 = L6_2(L7_2, L8_2)
        L7_2 = "\" a le rank "
        L8_2 = PlayersRanks
        L9_2 = YveltHelper
        L10_2 = L9_2
        L9_2 = L9_2.getIdentifier
        L11_2 = L3_2.source
        L9_2 = L9_2(L10_2, L11_2)
        L8_2 = L8_2[L9_2]
        L8_2 = L8_2.rank
        L9_2 = " !^0"
        L5_2 = L5_2 .. L6_2 .. L7_2 .. L8_2 .. L9_2
        L4_2(L5_2)
      else
        L4_2 = debugPrint
        L5_2 = "^2Le joueur \""
        L6_2 = YveltHelper
        L7_2 = L6_2
        L6_2 = L6_2.getPlayerName
        L8_2 = L3_2.source
        L6_2 = L6_2(L7_2, L8_2)
        L7_2 = "\" n'a actuellement aucun rank !^0"
        L5_2 = L5_2 .. L6_2 .. L7_2
        L4_2(L5_2)
      end
    else
      L4_2 = debugPrint
      L5_2 = "^1Le joueur que vous tentez de get son rank n'est pas connect\195\169 !^0"
      L4_2(L5_2)
    end
  end
end
L1_1(L2_1, L3_1)
L1_1 = RegisterCommand
L2_1 = "setrank"
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  if 0 == A0_2 then
    L2_2 = A1_2[1]
    if not L2_2 then
      return
    end
    L3_2 = A1_2[2]
    if not L3_2 then
      L4_2 = print
      L5_2 = "^2Le rank \""
      L6_2 = L3_2
      L7_2 = "\" est inconnu, voici la liste des ranks :^0"
      L5_2 = L5_2 .. L6_2 .. L7_2
      L4_2(L5_2)
      L4_2 = pairs
      L5_2 = RegisteredRanks
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = print
        L11_2 = "Rank : "
        L12_2 = L9_2.rank
        L13_2 = " | Label : "
        L14_2 = L9_2.label
        L11_2 = L11_2 .. L12_2 .. L13_2 .. L14_2
        L10_2(L11_2)
      end
      L4_2 = print
      L5_2 = "Exemple d'utilisation : setrank 1 fondateur"
      L4_2(L5_2)
      return
    end
    L4_2 = RanksList
    L4_2 = L4_2[L3_2]
    if L4_2 then
      L4_2 = YveltHelper
      L5_2 = L4_2
      L4_2 = L4_2.getPlayerFromId
      L6_2 = tonumber
      L7_2 = L2_2
      L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2(L7_2)
      L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      if L4_2 then
        L5_2 = PlayersRanks
        L6_2 = YveltHelper
        L7_2 = L6_2
        L6_2 = L6_2.getIdentifier
        L8_2 = L4_2.source
        L6_2 = L6_2(L7_2, L8_2)
        L5_2 = L5_2[L6_2]
        if L5_2 then
          L5_2 = PlayersRanks
          L6_2 = YveltHelper
          L7_2 = L6_2
          L6_2 = L6_2.getIdentifier
          L8_2 = L4_2.source
          L6_2 = L6_2(L7_2, L8_2)
          L5_2 = L5_2[L6_2]
          L5_2.rank = L3_2
          L5_2 = PlayersRanks
          L6_2 = YveltHelper
          L7_2 = L6_2
          L6_2 = L6_2.getIdentifier
          L8_2 = L4_2.source
          L6_2 = L6_2(L7_2, L8_2)
          L5_2 = L5_2[L6_2]
          L6_2 = RanksList
          L6_2 = L6_2[L3_2]
          L6_2 = L6_2.power
          L5_2.power = L6_2
          L5_2 = MySQL
          L5_2 = L5_2.Async
          L5_2 = L5_2.execute
          L6_2 = "UPDATE yvelt_players SET `rank` = @rank WHERE identifier = @identifier"
          L7_2 = {}
          L8_2 = YveltHelper
          L9_2 = L8_2
          L8_2 = L8_2.getIdentifier
          L10_2 = L4_2.source
          L8_2 = L8_2(L9_2, L10_2)
          L7_2["@identifier"] = L8_2
          L7_2["@rank"] = L3_2
          L5_2(L6_2, L7_2)
          L5_2 = YveltHelper
          L6_2 = L5_2
          L5_2 = L5_2.serverNotification
          L7_2 = L4_2.source
          L8_2 = "~g~Vous \195\170tes d\195\169sormais "
          L9_2 = RanksList
          L9_2 = L9_2[L3_2]
          L9_2 = L9_2.label
          L8_2 = L8_2 .. L9_2
          L5_2(L6_2, L7_2, L8_2)
          L5_2 = debugPrint
          L6_2 = "^2Le joueur \""
          L7_2 = YveltHelper
          L8_2 = L7_2
          L7_2 = L7_2.getPlayerName
          L9_2 = L4_2.source
          L7_2 = L7_2(L8_2, L9_2)
          L8_2 = "\" passe sous le rank "
          L9_2 = RanksList
          L9_2 = L9_2[L3_2]
          L9_2 = L9_2.label
          L10_2 = " !^0"
          L6_2 = L6_2 .. L7_2 .. L8_2 .. L9_2 .. L10_2
          L5_2(L6_2)
          L5_2 = refreshSource
          L6_2 = L4_2.source
          L5_2(L6_2)
        else
          L5_2 = MySQL
          L5_2 = L5_2.Async
          L5_2 = L5_2.execute
          L6_2 = "INSERT INTO yvelt_players (identifier, name, `rank`, report_count, report_notes) VALUES (@identifier, @name, @rank, @report_count, @report_notes)"
          L7_2 = {}
          L8_2 = YveltHelper
          L9_2 = L8_2
          L8_2 = L8_2.getIdentifier
          L10_2 = L4_2.source
          L8_2 = L8_2(L9_2, L10_2)
          L7_2["@identifier"] = L8_2
          L8_2 = YveltHelper
          L9_2 = L8_2
          L8_2 = L8_2.getPlayerName
          L10_2 = L4_2.source
          L8_2 = L8_2(L9_2, L10_2)
          L7_2["@name"] = L8_2
          L7_2["@rank"] = L3_2
          L7_2["@report_count"] = 0
          L7_2["@report_notes"] = 0
          L5_2(L6_2, L7_2)
          L5_2 = PlayersRanks
          L6_2 = YveltHelper
          L7_2 = L6_2
          L6_2 = L6_2.getIdentifier
          L8_2 = L4_2.source
          L6_2 = L6_2(L7_2, L8_2)
          L7_2 = {}
          L8_2 = YveltHelper
          L9_2 = L8_2
          L8_2 = L8_2.getPlayerName
          L10_2 = L4_2.source
          L8_2 = L8_2(L9_2, L10_2)
          L7_2.name = L8_2
          L7_2.rank = L3_2
          L7_2.report_count = 0
          L8_2 = RanksList
          L8_2 = L8_2[L3_2]
          L8_2 = L8_2.power
          L7_2.power = L8_2
          L7_2.report_notes = 0
          L8_2 = RanksList
          L8_2 = L8_2[L3_2]
          L8_2 = L8_2.perms
          L7_2.perms = L8_2
          L5_2[L6_2] = L7_2
          L5_2 = YveltHelper
          L6_2 = L5_2
          L5_2 = L5_2.serverNotification
          L7_2 = L4_2.source
          L8_2 = "~g~Vous \195\170tes d\195\169sormais "
          L9_2 = RanksList
          L9_2 = L9_2[L3_2]
          L9_2 = L9_2.label
          L8_2 = L8_2 .. L9_2
          L5_2(L6_2, L7_2, L8_2)
          L5_2 = debugPrint
          L6_2 = "^2Le joueur \""
          L7_2 = YveltHelper
          L8_2 = L7_2
          L7_2 = L7_2.getPlayerName
          L9_2 = L4_2.source
          L7_2 = L7_2(L8_2, L9_2)
          L8_2 = "\" est d\195\169sormais staff, sous le rank "
          L9_2 = RanksList
          L9_2 = L9_2[L3_2]
          L9_2 = L9_2.label
          L10_2 = " !^0"
          L6_2 = L6_2 .. L7_2 .. L8_2 .. L9_2 .. L10_2
          L5_2(L6_2)
          L5_2 = refreshSource
          L6_2 = L4_2.source
          L5_2(L6_2)
        end
      else
        L5_2 = debugPrint
        L6_2 = "^1Le joueur que vous tentez de modifier son rank n'est pas connect\195\169 !^0"
        L5_2(L6_2)
      end
    elseif "user" == L3_2 then
      L4_2 = YveltHelper
      L5_2 = L4_2
      L4_2 = L4_2.getPlayerFromId
      L6_2 = tonumber
      L7_2 = L2_2
      L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2(L7_2)
      L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      if L4_2 then
        L5_2 = PlayersRanks
        L6_2 = YveltHelper
        L7_2 = L6_2
        L6_2 = L6_2.getIdentifier
        L8_2 = L4_2.source
        L6_2 = L6_2(L7_2, L8_2)
        L5_2 = L5_2[L6_2]
        if L5_2 then
          L5_2 = PlayersRanks
          L6_2 = YveltHelper
          L7_2 = L6_2
          L6_2 = L6_2.getIdentifier
          L8_2 = L4_2.source
          L6_2 = L6_2(L7_2, L8_2)
          L5_2[L6_2] = nil
          L5_2 = MySQL
          L5_2 = L5_2.Async
          L5_2 = L5_2.execute
          L6_2 = "DELETE FROM yvelt_players WHERE identifier = @identifier"
          L7_2 = {}
          L8_2 = YveltHelper
          L9_2 = L8_2
          L8_2 = L8_2.getIdentifier
          L10_2 = L4_2.source
          L8_2 = L8_2(L9_2, L10_2)
          L7_2["@identifier"] = L8_2
          function L8_2(A0_3)
            local L1_3
          end
          L5_2(L6_2, L7_2, L8_2)
          L5_2 = debugPrint
          L6_2 = "^2Le joueur \""
          L7_2 = YveltHelper
          L8_2 = L7_2
          L7_2 = L7_2.getPlayerName
          L9_2 = L4_2.source
          L7_2 = L7_2(L8_2, L9_2)
          L8_2 = "\" n'a plus aucun rank !^0"
          L6_2 = L6_2 .. L7_2 .. L8_2
          L5_2(L6_2)
          L5_2 = YveltHelper
          L6_2 = L5_2
          L5_2 = L5_2.serverNotification
          L7_2 = L4_2.source
          L8_2 = "~g~Votre rank a \195\169t\195\169 retir\195\169 !"
          L5_2(L6_2, L7_2, L8_2)
          L5_2 = refreshSource
          L6_2 = L4_2.source
          L5_2(L6_2)
        else
          L5_2 = debugPrint
          L6_2 = "^2Le joueur \""
          L7_2 = YveltHelper
          L8_2 = L7_2
          L7_2 = L7_2.getPlayerName
          L9_2 = L4_2.source
          L7_2 = L7_2(L8_2, L9_2)
          L8_2 = "\" n'avait pas de rank !^0"
          L6_2 = L6_2 .. L7_2 .. L8_2
          L5_2(L6_2)
        end
      else
        L5_2 = debugPrint
        L6_2 = "^1Le joueur que vous tentez de modifier son rank n'est pas connect\195\169 !^0"
        L5_2(L6_2)
      end
    else
      L4_2 = print
      L5_2 = "^2Le rank \""
      L6_2 = L3_2
      L7_2 = "\" est inconnu, voici la liste des ranks :^0"
      L5_2 = L5_2 .. L6_2 .. L7_2
      L4_2(L5_2)
      L4_2 = pairs
      L5_2 = RegisteredRanks
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = print
        L11_2 = "Rank : "
        L12_2 = L9_2.rank
        L13_2 = " | Label : "
        L14_2 = L9_2.label
        L11_2 = L11_2 .. L12_2 .. L13_2 .. L14_2
        L10_2(L11_2)
      end
      L4_2 = print
      L5_2 = "Exemple d'utilisation : setrank 1 fondateur"
      L4_2(L5_2)
    end
  else
    L2_2 = exports
    L2_2 = L2_2.YveltAdmin
    L3_2 = L2_2
    L2_2 = L2_2.checkAcces
    L4_2 = A0_2
    L5_2 = "setrank"
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    if L2_2 then
      L3_2 = YveltHelper
      L4_2 = L3_2
      L3_2 = L3_2.getPlayerFromId
      L5_2 = A0_2
      L3_2 = L3_2(L4_2, L5_2)
      L4_2 = A1_2[1]
      if not L4_2 then
        return
      end
      L5_2 = L3_2.source
      L6_2 = tonumber
      L7_2 = L4_2
      L6_2 = L6_2(L7_2)
      if L5_2 == L6_2 then
        L5_2 = YveltHelper
        L6_2 = L5_2
        L5_2 = L5_2.serverNotification
        L7_2 = L3_2.source
        L8_2 = "~r~Impossible de changer son propre rank !"
        return L5_2(L6_2, L7_2, L8_2)
      end
      L5_2 = A1_2[2]
      if not L5_2 then
        L6_2 = YveltHelper
        L7_2 = L6_2
        L6_2 = L6_2.serverNotification
        L8_2 = L3_2.source
        L9_2 = "~r~Ce rank n'existe pas !"
        return L6_2(L7_2, L8_2, L9_2)
      end
      L6_2 = RanksList
      L6_2 = L6_2[L5_2]
      if L6_2 then
        L6_2 = YveltHelper
        L7_2 = L6_2
        L6_2 = L6_2.getPlayerFromId
        L8_2 = tonumber
        L9_2 = L4_2
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2)
        L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
        if L6_2 then
          L7_2 = PlayersRanks
          L8_2 = YveltHelper
          L9_2 = L8_2
          L8_2 = L8_2.getIdentifier
          L10_2 = L6_2.source
          L8_2 = L8_2(L9_2, L10_2)
          L7_2 = L7_2[L8_2]
          if L7_2 then
            L7_2 = PlayersRanks
            L8_2 = YveltHelper
            L9_2 = L8_2
            L8_2 = L8_2.getIdentifier
            L10_2 = L6_2.source
            L8_2 = L8_2(L9_2, L10_2)
            L7_2 = L7_2[L8_2]
            L7_2.rank = L5_2
            L7_2 = PlayersRanks
            L8_2 = YveltHelper
            L9_2 = L8_2
            L8_2 = L8_2.getIdentifier
            L10_2 = L6_2.source
            L8_2 = L8_2(L9_2, L10_2)
            L7_2 = L7_2[L8_2]
            L8_2 = RanksList
            L8_2 = L8_2[L5_2]
            L8_2 = L8_2.power
            L7_2.power = L8_2
            L7_2 = MySQL
            L7_2 = L7_2.Async
            L7_2 = L7_2.execute
            L8_2 = "UPDATE yvelt_players SET `rank` = @rank WHERE identifier = @identifier"
            L9_2 = {}
            L10_2 = YveltHelper
            L11_2 = L10_2
            L10_2 = L10_2.getIdentifier
            L12_2 = L6_2.source
            L10_2 = L10_2(L11_2, L12_2)
            L9_2["@identifier"] = L10_2
            L9_2["@rank"] = L5_2
            L7_2(L8_2, L9_2)
            L7_2 = YveltHelper
            L8_2 = L7_2
            L7_2 = L7_2.serverNotification
            L9_2 = L6_2.source
            L10_2 = "~g~Vous \195\170tes d\195\169sormais "
            L11_2 = RanksList
            L11_2 = L11_2[L5_2]
            L11_2 = L11_2.label
            L10_2 = L10_2 .. L11_2
            L7_2(L8_2, L9_2, L10_2)
            L7_2 = YveltHelper
            L8_2 = L7_2
            L7_2 = L7_2.serverNotification
            L9_2 = L3_2.source
            L10_2 = "~g~Le rank de "
            L11_2 = YveltHelper
            L12_2 = L11_2
            L11_2 = L11_2.getPlayerName
            L13_2 = L6_2.source
            L11_2 = L11_2(L12_2, L13_2)
            L12_2 = " a \195\169t\195\169 modifi\195\169"
            L10_2 = L10_2 .. L11_2 .. L12_2
            L7_2(L8_2, L9_2, L10_2)
            L7_2 = debugPrint
            L8_2 = "^2Le joueur \""
            L9_2 = YveltHelper
            L10_2 = L9_2
            L9_2 = L9_2.getPlayerName
            L11_2 = L6_2.source
            L9_2 = L9_2(L10_2, L11_2)
            L10_2 = "\" passe sous le rank "
            L11_2 = RanksList
            L11_2 = L11_2[L5_2]
            L11_2 = L11_2.label
            L12_2 = " !^0"
            L8_2 = L8_2 .. L9_2 .. L10_2 .. L11_2 .. L12_2
            L7_2(L8_2)
            L7_2 = refreshSource
            L8_2 = L6_2.source
            L7_2(L8_2)
          else
            L7_2 = MySQL
            L7_2 = L7_2.Async
            L7_2 = L7_2.execute
            L8_2 = "INSERT INTO yvelt_players (identifier, name, `rank`, report_count, report_notes) VALUES (@identifier, @name, @rank, @report_count, @report_notes)"
            L9_2 = {}
            L10_2 = YveltHelper
            L11_2 = L10_2
            L10_2 = L10_2.getIdentifier
            L12_2 = L6_2.source
            L10_2 = L10_2(L11_2, L12_2)
            L9_2["@identifier"] = L10_2
            L10_2 = YveltHelper
            L11_2 = L10_2
            L10_2 = L10_2.getPlayerName
            L12_2 = L6_2.source
            L10_2 = L10_2(L11_2, L12_2)
            L9_2["@name"] = L10_2
            L9_2["@rank"] = L5_2
            L9_2["@report_count"] = 0
            L9_2["@report_notes"] = 0
            L7_2(L8_2, L9_2)
            L7_2 = PlayersRanks
            L8_2 = YveltHelper
            L9_2 = L8_2
            L8_2 = L8_2.getIdentifier
            L10_2 = L6_2.source
            L8_2 = L8_2(L9_2, L10_2)
            L9_2 = {}
            L10_2 = YveltHelper
            L11_2 = L10_2
            L10_2 = L10_2.getPlayerName
            L12_2 = L6_2.source
            L10_2 = L10_2(L11_2, L12_2)
            L9_2.name = L10_2
            L9_2.rank = L5_2
            L9_2.report_count = 0
            L10_2 = RanksList
            L10_2 = L10_2[L5_2]
            L10_2 = L10_2.power
            L9_2.power = L10_2
            L9_2.report_notes = 0
            L10_2 = RanksList
            L10_2 = L10_2[L5_2]
            L10_2 = L10_2.perms
            L9_2.perms = L10_2
            L7_2[L8_2] = L9_2
            L7_2 = YveltHelper
            L8_2 = L7_2
            L7_2 = L7_2.serverNotification
            L9_2 = L6_2.source
            L10_2 = "~g~Vous \195\170tes d\195\169sormais "
            L11_2 = RanksList
            L11_2 = L11_2[L5_2]
            L11_2 = L11_2.label
            L10_2 = L10_2 .. L11_2
            L7_2(L8_2, L9_2, L10_2)
            L7_2 = YveltHelper
            L8_2 = L7_2
            L7_2 = L7_2.serverNotification
            L9_2 = L3_2.source
            L10_2 = "~g~Le rank de "
            L11_2 = YveltHelper
            L12_2 = L11_2
            L11_2 = L11_2.getPlayerName
            L13_2 = L6_2.source
            L11_2 = L11_2(L12_2, L13_2)
            L12_2 = " a \195\169t\195\169 modifi\195\169"
            L10_2 = L10_2 .. L11_2 .. L12_2
            L7_2(L8_2, L9_2, L10_2)
            L7_2 = debugPrint
            L8_2 = "^2Le joueur \""
            L9_2 = YveltHelper
            L10_2 = L9_2
            L9_2 = L9_2.getPlayerName
            L11_2 = L6_2.source
            L9_2 = L9_2(L10_2, L11_2)
            L10_2 = "\" est d\195\169sormais staff, sous le rank "
            L11_2 = RanksList
            L11_2 = L11_2[L5_2]
            L11_2 = L11_2.label
            L12_2 = " !^0"
            L8_2 = L8_2 .. L9_2 .. L10_2 .. L11_2 .. L12_2
            L7_2(L8_2)
            L7_2 = refreshSource
            L8_2 = L6_2.source
            L7_2(L8_2)
          end
        else
          L7_2 = debugPrint
          L8_2 = "^1Le joueur que vous tentez de modifier son rank n'est pas connect\195\169 !^0"
          L7_2(L8_2)
        end
      elseif "user" == L5_2 then
        L6_2 = YveltHelper
        L7_2 = L6_2
        L6_2 = L6_2.getPlayerFromId
        L8_2 = tonumber
        L9_2 = L4_2
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2)
        L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
        if L6_2 then
          L7_2 = PlayersRanks
          L8_2 = YveltHelper
          L9_2 = L8_2
          L8_2 = L8_2.getIdentifier
          L10_2 = L6_2.source
          L8_2 = L8_2(L9_2, L10_2)
          L7_2 = L7_2[L8_2]
          if L7_2 then
            L7_2 = PlayersRanks
            L8_2 = YveltHelper
            L9_2 = L8_2
            L8_2 = L8_2.getIdentifier
            L10_2 = L6_2.source
            L8_2 = L8_2(L9_2, L10_2)
            L7_2[L8_2] = nil
            L7_2 = MySQL
            L7_2 = L7_2.Async
            L7_2 = L7_2.execute
            L8_2 = "DELETE FROM yvelt_players WHERE identifier = @identifier"
            L9_2 = {}
            L10_2 = YveltHelper
            L11_2 = L10_2
            L10_2 = L10_2.getIdentifier
            L12_2 = L6_2.source
            L10_2 = L10_2(L11_2, L12_2)
            L9_2["@identifier"] = L10_2
            function L10_2(A0_3)
              local L1_3
            end
            L7_2(L8_2, L9_2, L10_2)
            L7_2 = debugPrint
            L8_2 = "^2Le joueur \""
            L9_2 = YveltHelper
            L10_2 = L9_2
            L9_2 = L9_2.getPlayerName
            L11_2 = L6_2.source
            L9_2 = L9_2(L10_2, L11_2)
            L10_2 = "\" n'a plus aucun rank !^0"
            L8_2 = L8_2 .. L9_2 .. L10_2
            L7_2(L8_2)
            L7_2 = YveltHelper
            L8_2 = L7_2
            L7_2 = L7_2.serverNotification
            L9_2 = L6_2.source
            L10_2 = "~g~Votre rank a \195\169t\195\169 retir\195\169 !"
            L7_2(L8_2, L9_2, L10_2)
            L7_2 = YveltHelper
            L8_2 = L7_2
            L7_2 = L7_2.serverNotification
            L9_2 = L3_2.source
            L10_2 = "~g~Le rank de "
            L11_2 = YveltHelper
            L12_2 = L11_2
            L11_2 = L11_2.getPlayerName
            L13_2 = L6_2.source
            L11_2 = L11_2(L12_2, L13_2)
            L12_2 = " a \195\169t\195\169 retir\195\169"
            L10_2 = L10_2 .. L11_2 .. L12_2
            L7_2(L8_2, L9_2, L10_2)
            L7_2 = refreshSource
            L8_2 = L6_2.source
            L7_2(L8_2)
          else
            L7_2 = debugPrint
            L8_2 = "^2Le joueur \""
            L9_2 = YveltHelper
            L10_2 = L9_2
            L9_2 = L9_2.getPlayerName
            L11_2 = L6_2.source
            L9_2 = L9_2(L10_2, L11_2)
            L10_2 = "\" n'avait pas de rank !^0"
            L8_2 = L8_2 .. L9_2 .. L10_2
            L7_2(L8_2)
            L7_2 = YveltHelper
            L8_2 = L7_2
            L7_2 = L7_2.serverNotification
            L9_2 = L3_2.source
            L10_2 = "~g~"
            L11_2 = YveltHelper
            L12_2 = L11_2
            L11_2 = L11_2.getPlayerName
            L13_2 = L6_2.source
            L11_2 = L11_2(L12_2, L13_2)
            L12_2 = " n'avais pas de rank"
            L10_2 = L10_2 .. L11_2 .. L12_2
            L7_2(L8_2, L9_2, L10_2)
          end
        else
          L7_2 = debugPrint
          L8_2 = "^1Le joueur que vous tentez de modifier son rank n'est pas connect\195\169 !^0"
          L7_2(L8_2)
        end
      else
        L6_2 = YveltHelper
        L7_2 = L6_2
        L6_2 = L6_2.serverNotification
        L8_2 = L3_2.source
        L9_2 = "~r~Ce rank n'existe pas !"
        return L6_2(L7_2, L8_2, L9_2)
      end
    else
      L3_2 = YveltHelper
      L4_2 = L3_2
      L3_2 = L3_2.getPlayerFromId
      L5_2 = A0_2
      L3_2 = L3_2(L4_2, L5_2)
      L4_2 = YveltHelper
      L5_2 = L4_2
      L4_2 = L4_2.serverNotification
      L6_2 = L3_2.source
      L7_2 = "~r~Vous n'avez pas la permission"
      L4_2(L5_2, L6_2, L7_2)
    end
  end
end
L1_1(L2_1, L3_1)
L1_1 = Callback
L1_1 = L1_1.registerServerCallback
L2_1 = "YveltAdmin:getRank"
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = YveltHelper
  L2_2 = L1_2
  L1_2 = L1_2.getPlayerFromId
  L3_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L2_2 = PlayersRanks
    L3_2 = YveltHelper
    L4_2 = L3_2
    L3_2 = L3_2.getIdentifier
    L5_2 = L1_2.source
    L3_2 = L3_2(L4_2, L5_2)
    L2_2 = L2_2[L3_2]
    if L2_2 then
      L3_2 = PlayersRanks
      L4_2 = YveltHelper
      L5_2 = L4_2
      L4_2 = L4_2.getIdentifier
      L6_2 = L1_2.source
      L4_2 = L4_2(L5_2, L6_2)
      L3_2 = L3_2[L4_2]
      L4_2 = PlayersRanks
      L5_2 = YveltHelper
      L6_2 = L5_2
      L5_2 = L5_2.getIdentifier
      L7_2 = L1_2.source
      L5_2 = L5_2(L6_2, L7_2)
      L4_2 = L4_2[L5_2]
      L4_2 = L4_2.rank
      L5_2 = RanksList
      L5_2 = L5_2[L4_2]
      L5_2 = L5_2.perms
      L3_2.perms = L5_2
      L5_2 = {}
      L6_2 = L3_2
      L5_2[1] = L6_2
      return L5_2
    else
      L3_2 = {}
      L3_2.rank = "user"
      L4_2 = {}
      L5_2 = L3_2
      L4_2[1] = L5_2
      return L4_2
    end
  end
end
L1_1(L2_1, L3_1)
function L1_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L1_2 = YveltHelper
  L2_2 = L1_2
  L1_2 = L1_2.getPlayerFromId
  L3_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = ESX
  L2_2 = L2_2.GetPlayers
  L2_2 = L2_2()
  if L2_2 then
    L3_2 = PlayersRanks
    L4_2 = YveltHelper
    L5_2 = L4_2
    L4_2 = L4_2.getIdentifier
    L6_2 = L1_2.source
    L4_2 = L4_2(L5_2, L6_2)
    L3_2 = L3_2[L4_2]
    if L3_2 then
      L4_2 = TriggerClientEvent
      L5_2 = "Yvelt:RefreshClientInfos"
      L6_2 = A0_2
      L7_2 = L3_2
      L8_2 = false
      L4_2(L5_2, L6_2, L7_2, L8_2)
    else
      L4_2 = {}
      L4_2.rank = "user"
      L5_2 = TriggerClientEvent
      L6_2 = "Yvelt:RefreshClientInfos"
      L7_2 = A0_2
      L8_2 = L4_2
      L9_2 = true
      L5_2(L6_2, L7_2, L8_2, L9_2)
      L5_2 = activeStaff
      L6_2 = "id:"
      L7_2 = A0_2
      L8_2 = ""
      L6_2 = L6_2 .. L7_2 .. L8_2
      L5_2 = L5_2[L6_2]
      if L5_2 then
        L5_2 = activeStaff
        L6_2 = "id:"
        L7_2 = A0_2
        L8_2 = ""
        L6_2 = L6_2 .. L7_2 .. L8_2
        L5_2[L6_2] = nil
        L5_2 = 1
        L6_2 = #L2_2
        L7_2 = 1
        for L8_2 = L5_2, L6_2, L7_2 do
          L9_2 = YveltHelper
          L10_2 = L9_2
          L9_2 = L9_2.getPlayerFromId
          L11_2 = L2_2[L8_2]
          L9_2 = L9_2(L10_2, L11_2)
          L10_2 = PlayersRanks
          L11_2 = YveltHelper
          L12_2 = L11_2
          L11_2 = L11_2.getIdentifier
          L13_2 = L9_2.source
          L11_2 = L11_2(L12_2, L13_2)
          L10_2 = L10_2[L11_2]
          if L10_2 then
            L10_2 = TriggerClientEvent
            L11_2 = "esx:showAdvancedNotification"
            L12_2 = L9_2.source
            L13_2 = "Administration"
            L14_2 = YveltConfig
            L14_2 = L14_2.ColorMenu
            L15_2 = "Mode mod\195\169ration"
            L14_2 = L14_2 .. L15_2
            L15_2 = YveltConfig
            L15_2 = L15_2.ColorMenu
            L16_2 = ""
            L17_2 = GetPlayerName
            L18_2 = A0_2
            L17_2 = L17_2(L18_2)
            L18_2 = "~s~ \195\160 ~r~d\195\169sactiver~s~ son mode mod\195\169ration "
            L15_2 = L15_2 .. L16_2 .. L17_2 .. L18_2
            L16_2 = "CHAR_BLIMP"
            L17_2 = 0
            L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
          end
        end
      end
    end
  end
end
refreshSource = L1_1
L1_1 = Callback
L1_1 = L1_1.registerServerCallback
L2_1 = "YveltAdmin:getRanksList"
function L3_1(A0_2)
  local L1_2, L2_2
  L1_2 = {}
  L2_2 = RanksList
  L1_2[1] = L2_2
  return L1_2
end
L1_1(L2_1, L3_1)
L1_1 = {}
PlayersRanks = L1_1
L1_1 = Callback
L1_1 = L1_1.registerServerCallback
L2_1 = "YveltAdmin:getStaffs"
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = YveltHelper
  L2_2 = L1_2
  L1_2 = L1_2.getPlayerFromId
  L3_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = {}
  L3_2 = PlayersRanks
  L4_2 = YveltHelper
  L5_2 = L4_2
  L4_2 = L4_2.getIdentifier
  L6_2 = L1_2.source
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  return L2_2
end
L1_1(L2_1, L3_1)
function L1_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = MySQL
  L0_2 = L0_2.Async
  L0_2 = L0_2.fetchAll
  L1_2 = "SELECT * FROM yvelt_players"
  L2_2 = {}
  function L3_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L1_3 = pairs
    L2_3 = A0_3
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
      L7_3 = RanksList
      L8_3 = L6_3.rank
      L7_3 = L7_3[L8_3]
      if L7_3 then
        L7_3 = PlayersRanks
        L8_3 = L6_3.identifier
        L9_3 = {}
        L10_3 = L6_3.id
        L9_3.id = L10_3
        L10_3 = YveltHelper
        L11_3 = L10_3
        L10_3 = L10_3.getTextFromAscii
        L12_3 = L6_3.name
        L10_3 = L10_3(L11_3, L12_3)
        L9_3.name = L10_3
        L10_3 = L6_3.rank
        L9_3.rank = L10_3
        L10_3 = L6_3.power
        L9_3.power = L10_3
        L10_3 = L6_3.color
        L9_3.color = L10_3
        L10_3 = tonumber
        L11_3 = L6_3.report_count
        L10_3 = L10_3(L11_3)
        L9_3.report_count = L10_3
        L10_3 = tonumber
        L11_3 = L6_3.report_notes
        L10_3 = L10_3(L11_3)
        L9_3.report_notes = L10_3
        L10_3 = RanksList
        L11_3 = L6_3.rank
        L10_3 = L10_3[L11_3]
        L10_3 = L10_3.perms
        L9_3.perms = L10_3
        L7_3[L8_3] = L9_3
      else
        L7_3 = MySQL
        L7_3 = L7_3.Async
        L7_3 = L7_3.execute
        L8_3 = "DELETE FROM yvelt_players WHERE id = @id"
        L9_3 = {}
        L10_3 = L6_3.id
        L9_3["@id"] = L10_3
        function L10_3(A0_4)
          local L1_4
        end
        L7_3(L8_3, L9_3, L10_3)
        L7_3 = debugPrint
        L8_3 = "^1Le joueur rank du staff "
        L9_3 = YveltHelper
        L10_3 = L9_3
        L9_3 = L9_3.getTextFromAscii
        L11_3 = L6_3.name
        L9_3 = L9_3(L10_3, L11_3)
        L10_3 = " a \195\169t\195\169 supprim\195\169, il est donc repass\195\169 sous simple joueur.^0"
        L8_3 = L8_3 .. L9_3 .. L10_3
        L7_3(L8_3)
      end
    end
    L1_3 = debugPrint
    L2_3 = "Tous les joueurs avec des ranks ont \195\169t\195\169 charg\195\169 !"
    L1_3(L2_3)
  end
  L0_2(L1_2, L2_2, L3_2)
end
loadPlayers = L1_1
L1_1 = RegisterServerEvent
L2_1 = "Yvelt:saveRank"
L1_1(L2_1)
L1_1 = AddEventHandler
L2_1 = "Yvelt:saveRank"
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = YveltHelper
  L3_2 = L2_2
  L2_2 = L2_2.getPlayerFromId
  L4_2 = source
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = {}
  if not A1_2 then
    L4_2 = YveltHelper
    L5_2 = L4_2
    L4_2 = L4_2.serverNotification
    L6_2 = L2_2.source
    L7_2 = "~r~Une erreur est survenue"
    return L4_2(L5_2, L6_2, L7_2)
  end
  L4_2 = PlayersRanks
  L5_2 = YveltHelper
  L6_2 = L5_2
  L5_2 = L5_2.getIdentifier
  L7_2 = L2_2.source
  L5_2 = L5_2(L6_2, L7_2)
  L4_2 = L4_2[L5_2]
  L4_2 = L4_2.rank
  if "fondateur" == L4_2 then
    L4_2 = RanksList
    L5_2 = A0_2.rank
    L4_2 = L4_2[L5_2]
    if L4_2 then
      L4_2 = {}
      perm = L4_2
      L4_2 = print
      L5_2 = json
      L5_2 = L5_2.encode
      L6_2 = A1_2
      L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L5_2(L6_2)
      L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
      L4_2 = pairs
      L5_2 = A1_2
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = print
        L11_2 = L8_2
        L12_2 = L9_2
        L10_2(L11_2, L12_2)
        if L8_2 then
          L10_2 = perm
          L10_2[L8_2] = L9_2
          L10_2 = print
          L11_2 = "Param\195\168tre "
          L12_2 = L8_2
          L13_2 = " d\195\169finie sur "
          L14_2 = tostring
          L15_2 = L9_2
          L14_2 = L14_2(L15_2)
          L11_2 = L11_2 .. L12_2 .. L13_2 .. L14_2
          L10_2(L11_2)
          L10_2 = table
          L10_2 = L10_2.insert
          L11_2 = L3_2
          L12_2 = perm
          L12_2 = L12_2[L8_2]
          L10_2(L11_2, L12_2)
        end
      end
      L4_2 = RanksList
      L5_2 = A0_2.rank
      L6_2 = {}
      L7_2 = A0_2.rank
      L6_2.rank = L7_2
      L7_2 = A0_2.power
      L6_2.power = L7_2
      L7_2 = A0_2.color
      L6_2.color = L7_2
      L7_2 = A0_2.label
      L6_2.label = L7_2
      L7_2 = perm
      L6_2.perms = L7_2
      L4_2[L5_2] = L6_2
      L4_2 = MySQL
      L4_2 = L4_2.Async
      L4_2 = L4_2.execute
      L5_2 = "UPDATE yvelt_ranks SET power = @power, color = @color, label = @label, perms = @perms WHERE `rank` = @rank"
      L6_2 = {}
      L7_2 = A0_2.rank
      L6_2["@rank"] = L7_2
      L7_2 = A0_2.power
      L6_2["@power"] = L7_2
      L7_2 = A0_2.color
      L6_2["@color"] = L7_2
      L7_2 = A0_2.label
      L6_2["@label"] = L7_2
      L7_2 = json
      L7_2 = L7_2.encode
      L8_2 = perm
      L7_2 = L7_2(L8_2)
      L6_2["@perms"] = L7_2
      L4_2(L5_2, L6_2)
    else
      L4_2 = YveltHelper
      L5_2 = L4_2
      L4_2 = L4_2.serverNotification
      L6_2 = L2_2.source
      L7_2 = "~r~Ce rank n'exsite pas a mes yeux !"
      L4_2(L5_2, L6_2, L7_2)
    end
  end
end
L1_1(L2_1, L3_1)
L1_1 = RegisterServerEvent
L2_1 = "Yvelt:createNewRank"
L1_1(L2_1)
L1_1 = AddEventHandler
L2_1 = "Yvelt:createNewRank"
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = YveltHelper
  L3_2 = L2_2
  L2_2 = L2_2.getPlayerFromId
  L4_2 = source
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = {}
  if not A1_2 then
    L4_2 = YveltHelper
    L5_2 = L4_2
    L4_2 = L4_2.serverNotification
    L6_2 = L2_2.source
    L7_2 = "~r~Une erreur est survenue"
    return L4_2(L5_2, L6_2, L7_2)
  end
  L4_2 = PlayersRanks
  L5_2 = YveltHelper
  L6_2 = L5_2
  L5_2 = L5_2.getIdentifier
  L7_2 = L2_2.source
  L5_2 = L5_2(L6_2, L7_2)
  L4_2 = L4_2[L5_2]
  L4_2 = L4_2.rank
  if "fondateur" == L4_2 then
    L4_2 = RanksList
    L5_2 = A0_2.rank
    L4_2 = L4_2[L5_2]
    if L4_2 then
      L4_2 = YveltHelper
      L5_2 = L4_2
      L4_2 = L4_2.serverNotification
      L6_2 = L2_2.source
      L7_2 = "~r~Ce rank \195\169xiste d\195\169j\195\160 !"
      L4_2(L5_2, L6_2, L7_2)
    else
      L4_2 = {}
      perm = L4_2
      L4_2 = pairs
      L5_2 = A1_2
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = L9_2.name
        if L10_2 then
          L10_2 = perm
          L11_2 = L9_2.name
          L12_2 = L9_2.default
          L10_2[L11_2] = L12_2
          L10_2 = table
          L10_2 = L10_2.insert
          L11_2 = L3_2
          L12_2 = perm
          L13_2 = L9_2.name
          L12_2 = L12_2[L13_2]
          L10_2(L11_2, L12_2)
        end
      end
      L4_2 = RanksList
      L5_2 = A0_2.rank
      L6_2 = {}
      L7_2 = A0_2.rank
      L6_2.rank = L7_2
      L7_2 = A0_2.power
      L6_2.power = L7_2
      L7_2 = A0_2.color
      L6_2.color = L7_2
      L7_2 = A0_2.label
      L6_2.label = L7_2
      L7_2 = json
      L7_2 = L7_2.encode
      L8_2 = perm
      L7_2 = L7_2(L8_2)
      L6_2.perms = L7_2
      L4_2[L5_2] = L6_2
      L4_2 = MySQL
      L4_2 = L4_2.Async
      L4_2 = L4_2.execute
      L5_2 = "INSERT INTO yvelt_ranks (label, `rank`, perms, power, color) VALUES (@label, @rank, @perms, @power, @color)"
      L6_2 = {}
      L7_2 = A0_2.label
      L6_2["@label"] = L7_2
      L7_2 = A0_2.rank
      L6_2["@rank"] = L7_2
      L7_2 = json
      L7_2 = L7_2.encode
      L8_2 = perm
      L7_2 = L7_2(L8_2)
      L6_2["@perms"] = L7_2
      L7_2 = A0_2.power
      L6_2["@power"] = L7_2
      L7_2 = A0_2.color
      L6_2["@color"] = L7_2
      L4_2(L5_2, L6_2)
      L4_2 = debugPrint
      L5_2 = "Un nouveau rank a \195\169t\195\169 cr\195\169e sous le nom de \""
      L6_2 = A0_2.rank
      L7_2 = "\" par "
      L8_2 = YveltHelper
      L9_2 = L8_2
      L8_2 = L8_2.getPlayerName
      L10_2 = L2_2.source
      L8_2 = L8_2(L9_2, L10_2)
      L9_2 = " !"
      L5_2 = L5_2 .. L6_2 .. L7_2 .. L8_2 .. L9_2
      L4_2(L5_2)
      L4_2 = refreshSource
      L5_2 = source
      L4_2(L5_2)
    end
  else
    L4_2 = DropPlayer
    L5_2 = source
    L6_2 = "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:createNewRank\")"
    L4_2(L5_2, L6_2)
  end
end
L1_1(L2_1, L3_1)
RegisterNetEvent('Yvelt:deleteRank')
AddEventHandler('Yvelt:deleteRank', function(rankName)
  local src = source
  local xPlayer = YveltHelper:getPlayerFromId(src)
  if not xPlayer then return end
  
  local identifier = YveltHelper:getIdentifier(xPlayer.source)
  local playerRank = PlayersRanks[identifier]
  
  if not playerRank or playerRank.rank ~= 'fondateur' then
    YveltHelper:serverNotification(src, '~r~Vous n\'avez pas la permission')
    DropPlayer(src, "YveltShield : Tentative de triche (bypass trigger : \"Yvelt:deleteRank\")")
    return
  end
  
  if rankName == 'fondateur' then
    YveltHelper:serverNotification(src, '~r~Impossible de supprimer le rank fondateur')
    return
  end
  
  if not RanksList[rankName] then
    YveltHelper:serverNotification(src, '~r~Ce rank n\'existe pas')
    return
  end
  
  MySQL.Async.execute('DELETE FROM yvelt_ranks WHERE `rank` = @rank', {
    ['@rank'] = rankName,
  }, function()
    RanksList[rankName] = nil
    YveltHelper:serverNotification(src, '~g~Rank supprimé avec succès')
    TriggerEvent('YveltAdmin:refreshRanksCache')
  end)
end)
L1_1 = MySQL
L1_1 = L1_1.ready
function L2_1()
  local L0_2, L1_2
  L0_2 = loadRanks
  L0_2()
end
L1_1(L2_1)
