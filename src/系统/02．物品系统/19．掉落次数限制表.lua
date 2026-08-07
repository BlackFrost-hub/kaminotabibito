--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 限次物品的整局掉落配置。未配置的物品不限制。
____exports["掉落次数限制表"] = {afac = 1, I0CQ = 1}
local _____7269_54C1_5DF2_6389_843D_6B21_6570 = {}
____exports["是否允许限次物品掉落"] = function(itemId)
    local _____6700_5927_6389_843D_6B21_6570 = ____exports["掉落次数限制表"][itemId]
    if _____6700_5927_6389_843D_6B21_6570 == nil then
        return true
    end
    return (_____7269_54C1_5DF2_6389_843D_6B21_6570[itemId] or 0) < _____6700_5927_6389_843D_6B21_6570
end
____exports["记录限次物品掉落"] = function(itemId)
    if ____exports["掉落次数限制表"][itemId] == nil then
        return
    end
    _____7269_54C1_5DF2_6389_843D_6B21_6570[itemId] = (_____7269_54C1_5DF2_6389_843D_6B21_6570[itemId] or 0) + 1
end
return ____exports
