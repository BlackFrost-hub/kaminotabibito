local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 单位动画等待通用函数。
-- 用途：播放单位动画、延迟播放单位动画、等待指定秒数后执行下一步。
-- 也可用于纯技能阶段延迟，不依赖单位动画。
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local _____52A8_753B_7B49_5F85_4E0A_4E0B_6587_8868 = {}
local function _____64AD_653E_4E0A_4E0B_6587_52A8_753B(ctx)
    if ctx["单位"] == nil or ctx["单位"] == 0 then
        return
    end
    if type(ctx["动画序号"]) == "number" then
        jass.SetUnitAnimationByIndex(ctx["单位"], ctx["动画序号"])
        return
    end
    if type(ctx["动画名"]) == "string" and ctx["动画名"] ~= "" then
        jass.SetUnitAnimation(ctx["单位"], ctx["动画名"])
    end
end
local function ____on_5355_4F4D_52A8_753B_7B49_5F85_5230_671F()
    local t = jass.GetExpiredTimer()
    if not t then
        return
    end
    local hid = jass.GetHandleId(t)
    local ctx = _____52A8_753B_7B49_5F85_4E0A_4E0B_6587_8868[hid]
    __TS__Delete(_____52A8_753B_7B49_5F85_4E0A_4E0B_6587_8868, hid)
    safeDestroyTimer(nil, t)
    if not ctx then
        return
    end
    _____64AD_653E_4E0A_4E0B_6587_52A8_753B(ctx)
    if ctx["恢复待机"] == true and ctx["单位"] ~= nil and ctx["单位"] ~= 0 then
        jass.SetUnitAnimationByIndex(ctx["单位"], 0)
    end
    if type(ctx["下一步"]) == "function" then
        ctx["下一步"]()
    end
end
local function _____521B_5EFA_52A8_753B_7B49_5F85_8BA1_65F6_5668(ctx, _____7B49_5F85_79D2_6570)
    local t = jass.CreateTimer()
    if not t then
        return nil
    end
    _____52A8_753B_7B49_5F85_4E0A_4E0B_6587_8868[jass.GetHandleId(t)] = ctx
    safeTimerStart(
        nil,
        t,
        _____7B49_5F85_79D2_6570,
        false,
        ____on_5355_4F4D_52A8_753B_7B49_5F85_5230_671F
    )
    return t
end
____exports["播放单位动画并等待"] = function(_____5355_4F4D, _____52A8_753B_5E8F_53F7, _____7B49_5F85_79D2_6570, _____4E0B_4E00_6B65)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if _____7B49_5F85_79D2_6570 < 0 then
        _____7B49_5F85_79D2_6570 = 0
    end
    jass.SetUnitAnimationByIndex(_____5355_4F4D, _____52A8_753B_5E8F_53F7)
    return _____521B_5EFA_52A8_753B_7B49_5F85_8BA1_65F6_5668({["单位"] = _____5355_4F4D, ["下一步"] = _____4E0B_4E00_6B65}, _____7B49_5F85_79D2_6570)
end
____exports["播放单位动作并等待"] = function(_____5355_4F4D, _____52A8_753B_540D, _____7B49_5F85_79D2_6570, _____4E0B_4E00_6B65)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if not _____52A8_753B_540D or _____52A8_753B_540D == "" then
        return nil
    end
    if _____7B49_5F85_79D2_6570 < 0 then
        _____7B49_5F85_79D2_6570 = 0
    end
    jass.SetUnitAnimation(_____5355_4F4D, _____52A8_753B_540D)
    return _____521B_5EFA_52A8_753B_7B49_5F85_8BA1_65F6_5668({["单位"] = _____5355_4F4D, ["下一步"] = _____4E0B_4E00_6B65}, _____7B49_5F85_79D2_6570)
end
____exports["播放单位动画并等待后恢复待机"] = function(_____5355_4F4D, _____52A8_753B_5E8F_53F7, _____7B49_5F85_79D2_6570, _____4E0B_4E00_6B65)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if _____7B49_5F85_79D2_6570 < 0 then
        _____7B49_5F85_79D2_6570 = 0
    end
    jass.SetUnitAnimationByIndex(_____5355_4F4D, _____52A8_753B_5E8F_53F7)
    return _____521B_5EFA_52A8_753B_7B49_5F85_8BA1_65F6_5668({["单位"] = _____5355_4F4D, ["恢复待机"] = true, ["下一步"] = _____4E0B_4E00_6B65}, _____7B49_5F85_79D2_6570)
end
____exports["延迟播放单位动画"] = function(_____5355_4F4D, _____52A8_753B_5E8F_53F7, _____5EF6_8FDF_79D2_6570, _____4E0B_4E00_6B65)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if _____5EF6_8FDF_79D2_6570 < 0 then
        _____5EF6_8FDF_79D2_6570 = 0
    end
    return _____521B_5EFA_52A8_753B_7B49_5F85_8BA1_65F6_5668({["单位"] = _____5355_4F4D, ["动画序号"] = _____52A8_753B_5E8F_53F7, ["下一步"] = _____4E0B_4E00_6B65}, _____5EF6_8FDF_79D2_6570)
end
____exports["延迟播放单位动作"] = function(_____5355_4F4D, _____52A8_753B_540D, _____5EF6_8FDF_79D2_6570, _____4E0B_4E00_6B65)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if not _____52A8_753B_540D or _____52A8_753B_540D == "" then
        return nil
    end
    if _____5EF6_8FDF_79D2_6570 < 0 then
        _____5EF6_8FDF_79D2_6570 = 0
    end
    return _____521B_5EFA_52A8_753B_7B49_5F85_8BA1_65F6_5668({["单位"] = _____5355_4F4D, ["动画名"] = _____52A8_753B_540D, ["下一步"] = _____4E0B_4E00_6B65}, _____5EF6_8FDF_79D2_6570)
end
____exports["零秒后播放单位动画"] = function(_____5355_4F4D, _____52A8_753B_5E8F_53F7, _____4E0B_4E00_6B65)
    return ____exports["延迟播放单位动画"](_____5355_4F4D, _____52A8_753B_5E8F_53F7, 0, _____4E0B_4E00_6B65)
end
____exports["技能延迟执行"] = function(_____5EF6_8FDF_79D2_6570, _____4E0B_4E00_6B65)
    if _____5EF6_8FDF_79D2_6570 < 0 then
        _____5EF6_8FDF_79D2_6570 = 0
    end
    return _____521B_5EFA_52A8_753B_7B49_5F85_8BA1_65F6_5668({["下一步"] = _____4E0B_4E00_6B65}, _____5EF6_8FDF_79D2_6570)
end
return ____exports
