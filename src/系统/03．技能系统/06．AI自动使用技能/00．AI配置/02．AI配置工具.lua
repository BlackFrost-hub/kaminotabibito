--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.01．单位系统.08．单位配置表.00．杂鱼配置表")
local _____6309_540D_5B57_53CD_67E5_6742_9C7C_5355_4F4DID = ____require_result_0["按名字反查杂鱼单位ID"]
local ____require_result_1 = require("系统.01．单位系统.08．单位配置表.01．精英配置表")
local _____6309_540D_5B57_53CD_67E5_7CBE_82F1_5355_4F4DID = ____require_result_1["按名字反查精英单位ID"]
local ____require_result_2 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_2["按名字反查Boss单位ID"]
local ____require_result_3 = require("系统.01．单位系统.08．单位配置表.03．异界Boss配置表")
local _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID = ____require_result_3["按名字反查异界Boss单位ID"]
local ____require_result_4 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID = ____require_result_4["按名字反查玩家英雄单位ID"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
____exports["创建单位AI配置"] = function(_____914D_7F6E)
    return _____914D_7F6E
end
____exports["创建AI状态白名单条件"] = function(_____8BFB_53D6_72B6_6001, _____5141_8BB8_72B6_6001_5217_8868)
    return function(unit)
        local _____5F53_524D_72B6_6001 = _____8BFB_53D6_72B6_6001(unit)
        if _____5F53_524D_72B6_6001 == nil then
            return false
        end
        do
            local i = 0
            while i < #_____5141_8BB8_72B6_6001_5217_8868 do
                if _____5141_8BB8_72B6_6001_5217_8868[i + 1] == _____5F53_524D_72B6_6001 then
                    return true
                end
                i = i + 1
            end
        end
        return false
    end
end
____exports["按归类筛选单位AI配置"] = function(_____914D_7F6E_5217_8868, _____5F52_7C7B)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["归类"] == _____5F52_7C7B then
                _____7ED3_679C[#_____7ED3_679C + 1] = _____914D_7F6E
            end
            i = i + 1
        end
    end
    return _____7ED3_679C
end
local function _____6309_5F52_7C7B_53CD_67E5_5355_4F4DID(_____5F52_7C7B, _____5355_4F4D_540D)
    if _____5F52_7C7B == "杂鱼" then
        return _____6309_540D_5B57_53CD_67E5_6742_9C7C_5355_4F4DID(_____5355_4F4D_540D)
    end
    if _____5F52_7C7B == "精英" then
        return _____6309_540D_5B57_53CD_67E5_7CBE_82F1_5355_4F4DID(_____5355_4F4D_540D)
    end
    if _____5F52_7C7B == "Boss" then
        return _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(_____5355_4F4D_540D)
    end
    if _____5F52_7C7B == "英雄Boss" then
        return _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(_____5355_4F4D_540D) or _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(_____5355_4F4D_540D)
    end
    if _____5F52_7C7B == "异界Boss" then
        return _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID(_____5355_4F4D_540D)
    end
    return nil
end
____exports["解析单位AI配置单位ID"] = function(_____914D_7F6E)
    if _____914D_7F6E["单位ID"] ~= nil and _____914D_7F6E["单位ID"] ~= "" then
        return _____914D_7F6E["单位ID"]
    end
    return _____6309_5F52_7C7B_53CD_67E5_5355_4F4DID(_____914D_7F6E["归类"], _____914D_7F6E["单位名"])
end
____exports["解析单位AI配置单位类型ID"] = function(_____914D_7F6E)
    return stringToFourCCSafe(____exports["解析单位AI配置单位ID"](_____914D_7F6E))
end
____exports["按单位名筛选单位AI配置"] = function(_____914D_7F6E_5217_8868, _____5355_4F4D_540D)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["单位名"] == _____5355_4F4D_540D then
                _____7ED3_679C[#_____7ED3_679C + 1] = _____914D_7F6E
            end
            i = i + 1
        end
    end
    return _____7ED3_679C
end
____exports["按单位ID筛选单位AI配置"] = function(_____914D_7F6E_5217_8868, _____5355_4F4DID)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if ____exports["解析单位AI配置单位ID"](_____914D_7F6E) == _____5355_4F4DID then
                _____7ED3_679C[#_____7ED3_679C + 1] = _____914D_7F6E
            end
            i = i + 1
        end
    end
    return _____7ED3_679C
end
____exports["按AI配置ID获取单位AI配置"] = function(_____914D_7F6E_5217_8868, ____AI_914D_7F6EID)
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["AI配置ID"] == ____AI_914D_7F6EID then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
____exports["按单位名获取单位AI配置"] = function(_____914D_7F6E_5217_8868, _____5355_4F4D_540D)
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["单位名"] == _____5355_4F4D_540D then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
____exports["按单位ID获取单位AI配置"] = function(_____914D_7F6E_5217_8868, _____5355_4F4DID)
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if ____exports["解析单位AI配置单位ID"](_____914D_7F6E) == _____5355_4F4DID then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
____exports["构建单位AI配置ID索引"] = function(_____914D_7F6E_5217_8868)
    local _____7D22_5F15 = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            _____7D22_5F15[_____914D_7F6E["AI配置ID"]] = _____914D_7F6E
            i = i + 1
        end
    end
    return _____7D22_5F15
end
____exports["构建单位名AI配置索引"] = function(_____914D_7F6E_5217_8868)
    local _____7D22_5F15 = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if not _____7D22_5F15[_____914D_7F6E["单位名"]] then
                _____7D22_5F15[_____914D_7F6E["单位名"]] = {}
            end
            local ____7D22_5F15______914D_7F6E__5355_4F4D_540D_6 = _____7D22_5F15[_____914D_7F6E["单位名"]]
            ____7D22_5F15______914D_7F6E__5355_4F4D_540D_6[#____7D22_5F15______914D_7F6E__5355_4F4D_540D_6 + 1] = _____914D_7F6E
            i = i + 1
        end
    end
    return _____7D22_5F15
end
____exports["构建单位IDAI配置索引"] = function(_____914D_7F6E_5217_8868)
    local _____7D22_5F15 = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            do
                local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
                local _____5355_4F4DID = ____exports["解析单位AI配置单位ID"](_____914D_7F6E)
                if _____5355_4F4DID == nil or _____5355_4F4DID == "" then
                    goto __continue51
                end
                if not _____7D22_5F15[_____5355_4F4DID] then
                    _____7D22_5F15[_____5355_4F4DID] = {}
                end
                local ____7D22_5F15______5355_4F4DID_7 = _____7D22_5F15[_____5355_4F4DID]
                ____7D22_5F15______5355_4F4DID_7[#____7D22_5F15______5355_4F4DID_7 + 1] = _____914D_7F6E
            end
            ::__continue51::
            i = i + 1
        end
    end
    return _____7D22_5F15
end
return ____exports
