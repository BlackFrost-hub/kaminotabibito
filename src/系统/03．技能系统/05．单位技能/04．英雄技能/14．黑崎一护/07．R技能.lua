--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.00．配置")
local _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["黑崎一护技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.01．状态表")
local _____83B7_53D6_6216_521B_5EFA_9ED1_5D0E_4E00_62A4_72B6_6001 = ____01_FF0E_72B6_6001_8868["获取或创建黑崎一护状态"]
local _____83B7_53D6_9ED1_5D0E_4E00_62A4_72B6_6001 = ____01_FF0E_72B6_6001_8868["获取黑崎一护状态"]
local _____8BBE_7F6E_9ED1_5D0E_4E00_62A4_534D_89E3 = ____01_FF0E_72B6_6001_8868["设置黑崎一护卍解"]
local _____89E3_9664_9ED1_5D0E_4E00_62A4A_952E_6B66_88C5 = ____01_FF0E_72B6_6001_8868["解除黑崎一护A键武装"]
local _____6B66_88C5_9ED1_5D0E_4E00_62A4A_952E = ____01_FF0E_72B6_6001_8868["武装黑崎一护A键"]
local ____09_FF0E_9ED1_5D0E_4E00_62A4 = require("系统.05．Buff系统.03．Buff表.02．英雄.09．黑崎一护")
local _____9ED1_5D0E_4E00_62A4BuffID = ____09_FF0E_9ED1_5D0E_4E00_62A4["黑崎一护BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____08_FF0E_9ED1_6D41_7259_7A81 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.08．黑流牙突")
local _____6CE8_518C_73A9_5BB6_9ED1_6D41_7259_7A81A_952E = ____08_FF0E_9ED1_6D41_7259_7A81["注册玩家黑流牙突A键"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统")
local SOS_SetUnitSpeed = ____require_result_1.SOS_SetUnitSpeed
local SOS_UnSetUnitSpeed = ____require_result_1.SOS_UnSetUnitSpeed
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local ____require_result_3 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_3.Sound3DII_CooPlayReuse
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local IsUnitAliveBJ = jass.IsUnitAliveBJ
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local _____914D_7F6E = _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____R_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587(unit)
    local id = GetHandleId(unit)
    local ctx = ____R_4E0A_4E0B_6587_8868[id]
    if ctx == nil then
        ctx = {["施法者"] = unit, ["已启动"] = false, ["倒计时回调ID"] = 0, ["Tick数"] = 0}
        ____R_4E0A_4E0B_6587_8868[id] = ctx
    end
    return ctx
end
local function ____R_53EF_91CA_653E(context, _caster)
    return context["已启动"] ~= true
end
____exports["结束卍解"] = function(caster)
    local record = _____83B7_53D6_9ED1_5D0E_4E00_62A4_72B6_6001(caster)
    if record == nil or record["卍解"] ~= true then
        return
    end
    _____8BBE_7F6E_9ED1_5D0E_4E00_62A4_534D_89E3(caster, false)
    _____89E3_9664_9ED1_5D0E_4E00_62A4A_952E_6B66_88C5(caster)
    if record["移速已突破"] then
        SOS_UnSetUnitSpeed(caster)
        record["移速已突破"] = false
    end
    local ctx = ____R_4E0A_4E0B_6587_8868[GetHandleId(caster)]
    if ctx ~= nil then
        if ctx["倒计时回调ID"] ~= 0 then
            removePeriodicCallback(ctx["倒计时回调ID"])
        end
        ctx["倒计时回调ID"] = 0
        ctx["已启动"] = false
    end
end
local function _____63A8_8FDB_534D_89E3_5012_8BA1_65F6(variable)
    local ctx = variable
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    local caster = ctx["施法者"]
    ctx["Tick数"] = ctx["Tick数"] + 1
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) or ctx["Tick数"] >= math.floor(_____914D_7F6E.R["持续秒"] * 10 + 0.5) then
        if caster ~= nil and caster ~= 0 then
            ____exports["结束卍解"](caster)
        elseif ctx["倒计时回调ID"] ~= 0 then
            removePeriodicCallback(ctx["倒计时回调ID"])
            ctx["倒计时回调ID"] = 0
            ctx["已启动"] = false
        end
    end
end
local function _____542F_52A8_534D_89E3(variable)
    local ctx = variable
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) then
        ctx["已启动"] = false
        return
    end
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    _____8BBE_7F6E_9ED1_5D0E_4E00_62A4_534D_89E3(caster, true)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.R["卍解特效"]["模型"],
        X = x,
        Y = y,
        Z = _____914D_7F6E.R["卍解特效"]["高度"],
        ["面向角度"] = 270,
        ["缩放"] = _____914D_7F6E.R["卍解特效"]["缩放"],
        ["持续秒"] = _____914D_7F6E.R["卍解特效"]["持续秒"]
    })
    Sound3DII_CooPlayReuse(
        _____914D_7F6E.R["卍解音效"]["路径"],
        x,
        y,
        0,
        _____914D_7F6E.R["卍解音效"]["裁断距离"]
    )
    registerManualBuff(caster, _____9ED1_5D0E_4E00_62A4BuffID["卍解"], _____914D_7F6E.R["持续秒"], 0)
    _____6CE8_518C_73A9_5BB6_9ED1_6D41_7259_7A81A_952E(caster)
    _____6B66_88C5_9ED1_5D0E_4E00_62A4A_952E(caster)
    ctx["Tick数"] = 0
    ctx["倒计时回调ID"] = addPeriodicCallback(100, _____63A8_8FDB_534D_89E3_5012_8BA1_65F6, ctx)
end
local function _____91CA_653E_89E3_653E(context, caster, ______6280_80FD_5B9E_4F8BID)
    local ____opt_7 = _____83B7_53D6_9ED1_5D0E_4E00_62A4_72B6_6001(caster)
    if (____opt_7 and ____opt_7["卍解"]) == true then
        ____exports["结束卍解"](caster)
    end
    context["施法者"] = caster
    context["已启动"] = true
    context["Tick数"] = 0
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    Sound3DII_CooPlayReuse(
        _____914D_7F6E.R["起手音效"]["路径"],
        x,
        y,
        0,
        _____914D_7F6E.R["起手音效"]["裁断距离"]
    )
    SOS_SetUnitSpeed(caster, _____914D_7F6E.R["移速"])
    _____83B7_53D6_6216_521B_5EFA_9ED1_5D0E_4E00_62A4_72B6_6001(caster)["移速已突破"] = true
    addDelayedCallback(
        math.floor(_____914D_7F6E.R["卍解延迟秒"] * 1000 + 0.5),
        _____542F_52A8_534D_89E3,
        context
    )
end
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function ____R_5355_4F4D_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if jass.GetUnitTypeId(dyingUnit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    ____exports["结束卍解"](dyingUnit)
end
____exports["注册黑崎一护R"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "黑崎一护-天锁斩月（R）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.R["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587,
        ["可释放"] = ____R_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653E_89E3_653E,
        ["创建独立技能实例"] = false
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____R_5355_4F4D_6B7B_4EA1_6E05_7406)
    end
end
____exports["注册黑崎一护R"]()
return ____exports
