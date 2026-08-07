local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
---
-- @noSelfInFile
local jass = require("jass.common")
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local QueueUnitAnimation = jass.QueueUnitAnimation
local function _____6267_884C_7B2C_4E09_7AE0_7535_5F71_5355_4F4D_52A8_4F5C(_____53C2_6570)
    local ____53C2_6570__5355_4F4D_5F15_7528_0 = _____53C2_6570["单位引用"]
    if ____53C2_6570__5355_4F4D_5F15_7528_0 == nil then
        ____53C2_6570__5355_4F4D_5F15_7528_0 = ""
    end
    local _____5355_4F4D_5F15_7528 = tostring(____53C2_6570__5355_4F4D_5F15_7528_0)
    if _____5355_4F4D_5F15_7528 == "" then
        return
    end
    local unit = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____5355_4F4D_5F15_7528)
    if unit == nil or unit == 0 then
        return
    end
    local _____52A8_753B_7F16_53F7 = __TS__Number(_____53C2_6570["动画编号"])
    local ____53C2_6570__52A8_753B_540D_1 = _____53C2_6570["动画名"]
    if ____53C2_6570__52A8_753B_540D_1 == nil then
        ____53C2_6570__52A8_753B_540D_1 = ""
    end
    local _____52A8_753B_540D = tostring(____53C2_6570__52A8_753B_540D_1)
    if _____53C2_6570["动画编号"] ~= nil and _____52A8_753B_7F16_53F7 >= 0 then
        SetUnitAnimationByIndex(unit, _____52A8_753B_7F16_53F7)
    elseif _____52A8_753B_540D ~= "" then
        SetUnitAnimation(unit, _____52A8_753B_540D)
    else
        return
    end
    if QueueUnitAnimation ~= nil then
        local ____53C2_6570__6062_590D_52A8_753B_540D_2 = _____53C2_6570["恢复动画名"]
        if ____53C2_6570__6062_590D_52A8_753B_540D_2 == nil then
            ____53C2_6570__6062_590D_52A8_753B_540D_2 = "stand"
        end
        QueueUnitAnimation(
            unit,
            tostring(____53C2_6570__6062_590D_52A8_753B_540D_2)
        )
    end
end
____exports["第三章电影动作注册表"] = {["第三章_播放电影单位动作"] = _____6267_884C_7B2C_4E09_7AE0_7535_5F71_5355_4F4D_52A8_4F5C}
return ____exports
