--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____on_6559_6D3E_5251_58EB_5EF6_8FDF_6D4B_8BD5, addDelayedCallback, _____65BD_52A0_5FEB_901F_63A7_5236Buff, _____83B7_53D6_5355_4F4D_786C_76F4_5269_4F59_65F6_95F4, debugLogForce, GetHandleId, GetUnitState, GetUnitX, GetUnitY, UnitDamageTarget, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, DAMAGE_TYPE_FIRE, DAMAGE_TYPE_DIVINE, WEAPON_TYPE_WHOKNOWS, UNIT_STATE_LIFE
function ____on_6559_6D3E_5251_58EB_5EF6_8FDF_6D4B_8BD5(variable)
    local data = variable
    if data == nil then
        return
    end
    local context = data["上下文"]
    if data["操作"] == "旋风结束检查" then
        debugLogForce(
            "教派剑士Boss技能测试",
            "深渊旋风延迟结束检查",
            "bossHid=",
            GetHandleId(context["Boss单位"]),
            "bossLife=",
            GetUnitState(context["Boss单位"], UNIT_STATE_LIFE),
            "runtimeState=",
            context["运行时"]["旋风状态"] ~= nil and "仍存在" or "已清理",
            "expected=",
            "全部轮次结束后旋风状态、吟唱条和弹幕清理"
        )
        return
    end
    if data["操作"] == "魔祭结算检查" then
        debugLogForce(
            "教派剑士Boss技能测试",
            "魔祭吸魂延迟结算检查",
            "bossHid=",
            GetHandleId(context["Boss单位"]),
            "bossLife=",
            GetUnitState(context["Boss单位"], UNIT_STATE_LIFE),
            "targetLife=",
            GetUnitState(context["玩家英雄"], UNIT_STATE_LIFE),
            "runtimeState=",
            context["运行时"]["魔祭状态"] ~= nil and "仍存在" or "已清理",
            "expected=",
            "1.9秒全体暗伤结算完成，2秒状态结束并清理"
        )
        return
    end
    if data["操作"] == "分身自然结束检查" then
        debugLogForce(
            "教派剑士Boss技能测试",
            "深渊分身延迟结束检查",
            "bossHid=",
            GetHandleId(context["Boss单位"]),
            "bossLife=",
            GetUnitState(context["Boss单位"], UNIT_STATE_LIFE),
            "runtimeState=",
            context["运行时"]["分身状态"] ~= nil and "仍存在" or "已清理",
            "expected=",
            "5秒到期后分身组和状态清理，Boss恢复可行动"
        )
        return
    end
    if data["操作"] == "黑洞穿越结束检查" then
        debugLogForce(
            "教派剑士Boss技能测试",
            "黑洞跨越延迟结束检查",
            "bossHid=",
            GetHandleId(context["Boss单位"]),
            "bossX=",
            GetUnitX(context["Boss单位"]),
            "bossY=",
            GetUnitY(context["Boss单位"]),
            "runtimeState=",
            context["运行时"]["黑洞状态"] ~= nil and "仍存在" or "已清理",
            "expected=",
            "入口/出口和强化普攻窗口按成功或失败原因清理"
        )
        return
    end
    if data["操作"] == "旋风打断" then
        _____65BD_52A0_5FEB_901F_63A7_5236Buff(
            context["玩家英雄"],
            context["Boss单位"],
            0,
            1,
            "教派剑士测试-旋风打断",
            "测试"
        )
        debugLogForce(
            "教派剑士Boss技能测试",
            "已向旋风中的Boss施加硬控制",
            "bossHid=",
            GetHandleId(context["Boss单位"]),
            "targetHid=",
            GetHandleId(context["玩家英雄"])
        )
        local callbackId = addDelayedCallback(350, ____on_6559_6D3E_5251_58EB_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "旋风打断检查"})
        local ____self_29 = context["运行时"]["清理"]
        ____self_29["登记延迟回调"](____self_29, "教派剑士测试-旋风打断检查", callbackId)
        return
    end
    if data["操作"] == "旋风打断检查" then
        local hardStunRemaining = _____83B7_53D6_5355_4F4D_786C_76F4_5269_4F59_65F6_95F4(context["Boss单位"])
        debugLogForce(
            "教派剑士Boss技能测试",
            "深渊旋风打断后硬直检查",
            "bossHid=",
            GetHandleId(context["Boss单位"]),
            "hardStunRemaining=",
            hardStunRemaining,
            "runtimeState=",
            context["运行时"]["旋风状态"] ~= nil and "仍存在" or "已清理",
            "expected=",
            "施法硬直剩余0且旋风状态已清理；外部硬控制独立按自身持续时间结束"
        )
        return
    end
    if data["操作"] == "黑洞摧毁" then
        local _____72B6_6001 = context["运行时"]["黑洞状态"]
        local ____opt_result_34
        if _____72B6_6001 ~= nil then
            ____opt_result_34 = _____72B6_6001["黑洞实例"]
        end
        local ____opt_result_35
        if ____opt_result_34 ~= nil then
            ____opt_result_35 = ____opt_result_34["单位"]
        end
        local ____opt_result_35_39 = ____opt_result_35
        if ____opt_result_35_39 == nil then
            local ____opt_result_38
            if _____72B6_6001 ~= nil then
                ____opt_result_38 = _____72B6_6001["黑洞单位"]
            end
            ____opt_result_35_39 = ____opt_result_38
        end
        local _____9ED1_6D1E = ____opt_result_35_39
        local submitted = 0
        if _____9ED1_6D1E ~= nil and _____9ED1_6D1E ~= 0 then
            do
                local i = 0
                while i < 8 do
                    if UnitDamageTarget(
                        context["玩家英雄"],
                        _____9ED1_6D1E,
                        100000,
                        true,
                        false,
                        ATTACK_TYPE_NORMAL,
                        DAMAGE_TYPE_NORMAL,
                        WEAPON_TYPE_WHOKNOWS
                    ) then
                        submitted = submitted + 1
                    end
                    i = i + 1
                end
            end
        end
        debugLogForce(
            "教派剑士Boss技能测试",
            "黑洞真实攻击已提交",
            "blackHoleHid=",
            _____9ED1_6D1E ~= nil and _____9ED1_6D1E ~= 0 and GetHandleId(_____9ED1_6D1E) or 0,
            "submitted=",
            submitted,
            "expected=",
            "黑洞被摧毁后触发爆炸与清理"
        )
        return
    end
    if data["操作"] == "魔祭火光反噬" then
        local fire = UnitDamageTarget(
            context["玩家英雄"],
            context["Boss单位"],
            1,
            false,
            false,
            ATTACK_TYPE_NORMAL,
            DAMAGE_TYPE_FIRE,
            WEAPON_TYPE_WHOKNOWS
        )
        local light = UnitDamageTarget(
            context["玩家英雄"],
            context["Boss单位"],
            1,
            false,
            false,
            ATTACK_TYPE_NORMAL,
            DAMAGE_TYPE_DIVINE,
            WEAPON_TYPE_WHOKNOWS
        )
        debugLogForce(
            "教派剑士Boss技能测试",
            "魔祭火光伤害已提交",
            "bossHid=",
            GetHandleId(context["Boss单位"]),
            "fireStarted=",
            fire,
            "lightStarted=",
            light,
            "expected=",
            "首个火/光伤害触发反噬，第二个伤害记录为状态结束后的对照"
        )
        return
    end
    local _____72B6_6001 = context["运行时"]["分身状态"]
    local ____opt_result_46
    if _____72B6_6001 ~= nil then
        ____opt_result_46 = _____72B6_6001["召唤组"]
    end
    local ____opt_result_47
    if ____opt_result_46 ~= nil then
        ____opt_result_47 = ____opt_result_46["取单位列表"]
    end
    local ____opt_result_48
    if ____opt_result_47 ~= nil then
        ____opt_result_48 = ____opt_result_47(____opt_result_46)
    end
    local ____opt_result_48_49 = ____opt_result_48
    if ____opt_result_48_49 == nil then
        ____opt_result_48_49 = {}
    end
    local _____5206_8EAB_5217_8868 = ____opt_result_48_49
    local submitted = 0
    do
        local i = 0
        while i < _____5206_8EAB_5217_8868.length do
            do
                local hit = 0
                while hit < 2 do
                    if UnitDamageTarget(
                        context["玩家英雄"],
                        _____5206_8EAB_5217_8868[i],
                        100000,
                        true,
                        false,
                        ATTACK_TYPE_NORMAL,
                        DAMAGE_TYPE_NORMAL,
                        WEAPON_TYPE_WHOKNOWS
                    ) then
                        submitted = submitted + 1
                    end
                    hit = hit + 1
                end
            end
            i = i + 1
        end
    end
    debugLogForce(
        "教派剑士Boss技能测试",
        "分身真实普攻已提交",
        "cloneCount=",
        _____5206_8EAB_5217_8868.length,
        "submitted=",
        submitted,
        "expected=",
        "每个分身两次纯普攻击破并触发死亡爆炸"
    )
end
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_1["应用Boss战启动属性配置"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local directRegisterPlayerHero = ____require_result_2.directRegisterPlayerHero
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.08．技能入口")
local _____6CE8_518C_6559_6D3E_5251_58EB_6280_80FD_7ED3_6784 = ____require_result_3["注册教派剑士技能结构"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587 = ____require_result_4["获取或创建教派剑士上下文"]
local _____6E05_7406_6559_6D3E_5251_58EB_4E0A_4E0B_6587 = ____require_result_4["清理教派剑士上下文"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_5.addDelayedCallback
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_6["施加快速控制Buff"]
_____83B7_53D6_5355_4F4D_786C_76F4_5269_4F59_65F6_95F4 = ____require_result_6["获取单位硬直剩余时间"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.04．深渊旋风")
local _____91CA_653E_6559_6D3E_5251_58EB_6DF1_6E0A_65CB_98CE = ____require_result_7["释放教派剑士深渊旋风"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.05．黑洞跨越")
local _____91CA_653E_6559_6D3E_5251_58EB_9ED1_6D1E_8DE8_8D8A = ____require_result_8["释放教派剑士黑洞跨越"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.06．魔祭吸魂")
local _____91CA_653E_6559_6D3E_5251_58EB_9B54_796D_5438_9B42 = ____require_result_9["释放教派剑士魔祭吸魂"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.07．深渊分身")
local _____91CA_653E_6559_6D3E_5251_58EB_6DF1_6E0A_5206_8EAB = ____require_result_10["释放教派剑士深渊分身"]
local ____require_result_11 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_11["注册Boss技能测试目标"]
local _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_11["注销Boss技能测试目标"]
local ____require_result_12 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_12["标记测试Boss跳过死亡结算"]
local ____require_result_13 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_13["Boss测试单位存活"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_13["获取Boss测试玩家基准英雄"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_13["设置Boss测试单位满血"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_13["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_13["注册Boss测试命令组"]
local ____require_result_14 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_14.debugLogForce
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local GetPlayerId = jass.GetPlayerId
GetHandleId = jass.GetHandleId
GetUnitState = jass.GetUnitState
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local SetUnitPosition = jass.SetUnitPosition
local SetUnitFacing = jass.SetUnitFacing
UnitDamageTarget = jass.UnitDamageTarget
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____6559_6D3E_5251_58EB_5355_4F4DID = stringToFourCCSafe("N05N")
local _____6D4B_8BD5_4E2D_5FC3X = -540.6
local _____6D4B_8BD5_4E2D_5FC3Y = -2495.2
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
local _____6700_8FD1Boss = {}
local function _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    SetUnitPosition(context["Boss单位"], _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(context["Boss单位"], 270)
    SetUnitPosition(context["玩家英雄"], _____6D4B_8BD5_4E2D_5FC3X - 450, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(context["玩家英雄"], 90)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["Boss单位"], 100000)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["玩家英雄"], 100000)
end
local function _____521B_5EFA_6216_83B7_53D6_6559_6D3E_5251_58EB_6D4B_8BD5_4E0A_4E0B_6587(player)
    local playerId = GetPlayerId(player)
    local _____73A9_5BB6_82F1_96C4 = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____73A9_5BB6_82F1_96C4) then
        return nil
    end
    _____6CE8_518C_6559_6D3E_5251_58EB_6280_80FD_7ED3_6784()
    directRegisterPlayerHero(player, _____73A9_5BB6_82F1_96C4)
    _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807(_____73A9_5BB6_82F1_96C4)
    local boss = _____6700_8FD1Boss[playerId]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        boss = CreateUnit(
            Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
            _____6559_6D3E_5251_58EB_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X,
            _____6D4B_8BD5_4E2D_5FC3Y,
            270
        )
        _____6700_8FD1Boss[playerId] = boss
    end
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
    local _____8FD0_884C_65F6 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587(boss)
    if _____8FD0_884C_65F6 == nil then
        return nil
    end
    local context = {["Boss单位"] = boss, ["玩家英雄"] = _____73A9_5BB6_82F1_96C4, ["运行时"] = _____8FD0_884C_65F6}
    _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    globals.udg_Boss = boss
    debugLogForce(
        "教派剑士Boss技能测试",
        "中立敌对隔离测试场准备完成",
        "playerId=",
        playerId,
        "bossOwner=",
        _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID,
        "bossHid=",
        GetHandleId(boss),
        "targetHid=",
        GetHandleId(_____73A9_5BB6_82F1_96C4),
        "passiveEnabled=",
        true
    )
    return context
end
local function _____6E05_7406_6559_6D3E_5251_58EB_6D4B_8BD5_4E0A_4E0B_6587(player, context)
    local playerId = GetPlayerId(player)
    _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807(context and context["玩家英雄"])
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context and context["Boss单位"]) then
        _____6E05_7406_6559_6D3E_5251_58EB_4E0A_4E0B_6587(context["Boss单位"])
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1Boss[playerId])
    _____6700_8FD1Boss[playerId] = nil
    if globals.udg_Boss == (context and context["Boss单位"]) then
        globals.udg_Boss = nil
    end
    debugLogForce("教派剑士Boss技能测试", "隔离测试场已清理", "playerId=", playerId)
end
local function _____6D4B_8BD5_9ED1_9B54_6CD5_4FB5_8680_666E_653B(_player, context)
    _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_9020_6210_4F24_5BB3 = UnitDamageTarget(
        context["Boss单位"],
        context["玩家英雄"],
        200,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
    debugLogForce(
        "教派剑士Boss技能测试",
        "真实普攻事件已提交，观察最大生命附加暗伤",
        "damageStarted=",
        _____662F_5426_9020_6210_4F24_5BB3,
        "bossHid=",
        GetHandleId(context["Boss单位"]),
        "targetHid=",
        GetHandleId(context["玩家英雄"])
    )
end
local function _____6D4B_8BD5_9ED1_9B54_6CD5_6CD5_672F_66B4_51FB(_player, context)
    _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    local _____5DF2_63D0_4EA4_6B21_6570 = 0
    do
        local i = 0
        while i < 8 do
            if UnitDamageTarget(
                context["Boss单位"],
                context["玩家英雄"],
                100,
                false,
                false,
                ATTACK_TYPE_NORMAL,
                DAMAGE_TYPE_SHADOW_STRIKE,
                WEAPON_TYPE_WHOKNOWS
            ) then
                _____5DF2_63D0_4EA4_6B21_6570 = _____5DF2_63D0_4EA4_6B21_6570 + 1
            end
            i = i + 1
        end
    end
    debugLogForce("教派剑士Boss技能测试", "连续提交八次暗魔法伤害，观察法术暴击日志", "submitted=", _____5DF2_63D0_4EA4_6B21_6570)
end
local function _____6D4B_8BD5_6DF1_6E0A_65CB_98CE(_player, context)
    _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5251_58EB_6DF1_6E0A_65CB_98CE(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(5000, ____on_6559_6D3E_5251_58EB_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "旋风结束检查"})
        local ____self_21 = context["运行时"]["清理"]
        ____self_21["登记延迟回调"](____self_21, "教派剑士测试-旋风结束检查", callbackId)
    end
    debugLogForce(
        "教派剑士Boss技能测试",
        "主动测试执行",
        "skill=",
        "深渊旋风",
        "started=",
        _____662F_5426_5F00_59CB
    )
end
local function _____6D4B_8BD5_6DF1_6E0A_65CB_98CE_6253_65AD(_player, context)
    _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5251_58EB_6DF1_6E0A_65CB_98CE(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(100, ____on_6559_6D3E_5251_58EB_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "旋风打断"})
        local ____self_22 = context["运行时"]["清理"]
        ____self_22["登记延迟回调"](____self_22, "教派剑士测试-旋风打断", callbackId)
    end
    debugLogForce(
        "教派剑士Boss技能测试",
        "深渊旋风受控打断测试",
        "started=",
        _____662F_5426_5F00_59CB,
        "expected=",
        "旋风状态存在时Boss受到硬控制，后续轮次停止"
    )
end
local function _____6D4B_8BD5_9ED1_6D1E_8DE8_8D8A(_player, context)
    _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5251_58EB_9ED1_6D1E_8DE8_8D8A(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(7000, ____on_6559_6D3E_5251_58EB_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "黑洞穿越结束检查"})
        local ____self_23 = context["运行时"]["清理"]
        ____self_23["登记延迟回调"](____self_23, "教派剑士测试-黑洞穿越结束检查", callbackId)
    end
    debugLogForce(
        "教派剑士Boss技能测试",
        "主动测试执行",
        "skill=",
        "黑洞跨越",
        "started=",
        _____662F_5426_5F00_59CB,
        "expected=",
        "Boss进入后在玩家身后出现并自动追击，最终状态清理"
    )
end
local function _____6D4B_8BD5_9ED1_6D1E_6467_6BC1(_player, context)
    _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5251_58EB_9ED1_6D1E_8DE8_8D8A(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(4100, ____on_6559_6D3E_5251_58EB_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "黑洞摧毁"})
        local ____self_24 = context["运行时"]["清理"]
        ____self_24["登记延迟回调"](____self_24, "教派剑士测试-黑洞摧毁", callbackId)
    end
    debugLogForce(
        "教派剑士Boss技能测试",
        "施法硬直结束后攻击黑洞测试",
        "started=",
        _____662F_5426_5F00_59CB,
        "delayMs=",
        4100,
        "expected=",
        "黑洞真实创建后再攻击，触发摧毁爆炸、吸引与强化普攻窗口"
    )
end
local function _____6D4B_8BD5_9B54_796D_5438_9B42(_player, context)
    _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5251_58EB_9B54_796D_5438_9B42(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(4000, ____on_6559_6D3E_5251_58EB_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "魔祭结算检查"})
        local ____self_25 = context["运行时"]["清理"]
        ____self_25["登记延迟回调"](____self_25, "教派剑士测试-魔祭结算检查", callbackId)
    end
    debugLogForce(
        "教派剑士Boss技能测试",
        "主动测试执行",
        "skill=",
        "魔祭吸魂",
        "started=",
        _____662F_5426_5F00_59CB
    )
end
local function _____6D4B_8BD5_9B54_796D_5438_9B42_706B_5149_53CD_566C(_player, context)
    _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5251_58EB_9B54_796D_5438_9B42(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(1400, ____on_6559_6D3E_5251_58EB_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "魔祭火光反噬"})
        local ____self_26 = context["运行时"]["清理"]
        ____self_26["登记延迟回调"](____self_26, "教派剑士测试-魔祭火光反噬", callbackId)
    end
    debugLogForce(
        "教派剑士Boss技能测试",
        "魔祭吸魂火属性反噬测试",
        "started=",
        _____662F_5426_5F00_59CB,
        "expected=",
        "进入2秒生效状态后提交火属性与光属性伤害，观察一次性反噬和无视韧性眩晕"
    )
end
local function _____6D4B_8BD5_6DF1_6E0A_5206_8EAB(_player, context)
    _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5251_58EB_6DF1_6E0A_5206_8EAB(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(5600, ____on_6559_6D3E_5251_58EB_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "分身自然结束检查"})
        local ____self_27 = context["运行时"]["清理"]
        ____self_27["登记延迟回调"](____self_27, "教派剑士测试-分身自然结束检查", callbackId)
    end
    debugLogForce(
        "教派剑士Boss技能测试",
        "主动测试执行",
        "skill=",
        "深渊分身",
        "started=",
        _____662F_5426_5F00_59CB
    )
end
local function _____6D4B_8BD5_6DF1_6E0A_5206_8EAB_5168_706D(_player, context)
    _____91CD_7F6E_6559_6D3E_5251_58EB_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5251_58EB_6DF1_6E0A_5206_8EAB(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(700, ____on_6559_6D3E_5251_58EB_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "分身全灭"})
        local ____self_28 = context["运行时"]["清理"]
        ____self_28["登记延迟回调"](____self_28, "教派剑士测试-分身全灭", callbackId)
    end
    debugLogForce(
        "教派剑士Boss技能测试",
        "深渊分身玩家全灭测试",
        "started=",
        _____662F_5426_5F00_59CB,
        "expected=",
        "全部真实分身由玩家普攻摧毁，Boss返回起点并硬直2.5秒"
    )
end
local _____6559_6D3E_5251_58EB_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["命令"] = "剑士1", ["名称"] = "黑魔法侵蚀普攻", ["执行"] = _____6D4B_8BD5_9ED1_9B54_6CD5_4FB5_8680_666E_653B},
    {["序号"] = 2, ["命令"] = "剑士2", ["名称"] = "黑魔法法术暴击", ["执行"] = _____6D4B_8BD5_9ED1_9B54_6CD5_6CD5_672F_66B4_51FB},
    {["序号"] = 3, ["命令"] = "剑士3", ["名称"] = "深渊旋风", ["执行"] = _____6D4B_8BD5_6DF1_6E0A_65CB_98CE},
    {["序号"] = 3, ["命令"] = "剑士3-2", ["名称"] = "深渊旋风受控打断", ["执行"] = _____6D4B_8BD5_6DF1_6E0A_65CB_98CE_6253_65AD},
    {["序号"] = 4, ["命令"] = "剑士4", ["名称"] = "黑洞跨越", ["执行"] = _____6D4B_8BD5_9ED1_6D1E_8DE8_8D8A},
    {["序号"] = 4, ["命令"] = "剑士4-2", ["名称"] = "黑洞摧毁", ["执行"] = _____6D4B_8BD5_9ED1_6D1E_6467_6BC1},
    {["序号"] = 5, ["命令"] = "剑士5", ["名称"] = "魔祭吸魂", ["执行"] = _____6D4B_8BD5_9B54_796D_5438_9B42},
    {["序号"] = 5, ["命令"] = "剑士5-2", ["名称"] = "魔祭火光反噬", ["执行"] = _____6D4B_8BD5_9B54_796D_5438_9B42_706B_5149_53CD_566C},
    {["序号"] = 6, ["命令"] = "剑士6", ["名称"] = "深渊分身", ["执行"] = _____6D4B_8BD5_6DF1_6E0A_5206_8EAB},
    {["序号"] = 6, ["命令"] = "剑士6-2", ["名称"] = "深渊分身全灭", ["执行"] = _____6D4B_8BD5_6DF1_6E0A_5206_8EAB_5168_706D}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "教派剑士",
    ["Boss名称"] = "蒙面人（剑士姿态）",
    ["场地"] = {["正式中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}, ["测试空地中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}},
    ["创建或获取上下文"] = _____521B_5EFA_6216_83B7_53D6_6559_6D3E_5251_58EB_6D4B_8BD5_4E0A_4E0B_6587,
    ["清理上下文"] = _____6E05_7406_6559_6D3E_5251_58EB_6D4B_8BD5_4E0A_4E0B_6587,
    ["技能命令列表"] = _____6559_6D3E_5251_58EB_6D4B_8BD5_6280_80FD_5217_8868
})
debugLogForce("教派剑士Boss技能测试", "隔离测试命令组注册完成", "commandCount=", #_____6559_6D3E_5251_58EB_6D4B_8BD5_6280_80FD_5217_8868)
return ____exports
