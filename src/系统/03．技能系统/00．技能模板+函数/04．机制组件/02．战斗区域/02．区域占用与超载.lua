--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_52A8_6001_77E9_5F62_533A_57DF_7EC4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.01．动态矩形区域组")
local _____7EDF_8BA1_52A8_6001_77E9_5F62_533A_57DF_5185_5355_4F4D_6570_91CF = ____01_FF0E_52A8_6001_77E9_5F62_533A_57DF_7EC4["统计动态矩形区域内单位数量"]
local function _____53D6_533A_57DF_5BB9_91CF(_____533A_57DF, _____9ED8_8BA4_5BB9_91CF, _____533A_57DF_5BB9_91CF)
    if _____533A_57DF_5BB9_91CF == nil then
        return _____9ED8_8BA4_5BB9_91CF
    end
    local id = _____533A_57DF["配置"].ID
    if id ~= nil and _____533A_57DF_5BB9_91CF[id] ~= nil then
        return _____533A_57DF_5BB9_91CF[id]
    end
    local _____540D_79F0 = _____533A_57DF["配置"]["名称"]
    if _____540D_79F0 ~= nil and _____533A_57DF_5BB9_91CF[_____540D_79F0] ~= nil then
        return _____533A_57DF_5BB9_91CF[_____540D_79F0]
    end
    return _____9ED8_8BA4_5BB9_91CF
end
____exports["统计区域占用状态"] = function(_____53C2_6570)
    local _____533A_57DF_7EC4 = _____53C2_6570["区域组"]
    if _____533A_57DF_7EC4 == nil then
        return {}
    end
    local result = {}
    local _____533A_57DF_5217_8868 = _____533A_57DF_7EC4["区域列表"]
    do
        local i = 0
        while i < #_____533A_57DF_5217_8868 do
            local _____533A_57DF = _____533A_57DF_5217_8868[i + 1]
            local _____5BB9_91CF = _____53D6_533A_57DF_5BB9_91CF(_____533A_57DF, _____53C2_6570["默认容量"], _____53C2_6570["区域容量"])
            local _____5355_4F4D_6570_91CF = _____7EDF_8BA1_52A8_6001_77E9_5F62_533A_57DF_5185_5355_4F4D_6570_91CF(_____533A_57DF, _____53C2_6570["单位列表"])
            result[#result + 1] = {["区域"] = _____533A_57DF, ["单位数量"] = _____5355_4F4D_6570_91CF, ["容量"] = _____5BB9_91CF, ["是否超载"] = _____5BB9_91CF >= 0 and _____5355_4F4D_6570_91CF > _____5BB9_91CF}
            i = i + 1
        end
    end
    return result
end
____exports["取超载区域列表"] = function(_____53C2_6570)
    local _____72B6_6001_5217_8868 = ____exports["统计区域占用状态"](_____53C2_6570)
    local result = {}
    do
        local i = 0
        while i < #_____72B6_6001_5217_8868 do
            if _____72B6_6001_5217_8868[i + 1]["是否超载"] then
                result[#result + 1] = _____72B6_6001_5217_8868[i + 1]
            end
            i = i + 1
        end
    end
    return result
end
____exports["是否存在超载区域"] = function(_____53C2_6570)
    local _____72B6_6001_5217_8868 = ____exports["统计区域占用状态"](_____53C2_6570)
    do
        local i = 0
        while i < #_____72B6_6001_5217_8868 do
            if _____72B6_6001_5217_8868[i + 1]["是否超载"] then
                return true
            end
            i = i + 1
        end
    end
    return false
end
return ____exports
