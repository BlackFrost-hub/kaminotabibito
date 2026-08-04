local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["设置触发单位控制状态"]
local ____13_FF0E_5267_60C5_7247_6BB5_6E05_7406_6CE8_518C_8868 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表")
local _____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406 = ____13_FF0E_5267_60C5_7247_6BB5_6E05_7406_6CE8_518C_8868["注册剧情片段清理"]
---
-- @noSelfInFile
local jass = require("jass.common")
do
    local ____13_FF0E_86C7_4EBA_65CF_4EA4_8FD8_98DF_4EBA_9B54_51ED_8BC1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.13．蛇人族交还食人魔凭证")
    ____exports["蛇人族交凭证剧情片段"] = ____13_FF0E_86C7_4EBA_65CF_4EA4_8FD8_98DF_4EBA_9B54_51ED_8BC1["蛇人族交凭证剧情片段"]
end
local IssueImmediateOrder = jass.IssueImmediateOrder
local SetUnitFacing = jass.SetUnitFacing
____exports["执行蛇人族交还食人魔凭证"] = function(_____53C2_6570)
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    local ____53C2_6570__9636_6BB5_0 = _____53C2_6570["阶段"]
    if ____53C2_6570__9636_6BB5_0 == nil then
        ____53C2_6570__9636_6BB5_0 = ""
    end
    local _____9636_6BB5 = tostring(____53C2_6570__9636_6BB5_0)
    if _____9636_6BB5 == "进入" then
        if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
            IssueImmediateOrder(_____89E6_53D1_5355_4F4D, "stop")
            _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001(true, false)
        end
        return
    end
    if _____9636_6BB5 == "触发单位转向" and _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        SetUnitFacing(
            _____89E6_53D1_5355_4F4D,
            __TS__Number(_____53C2_6570["朝向"]) or 200
        )
    end
end
_____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406(
    "jlc_snake_keeper_return_item",
    function()
        _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001(false, false)
    end
)
____exports["蛇人族交还食人魔凭证剧情动作注册表"] = {["SRZ蛇人族_交还食人魔凭证"] = ____exports["执行蛇人族交还食人魔凭证"]}
return ____exports
