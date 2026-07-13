--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_3["创建Boss战运行上下文"]
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.02．Boss弱点韧性配置表")
local _____67E5_627EBoss_5F31_70B9_97E7_6027_914D_7F6E = ____require_result_4["查找Boss弱点韧性配置"]
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.03．Boss血条UI")
local _____6CE8_518CBoss_8840_6761UI = ____require_result_5["注册Boss血条UI"]
local _____6CE8_9500Boss_8840_6761UI = ____require_result_5["注销Boss血条UI"]
local ____require_result_6 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.04．Boss弱点UI")
local _____6CE8_518CBoss_5F31_70B9UI = ____require_result_6["注册Boss弱点UI"]
local _____6CE8_9500Boss_5F31_70B9UI = ____require_result_6["注销Boss弱点UI"]
local ____require_result_7 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.05．Boss弱点运行状态")
local _____521B_5EFABoss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____require_result_7["创建Boss血条弱点韧性运行状态"]
local _____6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____require_result_7["清理Boss血条弱点韧性运行状态"]
local ____require_result_8 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.01．常量定义")
local ____Boss_5F31_70B9YD_5B57_6BB5 = ____require_result_8["Boss弱点YD字段"]
local _____6A21_5757_540D = "Boss血条弱点韧性测试"
local _____5355Boss_72EC_7ACB_62A4_536B_547D_4EE4 = "1047-1"
local _____53CCBoss_72EC_7ACB_62A4_536B_547D_4EE4 = "1047-2"
local _____53CCBoss_5171_4EAB_62A4_536B_547D_4EE4 = "1047-n"
local _____6E05_7406_547D_4EE4 = "1048"
local _____6D4B_8BD5_62A4_76FE_503C = 10
local _____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868 = {}
local function _____83B7_53D6_6D4B_8BD5_6B65_5175()
    return g.gg_unit_hfoo_0014
end
local function _____5199_5165Boss_8840_6761_6D4B_8BD5YD(bossUnit)
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "绑定单位",
        "unit",
        bossUnit
    )
    YDUserDataSetSafe(
        "unit",
        bossUnit,
        ____Boss_5F31_70B9YD_5B57_6BB5["护盾值"],
        "integer",
        _____6D4B_8BD5_62A4_76FE_503C
    )
    YDUserDataSetSafe(
        "unit",
        bossUnit,
        ____Boss_5F31_70B9YD_5B57_6BB5["原始护盾值"],
        "integer",
        _____6D4B_8BD5_62A4_76FE_503C
    )
    YDUserDataSetSafe(
        "unit",
        bossUnit,
        "剑弱",
        "boolean",
        true
    )
    YDUserDataSetSafe(
        "unit",
        bossUnit,
        "火弱",
        "boolean",
        true
    )
    YDUserDataSetSafe(
        "unit",
        bossUnit,
        "暗弱",
        "boolean",
        true
    )
    YDUserDataSetSafe(
        "unit",
        bossUnit,
        "弱点数量",
        "integer",
        3
    )
    YDUserDataSetSafe(
        "unit",
        bossUnit,
        "天生弱点数",
        "integer",
        3
    )
end
local function _____6E05_7406Boss_8840_6761_6D4B_8BD5_72B6_6001()
    do
        local i = #_____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868 - 1
        while i >= 0 do
            local state = _____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868[i + 1]
            state["是否已结束"] = true
            _____6CE8_9500Boss_5F31_70B9UI(state)
            _____6CE8_9500Boss_8840_6761UI(state)
            _____6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(state["Boss句柄ID"])
            i = i - 1
        end
    end
    _____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868 = {}
end
local function ____on_6CE8_518CBoss_8840_6761_5F31_70B9_97E7_6027_6D4B_8BD5(_player, command)
    local bossCount = command == _____5355Boss_72EC_7ACB_62A4_536B_547D_4EE4 and 1 or 2
    local guardType = command == _____53CCBoss_5171_4EAB_62A4_536B_547D_4EE4 and "共享" or "独立"
    _____6E05_7406Boss_8840_6761_6D4B_8BD5_72B6_6001()
    local _____6B65_5175 = _____83B7_53D6_6D4B_8BD5_6B65_5175()
    if _____6B65_5175 == nil or _____6B65_5175 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到 gg_unit_hfoo_0014")
        return
    end
    _____5199_5165Boss_8840_6761_6D4B_8BD5YD(_____6B65_5175)
    local context = _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587(_____6B65_5175, nil, nil, nil)
    if context == nil then
        debugLogForce(_____6A21_5757_540D, "创建测试上下文失败")
        return
    end
    local config = _____67E5_627EBoss_5F31_70B9_97E7_6027_914D_7F6E(_____6B65_5175)
    do
        local bossIndex = 0
        while bossIndex < bossCount do
            local ownerStateKey = -104701 - bossIndex * 3
            local mainState = _____521B_5EFABoss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(
                context,
                config,
                _____6B65_5175,
                "主Boss",
                ownerStateKey,
                ownerStateKey,
                guardType
            )
            _____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868[#_____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868 + 1] = mainState
            _____6CE8_518CBoss_8840_6761UI(mainState)
            _____6CE8_518CBoss_5F31_70B9UI(mainState)
            if guardType == "独立" then
                do
                    local guardIndex = 1
                    while guardIndex <= 2 do
                        local state = _____521B_5EFABoss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(
                            context,
                            config,
                            _____6B65_5175,
                            "护卫",
                            ownerStateKey,
                            ownerStateKey - guardIndex,
                            guardType
                        )
                        _____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868[#_____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868 + 1] = state
                        _____6CE8_518CBoss_8840_6761UI(state)
                        _____6CE8_518CBoss_5F31_70B9UI(state)
                        guardIndex = guardIndex + 1
                    end
                end
            end
            bossIndex = bossIndex + 1
        end
    end
    if guardType == "共享" then
        local sharedOwnerStateKey = -104701
        do
            local guardIndex = 0
            while guardIndex < 2 do
                local state = _____521B_5EFABoss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(
                    context,
                    config,
                    _____6B65_5175,
                    "护卫",
                    sharedOwnerStateKey,
                    -104707 - guardIndex,
                    guardType
                )
                _____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868[#_____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868 + 1] = state
                _____6CE8_518CBoss_8840_6761UI(state)
                _____6CE8_518CBoss_5F31_70B9UI(state)
                guardIndex = guardIndex + 1
            end
        end
    end
    local guardCount = guardType == "共享" and 2 or bossCount * 2
    debugLogForce(
        _____6A21_5757_540D,
        "已自动重置并创建",
        bossCount,
        "个主血条及",
        guardCount,
        "个",
        guardType,
        "护卫血条",
        "护盾=",
        _____6D4B_8BD5_62A4_76FE_503C,
        "弱点=剑/火/暗"
    )
end
local function ____on_6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_6D4B_8BD5()
    if #_____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868 == 0 then
        debugLogForce(_____6A21_5757_540D, "当前没有测试血条")
        return
    end
    local stateCount = #_____6700_8FD1_6D4B_8BD5_72B6_6001_5217_8868
    _____6E05_7406Boss_8840_6761_6D4B_8BD5_72B6_6001()
    debugLogForce(_____6A21_5757_540D, "已清理", stateCount, "条测试血条")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____5355Boss_72EC_7ACB_62A4_536B_547D_4EE4, ____on_6CE8_518CBoss_8840_6761_5F31_70B9_97E7_6027_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____53CCBoss_72EC_7ACB_62A4_536B_547D_4EE4, ____on_6CE8_518CBoss_8840_6761_5F31_70B9_97E7_6027_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____53CCBoss_5171_4EAB_62A4_536B_547D_4EE4, ____on_6CE8_518CBoss_8840_6761_5F31_70B9_97E7_6027_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6E05_7406_547D_4EE4, ____on_6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：1047-1=单Boss独立护卫，1047-2=双Boss独立护卫，1047-n=双Boss共享护卫；每次自动重置；输入", _____6E05_7406_547D_4EE4, "清理")
return ____exports
