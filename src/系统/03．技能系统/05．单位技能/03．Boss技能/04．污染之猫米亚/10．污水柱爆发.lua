local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.01．场地配置")
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心X"]
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心Y"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.12．平台超载惩罚")
local _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387 = ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A["取米亚平台超载伤害倍率"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.index")
local _____5F00_59CB_539F_5730_51FB_98DE = ____index["开始原地击飞"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_1["取当前有效玩家人数"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域")
local _____521B_5EFA_6301_7EED_5371_9669_533A_57DF = ____require_result_3["创建持续危险区域"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
local _____521B_5EFA_8584_5706_5F62_63D0_793A_5708 = ____require_result_4["创建薄圆形提示圈"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local ____require_result_6 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_6.YDWETimerDestroyEffectSafe
local ____require_result_7 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_7["造成AOE技能伤害"]
local jass = require("jass.common")
local japi = require("jass.japi")
local AddSpecialEffect = jass.AddSpecialEffect
local GetRandomInt = jass.GetRandomInt
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local ConvertUnitState = jass.ConvertUnitState
local EXSetEffectSize = japi.EXSetEffectSize
local GetUnitStateJapi = japi.GetUnitState
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4D_653B_51FB_529B(unit)
    if not _____5355_4F4D_6709_6548(unit) or type(GetUnitStateJapi) ~= "function" then
        return 1000
    end
    local value = GetUnitStateJapi(
        unit,
        ConvertUnitState(21)
    )
    return value > 0 and value or 1000
end
local function _____8BA1_7B97_6C61_6C34_67F1_7206_53D1_4F24_5BB3(boss, target)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水柱爆发"]
    return (_____53D6_5355_4F4D_653B_51FB_529B(boss) * config["爆发伤害Boss攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["爆发伤害目标最大生命比例"]) * config["爆发伤害总倍率"]
end
local function _____8BA1_7B97_6C61_6C34_67F1_6C34_5751_4F24_5BB3(boss, target)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水柱爆发"]
    return (_____53D6_5355_4F4D_653B_51FB_529B(boss) * config["水坑每秒伤害Boss攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["水坑每秒伤害目标最大生命比例"]) * config["水坑每秒伤害总倍率"]
end
local function _____8DDD_79BB_5E73_65B9(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end
local function _____53D6_6C61_6C34_67F1_6570_91CF()
    local playerCount = _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570()
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水柱爆发"]
    return playerCount <= 2 and config["单双人数量"] or config["三四人数量"]
end
local function _____9009_62E9_6C61_6C34_67F1_843D_70B9(boss)
    local count = _____53D6_6C61_6C34_67F1_6570_91CF()
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local candidates = {}
    do
        local i = 0
        while i < #heroes do
            if _____5355_4F4D_6709_6548(heroes[i + 1]) then
                candidates[#candidates + 1] = heroes[i + 1]
            end
            i = i + 1
        end
    end
    local result = {}
    while #result < count and #candidates > 0 do
        local index = GetRandomInt(0, #candidates - 1)
        local hero = candidates[index + 1]
        __TS__ArraySplice(candidates, index, 1)
        result[#result + 1] = {
            x = GetUnitX(hero),
            y = GetUnitY(hero)
        }
    end
    while #result < count do
        result[#result + 1] = {
            x = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X(),
            y = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y()
        }
    end
    return result
end
local function _____64AD_653E_6C61_6C34_67F1_9884_8B66(point)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水柱爆发"]
    _____521B_5EFA_8584_5706_5F62_63D0_793A_5708(
        point.x,
        point.y,
        config["爆发半径"],
        config["预警秒"],
        1 / config["预警秒"]
    )
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["平台预警底圈"],
        X = point.x,
        Y = point.y,
        Z = 20,
        ["缩放"] = 0.9,
        ["红"] = 80,
        ["绿"] = 255,
        ["蓝"] = 80,
        ["透明度"] = 210,
        ["持续秒"] = config["预警秒"]
    })
end
local function _____64AD_653E_6C61_6C34_67F1_7206_53D1_8868_73B0(point)
    local effects = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水柱爆发"]["爆发特效"]
    do
        local i = 0
        while i < #effects do
            do
                local effect = AddSpecialEffect(effects[i + 1], point.x, point.y)
                if effect == nil or effect == 0 then
                    goto __continue18
                end
                if type(EXSetEffectSize) == "function" then
                    EXSetEffectSize(effect, 1)
                end
                YDWETimerDestroyEffectSafe(2, effect)
            end
            ::__continue18::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_6C61_6C34_67F1_6B8B_7559_6C34_5751(context, point)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水柱爆发"]
    _____521B_5EFA_6301_7EED_5371_9669_533A_57DF({
        X = point.x,
        Y = point.y,
        ["半径"] = config["水坑半径"],
        ["持续时间"] = config["水坑持续秒"],
        ["检测间隔"] = 1,
        ["影响目标"] = "敌方",
        ["所有者"] = context["Boss单位"],
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["腐化残留云"],
        ["特效高度"] = 0,
        ["显示提示圈"] = false,
        ["on周期"] = function(_____533A_57DF_5185_5355_4F4D)
            do
                local i = 0
                while i < #_____533A_57DF_5185_5355_4F4D do
                    do
                        local target = _____533A_57DF_5185_5355_4F4D[i + 1]
                        if not _____5355_4F4D_6709_6548(target) then
                            goto __continue24
                        end
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["来源"] = context["Boss单位"],
                            ["目标"] = target,
                            ["伤害"] = _____8BA1_7B97_6C61_6C34_67F1_6C34_5751_4F24_5BB3(context["Boss单位"], target) * _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387(target),
                            attackType = jass.ATTACK_TYPE_CHAOS,
                            ["伤害类型"] = jass.DAMAGE_TYPE_POISON,
                            weaponType = jass.WEAPON_TYPE_WHOKNOWS,
                            ["来源类型"] = "Boss技能"
                        })
                        _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, target, config["水坑每秒腐化层数"], "污水柱残留水坑")
                    end
                    ::__continue24::
                    i = i + 1
                end
            end
        end
    })
end
local function _____7ED3_7B97_6C61_6C34_67F1_7206_53D1(context, point)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["阶段"] ~= 2 then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水柱爆发"]
    local radius2 = config["爆发半径"] * config["爆发半径"]
    _____64AD_653E_6C61_6C34_67F1_7206_53D1_8868_73B0(point)
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "污水柱爆发", 2)
    local targets = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____5355_4F4D_6709_6548(target) then
                    goto __continue29
                end
                if _____8DDD_79BB_5E73_65B9(
                    point.x,
                    point.y,
                    GetUnitX(target),
                    GetUnitY(target)
                ) > radius2 then
                    goto __continue29
                end
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = target,
                    ["伤害"] = _____8BA1_7B97_6C61_6C34_67F1_7206_53D1_4F24_5BB3(boss, target) * _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387(target),
                    attackType = jass.ATTACK_TYPE_CHAOS,
                    ["伤害类型"] = jass.DAMAGE_TYPE_POISON,
                    weaponType = jass.WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
                _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, target, config["命中腐化层数"], "污水柱爆发")
                _____5F00_59CB_539F_5730_51FB_98DE(target, {
                    ["持续时间"] = config["原地击飞持续秒"],
                    ["最小高度"] = config["原地击飞最小高度"],
                    ["最大高度"] = config["原地击飞最大高度"],
                    ["冲击波模型"] = "",
                    ["持续特效模型"] = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl",
                    ["持续特效间隔"] = 0.12,
                    ["主单位"] = boss
                })
            end
            ::__continue29::
            i = i + 1
        end
    end
    _____521B_5EFA_6C61_6C34_67F1_6B8B_7559_6C34_5751(context, point)
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "污水柱爆发", 3)
end
____exports["注册米亚污水柱爆发"] = function()
end
____exports["尝试触发米亚污水柱爆发"] = function(context, nowMs)
    if context["阶段"] ~= 2 then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水柱爆发"]
    if context["上次污水柱爆发Ms"] > 0 and nowMs - context["上次污水柱爆发Ms"] < config["冷却Ms"] then
        return
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    context["上次污水柱爆发Ms"] = nowMs
    local points = _____9009_62E9_6C61_6C34_67F1_843D_70B9(boss)
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "污水柱爆发", 0)
    do
        local i = 0
        while i < #points do
            _____64AD_653E_6C61_6C34_67F1_9884_8B66(points[i + 1])
            i = i + 1
        end
    end
    addDelayedCallback(
        1500,
        function()
            if not _____5355_4F4D_6709_6548(context["Boss单位"]) or context["阶段"] ~= 2 then
                return
            end
            _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "污水柱爆发", 1)
        end
    )
    addDelayedCallback(
        config["预警秒"] * 1000,
        function()
            do
                local i = 0
                while i < #points do
                    _____7ED3_7B97_6C61_6C34_67F1_7206_53D1(context, points[i + 1])
                    i = i + 1
                end
            end
        end
    )
end
return ____exports
