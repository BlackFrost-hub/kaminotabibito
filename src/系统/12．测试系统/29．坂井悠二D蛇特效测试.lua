--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.00．配置")
local _____8299_8389_83B2_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲表现配置"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_1["是允许测试玩家"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_4.debugLogForce
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_GetPointZ = ____require_result_5.EC_GetPointZ
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local GetHandleId = jass.GetHandleId
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local EXSetEffectSize = japi.EXSetEffectSize
local EXSetEffectZ = japi.EXSetEffectZ
local _____6A21_5757_540D = "芙莉莲Q附加弹道层测试"
local _____6D4B_8BD5_547D_4EE4 = "-测试芙莉莲Q附加"
local _____6D4B_8BD5_7F29_653E = 2
local _____6D4B_8BD5_9AD8_5EA6 = 50
local _____89C2_5BDF_65F6_95F4_6BEB_79D2 = 10000
local function _____9500_6BC1_6D4B_8BD5_7279_6548(_____53C2_6570)
    local _____7279_6548 = _____53C2_6570
    if _____7279_6548 == nil or _____7279_6548 == 0 then
        return
    end
    DestroyEffect(_____7279_6548)
    debugLogForce(
        _____6A21_5757_540D,
        "测试特效已自动销毁",
        "句柄",
        GetHandleId(_____7279_6548)
    )
end
local function ____on_6D4B_8BD5_8299_8389_83B2Q_9644_52A0(_____73A9_5BB6, ______547D_4EE4)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(_____73A9_5BB6) then
        return
    end
    local _____82F1_96C4 = getRegisteredPlayerHero(_____73A9_5BB6)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到输入指令玩家的已注册英雄")
        return
    end
    local x = GetUnitX(_____82F1_96C4)
    local y = GetUnitY(_____82F1_96C4)
    local z = EC_GetPointZ(x, y) + GetUnitFlyHeight(_____82F1_96C4) + _____6D4B_8BD5_9AD8_5EA6
    local _____6A21_578B_8DEF_5F84 = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道附加特效"]["模型路径"]
    local _____7279_6548 = AddSpecialEffect(_____6A21_578B_8DEF_5F84, x, y)
    if _____7279_6548 == nil or _____7279_6548 == 0 then
        debugLogForce(
            _____6A21_5757_540D,
            "创建失败",
            "模型",
            _____6A21_578B_8DEF_5F84,
            "X",
            x,
            "Y",
            y
        )
        return
    end
    EXSetEffectSize(_____7279_6548, _____6D4B_8BD5_7F29_653E)
    EXSetEffectZ(_____7279_6548, z)
    addDelayedCallback(_____89C2_5BDF_65F6_95F4_6BEB_79D2, _____9500_6BC1_6D4B_8BD5_7279_6548, _____7279_6548)
    debugLogForce(
        _____6A21_5757_540D,
        "已在玩家英雄位置创建",
        "模型",
        _____6A21_578B_8DEF_5F84,
        "缩放",
        _____6D4B_8BD5_7F29_653E,
        "高度",
        _____6D4B_8BD5_9AD8_5EA6,
        "X",
        x,
        "Y",
        y,
        "Z",
        z,
        "句柄",
        GetHandleId(_____7279_6548),
        "观察秒",
        _____89C2_5BDF_65F6_95F4_6BEB_79D2 / 1000
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_6D4B_8BD5_8299_8389_83B2Q_9644_52A0)
debugLogForce(_____6A21_5757_540D, "测试命令已注册", _____6D4B_8BD5_547D_4EE4)
return ____exports
