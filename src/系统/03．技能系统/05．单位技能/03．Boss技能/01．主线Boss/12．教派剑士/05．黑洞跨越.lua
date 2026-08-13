local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027, _____6062_590D_9ED1_6D1E_5954_8DD1_5C5E_6027, _____6E05_9664_9ED1_6D1E_5F3A_5316_666E_653B, _____6FC0_6D3B_9ED1_6D1E_5F3A_5316_666E_653B, _____7ED3_675F_9ED1_6D1E_8DE8_8D8A, ____on_9ED1_6D1EBoss_51FA_73B0, ____on_521B_5EFA_9ED1_6D1E_51FA_53E3, _____5B89_6392_9ED1_6D1E_79FB_52A8_68C0_67E5, ____on_9ED1_6D1E_79FB_52A8_68C0_67E5, addDelayedCallback, removeDelayedCallback, _____6DFB_52A0_5355_4F4D_6682_505C, _____79FB_9664_5355_4F4D_6682_505C, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____5173_95ED_541F_5531_6761, _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4, YDUserDataGetSafe, YDUserDataSetSafe, EC_CreateEffect, Sound3DII_CooPlayReuse, debugLogForce, GetHandleId, GetUnitFacing, GetUnitX, GetUnitY, SetUnitFacing, ShowUnit, IssuePointOrder, IssueTargetOrder, _____9ED1_6D1E_6682_505C_6765_6E90
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.00．配置")
local _____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派剑士单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.01．运行时上下文")
local _____83B7_53D6_5168_90E8_6559_6D3E_5251_58EB_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部教派剑士上下文"]
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建教派剑士上下文"]
local _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["教派剑士单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.02．数值与表现配置")
local _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派剑士技能配置"]
local _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派剑士音效配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.11．台词播放")
local _____64AD_653E_6559_6D3E_5251_58EB_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放教派剑士台词"]
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
local ____03_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____03_FF0E_5BF9_5916_63A5_53E3["开始冲锋"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____8DDD_79BB_5E73_65B9XY = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离平方XY"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位最大生命"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["执行战斗自身传送到坐标"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664 = ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664["执行非伤害生命移除"]
local ____11_FF0E_6559_6D3E_5251_58EB = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.11．教派剑士")
local _____6559_6D3E_5251_58EBBuffID = ____11_FF0E_6559_6D3E_5251_58EB["教派剑士BuffID"]
function _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027(unit, _____5C5E_6027_540D, _____589E_91CF)
    local _____5F53_524D_503C = __TS__Number(YDUserDataGetSafe("unit", unit, _____5C5E_6027_540D, "real")) or 0
    YDUserDataSetSafe(
        "unit",
        unit,
        _____5C5E_6027_540D,
        "real",
        _____5F53_524D_503C + _____589E_91CF
    )
end
function _____6062_590D_9ED1_6D1E_5954_8DD1_5C5E_6027(_____72B6_6001)
    if not _____72B6_6001["奔跑属性已应用"] then
        return
    end
    _____72B6_6001["奔跑属性已应用"] = false
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027(boss, "闪避率", -_____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]["奔跑闪避加成"])
    _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027(boss, "眩晕抗性", _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]["奔跑韧性降低"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____6559_6D3E_5251_58EBBuffID["黑洞奔袭"])
    debugLogForce(
        "教派剑士-黑洞跨越",
        "奔跑属性恢复",
        "bossHid=",
        boss ~= nil and boss ~= 0 and GetHandleId(boss) or 0
    )
end
function _____6E05_9664_9ED1_6D1E_5F3A_5316_666E_653B(variable)
    local _____4E0A_4E0B_6587 = variable
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    _____4E0A_4E0B_6587["黑洞强化普攻清除回调ID"] = 0
    _____4E0A_4E0B_6587["黑洞强化普攻就绪"] = false
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____4E0A_4E0B_6587["Boss单位"], _____6559_6D3E_5251_58EBBuffID["黑洞强化普攻"])
    debugLogForce(
        "教派剑士-黑洞跨越",
        "强化普攻窗口结束",
        "bossHid=",
        _____4E0A_4E0B_6587["Boss单位"] ~= nil and _____4E0A_4E0B_6587["Boss单位"] ~= 0 and GetHandleId(_____4E0A_4E0B_6587["Boss单位"]) or 0
    )
end
function _____6FC0_6D3B_9ED1_6D1E_5F3A_5316_666E_653B(_____4E0A_4E0B_6587)
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]
    if _____4E0A_4E0B_6587["黑洞强化普攻清除回调ID"] ~= 0 then
        removeDelayedCallback(_____4E0A_4E0B_6587["黑洞强化普攻清除回调ID"])
    end
    _____4E0A_4E0B_6587["黑洞强化普攻就绪"] = true
    registerManualBuff(
        _____4E0A_4E0B_6587["Boss单位"],
        _____6559_6D3E_5251_58EBBuffID["黑洞强化普攻"],
        _____914D_7F6E["强化普攻窗口秒"],
        0,
        {sourceUnit = _____4E0A_4E0B_6587["Boss单位"], effectSourceName = "黑洞强化普攻", effectSourceType = "技能"}
    )
    _____4E0A_4E0B_6587["黑洞强化普攻清除回调ID"] = addDelayedCallback(_____914D_7F6E["强化普攻窗口秒"] * 1000, _____6E05_9664_9ED1_6D1E_5F3A_5316_666E_653B, _____4E0A_4E0B_6587)
    local ____self_14 = _____4E0A_4E0B_6587["清理"]
    ____self_14["登记延迟回调"](____self_14, "教派剑士-黑洞强化普攻窗口", _____4E0A_4E0B_6587["黑洞强化普攻清除回调ID"])
    debugLogForce(
        "教派剑士-黑洞跨越",
        "强化普攻窗口激活",
        "bossHid=",
        GetHandleId(_____4E0A_4E0B_6587["Boss单位"]),
        "duration=",
        _____914D_7F6E["强化普攻窗口秒"]
    )
end
function _____7ED3_675F_9ED1_6D1E_8DE8_8D8A(_____72B6_6001, _____539F_56E0)
    if _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["已结束"] = true
    _____72B6_6001["阶段"] = "结束"
    _____6062_590D_9ED1_6D1E_5954_8DD1_5C5E_6027(_____72B6_6001)
    if _____72B6_6001["移动检查回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["移动检查回调ID"])
        _____72B6_6001["移动检查回调ID"] = 0
    end
    local _____9ED1_6D1E_5B9E_4F8B = _____72B6_6001["黑洞实例"]
    _____72B6_6001["黑洞实例"] = nil
    _____72B6_6001["黑洞单位"] = nil
    if _____9ED1_6D1E_5B9E_4F8B ~= nil then
        _____9ED1_6D1E_5B9E_4F8B["销毁"](_____9ED1_6D1E_5B9E_4F8B, "主动销毁")
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    if _____72B6_6001["Boss已隐藏"] and boss ~= nil and boss ~= 0 then
        ShowUnit(boss, true)
        _____79FB_9664_5355_4F4D_6682_505C(boss, _____9ED1_6D1E_6682_505C_6765_6E90)
        _____72B6_6001["Boss已隐藏"] = false
    end
    _____5173_95ED_541F_5531_6761(_____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]["读条通道"])
    if _____72B6_6001["上下文"]["黑洞状态"] == _____72B6_6001 then
        _____72B6_6001["上下文"]["黑洞状态"] = nil
    end
    debugLogForce(
        "教派剑士-黑洞跨越",
        "状态结束",
        "bossHid=",
        boss ~= nil and boss ~= 0 and GetHandleId(boss) or 0,
        "reason=",
        _____539F_56E0
    )
end
function ____on_9ED1_6D1EBoss_51FA_73B0(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] or not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(_____72B6_6001["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    ShowUnit(boss, true)
    _____79FB_9664_5355_4F4D_6682_505C(boss, _____9ED1_6D1E_6682_505C_6765_6E90)
    _____72B6_6001["Boss已隐藏"] = false
    _____6FC0_6D3B_9ED1_6D1E_5F3A_5316_666E_653B(_____72B6_6001["上下文"])
    _____64AD_653E_6559_6D3E_5251_58EB_53F0_8BCD(boss, "黑洞跨越")
    Sound3DII_CooPlayReuse(
        _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E["黑洞跨越"]["Boss出现"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E["音效裁断距离"]
    )
    local target = _____72B6_6001["出口目标"]
    local ____temp_15
    if target ~= nil and target ~= 0 and _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(target) then
        ____temp_15 = IssueTargetOrder(boss, "attack", target)
    else
        ____temp_15 = false
    end
    local _____5DF2_4E0B_8FBE_653B_51FB = ____temp_15
    debugLogForce(
        "教派剑士-黑洞跨越",
        "Boss出现并追击出口目标",
        "bossHid=",
        GetHandleId(boss),
        "targetHid=",
        target ~= nil and target ~= 0 and GetHandleId(target) or 0,
        "ordered=",
        _____5DF2_4E0B_8FBE_653B_51FB
    )
    _____7ED3_675F_9ED1_6D1E_8DE8_8D8A(_____72B6_6001, "成功穿越并出现")
end
function ____on_521B_5EFA_9ED1_6D1E_51FA_53E3(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] or not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(_____72B6_6001["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]
    local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
    _____72B6_6001["出口目标"] = target
    local X = _____72B6_6001["黑洞X"]
    local Y = _____72B6_6001["黑洞Y"]
    if target ~= nil and target ~= 0 and _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(target) then
        local behind = GetUnitFacing(target) + 180
        X = _____6781_5750_6807X(
            GetUnitX(target),
            behind,
            _____914D_7F6E["出口身后距离"]
        )
        Y = _____6781_5750_6807Y(
            GetUnitY(target),
            behind,
            _____914D_7F6E["出口身后距离"]
        )
        SetUnitFacing(
            boss,
            _____4E24_70B9_89D2_5EA6(
                X,
                Y,
                GetUnitX(target),
                GetUnitY(target)
            )
        )
    end
    _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(boss, X, Y)
    EC_CreateEffect(
        _____914D_7F6E["黑洞模型路径"],
        X,
        Y,
        0,
        0,
        _____914D_7F6E["黑洞缩放"],
        1,
        _____914D_7F6E["出口黑洞持续秒"]
    )
    _____72B6_6001["阶段"] = "出口等待"
    _____72B6_6001["出现回调ID"] = addDelayedCallback(_____914D_7F6E["出口等待秒"] * 1000, ____on_9ED1_6D1EBoss_51FA_73B0, _____72B6_6001)
    local ____self_16 = _____72B6_6001["上下文"]["清理"]
    ____self_16["登记延迟回调"](____self_16, "教派剑士-黑洞出现", _____72B6_6001["出现回调ID"])
    debugLogForce(
        "教派剑士-黑洞跨越",
        "出口创建",
        "bossHid=",
        GetHandleId(boss),
        "targetHid=",
        target ~= nil and target ~= 0 and GetHandleId(target) or 0,
        "x=",
        X,
        "y=",
        Y
    )
end
function _____5B89_6392_9ED1_6D1E_79FB_52A8_68C0_67E5(_____72B6_6001)
    if _____72B6_6001["已结束"] or _____72B6_6001["阶段"] ~= "奔跑" then
        return
    end
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]
    _____72B6_6001["移动检查回调ID"] = addDelayedCallback(_____914D_7F6E["移动检查间隔秒"] * 1000, ____on_9ED1_6D1E_79FB_52A8_68C0_67E5, _____72B6_6001)
    local ____self_17 = _____72B6_6001["上下文"]["清理"]
    ____self_17["登记延迟回调"](____self_17, "教派剑士-黑洞移动检查", _____72B6_6001["移动检查回调ID"])
end
function ____on_9ED1_6D1E_79FB_52A8_68C0_67E5(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] or _____72B6_6001["阶段"] ~= "奔跑" then
        return
    end
    _____72B6_6001["移动检查回调ID"] = 0
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    if not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) then
        _____7ED3_675F_9ED1_6D1E_8DE8_8D8A(_____72B6_6001, "Boss失效")
        return
    end
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]
    local _____5728_5165_53E3_5185 = _____8DDD_79BB_5E73_65B9XY(
        GetUnitX(boss),
        GetUnitY(boss),
        _____72B6_6001["黑洞X"],
        _____72B6_6001["黑洞Y"]
    ) <= _____914D_7F6E["黑洞进入距离"] * _____914D_7F6E["黑洞进入距离"]
    local ____temp_19 = _____72B6_6001["黑洞实例"] == nil
    if not ____temp_19 then
        local ____self_18 = _____72B6_6001["黑洞实例"]
        ____temp_19 = not ____self_18["是否存活"](____self_18)
    end
    if ____temp_19 then
        _____7ED3_675F_9ED1_6D1E_8DE8_8D8A(_____72B6_6001, "黑洞失效")
        return
    end
    if not _____5728_5165_53E3_5185 then
        IssuePointOrder(boss, "move", _____72B6_6001["黑洞X"], _____72B6_6001["黑洞Y"])
        _____5B89_6392_9ED1_6D1E_79FB_52A8_68C0_67E5(_____72B6_6001)
        return
    end
    _____6062_590D_9ED1_6D1E_5954_8DD1_5C5E_6027(_____72B6_6001)
    _____72B6_6001["阶段"] = "消失"
    Sound3DII_CooPlayReuse(
        _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E["黑洞跨越"]["进入黑洞"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E["音效裁断距离"]
    )
    local _____9ED1_6D1E_5B9E_4F8B = _____72B6_6001["黑洞实例"]
    _____72B6_6001["黑洞实例"] = nil
    _____72B6_6001["黑洞单位"] = nil
    _____9ED1_6D1E_5B9E_4F8B["销毁"](_____9ED1_6D1E_5B9E_4F8B, "主动销毁")
    _____6DFB_52A0_5355_4F4D_6682_505C(boss, _____9ED1_6D1E_6682_505C_6765_6E90)
    ShowUnit(boss, false)
    _____72B6_6001["Boss已隐藏"] = true
    _____72B6_6001["出口回调ID"] = addDelayedCallback(_____914D_7F6E["消失等待秒"] * 1000, ____on_521B_5EFA_9ED1_6D1E_51FA_53E3, _____72B6_6001)
    local ____self_20 = _____72B6_6001["上下文"]["清理"]
    ____self_20["登记延迟回调"](____self_20, "教派剑士-黑洞出口", _____72B6_6001["出口回调ID"])
    debugLogForce(
        "教派剑士-黑洞跨越",
        "成功进入黑洞并消失",
        "bossHid=",
        GetHandleId(boss),
        "wait=",
        _____914D_7F6E["消失等待秒"]
    )
end
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_2.addDelayedCallback
removeDelayedCallback = ____require_result_2.removeDelayedCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_3["开始硬直"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
_____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_5.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_5["移除单位指定Buff"]
local ____require_result_6 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_6["显示常规技能吟唱条"]
_____5173_95ED_541F_5531_6761 = ____require_result_6["关闭吟唱条"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_7.getUnitsInRange
local ____require_result_8 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_8["获取Boss技能随机敌对英雄"]
local ____require_result_9 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_9.YDUserDataGetSafe
YDUserDataSetSafe = ____require_result_9.YDUserDataSetSafe
local ____require_result_10 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
EC_CreateEffect = ____require_result_10.EC_CreateEffect
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_11.stringToFourCCSafe
local ____require_result_12 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
Sound3DII_CooPlayReuse = ____require_result_12.Sound3DII_CooPlayReuse
local ____require_result_13 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_13.debugLogForce
local jass = require("jass.common")
GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetRandomReal = jass.GetRandomReal
GetUnitFacing = jass.GetUnitFacing
local GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local SetUnitAnimation = jass.SetUnitAnimation
SetUnitFacing = jass.SetUnitFacing
ShowUnit = jass.ShowUnit
IssuePointOrder = jass.IssuePointOrder
IssueTargetOrder = jass.IssueTargetOrder
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
_____9ED1_6D1E_6682_505C_6765_6E90 = "Boss:教派剑士:黑洞跨越"
local _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____9ED1_6D1E_8DE8_8D8A_6280_80FDID = stringToFourCCSafe(_____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["黑洞跨越"])
local _____9ED1_6D1E_8DE8_8D8A_5DF2_6CE8_518C = false
local function _____6263_9664Boss_6700_5927_751F_547D_6BD4_4F8B(boss, ratio)
    _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664({
        ["目标"] = boss,
        ["数值"] = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(boss) * ratio,
        ["不致死"] = false,
        ["显示文字"] = false,
        ["显示特效"] = false
    })
end
local function ____on_9ED1_6D1E_8DE8_8D8A_6E05_7406(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 ~= nil then
        _____7ED3_675F_9ED1_6D1E_8DE8_8D8A(_____72B6_6001, "上下文清理")
    end
end
local function _____7ED3_7B97_9ED1_6D1E_6467_6BC1(_____72B6_6001, killer)
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    EC_CreateEffect(
        _____914D_7F6E["黑洞摧毁特效路径"],
        _____72B6_6001["黑洞X"],
        _____72B6_6001["黑洞Y"],
        0,
        0,
        _____914D_7F6E["黑洞摧毁特效缩放"],
        1,
        _____914D_7F6E["黑洞摧毁特效持续秒"]
    )
    Sound3DII_CooPlayReuse(
        _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E["黑洞跨越"]["黑洞被摧毁"],
        _____72B6_6001["黑洞X"],
        _____72B6_6001["黑洞Y"],
        0,
        _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E["音效裁断距离"]
    )
    local _____5355_4F4D_5217_8868 = getUnitsInRange(_____72B6_6001["黑洞X"], _____72B6_6001["黑洞Y"], _____914D_7F6E["摧毁爆炸半径"])
    local _____547D_4E2D_6570 = 0
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            local target = _____5355_4F4D_5217_8868[i + 1]
            local _____6BD4_4F8B = target == killer and _____914D_7F6E["摧毁者已损生命比例"] or _____914D_7F6E["普通目标已损生命比例"]
            local _____7ED3_679C = _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                ["来源"] = boss,
                ["目标"] = target,
                ["技能ID"] = _____9ED1_6D1E_8DE8_8D8A_6280_80FDID,
                ["伤害公式"] = {["目标已损生命比例"] = _____6BD4_4F8B},
                attack = false,
                ranged = false,
                attackType = ATTACK_TYPE_NORMAL,
                ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["标签"] = "教派剑士·黑洞摧毁"
            })
            if _____7ED3_679C["是否造成伤害"] then
                _____547D_4E2D_6570 = _____547D_4E2D_6570 + 1
            end
            if _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(target) then
                _____5F00_59CB_51B2_950B(
                    target,
                    {
                        ["主单位"] = boss,
                        ["角度"] = _____4E24_70B9_89D2_5EA6(
                            GetUnitX(target),
                            GetUnitY(target),
                            _____72B6_6001["黑洞X"],
                            _____72B6_6001["黑洞Y"]
                        ),
                        ["距离"] = _____914D_7F6E["吸引距离"],
                        ["持续时间"] = _____914D_7F6E["吸引持续秒"],
                        ["检查地形"] = true,
                        ["朝向跟随位移"] = false,
                        ["暂停单位"] = false
                    }
                )
            end
            i = i + 1
        end
    end
    debugLogForce(
        "教派剑士-黑洞跨越",
        "黑洞被玩家摧毁并结算",
        "bossHid=",
        GetHandleId(boss),
        "killerHid=",
        killer ~= nil and killer ~= 0 and GetHandleId(killer) or 0,
        "targetCount=",
        #_____5355_4F4D_5217_8868,
        "hitCount=",
        _____547D_4E2D_6570
    )
end
local function ____on_9ED1_6D1E_673A_5236_7ED3_675F(_unit, reason, killer, variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["黑洞实例"] = nil
    _____72B6_6001["黑洞单位"] = nil
    if reason == "被击杀" then
        _____6062_590D_9ED1_6D1E_5954_8DD1_5C5E_6027(_____72B6_6001)
        if killer ~= nil and killer ~= 0 then
            _____7ED3_7B97_9ED1_6D1E_6467_6BC1(_____72B6_6001, killer)
        end
        _____7ED3_675F_9ED1_6D1E_8DE8_8D8A(_____72B6_6001, "黑洞被击杀")
        return
    end
    if _____72B6_6001["阶段"] == "消失" or _____72B6_6001["阶段"] == "出口等待" then
        return
    end
    _____7ED3_675F_9ED1_6D1E_8DE8_8D8A(_____72B6_6001, reason == "自然到期" and "黑洞自然到期" or "黑洞提前结束")
end
local function ____on_5F00_59CB_9ED1_6D1E_5954_8DD1(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] or not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(_____72B6_6001["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]
    _____5173_95ED_541F_5531_6761(_____914D_7F6E["读条通道"])
    _____6263_9664Boss_6700_5927_751F_547D_6BD4_4F8B(boss, _____914D_7F6E["自损最大生命比例"])
    if not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) then
        _____7ED3_675F_9ED1_6D1E_8DE8_8D8A(_____72B6_6001, "自损后死亡")
        return
    end
    _____72B6_6001["黑洞实例"] = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = _____72B6_6001["上下文"]["清理"],
        ["名称"] = "教派剑士-黑洞入口",
        ["单位名称"] = "黑洞",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["模型路径"] = _____914D_7F6E["黑洞模型路径"],
        X = _____72B6_6001["黑洞X"],
        Y = _____72B6_6001["黑洞Y"],
        ["最大生命"] = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(boss) * _____914D_7F6E["黑洞最大生命比例"],
        ["固定站桩"] = true,
        ["禁止普攻"] = true,
        ["禁用路径"] = true,
        ["缩放"] = _____914D_7F6E["黑洞缩放"],
        ["持续时间"] = _____914D_7F6E["黑洞持续秒"],
        ["变量"] = _____72B6_6001,
        ["on结束"] = ____on_9ED1_6D1E_673A_5236_7ED3_675F
    })
    if _____72B6_6001["黑洞实例"] == nil then
        _____7ED3_675F_9ED1_6D1E_8DE8_8D8A(_____72B6_6001, "黑洞创建失败")
        return
    end
    _____72B6_6001["黑洞单位"] = _____72B6_6001["黑洞实例"]["单位"]
    _____72B6_6001["奔跑属性已应用"] = true
    _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027(boss, "闪避率", _____914D_7F6E["奔跑闪避加成"])
    _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027(boss, "眩晕抗性", -_____914D_7F6E["奔跑韧性降低"])
    registerManualBuff(
        boss,
        _____6559_6D3E_5251_58EBBuffID["黑洞奔袭"],
        _____914D_7F6E["黑洞持续秒"],
        0,
        {sourceUnit = boss, effectSourceName = "黑洞奔袭", effectSourceType = "技能"}
    )
    _____72B6_6001["阶段"] = "奔跑"
    local _____5DF2_4E0B_8FBE_79FB_52A8 = IssuePointOrder(boss, "move", _____72B6_6001["黑洞X"], _____72B6_6001["黑洞Y"])
    _____5B89_6392_9ED1_6D1E_79FB_52A8_68C0_67E5(_____72B6_6001)
    debugLogForce(
        "教派剑士-黑洞跨越",
        "黑洞创建并开始真实移动",
        "bossHid=",
        GetHandleId(boss),
        "holeHid=",
        GetHandleId(_____72B6_6001["黑洞单位"]),
        "ordered=",
        _____5DF2_4E0B_8FBE_79FB_52A8,
        "x=",
        _____72B6_6001["黑洞X"],
        "y=",
        _____72B6_6001["黑洞Y"]
    )
end
local function _____9ED1_6D1E_514B_5236_5C5E_6027_627F_4F24_4FEE_6B63(context)
    if context == nil or context.target == nil or context.target == 0 or context.isFireDamage ~= true and context.isLightDamage ~= true then
        local ____opt_result_23
        if context ~= nil then
            ____opt_result_23 = context.currentDamage
        end
        local ____opt_result_23_24 = ____opt_result_23
        if ____opt_result_23_24 == nil then
            ____opt_result_23_24 = 0
        end
        return ____opt_result_23_24
    end
    local _____4E0A_4E0B_6587_5217_8868 = _____83B7_53D6_5168_90E8_6559_6D3E_5251_58EB_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #_____4E0A_4E0B_6587_5217_8868 do
            local _____72B6_6001 = _____4E0A_4E0B_6587_5217_8868[i + 1]["黑洞状态"]
            if _____72B6_6001 ~= nil and not _____72B6_6001["已结束"] and _____72B6_6001["黑洞单位"] == context.target then
                local after = context.currentDamage * _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]["克制属性承伤倍率"]
                debugLogForce(
                    "教派剑士-黑洞跨越",
                    "黑洞受到火/光克制增伤",
                    "holeHid=",
                    GetHandleId(context.target),
                    "before=",
                    context.currentDamage,
                    "after=",
                    after
                )
                return after
            end
            i = i + 1
        end
    end
    return context.currentDamage
end
____exports["释放教派剑士黑洞跨越"] = function(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) or _____4E0A_4E0B_6587["黑洞状态"] ~= nil then
        return false
    end
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]
    local _____65B9_5411 = GetRandomReal(0, 360)
    local _____72B6_6001 = {
        ["已结束"] = false,
        ["上下文"] = _____4E0A_4E0B_6587,
        ["阶段"] = "前摇",
        ["黑洞X"] = _____6781_5750_6807X(
            GetUnitX(boss),
            _____65B9_5411,
            _____914D_7F6E["黑洞生成距离"]
        ),
        ["黑洞Y"] = _____6781_5750_6807Y(
            GetUnitY(boss),
            _____65B9_5411,
            _____914D_7F6E["黑洞生成距离"]
        ),
        ["移动检查回调ID"] = 0,
        ["奔跑属性已应用"] = false,
        ["Boss已隐藏"] = false,
        ["启动回调ID"] = 0,
        ["出口回调ID"] = 0,
        ["出现回调ID"] = 0
    }
    _____4E0A_4E0B_6587["黑洞状态"] = _____72B6_6001
    local ____self_27 = _____4E0A_4E0B_6587["清理"]
    ____self_27["登记清理"](____self_27, "教派剑士-黑洞跨越清理", ____on_9ED1_6D1E_8DE8_8D8A_6E05_7406, _____72B6_6001)
    _____5F00_59CB_786C_76F4(boss, _____914D_7F6E["施法硬直秒"])
    SetUnitAnimation(boss, _____914D_7F6E["动作名"])
    Sound3DII_CooPlayReuse(
        _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E["黑洞跨越"]["黑洞开启"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E["音效裁断距离"]
    )
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____914D_7F6E["施法硬直秒"],
        ["颜色ID"] = _____914D_7F6E["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
    _____72B6_6001["启动回调ID"] = addDelayedCallback(_____914D_7F6E["施法硬直秒"] * 1000, ____on_5F00_59CB_9ED1_6D1E_5954_8DD1, _____72B6_6001)
    local ____self_28 = _____4E0A_4E0B_6587["清理"]
    ____self_28["登记延迟回调"](____self_28, "教派剑士-黑洞奔跑开始", _____72B6_6001["启动回调ID"])
    debugLogForce(
        "教派剑士-黑洞跨越",
        "施法前摇开始",
        "bossHid=",
        GetHandleId(boss),
        "holeX=",
        _____72B6_6001["黑洞X"],
        "holeY=",
        _____72B6_6001["黑洞Y"]
    )
    return true
end
local function ____on_6559_6D3E_5251_58EB_9ED1_6D1E_8DE8_8D8A_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____9ED1_6D1E_8DE8_8D8A_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587(castingUnit)
    local _____5DF2_5F00_59CB = _____4E0A_4E0B_6587 ~= nil and ____exports["释放教派剑士黑洞跨越"](_____4E0A_4E0B_6587)
    debugLogForce(
        "教派剑士-黑洞跨越",
        "正式SPELL_EFFECT入口",
        "bossHid=",
        GetHandleId(castingUnit),
        "started=",
        _____5DF2_5F00_59CB
    )
end
____exports["注册教派剑士黑洞跨越"] = function()
    if _____9ED1_6D1E_8DE8_8D8A_5DF2_6CE8_518C then
        return
    end
    _____9ED1_6D1E_8DE8_8D8A_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_6559_6D3E_5251_58EB_9ED1_6D1E_8DE8_8D8A_751F_6548)
    registerDamageModifier(_____9ED1_6D1E_514B_5236_5C5E_6027_627F_4F24_4FEE_6B63, 8)
    debugLogForce("教派剑士-黑洞跨越", "技能壳与黑洞克制承伤监听注册完成", "skillId=", _____9ED1_6D1E_8DE8_8D8A_6280_80FDID)
end
return ____exports
