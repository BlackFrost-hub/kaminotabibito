--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_0.SelectUnitForPlayerSingle
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_2["应用Boss战启动属性配置"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587 = ____require_result_3["获取或创建菲尼克斯尔上下文"]
local _____6E05_7406_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587 = ____require_result_3["清理菲尼克斯尔上下文"]
local _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_8FD0_884C_65F6 = ____require_result_3["注册菲尼克斯尔运行时"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.18．技能入口")
local _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_6280_80FD_7ED3_6784 = ____require_result_4["注册菲尼克斯尔技能结构"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.05．永恒冰核与导管")
local _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6C38_6052_51B0_6838_4E0E_5BFC_7BA1 = ____require_result_5["初始化菲尼克斯尔永恒冰核与导管"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.06．炽羽散射")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_70BD_7FBD_6563_5C04 = ____require_result_6["释放菲尼克斯尔炽羽散射"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.07．熔岩吐息")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_7194_5CA9_5410_606F = ____require_result_7["释放菲尼克斯尔熔岩吐息"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.08．凤凰漩涡")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_51E4_51F0_6F29_6DA1 = ____require_result_8["释放菲尼克斯尔凤凰漩涡"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.09．浴火重生准备")
local _____89E6_53D1_83F2_5C3C_514B_65AF_5C14P1_8F6C_573A = ____require_result_9["触发菲尼克斯尔P1转场"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.04．双形态转换")
local _____5207_6362_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001 = ____require_result_10["切换菲尼克斯尔第二形态"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.11．骸骨弹幕")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_9AB8_9AA8_5F39_5E55 = ____require_result_11["释放菲尼克斯尔骸骨弹幕"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.12．怨火链接")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_6028_706B_94FE_63A5 = ____require_result_12["释放菲尼克斯尔怨火链接"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.13．凤凰挽歌")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_51E4_51F0_633D_6B4C = ____require_result_13["释放菲尼克斯尔凤凰挽歌"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.14．元素爆发")
local _____7ED3_7B97_83F2_5C3C_514B_65AF_5C14_5143_7D20_7206_53D1 = ____require_result_14["结算菲尼克斯尔元素爆发"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.15．怨火核心暴露")
local _____89E6_53D1_83F2_5C3C_514B_65AF_5C14_6028_706B_6838_5FC3_66B4_9732 = ____require_result_15["触发菲尼克斯尔怨火核心暴露"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.16．永恒轮回")
local _____89E6_53D1_83F2_5C3C_514B_65AF_5C14_6C38_6052_8F6E_56DE = ____require_result_16["触发菲尼克斯尔永恒轮回"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.19．公共工具")
local _____5EF6_8FDF = ____require_result_17["延迟"]
local _____6DFB_52A0_5143_7D20_5C42_6570 = ____require_result_17["添加元素层数"]
local _____51CF_5C11_5143_7D20_5C42_6570 = ____require_result_17["减少元素层数"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.01．场地配置")
local _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E = ____require_result_18["菲尼克斯尔场地配置"]
local ____require_result_19 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04 = ____require_result_19["创建测试中心平移映射"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807 = ____require_result_19["按测试映射平移坐标"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62 = ____require_result_19["按测试映射平移矩形"]
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_19["标记测试Boss跳过死亡结算"]
local ____require_result_20 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_20["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_20["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_20["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_20["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_20["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_20["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_20["注册Boss测试命令组"]
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4DID = stringToFourCC("N00U")
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5BossX = -540.6
local _____4E34_65F6_6D4B_8BD5BossY = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6X = -540.6
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local _____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167 = {
    ["战斗矩形"] = {["左"] = -928, ["右"] = 2816, ["下"] = -11744, ["上"] = -7968},
    ["中心点"] = {x = 944, y = -9856},
    ["Boss初始点"] = {x = -244.6, y = -9805.3},
    ["永恒冰核点"] = {x = 944, y = -9856},
    ["导管点位"] = {{x = 44, y = -10756}, {x = 1844, y = -10756}, {x = 44, y = -8956}, {x = 1844, y = -8956}},
    ["怨火核心点"] = {x = 944, y = -9856},
    ["凤凰蛋点位"] = {{x = 44, y = -10756}, {x = 1844, y = -10756}, {x = 44, y = -8956}, {x = 1844, y = -8956}},
    ["挽歌安全区点位"] = {{x = 44, y = -10756, ["元素"] = "火"}, {x = 1844, y = -10756, ["元素"] = "冰"}, {x = 44, y = -8956, ["元素"] = "毒"}, {x = 1844, y = -8956, ["元素"] = "暗"}}
}
local CreateUnit = jass.CreateUnit
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local GetPlayerId = jass.GetPlayerId
local GetRandomInt = jass.GetRandomInt
local KillUnit = jass.KillUnit
local GetUnitState = jass.GetUnitState
local UnitDamageTarget = jass.UnitDamageTarget
local _____6700_8FD1_6D4B_8BD5Boss = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local function _____590D_5236_6620_5C04_83F2_5C3C_514B_65AF_5C14_70B9_4F4D_6570_7EC4(_____70B9_4F4D, _____6620_5C04)
    local result = {}
    do
        local i = 0
        while i < #_____70B9_4F4D do
            local mapped = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807(_____70B9_4F4D[i + 1], _____6620_5C04)
            if _____70B9_4F4D[i + 1]["元素"] ~= nil then
                result[#result + 1] = {x = mapped.x, y = mapped.y, ["元素"] = _____70B9_4F4D[i + 1]["元素"]}
            else
                result[#result + 1] = mapped
            end
            i = i + 1
        end
    end
    return result
end
local function _____5E94_7528_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_573A_5730()
    local _____6620_5C04 = _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["中心点"].x, _____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["中心点"].y, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["战斗矩形"] = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["战斗矩形"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["中心点"] = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["中心点"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["Boss初始点"] = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["Boss初始点"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["永恒冰核点"] = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["永恒冰核点"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["导管点位"] = _____590D_5236_6620_5C04_83F2_5C3C_514B_65AF_5C14_70B9_4F4D_6570_7EC4(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["导管点位"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["怨火核心点"] = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["怨火核心点"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["凤凰蛋点位"] = _____590D_5236_6620_5C04_83F2_5C3C_514B_65AF_5C14_70B9_4F4D_6570_7EC4(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["凤凰蛋点位"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["挽歌安全区点位"] = _____590D_5236_6620_5C04_83F2_5C3C_514B_65AF_5C14_70B9_4F4D_6570_7EC4(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["挽歌安全区点位"], _____6620_5C04)
end
local function _____590D_5236_83F2_5C3C_514B_65AF_5C14_6B63_5F0F_70B9_4F4D_6570_7EC4(_____70B9_4F4D)
    local result = {}
    do
        local i = 0
        while i < #_____70B9_4F4D do
            local item = _____70B9_4F4D[i + 1]
            if item["元素"] ~= nil then
                result[#result + 1] = {x = item.x, y = item.y, ["元素"] = item["元素"]}
            else
                result[#result + 1] = {x = item.x, y = item.y}
            end
            i = i + 1
        end
    end
    return result
end
local function _____6062_590D_83F2_5C3C_514B_65AF_5C14_6B63_5F0F_573A_5730()
    local snapshot = _____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["战斗矩形"] = {["左"] = snapshot["战斗矩形"]["左"], ["右"] = snapshot["战斗矩形"]["右"], ["下"] = snapshot["战斗矩形"]["下"], ["上"] = snapshot["战斗矩形"]["上"]}
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["中心点"] = {x = snapshot["中心点"].x, y = snapshot["中心点"].y}
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["Boss初始点"] = {x = snapshot["Boss初始点"].x, y = snapshot["Boss初始点"].y}
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["永恒冰核点"] = {x = snapshot["永恒冰核点"].x, y = snapshot["永恒冰核点"].y}
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["导管点位"] = _____590D_5236_83F2_5C3C_514B_65AF_5C14_6B63_5F0F_70B9_4F4D_6570_7EC4(snapshot["导管点位"])
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["怨火核心点"] = {x = snapshot["怨火核心点"].x, y = snapshot["怨火核心点"].y}
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["凤凰蛋点位"] = _____590D_5236_83F2_5C3C_514B_65AF_5C14_6B63_5F0F_70B9_4F4D_6570_7EC4(snapshot["凤凰蛋点位"])
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["挽歌安全区点位"] = _____590D_5236_83F2_5C3C_514B_65AF_5C14_6B63_5F0F_70B9_4F4D_6570_7EC4(snapshot["挽歌安全区点位"])
end
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local cached = _____6700_8FD1_6D4B_8BD5Boss[pid]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(cached) then
        SetUnitPosition(cached, _____4E34_65F6_6D4B_8BD5BossX, _____4E34_65F6_6D4B_8BD5BossY)
        SetUnitFacing(cached, 270)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(cached)
        globals.udg_Boss = cached
        return cached
    end
    local boss = CreateUnit(
        player,
        _____83F2_5C3C_514B_65AF_5C14_5355_4F4DID,
        _____4E34_65F6_6D4B_8BD5BossX,
        _____4E34_65F6_6D4B_8BD5BossY,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____6700_8FD1_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 40, false)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        globals.udg_Boss = boss
    end
    return boss
end
local function _____51C6_5907_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_573A_666F(player, hero, boss)
    local pid = GetPlayerId(player)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid], _____4E34_65F6_6D4B_8BD5_73A9_5BB6X - 260, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____4E34_65F6_6D4B_8BD5_73A9_5BB6X + 260, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
    return _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(boss)
end
local function _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_4E0A_4E0B_6587(context)
    _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_8FD0_884C_65F6()
    _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_6280_80FD_7ED3_6784()
    _____5E94_7528_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_573A_5730()
    _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6C38_6052_51B0_6838_4E0E_5BFC_7BA1(context)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(context.Boss)
end
local function _____521B_5EFA_5E76_521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) then
        return nil
    end
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    local context = _____51C6_5907_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_573A_666F(player, hero, boss)
    if context == nil then
        return nil
    end
    _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_4E0A_4E0B_6587(context)
    return context
end
local function _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    if context["当前形态"] == "第一形态" then
        _____5207_6362_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    end
end
local function _____6E05_7406_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5(player, _context)
    local pid = GetPlayerId(player)
    local boss = _____6700_8FD1_6D4B_8BD5Boss[pid]
    if boss ~= nil and boss ~= 0 then
        _____6E05_7406_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(boss)
    end
    _____6062_590D_83F2_5C3C_514B_65AF_5C14_6B63_5F0F_573A_5730()
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(boss)
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = nil
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____6700_8FD1_6D4B_8BD5Boss[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD1_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        _____91CA_653E_83F2_5C3C_514B_65AF_5C14_70BD_7FBD_6563_5C04(context, target)
    end
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD2_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        _____91CA_653E_83F2_5C3C_514B_65AF_5C14_7194_5CA9_5410_606F(context, target)
    end
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD3_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        _____91CA_653E_83F2_5C3C_514B_65AF_5C14_51E4_51F0_6F29_6DA1(context, target)
    end
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD4_6D4B_8BD5_547D_4EE4(_player, context)
    _____89E6_53D1_83F2_5C3C_514B_65AF_5C14P1_8F6C_573A(context)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD5_6D4B_8BD5_547D_4EE4(_player, context)
    _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    _____91CA_653E_83F2_5C3C_514B_65AF_5C14_9AB8_9AA8_5F39_5E55(context)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD6_6D4B_8BD5_547D_4EE4(_player, context)
    _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    _____91CA_653E_83F2_5C3C_514B_65AF_5C14_6028_706B_94FE_63A5(context)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD7_6D4B_8BD5_547D_4EE4(_player, context)
    _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    _____91CA_653E_83F2_5C3C_514B_65AF_5C14_51E4_51F0_633D_6B4C(context)
end
local function _____6E05_7A7A_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_5143_7D20_5C42_6570(target)
    _____51CF_5C11_5143_7D20_5C42_6570(target, "火", 999)
    _____51CF_5C11_5143_7D20_5C42_6570(target, "冰", 999)
    _____51CF_5C11_5143_7D20_5C42_6570(target, "毒", 999)
    _____51CF_5C11_5143_7D20_5C42_6570(target, "暗", 999)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD8_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    _____6E05_7A7A_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_5143_7D20_5C42_6570(target)
    local _____5143_7D20_5217_8868 = {"火", "冰", "毒", "暗"}
    local _____968F_673A_5143_7D20 = _____5143_7D20_5217_8868[GetRandomInt(0, #_____5143_7D20_5217_8868 - 1) + 1]
    _____6DFB_52A0_5143_7D20_5C42_6570(target, _____968F_673A_5143_7D20, 5, 30)
    _____7ED3_7B97_83F2_5C3C_514B_65AF_5C14_5143_7D20_7206_53D1(context)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD8_706B_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    _____6E05_7A7A_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_5143_7D20_5C42_6570(target)
    _____6DFB_52A0_5143_7D20_5C42_6570(target, "火", 5, 30)
    _____7ED3_7B97_83F2_5C3C_514B_65AF_5C14_5143_7D20_7206_53D1(context)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD9_6D4B_8BD5_547D_4EE4(_player, context)
    _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    _____89E6_53D1_83F2_5C3C_514B_65AF_5C14_6028_706B_6838_5FC3_66B4_9732(context)
end
local function _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_6280_80FD9_51FB_6740_6838_5FC3_56DE_8C03(context, source)
    return function()
        if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["怨火核心"]) then
            return
        end
        if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(source) then
            local _____5269_4F59_751F_547D = GetUnitState(context["怨火核心"], jass.UNIT_STATE_LIFE)
            UnitDamageTarget(
                source,
                context["怨火核心"],
                _____5269_4F59_751F_547D + 1,
                false,
                false,
                jass.ATTACK_TYPE_NORMAL,
                jass.DAMAGE_TYPE_MIND,
                jass.WEAPON_TYPE_WHOKNOWS
            )
        else
            KillUnit(context["怨火核心"])
        end
    end
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD9_51FB_6740_6D4B_8BD5_547D_4EE4(player, context)
    _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    _____89E6_53D1_83F2_5C3C_514B_65AF_5C14_6028_706B_6838_5FC3_66B4_9732(context)
    local source = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    _____5EF6_8FDF(
        1000,
        _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_6280_80FD9_51FB_6740_6838_5FC3_56DE_8C03(context, source)
    )
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD10_6D4B_8BD5_547D_4EE4(_player, context)
    _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    _____89E6_53D1_83F2_5C3C_514B_65AF_5C14_6C38_6052_8F6E_56DE(context)
end
local _____83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "炽羽散射", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "熔岩吐息", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "凤凰漩涡", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "P1转场", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD4_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["名称"] = "骸骨弹幕", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD5_6D4B_8BD5_547D_4EE4},
    {["序号"] = 6, ["名称"] = "怨火链接", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD6_6D4B_8BD5_547D_4EE4},
    {["序号"] = 7, ["名称"] = "凤凰挽歌", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD7_6D4B_8BD5_547D_4EE4},
    {["序号"] = 8, ["名称"] = "元素爆发(随机)", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD8_6D4B_8BD5_547D_4EE4},
    {["序号"] = 82, ["命令"] = "8-2", ["名称"] = "元素爆发(火)", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD8_706B_6D4B_8BD5_547D_4EE4},
    {["序号"] = 9, ["名称"] = "怨火核心暴露", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD9_6D4B_8BD5_547D_4EE4},
    {["序号"] = 91, ["命令"] = "9-1", ["名称"] = "怨火核心暴露(1秒后击杀)", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD9_51FB_6740_6D4B_8BD5_547D_4EE4},
    {["序号"] = 10, ["名称"] = "永恒轮回", ["执行"] = ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD10_6D4B_8BD5_547D_4EE4}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "菲尼克斯尔",
    ["Boss名称"] = "菲尼克斯尔",
    ["创建或获取上下文"] = _____521B_5EFA_5E76_521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5,
    ["清理上下文"] = _____6E05_7406_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5,
    ["技能命令列表"] = _____83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
