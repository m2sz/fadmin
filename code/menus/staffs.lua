function MenuStaffs()
    --[[
        PlayersRanks[v.identifier] = {
            id = v.id,
            name = v.name,
            rank = v.rank,
            power = v.power,
            color = v.color,
            report_count = v.report_count,
            report_notes = v.report_notes,
            perms = RanksList[v.rank].perms
        }
    ]]
    if StaffListtt == nil then
        if json.encode(StaffListtt) ~= '[]' then
            RageUI.Separator()
            RageUI.Separator('~r~Chargement des staffs...')
            RageUI.Separator()
        else
            RageUI.Separator()
            RageUI.Separator('~r~Une erreur est survenue...')
            RageUI.Separator()
        end
    else
        for k, v in pairs(StaffListtt) do
            RageUI.Button(v.name..' ~c~('..v.rank..')', 'Reports effectué : '..YveltConfig.ColorMenu.. '' ..v.report_count..'~s~\nMoyenne : '..YveltConfig.ColorMenu.. '' ..calcMoyenne(v.report_count, v.report_notes)..'/5', {RightLabel = calcMoyenne(v.report_count, v.report_notes)..'/5', RightBadge = RageUI.BadgeStyle.Star}, true, {})
        end
    end
end