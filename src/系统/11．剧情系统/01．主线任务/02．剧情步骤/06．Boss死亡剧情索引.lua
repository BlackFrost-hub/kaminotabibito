--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["Boss死亡剧情索引表"] = {
    {
        ["Boss单位ID"] = "N00C",
        ["Boss名"] = "地精祭祀",
        ["需要剧情进度"] = 3,
        ["设置剧情进度"] = 4,
        ["剧情片段ID"] = "jlc_elven_village_goblin_defeated_to_desert",
        ["说明"] = "地精祭祀死亡后，接黑影退场、复命长老、前往沙漠。"
    },
    {
        ["Boss单位ID"] = "N05J",
        ["Boss名"] = "沙漠食人魔",
        ["需要剧情进度"] = 11,
        ["设置剧情进度"] = 12,
        ["剧情片段ID"] = "jlc_snake_ogre_defeated_to_guard_duel",
        ["说明"] = "沙漠食人魔一阶段死亡后，接裂隙与杀戮食人魔二阶段。"
    },
    {
        ["Boss单位ID"] = "N05K",
        ["Boss名"] = "杀戮食人魔",
        ["需要剧情进度"] = 12,
        ["设置剧情进度"] = 13,
        ["阶段标记"] = "沙漠食人魔二阶段",
        ["剧情片段ID"] = "jlc_snake_ogre_defeated_to_guard_duel",
        ["说明"] = "杀戮食人魔死亡后，回蛇人族交凭证并接护卫对战。"
    },
    {
        ["Boss单位ID"] = "N05N",
        ["Boss名"] = "蒙面人",
        ["需要剧情进度"] = 17,
        ["设置剧情进度"] = 18,
        ["阶段标记"] = "剑士姿态",
        ["剧情片段ID"] = "jlc_return_village_defeat_chapter_one_cult_boss",
        ["说明"] = "第一章最终Boss剑士姿态死亡后，接教派败退与前往王城。"
    },
    {
        ["Boss单位ID"] = "N05M",
        ["Boss名"] = "蒙面人",
        ["需要剧情进度"] = 17,
        ["设置剧情进度"] = 18,
        ["阶段标记"] = "学者姿态",
        ["剧情片段ID"] = "jlc_return_village_defeat_chapter_one_cult_boss",
        ["说明"] = "第一章最终Boss学者姿态死亡后，接教派败退与前往王城。"
    },
    {
        ["Boss单位ID"] = "N05S",
        ["Boss名"] = "树魔首领",
        ["需要剧情进度"] = 27,
        ["设置剧情进度"] = 28,
        ["剧情片段ID"] = "elven_city_hunter_to_treant_leader",
        ["说明"] = "树魔首领死亡后，掉落魔法信件并返回王城汇报。"
    }
}
local function _____5267_60C5_8FDB_5EA6_5339_914D(_____914D_7F6E_8FDB_5EA6, _____5F53_524D_5267_60C5_8FDB_5EA6)
    return _____914D_7F6E_8FDB_5EA6 == nil or _____5F53_524D_5267_60C5_8FDB_5EA6 == nil or _____914D_7F6E_8FDB_5EA6 == _____5F53_524D_5267_60C5_8FDB_5EA6
end
local function _____9636_6BB5_5339_914D(_____914D_7F6E_9636_6BB5, _____5F53_524D_9636_6BB5)
    return _____914D_7F6E_9636_6BB5 == nil or _____5F53_524D_9636_6BB5 == nil or _____914D_7F6E_9636_6BB5 == _____5F53_524D_9636_6BB5
end
____exports["查找Boss死亡剧情索引"] = function(____Boss_5355_4F4DID, _____5F53_524D_5267_60C5_8FDB_5EA6, _____9636_6BB5_6807_8BB0)
    do
        local i = 0
        while i < #____exports["Boss死亡剧情索引表"] do
            do
                local _____7D22_5F15_9879 = ____exports["Boss死亡剧情索引表"][i + 1]
                if _____7D22_5F15_9879["Boss单位ID"] ~= ____Boss_5355_4F4DID then
                    goto __continue6
                end
                if not _____5267_60C5_8FDB_5EA6_5339_914D(_____7D22_5F15_9879["需要剧情进度"], _____5F53_524D_5267_60C5_8FDB_5EA6) then
                    goto __continue6
                end
                if not _____9636_6BB5_5339_914D(_____7D22_5F15_9879["阶段标记"], _____9636_6BB5_6807_8BB0) then
                    goto __continue6
                end
                return _____7D22_5F15_9879
            end
            ::__continue6::
            i = i + 1
        end
    end
    return nil
end
____exports.default = ____exports["Boss死亡剧情索引表"]
return ____exports
