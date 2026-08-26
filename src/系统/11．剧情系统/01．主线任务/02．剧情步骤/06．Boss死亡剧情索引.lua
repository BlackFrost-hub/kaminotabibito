--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668["播放主线剧情片段"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_1["按名字反查Boss单位ID"]
local GetUnitTypeId = jass.GetUnitTypeId
____exports["Boss死亡剧情索引表"] = {
    {
        ["Boss单位名"] = "地精祭祀|cffff0000（BossLV12）|r",
        ["Boss单位ID"] = "N00C",
        ["需要剧情进度"] = 3,
        ["设置剧情进度"] = 4,
        ["剧情片段ID"] = "jlc_goblin_boss_death",
        ["说明"] = "地精祭祀死亡后播放残血地精、首领奖励、神秘人出现与回村复命引导演出。"
    },
    {
        ["Boss单位名"] = "沙漠食人魔",
        ["需要剧情进度"] = 11,
        ["设置剧情进度"] = 12,
        ["剧情片段ID"] = "jlc_desert_ogre_first_death",
        ["说明"] = "沙漠食人魔一阶段死亡后，接裂隙与杀戮食人魔二阶段演出。"
    },
    {
        ["Boss单位名"] = "杀戮食人魔",
        ["需要剧情进度"] = 12,
        ["设置剧情进度"] = 13,
        ["阶段标记"] = "沙漠食人魔二阶段",
        ["剧情片段ID"] = "jlc_slaughter_ogre_death",
        ["说明"] = "杀戮食人魔死亡后，引导回蛇人族交任务；死亡掉落迁出到后续 Boss 死亡掉落系统。"
    },
    {
        ["Boss单位名"] = "教派剑士",
        ["需要剧情进度"] = 17,
        ["设置剧情进度"] = 18,
        ["阶段标记"] = "剑士姿态",
        ["剧情片段ID"] = "jlc_cult_final_boss_death",
        ["说明"] = "第一章最终 Boss 剑士姿态死亡后，接教派败退与前往王城。"
    },
    {
        ["Boss单位名"] = "教派学者",
        ["需要剧情进度"] = 17,
        ["设置剧情进度"] = 18,
        ["阶段标记"] = "学者姿态",
        ["剧情片段ID"] = "jlc_cult_final_boss_death",
        ["说明"] = "第一章最终 Boss 学者姿态死亡后，接教派败退与前往王城。"
    },
    {
        ["Boss单位名"] = "树魔首领",
        ["需要剧情进度"] = 27,
        ["设置剧情进度"] = 28,
        ["剧情片段ID"] = "elven_city_treant_leader_death",
        ["说明"] = "树魔首领死亡后，留下遗言并掉落残缺的魔法信件，等待玩家查看。"
    },
    {
        ["Boss单位名"] = "菲利斯",
        ["需要剧情进度"] = 32,
        ["设置剧情进度"] = 33,
        ["剧情片段ID"] = "elven_city_chapter_boss_death_bridge",
        ["说明"] = "王城外的菲利斯投影被击败后，揭示正面攻城只是调虎离山，并引导玩家回援王宫。"
    },
    {
        ["Boss单位名"] = "里科特",
        ["需要剧情进度"] = 34,
        ["设置剧情进度"] = 35,
        ["剧情片段ID"] = "elven_city_chapter_end",
        ["说明"] = "当前 TS 暂按第二章末战 Boss = 里科特王子 假定绑定；源 JASS 仅能确认剧情进度 34 时死亡触发后进入章节末最终收束，具体死亡单位判定仍可能补正。"
    },
    {
        ["Boss单位名"] = "双重凤凰·菲尼克斯尔",
        ["需要剧情进度"] = 44,
        ["设置剧情进度"] = 45,
        ["剧情片段ID"] = "molten_realm_phoenixel_aftermath",
        ["说明"] = "菲尼克斯尔死亡后熄灭怨火、稳定传送阵并前往英灵墓地。"
    },
    {["Boss单位名"] = "沉睡英魂·亚伦柯斯", ["需要剧情进度"] = 47, ["设置剧情进度"] = 48, ["说明"] = "亚伦柯斯死亡后开启通往封印核心的内层墓门；传送门由 Boss 死亡监听按场景时机注册。"}
}
local function ____Boss_5355_4F4D_540D_5339_914D(unitTypeId, ____Boss_5355_4F4D_540D, ____Boss_5355_4F4DID)
    local rawId = ____Boss_5355_4F4DID or _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(____Boss_5355_4F4D_540D)
    return stringToFourCCSafe(rawId) == unitTypeId
end
local function _____5267_60C5_8FDB_5EA6_5339_914D(_____914D_7F6E_8FDB_5EA6, _____5F53_524D_5267_60C5_8FDB_5EA6)
    return _____914D_7F6E_8FDB_5EA6 == nil or _____914D_7F6E_8FDB_5EA6 == _____5F53_524D_5267_60C5_8FDB_5EA6
end
local function _____9636_6BB5_5339_914D(_____914D_7F6E_9636_6BB5, _____5F53_524D_9636_6BB5)
    return _____914D_7F6E_9636_6BB5 == nil or _____5F53_524D_9636_6BB5 == nil or _____914D_7F6E_9636_6BB5 == _____5F53_524D_9636_6BB5
end
____exports["查找Boss死亡剧情索引"] = function(____Boss_5355_4F4D_7C7B_578BID, _____5F53_524D_5267_60C5_8FDB_5EA6, _____9636_6BB5_6807_8BB0)
    do
        local i = 0
        while i < #____exports["Boss死亡剧情索引表"] do
            do
                local _____7D22_5F15_9879 = ____exports["Boss死亡剧情索引表"][i + 1]
                if not ____Boss_5355_4F4D_540D_5339_914D(____Boss_5355_4F4D_7C7B_578BID, _____7D22_5F15_9879["Boss单位名"], _____7D22_5F15_9879["Boss单位ID"]) then
                    goto __continue7
                end
                if not _____5267_60C5_8FDB_5EA6_5339_914D(_____7D22_5F15_9879["需要剧情进度"], _____5F53_524D_5267_60C5_8FDB_5EA6) then
                    goto __continue7
                end
                if not _____9636_6BB5_5339_914D(_____7D22_5F15_9879["阶段标记"], _____9636_6BB5_6807_8BB0) then
                    goto __continue7
                end
                return _____7D22_5F15_9879
            end
            ::__continue7::
            i = i + 1
        end
    end
    return nil
end
____exports["尝试播放Boss死亡主线剧情"] = function(bossUnit, _____9636_6BB5_6807_8BB0)
    if bossUnit == nil or bossUnit == 0 then
        return false
    end
    local _____7D22_5F15_9879 = ____exports["查找Boss死亡剧情索引"](
        GetUnitTypeId(bossUnit),
        _____8BFB_53D6_5267_60C5_8FDB_5EA6(),
        _____9636_6BB5_6807_8BB0
    )
    if _____7D22_5F15_9879 == nil then
        return false
    end
    if _____7D22_5F15_9879["设置剧情进度"] ~= nil then
        _____5199_5165_5267_60C5_8FDB_5EA6(_____7D22_5F15_9879["设置剧情进度"])
    end
    if _____7D22_5F15_9879["剧情片段ID"] == nil or _____7D22_5F15_9879["剧情片段ID"] == "" then
        return true
    end
    return _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7D22_5F15_9879["剧情片段ID"], {["片段ID"] = _____7D22_5F15_9879["剧情片段ID"], ["触发配置名"] = "Boss死亡剧情索引", ["触发单位"] = bossUnit})
end
____exports.default = ____exports["Boss死亡剧情索引表"]
return ____exports
