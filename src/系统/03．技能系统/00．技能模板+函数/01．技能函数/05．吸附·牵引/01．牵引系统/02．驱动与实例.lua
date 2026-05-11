--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____on_5438_9644_7275_5F15_7CFB_7EDFTick, ____tick_8BA1_6570
local ____01_FF0E_79FB_52A8_4E0E_95EA_7535 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.01．牵引系统.01．移动与闪电")
local _____63A8_8FDB_7275_5F15_5B9E_4F8B = ____01_FF0E_79FB_52A8_4E0E_95EA_7535["推进牵引实例"]
local _____7ED3_675F_7275_5F15_5B9E_4F8B = ____01_FF0E_79FB_52A8_4E0E_95EA_7535["结束牵引实例"]
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.01．牵引系统.00．共享")
local _____6D3B_52A8_7275_5F15_5217_8868 = ____00_FF0E_5171_4EAB["活动牵引列表"]
local _____7275_5F15_6620_5C04 = ____00_FF0E_5171_4EAB["牵引映射"]
function ____on_5438_9644_7275_5F15_7CFB_7EDFTick()
    ____tick_8BA1_6570 = ____tick_8BA1_6570 + 1
    if ____tick_8BA1_6570 < 2 then
        return
    end
    ____tick_8BA1_6570 = 0
    local i = 0
    while i < #_____6D3B_52A8_7275_5F15_5217_8868 do
        local _____5B9E_4F8B = _____6D3B_52A8_7275_5F15_5217_8868[i + 1]
        _____63A8_8FDB_7275_5F15_5B9E_4F8B(_____5B9E_4F8B)
        if _____6D3B_52A8_7275_5F15_5217_8868[i + 1] == _____5B9E_4F8B then
            i = i + 1
        end
    end
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
local offTick10ms = ____require_result_0.offTick10ms
local _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
____tick_8BA1_6570 = 0
local function _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(____on_5438_9644_7275_5F15_7CFB_7EDFTick)
end
local function _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
    if not _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
    offTick10ms(____on_5438_9644_7275_5F15_7CFB_7EDFTick)
end
local function _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668()
    if #_____6D3B_52A8_7275_5F15_5217_8868 ~= 0 then
        return
    end
    ____tick_8BA1_6570 = 0
    _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
end
____exports["注册到中心计时器"] = _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668
____exports["尝试收尾中心计时器"] = _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668
____exports["结束牵引ID"] = function(_____7275_5F15ID, _____539F_56E0)
    local _____5B9E_4F8B = _____7275_5F15_6620_5C04[_____7275_5F15ID]
    if not _____5B9E_4F8B then
        return false
    end
    _____7ED3_675F_7275_5F15_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    return true
end
return ____exports
