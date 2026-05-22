local ____lualib = require("lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
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
local _____73A9_5BB6_82F1_96C4_914D_7F6E_8868 = ____require_result_4["玩家英雄配置表"]
local ____require_result_5 = require("系统.02．物品系统.02．装备掉落表")
local _____88C5_5907_6389_843D_8868 = ____require_result_5["装备掉落表"]
local _____989D_5916_5355_4F4D_540D_7D22_5F15 = {}
local function _____8BB0_5F55_989D_5916_5355_4F4D_540D(name, rawcode)
    if type(name) ~= "string" or name == "" then
        return
    end
    if _____989D_5916_5355_4F4D_540D_7D22_5F15[name] == nil then
        _____989D_5916_5355_4F4D_540D_7D22_5F15[name] = rawcode
    end
end
local function _____521D_59CB_5316_989D_5916_5355_4F4D_540D_7D22_5F15()
    if #__TS__ObjectKeys(_____989D_5916_5355_4F4D_540D_7D22_5F15) > 0 then
        return
    end
    local _____73A9_5BB6_82F1_96C4Rawcode_5217_8868 = __TS__ObjectKeys(_____73A9_5BB6_82F1_96C4_914D_7F6E_8868)
    do
        local i = 0
        while i < #_____73A9_5BB6_82F1_96C4Rawcode_5217_8868 do
            do
                local rawcode = _____73A9_5BB6_82F1_96C4Rawcode_5217_8868[i + 1]
                local _____914D_7F6E = _____73A9_5BB6_82F1_96C4_914D_7F6E_8868[rawcode]
                if _____914D_7F6E == nil then
                    goto __continue8
                end
                _____8BB0_5F55_989D_5916_5355_4F4D_540D(_____914D_7F6E.Name, rawcode)
                _____8BB0_5F55_989D_5916_5355_4F4D_540D(_____914D_7F6E.Propernames, rawcode)
            end
            ::__continue8::
            i = i + 1
        end
    end
    local _____6389_843D_8868Rawcode_5217_8868 = __TS__ObjectKeys(_____88C5_5907_6389_843D_8868)
    do
        local i = 0
        while i < #_____6389_843D_8868Rawcode_5217_8868 do
            do
                local rawcode = _____6389_843D_8868Rawcode_5217_8868[i + 1]
                local _____914D_7F6E = _____88C5_5907_6389_843D_8868[rawcode]
                if _____914D_7F6E == nil then
                    goto __continue11
                end
                _____8BB0_5F55_989D_5916_5355_4F4D_540D(_____914D_7F6E.name, rawcode)
            end
            ::__continue11::
            i = i + 1
        end
    end
end
____exports["按名字反查任意单位ID"] = function(name)
    _____521D_59CB_5316_989D_5916_5355_4F4D_540D_7D22_5F15()
    return _____6309_540D_5B57_53CD_67E5_6742_9C7C_5355_4F4DID(name) or _____6309_540D_5B57_53CD_67E5_7CBE_82F1_5355_4F4DID(name) or _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(name) or _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID(name) or _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(name) or _____989D_5916_5355_4F4D_540D_7D22_5F15[name]
end
return ____exports
