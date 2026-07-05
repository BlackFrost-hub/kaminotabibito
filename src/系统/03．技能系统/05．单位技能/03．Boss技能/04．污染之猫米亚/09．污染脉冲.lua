--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.01．场地配置")
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心X"]
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心Y"]
local _____53D6_7C73_4E9A_5355_4F4D_6240_5728_5B89_5168_57DF = ____01_FF0E_573A_5730_914D_7F6E["取米亚单位所在安全域"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.12．平台超载惩罚")
local _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387 = ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A["取米亚平台超载伤害倍率"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761 = ____require_result_2["显示场地常驻AOE吟唱条"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_4["造成AOE技能伤害"]
local jass = require("jass.common")
local japi = require("jass.japi")
local AddSpecialEffect = jass.AddSpecialEffect
local GetUnitState = jass.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local EXSetEffectSize = japi.EXSetEffectSize
local EXSetEffectZ = japi.EXSetEffectZ
local EXEffectMatRotateZ = japi.EXEffectMatRotateZ
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____8DDD_79BB_5E73_65B9(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end
local function _____5355_4F4D_5728_6709_6548_5B89_5168_57DF_5185(context, unit)
    local _____533A_57DF = _____53D6_7C73_4E9A_5355_4F4D_6240_5728_5B89_5168_57DF(unit, context["安全域区域组"])
    if _____533A_57DF == nil then
        return false
    end
    local id = _____533A_57DF["配置"].ID or _____533A_57DF["配置"]["名称"] or ""
    if id ~= "" and context["腐化转移污染平台ID"] == id then
        return false
    end
    if id ~= "" and context["超载平台ID表"][id] == true then
        return false
    end
    return true
end
local function _____521B_5EFA_671D_5411_70B9_7279_6548(model, x, y, scale, duration, yawDeg, z)
    local effect = AddSpecialEffect(model, x, y)
    if effect == nil or effect == 0 then
        return
    end
    if type(EXSetEffectSize) == "function" then
        EXSetEffectSize(effect, scale)
    end
    if z ~= nil and z ~= 0 and type(EXSetEffectZ) == "function" then
        EXSetEffectZ(effect, z)
    end
    if type(EXEffectMatRotateZ) == "function" then
        EXEffectMatRotateZ(effect, yawDeg)
    end
    YDWETimerDestroyEffectSafe(duration, effect)
end
local function _____64AD_653E_8109_51B2_4E2D_5FC3_9884_8B66()
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    _____521B_5EFA_671D_5411_70B9_7279_6548(
        config["中心预警特效"],
        _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X(),
        _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y(),
        1.4,
        config["预警秒"] + 0.2,
        0,
        30
    )
end
local function _____64AD_653E_8109_51B2_6CE2_8868_73B0(waveIndex)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    local centerX = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X()
    local centerY = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y()
    local waveNo = waveIndex + 1
    local angles = {0, 90, 180, 270}
    do
        local i = 0
        while i < #angles do
            _____521B_5EFA_671D_5411_70B9_7279_6548(
                config["脉冲中心特效"],
                centerX,
                centerY,
                1,
                1.2,
                angles[i + 1],
                0
            )
            i = i + 1
        end
    end
    _____521B_5EFA_671D_5411_70B9_7279_6548(
        config["扩散波特效"],
        centerX,
        centerY,
        1.5 * waveNo,
        2,
        270,
        0
    )
end
local function _____7ED3_7B97_6C61_67D3_8109_51B2_6CE2(context, waveIndex)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["阶段"] ~= 2 then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    local radius = config["波次半径"][waveIndex + 1]
    local radius2 = radius * radius
    local centerX = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X()
    local centerY = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y()
    _____64AD_653E_8109_51B2_6CE2_8868_73B0(waveIndex)
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "污染脉冲", waveIndex + 2)
    local targets = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____5355_4F4D_6709_6548(target) then
                    goto __continue20
                end
                if _____5355_4F4D_5728_6709_6548_5B89_5168_57DF_5185(context, target) then
                    goto __continue20
                end
                if _____8DDD_79BB_5E73_65B9(
                    centerX,
                    centerY,
                    GetUnitX(target),
                    GetUnitY(target)
                ) > radius2 then
                    goto __continue20
                end
                local maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = target,
                    ["伤害"] = maxLife * config["每波最大生命伤害比例"] * _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387(target),
                    attackType = jass.ATTACK_TYPE_CHAOS,
                    ["伤害类型"] = jass.DAMAGE_TYPE_POISON,
                    weaponType = jass.WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
                _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, target, config["每波腐化层数"], "污染脉冲")
            end
            ::__continue20::
            i = i + 1
        end
    end
end
____exports["注册米亚污染脉冲"] = function()
end
____exports["尝试触发米亚污染脉冲"] = function(context, nowMs)
    if context["阶段"] ~= 2 then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    if context["上次污染脉冲Ms"] > 0 and nowMs - context["上次污染脉冲Ms"] < config["轮次间隔Ms"] then
        return
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    context["上次污染脉冲Ms"] = nowMs
    _____64AD_653E_8109_51B2_4E2D_5FC3_9884_8B66()
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "污染脉冲", 0)
    _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761({["总时长"] = config["预警秒"], ["颜色ID"] = 3, ["标题文本"] = "污染脉冲", ["提示文本"] = "水池污染正在扩散，请进入安全域。"})
    addDelayedCallback(
        (config["预警秒"] - 3) * 1000,
        function()
            if not _____5355_4F4D_6709_6548(context["Boss单位"]) or context["阶段"] ~= 2 then
                return
            end
            _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "污染脉冲", 1)
        end
    )
    do
        local i = 0
        while i < #config["波次半径"] do
            local waveIndex = i
            addDelayedCallback(
                (config["预警秒"] + waveIndex) * 1000,
                function()
                    _____7ED3_7B97_6C61_67D3_8109_51B2_6CE2(context, waveIndex)
                end
            )
            i = i + 1
        end
    end
end
return ____exports
