--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_0.SelectUnitForPlayerSingle
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_2["应用Boss战启动属性配置"]
local ____require_result_3 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_3["标记测试Boss跳过死亡结算"]
local ____require_result_4 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_4["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_4["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_4["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_4["准备Boss测试固定步兵"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_4["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_4["注册Boss测试命令组"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587 = ____require_result_5["获取或创建卡瑟拉上下文"]
local _____6E05_7406_5361_745F_62C9_4E0A_4E0B_6587 = ____require_result_5["清理卡瑟拉上下文"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.13．被动效果")
local _____6CE8_518C_5361_745F_62C9_88AB_52A8_6548_679C = ____require_result_6["注册卡瑟拉被动效果"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.06．深渊召唤")
local _____91CA_653E_5361_745F_62C9_6DF1_6E0A_53EC_5524 = ____require_result_7["释放卡瑟拉深渊召唤"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.03．深海涡流")
local _____91CA_653E_5361_745F_62C9_6DF1_6D77_6DA1_6D41 = ____require_result_8["释放卡瑟拉深海涡流"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.04．触手鞭笞")
local _____91CA_653E_5361_745F_62C9_89E6_624B_97AD_7B1E = ____require_result_9["释放卡瑟拉触手鞭笞"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.05．墨汁喷吐")
local _____91CA_653E_5361_745F_62C9_58A8_6C41_55B7_5410 = ____require_result_10["释放卡瑟拉墨汁喷吐"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.07．高压水炮")
local _____91CA_653E_5361_745F_62C9_9AD8_538B_6C34_70AE = ____require_result_11["释放卡瑟拉高压水炮"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.08．触手解放")
local _____89E6_53D1_5361_745F_62C9_89E6_624B_89E3_653E = ____require_result_12["触发卡瑟拉触手解放"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.09．共生电击")
local _____91CA_653E_5361_745F_62C9_5171_751F_7535_51FB = ____require_result_13["释放卡瑟拉共生电击"]
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local CreateUnit = jass.CreateUnit
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local GetPlayerId = jass.GetPlayerId
local _____5361_745F_62C9_6D4B_8BD5Boss = {}
local _____5361_745F_62C9_6D4B_8BD5_6B65_51751 = {}
local _____5361_745F_62C9_6D4B_8BD5_6B65_51752 = {}
local function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local cached = _____5361_745F_62C9_6D4B_8BD5Boss[pid]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(cached) then
        SetUnitPosition(cached, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
        SetUnitFacing(cached, 270)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(cached)
        globals.udg_Boss = cached
        return cached
    end
    local boss = CreateUnit(
        player,
        stringToFourCC("N05V"),
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____5361_745F_62C9_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 42, false)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        globals.udg_Boss = boss
    end
    return boss
end
local function _____51C6_5907_6D4B_8BD5_573A_666F(player, boss)
    local pid = GetPlayerId(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if hero ~= nil and hero ~= 0 then
        SetUnitPosition(hero, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y)
        SetUnitFacing(hero, 90)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    end
    _____5361_745F_62C9_6D4B_8BD5_6B65_51751[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____5361_745F_62C9_6D4B_8BD5_6B65_51751[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    _____5361_745F_62C9_6D4B_8BD5_6B65_51752[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____5361_745F_62C9_6D4B_8BD5_6B65_51752[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X + 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
end
local function _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
end
local function _____521B_5EFA_5361_745F_62C9_6D4B_8BD5(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____6CE8_518C_5361_745F_62C9_88AB_52A8_6548_679C()
    _____51C6_5907_6D4B_8BD5_573A_666F(player, boss)
    _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    return _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587(boss)
end
local function _____6E05_7406_5361_745F_62C9_6D4B_8BD5(player, _context)
    local pid = GetPlayerId(player)
    local boss = _____5361_745F_62C9_6D4B_8BD5Boss[pid]
    if boss ~= nil and boss ~= 0 then
        _____6E05_7406_5361_745F_62C9_4E0A_4E0B_6587(boss)
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____5361_745F_62C9_6D4B_8BD5_6B65_51751[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____5361_745F_62C9_6D4B_8BD5_6B65_51752[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(boss)
    _____5361_745F_62C9_6D4B_8BD5_6B65_51751[pid] = nil
    _____5361_745F_62C9_6D4B_8BD5_6B65_51752[pid] = nil
    _____5361_745F_62C9_6D4B_8BD5Boss[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function ____on_5361_745F_62C9_6280_80FD1_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_5361_745F_62C9_6DF1_6D77_6DA1_6D41(context)
    end
end
local function ____on_5361_745F_62C9_6280_80FD2_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_5361_745F_62C9_89E6_624B_97AD_7B1E(context)
    end
end
local function ____on_5361_745F_62C9_6280_80FD3_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_5361_745F_62C9_58A8_6C41_55B7_5410(context)
    end
end
local function ____on_5361_745F_62C9_6280_80FD4_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_5361_745F_62C9_6DF1_6E0A_53EC_5524(context)
    end
end
local function ____on_5361_745F_62C9_6280_80FD5_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_5361_745F_62C9_9AD8_538B_6C34_70AE(context)
    end
end
local function ____on_5361_745F_62C9_6280_80FD6_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____89E6_53D1_5361_745F_62C9_89E6_624B_89E3_653E(context)
    end
end
local function ____on_5361_745F_62C9_6280_80FD7_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_5361_745F_62C9_5171_751F_7535_51FB(context)
    end
end
local _____5361_745F_62C9_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "深海涡流", ["执行"] = ____on_5361_745F_62C9_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "触手鞭笞", ["执行"] = ____on_5361_745F_62C9_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "墨汁喷吐", ["执行"] = ____on_5361_745F_62C9_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "深渊召唤", ["执行"] = ____on_5361_745F_62C9_6280_80FD4_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["名称"] = "高压水炮", ["执行"] = ____on_5361_745F_62C9_6280_80FD5_6D4B_8BD5_547D_4EE4},
    {["序号"] = 6, ["名称"] = "触手解放", ["执行"] = ____on_5361_745F_62C9_6280_80FD6_6D4B_8BD5_547D_4EE4},
    {["序号"] = 7, ["名称"] = "共生电击", ["执行"] = ____on_5361_745F_62C9_6280_80FD7_6D4B_8BD5_547D_4EE4}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "卡瑟拉",
    ["Boss名称"] = "卡瑟拉",
    ["创建或获取上下文"] = _____521B_5EFA_5361_745F_62C9_6D4B_8BD5,
    ["清理上下文"] = _____6E05_7406_5361_745F_62C9_6D4B_8BD5,
    ["技能命令列表"] = _____5361_745F_62C9_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
