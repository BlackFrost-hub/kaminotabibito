local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_602A_53EB, _____8FDB_5165_65E0_4ECE_66B4_6012, _____9000_51FA_65E0_4ECE_66B4_6012, _____6E05_9664_517D_7FA4_653B_51FB_529B_52A0_6210, _____5237_65B0_517D_7FA4_653B_51FB_529B_52A0_6210, _____5237_65B0_968F_4ECE_72B6_6001, GetUnitX, GetUnitY, GetUnitDefaultMoveSpeed, AddSpecialEffectTarget, DestroyEffect, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____6811_9B54_9996_9886BuffID, SGSS_SetState, _____653B_51FB_529B_5C5E_6027ID, _____653B_901F_5C5E_6027ID, _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.00．配置")
local _____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["树魔首领单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.01．运行时上下文")
local _____83B7_53D6_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取树魔首领上下文"]
local _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建树魔首领上下文"]
local _____83B7_53D6_5168_90E8_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部树魔首领上下文"]
local _____6E05_7406_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清理树魔首领上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.02．数值与表现配置")
local _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔首领数值与表现配置"]
local _____6811_9B54_9996_9886_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔首领音效配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.08．台词播放")
local _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放树魔首领台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_53E5_67C4_5B58_5728 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位句柄存在"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____6CBB_7597_6CE2_8DF3_94FE = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.治疗波跳链")
local _____53D1_8D77_6CBB_7597_6CE2_8DF3_94FE = _____6CBB_7597_6CE2_8DF3_94FE["发起治疗波跳链"]
local _____5145_80FD_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = _____5145_80FD_7CFB_7EDF["开始充能"]
function _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_602A_53EB(boss, _____89E6_53D1_6982_7387_767E_5206_6BD4)
    local soundCfg = _____6811_9B54_9996_9886_97F3_6548_914D_7F6E
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = soundCfg["怪物拟声"]["标识"],
        ["音效路径列表"] = soundCfg["怪物拟声"]["音效路径列表"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["裁断距离"] = soundCfg["默认裁断距离"],
        ["冷却Ms"] = soundCfg["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = _____89E6_53D1_6982_7387_767E_5206_6BD4
    })
end
function _____8FDB_5165_65E0_4ECE_66B4_6012(context)
    if context["无从暴怒中"] then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    context["无从暴怒中"] = true
    context["暴怒攻速增量"] = cfg["无小弟攻速提高"]
    context["暴怒移速增量"] = GetUnitDefaultMoveSpeed(context["Boss单位"]) * cfg["无小弟移速提高"]
    SGSS_SetState(context["Boss单位"], _____653B_901F_5C5E_6027ID, context["暴怒攻速增量"])
    SGSS_SetState(context["Boss单位"], _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID, context["暴怒移速增量"])
    context["暴怒持续特效"] = AddSpecialEffectTarget(cfg["暴怒持续特效路径"], context["Boss单位"], "origin")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["随从特性"]["无从暴怒"],
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_602A_53EB(context["Boss单位"], _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["怪物拟声"]["暴怒触发概率百分比"])
end
function _____9000_51FA_65E0_4ECE_66B4_6012(context)
    if not context["无从暴怒中"] then
        return
    end
    context["无从暴怒中"] = false
    if context["暴怒持续特效"] ~= nil and context["暴怒持续特效"] ~= 0 then
        DestroyEffect(context["暴怒持续特效"])
    end
    context["暴怒持续特效"] = nil
    if context["暴怒攻速增量"] ~= 0 then
        SGSS_SetState(context["Boss单位"], _____653B_901F_5C5E_6027ID, -context["暴怒攻速增量"])
    end
    if context["暴怒移速增量"] ~= 0 then
        SGSS_SetState(context["Boss单位"], _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID, -context["暴怒移速增量"])
    end
    context["暴怒攻速增量"] = 0
    context["暴怒移速增量"] = 0
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____6811_9B54_9996_9886BuffID["无从暴怒"])
end
function _____6E05_9664_517D_7FA4_653B_51FB_529B_52A0_6210(context)
    local applied = context["兽群攻击力增量"]
    if applied ~= 0 and _____5355_4F4D_53E5_67C4_5B58_5728(context["Boss单位"]) then
        SGSS_SetState(context["Boss单位"], _____653B_51FB_529B_5C5E_6027ID, -applied)
    end
    context["兽群攻击力增量"] = 0
end
function _____5237_65B0_517D_7FA4_653B_51FB_529B_52A0_6210(context)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    local rawRatio = context["当前兽群层数"] * cfg["每个小弟攻击提高"]
    local ratio = rawRatio < cfg["最高攻击提高"] and rawRatio or cfg["最高攻击提高"]
    local currentAttack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["Boss单位"])
    local attackWithoutPack = currentAttack - context["兽群攻击力增量"]
    local baseAttack = attackWithoutPack > 0 and attackWithoutPack or 0
    local nextBonus = baseAttack * ratio
    local delta = nextBonus - context["兽群攻击力增量"]
    if delta > 0.001 or delta < -0.001 then
        SGSS_SetState(context["Boss单位"], _____653B_51FB_529B_5C5E_6027ID, delta)
    end
    context["兽群攻击力增量"] = nextBonus
end
function _____5237_65B0_968F_4ECE_72B6_6001(context)
    if not _____5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        _____6E05_7406_6811_9B54_9996_9886_4E0A_4E0B_6587(context["Boss单位"])
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    local ____self_15 = context["随从组"]
    local count = ____self_15["取存活数量"](____self_15)
    context["当前随从数量"] = count
    context["当前兽群层数"] = count < cfg["兽群最高层数"] and count or cfg["兽群最高层数"]
    _____5237_65B0_517D_7FA4_653B_51FB_529B_52A0_6210(context)
    if count > 0 then
        _____9000_51FA_65E0_4ECE_66B4_6012(context)
        registerManualBuff(
            context["Boss单位"],
            _____6811_9B54_9996_9886BuffID["兽群号令"],
            cfg["兽群Buff刷新秒"],
            context["当前兽群层数"],
            {sourceName = "树魔首领", stack = context["当前兽群层数"]}
        )
    else
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____6811_9B54_9996_9886BuffID["兽群号令"])
        _____8FDB_5165_65E0_4ECE_66B4_6012(context)
        registerManualBuff(
            context["Boss单位"],
            _____6811_9B54_9996_9886BuffID["无从暴怒"],
            cfg["暴怒Buff刷新秒"],
            1,
            {sourceName = "树魔首领"}
        )
    end
end
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local jglobals = require("jass.globals")
local GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local GetUnitFacing = jass.GetUnitFacing
GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed
local GetOwningPlayer = jass.GetOwningPlayer
local GetRandomReal = jass.GetRandomReal
local GetRandomInt = jass.GetRandomInt
local GetUnitState = jass.GetUnitState
AddSpecialEffectTarget = jass.AddSpecialEffectTarget
DestroyEffect = jass.DestroyEffect
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_2.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.04．树魔首领")
_____6811_9B54_9996_9886BuffID = ____require_result_3["树魔首领BuffID"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.00．SGSS")
SGSS_SetState = ____require_result_4.SGSS_SetState
local ____require_result_5 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_5.CosBJ
local SinBJ = ____require_result_5.SinBJ
local ____require_result_6 = require("系统.01．单位系统.10．护卫系统.index")
local _____521B_5EFA_62A4_536B_5355_4F4D = ____require_result_6["创建护卫单位"]
local _____83B7_53D6Boss_62A4_536B_5217_8868 = ____require_result_6["获取Boss护卫列表"]
local _____662F_5426_6307_5B9ABoss_62A4_536B = ____require_result_6["是否指定Boss护卫"]
local _____5904_7406Boss_7ED3_675F_5168_90E8_62A4_536B = ____require_result_6["处理Boss结束全部护卫"]
_____653B_51FB_529B_5C5E_6027ID = 1
_____653B_901F_5C5E_6027ID = 10
_____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID = 9
local _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____730E_5934_8005_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["召唤物ID"]["猎头者"])
local _____5DEB_533B_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["召唤物ID"]["巫医"])
local _____6295_63B7_8005_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["召唤物ID"]["投掷者"])
local _____6811_9B54_9996_9886_968F_4ECE_7279_6027_5DF2_6CE8_518C = false
local function _____662F_6811_9B54_9996_9886(unit)
    return _____5355_4F4D_5B58_6D3B(unit) and GetUnitTypeId(unit) == _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID
end
local function _____5355_4F4D_7C7B_578B_662F_6811_9B54_9996_9886(unit)
    return _____5355_4F4D_53E5_67C4_5B58_5728(unit) and GetUnitTypeId(unit) == _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID
end
local function _____7EDF_8BA1_6811_9B54_968F_4ECE(context)
    local result = {["猎头者"] = 0, ["巫医"] = 0, ["投掷者"] = 0}
    local ____self_7 = context["随从组"]
    local list = ____self_7["取单位列表"](____self_7)
    do
        local i = 0
        while i < #list do
            do
                local unit = list[i + 1]
                if not _____5355_4F4D_5B58_6D3B(unit) then
                    goto __continue6
                end
                local typeId = GetUnitTypeId(unit)
                if typeId == _____730E_5934_8005_5355_4F4D_7C7B_578BID then
                    result["猎头者"] = result["猎头者"] + 1
                elseif typeId == _____5DEB_533B_5355_4F4D_7C7B_578BID then
                    result["巫医"] = result["巫医"] + 1
                elseif typeId == _____6295_63B7_8005_5355_4F4D_7C7B_578BID then
                    result["投掷者"] = result["投掷者"] + 1
                end
            end
            ::__continue6::
            i = i + 1
        end
    end
    return result
end
local function _____8BA1_7B97_968F_4ECE_53EC_5524_70B9(boss, _____7F16_5236, _____69FD_4F4D_5E8F_53F7)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    local _____5C45_4E2D_69FD_4F4D = _____69FD_4F4D_5E8F_53F7 - (_____7F16_5236["数量"] - 1) * 0.5
    local angle = GetUnitFacing(boss) + _____7F16_5236["相对Boss朝向角度"] + _____5C45_4E2D_69FD_4F4D * _____7F16_5236["槽位间隔角度"] + GetRandomReal(-cfg["召唤角度抖动"], cfg["召唤角度抖动"])
    return {
        x = GetUnitX(boss) + CosBJ(angle) * _____7F16_5236["召唤距离"],
        y = GetUnitY(boss) + SinBJ(angle) * _____7F16_5236["召唤距离"]
    }
end
local function _____83B7_53D6_6811_9B54_968F_4ECE_62A4_536B_7C7B_578B(unitTypeId)
    if unitTypeId == _____730E_5934_8005_5355_4F4D_7C7B_578BID then
        return "树魔首领:猎头者"
    end
    if unitTypeId == _____5DEB_533B_5355_4F4D_7C7B_578BID then
        return "树魔首领:巫医"
    end
    if unitTypeId == _____6295_63B7_8005_5355_4F4D_7C7B_578BID then
        return "树魔首领:投掷者"
    end
    return "树魔首领:随从"
end
local function _____83B7_53D6_6811_9B54_968F_4ECE_8840_6761_4F18_5148_7EA7(unitTypeId)
    local priorities = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]["血条优先级"]
    if unitTypeId == _____6295_63B7_8005_5355_4F4D_7C7B_578BID then
        return priorities["投掷者"]
    end
    if unitTypeId == _____5DEB_533B_5355_4F4D_7C7B_578BID then
        return priorities["巫医"]
    end
    if unitTypeId == _____730E_5934_8005_5355_4F4D_7C7B_578BID then
        return priorities["猎头者"]
    end
    return 0
end
local function _____53EC_5524_6811_9B54_968F_4ECE(context, unitTypeId, _____7F16_5236, _____69FD_4F4D_5E8F_53F7)
    local boss = context["Boss单位"]
    local _____70B9 = _____8BA1_7B97_968F_4ECE_53EC_5524_70B9(boss, _____7F16_5236, _____69FD_4F4D_5E8F_53F7)
    local minion = _____521B_5EFA_62A4_536B_5355_4F4D({
        ["主Boss单位"] = boss,
        ["护卫类型"] = _____83B7_53D6_6811_9B54_968F_4ECE_62A4_536B_7C7B_578B(unitTypeId),
        ["护卫血条优先级"] = _____83B7_53D6_6811_9B54_968F_4ECE_8840_6761_4F18_5148_7EA7(unitTypeId),
        ["标记为召唤单位"] = true,
        ["Boss结束处理"] = "移除",
        ["单位类型"] = unitTypeId,
        ["所属玩家"] = GetOwningPlayer(boss),
        X = _____70B9.x,
        Y = _____70B9.y,
        ["面向"] = GetUnitFacing(boss)
    })
    if minion == nil or minion == 0 then
        return nil
    end
    local ____self_8 = context["随从组"]
    ____self_8["登记"](____self_8, minion)
    return minion
end
local function _____968F_673A_53D6_97F3_6548_8DEF_5F84(list)
    if #list <= 0 then
        return ""
    end
    return list[GetRandomInt(0, #list - 1) + 1]
end
local function _____53D6_5355_4F4D_7F3A_8840_6BD4_4F8B(unit)
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return 0
    end
    local maxLife = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return 0
    end
    local currentLife = GetUnitState(unit, UNIT_STATE_LIFE)
    local ratio = (maxLife - currentLife) / maxLife
    return ratio > 0 and ratio or 0
end
local function _____9009_62E9_5DEB_533B_6CBB_7597_76EE_6807(context)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    local boss = context["Boss单位"]
    local bossMissingRatio = _____53D6_5355_4F4D_7F3A_8840_6BD4_4F8B(boss)
    if bossMissingRatio >= cfg["巫医优先治疗Boss缺血比例"] then
        return boss
    end
    local list = _____83B7_53D6Boss_62A4_536B_5217_8868(boss, true)
    local target = nil
    local highestMissingRatio = 0
    do
        local i = 0
        while i < #list do
            local minion = list[i + 1]
            local missingRatio = _____53D6_5355_4F4D_7F3A_8840_6BD4_4F8B(minion)
            if missingRatio > highestMissingRatio then
                target = minion
                highestMissingRatio = missingRatio
            end
            i = i + 1
        end
    end
    if target ~= nil then
        return target
    end
    local ____temp_9
    if bossMissingRatio > 0 then
        ____temp_9 = boss
    else
        ____temp_9 = nil
    end
    return ____temp_9
end
local function _____53D1_8D77_6811_9B54_5DEB_533B_7597_6CE2(context, witchDoctor)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    local boss = context["Boss单位"]
    local target = _____9009_62E9_5DEB_533B_6CBB_7597_76EE_6807(context)
    if target == nil or target == 0 then
        return
    end
    local healAmount = GetUnitStateJapi(context["Boss单位"], UNIT_STATE_MAX_LIFE) * cfg["巫医疗波Boss最大生命比例"]
    local function _____6811_9B54_5DEB_533B_7597_6CE2_76EE_6807_7B5B_9009(unit)
        if not _____5355_4F4D_5B58_6D3B(unit) or _____53D6_5355_4F4D_7F3A_8840_6BD4_4F8B(unit) <= 0 then
            return false
        end
        return unit == boss or _____662F_5426_6307_5B9ABoss_62A4_536B(unit, boss)
    end
    _____53D1_8D77_6CBB_7597_6CE2_8DF3_94FE({
        ["起始目标"] = target,
        ["来源单位"] = witchDoctor,
        ["最大跳数"] = cfg["巫医疗波最大目标数"],
        ["初始治疗量"] = healAmount,
        ["影响目标"] = "友方",
        ["每跳最大距离"] = cfg["巫医疗波每跳最大距离"],
        ["每跳衰减系数"] = cfg["巫医疗波每跳衰减系数"],
        ["允许重复治疗"] = false,
        ["跳跃间隔"] = cfg["巫医疗波跳跃间隔秒"],
        ["闪电效果代码"] = "HWPB",
        ["目标筛选"] = _____6811_9B54_5DEB_533B_7597_6CE2_76EE_6807_7B5B_9009
    })
end
local _____6811_9B54_5DEB_533B_6CBB_7597_5145_80FD_8BB0_5F55_8868 = {}
local function _____9762_5411_6811_9B54_5DEB_533B_6CBB_7597_76EE_6807(witchDoctor, target)
    if not _____5355_4F4D_5B58_6D3B(witchDoctor) or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    SetUnitFacing(
        witchDoctor,
        _____4E24_70B9_89D2_5EA6(
            GetUnitX(witchDoctor),
            GetUnitY(witchDoctor),
            GetUnitX(target),
            GetUnitY(target)
        )
    )
end
local function _____6811_9B54_5DEB_533B_6CBB_7597_5145_80FD_5F00_59CB(witchDoctor, ______5145_80FDID)
    if not _____5355_4F4D_5B58_6D3B(witchDoctor) then
        return
    end
    SetUnitTimeScale(witchDoctor, 1)
    SetUnitAnimation(witchDoctor, "spell")
end
local function _____6811_9B54_5DEB_533B_6CBB_7597_5145_80FD_5B8C_6210(witchDoctor, _____5145_80FDID)
    local _____8BB0_5F55 = _____6811_9B54_5DEB_533B_6CBB_7597_5145_80FD_8BB0_5F55_8868[_____5145_80FDID]
    __TS__Delete(_____6811_9B54_5DEB_533B_6CBB_7597_5145_80FD_8BB0_5F55_8868, _____5145_80FDID)
    if _____8BB0_5F55 == nil then
        return
    end
    _____9762_5411_6811_9B54_5DEB_533B_6CBB_7597_76EE_6807(witchDoctor, _____8BB0_5F55.target)
    if _____5355_4F4D_5B58_6D3B(witchDoctor) and _____5355_4F4D_5B58_6D3B(_____8BB0_5F55.context["Boss单位"]) then
        _____53D1_8D77_6811_9B54_5DEB_533B_7597_6CE2(_____8BB0_5F55.context, witchDoctor)
    end
end
local function _____6811_9B54_5DEB_533B_6CBB_7597_5145_80FD_7ED3_675F(witchDoctor, ______539F_56E0, _____5145_80FDID)
    __TS__Delete(_____6811_9B54_5DEB_533B_6CBB_7597_5145_80FD_8BB0_5F55_8868, _____5145_80FDID)
    if not _____5355_4F4D_5B58_6D3B(witchDoctor) then
        return
    end
    SetUnitTimeScale(witchDoctor, 1)
    SetUnitAnimationByIndex(witchDoctor, 0)
end
local function _____542F_52A8_5DEB_533B_6CBB_7597_6CE2_65BD_6CD5(context, witchDoctor, target)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    local _____65BD_6CD5_786C_76F4_79D2 = cfg["巫医疗波施法硬直秒"]
    _____9762_5411_6811_9B54_5DEB_533B_6CBB_7597_76EE_6807(witchDoctor, target)
    local _____5145_80FDID = _____5F00_59CB_5145_80FD(witchDoctor, {
        ["持续时间"] = _____65BD_6CD5_786C_76F4_79D2,
        ["主单位"] = context["Boss单位"],
        ["主单位死亡时中断"] = true,
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["进度条特效动画序号"] = 0,
        ["进度条特效动画速度"] = _____65BD_6CD5_786C_76F4_79D2 > 0 and 1 / _____65BD_6CD5_786C_76F4_79D2 or 1,
        ["开始回调"] = _____6811_9B54_5DEB_533B_6CBB_7597_5145_80FD_5F00_59CB,
        ["充能完成回调"] = _____6811_9B54_5DEB_533B_6CBB_7597_5145_80FD_5B8C_6210,
        ["结束回调"] = _____6811_9B54_5DEB_533B_6CBB_7597_5145_80FD_7ED3_675F
    })
    if _____5145_80FDID > 0 then
        _____6811_9B54_5DEB_533B_6CBB_7597_5145_80FD_8BB0_5F55_8868[_____5145_80FDID] = {context = context, target = target}
    end
end
local function _____542F_52A8_5DEB_533B_6CBB_7597_9A71_52A8(context, witchDoctor)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    local _____4E0B_4E00_6B21_6CBB_7597Ms = getServerTime() + cfg["巫医疗波首次延迟秒"] * 1000
    local healId = 0
    healId = addPeriodicCallback(
        cfg["巫医治疗检测间隔秒"] * 1000,
        function()
            if not _____5355_4F4D_5B58_6D3B(witchDoctor) or not _____5355_4F4D_5B58_6D3B(context["Boss单位"]) then
                removePeriodicCallback(healId)
                return
            end
            local now = getServerTime()
            if now < _____4E0B_4E00_6B21_6CBB_7597Ms then
                return
            end
            local target = _____9009_62E9_5DEB_533B_6CBB_7597_76EE_6807(context)
            if target == nil or target == 0 then
                return
            end
            _____4E0B_4E00_6B21_6CBB_7597Ms = now + cfg["巫医疗波冷却秒"] * 1000
            _____542F_52A8_5DEB_533B_6CBB_7597_6CE2_65BD_6CD5(context, witchDoctor, target)
        end
    )
    local ____self_10 = context["清理"]
    ____self_10["登记周期回调"](____self_10, "树魔巫医治疗", healId)
end
____exports["测试触发树魔巫医疗波"] = function(context)
    if not _____5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        return false
    end
    local target = _____9009_62E9_5DEB_533B_6CBB_7597_76EE_6807(context)
    if target == nil or target == 0 then
        return false
    end
    local ____self_11 = context["随从组"]
    local list = ____self_11["取单位列表"](____self_11)
    do
        local i = 0
        while i < #list do
            do
                local witchDoctor = list[i + 1]
                if not _____5355_4F4D_5B58_6D3B(witchDoctor) or GetUnitTypeId(witchDoctor) ~= _____5DEB_533B_5355_4F4D_7C7B_578BID then
                    goto __continue58
                end
                _____542F_52A8_5DEB_533B_6CBB_7597_6CE2_65BD_6CD5(context, witchDoctor, target)
                return true
            end
            ::__continue58::
            i = i + 1
        end
    end
    return false
end
local function _____8865_5145_6307_5B9A_7C7B_578B_968F_4ECE(context, unitTypeId, _____5F53_524D_6570_91CF, _____7F16_5236)
    local created = 0
    do
        local i = _____5F53_524D_6570_91CF
        while i < _____7F16_5236["数量"] do
            do
                local minion = _____53EC_5524_6811_9B54_968F_4ECE(context, unitTypeId, _____7F16_5236, i)
                if minion == nil or minion == 0 then
                    goto __continue62
                end
                created = created + 1
                if unitTypeId == _____5DEB_533B_5355_4F4D_7C7B_578BID then
                    _____542F_52A8_5DEB_533B_6CBB_7597_9A71_52A8(context, minion)
                end
            end
            ::__continue62::
            i = i + 1
        end
    end
    return created
end
local function _____8865_5145_6811_9B54_968F_4ECE_7F16_5236(context)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    local counts = _____7EDF_8BA1_6811_9B54_968F_4ECE(context)
    local created = 0
    created = created + _____8865_5145_6307_5B9A_7C7B_578B_968F_4ECE(context, _____730E_5934_8005_5355_4F4D_7C7B_578BID, counts["猎头者"], cfg["编制"]["猎头者"])
    created = created + _____8865_5145_6307_5B9A_7C7B_578B_968F_4ECE(context, _____5DEB_533B_5355_4F4D_7C7B_578BID, counts["巫医"], cfg["编制"]["巫医"])
    created = created + _____8865_5145_6307_5B9A_7C7B_578B_968F_4ECE(context, _____6295_63B7_8005_5355_4F4D_7C7B_578BID, counts["投掷者"], cfg["编制"]["投掷者"])
    if created <= 0 then
        return 0
    end
    local soundCfg = _____6811_9B54_9996_9886_97F3_6548_914D_7F6E
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____968F_673A_53D6_97F3_6548_8DEF_5F84(soundCfg["随从特性"]["召唤号令列表"]),
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        soundCfg["默认裁断距离"]
    )
    _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_602A_53EB(context["Boss单位"], soundCfg["怪物拟声"]["召唤触发概率百分比"])
    _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD(context["Boss单位"], "随从特性")
    return created
end
____exports["初始化树魔首领随从特性"] = function(context)
    if context["随从特性已初始化"] or not _____5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    context["随从特性已初始化"] = true
    local boss = context["Boss单位"]
    local ____self_12 = context["清理"]
    ____self_12["登记清理"](
        ____self_12,
        "树魔首领-护卫登记清理",
        function()
            _____5904_7406Boss_7ED3_675F_5168_90E8_62A4_536B(boss)
        end
    )
    local ____self_13 = context["清理"]
    ____self_13["登记清理"](
        ____self_13,
        "树魔首领-兽群攻击力回滚",
        function()
            _____6E05_9664_517D_7FA4_653B_51FB_529B_52A0_6210(context)
        end
    )
    local ____self_14 = context["清理"]
    ____self_14["登记清理"](
        ____self_14,
        "树魔首领-无从暴怒清理",
        function()
            _____9000_51FA_65E0_4ECE_66B4_6012(context)
        end
    )
    if cfg["初始召唤延迟秒"] <= 0 then
        _____8865_5145_6811_9B54_968F_4ECE_7F16_5236(context)
        context["下一次召唤Ms"] = getServerTime() + cfg["补员间隔秒"] * 1000
    else
        context["下一次召唤Ms"] = getServerTime() + cfg["初始召唤延迟秒"] * 1000
    end
    _____5237_65B0_968F_4ECE_72B6_6001(context)
end
____exports["立即补充树魔首领随从"] = function(context)
    if not _____5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        return 0
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    context["随从特性已初始化"] = true
    local created = _____8865_5145_6811_9B54_968F_4ECE_7F16_5236(context)
    context["下一次召唤Ms"] = getServerTime() + cfg["补员间隔秒"] * 1000
    _____5237_65B0_968F_4ECE_72B6_6001(context)
    return created
end
local function ____on_6811_9B54_9996_9886_6B7B_4EA1(dyingUnit)
    if not _____5355_4F4D_7C7B_578B_662F_6811_9B54_9996_9886(dyingUnit) then
        return
    end
    local context = _____83B7_53D6_6811_9B54_9996_9886_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____9000_51FA_65E0_4ECE_66B4_6012(context)
    end
    _____6E05_7406_6811_9B54_9996_9886_4E0A_4E0B_6587(dyingUnit)
end
local function _____6811_9B54_9996_9886_968F_4ECE_7279_6027Tick()
    local currentBoss = jglobals.udg_Boss
    if _____662F_6811_9B54_9996_9886(currentBoss) then
        local context = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587(currentBoss)
        if context ~= nil then
            ____exports["初始化树魔首领随从特性"](context)
        end
    end
    local now = getServerTime()
    local list = _____83B7_53D6_5168_90E8_6811_9B54_9996_9886_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #list do
            do
                local context = list[i + 1]
                if context == nil then
                    goto __continue98
                end
                if context["随从特性已初始化"] and context["下一次召唤Ms"] > 0 and now >= context["下一次召唤Ms"] then
                    _____8865_5145_6811_9B54_968F_4ECE_7F16_5236(context)
                    context["下一次召唤Ms"] = now + _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]["补员间隔秒"] * 1000
                end
                _____5237_65B0_968F_4ECE_72B6_6001(context)
            end
            ::__continue98::
            i = i + 1
        end
    end
end
____exports["注册树魔首领随从特性"] = function()
    if _____6811_9B54_9996_9886_968F_4ECE_7279_6027_5DF2_6CE8_518C then
        return
    end
    _____6811_9B54_9996_9886_968F_4ECE_7279_6027_5DF2_6CE8_518C = true
    registerDeathListener(____on_6811_9B54_9996_9886_6B7B_4EA1)
    addPeriodicCallback(_____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]["追随刷新间隔毫秒"], _____6811_9B54_9996_9886_968F_4ECE_7279_6027Tick)
end
return ____exports
