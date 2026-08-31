--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53D6_6700_5927_751F_547D, jass, GetUnitStateJapi
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local _____64AD_653E_683C_9C81_59C6_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放格鲁姆台词"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
function _____53D6_6700_5927_751F_547D(unit)
    return GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE) or 0
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_0["开始充能"]
local _____505C_6B62_5145_80FD = ____require_result_0["停止充能"]
local _____5355_4F4D_662F_5426_6B63_5728_5145_80FD = ____require_result_0["单位是否正在充能"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电")
local _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_2["创建单位绑定闪电"]
local _____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_2["销毁单位绑定闪电"]
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_4.doHeal
local ____require_result_5 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_5["显示大招吟唱条"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.18．单位动画守护")
local _____521B_5EFA_5355_4F4D_52A8_753B_5B88_62A4 = ____require_result_6["创建单位动画守护"]
jass = require("jass.common")
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
local KillUnit = jass.KillUnit
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local function _____5468_671F(ms, callback)
    return addPeriodicCallback(ms, callback)
end
local function _____505C_6B62_5468_671F(id)
    removePeriodicCallback(id)
end
local function _____6E05_7406_7099_70ED_5949_732E_8FDE_63A5(context)
    if context["炙热奉献连接"] ~= nil then
        _____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535(context["炙热奉献连接"])
    end
    context["炙热奉献连接"] = nil
end
local function _____6062_590D_683C_9C81_59C6_52A8_753B(grum)
    if not _____5355_4F4D_6709_6548(grum) then
        return
    end
    SetUnitTimeScale(grum, 1)
    SetUnitAnimationByIndex(grum, 0)
end
local function ____on_7099_70ED_5949_732E_5F00_59CB(context, grum, _chargeId)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["炙热奉献"]
    context["炙热奉献进行中"] = true
    registerManualBuff(
        grum,
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["炙热奉献"],
        config["引导秒"],
        1,
        {stack = 1, sourceName = "巴尔扎罗斯-炙热奉献"}
    )
    SetUnitAnimationByIndex(grum, config["动画编号"])
    SetUnitTimeScale(grum, config["动画速度"])
    _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(context["Boss单位"], "炙热奉献", 0)
    _____663E_793A_5927_62DB_541F_5531_6761({["总时长"] = config["引导秒"], ["颜色ID"] = config["吟唱条颜色ID"], ["标题文本"] = config["吟唱条标题文本"], ["提示文本"] = config["吟唱条提示文本"]})
    context["炙热奉献连接"] = _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535({
        ["效果代码"] = config["火焰连接效果代码"],
        ["起点单位"] = grum,
        ["终点单位"] = context["Boss单位"],
        ["持续时间"] = config["引导秒"],
        ["起点高度偏移"] = config["连接起点高度"],
        ["终点高度偏移"] = config["连接终点高度"],
        ["任一死亡时销毁"] = true
    })
    local ____self_7 = context["清理"]
    ____self_7["登记清理"](
        ____self_7,
        "巴尔扎罗斯-炙热奉献连接",
        function()
            _____6E05_7406_7099_70ED_5949_732E_8FDE_63A5(context)
        end
    )
end
local function ____on_7099_70ED_5949_732E_5B8C_6210(context, grum)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["炙热奉献"]
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) or not _____5355_4F4D_6709_6548(grum) then
        return
    end
    local healAmount = _____53D6_6700_5927_751F_547D(context["Boss单位"]) * config["Boss治疗最大生命比例"]
    doHeal({
        HealSource = grum,
        HealTarget = context["Boss单位"],
        HealAmount = healAmount,
        ItemHeal = false,
        HealEffect = false
    })
    registerManualBuff(
        context["Boss单位"],
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["熔岩暴走"],
        config["熔岩暴走持续秒"],
        1,
        {stack = 1, sourceName = "巴尔扎罗斯-炙热奉献"}
    )
    context["炙热奉献进行中"] = false
    context["炙热奉献充能ID"] = 0
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(grum, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["炙热奉献"])
    _____6E05_7406_7099_70ED_5949_732E_8FDE_63A5(context)
    KillUnit(grum)
end
local function ____on_7099_70ED_5949_732E_7ED3_675F(context, grum, _____539F_56E0)
    context["炙热奉献进行中"] = false
    context["炙热奉献充能ID"] = 0
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(grum, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["炙热奉献"])
    _____6E05_7406_7099_70ED_5949_732E_8FDE_63A5(context)
    if _____539F_56E0 ~= "完成" then
        _____64AD_653E_683C_9C81_59C6_53F0_8BCD(grum, "死亡", 0)
    end
    _____6062_590D_683C_9C81_59C6_52A8_753B(grum)
end
____exports["触发格鲁姆炙热奉献"] = function(context)
    local grum = context["格鲁姆"]
    local boss = context["Boss单位"]
    if context["炙热奉献进行中"] or context["炙热奉献已触发"] or not _____5355_4F4D_6709_6548(grum) or not _____5355_4F4D_6709_6548(boss) then
        return 0
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["炙热奉献"]
    local life = jass.GetUnitState(grum, jass.UNIT_STATE_LIFE)
    local maxLife = _____53D6_6700_5927_751F_547D(grum)
    if maxLife <= 0 or life > maxLife * config["触发生命比例"] then
        return 0
    end
    context["炙热奉献已触发"] = true
    local chargeId = _____5F00_59CB_5145_80FD(
        grum,
        {
            ["持续时间"] = config["引导秒"],
            ["主单位"] = boss,
            ["主单位死亡时中断"] = true,
            ["强制硬直"] = true,
            ["显示进度条特效"] = true,
            ["进度条特效动画序号"] = 0,
            ["开始回调"] = function(unit, id)
                ____on_7099_70ED_5949_732E_5F00_59CB(context, unit, id)
            end,
            ["充能完成回调"] = function(unit, _id)
                ____on_7099_70ED_5949_732E_5B8C_6210(context, unit)
            end,
            ["结束回调"] = function(unit, reason, _id)
                ____on_7099_70ED_5949_732E_7ED3_675F(context, unit, reason)
            end
        }
    )
    context["炙热奉献充能ID"] = chargeId
    return chargeId
end
____exports["中断格鲁姆炙热奉献"] = function(context)
    local chargeId = context["炙热奉献充能ID"]
    if chargeId <= 0 then
        return false
    end
    return _____505C_6B62_5145_80FD(chargeId)
end
____exports["初始化巴尔扎罗斯炙热奉献"] = function(context)
    if context["炙热奉献已初始化"] then
        return
    end
    context["炙热奉献已初始化"] = true
    local timerId
    timerId = _____5468_671F(
        500,
        function()
            if not _____5355_4F4D_6709_6548(context["Boss单位"]) or not _____5355_4F4D_6709_6548(context["格鲁姆"]) then
                _____505C_6B62_5468_671F(timerId)
                return
            end
            if not context["炙热奉献进行中"] then
                ____exports["触发格鲁姆炙热奉献"](context)
            end
        end
    )
    local ____self_8 = context["清理"]
    ____self_8["登记周期回调"](____self_8, "巴尔扎罗斯-炙热奉献检测", timerId)
    local ____self_9 = context["清理"]
    ____self_9["登记清理"](
        ____self_9,
        "巴尔扎罗斯-炙热奉献充能",
        function()
            if _____5355_4F4D_662F_5426_6B63_5728_5145_80FD(context["格鲁姆"]) then
                ____exports["中断格鲁姆炙热奉献"](context)
            end
        end
    )
end
return ____exports
