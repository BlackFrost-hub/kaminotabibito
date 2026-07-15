--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 单位动画等待通用函数。
-- 用途：播放单位动画、延迟播放单位动画、等待指定秒数后执行下一步。
-- 也可用于纯技能阶段延迟，不依赖单位动画。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local EXSetUnitFacing = ____require_result_0.EXSetUnitFacing
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local getServerTime = ____require_result_1.getServerTime
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local GetHandleId = jass.GetHandleId
local SetUnitFacing = jass.SetUnitFacing
local DEGREES_TO_RADIANS = jass.bj_DEGTORAD
local _____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868 = {}
local _____5355_4F4D_9650_65F6_52A8_753B_4EE4_724C_8868 = {}
local _____52A8_753B_7B49_5F85_4EFB_52A1ID_5E8F_53F7 = 0
local _____5355_4F4D_9650_65F6_52A8_753B_4EE4_724C_5E8F_53F7 = 0
local _____52A8_753B_7B49_5F85_9A71_52A8_5DF2_6CE8_518C = false
local function _____91CD_7F6E_5355_4F4D_5F85_673A_52A8_753B(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    SetUnitAnimation(_____5355_4F4D, "stand")
end
local function _____64AD_653E_4E0A_4E0B_6587_52A8_753B(ctx)
    if ctx["单位"] == nil or ctx["单位"] == 0 then
        return
    end
    if type(ctx["动画序号"]) == "number" then
        SetUnitAnimationByIndex(ctx["单位"], ctx["动画序号"])
        return
    end
    if type(ctx["动画名"]) == "string" and ctx["动画名"] ~= "" then
        SetUnitAnimation(ctx["单位"], ctx["动画名"])
        return
    end
    _____91CD_7F6E_5355_4F4D_5F85_673A_52A8_753B(ctx["单位"])
end
local function _____6267_884C_52A8_753B_7B49_5F85_4E0A_4E0B_6587(ctx)
    _____64AD_653E_4E0A_4E0B_6587_52A8_753B(ctx)
    if ctx["恢复待机"] == true and ctx["单位"] ~= nil and ctx["单位"] ~= 0 then
        SetUnitAnimationByIndex(ctx["单位"], 0)
    end
    if ctx["下一步"] ~= nil then
        ctx["下一步"]()
    end
end
local function ____on_52A8_753B_7B49_5F85_9A71_52A8()
    if #_____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868 == 0 then
        return
    end
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____539F_4EFB_52A1_6570_91CF = #_____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868
    local _____5199_5165_4F4D_7F6E = 0
    do
        local i = 0
        while i < _____539F_4EFB_52A1_6570_91CF do
            local _____4EFB_52A1 = _____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868[i + 1]
            if _____5F53_524D_65F6_95F4_6BEB_79D2 >= _____4EFB_52A1["到期时间毫秒"] then
                _____6267_884C_52A8_753B_7B49_5F85_4E0A_4E0B_6587(_____4EFB_52A1["上下文"])
            else
                _____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868[_____5199_5165_4F4D_7F6E + 1] = _____4EFB_52A1
                _____5199_5165_4F4D_7F6E = _____5199_5165_4F4D_7F6E + 1
            end
            i = i + 1
        end
    end
    do
        local i = _____539F_4EFB_52A1_6570_91CF
        while i < #_____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868 do
            _____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868[_____5199_5165_4F4D_7F6E + 1] = _____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868[i + 1]
            _____5199_5165_4F4D_7F6E = _____5199_5165_4F4D_7F6E + 1
            i = i + 1
        end
    end
    while #_____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868 > _____5199_5165_4F4D_7F6E do
        table.remove(_____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868)
    end
end
local function _____786E_4FDD_52A8_753B_7B49_5F85_9A71_52A8()
    if _____52A8_753B_7B49_5F85_9A71_52A8_5DF2_6CE8_518C then
        return
    end
    _____52A8_753B_7B49_5F85_9A71_52A8_5DF2_6CE8_518C = true
    addPeriodicCallback(10, ____on_52A8_753B_7B49_5F85_9A71_52A8)
end
local function _____521B_5EFA_52A8_753B_7B49_5F85_4EFB_52A1(ctx, _____7B49_5F85_79D2_6570)
    _____52A8_753B_7B49_5F85_4EFB_52A1ID_5E8F_53F7 = _____52A8_753B_7B49_5F85_4EFB_52A1ID_5E8F_53F7 + 1
    local ID = _____52A8_753B_7B49_5F85_4EFB_52A1ID_5E8F_53F7
    _____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868[#_____52A8_753B_7B49_5F85_4EFB_52A1_5217_8868 + 1] = {
        ID = ID,
        ["到期时间毫秒"] = getServerTime() + _____7B49_5F85_79D2_6570 * 1000,
        ["上下文"] = ctx
    }
    _____786E_4FDD_52A8_753B_7B49_5F85_9A71_52A8()
    return ID
end
____exports["播放单位动画并等待"] = function(_____5355_4F4D, _____52A8_753B_5E8F_53F7, _____7B49_5F85_79D2_6570, _____4E0B_4E00_6B65)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if _____7B49_5F85_79D2_6570 < 0 then
        _____7B49_5F85_79D2_6570 = 0
    end
    SetUnitAnimationByIndex(_____5355_4F4D, _____52A8_753B_5E8F_53F7)
    return _____521B_5EFA_52A8_753B_7B49_5F85_4EFB_52A1({["单位"] = _____5355_4F4D, ["下一步"] = _____4E0B_4E00_6B65}, _____7B49_5F85_79D2_6570)
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
    SetUnitAnimation(_____5355_4F4D, _____52A8_753B_540D)
    return _____521B_5EFA_52A8_753B_7B49_5F85_4EFB_52A1({["单位"] = _____5355_4F4D, ["下一步"] = _____4E0B_4E00_6B65}, _____7B49_5F85_79D2_6570)
end
____exports["播放单位动画并等待后恢复待机"] = function(_____5355_4F4D, _____52A8_753B_5E8F_53F7, _____7B49_5F85_79D2_6570, _____4E0B_4E00_6B65)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if _____7B49_5F85_79D2_6570 < 0 then
        _____7B49_5F85_79D2_6570 = 0
    end
    SetUnitAnimationByIndex(_____5355_4F4D, _____52A8_753B_5E8F_53F7)
    return _____521B_5EFA_52A8_753B_7B49_5F85_4EFB_52A1({["单位"] = _____5355_4F4D, ["恢复待机"] = true, ["下一步"] = _____4E0B_4E00_6B65}, _____7B49_5F85_79D2_6570)
end
____exports["播放限时单位动画"] = function(_____53C2_6570)
    local _____5355_4F4D = _____53C2_6570["单位"]
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if _____53C2_6570["动画编号"] == nil and (_____53C2_6570["动画名"] == nil or _____53C2_6570["动画名"] == "") then
        return nil
    end
    local _____5355_4F4DID = GetHandleId(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return nil
    end
    local _____6301_7EED_79D2 = _____53C2_6570["持续秒"]
    if _____6301_7EED_79D2 < 0 then
        _____6301_7EED_79D2 = 0
    end
    _____5355_4F4D_9650_65F6_52A8_753B_4EE4_724C_5E8F_53F7 = _____5355_4F4D_9650_65F6_52A8_753B_4EE4_724C_5E8F_53F7 + 1
    local _____4EE4_724C = _____5355_4F4D_9650_65F6_52A8_753B_4EE4_724C_5E8F_53F7
    _____5355_4F4D_9650_65F6_52A8_753B_4EE4_724C_8868[_____5355_4F4DID] = _____4EE4_724C
    SetUnitTimeScale(_____5355_4F4D, _____53C2_6570["动画速度"] or 1)
    if _____53C2_6570["动画编号"] ~= nil then
        SetUnitAnimationByIndex(_____5355_4F4D, _____53C2_6570["动画编号"])
    else
        SetUnitAnimation(_____5355_4F4D, _____53C2_6570["动画名"])
    end
    local _____91CD_64AD_65F6_70B9_79D2_5217_8868 = _____53C2_6570["重播时点秒列表"] or ({})
    do
        local i = 0
        while i < #_____91CD_64AD_65F6_70B9_79D2_5217_8868 do
            do
                local _____91CD_64AD_65F6_70B9_79D2 = _____91CD_64AD_65F6_70B9_79D2_5217_8868[i + 1]
                if not (_____91CD_64AD_65F6_70B9_79D2 > 0) or _____91CD_64AD_65F6_70B9_79D2 >= _____6301_7EED_79D2 then
                    goto __continue41
                end
                _____521B_5EFA_52A8_753B_7B49_5F85_4EFB_52A1(
                    {["下一步"] = function()
                        if _____5355_4F4D_9650_65F6_52A8_753B_4EE4_724C_8868[_____5355_4F4DID] ~= _____4EE4_724C then
                            return
                        end
                        SetUnitTimeScale(_____5355_4F4D, _____53C2_6570["动画速度"] or 1)
                        if _____53C2_6570["动画编号"] ~= nil then
                            SetUnitAnimationByIndex(_____5355_4F4D, _____53C2_6570["动画编号"])
                        else
                            SetUnitAnimation(_____5355_4F4D, _____53C2_6570["动画名"])
                        end
                    end},
                    _____91CD_64AD_65F6_70B9_79D2
                )
            end
            ::__continue41::
            i = i + 1
        end
    end
    return _____521B_5EFA_52A8_753B_7B49_5F85_4EFB_52A1(
        {["下一步"] = function()
            if _____5355_4F4D_9650_65F6_52A8_753B_4EE4_724C_8868[_____5355_4F4DID] ~= _____4EE4_724C then
                return
            end
            _____5355_4F4D_9650_65F6_52A8_753B_4EE4_724C_8868[_____5355_4F4DID] = nil
            SetUnitTimeScale(_____5355_4F4D, _____53C2_6570["恢复动画速度"] or 1)
            if _____53C2_6570["恢复动画"] ~= false then
                if _____53C2_6570["恢复动画编号"] ~= nil then
                    SetUnitAnimationByIndex(_____5355_4F4D, _____53C2_6570["恢复动画编号"])
                elseif _____53C2_6570["恢复动画名"] ~= nil and _____53C2_6570["恢复动画名"] ~= "" then
                    SetUnitAnimation(_____5355_4F4D, _____53C2_6570["恢复动画名"])
                else
                    SetUnitAnimation(_____5355_4F4D, "stand")
                end
            end
            if _____53C2_6570["完成回调"] ~= nil then
                _____53C2_6570["完成回调"]()
            end
        end},
        _____6301_7EED_79D2
    )
end
____exports["延迟播放单位动画"] = function(_____5355_4F4D, _____52A8_753B_5E8F_53F7, _____5EF6_8FDF_79D2_6570, _____4E0B_4E00_6B65)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if _____5EF6_8FDF_79D2_6570 < 0 then
        _____5EF6_8FDF_79D2_6570 = 0
    end
    return _____521B_5EFA_52A8_753B_7B49_5F85_4EFB_52A1({["单位"] = _____5355_4F4D, ["动画序号"] = _____52A8_753B_5E8F_53F7, ["下一步"] = _____4E0B_4E00_6B65}, _____5EF6_8FDF_79D2_6570)
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
    return _____521B_5EFA_52A8_753B_7B49_5F85_4EFB_52A1({["单位"] = _____5355_4F4D, ["动画名"] = _____52A8_753B_540D, ["下一步"] = _____4E0B_4E00_6B65}, _____5EF6_8FDF_79D2_6570)
end
____exports["零秒后播放单位动画"] = function(_____5355_4F4D, _____52A8_753B_5E8F_53F7, _____4E0B_4E00_6B65)
    return ____exports["延迟播放单位动画"](_____5355_4F4D, _____52A8_753B_5E8F_53F7, 0, _____4E0B_4E00_6B65)
end
____exports["零秒后播放单位动作"] = function(_____5355_4F4D, _____52A8_753B_540D, _____4E0B_4E00_6B65)
    return ____exports["延迟播放单位动作"](_____5355_4F4D, _____52A8_753B_540D, 0, _____4E0B_4E00_6B65)
end
____exports["零秒后重置单位动画"] = function(_____5355_4F4D, _____4E0B_4E00_6B65)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    return _____521B_5EFA_52A8_753B_7B49_5F85_4EFB_52A1({["单位"] = _____5355_4F4D, ["下一步"] = _____4E0B_4E00_6B65}, 0)
end
--- 立即设置单位朝向。
-- 
-- 说明：
-- - 技能层统一传角度制，与 `GetUnitFacing` / `SetUnitFacing` 保持一致。
-- - 内部会同步调用 `EXSetUnitFacing`，用弧度制立即修正朝向。
____exports["立即设置单位朝向"] = function(_____5355_4F4D, _____671D_5411_89D2_5EA6)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    SetUnitFacing(_____5355_4F4D, _____671D_5411_89D2_5EA6)
    EXSetUnitFacing(_____5355_4F4D, _____671D_5411_89D2_5EA6 * DEGREES_TO_RADIANS)
end
____exports["技能延迟执行"] = function(_____5EF6_8FDF_79D2_6570, _____4E0B_4E00_6B65)
    if _____5EF6_8FDF_79D2_6570 < 0 then
        _____5EF6_8FDF_79D2_6570 = 0
    end
    return _____521B_5EFA_52A8_753B_7B49_5F85_4EFB_52A1({["下一步"] = _____4E0B_4E00_6B65}, _____5EF6_8FDF_79D2_6570)
end
return ____exports
