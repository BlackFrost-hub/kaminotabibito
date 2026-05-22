local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local ____require_result_0 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID = ____require_result_0["按名字反查玩家英雄单位ID"]
local _____73A9_5BB6_82F1_96C4_914D_7F6E_8868 = ____require_result_0["玩家英雄配置表"]
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具")
local _____83B7_53D6_5355_4F4D_82F1_96C4Rawcode = ____require_result_1["获取单位英雄Rawcode"]
____exports["玩家英雄别名配置列表"] = {{["配置名"] = "女仆", ["别名列表"] = {"十六夜咲夜"}}, {["配置名"] = "永远17岁的少女", ["别名列表"] = {"八云紫"}}, {["配置名"] = "月兔", ["别名列表"] = {"铃仙"}}}
local _____82F1_96C4Rawcode_5230_522B_540D_5217_8868 = (function()
    local map = {}
    do
        local i = 0
        while i < #____exports["玩家英雄别名配置列表"] do
            do
                local config = ____exports["玩家英雄别名配置列表"][i + 1]
                local rawcode = _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(config["配置名"])
                if rawcode == nil or rawcode == "" then
                    goto __continue4
                end
                if map[rawcode] == nil then
                    map[rawcode] = {}
                end
                do
                    local j = 0
                    while j < #config["别名列表"] do
                        local ____map_rawcode_2 = map[rawcode]
                        ____map_rawcode_2[#____map_rawcode_2 + 1] = config["别名列表"][j + 1]
                        j = j + 1
                    end
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
    return map
end)()
____exports["获取玩家英雄别名列表"] = function(heroRawcode)
    if heroRawcode == nil or heroRawcode == "" then
        return {}
    end
    return _____82F1_96C4Rawcode_5230_522B_540D_5217_8868[heroRawcode] or ({})
end
____exports["获取单位玩家英雄全部名称"] = function(unit)
    local heroRawcode = _____83B7_53D6_5355_4F4D_82F1_96C4Rawcode(unit)
    if heroRawcode == nil or heroRawcode == "" then
        return {}
    end
    local config = _____73A9_5BB6_82F1_96C4_914D_7F6E_8868[heroRawcode]
    if config == nil then
        return {}
    end
    local result = {}
    local ____config_Name_3 = config.Name
    if ____config_Name_3 == nil then
        ____config_Name_3 = ""
    end
    local name = __TS__StringTrim(tostring(____config_Name_3))
    local ____config_Propernames_4 = config.Propernames
    if ____config_Propernames_4 == nil then
        ____config_Propernames_4 = ""
    end
    local propernames = __TS__StringTrim(tostring(____config_Propernames_4))
    if name ~= "" then
        result[#result + 1] = name
    end
    if propernames ~= "" then
        result[#result + 1] = propernames
    end
    local aliases = ____exports["获取玩家英雄别名列表"](heroRawcode)
    do
        local i = 0
        while i < #aliases do
            local alias = aliases[i + 1]
            if alias ~= "" then
                result[#result + 1] = alias
            end
            i = i + 1
        end
    end
    return result
end
____exports["单位是否匹配玩家英雄名称"] = function(unit, name)
    if name == nil or name == "" then
        return false
    end
    local names = ____exports["获取单位玩家英雄全部名称"](unit)
    do
        local i = 0
        while i < #names do
            if names[i + 1] == name then
                return true
            end
            i = i + 1
        end
    end
    return false
end
return ____exports
