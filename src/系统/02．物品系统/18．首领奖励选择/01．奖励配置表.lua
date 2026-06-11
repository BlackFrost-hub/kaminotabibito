--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_7C7B_578B_5B9A_4E49 = require("系统.02．物品系统.18．首领奖励选择.00．类型定义")
local _____9996_9886_5956_52B1_6700_591A_9009_9879_6570 = ____00_FF0E_7C7B_578B_5B9A_4E49["首领奖励最多选项数"]
local _____9996_9886_5956_52B1_6700_5C11_9009_9879_6570 = ____00_FF0E_7C7B_578B_5B9A_4E49["首领奖励最少选项数"]
____exports["瑟兰迪尔奖励池ID"] = "chapter2.hidden.thranduil"
____exports["首领奖励池配置表"] = {{["奖励池ID"] = ____exports["瑟兰迪尔奖励池ID"], ["标题"] = "瑟兰迪尔的执法遗物", ["可选数量"] = 2, ["选项"] = {
    {["装备名"] = "执法者徽记", ["排序"] = 1},
    {["装备名"] = "月光锁链护腕", ["排序"] = 2},
    {["装备名"] = "审判之锋长剑", ["排序"] = 3},
    {["装备名"] = "精灵执法披风", ["排序"] = 4},
    {["装备名"] = "瑟兰迪尔的决心", ["排序"] = 5}
}}}
____exports["查找首领奖励池"] = function(_____5956_52B1_6C60ID)
    do
        local _____5E8F_53F7 = 0
        while _____5E8F_53F7 < #____exports["首领奖励池配置表"] do
            local _____5956_52B1_6C60 = ____exports["首领奖励池配置表"][_____5E8F_53F7 + 1]
            if _____5956_52B1_6C60["奖励池ID"] == _____5956_52B1_6C60ID then
                return _____5956_52B1_6C60
            end
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    return nil
end
____exports["校验首领奖励池结构"] = function(_____5956_52B1_6C60)
    local _____9009_9879_6570_91CF = #_____5956_52B1_6C60["选项"]
    if _____9009_9879_6570_91CF < _____9996_9886_5956_52B1_6700_5C11_9009_9879_6570 then
        return false
    end
    if _____9009_9879_6570_91CF > _____9996_9886_5956_52B1_6700_591A_9009_9879_6570 then
        return false
    end
    if _____5956_52B1_6C60["可选数量"] < 1 then
        return false
    end
    if _____5956_52B1_6C60["可选数量"] > _____9009_9879_6570_91CF then
        return false
    end
    return true
end
return ____exports
