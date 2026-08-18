--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.13．坂井悠二.00．配置")
local _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["坂井悠二技能配置"]
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
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_5.debugLogForce
local ____require_result_6 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitVertexColorBJ = ____require_result_6.SetUnitVertexColorBJ
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_GetPointZ = ____require_result_7.EC_GetPointZ
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local CreateUnit = jass.CreateUnit
local DestroyEffect = jass.DestroyEffect
local DzSetUnitModel = japi.DzSetUnitModel
local EXSetEffectSize = japi.EXSetEffectSize
local EXSetEffectZ = japi.EXSetEffectZ
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitFacing = jass.GetUnitFacing
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local RemoveUnit = jass.RemoveUnit
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitScale = jass.SetUnitScale
local SetUnitState = jass.SetUnitState
local SetUnitTimeScale = jass.SetUnitTimeScale
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____914D_7F6E = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.D
local _____6A21_5757_540D = "坂井悠二D蛇特效测试"
local _____76F4_63A5_6A21_578B_547D_4EE4 = "-测试坂井D模型"
local _____9644_52A0_6A21_578B_547D_4EE4 = "-测试坂井D附加"
local _____89C2_5BDF_65F6_95F4_6BEB_79D2 = 10000
local function _____53D6_6709_6548_82F1_96C4(_____73A9_5BB6)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(_____73A9_5BB6) then
        return nil
    end
    local _____82F1_96C4 = getRegisteredPlayerHero(_____73A9_5BB6)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到输入指令玩家的已注册英雄")
        return nil
    end
    return _____82F1_96C4
end
local function _____6E05_7406_76F4_63A5_6A21_578B(_____53C2_6570)
    local _____4E0A_4E0B_6587 = _____53C2_6570
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    if _____4E0A_4E0B_6587["蛇头"] ~= nil and _____4E0A_4E0B_6587["蛇头"] ~= 0 then
        DestroyEffect(_____4E0A_4E0B_6587["蛇头"])
    end
    if _____4E0A_4E0B_6587["蛇身"] ~= nil and _____4E0A_4E0B_6587["蛇身"] ~= 0 then
        DestroyEffect(_____4E0A_4E0B_6587["蛇身"])
    end
    if _____4E0A_4E0B_6587["绿黑光束"] ~= nil and _____4E0A_4E0B_6587["绿黑光束"] ~= 0 then
        DestroyEffect(_____4E0A_4E0B_6587["绿黑光束"])
    end
    debugLogForce(_____6A21_5757_540D, "直接模型测试已自动清理")
end
local function _____6E05_7406_9644_52A0_6A21_578B(_____53C2_6570)
    local _____4E0A_4E0B_6587 = _____53C2_6570
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    if _____4E0A_4E0B_6587["蛇头"] ~= nil and _____4E0A_4E0B_6587["蛇头"] ~= 0 then
        DestroyEffect(_____4E0A_4E0B_6587["蛇头"])
    end
    if _____4E0A_4E0B_6587["蛇身"] ~= nil and _____4E0A_4E0B_6587["蛇身"] ~= 0 then
        DestroyEffect(_____4E0A_4E0B_6587["蛇身"])
    end
    if _____4E0A_4E0B_6587["绿黑光束"] ~= nil and _____4E0A_4E0B_6587["绿黑光束"] ~= 0 then
        DestroyEffect(_____4E0A_4E0B_6587["绿黑光束"])
    end
    if _____4E0A_4E0B_6587["原生对照"] ~= nil and _____4E0A_4E0B_6587["原生对照"] ~= 0 then
        DestroyEffect(_____4E0A_4E0B_6587["原生对照"])
    end
    if _____4E0A_4E0B_6587["头部马甲"] ~= nil and _____4E0A_4E0B_6587["头部马甲"] ~= 0 then
        RemoveUnit(_____4E0A_4E0B_6587["头部马甲"])
    end
    if _____4E0A_4E0B_6587["蛇身马甲"] ~= nil and _____4E0A_4E0B_6587["蛇身马甲"] ~= 0 then
        RemoveUnit(_____4E0A_4E0B_6587["蛇身马甲"])
    end
    debugLogForce(_____6A21_5757_540D, "附加模型测试已自动清理")
end
local function ____on_76F4_63A5_6A21_578B_6D4B_8BD5(_____73A9_5BB6, ______547D_4EE4)
    local _____82F1_96C4 = _____53D6_6709_6548_82F1_96C4(_____73A9_5BB6)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local x = GetUnitX(_____82F1_96C4)
    local y = GetUnitY(_____82F1_96C4)
    local _____82F1_96C4Z = EC_GetPointZ(x, y) + GetUnitFlyHeight(_____82F1_96C4)
    local _____86C7_5934_914D_7F6E = _____914D_7F6E["马甲一"]["特效"]
    local _____86C7_8EAB_914D_7F6E = _____914D_7F6E["马甲二"]["特效"][1]
    local _____5149_675F_914D_7F6E = _____914D_7F6E["马甲二"]["特效"][2]
    local _____86C7_5934 = AddSpecialEffect(_____86C7_5934_914D_7F6E["模型路径"], x, y)
    local _____86C7_8EAB = AddSpecialEffect(_____86C7_8EAB_914D_7F6E["模型路径"], x, y)
    local _____7EFF_9ED1_5149_675F = AddSpecialEffect(_____5149_675F_914D_7F6E["模型路径"], x, y)
    if _____86C7_5934 ~= nil and _____86C7_5934 ~= 0 then
        EXSetEffectSize(_____86C7_5934, _____914D_7F6E["马甲一"]["缩放"])
        EXSetEffectZ(_____86C7_5934, _____82F1_96C4Z + _____914D_7F6E["马甲一"]["飞行高度增量"])
    end
    if _____86C7_8EAB ~= nil and _____86C7_8EAB ~= 0 then
        EXSetEffectSize(_____86C7_8EAB, _____914D_7F6E["马甲二"]["缩放"])
        EXSetEffectZ(_____86C7_8EAB, _____82F1_96C4Z + _____914D_7F6E["马甲二"]["飞行高度增量"])
    end
    if _____7EFF_9ED1_5149_675F ~= nil and _____7EFF_9ED1_5149_675F ~= 0 then
        EXSetEffectSize(_____7EFF_9ED1_5149_675F, _____914D_7F6E["马甲二"]["缩放"])
        EXSetEffectZ(_____7EFF_9ED1_5149_675F, _____82F1_96C4Z + _____914D_7F6E["马甲二"]["飞行高度增量"])
    end
    addDelayedCallback(_____89C2_5BDF_65F6_95F4_6BEB_79D2, _____6E05_7406_76F4_63A5_6A21_578B, {["蛇头"] = _____86C7_5934, ["蛇身"] = _____86C7_8EAB, ["绿黑光束"] = _____7EFF_9ED1_5149_675F})
    debugLogForce(
        _____6A21_5757_540D,
        "直接模型已在玩家英雄位置创建",
        "英雄",
        GetHandleId(_____82F1_96C4),
        "X",
        x,
        "Y",
        y,
        "蛇头句柄",
        GetHandleId(_____86C7_5934),
        "蛇身句柄",
        GetHandleId(_____86C7_8EAB),
        "光束句柄",
        GetHandleId(_____7EFF_9ED1_5149_675F),
        "观察秒",
        _____89C2_5BDF_65F6_95F4_6BEB_79D2 / 1000
    )
end
local function _____521D_59CB_5316_6D4B_8BD5_9A6C_7532(_____9A6C_7532, _____7F29_653E, _____9AD8_5EA6, _____52A8_753B_7F16_53F7, _____65F6_95F4_7F29_653E, _____989C_8272)
    if _____9A6C_7532 == nil or _____9A6C_7532 == 0 then
        return
    end
    DzSetUnitModel(_____9A6C_7532, _____914D_7F6E["马甲载体模型路径"])
    SetUnitState(_____9A6C_7532, UNIT_STATE_MAX_LIFE, _____914D_7F6E["马甲一"]["HP保障值"])
    SetUnitState(_____9A6C_7532, UNIT_STATE_LIFE, _____914D_7F6E["马甲一"]["HP保障值"])
    SetUnitAnimationByIndex(_____9A6C_7532, _____52A8_753B_7F16_53F7)
    SetUnitTimeScale(_____9A6C_7532, _____65F6_95F4_7F29_653E)
    SetUnitScale(_____9A6C_7532, _____7F29_653E, _____7F29_653E, _____7F29_653E)
    SetUnitVertexColorBJ(
        _____9A6C_7532,
        _____989C_8272["红"],
        _____989C_8272["绿"],
        _____989C_8272["蓝"],
        _____989C_8272["透明度"]
    )
    SetUnitFlyHeight(_____9A6C_7532, _____9AD8_5EA6, 0)
end
local function _____6267_884C_5EF6_8FDF_9644_52A0_6D4B_8BD5(_____53C2_6570)
    local _____4E0A_4E0B_6587 = _____53C2_6570
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    if _____4E0A_4E0B_6587["头部马甲"] == nil or _____4E0A_4E0B_6587["头部马甲"] == 0 or _____4E0A_4E0B_6587["蛇身马甲"] == nil or _____4E0A_4E0B_6587["蛇身马甲"] == 0 then
        debugLogForce(_____6A21_5757_540D, "延迟附加失败：测试马甲无效")
        _____6E05_7406_9644_52A0_6A21_578B(_____4E0A_4E0B_6587)
        return
    end
    _____4E0A_4E0B_6587["蛇头"] = AddSpecialEffectTarget(_____914D_7F6E["马甲一"]["特效"]["模型路径"], _____4E0A_4E0B_6587["头部马甲"], _____914D_7F6E["马甲一"]["特效"]["挂点"])
    _____4E0A_4E0B_6587["蛇身"] = AddSpecialEffectTarget(_____914D_7F6E["马甲二"]["特效"][1]["模型路径"], _____4E0A_4E0B_6587["蛇身马甲"], _____914D_7F6E["马甲二"]["特效"][1]["挂点"])
    _____4E0A_4E0B_6587["绿黑光束"] = AddSpecialEffectTarget(_____914D_7F6E["马甲二"]["特效"][2]["模型路径"], _____4E0A_4E0B_6587["蛇身马甲"], _____914D_7F6E["马甲二"]["特效"][2]["挂点"])
    _____4E0A_4E0B_6587["原生对照"] = AddSpecialEffectTarget("Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl", _____4E0A_4E0B_6587["头部马甲"], "origin")
    addDelayedCallback(_____89C2_5BDF_65F6_95F4_6BEB_79D2, _____6E05_7406_9644_52A0_6A21_578B, _____4E0A_4E0B_6587)
    debugLogForce(
        _____6A21_5757_540D,
        "延迟0.05秒后完成附加",
        "头部马甲",
        GetHandleId(_____4E0A_4E0B_6587["头部马甲"]),
        "蛇身马甲",
        GetHandleId(_____4E0A_4E0B_6587["蛇身马甲"]),
        "蛇头句柄",
        GetHandleId(_____4E0A_4E0B_6587["蛇头"]),
        "蛇身句柄",
        GetHandleId(_____4E0A_4E0B_6587["蛇身"]),
        "光束句柄",
        GetHandleId(_____4E0A_4E0B_6587["绿黑光束"]),
        "原生对照句柄",
        GetHandleId(_____4E0A_4E0B_6587["原生对照"]),
        "观察秒",
        _____89C2_5BDF_65F6_95F4_6BEB_79D2 / 1000
    )
end
local function ____on_9644_52A0_6A21_578B_6D4B_8BD5(_____73A9_5BB6, ______547D_4EE4)
    local _____82F1_96C4 = _____53D6_6709_6548_82F1_96C4(_____73A9_5BB6)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local x = GetUnitX(_____82F1_96C4)
    local y = GetUnitY(_____82F1_96C4)
    local _____9762_5411 = GetUnitFacing(_____82F1_96C4)
    local _____82F1_96C4_98DE_884C_9AD8_5EA6 = GetUnitFlyHeight(_____82F1_96C4)
    local _____9A6C_7532_7C7B_578BID = stringToFourCCSafe(_____914D_7F6E["马甲一"]["单位类型ID"])
    local owner = GetOwningPlayer(_____82F1_96C4)
    local _____5934_90E8_9A6C_7532 = CreateUnit(
        owner,
        _____9A6C_7532_7C7B_578BID,
        x,
        y,
        _____9762_5411
    )
    local _____86C7_8EAB_9A6C_7532 = CreateUnit(
        owner,
        _____9A6C_7532_7C7B_578BID,
        x,
        y,
        _____9762_5411
    )
    _____521D_59CB_5316_6D4B_8BD5_9A6C_7532(
        _____5934_90E8_9A6C_7532,
        _____914D_7F6E["马甲一"]["缩放"],
        _____82F1_96C4_98DE_884C_9AD8_5EA6 + _____914D_7F6E["马甲一"]["飞行高度增量"],
        _____914D_7F6E["马甲一"]["动画编号"],
        _____914D_7F6E["马甲一"]["时间缩放"],
        _____914D_7F6E["马甲一"]["颜色"]
    )
    _____521D_59CB_5316_6D4B_8BD5_9A6C_7532(
        _____86C7_8EAB_9A6C_7532,
        _____914D_7F6E["马甲二"]["缩放"],
        _____82F1_96C4_98DE_884C_9AD8_5EA6 + _____914D_7F6E["马甲二"]["飞行高度增量"],
        _____914D_7F6E["马甲二"]["动画编号"],
        _____914D_7F6E["马甲二"]["时间缩放"],
        _____914D_7F6E["马甲二"]["颜色"]
    )
    local _____4E0A_4E0B_6587 = {
        ["头部马甲"] = _____5934_90E8_9A6C_7532,
        ["蛇身马甲"] = _____86C7_8EAB_9A6C_7532,
        ["蛇头"] = nil,
        ["蛇身"] = nil,
        ["绿黑光束"] = nil,
        ["原生对照"] = nil
    }
    addDelayedCallback(50, _____6267_884C_5EF6_8FDF_9644_52A0_6D4B_8BD5, _____4E0A_4E0B_6587)
    debugLogForce(
        _____6A21_5757_540D,
        "附加载体已在玩家英雄位置创建，等待0.05秒刷新模型节点",
        "英雄",
        GetHandleId(_____82F1_96C4),
        "X",
        x,
        "Y",
        y,
        "马甲类型",
        _____914D_7F6E["马甲一"]["单位类型ID"],
        "载体模型",
        _____914D_7F6E["马甲载体模型路径"],
        "头部马甲",
        GetHandleId(_____5934_90E8_9A6C_7532),
        "蛇身马甲",
        GetHandleId(_____86C7_8EAB_9A6C_7532)
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____76F4_63A5_6A21_578B_547D_4EE4, ____on_76F4_63A5_6A21_578B_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____9644_52A0_6A21_578B_547D_4EE4, ____on_9644_52A0_6A21_578B_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "测试命令已注册", _____76F4_63A5_6A21_578B_547D_4EE4, _____9644_52A0_6A21_578B_547D_4EE4)
return ____exports
