--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_516C_5171 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.00．公共")
local _____683C_9C81_59C6_516C_5171 = ____00_FF0E_516C_5171["格鲁姆公共"]
local ____683C_9C81_59C6_516C_5171_0 = _____683C_9C81_59C6_516C_5171
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____683C_9C81_59C6_516C_5171_0["巴尔扎罗斯技能数值配置"]
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____683C_9C81_59C6_516C_5171_0["播放巴尔扎罗斯台词"]
local _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED = ____683C_9C81_59C6_516C_5171_0["施加巴尔扎罗斯灼热"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____683C_9C81_59C6_516C_5171_0["读取单位攻击力"]
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____683C_9C81_59C6_516C_5171_0["启动基础施法时间线"]
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____683C_9C81_59C6_516C_5171_0["创建技能提示圈"]
local _____521B_5EFA_7EBF_6BB5_5371_9669_533A = ____683C_9C81_59C6_516C_5171_0["创建线段危险区"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____683C_9C81_59C6_516C_5171_0["获取Boss技能敌对英雄列表"]
local addPeriodicCallback = ____683C_9C81_59C6_516C_5171_0.addPeriodicCallback
local removePeriodicCallback = ____683C_9C81_59C6_516C_5171_0.removePeriodicCallback
local getServerTime = ____683C_9C81_59C6_516C_5171_0.getServerTime
local CosBJ = ____683C_9C81_59C6_516C_5171_0.CosBJ
local SinBJ = ____683C_9C81_59C6_516C_5171_0.SinBJ
local GetUnitX = ____683C_9C81_59C6_516C_5171_0.GetUnitX
local GetUnitY = ____683C_9C81_59C6_516C_5171_0.GetUnitY
local GetUnitState = ____683C_9C81_59C6_516C_5171_0.GetUnitState
local UnitDamageTarget = ____683C_9C81_59C6_516C_5171_0.UnitDamageTarget
local UNIT_STATE_MAX_LIFE = ____683C_9C81_59C6_516C_5171_0.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_CHAOS = ____683C_9C81_59C6_516C_5171_0.ATTACK_TYPE_CHAOS
local DAMAGE_TYPE_FIRE = ____683C_9C81_59C6_516C_5171_0.DAMAGE_TYPE_FIRE
local WEAPON_TYPE_WHOKNOWS = ____683C_9C81_59C6_516C_5171_0.WEAPON_TYPE_WHOKNOWS
local _____5355_4F4D_6709_6548 = ____683C_9C81_59C6_516C_5171_0["单位有效"]
local _____53D6_5355_4F4DID = ____683C_9C81_59C6_516C_5171_0["取单位ID"]
local _____53D6_65B9_5411_89D2 = ____683C_9C81_59C6_516C_5171_0["取方向角"]
local _____8BA1_7B97_706B_5F84_6301_7EED_4F24_5BB3 = ____683C_9C81_59C6_516C_5171_0["计算火径持续伤害"]
local _____8BA1_7B97_706B_5F84_7A7F_8D8A_4F24_5BB3 = ____683C_9C81_59C6_516C_5171_0["计算火径穿越伤害"]
local _____64AD_653E_70B9_7279_6548 = ____683C_9C81_59C6_516C_5171_0["播放点特效"]
local function _____53D6_706B_5F84_53C2_6570(grum, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    local normalAngle = _____53D6_65B9_5411_89D2(grum, target)
    return {
        center = {
            x = GetUnitX(grum) + CosBJ(normalAngle) * config["火线中心前移"],
            y = GetUnitY(grum) + SinBJ(normalAngle) * config["火线中心前移"]
        },
        lineAngle = normalAngle + 90,
        normalAngle = normalAngle
    }
end
local function _____521B_5EFA_706B_5F84_7A7F_8D8A_68C0_6D4B(context, grum, center, lineAngle, normalAngle)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    local sideMap = {}
    local nextAllowed = {}
    local lineX = CosBJ(lineAngle)
    local lineY = SinBJ(lineAngle)
    local normalX = CosBJ(normalAngle)
    local normalY = SinBJ(normalAngle)
    local halfLength = config["长度"] * 0.5
    local endMs = getServerTime() + config["持续秒"] * 1000
    local tickId
    tickId = addPeriodicCallback(
        config["Tick间隔毫秒"],
        function()
            local now = getServerTime()
            if now >= endMs or not _____5355_4F4D_6709_6548(grum) then
                removePeriodicCallback(tickId)
                return
            end
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
            do
                local i = 0
                while i < #heroes do
                    do
                        local hero = heroes[i + 1]
                        if not _____5355_4F4D_6709_6548(hero) then
                            goto __continue7
                        end
                        local dx = GetUnitX(hero) - center.x
                        local dy = GetUnitY(hero) - center.y
                        local along = dx * lineX + dy * lineY
                        if along < -halfLength or along > halfLength then
                            goto __continue7
                        end
                        local sideValue = dx * normalX + dy * normalY
                        local side = sideValue >= 0 and 1 or -1
                        local id = _____53D6_5355_4F4DID(hero)
                        local oldSide = sideMap[id]
                        sideMap[id] = side
                        if oldSide == nil or oldSide == side then
                            goto __continue7
                        end
                        if now < (nextAllowed[id] or 0) then
                            goto __continue7
                        end
                        nextAllowed[id] = now + config["穿越防抖秒"] * 1000
                        UnitDamageTarget(
                            grum,
                            hero,
                            _____8BA1_7B97_706B_5F84_7A7F_8D8A_4F24_5BB3(grum, hero),
                            false,
                            true,
                            ATTACK_TYPE_CHAOS,
                            DAMAGE_TYPE_FIRE,
                            WEAPON_TYPE_WHOKNOWS
                        )
                        _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED(hero, config["灼热层数"])
                    end
                    ::__continue7::
                    i = i + 1
                end
            end
        end
    )
    local ____self_1 = context["清理"]
    ____self_1["登记周期回调"](____self_1, "格鲁姆-熔岩火径穿越检测", tickId)
end
local function _____521B_5EFA_706B_5F84(context, center, lineAngle, normalAngle)
    local grum = context["格鲁姆"]
    if not _____5355_4F4D_6709_6548(grum) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    local effect = _____64AD_653E_70B9_7279_6548(
        config["火线模型路径"],
        center.x,
        center.y,
        config["火线特效高度"],
        config["火线特效缩放"],
        config["持续秒"],
        lineAngle
    )
    local ____self_2 = context["清理"]
    ____self_2["登记特效"](____self_2, "格鲁姆-熔岩火径主特效", effect)
    _____521B_5EFA_7EBF_6BB5_5371_9669_533A({
        ["清理"] = context["清理"],
        ["名称"] = "格鲁姆-熔岩火径",
        ["起点X"] = center.x - CosBJ(lineAngle) * config["长度"] * 0.5,
        ["起点Y"] = center.y - SinBJ(lineAngle) * config["长度"] * 0.5,
        ["方向角"] = lineAngle,
        ["长度"] = config["长度"],
        ["宽度"] = config["宽度"],
        ["持续秒"] = config["持续秒"],
        ["Tick间隔毫秒"] = config["Tick间隔毫秒"],
        ["周期秒"] = config["周期秒"],
        ["单位列表"] = function()
            return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
        end,
        ["提示圈"] = false,
        ["on周期"] = function(unit)
            if not _____5355_4F4D_6709_6548(grum) or not _____5355_4F4D_6709_6548(unit) then
                return
            end
            UnitDamageTarget(
                grum,
                unit,
                _____8BA1_7B97_706B_5F84_6301_7EED_4F24_5BB3(grum),
                false,
                true,
                ATTACK_TYPE_CHAOS,
                DAMAGE_TYPE_FIRE,
                WEAPON_TYPE_WHOKNOWS
            )
            _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED(unit, config["灼热层数"])
        end
    })
    _____521B_5EFA_706B_5F84_7A7F_8D8A_68C0_6D4B(
        context,
        grum,
        center,
        lineAngle,
        normalAngle
    )
end
____exports["释放格鲁姆火径"] = function(context, target)
    local grum = context["格鲁姆"]
    if not _____5355_4F4D_6709_6548(grum) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    local fire = _____53D6_706B_5F84_53C2_6570(grum, target)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = fire.center.x,
        Y = fire.center.y,
        ["宽度"] = config["宽度"],
        ["长度"] = config["长度"],
        ["朝向"] = fire.lineAngle,
        ["持续时间"] = config["施法硬直秒"]
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = grum,
        ["目标X"] = fire.center.x,
        ["目标Y"] = fire.center.y,
        ["硬直秒"] = config["施法硬直秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["施法硬直秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(context["Boss单位"], "熔岩火径")
        end,
        ["on生效"] = function()
            _____521B_5EFA_706B_5F84(context, fire.center, fire.lineAngle, fire.normalAngle)
        end
    })
end
return ____exports
