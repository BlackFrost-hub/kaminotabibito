local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_6708_5149_704C_6CE8Key, _____56DE_6EDA_6708_5149_704C_6CE8_72B6_6001, ____on_6708_5149_704C_6CE8Buff_79FB_9664, _____64AD_653E_795E_7F5A_7279_6548, _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_704C_6CE8, _____7ED3_7B97_745F_5170_8FEA_5C14_7CBE_7075_795E_7F5A, addDelayedCallback, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, SGSS_SetState, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____5BF9_5355_4F4D_9020_6210_5F3A_5316_4F24_5BB3, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761, _____5173_95ED_541F_5531_6761, _____521B_5EFA_70B9_7279_6548, Sound3DII_CooPlayReuse, GetUnitState, GetUnitName, GetUnitX, GetUnitY, SetUnitScale, GetUnitDefaultMoveSpeed, R2I, UNIT_STATE_MAX_LIFE, _____653B_51FB_529B_5C5E_6027ID, _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID, _____6708_5149_704C_6CE8_72B6_6001_8868, _____5F53_524D_6708_5149_704C_6CE8Boss
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.15．台词播放")
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
function _____53D6_6708_5149_704C_6CE8Key(unit)
    if unit == nil or unit == 0 then
        return ""
    end
    return tostring(_____53D6_5355_4F4DID(unit)
    )
end
function _____56DE_6EDA_6708_5149_704C_6CE8_72B6_6001(unit)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光灌注"]
    local key = _____53D6_6708_5149_704C_6CE8Key(unit)
    if key == "" then
        return
    end
    local state = _____6708_5149_704C_6CE8_72B6_6001_8868[key]
    __TS__Delete(_____6708_5149_704C_6CE8_72B6_6001_8868, key)
    if state == nil then
        return
    end
    SGSS_SetState(unit, _____653B_51FB_529B_5C5E_6027ID, -state["攻击力"])
    SGSS_SetState(unit, _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID, state["移速扣减"])
    SetUnitScale(unit, config["基础模型缩放"], config["基础模型缩放"], config["基础模型缩放"])
    if _____5F53_524D_6708_5149_704C_6CE8Boss == unit then
        _____5F53_524D_6708_5149_704C_6CE8Boss = nil
    end
end
function ____on_6708_5149_704C_6CE8Buff_79FB_9664(unit, _buffID, _row)
    if unit == nil or unit == 0 then
        return
    end
    _____56DE_6EDA_6708_5149_704C_6CE8_72B6_6001(unit)
end
function _____64AD_653E_795E_7F5A_7279_6548(x, y)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光灌注"]
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = config["神罚特效1"], X = x, Y = y, ["持续秒"] = 2})
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = config["神罚特效2"], X = x, Y = y, ["持续秒"] = 2})
end
function _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_704C_6CE8(boss)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光灌注"]
    local duration = config["狂暴秒"]
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, config.BuffID)
    local _____653B_51FB_529B_52A0_6210 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * config["攻击力加成"]
    local _____79FB_901F_6263_51CF = GetUnitDefaultMoveSpeed(boss) * config["移动速度降低"]
    SGSS_SetState(boss, _____653B_51FB_529B_5C5E_6027ID, _____653B_51FB_529B_52A0_6210)
    SGSS_SetState(boss, _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID, -_____79FB_901F_6263_51CF)
    _____6708_5149_704C_6CE8_72B6_6001_8868[_____53D6_6708_5149_704C_6CE8Key(boss)] = {["攻击力"] = _____653B_51FB_529B_52A0_6210, ["移速扣减"] = _____79FB_901F_6263_51CF}
    _____5F53_524D_6708_5149_704C_6CE8Boss = boss
    registerManualBuff(
        boss,
        config.BuffID,
        duration,
        _____653B_51FB_529B_52A0_6210,
        {
            sourceName = GetUnitName(boss),
            iconOverride = "BuffIcon\\Boss\\Thranduil\\yueguangguanzhu.blp",
            effectModelOverride = config["特效"],
            effectValue2 = -_____79FB_901F_6263_51CF,
            onRemove = ____on_6708_5149_704C_6CE8Buff_79FB_9664
        }
    )
    local _____72C2_66B4_6A21_578B_7F29_653E = config["基础模型缩放"] * (1 + config["模型缩放加成"])
    SetUnitScale(boss, _____72C2_66B4_6A21_578B_7F29_653E, _____72C2_66B4_6A21_578B_7F29_653E, _____72C2_66B4_6A21_578B_7F29_653E)
    Sound3DII_CooPlayReuse(
        config["灌注完成音效"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        config["灌注完成音效裁断距离"]
    )
    _____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761({["总时长"] = duration, ["颜色ID"] = config["惩罚吟唱条颜色ID"], ["标题文本"] = config["惩罚吟唱条标题文本"], ["提示文本"] = config["惩罚吟唱条提示文本"]})
    addDelayedCallback(
        R2I(duration * 1000),
        function()
            _____5173_95ED_541F_5531_6761("致命惩罚")
            if not _____5355_4F4D_6709_6548(boss) then
                return
            end
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, config.BuffID)
            _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(boss, "精灵神罚")
            _____7ED3_7B97_745F_5170_8FEA_5C14_7CBE_7075_795E_7F5A(boss)
        end
    )
end
function _____7ED3_7B97_745F_5170_8FEA_5C14_7CBE_7075_795E_7F5A(boss)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光灌注"]
    Sound3DII_CooPlayReuse(
        config["神罚结算音效"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        config["神罚结算音效裁断距离"]
    )
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(target) then
                    goto __continue27
                end
                _____64AD_653E_795E_7F5A_7279_6548(
                    GetUnitX(target),
                    GetUnitY(target)
                )
                _____5BF9_5355_4F4D_9020_6210_5F3A_5316_4F24_5BB3(
                    boss,
                    target,
                    GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["神罚伤害最大生命比例"]
                )
            end
            ::__continue27::
            i = i + 1
        end
    end
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_1.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.00．SGSS")
SGSS_SetState = ____require_result_2.SGSS_SetState
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
_____5BF9_5355_4F4D_9020_6210_5F3A_5316_4F24_5BB3 = ____require_result_3["对单位造成强化伤害"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_5["开始硬直"]
local ____require_result_6 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_6["显示常规技能吟唱条"]
_____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761 = ____require_result_6["显示致命惩罚吟唱条"]
_____5173_95ED_541F_5531_6761 = ____require_result_6["关闭吟唱条"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local createTimedUnitEffect = ____require_result_7.createTimedUnitEffect
local ____require_result_8 = require("lib.扩展函数.封装函数.02．音效系统.index")
Sound3DII_CooPlayReuse = ____require_result_8.Sound3DII_CooPlayReuse
local jass = require("jass.common")
GetUnitState = jass.GetUnitState
GetUnitName = jass.GetUnitName
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
SetUnitScale = jass.SetUnitScale
GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
R2I = jass.R2I
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
_____653B_51FB_529B_5C5E_6027ID = 1
_____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID = 9
_____6708_5149_704C_6CE8_72B6_6001_8868 = {}
_____5F53_524D_6708_5149_704C_6CE8Boss = nil
____exports["释放瑟兰迪尔月光灌注"] = function(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光灌注"]
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["已触发月光灌注"] then
        return false
    end
    if context["月光灌注组合执行器"] == nil then
        context["月光灌注组合执行器"] = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "瑟兰迪尔-月光灌注", ["清理"] = context["清理"], ["互斥组"] = "瑟兰迪尔月光灌注"})
    end
    local ____self_9 = context["月光灌注组合执行器"]
    local _____6267_884CID = ____self_9["开始"](
        ____self_9,
        {
            key = "月光灌注",
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = R2I(config["施法硬直秒"] * 1000) + 1000,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868({
                {
                    ["时点毫秒"] = config["举剑冻结延迟Ms"],
                    ["名称"] = "月光灌注举剑停顿",
                    ["执行"] = function()
                        if _____5355_4F4D_6709_6548(boss) then
                            SetUnitTimeScale(boss, config["冻结动画速度"])
                        end
                    end
                },
                {
                    ["时点毫秒"] = R2I(config["施法硬直秒"] * 1000),
                    ["名称"] = "月光灌注生效",
                    ["执行"] = function()
                        _____5173_95ED_541F_5531_6761("常规技能")
                        if not _____5355_4F4D_6709_6548(boss) then
                            return
                        end
                        SetUnitTimeScale(boss, config["恢复动画速度"])
                        SetUnitAnimationByIndex(boss, config["恢复动画编号"])
                        _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_704C_6CE8(boss)
                    end
                }
            }),
            ["结束回调"] = function(event)
                if event["原因"] == "完成" then
                    return
                end
                _____5173_95ED_541F_5531_6761("常规技能")
                if not _____5355_4F4D_6709_6548(boss) then
                    return
                end
                SetUnitTimeScale(boss, config["恢复动画速度"])
                SetUnitAnimationByIndex(boss, config["恢复动画编号"])
            end
        }
    )
    if _____6267_884CID == 0 then
        return false
    end
    context["已触发月光灌注"] = true
    _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(boss, "月光灌注")
    _____5F00_59CB_786C_76F4(boss, config["施法硬直秒"])
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({["总时长"] = config["施法硬直秒"], ["颜色ID"] = config["吟唱条颜色ID"], ["标题文本"] = config["吟唱条标题文本"], ["提示文本"] = config["吟唱条提示文本"]})
    SetUnitTimeScale(boss, config["施法动画速度"])
    SetUnitAnimationByIndex(boss, config["动画编号"])
    createTimedUnitEffect(boss, "origin", config["特效"], config["施法硬直秒"])
    return true
end
____exports["清理瑟兰迪尔月光灌注"] = function()
    _____5173_95ED_541F_5531_6761("致命惩罚")
    if _____5F53_524D_6708_5149_704C_6CE8Boss ~= nil and _____5F53_524D_6708_5149_704C_6CE8Boss ~= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____5F53_524D_6708_5149_704C_6CE8Boss, _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光灌注"].BuffID)
        _____5F53_524D_6708_5149_704C_6CE8Boss = nil
    end
end
return ____exports
