local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberToFixed = ____lualib.__TS__NumberToFixed
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 诅咒命中率测试
-- 
-- 输入 "1020"：
-- - 先把玩家1与大法师的“命中率”都清成 0（即默认 100%）
-- - 再对 gg_unit_Hamg_0002 施加 3 秒诅咒
-- - 立即/到期后分别打印单位命中率属性值与“显示命中率”
-- 
-- 说明：
-- - YDUserData 的“命中率”是相对 100% 的偏移量
-- - 0   = 100%
-- - 0.2 = 120%
-- - -0.33 = 67%
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_setCurse = ____require_result_3.SFB_setCurse
local YDUserDataGet = YDUserDataGetSafe
local YDUserDataSet = YDUserDataSetSafe
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local CreateTimer = jass.CreateTimer
local DestroyTimer = jass.DestroyTimer
local TimerStart = jass.TimerStart
local GetExpiredTimer = jass.GetExpiredTimer
local GetHandleId = jass.GetHandleId
local _____6A21_5757_540D = "诅咒命中率测试"
local _____6D4B_8BD5_547D_4EE4 = "1020"
local ____ATTR__547D_4E2D_7387 = "命中率"
local ____BUFF__6301_7EED_65F6_95F4 = 3
local _____5230_671F_68C0_67E5_4E0A_4E0B_6587 = {}
local function _____5F52_4E00_5316_5B9E_6570(value)
    if value == nil or value == false or value == "" then
        return 0
    end
    local n = type(value) == "number" and value or __TS__Number(value)
    return n ~= n and 0 or n
end
local function _____8BFB_53D6_5355_4F4D_547D_4E2D_7387_504F_79FB(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return _____5F52_4E00_5316_5B9E_6570(YDUserDataGet("unit", unit, ____ATTR__547D_4E2D_7387, "real"))
end
local function _____8BFB_53D6_73A9_5BB6_547D_4E2D_7387_504F_79FB(player)
    if player == nil or player == 0 then
        return 0
    end
    return _____5F52_4E00_5316_5B9E_6570(YDUserDataGet("player", player, ____ATTR__547D_4E2D_7387, "real"))
end
local function _____8BFB_53D6_6709_6548_547D_4E2D_7387_504F_79FB(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local unitValue = _____8BFB_53D6_5355_4F4D_547D_4E2D_7387_504F_79FB(unit)
    if unitValue ~= 0 then
        return unitValue
    end
    return _____8BFB_53D6_73A9_5BB6_547D_4E2D_7387_504F_79FB(GetOwningPlayer(unit))
end
local function _____547D_4E2D_7387_504F_79FB_8F6C_663E_793A_6587_672C(value)
    return __TS__NumberToFixed((1 + value) * 100, 0) .. "%"
end
local function _____662F_5426_8D70_73A9_5BB6_547D_4E2D_7387(unit)
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    local playerId = GetPlayerId(owner)
    return playerId >= 0 and playerId <= 3
end
local function _____6253_5370_547D_4E2D_7387_72B6_6001(stage, unit)
    local owner = GetOwningPlayer(unit)
    local unitOffset = _____8BFB_53D6_5355_4F4D_547D_4E2D_7387_504F_79FB(unit)
    local playerOffset = _____8BFB_53D6_73A9_5BB6_547D_4E2D_7387_504F_79FB(owner)
    local effectiveOffset = _____8BFB_53D6_6709_6548_547D_4E2D_7387_504F_79FB(unit)
    local mode = _____662F_5426_8D70_73A9_5BB6_547D_4E2D_7387(unit) and "玩家" or "单位"
    debugLogForce(
        _____6A21_5757_540D,
        stage,
        "诅咒目标层=",
        mode,
        "单位偏移=",
        unitOffset,
        "玩家偏移=",
        playerOffset,
        "有效偏移=",
        effectiveOffset,
        "显示命中率=",
        _____547D_4E2D_7387_504F_79FB_8F6C_663E_793A_6587_672C(effectiveOffset)
    )
end
local function ____on_8BC5_5492_5230_671F_68C0_67E5()
    local timer = GetExpiredTimer()
    local timerId = GetHandleId(timer)
    local target = _____5230_671F_68C0_67E5_4E0A_4E0B_6587[timerId]
    if target ~= nil and target ~= 0 then
        _____6253_5370_547D_4E2D_7387_72B6_6001("诅咒到期后", target)
    end
    __TS__Delete(_____5230_671F_68C0_67E5_4E0A_4E0B_6587, timerId)
    DestroyTimer(timer)
end
local function _____5B89_6392_5230_671F_68C0_67E5(unit, timeout)
    local timer = CreateTimer()
    local timerId = GetHandleId(timer)
    _____5230_671F_68C0_67E5_4E0A_4E0B_6587[timerId] = unit
    TimerStart(timer, timeout, false, ____on_8BC5_5492_5230_671F_68C0_67E5)
end
local function ____on_804A_5929_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local owner = GetOwningPlayer(_____5927_6CD5_5E08)
    YDUserDataSet(
        "player",
        owner,
        ____ATTR__547D_4E2D_7387,
        "real",
        0
    )
    YDUserDataSet(
        "unit",
        _____5927_6CD5_5E08,
        ____ATTR__547D_4E2D_7387,
        "real",
        0
    )
    _____6253_5370_547D_4E2D_7387_72B6_6001("施加前", _____5927_6CD5_5E08)
    SFB_setCurse(_____5927_6CD5_5E08, _____5927_6CD5_5E08, ____BUFF__6301_7EED_65F6_95F4)
    _____6253_5370_547D_4E2D_7387_72B6_6001("诅咒施加后", _____5927_6CD5_5E08)
    _____5B89_6392_5230_671F_68C0_67E5(_____5927_6CD5_5E08, ____BUFF__6301_7EED_65F6_95F4 + 0.1)
    debugLogForce(_____6A21_5757_540D, "已施加3秒诅咒，预期：100% -> 67% -> 100%")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "测试自定义诅咒命中率")
return ____exports
