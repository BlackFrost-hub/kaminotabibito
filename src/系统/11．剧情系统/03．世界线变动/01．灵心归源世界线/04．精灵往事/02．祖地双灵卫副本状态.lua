--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local function _____521B_5EFA_7A7A_8BD5_70BC_72B6_6001()
    return {
        ["已完成"] = false,
        ["锁定玩家ID"] = -1,
        ["开始时间毫秒"] = 0,
        ["累计数值"] = 0,
        ["目标单位"] = nil,
        ["进度UI"] = nil
    }
end
____exports["祖地双灵卫副本状态"] = {
    ["已初始化"] = false,
    ["任务已接受"] = false,
    ["守门放行广播进行中"] = false,
    ["守门放行触发英雄"] = nil,
    ["守门已放行"] = false,
    ["试炼已创建"] = false,
    ["试炼全部完成已派发"] = false,
    ["传送点已创建"] = false,
    ["传送点特效"] = nil,
    ["传送点触发器"] = nil,
    ["传送点区域"] = nil,
    ["Boss场景已触发"] = false,
    ["Boss场景触发英雄"] = nil,
    ["Boss战已启动"] = false,
    ["Boss击败数"] = 0,
    ["Boss战已完成"] = false,
    ["奖励已提交"] = false,
    ["守门单位"] = nil,
    ["本思雅单位"] = nil,
    ["埃德里安单位"] = nil,
    ["Boss单位列表"] = {},
    ["试炼"] = {
        ["持续伤害"] = _____521B_5EFA_7A7A_8BD5_70BC_72B6_6001(),
        ["单次伤害"] = _____521B_5EFA_7A7A_8BD5_70BC_72B6_6001(),
        ["治疗"] = _____521B_5EFA_7A7A_8BD5_70BC_72B6_6001()
    }
}
____exports["祖地双灵卫试炼是否全部完成"] = function()
    return ____exports["祖地双灵卫副本状态"]["试炼"]["持续伤害"]["已完成"] and ____exports["祖地双灵卫副本状态"]["试炼"]["单次伤害"]["已完成"] and ____exports["祖地双灵卫副本状态"]["试炼"]["治疗"]["已完成"]
end
return ____exports
