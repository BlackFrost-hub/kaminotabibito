local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D1_5C04_71D5_8FD4_7B2CN_51FB, _____71D5_8FD4_7ED3_675F_6062_590D, _____53D1_5C04_71D5_8FD4_5200_5149, _____89E6_53D1_71D5_8FD4, addDelayedCallback, ____SFB__65BD_52A0_901A_7528Buff, _____521B_5EFA_539F_751F_5F39_5E55, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____5355_4F4D_5B58_6D3B, _____6781_5750_6807X, _____6781_5750_6807Y, _____79D2_8F6C_6BEB_79D2, _____79FB_9664_5355_4F4D_6682_505C, ____R_6280_80FDID_6570_503C, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, GetHandleId, GetUnitX, GetUnitY, GetUnitFacing, SetUnitInvulnerable, SetUnitTimeScale, SetUnitAnimation, ____R_4E2D_65AD_53D6_6D88_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00．配置")
local _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["佐佐木单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00A．表现工具")
local _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放佐佐木坐标音效"]
local _____64AD_653E_4F50_4F50_6728_914D_7F6E_52A8_4F5C = ____00A_FF0E_8868_73B0_5DE5_5177["播放佐佐木配置动作"]
local _____64AD_653E_4F50_4F50_6728_5168_5C40_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放佐佐木全局音效"]
local ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00B．分身与状态管理")
local _____662F_4F50_4F50_6728_672C_4F53 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是佐佐木本体"]
local ____11_FF0E_4F50_4F50_6728_5C0F_6B21_90CE = require("系统.05．Buff系统.03．Buff表.02．英雄.11．佐佐木小次郎")
local _____4F50_4F50_6728_5C0F_6B21_90CEBuffID = ____11_FF0E_4F50_4F50_6728_5C0F_6B21_90CE["佐佐木小次郎BuffID"]
function _____53D1_5C04_71D5_8FD4_7B2CN_51FB(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or not _____5355_4F4D_5B58_6D3B(_____53C2_6570["英雄"]) then
        return
    end
    if ____R_4E2D_65AD_53D6_6D88_8868[GetHandleId(_____53C2_6570["英雄"])] == true then
        return
    end
    _____53D1_5C04_71D5_8FD4_5200_5149(
        _____53C2_6570["英雄"],
        _____53C2_6570["起点X"],
        _____53C2_6570["起点Y"],
        _____53C2_6570["角度"],
        _____53C2_6570["击序"]
    )
end
function _____71D5_8FD4_7ED3_675F_6062_590D(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil then
        return
    end
    local _____82F1_96C4 = _____53C2_6570["英雄"]
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or not _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        return
    end
    if ____R_4E2D_65AD_53D6_6D88_8868[GetHandleId(_____82F1_96C4)] == true then
        return
    end
    SetUnitInvulnerable(_____82F1_96C4, false)
    SetUnitTimeScale(_____82F1_96C4, 1)
    SetUnitAnimation(_____82F1_96C4, "stand")
    _____79FB_9664_5355_4F4D_6682_505C(_____82F1_96C4, "佐佐木R燕返防御")
end
function _____53D1_5C04_71D5_8FD4_5200_5149(_____82F1_96C4, _____8D77_70B9X, _____8D77_70B9Y, _____89D2_5EA6, _____51FB_5E8F)
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.R
    local _____51FB = cfg["三击"][_____51FB_5E8F + 1]
    _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548(
        _____51FB["音效路径"],
        GetUnitX(_____82F1_96C4),
        GetUnitY(_____82F1_96C4),
        cfg["三击音效裁断"]
    )
    local _____5F39_5E55_53C2_6570 = {
        ["所有者"] = _____82F1_96C4,
        X = _____8D77_70B9X,
        Y = _____8D77_70B9Y,
        ["方向角"] = _____89D2_5EA6 + _____51FB["角度偏移"],
        ["速度"] = _____51FB["速度"],
        ["最大距离"] = _____51FB["最大飞行距离"],
        ["命中半径"] = _____51FB["命中半径"],
        ["影响目标"] = "敌方",
        ["每单位最大命中次数"] = 1,
        ["不可阻挡"] = true,
        ["伤害值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____82F1_96C4) * cfg["攻击力倍率"],
        attack = true,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____R_6280_80FDID_6570_503C,
        ["标签"] = "佐佐木小次郎-燕返",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true,
        ["模型"] = cfg["刀光特效模型"],
        ["缩放"] = 1.5,
        ["附加特效1"] = {["模型"] = cfg["剑气伴随模型"], ["缩放"] = _____51FB["缩放"], ["跟随主弹幕参数"] = true},
        ["on命中"] = function(_____76EE_6807_5355_4F4D)
            ____SFB__65BD_52A0_901A_7528Buff(_____82F1_96C4, _____76EE_6807_5355_4F4D, 21, _____51FB["硬直秒"])
        end
    }
    _____521B_5EFA_539F_751F_5F39_5E55(_____5F39_5E55_53C2_6570)
end
function _____89E6_53D1_71D5_8FD4(_____82F1_96C4)
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.R
    SetUnitInvulnerable(_____82F1_96C4, true)
    _____64AD_653E_4F50_4F50_6728_914D_7F6E_52A8_4F5C(_____82F1_96C4, cfg["反击动作索引"], cfg["反击动作速度"])
    _____64AD_653E_4F50_4F50_6728_5168_5C40_97F3_6548(cfg["燕返触发音效键"])
    local _____89D2_5EA6 = GetUnitFacing(_____82F1_96C4)
    local _____8D77_70B9X = _____6781_5750_6807X(
        _____6781_5750_6807X(
            GetUnitX(_____82F1_96C4),
            _____89D2_5EA6 + 90,
            25
        ),
        _____89D2_5EA6,
        50
    )
    local _____8D77_70B9Y = _____6781_5750_6807Y(
        _____6781_5750_6807Y(
            GetUnitY(_____82F1_96C4),
            _____89D2_5EA6 + 90,
            25
        ),
        _____89D2_5EA6,
        50
    )
    do
        local _____51FB_5E8F = 0
        while _____51FB_5E8F < #cfg["三击"] do
            addDelayedCallback(
                _____79D2_8F6C_6BEB_79D2((_____51FB_5E8F + 1) * cfg["三击间隔秒"]),
                _____53D1_5C04_71D5_8FD4_7B2CN_51FB,
                {
                    ["英雄"] = _____82F1_96C4,
                    ["起点X"] = _____8D77_70B9X,
                    ["起点Y"] = _____8D77_70B9Y,
                    ["角度"] = _____89D2_5EA6,
                    ["击序"] = _____51FB_5E8F
                }
            )
            _____51FB_5E8F = _____51FB_5E8F + 1
        end
    end
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2((#cfg["三击"] + 1) * cfg["三击间隔秒"]),
        _____71D5_8FD4_7ED3_675F_6062_590D,
        {["英雄"] = _____82F1_96C4}
    )
end
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_2.registerSpellEffectListener
local registerSpellEndcastListener = ____require_result_2.registerSpellEndcastListener
local ____require_result_3 = require("系统.04．伤害系统.01．伤害事件")
local registerDamageCallback = ____require_result_3.registerDamageCallback
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
____SFB__65BD_52A0_901A_7528Buff = ____require_result_4["SFB_施加通用Buff"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
_____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_5["创建原生弹幕"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
_____5355_4F4D_5B58_6D3B = ____require_result_6["单位存活"]
_____6781_5750_6807X = ____require_result_6["极坐标X"]
_____6781_5750_6807Y = ____require_result_6["极坐标Y"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算")
_____79D2_8F6C_6BEB_79D2 = ____require_result_7["秒转毫秒"]
local ____require_result_8 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_8.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_8["移除单位指定Buff"]
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_9["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_9["移除单位暂停"]
____R_6280_80FDID_6570_503C = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["R技能ID"])
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
GetHandleId = jass.GetHandleId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFacing = jass.GetUnitFacing
SetUnitInvulnerable = jass.SetUnitInvulnerable
SetUnitTimeScale = jass.SetUnitTimeScale
SetUnitAnimation = jass.SetUnitAnimation
--- 防御窗口开启中（0.68 秒内为 true）
local ____R_9632_5FA1_7A97_53E3_8868 = {}
--- 窗口内已受击（燕返触发标记，0.70 秒结算时消耗）
local ____R_53CD_51FB_6807_8BB0_8868 = {}
____R_4E2D_65AD_53D6_6D88_8868 = {}
local function _____4F50_4F50_6728R_53D7_51FB_6807_8BB0(unit)
    if unit == nil or unit == 0 then
        return
    end
    local id = GetHandleId(unit)
    if ____R_9632_5FA1_7A97_53E3_8868[id] ~= true then
        return
    end
    ____R_9632_5FA1_7A97_53E3_8868[id] = false
    ____R_53CD_51FB_6807_8BB0_8868[id] = true
end
registerDamageCallback(_____4F50_4F50_6728R_53D7_51FB_6807_8BB0)
local function _____5173_95EDR_9632_5FA1_7A97_53E3(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil then
        return
    end
    ____R_9632_5FA1_7A97_53E3_8868[_____53C2_6570["单位ID"]] = false
end
local function _____7ED3_7B97R_9632_5FA1_7A97_53E3(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____53C2_6570["施法单位"]
    local id = _____53C2_6570["单位ID"]
    ____R_9632_5FA1_7A97_53E3_8868[id] = false
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65BD_6CD5_5355_4F4D, _____4F50_4F50_6728_5C0F_6B21_90CEBuffID["燕返守卫"])
    if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_5355_4F4D) then
        return
    end
    if ____R_4E2D_65AD_53D6_6D88_8868[id] == true then
        return
    end
    if ____R_53CD_51FB_6807_8BB0_8868[id] == true then
        ____R_53CD_51FB_6807_8BB0_8868[id] = false
        _____89E6_53D1_71D5_8FD4(_____65BD_6CD5_5355_4F4D)
    else
        SetUnitTimeScale(_____65BD_6CD5_5355_4F4D, 1)
        SetUnitAnimation(_____65BD_6CD5_5355_4F4D, "stand")
        _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_5355_4F4D, "佐佐木R燕返防御")
    end
end
local function ____on_4F50_4F50_6728R_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    if not _____662F_4F50_4F50_6728_672C_4F53(_____65BD_6CD5_5355_4F4D) then
        return
    end
    if _____6280_80FDID_6570_503C ~= ____R_6280_80FDID_6570_503C then
        return
    end
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.R
    local id = GetHandleId(_____65BD_6CD5_5355_4F4D)
    __TS__Delete(____R_4E2D_65AD_53D6_6D88_8868, id)
    _____64AD_653E_4F50_4F50_6728_5168_5C40_97F3_6548(cfg["防御姿态音效键"])
    _____64AD_653E_4F50_4F50_6728_914D_7F6E_52A8_4F5C(_____65BD_6CD5_5355_4F4D, cfg["防御动作索引"], 0)
    _____6DFB_52A0_5355_4F4D_6682_505C(_____65BD_6CD5_5355_4F4D, "佐佐木R燕返防御")
    ____R_9632_5FA1_7A97_53E3_8868[id] = true
    ____R_53CD_51FB_6807_8BB0_8868[id] = false
    registerManualBuff(_____65BD_6CD5_5355_4F4D, _____4F50_4F50_6728_5C0F_6B21_90CEBuffID["燕返守卫"], cfg["防御窗口秒"], 0)
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(cfg["防御窗口秒"]),
        _____5173_95EDR_9632_5FA1_7A97_53E3,
        {["单位ID"] = id}
    )
    addDelayedCallback(700, _____7ED3_7B97R_9632_5FA1_7A97_53E3, {["施法单位"] = _____65BD_6CD5_5355_4F4D, ["单位ID"] = id})
end
registerSpellEffectListener(____on_4F50_4F50_6728R_751F_6548)
--- 施法中断清理（SPELL_ENDCAST 触发，正常结算/燕返结束后标记复位幂等跳过）。
-- 只清理本技能创建的防御状态：窗口/反击/中断标记复位、防御暂停（具名来源）、
-- 燕返守卫 Buff、燕返无敌/倍速/动作恢复。不影响其他技能暂停来源与 Buff。
-- 中断后 燕返三击/结束恢复/窗口结算 回调由 R中断取消表 失效。
local function _____4F50_4F50_6728R_4E2D_65AD_6E05_7406(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    if _____6280_80FDID_6570_503C ~= ____R_6280_80FDID_6570_503C then
        return
    end
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local id = GetHandleId(_____65BD_6CD5_5355_4F4D)
    ____R_9632_5FA1_7A97_53E3_8868[id] = false
    ____R_53CD_51FB_6807_8BB0_8868[id] = false
    ____R_4E2D_65AD_53D6_6D88_8868[id] = true
    _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_5355_4F4D, "佐佐木R燕返防御")
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65BD_6CD5_5355_4F4D, _____4F50_4F50_6728_5C0F_6B21_90CEBuffID["燕返守卫"])
    if _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_5355_4F4D) then
        SetUnitInvulnerable(_____65BD_6CD5_5355_4F4D, false)
        SetUnitTimeScale(_____65BD_6CD5_5355_4F4D, 1)
        SetUnitAnimation(_____65BD_6CD5_5355_4F4D, "stand")
    end
end
registerSpellEndcastListener(_____4F50_4F50_6728R_4E2D_65AD_6E05_7406)
return ____exports
