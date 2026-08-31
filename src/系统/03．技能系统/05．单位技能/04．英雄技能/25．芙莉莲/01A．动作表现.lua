--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53D6_5E8F_5217_540D_79F0, removeDelayedCallback, _____5355_4F4D_5B58_6D3B, SetUnitAnimationByIndex, SetUnitTimeScale
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.00．配置")
local _____8299_8389_83B2_6A21_578B_52A8_4F5C_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲模型动作配置"]
local _____8299_8389_83B2_6280_80FD_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["芙莉莲技能动作槽"]
____exports["停止循环守护"] = function(_____53E5_67C4)
    if _____53E5_67C4 == nil then
        return
    end
    if _____53E5_67C4["恢复ID"] ~= 0 then
        removeDelayedCallback(_____53E5_67C4["恢复ID"])
    end
    _____53E5_67C4["恢复ID"] = 0
    if _____53E5_67C4["英雄"] ~= nil and _____53E5_67C4["英雄"] ~= 0 and _____5355_4F4D_5B58_6D3B(_____53E5_67C4["英雄"]) then
        SetUnitTimeScale(_____53E5_67C4["英雄"], 1)
        SetUnitAnimationByIndex(_____53E5_67C4["英雄"], _____8299_8389_83B2_6A21_578B_52A8_4F5C_914D_7F6E["待机索引"])
    end
end
function _____53D6_5E8F_5217_540D_79F0(_____7D22_5F15)
    do
        local i = 0
        while i < #_____8299_8389_83B2_6A21_578B_52A8_4F5C_914D_7F6E["序列"] do
            if _____8299_8389_83B2_6A21_578B_52A8_4F5C_914D_7F6E["序列"][i + 1]["索引"] == _____7D22_5F15 then
                return _____8299_8389_83B2_6A21_578B_52A8_4F5C_914D_7F6E["序列"][i + 1]["名称"]
            end
            i = i + 1
        end
    end
    return ""
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
removeDelayedCallback = ____require_result_0.removeDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____5355_4F4D_5B58_6D3B = ____require_result_1["单位存活"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.02．被动效果")
local _____767B_8BB0_8299_8389_83B2_6E05_7406 = ____require_result_2["登记芙莉莲清理"]
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitTimeScale = jass.SetUnitTimeScale
local function _____53D6_5E8F_5217_5B9A_4E49(_____7D22_5F15)
    do
        local i = 0
        while i < #_____8299_8389_83B2_6A21_578B_52A8_4F5C_914D_7F6E["序列"] do
            local s = _____8299_8389_83B2_6A21_578B_52A8_4F5C_914D_7F6E["序列"][i + 1]
            if s["索引"] == _____7D22_5F15 then
                return {["原始时长秒"] = s["原始时长秒"], ["循环"] = s["循环"]}
            end
            i = i + 1
        end
    end
    return nil
end
--- 播放限时动作：按索引播放指定时长，结束后恢复模型配置的待机序列与动画速度 1.0。
-- 登记 02 技能清理器（技能结束/死亡统一移除恢复回调）。
____exports["播放限时动作"] = function(_____82F1_96C4, _____69FD, _____767B_8BB0_540D)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____69FD["索引"] <= 0 then
        return
    end
    SetUnitAnimationByIndex(_____82F1_96C4, _____69FD["索引"])
    if _____69FD["播放速度"] > 0 and _____69FD["播放速度"] ~= 1 then
        SetUnitTimeScale(_____82F1_96C4, _____69FD["播放速度"])
    end
    if _____69FD["持续秒"] > 0 then
        local _____6301_7EED_6BEB_79D2 = _____69FD["持续秒"] * 1000
        local _____6062_590DID = addDelayedCallback(
            _____6301_7EED_6BEB_79D2,
            function()
                if _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                    SetUnitTimeScale(_____82F1_96C4, 1)
                    SetUnitAnimationByIndex(_____82F1_96C4, _____8299_8389_83B2_6A21_578B_52A8_4F5C_914D_7F6E["待机索引"])
                end
            end
        )
        _____767B_8BB0_8299_8389_83B2_6E05_7406(
            _____82F1_96C4,
            _____767B_8BB0_540D,
            function()
                removeDelayedCallback(_____6062_590DID)
                if _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                    SetUnitTimeScale(_____82F1_96C4, 1)
                    SetUnitAnimationByIndex(_____82F1_96C4, _____8299_8389_83B2_6A21_578B_52A8_4F5C_914D_7F6E["待机索引"])
                end
            end
        )
    end
end
____exports["开始循环守护"] = function(_____82F1_96C4, _____69FD, _____767B_8BB0_540D)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____69FD["索引"] <= 0 then
        return nil
    end
    SetUnitAnimationByIndex(_____82F1_96C4, _____69FD["索引"])
    if _____69FD["播放速度"] > 0 and _____69FD["播放速度"] ~= 1 then
        SetUnitTimeScale(_____82F1_96C4, _____69FD["播放速度"])
    end
    local _____6062_590DID = 0
    if _____69FD["持续秒"] > 0 then
        _____6062_590DID = addDelayedCallback(
            _____69FD["持续秒"] * 1000,
            function()
                if _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                    SetUnitTimeScale(_____82F1_96C4, 1)
                    SetUnitAnimationByIndex(_____82F1_96C4, _____8299_8389_83B2_6A21_578B_52A8_4F5C_914D_7F6E["待机索引"])
                end
            end
        )
    end
    local _____53E5_67C4 = {["英雄"] = _____82F1_96C4, ["登记名"] = _____767B_8BB0_540D, ["恢复ID"] = _____6062_590DID}
    _____767B_8BB0_8299_8389_83B2_6E05_7406(
        _____82F1_96C4,
        _____767B_8BB0_540D,
        function()
            ____exports["停止循环守护"](_____53E5_67C4)
        end
    )
    return _____53E5_67C4
end
local function _____6784_9020_69FD(_____69FD_914D_7F6E)
    local def = _____53D6_5E8F_5217_5B9A_4E49(_____69FD_914D_7F6E["索引"])
    local ____69FD_914D_7F6E__7D22_5F15_4 = _____69FD_914D_7F6E["索引"]
    local ____temp_5 = def ~= nil and _____53D6_5E8F_5217_540D_79F0(_____69FD_914D_7F6E["索引"]) or ""
    local ____temp_6 = def ~= nil and def["原始时长秒"] or 0
    local ____69FD_914D_7F6E__64AD_653E_901F_5EA6_7 = _____69FD_914D_7F6E["播放速度"]
    local ____69FD_914D_7F6E__6301_7EED_79D2_8 = _____69FD_914D_7F6E["持续秒"]
    local ____temp_3
    if def ~= nil then
        ____temp_3 = def["循环"]
    else
        ____temp_3 = false
    end
    return {
        ["索引"] = ____69FD_914D_7F6E__7D22_5F15_4,
        ["名称"] = ____temp_5,
        ["原始时长秒"] = ____temp_6,
        ["播放速度"] = ____69FD_914D_7F6E__64AD_653E_901F_5EA6_7,
        ["持续秒"] = ____69FD_914D_7F6E__6301_7EED_79D2_8,
        ["循环"] = ____temp_3
    }
end
____exports["芙莉莲动作槽"] = {
    ["Q发射"] = _____6784_9020_69FD(_____8299_8389_83B2_6280_80FD_52A8_4F5C_69FD["Q发射"]),
    ["W保持防御"] = _____6784_9020_69FD(_____8299_8389_83B2_6280_80FD_52A8_4F5C_69FD["W保持防御"]),
    ["E起飞"] = _____6784_9020_69FD(_____8299_8389_83B2_6280_80FD_52A8_4F5C_69FD["E起飞"]),
    ["E观察保持"] = _____6784_9020_69FD(_____8299_8389_83B2_6280_80FD_52A8_4F5C_69FD["E观察保持"]),
    ["R蓄力保持"] = _____6784_9020_69FD(_____8299_8389_83B2_6280_80FD_52A8_4F5C_69FD["R蓄力保持"]),
    ["R发射"] = _____6784_9020_69FD(_____8299_8389_83B2_6280_80FD_52A8_4F5C_69FD["R发射"]),
    ["D花田"] = _____6784_9020_69FD(_____8299_8389_83B2_6280_80FD_52A8_4F5C_69FD["D花田"])
}
return ____exports
