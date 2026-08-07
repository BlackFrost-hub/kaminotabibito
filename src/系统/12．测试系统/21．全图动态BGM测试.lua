--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_0["是允许测试玩家"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local ____require_result_3 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____6CE8_518C_52A8_6001_77E9_5F62_533A_57DF = ____require_result_3["注册动态矩形区域"]
local _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF = ____require_result_3["注销动态矩形区域"]
local ____require_result_4 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local SetStackedSoundBJ = ____require_result_4.SetStackedSoundBJ
local GetWorldBounds = jass.GetWorldBounds
local GetRectMinX = jass.GetRectMinX
local GetRectMaxX = jass.GetRectMaxX
local GetRectMinY = jass.GetRectMinY
local GetRectMaxY = jass.GetRectMaxY
local CreateSound = jass.CreateSound
local StartSound = jass.StartSound
local StopSound = jass.StopSound
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local _____6A21_5757_540D = "全图动态BGM测试"
local _____6D4B_8BD5_547D_4EE4 = "全图BGM测试"
local _____6E05_7406_547D_4EE4 = "全图BGM清理"
local _____52A8_6001_77E9_5F62_952E = "测试.全图动态BGM"
local _____6D4B_8BD5_97F3_4E50_8DEF_5F84 = "Sound\\BGM\\Scene\\SealCore\\Ryo Kondo - Abode of the Ancient Gods.mp3"
local _____6D4B_8BD5_77E9_5F62 = nil
local _____6D4B_8BD5_97F3_9891 = nil
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____6E05_7406_5168_56FEBGM()
    local _____6709_72B6_6001 = _____53E5_67C4_6709_6548(_____6D4B_8BD5_77E9_5F62) or _____53E5_67C4_6709_6548(_____6D4B_8BD5_97F3_9891)
    if _____53E5_67C4_6709_6548(_____6D4B_8BD5_97F3_9891) and _____53E5_67C4_6709_6548(_____6D4B_8BD5_77E9_5F62) then
        SetStackedSoundBJ(false, _____6D4B_8BD5_97F3_9891, _____6D4B_8BD5_77E9_5F62)
    end
    if _____53E5_67C4_6709_6548(_____6D4B_8BD5_97F3_9891) then
        StopSound(_____6D4B_8BD5_97F3_9891, true, false)
    end
    local _____6CE8_9500_6210_529F = _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____52A8_6001_77E9_5F62_952E)
    _____6D4B_8BD5_77E9_5F62 = nil
    _____6D4B_8BD5_97F3_9891 = nil
    if _____6709_72B6_6001 or _____6CE8_9500_6210_529F then
        debugLogForce(
            _____6A21_5757_540D,
            "已清理",
            "动态矩形键",
            _____52A8_6001_77E9_5F62_952E,
            "注销成功",
            _____6CE8_9500_6210_529F
        )
    end
    return _____6709_72B6_6001 or _____6CE8_9500_6210_529F
end
local function _____5F00_59CB_5168_56FEBGM(player)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    _____6E05_7406_5168_56FEBGM()
    local _____4E16_754C_8FB9_754C = GetWorldBounds()
    if not _____53E5_67C4_6709_6548(_____4E16_754C_8FB9_754C) then
        debugLogForce(_____6A21_5757_540D, "创建失败", "原因=GetWorldBounds返回空句柄")
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            6,
            "[全图BGM测试] 创建失败：无法取得地图边界。"
        )
        return
    end
    local _____5DE6 = GetRectMinX(_____4E16_754C_8FB9_754C)
    local _____53F3 = GetRectMaxX(_____4E16_754C_8FB9_754C)
    local _____4E0B = GetRectMinY(_____4E16_754C_8FB9_754C)
    local _____4E0A = GetRectMaxY(_____4E16_754C_8FB9_754C)
    _____6D4B_8BD5_77E9_5F62 = _____6CE8_518C_52A8_6001_77E9_5F62_533A_57DF({
        ["键"] = _____52A8_6001_77E9_5F62_952E,
        ["左"] = _____5DE6,
        ["右"] = _____53F3,
        ["下"] = _____4E0B,
        ["上"] = _____4E0A,
        ["说明"] = "测试用当前地图全图动态矩形"
    })
    if not _____53E5_67C4_6709_6548(_____6D4B_8BD5_77E9_5F62) then
        debugLogForce(
            _____6A21_5757_540D,
            "创建失败",
            "原因=动态矩形创建失败",
            "左",
            _____5DE6,
            "右",
            _____53F3,
            "下",
            _____4E0B,
            "上",
            _____4E0A
        )
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            6,
            "[全图BGM测试] 创建失败：动态矩形无效。"
        )
        return
    end
    _____6D4B_8BD5_97F3_9891 = CreateSound(
        _____6D4B_8BD5_97F3_4E50_8DEF_5F84,
        true,
        false,
        false,
        10,
        10,
        "DefaultEAXON"
    )
    if not _____53E5_67C4_6709_6548(_____6D4B_8BD5_97F3_9891) then
        _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____52A8_6001_77E9_5F62_952E)
        _____6D4B_8BD5_77E9_5F62 = nil
        debugLogForce(
            _____6A21_5757_540D,
            "创建失败",
            "原因=CreateSound返回空句柄",
            "音乐路径",
            _____6D4B_8BD5_97F3_4E50_8DEF_5F84
        )
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            6,
            "[全图BGM测试] 创建失败：音频句柄无效。"
        )
        return
    end
    SetStackedSoundBJ(true, _____6D4B_8BD5_97F3_9891, _____6D4B_8BD5_77E9_5F62)
    StartSound(_____6D4B_8BD5_97F3_9891)
    debugLogForce(
        _____6A21_5757_540D,
        "创建并播放成功",
        "动态矩形键",
        _____52A8_6001_77E9_5F62_952E,
        "左",
        _____5DE6,
        "右",
        _____53F3,
        "下",
        _____4E0B,
        "上",
        _____4E0A,
        "音乐路径",
        _____6D4B_8BD5_97F3_4E50_8DEF_5F84
    )
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        "[全图BGM测试] 已创建全图动态矩形并播放测试音乐。输入“全图BGM清理”结束测试。"
    )
end
local function _____6267_884C_6E05_7406_547D_4EE4(player, _command)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local _____6E05_7406_6210_529F = _____6E05_7406_5168_56FEBGM()
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        6,
        _____6E05_7406_6210_529F and "[全图BGM测试] 已清理测试矩形和音频。" or "[全图BGM测试] 当前没有需要清理的测试对象。"
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, _____5F00_59CB_5168_56FEBGM)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6E05_7406_547D_4EE4, _____6267_884C_6E05_7406_547D_4EE4)
debugLogForce(_____6A21_5757_540D, "已注册命令", _____6D4B_8BD5_547D_4EE4, _____6E05_7406_547D_4EE4)
return ____exports
