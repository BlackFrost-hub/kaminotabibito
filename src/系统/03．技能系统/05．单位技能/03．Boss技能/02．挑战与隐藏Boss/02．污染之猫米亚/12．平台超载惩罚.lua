--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_5E73_53F0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚平台配置"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_0["取当前有效玩家人数"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local getBuffRuntime = ____require_result_2.getBuffRuntime
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____require_result_3["创建循环点特效"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____5E73_53F0_8D85_8F7D_6548_679C_8868 = {}
local _____5E73_53F0_8D85_8F7D_6301_7EED_53F0_8BCD_95F4_9694Ms = 3000
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5E73_53F0ID(_____533A_57DF)
    return _____533A_57DF["配置"].ID or _____533A_57DF["配置"]["名称"] or ""
end
local function _____5355_4F4D_5728_5E73_53F0_5185(unit, _____533A_57DF)
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    return x >= _____533A_57DF["配置"]["左"] and x <= _____533A_57DF["配置"]["右"] and y >= _____533A_57DF["配置"]["下"] and y <= _____533A_57DF["配置"]["上"]
end
local function _____53D6_5E73_53F0_5BB9_91CF()
    return _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570() <= 2 and _____7C73_4E9A_5E73_53F0_914D_7F6E["单双人平台容量"] or _____7C73_4E9A_5E73_53F0_914D_7F6E["三四人平台容量"]
end
local function _____53D6_5E73_53F0_5185_82F1_96C4(_____533A_57DF, heroes)
    local result = {}
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue8
                end
                if _____5355_4F4D_5728_5E73_53F0_5185(hero, _____533A_57DF) then
                    result[#result + 1] = hero
                end
            end
            ::__continue8::
            i = i + 1
        end
    end
    return result
end
local function _____786E_4FDD_5E73_53F0_8D85_8F7D_8868_73B0(context, _____533A_57DF, id)
    local key = "mia-overload:" .. id
    if _____5E73_53F0_8D85_8F7D_6548_679C_8868[key] == true then
        return
    end
    _____5E73_53F0_8D85_8F7D_6548_679C_8868[key] = true
    _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["腐化残留云"],
        X = _____533A_57DF["中心X"],
        Y = _____533A_57DF["中心Y"],
        Z = 0,
        ["缩放"] = 0.8,
        ["重建间隔秒"] = 3,
        ["单次持续秒"] = 2.8,
        ["存活条件"] = function()
            local alive = _____5355_4F4D_6709_6548(context["Boss单位"]) and context["超载平台ID表"][id] == true
            if not alive then
                _____5E73_53F0_8D85_8F7D_6548_679C_8868[key] = nil
            end
            return alive
        end
    })
end
local function _____5237_65B0_5E73_53F0_8D85_8F7DBuff(target)
    registerManualBuff(
        target,
        _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E.BuffID["平台超载"],
        1.2,
        0.3,
        {sourceName = "平台超载", effectModelOverride = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["腐化高层"]}
    )
end
local function _____5904_7406_8D85_8F7D_5E73_53F0(context, _____533A_57DF, units, nowMs)
    local id = _____53D6_5E73_53F0ID(_____533A_57DF)
    if id == "" then
        return
    end
    context["超载平台ID表"][id] = true
    _____786E_4FDD_5E73_53F0_8D85_8F7D_8868_73B0(context, _____533A_57DF, id)
    if context["超载平台下次叠层Ms表"][id] == nil or nowMs >= (context["超载平台下次叠层Ms表"][id] or 0) then
        context["超载平台下次叠层Ms表"][id] = nowMs + 1000
        do
            local i = 0
            while i < #units do
                _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, units[i + 1], 1, "平台超载惩罚")
                i = i + 1
            end
        end
    end
    do
        local i = 0
        while i < #units do
            _____5237_65B0_5E73_53F0_8D85_8F7DBuff(units[i + 1])
            i = i + 1
        end
    end
    if context["上次平台超载台词Ms"] <= 0 then
        _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "平台超载惩罚", 0)
        context["上次平台超载台词Ms"] = nowMs
    elseif nowMs - context["上次平台超载台词Ms"] >= _____5E73_53F0_8D85_8F7D_6301_7EED_53F0_8BCD_95F4_9694Ms then
        _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "平台超载惩罚", 1)
        context["上次平台超载台词Ms"] = nowMs
    end
end
____exports["取米亚平台超载伤害倍率"] = function(target)
    if target == nil or target == 0 then
        return 1
    end
    return getBuffRuntime(target, _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E.BuffID["平台超载"]) ~= nil and 1.3 or 1
end
____exports["注册米亚平台超载惩罚"] = function()
end
____exports["刷新米亚平台超载惩罚"] = function(context, nowMs)
    if context["阶段"] < 2 then
        return
    end
    if context["上次平台超载检测Ms"] > 0 and nowMs - context["上次平台超载检测Ms"] < _____7C73_4E9A_5E73_53F0_914D_7F6E["超载检测间隔Ms"] then
        return
    end
    context["上次平台超载检测Ms"] = nowMs
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    local capacity = _____53D6_5E73_53F0_5BB9_91CF()
    local _____672C_8F6E_8D85_8F7D_8868 = {}
    local _____533A_57DF_5217_8868 = context["安全域区域组"]["区域列表"]
    do
        local i = 0
        while i < #_____533A_57DF_5217_8868 do
            do
                local _____533A_57DF = _____533A_57DF_5217_8868[i + 1]
                local id = _____53D6_5E73_53F0ID(_____533A_57DF)
                if id == "" or context["腐化转移污染平台ID"] == id then
                    goto __continue33
                end
                local units = _____53D6_5E73_53F0_5185_82F1_96C4(_____533A_57DF, heroes)
                if #units > capacity then
                    _____672C_8F6E_8D85_8F7D_8868[id] = true
                    _____5904_7406_8D85_8F7D_5E73_53F0(context, _____533A_57DF, units, nowMs)
                end
            end
            ::__continue33::
            i = i + 1
        end
    end
    local _____4ECD_6709_8D85_8F7D = false
    do
        local i = 0
        while i < #_____533A_57DF_5217_8868 do
            do
                local id = _____53D6_5E73_53F0ID(_____533A_57DF_5217_8868[i + 1])
                if id == "" then
                    goto __continue37
                end
                if _____672C_8F6E_8D85_8F7D_8868[id] == true then
                    _____4ECD_6709_8D85_8F7D = true
                else
                    context["超载平台ID表"][id] = nil
                    context["超载平台下次叠层Ms表"][id] = nil
                end
            end
            ::__continue37::
            i = i + 1
        end
    end
    if not _____4ECD_6709_8D85_8F7D then
        context["上次平台超载台词Ms"] = 0
    end
end
return ____exports
