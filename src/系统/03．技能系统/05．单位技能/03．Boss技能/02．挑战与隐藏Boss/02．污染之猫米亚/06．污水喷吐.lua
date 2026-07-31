--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BFB_53D6_7C73_4E9A_5355_4F4D_5750_6807, _____70B9_5728_524D_65B9_6247_5F62_5185, _____8BA9_5355_4F4D_9762_5411_76EE_6807, _____6267_884C_7C73_4E9A_6C61_6C34_55B7_5410_4F24_5BB3Tick, _____64AD_653E_7C73_4E9A_6C61_6C34_55B7_5410_8868_73B0Tick, _____64AD_653E_55B7_5410_8868_73B0, _____521B_5EFA_6C61_6C34_55B7_5410_6B8B_7559_533A, _____7ED3_7B97_7C73_4E9A_6C61_6C34_55B7_5410, ____on_7C73_4E9A_6C61_6C34_55B7_5410_751F_6548, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868Ex, _____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807, _____521B_5EFA_70B9_7279_6548, _____521B_5EFA_6301_7EED_5371_9669_533A_57DF, _____521B_5EFA_6280_80FD_63D0_793A_5708, addDelayedCallback, addPeriodicCallback, removePeriodicCallback, ceil, CosBJ, SinBJ, jass, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitFacing, SetUnitFacing, SetUnitAnimationByIndex, SetUnitTimeScale, Atan2, BJ_RADTODEG, _____7C73_4E9A_5355_4F4D_7C7B_578BID, _____6C61_6C34_55B7_5410_6280_80FDID
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建米亚上下文"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local _____7C73_4E9A_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚音效配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____19_FF0E_65BD_6CD5_63D0_793A = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.19．施法提示")
local _____5F00_59CB_7C73_4E9A_5E38_89C4_65BD_6CD5 = ____19_FF0E_65BD_6CD5_63D0_793A["开始米亚常规施法"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["延迟播放Boss坐标音效"]
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____08_FF0E_6C61_67D3_6807_8BB0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.08．污染标记")
local _____53D6_7C73_4E9A_6C61_67D3_6807_8BB0_4F24_5BB3_500D_7387 = ____08_FF0E_6C61_67D3_6807_8BB0["取米亚污染标记伤害倍率"]
local ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.12．平台超载惩罚")
local _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387 = ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A["取米亚平台超载伤害倍率"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss技能伤害"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____8BFB_53D6_7C73_4E9A_5355_4F4D_5750_6807(unit)
    if unit == nil or unit == 0 then
        return nil
    end
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    if x == nil or y == nil then
        return nil
    end
    return {x = x, y = y}
end
function _____70B9_5728_524D_65B9_6247_5F62_5185(_____4E2D_5FC3X, _____4E2D_5FC3Y, target, range, halfAngle, facing)
    if target == nil or target == 0 or not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local ____target_5750_6807 = _____8BFB_53D6_7C73_4E9A_5355_4F4D_5750_6807(target)
    if ____target_5750_6807 == nil then
        return false
    end
    local dx = ____target_5750_6807.x - _____4E2D_5FC3X
    local dy = ____target_5750_6807.y - _____4E2D_5FC3Y
    local distance2 = dx * dx + dy * dy
    if distance2 > range * range then
        return false
    end
    local _____5B89_5168_671D_5411 = facing == nil and 0 or facing
    local forwardX = CosBJ(_____5B89_5168_671D_5411)
    local forwardY = SinBJ(_____5B89_5168_671D_5411)
    if forwardX == nil or forwardY == nil then
        return false
    end
    local dot = dx * forwardX + dy * forwardY
    if dot <= 0 then
        return false
    end
    local cosLimit = CosBJ(halfAngle)
    if cosLimit == nil then
        return false
    end
    return dot * dot >= distance2 * cosLimit * cosLimit
end
function _____8BA9_5355_4F4D_9762_5411_76EE_6807(caster, target, ____caster_5750_6807)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local _____6765_6E90_5750_6807 = ____caster_5750_6807 ~= nil and ____caster_5750_6807 or _____8BFB_53D6_7C73_4E9A_5355_4F4D_5750_6807(caster)
    local _____76EE_6807_5750_6807 = _____8BFB_53D6_7C73_4E9A_5355_4F4D_5750_6807(target)
    if _____6765_6E90_5750_6807 == nil or _____76EE_6807_5750_6807 == nil then
        return
    end
    local angle = Atan2(_____76EE_6807_5750_6807.y - _____6765_6E90_5750_6807.y, _____76EE_6807_5750_6807.x - _____6765_6E90_5750_6807.x) * BJ_RADTODEG
    if angle == nil then
        return
    end
    SetUnitFacing(caster, angle)
end
function _____6267_884C_7C73_4E9A_6C61_6C34_55B7_5410_4F24_5BB3Tick(data)
    local context = data.context
    local boss = data.boss
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水喷吐"]
    local targets = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868Ex(boss)
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____5355_4F4D_6709_6548(target) or not _____70B9_5728_524D_65B9_6247_5F62_5185(
                    data["中心X"],
                    data["中心Y"],
                    target,
                    config["喷吐距离"],
                    config["喷吐半角"],
                    data["朝向"]
                ) then
                    goto __continue18
                end
                _____6267_884CBoss_6280_80FD_4F24_5BB3({
                    ["技能ID"] = _____6C61_6C34_55B7_5410_6280_80FDID,
                    ["来源"] = boss,
                    ["目标"] = target,
                    ["伤害公式"] = {
                        ["来源攻击力比例"] = config["直接伤害Boss攻击力比例"],
                        ["目标最大生命比例"] = config["直接伤害目标最大生命比例"],
                        ["总倍率"] = config["直接伤害总倍率"] * data["每Tick伤害倍率"] * _____53D6_7C73_4E9A_6C61_67D3_6807_8BB0_4F24_5BB3_500D_7387(context, target) * _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387(target)
                    },
                    attackType = jass.ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = jass.DAMAGE_TYPE_POISON,
                    weaponType = jass.WEAPON_TYPE_WHOKNOWS,
                    ["伤害形态"] = "AOE",
                    ["标签"] = "米亚污水喷吐Tick"
                })
                if data["当前Tick数"] == 1 then
                    _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, target, config["直接腐化层数"], "污水喷吐")
                end
            end
            ::__continue18::
            i = i + 1
        end
    end
end
function _____64AD_653E_7C73_4E9A_6C61_6C34_55B7_5410_8868_73B0Tick(variable)
    local data = variable
    if data == nil then
        return
    end
    if data["剩余Tick数"] <= 0 then
        if data["周期ID"] > 0 then
            removePeriodicCallback(data["周期ID"])
            data["周期ID"] = 0
        end
        return
    end
    local context = data.context
    local boss = data.boss
    local ____temp_8 = context == nil or context["清理"] == nil
    if not ____temp_8 then
        local ____self_7 = context["清理"]
        ____temp_8 = ____self_7["已清理"](____self_7)
    end
    if ____temp_8 or not _____5355_4F4D_6709_6548(boss) then
        if data["周期ID"] > 0 then
            removePeriodicCallback(data["周期ID"])
            data["周期ID"] = 0
        end
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水喷吐"]
    local _____5B89_5168_671D_5411 = data["朝向"] == nil and 0 or data["朝向"]
    local forwardX = CosBJ(_____5B89_5168_671D_5411)
    local forwardY = SinBJ(_____5B89_5168_671D_5411)
    if data["中心X"] == nil or data["中心Y"] == nil or forwardX == nil or forwardY == nil then
        if data["周期ID"] > 0 then
            removePeriodicCallback(data["周期ID"])
            data["周期ID"] = 0
        end
        return
    end
    local x = data["中心X"] + forwardX * config["喷吐特效前移距离"]
    local y = data["中心Y"] + forwardY * config["喷吐特效前移距离"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = config["喷吐特效路径"],
        X = x,
        Y = y,
        ["Z轴角度"] = _____5B89_5168_671D_5411,
        ["缩放"] = config["喷吐特效缩放"],
        ["持续秒"] = config["喷吐特效单次生命周期秒"],
        ["红"] = config["喷吐特效红"],
        ["绿"] = config["喷吐特效绿"],
        ["蓝"] = config["喷吐特效蓝"],
        ["透明度"] = config["喷吐特效透明度"]
    })
    _____6267_884C_7C73_4E9A_6C61_6C34_55B7_5410_4F24_5BB3Tick(data)
    data["当前Tick数"] = data["当前Tick数"] + 1
    data["剩余Tick数"] = data["剩余Tick数"] - 1
    if data["剩余Tick数"] <= 0 and data["周期ID"] > 0 then
        removePeriodicCallback(data["周期ID"])
        data["周期ID"] = 0
    end
end
function _____64AD_653E_55B7_5410_8868_73B0(context, boss, _____4E2D_5FC3X, _____4E2D_5FC3Y, facing)
    local ____temp_10 = context == nil or context["清理"] == nil
    if not ____temp_10 then
        local ____self_9 = context["清理"]
        ____temp_10 = ____self_9["已清理"](____self_9)
    end
    if ____temp_10 or boss == nil or boss == 0 or not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水喷吐"]
    local ____tick_79D2 = config["喷吐特效Tick秒"]
    local _____603BTick_6570 = ____tick_79D2 > 0 and ceil(config["喷吐特效持续秒"] / ____tick_79D2) or 0
    if _____603BTick_6570 <= 0 then
        return
    end
    local data = {
        context = context,
        boss = boss,
        ["中心X"] = _____4E2D_5FC3X,
        ["中心Y"] = _____4E2D_5FC3Y,
        ["朝向"] = facing,
        ["当前Tick数"] = 1,
        ["每Tick伤害倍率"] = 1 / _____603BTick_6570,
        ["剩余Tick数"] = _____603BTick_6570,
        ["周期ID"] = 0
    }
    _____64AD_653E_7C73_4E9A_6C61_6C34_55B7_5410_8868_73B0Tick(data)
    if data["剩余Tick数"] <= 0 then
        return
    end
    data["周期ID"] = addPeriodicCallback(____tick_79D2 * 1000, _____64AD_653E_7C73_4E9A_6C61_6C34_55B7_5410_8868_73B0Tick, data)
    local ____self_11 = context["清理"]
    ____self_11["登记周期回调"](____self_11, "米亚-污水喷吐表现Tick", data["周期ID"])
end
function _____521B_5EFA_6C61_6C34_55B7_5410_6B8B_7559_533A(context, _____4E2D_5FC3X, _____4E2D_5FC3Y, facing)
    local ____temp_13 = context == nil or context["清理"] == nil
    if not ____temp_13 then
        local ____self_12 = context["清理"]
        ____temp_13 = ____self_12["已清理"](____self_12)
    end
    if ____temp_13 then
        return
    end
    local boss = context["Boss单位"]
    if boss == nil or boss == 0 or not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水喷吐"]
    local _____5B89_5168_671D_5411 = facing == nil and 0 or facing
    local forwardX = CosBJ(_____5B89_5168_671D_5411)
    local forwardY = SinBJ(_____5B89_5168_671D_5411)
    if _____4E2D_5FC3X == nil or _____4E2D_5FC3Y == nil or forwardX == nil or forwardY == nil then
        return
    end
    local x = _____4E2D_5FC3X + forwardX * (config["喷吐距离"] * 0.55)
    local y = _____4E2D_5FC3Y + forwardY * (config["喷吐距离"] * 0.55)
    _____521B_5EFA_6301_7EED_5371_9669_533A_57DF({
        X = x,
        Y = y,
        ["半径"] = config["残留半径"],
        ["持续时间"] = config["残留持续秒"],
        ["检测间隔"] = 1,
        ["影响目标"] = "敌方",
        ["所有者"] = boss,
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["腐化残留云"],
        ["特效高度"] = 0,
        ["提示圈"] = {["类型"] = "敌方圆形"},
        ["on周期"] = function(_____533A_57DF_5185_5355_4F4D)
            local ____temp_15 = context == nil or context["清理"] == nil
            if not ____temp_15 then
                local ____self_14 = context["清理"]
                ____temp_15 = ____self_14["已清理"](____self_14)
            end
            if ____temp_15 then
                return
            end
            do
                local i = 0
                while i < #_____533A_57DF_5185_5355_4F4D do
                    _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, _____533A_57DF_5185_5355_4F4D[i + 1], config["残留每秒腐化层数"], "污水喷吐残留")
                    i = i + 1
                end
            end
        end
    })
end
function _____7ED3_7B97_7C73_4E9A_6C61_6C34_55B7_5410(variable)
    local data = variable
    if data == nil then
        return
    end
    local context = data.context
    local ____temp_17 = context == nil or context["清理"] == nil
    if not ____temp_17 then
        local ____self_16 = context["清理"]
        ____temp_17 = ____self_16["已清理"](____self_16)
    end
    if ____temp_17 then
        return
    end
    local boss = context["Boss单位"]
    local ____boss_6709_6548 = boss ~= nil and boss ~= 0 and _____5355_4F4D_6709_6548(boss)
    if not ____boss_6709_6548 then
        return
    end
    local _____4E2D_5FC3X = data["中心X"]
    local _____4E2D_5FC3Y = data["中心Y"]
    if _____4E2D_5FC3X == nil or _____4E2D_5FC3Y == nil then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水喷吐"]
    local _____5B89_5168_671D_5411 = data["朝向"] == nil and GetUnitFacing(boss) or data["朝向"]
    local _____6700_7EC8_671D_5411 = _____5B89_5168_671D_5411 == nil and 0 or _____5B89_5168_671D_5411
    SetUnitFacing(boss, _____6700_7EC8_671D_5411)
    _____64AD_653E_55B7_5410_8868_73B0(
        context,
        boss,
        _____4E2D_5FC3X,
        _____4E2D_5FC3Y,
        _____6700_7EC8_671D_5411
    )
    _____521B_5EFA_6C61_6C34_55B7_5410_6B8B_7559_533A(context, _____4E2D_5FC3X, _____4E2D_5FC3Y, _____6700_7EC8_671D_5411)
end
____exports["释放米亚污水喷吐"] = function(context)
    local ____temp_19 = context == nil or context["清理"] == nil
    if not ____temp_19 then
        local ____self_18 = context["清理"]
        ____temp_19 = ____self_18["已清理"](____self_18)
    end
    if ____temp_19 then
        return
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水喷吐"]
    local ____opt_20 = _____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807(boss)
    local threatTarget = ____opt_20 and ____opt_20.targetRef
    local ____boss_5750_6807 = _____8BFB_53D6_7C73_4E9A_5355_4F4D_5750_6807(boss)
    if ____boss_5750_6807 == nil then
        return
    end
    if _____5355_4F4D_6709_6548(threatTarget) then
        _____8BA9_5355_4F4D_9762_5411_76EE_6807(boss, threatTarget, ____boss_5750_6807)
    end
    local _____5F53_524D_671D_5411 = GetUnitFacing(boss)
    local facing = _____5F53_524D_671D_5411 == nil and 0 or _____5F53_524D_671D_5411
    SetUnitFacing(boss, facing)
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "污水喷吐")
    _____64AD_653EBoss_5750_6807_97F3_6548(_____7C73_4E9A_97F3_6548_914D_7F6E["污水喷吐"]["前摇蓄力"], ____boss_5750_6807.x, ____boss_5750_6807.y, _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"])
    _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548(
        _____7C73_4E9A_97F3_6548_914D_7F6E["污水喷吐"]["持续喷射"],
        ____boss_5750_6807.x,
        ____boss_5750_6807.y,
        _____7C73_4E9A_97F3_6548_914D_7F6E["污水喷吐"]["持续喷射延迟Ms"],
        _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5F00_59CB_7C73_4E9A_5E38_89C4_65BD_6CD5(
        boss,
        config["总硬直秒"],
        "污水喷吐",
        ((((("1秒后向正面喷吐" .. tostring(config["喷吐特效持续秒"])) .. "秒，范围") .. tostring(config["喷吐距离"])) .. "码、") .. tostring(config["喷吐半角"] * 2)) .. "°扇形（离开米亚正面）",
        config["总硬直秒"]
    )
    SetUnitTimeScale(boss, config["动画速度"])
    SetUnitAnimationByIndex(boss, config["动画编号"])
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "红色扇形",
        X = ____boss_5750_6807.x,
        Y = ____boss_5750_6807.y,
        ["半径"] = config["喷吐距离"],
        ["扇形角度"] = config["喷吐半角"] * 2,
        ["朝向"] = facing,
        ["持续时间"] = config["前摇秒"],
        ["来源单位"] = boss
    })
    local delayedId = addDelayedCallback(config["前摇秒"] * 1000, _____7ED3_7B97_7C73_4E9A_6C61_6C34_55B7_5410, {context = context, ["朝向"] = facing, ["中心X"] = ____boss_5750_6807.x, ["中心Y"] = ____boss_5750_6807.y})
    local ____self_22 = context["清理"]
    ____self_22["登记延迟回调"](____self_22, "米亚-污水喷吐结算", delayedId)
end
function ____on_7C73_4E9A_6C61_6C34_55B7_5410_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6C61_6C34_55B7_5410_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____7C73_4E9A_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放米亚污水喷吐"](context)
end
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868Ex = ____require_result_0["获取Boss技能敌对英雄列表Ex"]
_____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807 = ____require_result_0["获取Boss技能应攻击目标"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域")
_____521B_5EFA_6301_7EED_5371_9669_533A_57DF = ____require_result_2["创建持续危险区域"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_4.addDelayedCallback
addPeriodicCallback = ____require_result_4.addPeriodicCallback
removePeriodicCallback = ____require_result_4.removePeriodicCallback
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.07．数学运算")
ceil = ____require_result_5.ceil
local ____require_result_6 = require("lib.扩展函数.BJ函数.12．数学函数")
CosBJ = ____require_result_6.CosBJ
SinBJ = ____require_result_6.SinBJ
jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFacing = jass.GetUnitFacing
SetUnitFacing = jass.SetUnitFacing
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitTimeScale = jass.SetUnitTimeScale
Atan2 = jass.Atan2
BJ_RADTODEG = 57.29577951308232
_____7C73_4E9A_5355_4F4D_7C7B_578BID = stringToFourCC(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["Boss单位ID"])
_____6C61_6C34_55B7_5410_6280_80FDID = stringToFourCC(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["污水喷吐技能"])
local _____7C73_4E9A_6C61_6C34_55B7_5410_5DF2_6CE8_518C = false
____exports["注册米亚污水喷吐"] = function()
    if _____7C73_4E9A_6C61_6C34_55B7_5410_5DF2_6CE8_518C then
        return
    end
    _____7C73_4E9A_6C61_6C34_55B7_5410_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "米亚-污水喷吐",
        ["单位类型ID"] = _____7C73_4E9A_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6C61_6C34_55B7_5410_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_7C73_4E9A_6C61_6C34_55B7_5410_751F_6548(boss, _____6C61_6C34_55B7_5410_6280_80FDID)
        end
    })
end
return ____exports
