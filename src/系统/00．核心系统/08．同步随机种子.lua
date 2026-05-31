--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 同步随机种子
-- 
-- 只在地图启动时设置一次 JASS 随机种子，避免每局都从同一条随机序列开头开始。
local jass = require("jass.common")
local japi = require("jass.japi")
local CreateTimer = jass.CreateTimer
local DestroyTimer = jass.DestroyTimer
local TimerStart = jass.TimerStart
local SetRandomSeed = jass.SetRandomSeed
local R2I = jass.R2I
local DzAPI_Map_GetGameStartTime = japi.DzAPI_Map_GetGameStartTime
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local _____8C03_8BD5_6A21_5757 = "同步随机种子"
local _____6700_5927_79CD_5B50 = 2147483647
local _____6700_591A_7B49_5F85_65E5_5FD7_6B21_6570 = 5
local _____5DF2_8BBE_7F6E = false
local _____91CD_8BD5_8BA1_65F6_5668 = nil
local _____7B49_5F85_65E5_5FD7_6B21_6570 = 0
local function _____8F93_51FA_65E5_5FD7(...)
    debugLogForce(nil, _____8C03_8BD5_6A21_5757, ...)
end
local function _____53D6_540C_6B65_79CD_5B50()
    local startTime = DzAPI_Map_GetGameStartTime()
    if startTime == nil or startTime <= 0 then
        return 0
    end
    local seed = R2I(startTime)
    if seed <= 0 then
        return 0
    end
    if seed > _____6700_5927_79CD_5B50 then
        seed = seed % _____6700_5927_79CD_5B50
    end
    return seed > 0 and seed or 1
end
local function _____9500_6BC1_91CD_8BD5_8BA1_65F6_5668()
    if not _____91CD_8BD5_8BA1_65F6_5668 then
        return
    end
    DestroyTimer(_____91CD_8BD5_8BA1_65F6_5668)
    _____91CD_8BD5_8BA1_65F6_5668 = nil
end
local function _____5C1D_8BD5_8BBE_7F6E_540C_6B65_968F_673A_79CD_5B50()
    if _____5DF2_8BBE_7F6E then
        return true
    end
    local seed = _____53D6_540C_6B65_79CD_5B50()
    if seed <= 0 then
        if _____7B49_5F85_65E5_5FD7_6B21_6570 < _____6700_591A_7B49_5F85_65E5_5FD7_6B21_6570 then
            _____7B49_5F85_65E5_5FD7_6B21_6570 = _____7B49_5F85_65E5_5FD7_6B21_6570 + 1
            _____8F93_51FA_65E5_5FD7("等待有效启动时间", "第", _____7B49_5F85_65E5_5FD7_6B21_6570, "次")
        end
        return false
    end
    SetRandomSeed(seed)
    _____5DF2_8BBE_7F6E = true
    _____9500_6BC1_91CD_8BD5_8BA1_65F6_5668()
    _____8F93_51FA_65E5_5FD7("已设置", "seed=", seed)
    return true
end
local function ____on_540C_6B65_968F_673A_79CD_5B50_91CD_8BD5()
    _____5C1D_8BD5_8BBE_7F6E_540C_6B65_968F_673A_79CD_5B50()
end
local function _____542F_52A8_540C_6B65_968F_673A_79CD_5B50()
    if _____5C1D_8BD5_8BBE_7F6E_540C_6B65_968F_673A_79CD_5B50() then
        return
    end
    if _____91CD_8BD5_8BA1_65F6_5668 then
        return
    end
    _____91CD_8BD5_8BA1_65F6_5668 = CreateTimer()
    TimerStart(_____91CD_8BD5_8BA1_65F6_5668, 0.1, true, ____on_540C_6B65_968F_673A_79CD_5B50_91CD_8BD5)
end
_____542F_52A8_540C_6B65_968F_673A_79CD_5B50()
return ____exports
