--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 同步随机种子
-- 
-- 仅由 Player(0) 读取平台服务器开局时间并发送低频同步消息。
-- 所有客户端只在同一同步回调中设置 JASS 随机种子，避免各端设置时机不同。
local jass = require("jass.common")
local centerTimer = require("系统.00．核心系统.05．中心计时器")
local dzSync = require("lib.扩展函数.KK扩展API.04．同步数据安全版")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local GetLocalPlayer = jass.GetLocalPlayer
local GetPlayerId = jass.GetPlayerId
local Player = jass.Player
local SetRandomSeed = jass.SetRandomSeed
local R2I = jass.R2I
local I2S = jass.I2S
local S2I = jass.S2I
local _____8C03_8BD5_6A21_5757 = "同步随机种子"
local _____540C_6B65_524D_7F00 = "MAPSEED"
local _____6743_5A01_73A9_5BB6ID = 0
local _____6700_5927_79CD_5B50 = 2147483647
local _____6709_6548_5E73_53F0_65F6_95F4_4E0B_9650_6BEB_79D2 = 1451606400000
local _____91CD_8BD5_95F4_9694_6BEB_79D2 = 100
local _____6700_591A_7B49_5F85_65E5_5FD7_6B21_6570 = 5
local _____5DF2_8BBE_7F6E = false
local _____672C_673A_5DF2_53D1_9001 = false
local _____91CD_8BD5_4EFB_52A1ID
local _____7B49_5F85_65E5_5FD7_6B21_6570 = 0
local function _____8F93_51FA_65E5_5FD7(...)
    debugLogForce(_____8C03_8BD5_6A21_5757, ...)
end
local function _____6807_51C6_5316_79CD_5B50(serverTimeMs)
    local seed = R2I(serverTimeMs / 1000)
    if seed > _____6700_5927_79CD_5B50 then
        seed = seed % _____6700_5927_79CD_5B50
    end
    return seed > 0 and seed or 1
end
local function _____505C_6B62_91CD_8BD5()
    if _____91CD_8BD5_4EFB_52A1ID == nil then
        return
    end
    centerTimer.removePeriodicCallback(_____91CD_8BD5_4EFB_52A1ID)
    _____91CD_8BD5_4EFB_52A1ID = nil
end
local function ____on_6536_5230_540C_6B65_79CD_5B50()
    if _____5DF2_8BBE_7F6E then
        return
    end
    local _____53D1_9001_73A9_5BB6 = dzSync.DzGetTriggerSyncPlayerSafe()
    local _____53D1_9001_73A9_5BB6ID = (_____53D1_9001_73A9_5BB6 == nil or _____53D1_9001_73A9_5BB6 == 0) and -1 or GetPlayerId(_____53D1_9001_73A9_5BB6)
    if _____53D1_9001_73A9_5BB6ID ~= _____6743_5A01_73A9_5BB6ID then
        _____8F93_51FA_65E5_5FD7("拒绝非权威种子", "发送玩家ID=", _____53D1_9001_73A9_5BB6ID)
        return
    end
    local seed = S2I(dzSync.DzGetTriggerSyncDataSafe())
    if seed <= 0 or seed > _____6700_5927_79CD_5B50 then
        _____8F93_51FA_65E5_5FD7("拒绝无效种子", "seed=", seed)
        return
    end
    SetRandomSeed(seed)
    _____5DF2_8BBE_7F6E = true
    _____505C_6B62_91CD_8BD5()
    _____8F93_51FA_65E5_5FD7(
        "同步设置完成",
        "seed=",
        seed,
        "发送玩家ID=",
        _____53D1_9001_73A9_5BB6ID
    )
end
local function ____on_5C1D_8BD5_53D1_9001_79CD_5B50()
    if _____5DF2_8BBE_7F6E then
        _____505C_6B62_91CD_8BD5()
        return
    end
    if GetLocalPlayer() ~= Player(_____6743_5A01_73A9_5BB6ID) then
        return
    end
    if _____672C_673A_5DF2_53D1_9001 then
        return
    end
    local serverTimeMs = centerTimer.getServerTime()
    if serverTimeMs < _____6709_6548_5E73_53F0_65F6_95F4_4E0B_9650_6BEB_79D2 then
        if _____7B49_5F85_65E5_5FD7_6B21_6570 < _____6700_591A_7B49_5F85_65E5_5FD7_6B21_6570 then
            _____7B49_5F85_65E5_5FD7_6B21_6570 = _____7B49_5F85_65E5_5FD7_6B21_6570 + 1
            _____8F93_51FA_65E5_5FD7(
                "等待有效平台服务器时间",
                "第",
                _____7B49_5F85_65E5_5FD7_6B21_6570,
                "次",
                "serverTimeMs=",
                serverTimeMs
            )
        end
        return
    end
    local seed = _____6807_51C6_5316_79CD_5B50(serverTimeMs)
    _____672C_673A_5DF2_53D1_9001 = true
    _____8F93_51FA_65E5_5FD7(
        "权威端发送",
        "seed=",
        seed,
        "serverTimeMs=",
        serverTimeMs
    )
    dzSync.DzSyncDataSafe(
        _____540C_6B65_524D_7F00,
        I2S(seed)
    )
end
local function _____521D_59CB_5316_540C_6B65_968F_673A_79CD_5B50()
    local _____540C_6B65_89E6_53D1_5668 = CreateTrigger()
    TriggerAddAction(_____540C_6B65_89E6_53D1_5668, ____on_6536_5230_540C_6B65_79CD_5B50)
    dzSync.DzTriggerRegisterSyncDataSafe(_____540C_6B65_89E6_53D1_5668, _____540C_6B65_524D_7F00, true)
    _____91CD_8BD5_4EFB_52A1ID = centerTimer.addPeriodicCallback(_____91CD_8BD5_95F4_9694_6BEB_79D2, ____on_5C1D_8BD5_53D1_9001_79CD_5B50)
    _____8F93_51FA_65E5_5FD7(
        "同步监听已注册",
        "prefix=",
        _____540C_6B65_524D_7F00,
        "权威玩家ID=",
        _____6743_5A01_73A9_5BB6ID,
        "重试任务ID=",
        _____91CD_8BD5_4EFB_52A1ID
    )
end
_____521D_59CB_5316_540C_6B65_968F_673A_79CD_5B50()
return ____exports
