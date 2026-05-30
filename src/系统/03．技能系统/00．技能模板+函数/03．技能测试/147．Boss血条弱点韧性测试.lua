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
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.01．Boss战运行上下文")
local _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_3["创建Boss战运行上下文"]
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.07．Boss弱点事件桥接")
local _____542F_52A8Boss_8840_6761_5F31_70B9_97E7_6027 = ____require_result_4["启动Boss血条弱点韧性"]
local _____7ED3_675FBoss_8840_6761_5F31_70B9_97E7_6027 = ____require_result_4["结束Boss血条弱点韧性"]
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.01．常量定义")
local ____Boss_5F31_70B9YD_5B57_6BB5 = ____require_result_5["Boss弱点YD字段"]
local _____6A21_5757_540D = "Boss血条弱点韧性测试"
local _____6CE8_518C_547D_4EE4 = "1047"
local _____6E05_7406_547D_4EE4 = "1048"
local _____6D4B_8BD5_62A4_76FE_503C = 10
local _____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587 = nil
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
local function ____on_6CE8_518CBoss_8840_6761_5F31_70B9_97E7_6027_6D4B_8BD5()
    local _____6B65_5175 = _____83B7_53D6_6D4B_8BD5_6B65_5175()
    if _____6B65_5175 == nil or _____6B65_5175 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到 gg_unit_hfoo_0014")
        return
    end
    if _____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587 ~= nil then
        _____7ED3_675FBoss_8840_6761_5F31_70B9_97E7_6027(_____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587)
        _____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587 = nil
    end
    _____5199_5165Boss_8840_6761_6D4B_8BD5YD(_____6B65_5175)
    local context = _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587(_____6B65_5175, nil, nil, nil)
    if context == nil then
        debugLogForce(_____6A21_5757_540D, "创建测试上下文失败")
        return
    end
    _____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587 = context
    _____542F_52A8Boss_8840_6761_5F31_70B9_97E7_6027(context)
    debugLogForce(
        _____6A21_5757_540D,
        "已给 gg_unit_hfoo_0014 注册 Boss 血条弱点韧性测试",
        "护盾=",
        _____6D4B_8BD5_62A4_76FE_503C,
        "弱点=剑/火/暗"
    )
end
local function ____on_6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_6D4B_8BD5()
    if _____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587 == nil then
        debugLogForce(_____6A21_5757_540D, "当前没有测试上下文")
        return
    end
    _____7ED3_675FBoss_8840_6761_5F31_70B9_97E7_6027(_____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587)
    _____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587 = nil
    debugLogForce(_____6A21_5757_540D, "已清理 Boss 血条弱点韧性测试")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6CE8_518C_547D_4EE4, ____on_6CE8_518CBoss_8840_6761_5F31_70B9_97E7_6027_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6E05_7406_547D_4EE4, ____on_6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_6D4B_8BD5)
debugLogForce(
    _____6A21_5757_540D,
    "已注册测试：输入",
    _____6CE8_518C_547D_4EE4,
    "给 gg_unit_hfoo_0014 注册Boss血条；输入",
    _____6E05_7406_547D_4EE4,
    "清理"
)
return ____exports
