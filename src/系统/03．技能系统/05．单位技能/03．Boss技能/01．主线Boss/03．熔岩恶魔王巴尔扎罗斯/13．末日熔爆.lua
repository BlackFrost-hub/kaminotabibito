--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．场地配置")
local _____5DF4_5C14_624E_7F57_65AF_56FA_5B9A_5B89_5168_533A_914D_7F6E_8868 = ____01_FF0E_573A_5730_914D_7F6E["巴尔扎罗斯固定安全区配置表"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯音效配置"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.16．灼热层数工具")
local _____51CF_5C11_5DF4_5C14_624E_7F57_65AF_707C_70ED_5C42_6570 = ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177["减少巴尔扎罗斯灼热层数"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____require_result_0["计算组合技能伤害"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.03．Boss战场地点位")
local _____521B_5EFABoss_6218_573A_5730_70B9_4F4D_96C6 = ____require_result_3["创建Boss战场地点位集"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.index")
local _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668 = ____require_result_4["创建血量节点触发器"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local ____require_result_7 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_7.addDelayedCallback
local addPeriodicCallback = ____require_result_7.addPeriodicCallback
local getServerTime = ____require_result_7.getServerTime
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local _____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____require_result_8["创建循环点特效"]
local ____require_result_9 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_9.CosBJ
local SinBJ = ____require_result_9.SinBJ
local ____require_result_10 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_10["造成AOE技能伤害"]
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_10["创建独立技能伤害实例"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local function _____53D6_573A_5730_4E2D_5FC3(context)
    local boss = context["Boss单位"]
    local fallbackX = GetUnitX(boss)
    local fallbackY = GetUnitY(boss)
    local points = _____521B_5EFABoss_6218_573A_5730_70B9_4F4D_96C6(context["战斗区域组"], fallbackX, fallbackY)
    local center = points["取中心"](points)
    if center.X == 0 and center.Y == 0 then
        return {X = fallbackX, Y = fallbackY}
    end
    return {X = center.X, Y = center.Y}
end
local function _____53D6_5B89_5168_70B9_5217_8868(context, center)
    local result = {}
    local safeAreas = context["测试固定安全区配置表"] or _____5DF4_5C14_624E_7F57_65AF_56FA_5B9A_5B89_5168_533A_914D_7F6E_8868
    do
        local i = 0
        while i < #safeAreas do
            local area = safeAreas[i + 1]
            result[#result + 1] = {
                X = (area["左"] + area["右"]) / 2,
                Y = (area["下"] + area["上"]) / 2,
                ["左"] = area["左"],
                ["右"] = area["右"],
                ["下"] = area["下"],
                ["上"] = area["上"]
            }
            i = i + 1
        end
    end
    if #result > 0 then
        return result
    end
    local saved = context["元素安全印记列表"]
    do
        local i = 0
        while i < #saved do
            result[#result + 1] = {X = saved[i + 1].X, Y = saved[i + 1].Y}
            i = i + 1
        end
    end
    if #result > 0 then
        return result
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    result[#result + 1] = {X = center.X - config["安全点回退距离"], Y = center.Y}
    result[#result + 1] = {X = center.X + config["安全点回退距离"], Y = center.Y}
    return result
end
local function _____521B_5EFA_5B89_5168_70B9_63D0_793A(point, _____6301_7EED_79D2)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    if point["左"] ~= nil and point["右"] ~= nil and point["下"] ~= nil and point["上"] ~= nil then
        local _____77E9_5F62_8DEF_5F84_8D77_70B9X = (point["左"] + point["右"]) / 2
        local _____77E9_5F62_8DEF_5F84_8D77_70B9Y = point["下"]
        _____521B_5EFA_6280_80FD_63D0_793A_5708({
            ["类型"] = "矩形",
            X = _____77E9_5F62_8DEF_5F84_8D77_70B9X,
            Y = _____77E9_5F62_8DEF_5F84_8D77_70B9Y,
            ["宽度"] = point["右"] - point["左"],
            ["长度"] = point["上"] - point["下"],
            ["朝向"] = 90,
            ["持续时间"] = _____6301_7EED_79D2,
            ["动画速度"] = 1
        })
        return
    end
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "白色安全圆",
        X = point.X,
        Y = point.Y,
        ["半径"] = config["安全区半径"],
        ["持续时间"] = _____6301_7EED_79D2,
        ["动画速度"] = 1
    })
end
local function _____521B_5EFA_5B89_5168_70B9_9AD8_4EAE(points)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    do
        local i = 0
        while i < #points do
            local point = points[i + 1]
            _____521B_5EFA_5B89_5168_70B9_63D0_793A(point, config["引导秒"])
            _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
                ["模型路径"] = config["安全点特效路径"],
                X = point.X,
                Y = point.Y,
                Z = config["安全点特效高度"],
                ["缩放"] = config["安全点特效缩放"],
                ["红"] = 170,
                ["绿"] = 220,
                ["蓝"] = 255,
                ["透明度"] = 230,
                ["重建间隔秒"] = 3,
                ["单次持续秒"] = 2.8,
                ["总持续秒"] = config["安全点临时高亮持续秒"]
            })
            i = i + 1
        end
    end
end
local function _____521B_5EFA_672B_65E5_7194_7206_5F15_5BFC_8868_73B0(context, center, safePoints)
    local boss = context["Boss单位"]
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = config["Boss蓄力特效路径"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        Z = config["Boss蓄力特效高度"],
        ["缩放"] = config["Boss蓄力特效缩放"],
        ["重建间隔秒"] = config["Boss蓄力特效Tick秒"],
        ["单次持续秒"] = config["Boss蓄力特效Tick秒"],
        ["总持续秒"] = config["引导秒"],
        ["存活条件"] = function()
            return context["末日熔爆引导中"] and _____5355_4F4D_6709_6548(boss)
        end
    })
    _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = config["场地中心法阵路径"],
        X = center.X,
        Y = center.Y,
        Z = config["场地中心法阵高度"],
        ["缩放"] = config["场地中心法阵缩放"],
        ["重建间隔秒"] = 3,
        ["单次持续秒"] = 2.8,
        ["总持续秒"] = config["引导秒"]
    })
    _____521B_5EFA_5B89_5168_70B9_9AD8_4EAE(safePoints)
    addDelayedCallback(
        config["中途提示秒"] * 1000,
        function()
            if not context["末日熔爆引导中"] or not _____5355_4F4D_6709_6548(boss) then
                return
            end
            _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(boss, "末日熔爆中途")
            do
                local i = 0
                while i < #safePoints do
                    _____521B_5EFA_5B89_5168_70B9_63D0_793A(safePoints[i + 1], config["引导秒"] - config["中途提示秒"])
                    i = i + 1
                end
            end
        end
    )
end
local function _____70B9_5728_5B89_5168_533A(unit, safePoints)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    local radius2 = config["安全区半径"] * config["安全区半径"]
    do
        local i = 0
        while i < #safePoints do
            do
                local point = safePoints[i + 1]
                if point["左"] ~= nil and point["右"] ~= nil and point["下"] ~= nil and point["上"] ~= nil then
                    if x >= point["左"] and x <= point["右"] and y >= point["下"] and y <= point["上"] then
                        return true
                    end
                    goto __continue24
                end
                local dx = x - safePoints[i + 1].X
                local dy = y - safePoints[i + 1].Y
                if dx * dx + dy * dy <= radius2 then
                    return true
                end
            end
            ::__continue24::
            i = i + 1
        end
    end
    return false
end
local function _____8BA1_7B97_5916_5708_4F24_5BB3(boss, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    return _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, target, {["来源攻击力比例"] = config["外圈伤害Boss攻击力比例"], ["目标最大生命比例"] = config["外圈伤害目标最大生命比例"], ["总倍率"] = config["外圈伤害总倍率"]})
end
local function _____8BA1_7B97_5B89_5168_533A_4F59_6CE2_4F24_5BB3(target)
    return GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE) * _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]["安全区余波目标最大生命比例"]
end
local function _____64AD_653E_7206_53D1_8868_73B0(center)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = config["爆发特效路径"],
        X = center.X,
        Y = center.Y,
        Z = config["爆发特效高度"],
        ["缩放"] = config["爆发特效缩放"],
        ["持续秒"] = config["爆发特效持续秒"]
    })
    local angles = config["场地屏幕特效角度"]
    do
        local i = 0
        while i < #angles do
            local angle = angles[i + 1]
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = config["场地特效路径"],
                X = center.X + CosBJ(angle) * config["场地屏幕特效距离"],
                Y = center.Y + SinBJ(angle) * config["场地屏幕特效距离"],
                Z = config["场地特效高度"],
                ["缩放"] = config["场地特效缩放"],
                ["持续秒"] = config["场地特效持续秒"]
            })
            i = i + 1
        end
    end
end
local function _____7ED3_7B97_672B_65E5_7194_7206(context, center, safePoints, _____6280_80FD_5B9E_4F8BID)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    _____64AD_653E_7206_53D1_8868_73B0(center)
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["末日熔爆"]["爆发结算"], center.X, center.Y, _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue36
                end
                if _____70B9_5728_5B89_5168_533A(hero, safePoints) then
                    _____9020_6210AOE_6280_80FD_4F24_5BB3({
                        ["来源"] = boss,
                        ["目标"] = hero,
                        ["伤害"] = _____8BA1_7B97_5B89_5168_533A_4F59_6CE2_4F24_5BB3(hero),
                        attack = false,
                        ranged = true,
                        attackType = ATTACK_TYPE_NORMAL,
                        ["伤害类型"] = DAMAGE_TYPE_FIRE,
                        weaponType = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "Boss技能",
                        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                        ["标签"] = "巴尔扎罗斯末日熔爆"
                    })
                    _____51CF_5C11_5DF4_5C14_624E_7F57_65AF_707C_70ED_5C42_6570(hero, config["安全区清除灼热层数"])
                else
                    _____9020_6210AOE_6280_80FD_4F24_5BB3({
                        ["来源"] = boss,
                        ["目标"] = hero,
                        ["伤害"] = _____8BA1_7B97_5916_5708_4F24_5BB3(boss, hero),
                        attack = false,
                        ranged = true,
                        attackType = ATTACK_TYPE_NORMAL,
                        ["伤害类型"] = DAMAGE_TYPE_FIRE,
                        weaponType = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "Boss技能",
                        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                        ["标签"] = "巴尔扎罗斯末日熔爆"
                    })
                end
            end
            ::__continue36::
            i = i + 1
        end
    end
    _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(boss, "末日熔爆爆发")
end
____exports["释放巴尔扎罗斯末日熔爆"] = function(context)
    local boss = context["Boss单位"]
    if context["末日熔爆引导中"] or not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    local center = _____53D6_573A_5730_4E2D_5FC3(context)
    local safePoints = _____53D6_5B89_5168_70B9_5217_8868(context, center)
    local _____6280_80FD_5B9E_4F8BID = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["来源类型"] = "Boss技能", ["标签"] = "巴尔扎罗斯末日熔爆", ["持续时间秒"] = config["引导秒"] + 2})
    context["末日熔爆引导中"] = true
    _____521B_5EFA_672B_65E5_7194_7206_5F15_5BFC_8868_73B0(context, center, safePoints)
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["末日熔爆"]["开始引导"], center.X, center.Y, _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标X"] = center.X,
        ["目标Y"] = center.Y,
        ["硬直秒"] = config["引导秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "致命惩罚",
            ["总时长"] = config["引导秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(boss, "末日熔爆")
        end,
        ["on生效"] = function()
            context["末日熔爆引导中"] = false
            _____7ED3_7B97_672B_65E5_7194_7206(context, center, safePoints, _____6280_80FD_5B9E_4F8BID)
        end
    })
end
local function _____8FDB_5165_7B2C_4E09_9636_6BB5(context)
    if context["阶段"] == 3 then
        return
    end
    context["阶段"] = 3
    local boss = context["Boss单位"]
    local delayMs = context["阶段3台词最早Ms"] - getServerTime()
    if delayMs <= 0 then
        _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(boss, "转阶段3", 0)
    else
        addDelayedCallback(
            delayMs,
            function()
                if _____5355_4F4D_6709_6548(boss) then
                    _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(boss, "转阶段3", 0)
                end
            end
        )
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    context["末日熔爆下一次允许Ms"] = getServerTime() + config["周期冷却秒"] * 1000
    registerManualBuff(
        context["Boss单位"],
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["熔岩暴走"],
        3600,
        1,
        {stack = 1, sourceName = "巴尔扎罗斯"}
    )
end
local function _____5C1D_8BD5_5468_671F_89E6_53D1_672B_65E5_7194_7206(context)
    if context["阶段"] ~= 3 or context["末日熔爆引导中"] then
        return
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local now = getServerTime()
    if context["末日熔爆下一次允许Ms"] <= 0 or now < context["末日熔爆下一次允许Ms"] then
        return
    end
    ____exports["释放巴尔扎罗斯末日熔爆"](context)
    context["末日熔爆下一次允许Ms"] = now + _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]["周期冷却秒"] * 1000
end
local function _____5C1D_8BD5_4F4E_8840_91CF_989D_5916_89E6_53D1(context)
    if context["已触发低血量末日熔爆"] or context["末日熔爆引导中"] then
        return
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return
    end
    local ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    if ratio > config["低血量额外触发生命比例"] then
        return
    end
    context["已触发低血量末日熔爆"] = true
    ____exports["释放巴尔扎罗斯末日熔爆"](context)
    context["末日熔爆下一次允许Ms"] = getServerTime() + config["低血量触发后冷却秒"] * 1000
end
____exports["初始化巴尔扎罗斯末日熔爆节点"] = function(context)
    if context["末日熔爆节点已初始化"] then
        return
    end
    context["末日熔爆节点已初始化"] = true
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["末日熔爆"]
    _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668({
        ["清理"] = context["清理"],
        ["名称"] = "巴尔扎罗斯-末日熔爆阶段节点",
        ["单位"] = context["Boss单位"],
        ["节点列表"] = {{
            ID = "末日熔爆-P3",
            ["百分比"] = config["第三阶段触发生命比例"],
            ["on触发"] = function()
                _____8FDB_5165_7B2C_4E09_9636_6BB5(context)
            end
        }}
    })
    local tickId = addPeriodicCallback(
        config["运行检查间隔毫秒"],
        function()
            _____5C1D_8BD5_4F4E_8840_91CF_989D_5916_89E6_53D1(context)
            _____5C1D_8BD5_5468_671F_89E6_53D1_672B_65E5_7194_7206(context)
        end
    )
    local ____self_11 = context["清理"]
    ____self_11["登记周期回调"](____self_11, "巴尔扎罗斯-末日熔爆周期", tickId)
end
____exports["注册巴尔扎罗斯末日熔爆"] = function()
end
return ____exports
