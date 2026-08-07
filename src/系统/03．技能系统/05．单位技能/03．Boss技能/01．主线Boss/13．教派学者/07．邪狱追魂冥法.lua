local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.00．配置")
local _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派学者单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建教派学者上下文"]
local _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["教派学者单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.02．数值与表现配置")
local _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派学者技能配置"]
local ____09_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.09．台词播放")
local _____64AD_653E_6559_6D3E_5B66_8005_53F0_8BCD = ____09_FF0E_53F0_8BCD_64AD_653E["播放教派学者台词"]
local ____03_FF0E_6697_5F71_7D22_547D = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.03．暗影索命")
local _____521B_5EFA_6559_6D3E_5B66_8005_6697_5F71_5F39_5E55 = ____03_FF0E_6697_5F71_7D22_547D["创建教派学者暗影弹幕"]
local ____03_FF0E_56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.03．固定受击次数机制单位")
local _____521B_5EFA_56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D = ____03_FF0E_56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D["创建固定受击次数机制单位"]
local ____01_FF0E_6301_7EED_5355_4F4D_8FDE_7EBF = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.07．机制连线.01．持续单位连线")
local _____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF = ____01_FF0E_6301_7EED_5355_4F4D_8FDE_7EBF["创建持续单位连线"]
local ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6309_6BD4_4F8B_79FB_9664_6700_5927_751F_547D = ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664["按比例移除最大生命"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_1["开始硬直"]
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_1["施加快速减速Buff"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local getBuffRuntime = ____require_result_2.getBuffRuntime
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____require_result_3["常规BuffID"]
local ____require_result_4 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_4["显示大招吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_4["关闭吟唱条"]
local ____require_result_5 = require("系统.09．表现系统.08．吟唱条.00．常量定义")
local _____541F_5531_6761_901A_9053__5927_62DB = ____require_result_5["吟唱条通道_大招"]
local ____require_result_6 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_6["获取Boss技能敌对英雄列表"]
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_7.EC_CreateEffect
local ____require_result_8 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_8.Sound3DII_CooPlayReuse
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_9.stringToFourCCSafe
local jass = require("jass.common")
local globals = require("jass.globals")
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetRandomReal = jass.GetRandomReal
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local _____90AA_72F1_8FFD_9B42_51A5_6CD5_6280_80FDID = stringToFourCCSafe(_____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["邪狱追魂冥法"])
local _____9501_94FE_5355_4F4D_72B6_6001_8868 = {}
local _____90AA_72F1_8FFD_9B42_9501_94FE_51CF_901F_6765_6E90 = "教派学者-邪狱追魂锁链"
local _____90AA_72F1_8FFD_9B42_51A5_6CD5_5DF2_6CE8_518C = false
local function _____8BFB_53D6_5F53_524D_96BE_5EA6N()
    local value = __TS__Number(globals.udg_N)
    return value == value and value > 0 and value or 0
end
local function ____on_90AA_72F1_8FFD_9B42_8BFB_6761_5173_95ED(variable)
    local _____8BF7_6C42 = variable
    if _____8BF7_6C42 == nil then
        return
    end
    _____5173_95ED_541F_5531_6761(_____541F_5531_6761_901A_9053__5927_62DB)
end
local function _____5F00_59CB_90AA_72F1_8FFD_9B42_65BD_6CD5_8868_73B0(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587["Boss单位"]
    local _____516C_5171 = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["邪狱追魂冥法"]
    _____5F00_59CB_786C_76F4(boss, _____516C_5171["通魔施法秒"])
    SetUnitAnimation(boss, _____516C_5171["动作名"])
    _____64AD_653E_6559_6D3E_5B66_8005_53F0_8BCD(boss, "邪狱追魂冥法")
    _____663E_793A_5927_62DB_541F_5531_6761({["总时长"] = _____516C_5171["通魔施法秒"], ["颜色ID"] = _____516C_5171["读条颜色ID"], ["标题文本"] = _____914D_7F6E["读条标题"], ["提示文本"] = _____914D_7F6E["读条提示"]})
    local _____56DE_8C03ID = addDelayedCallback(_____516C_5171["通魔施法秒"] * 1000, ____on_90AA_72F1_8FFD_9B42_8BFB_6761_5173_95ED, {["Boss单位"] = boss})
    local ____self_10 = _____4E0A_4E0B_6587["清理"]
    ____self_10["登记延迟回调"](____self_10, "教派学者-邪狱追魂读条关闭", _____56DE_8C03ID)
end
local function _____7ED3_675F_5355_6761_90AA_72F1_9501_94FE(_____9501_94FE, _____539F_56E0)
    if _____9501_94FE["已结束"] then
        return
    end
    _____9501_94FE["已结束"] = true
    local _____673A_5236_5B9E_4F8B = _____9501_94FE["机制实例"]
    _____9501_94FE["机制实例"] = nil
    if _____673A_5236_5B9E_4F8B ~= nil then
        __TS__Delete(_____9501_94FE_5355_4F4D_72B6_6001_8868, _____673A_5236_5B9E_4F8B.ID)
        _____673A_5236_5B9E_4F8B["销毁"](_____673A_5236_5B9E_4F8B, "主动销毁")
    end
    if _____9501_94FE["连线实例"] ~= nil then
        local ____self_11 = _____9501_94FE["连线实例"]
        ____self_11["停止"](____self_11, _____539F_56E0)
        _____9501_94FE["连线实例"] = nil
    end
    local _____51CF_901FBuff_8FD0_884C_65F6 = _____9501_94FE["减速Buff运行时"]
    _____9501_94FE["减速Buff运行时"] = nil
    local _____5DF2_79FB_9664_51CF_901F = false
    if _____51CF_901FBuff_8FD0_884C_65F6 ~= nil and getBuffRuntime(_____9501_94FE["目标单位"], _____5E38_89C4BuffID["减速"]) == _____51CF_901FBuff_8FD0_884C_65F6 then
        _____5DF2_79FB_9664_51CF_901F = _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____9501_94FE["目标单位"], _____5E38_89C4BuffID["减速"])
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____9501_94FE["目标单位"], _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["邪狱追魂锁链"])
end
local function _____5237_65B0_90AA_72F1_9501_94FE_51CF_901F(_____9501_94FE)
    local boss = _____9501_94FE["父状态"]["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["邪狱追魂冥法"]
    _____65BD_52A0_5FEB_901F_51CF_901FBuff(
        boss,
        _____9501_94FE["目标单位"],
        0,
        _____914D_7F6E["锁链移动减速比例"],
        _____914D_7F6E["锁链单次减速持续秒"],
        _____90AA_72F1_8FFD_9B42_9501_94FE_51CF_901F_6765_6E90,
        "技能"
    )
    local _____5F53_524D_51CF_901FBuff_8FD0_884C_65F6 = getBuffRuntime(_____9501_94FE["目标单位"], _____5E38_89C4BuffID["减速"])
    if _____5F53_524D_51CF_901FBuff_8FD0_884C_65F6 ~= nil and _____5F53_524D_51CF_901FBuff_8FD0_884C_65F6.effectSourceName == _____90AA_72F1_8FFD_9B42_9501_94FE_51CF_901F_6765_6E90 then
        _____9501_94FE["减速Buff运行时"] = _____5F53_524D_51CF_901FBuff_8FD0_884C_65F6
    end
end
local function ____on_90AA_72F1_9501_94FE_53D7_51FB(unit, remaining, context)
end
local function ____on_90AA_72F1_9501_94FE_51FB_7834(unit, context)
    local _____9501_94FE = _____9501_94FE_5355_4F4D_72B6_6001_8868[GetHandleId(unit)]
end
local function ____on_90AA_72F1_9501_94FE_673A_5236_7ED3_675F(unit, reason, _killer, variable)
    local _____9501_94FE = variable
    if _____9501_94FE == nil then
        return
    end
    __TS__Delete(
        _____9501_94FE_5355_4F4D_72B6_6001_8868,
        GetHandleId(unit)
    )
    _____9501_94FE["机制实例"] = nil
    _____7ED3_675F_5355_6761_90AA_72F1_9501_94FE(
        _____9501_94FE,
        (reason == "被击杀" or reason == "主动销毁") and "锁链被击破" or tostring(reason)
    )
end
local function _____7ED3_675F_90AA_72F1_8FFD_9B42(_____72B6_6001, _____539F_56E0)
    if _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["已结束"] = true
    if _____72B6_6001["周期回调ID"] ~= 0 then
        removePeriodicCallback(_____72B6_6001["周期回调ID"])
        _____72B6_6001["周期回调ID"] = 0
    end
    do
        local i = 0
        while i < #_____72B6_6001["锁链列表"] do
            _____7ED3_675F_5355_6761_90AA_72F1_9501_94FE(_____72B6_6001["锁链列表"][i + 1], _____539F_56E0)
            i = i + 1
        end
    end
    if _____72B6_6001["上下文"]["邪狱追魂状态"] == _____72B6_6001 then
        _____72B6_6001["上下文"]["邪狱追魂状态"] = nil
    end
end
local function ____on_90AA_72F1_8FFD_9B42_6E05_7406(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 ~= nil then
        _____7ED3_675F_90AA_72F1_8FFD_9B42(_____72B6_6001, "上下文清理")
    end
end
local function ____on_90AA_72F1_8FFD_9B42_5468_671F(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(boss) then
        _____7ED3_675F_90AA_72F1_8FFD_9B42(_____72B6_6001, "Boss失效")
        return
    end
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["邪狱追魂冥法"]
    _____72B6_6001["已运行秒"] = _____72B6_6001["已运行秒"] + _____914D_7F6E["锁链跟随间隔秒"]
    do
        local i = 0
        while i < #_____72B6_6001["锁链列表"] do
            do
                local _____9501_94FE = _____72B6_6001["锁链列表"][i + 1]
                if _____9501_94FE["已结束"] then
                    goto __continue29
                end
                local ____temp_13 = not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____9501_94FE["目标单位"]) or _____9501_94FE["机制实例"] == nil
                if not ____temp_13 then
                    local ____self_12 = _____9501_94FE["机制实例"]
                    ____temp_13 = not ____self_12["是否存活"](____self_12)
                end
                if ____temp_13 then
                    _____7ED3_675F_5355_6761_90AA_72F1_9501_94FE(_____9501_94FE, "目标或机制单位失效")
                    goto __continue29
                end
                SetUnitX(
                    _____9501_94FE["机制实例"]["单位"],
                    GetUnitX(_____9501_94FE["目标单位"])
                )
                SetUnitY(
                    _____9501_94FE["机制实例"]["单位"],
                    GetUnitY(_____9501_94FE["目标单位"])
                )
                if _____72B6_6001["已运行秒"] + 0.001 >= _____9501_94FE["下次减速刷新秒"] then
                    _____5237_65B0_90AA_72F1_9501_94FE_51CF_901F(_____9501_94FE)
                    _____9501_94FE["下次减速刷新秒"] = _____9501_94FE["下次减速刷新秒"] + _____914D_7F6E["锁链刷新减速间隔秒"]
                end
            end
            ::__continue29::
            i = i + 1
        end
    end
    if _____72B6_6001["已运行秒"] + 0.001 >= _____914D_7F6E["锁链持续秒"] then
        _____7ED3_675F_90AA_72F1_8FFD_9B42(_____72B6_6001, "锁链持续时间结束")
    end
end
local function ____on_90AA_72F1_8FFD_9B42_53D1_5C04_6697_5F71(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] or _____72B6_6001["已发射弹幕"] or not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____72B6_6001["上下文"]["Boss单位"]) then
        return
    end
    _____72B6_6001["已发射弹幕"] = true
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["邪狱追魂冥法"]
    local count = _____914D_7F6E["弹幕基础数量"] + _____914D_7F6E["每难度弹幕数量"] * _____8BFB_53D6_5F53_524D_96BE_5EA6N()
    local created = 0
    do
        local i = 0
        while i < count do
            if _____521B_5EFA_6559_6D3E_5B66_8005_6697_5F71_5F39_5E55(
                _____72B6_6001["上下文"],
                GetRandomReal(0, 360),
                _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["暗影索命"]["终结弹幕缩放"],
                "邪狱追魂冥法"
            ) > 0 then
                created = created + 1
            end
            i = i + 1
        end
    end
end
local function _____521B_5EFA_90AA_72F1_9501_94FE(_____72B6_6001, target)
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["邪狱追魂冥法"]
    local _____9501_94FE = {["已结束"] = false, ["父状态"] = _____72B6_6001, ["目标单位"] = target, ["下次减速刷新秒"] = 0}
    _____9501_94FE["机制实例"] = _____521B_5EFA_56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D({
        ["清理"] = _____72B6_6001["上下文"]["清理"],
        ["名称"] = "教派学者-邪狱追魂锁链",
        ["单位名称"] = "邪狱锁链",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["模型路径"] = _____914D_7F6E["锁链模型路径"],
        X = GetUnitX(target),
        Y = GetUnitY(target),
        ["固定站桩"] = false,
        ["禁止普攻"] = true,
        ["缩放"] = _____914D_7F6E["锁链缩放"],
        ["持续时间"] = _____914D_7F6E["锁链持续秒"],
        ["受击次数"] = _____914D_7F6E["锁链受击次数"],
        ["计数模式"] = "纯普攻",
        ["未计数伤害无效"] = true,
        ["同步生命条"] = true,
        ["变量"] = _____9501_94FE,
        ["on受击"] = ____on_90AA_72F1_9501_94FE_53D7_51FB,
        ["on击破"] = ____on_90AA_72F1_9501_94FE_51FB_7834,
        ["on结束"] = ____on_90AA_72F1_9501_94FE_673A_5236_7ED3_675F
    })
    if _____9501_94FE["机制实例"] == nil then
        _____9501_94FE["已结束"] = true
        local ____72B6_6001__9501_94FE_5217_8868_14 = _____72B6_6001["锁链列表"]
        ____72B6_6001__9501_94FE_5217_8868_14[#____72B6_6001__9501_94FE_5217_8868_14 + 1] = _____9501_94FE
        return
    end
    _____9501_94FE_5355_4F4D_72B6_6001_8868[_____9501_94FE["机制实例"].ID] = _____9501_94FE
    _____9501_94FE["连线实例"] = _____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF({
        ["清理"] = _____72B6_6001["上下文"]["清理"],
        ["名称"] = "教派学者-邪狱追魂连线",
        ["起点单位"] = boss,
        ["终点单位"] = _____9501_94FE["机制实例"]["单位"],
        ["闪电代码"] = _____914D_7F6E["锁链闪电类型"],
        ["持续秒"] = _____914D_7F6E["锁链持续秒"],
        ["Tick间隔毫秒"] = _____914D_7F6E["锁链跟随间隔秒"] * 1000
    })
    registerManualBuff(
        target,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["邪狱追魂锁链"],
        _____914D_7F6E["锁链持续秒"],
        _____914D_7F6E["锁链移动减速比例"],
        {sourceUnit = boss, effectSourceName = "邪狱追魂锁链", effectSourceType = "技能"}
    )
    _____5237_65B0_90AA_72F1_9501_94FE_51CF_901F(_____9501_94FE)
    _____9501_94FE["下次减速刷新秒"] = _____914D_7F6E["锁链刷新减速间隔秒"]
    local ____72B6_6001__9501_94FE_5217_8868_15 = _____72B6_6001["锁链列表"]
    ____72B6_6001__9501_94FE_5217_8868_15[#____72B6_6001__9501_94FE_5217_8868_15 + 1] = _____9501_94FE
end
local function _____542F_52A8_90AA_72F1_8FFD_9B42_673A_5236(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(boss) or _____4E0A_4E0B_6587["邪狱追魂状态"] ~= nil then
        return false
    end
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["邪狱追魂冥法"]
    local _____72B6_6001 = {
        ["已结束"] = false,
        ["上下文"] = _____4E0A_4E0B_6587,
        ["锁链列表"] = {},
        ["已运行秒"] = 0,
        ["周期回调ID"] = 0,
        ["已发射弹幕"] = false
    }
    _____4E0A_4E0B_6587["邪狱追魂状态"] = _____72B6_6001
    local ____self_18 = _____4E0A_4E0B_6587["清理"]
    ____self_18["登记清理"](____self_18, "教派学者-邪狱追魂清理", ____on_90AA_72F1_8FFD_9B42_6E05_7406, _____72B6_6001)
    local _____79FB_9664_91CF = _____6309_6BD4_4F8B_79FB_9664_6700_5927_751F_547D(boss, _____914D_7F6E["自损最大生命比例"], true)
    EC_CreateEffect(
        _____914D_7F6E["自损特效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        0,
        _____914D_7F6E["自损特效缩放"],
        1,
        1
    )
    EC_CreateEffect(
        _____914D_7F6E["起始特效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        0,
        _____914D_7F6E["起始特效缩放"],
        1,
        _____914D_7F6E["起始特效持续秒"]
    )
    Sound3DII_CooPlayReuse(
        _____914D_7F6E["起始音效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["音效裁断距离"]
    )
    local _____76EE_6807_5217_8868 = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            if _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____76EE_6807_5217_8868[i + 1]) then
                _____521B_5EFA_90AA_72F1_9501_94FE(_____72B6_6001, _____76EE_6807_5217_8868[i + 1])
            end
            i = i + 1
        end
    end
    _____72B6_6001["周期回调ID"] = addPeriodicCallback(_____914D_7F6E["锁链跟随间隔秒"] * 1000, ____on_90AA_72F1_8FFD_9B42_5468_671F, _____72B6_6001)
    local ____self_19 = _____4E0A_4E0B_6587["清理"]
    ____self_19["登记周期回调"](____self_19, "教派学者-邪狱追魂周期", _____72B6_6001["周期回调ID"])
    local _____53D1_5C04_56DE_8C03ID = addDelayedCallback(_____914D_7F6E["弹幕发射延迟秒"] * 1000, ____on_90AA_72F1_8FFD_9B42_53D1_5C04_6697_5F71, _____72B6_6001)
    local ____self_20 = _____4E0A_4E0B_6587["清理"]
    ____self_20["登记延迟回调"](____self_20, "教派学者-邪狱追魂弹幕发射", _____53D1_5C04_56DE_8C03ID)
    return true
end
local function ____on_90AA_72F1_8FFD_9B42_5EF6_8FDF_542F_52A8(variable)
    local _____8BF7_6C42 = variable
    if _____8BF7_6C42 ~= nil then
        _____542F_52A8_90AA_72F1_8FFD_9B42_673A_5236(_____8BF7_6C42["上下文"])
    end
end
____exports["释放教派学者邪狱追魂冥法"] = function(_____4E0A_4E0B_6587)
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]) or _____4E0A_4E0B_6587["邪狱追魂状态"] ~= nil then
        return false
    end
    _____5F00_59CB_90AA_72F1_8FFD_9B42_65BD_6CD5_8868_73B0(_____4E0A_4E0B_6587)
    local _____56DE_8C03ID = addDelayedCallback(_____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["通魔施法秒"] * 1000, ____on_90AA_72F1_8FFD_9B42_5EF6_8FDF_542F_52A8, {["上下文"] = _____4E0A_4E0B_6587})
    local ____self_23 = _____4E0A_4E0B_6587["清理"]
    ____self_23["登记延迟回调"](____self_23, "教派学者-邪狱追魂显式释放", _____56DE_8C03ID)
    return true
end
____exports["注册教派学者邪狱追魂冥法"] = function()
    if _____90AA_72F1_8FFD_9B42_51A5_6CD5_5DF2_6CE8_518C then
        return
    end
    _____90AA_72F1_8FFD_9B42_51A5_6CD5_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "教派学者-邪狱追魂冥法",
        ["单位类型ID"] = _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["单位ID"],
        ["技能ID"] = _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["邪狱追魂冥法"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587,
        ["释放技能"] = function(_____4E0A_4E0B_6587)
            ____exports["释放教派学者邪狱追魂冥法"](_____4E0A_4E0B_6587)
        end
    })
end
return ____exports
