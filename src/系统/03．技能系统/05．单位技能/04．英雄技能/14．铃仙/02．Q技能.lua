--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00．配置")
local _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["铃仙单位技能配置"]
local ____12_FF0E_94C3_4ED9 = require("系统.05．Buff系统.03．Buff表.02．英雄.12．铃仙")
local _____94C3_4ED9BuffID = ____12_FF0E_94C3_4ED9["铃仙BuffID"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00A．表现工具")
local _____64AD_653E_94C3_4ED9_5355_4F4D_7ED1_5B9A_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放铃仙单位绑定音效"]
local ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00B．分身与状态管理")
local _____662F_94C3_4ED9_672C_4F53 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是铃仙本体"]
local _____94C3_4ED9_5206_8EAB_6570_91CF = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["铃仙分身数量"]
local _____83B7_53D6_94C3_4ED9_5206_8EAB_7EC4 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["获取铃仙分身组"]
local _____79FB_9664_94C3_4ED9_5206_8EAB = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["移除铃仙分身"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_3["造成技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_4["创建原生弹幕"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_51CF_901F = ____require_result_5["施加减速"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_7["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_7["移除单位暂停"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_9["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_9["单位存活"]
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local ____Q_6280_80FDID = stringToFourCCSafe(_____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"])
local ____Agho_9690_8EAB_80FD_529BID = stringToFourCCSafe("Agho")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local IsUnitType = jass.IsUnitType
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local _____89D2_5EA6_8F6C_5F27_5EA6 = math.pi / 180
local function _____4E24_70B9_89D2_5EA6(x1, y1, x2, y2)
    return math.atan(y2 - y1, x2 - x1) * 180 / math.pi
end
local function _____94C3_4ED9Q_5206_8EAB_6A21_4EFF(_____65BD_6CD5_8005, _____5206_8EAB, _____65B9_5411_89D2)
    if _____5206_8EAB == nil or _____5206_8EAB == 0 then
        return
    end
    local cfg = _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E.Q
    if not _____5355_4F4D_5B58_6D3B(_____5206_8EAB) then
        _____79FB_9664_94C3_4ED9_5206_8EAB(_____65BD_6CD5_8005, _____5206_8EAB)
        return
    end
    SetUnitFacing(_____5206_8EAB, _____65B9_5411_89D2)
    _____6DFB_52A0_5355_4F4D_6682_505C(_____5206_8EAB, "铃仙Q分身模仿")
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["命中特效模型"],
        X = GetUnitX(_____5206_8EAB),
        Y = GetUnitY(_____5206_8EAB),
        Z = cfg["分身特效Z"],
        ["缩放"] = cfg["分身特效缩放"],
        ["Z轴角度"] = _____65B9_5411_89D2,
        ["动画速度"] = 3,
        ["持续秒"] = cfg["分身特效时长"]
    })
    addDelayedCallback(
        350,
        function()
            if _____5206_8EAB == nil or _____5206_8EAB == 0 or not _____5355_4F4D_5B58_6D3B(_____5206_8EAB) then
                return
            end
            SetUnitAnimationByIndex(_____5206_8EAB, 2)
            _____79FB_9664_5355_4F4D_6682_505C(_____5206_8EAB, "铃仙Q分身模仿")
        end
    )
    SetUnitTimeScale(_____5206_8EAB, 1)
end
local function ____on_94C3_4ED9Q(_____65BD_6CD5_8005, _____6280_80FDID_6570_503C)
    if _____6280_80FDID_6570_503C ~= ____Q_6280_80FDID then
        return
    end
    if not _____662F_94C3_4ED9_672C_4F53(_____65BD_6CD5_8005) then
        return
    end
    local cfg = _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E.Q
    local _____8D77_70B9X = GetUnitX(_____65BD_6CD5_8005)
    local _____8D77_70B9Y = GetUnitY(_____65BD_6CD5_8005)
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(_____8D77_70B9X, _____8D77_70B9Y, _____76EE_6807X, _____76EE_6807Y)
    _____64AD_653E_94C3_4ED9_5355_4F4D_7ED1_5B9A_97F3_6548(_____65BD_6CD5_8005, "gg_snd_LX_Q2", 100)
    _____64AD_653E_94C3_4ED9_5355_4F4D_7ED1_5B9A_97F3_6548(_____65BD_6CD5_8005, "gg_snd_LX_q", 100)
    local _____5206_8EAB_7EC4 = _____83B7_53D6_94C3_4ED9_5206_8EAB_7EC4(_____65BD_6CD5_8005)
    do
        local i = 0
        while i < #_____5206_8EAB_7EC4 do
            _____94C3_4ED9Q_5206_8EAB_6A21_4EFF(_____65BD_6CD5_8005, _____5206_8EAB_7EC4[i + 1], _____65B9_5411_89D2)
            i = i + 1
        end
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["命中特效模型"],
        X = _____8D77_70B9X,
        Y = _____8D77_70B9Y,
        Z = cfg["命中特效Z"],
        ["缩放"] = cfg["命中特效缩放"],
        ["Z轴角度"] = _____65B9_5411_89D2,
        ["动画速度"] = 3,
        ["持续秒"] = cfg["命中特效时长"]
    })
    local _____5206_8EAB_6570_91CF = _____94C3_4ED9_5206_8EAB_6570_91CF(_____65BD_6CD5_8005)
    local _____603B_4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * cfg["攻击力倍率"] * (1 + cfg["每分身伤害加成"] * _____5206_8EAB_6570_91CF)
    local _____547D_4E2D_82F1_96C4 = false
    local _____547D_4E2D_5355_4F4D_6570 = 0
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = _____65BD_6CD5_8005,
        X = _____8D77_70B9X,
        Y = _____8D77_70B9Y,
        ["方向角"] = _____65B9_5411_89D2,
        ["速度"] = cfg["弹幕速度"],
        ["最大距离"] = cfg["弹幕最大步数"] * cfg["弹幕每tick距离"],
        ["生命周期"] = cfg["弹幕最大步数"] * cfg["弹幕tick秒"],
        ["命中半径"] = cfg["弹幕命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = false,
        ["每单位最大命中次数"] = 1,
        ["最大总命中次数"] = 0,
        ["模型"] = "",
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____Q_6280_80FDID,
        ["技能标签"] = "铃仙-幻觉冲击波",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true,
        ["on命中"] = function(_____76EE_6807)
            _____65BD_52A0_51CF_901F(
                _____65BD_6CD5_8005,
                _____76EE_6807,
                cfg["减速比例"],
                cfg["减速持续秒"],
                _____94C3_4ED9BuffID["Q减速"],
                "技能"
            )
            local _____662F_82F1_96C4 = IsUnitType(_____76EE_6807, UNIT_TYPE_HERO)
            if _____662F_82F1_96C4 then
                _____547D_4E2D_82F1_96C4 = true
            end
            _____547D_4E2D_5355_4F4D_6570 = _____547D_4E2D_5355_4F4D_6570 + 1
            _____9020_6210_6280_80FD_4F24_5BB3({
                ["来源"] = _____65BD_6CD5_8005,
                ["目标"] = _____76EE_6807,
                ["伤害"] = _____662F_82F1_96C4 and _____603B_4F24_5BB3 or _____603B_4F24_5BB3 * cfg["非英雄伤害倍率"],
                ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                attack = true,
                ranged = false,
                attackType = ATTACK_TYPE_NORMAL,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "单位技能",
                ["技能ID"] = ____Q_6280_80FDID,
                ["标签"] = "铃仙-幻觉冲击波",
                ["伤害形态"] = "单体",
                ["参与技能伤害加成"] = true
            })
        end,
        ["on结束"] = function(_____539F_56E0)
            if _____547D_4E2D_82F1_96C4 then
                UnitAddAbility(_____65BD_6CD5_8005, ____Agho_9690_8EAB_80FD_529BID)
                registerManualBuff(_____65BD_6CD5_8005, _____94C3_4ED9BuffID["Q隐身"], cfg["隐身持续秒"], 0)
                addDelayedCallback(
                    math.floor(cfg["隐身持续秒"] * 1000 + 0.5),
                    function()
                        if _____65BD_6CD5_8005 ~= nil and _____65BD_6CD5_8005 ~= 0 and _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                            UnitRemoveAbility(_____65BD_6CD5_8005, ____Agho_9690_8EAB_80FD_529BID)
                        end
                    end
                )
            end
        end
    })
end
registerSpellEffectListener(____on_94C3_4ED9Q)
return ____exports
