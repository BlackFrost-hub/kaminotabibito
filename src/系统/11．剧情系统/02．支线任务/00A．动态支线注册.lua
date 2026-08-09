--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.02．任务配置表")
local _____4EFB_52A1_914D_7F6E_5217_8868 = ____02_FF0E_4EFB_52A1_914D_7F6E_8868["任务配置列表"]
local ____05_FF0E_4EFB_52A1_914D_7F6E_6CE8_518C = require("系统.08．任务系统.00．配置表.05．任务配置注册")
local _____6CE8_518C_5355_4E2A_4EFB_52A1_914D_7F6E_5230_4EFB_52A1_5E93 = ____05_FF0E_4EFB_52A1_914D_7F6E_6CE8_518C["注册单个任务配置到任务库"]
local ____01_FF0E_652F_7EBFNPC_914D_7F6E_8868 = require("系统.11．剧情系统.02．支线任务.01．支线NPC配置表")
local _____652F_7EBFNPC_914D_7F6E_5217_8868 = ____01_FF0E_652F_7EBFNPC_914D_7F6E_8868["支线NPC配置列表"]
local function _____67E5_627E_8FD0_884C_65F6_4EFB_52A1_914D_7F6E(_____4EFB_52A1ID)
    for ____, _____914D_7F6E in ipairs(_____4EFB_52A1_914D_7F6E_5217_8868) do
        if _____914D_7F6E["任务ID"] == _____4EFB_52A1ID then
            return _____914D_7F6E
        end
    end
    return nil
end
local function _____67E5_627E_8FD0_884C_65F6NPC_914D_7F6E(_____4EFB_52A1ID)
    for ____, _____914D_7F6E in ipairs(_____652F_7EBFNPC_914D_7F6E_5217_8868) do
        if _____914D_7F6E["任务ID"] == _____4EFB_52A1ID then
            return _____914D_7F6E
        end
    end
    return nil
end
____exports["注册动态支线配置"] = function(_____4EFB_52A1, NPC)
    if not _____4EFB_52A1 or not _____4EFB_52A1["任务ID"] then
        return false
    end
    local _____4EFB_52A1ID = _____4EFB_52A1["任务ID"]
    local _____8FD0_884C_65F6_4EFB_52A1 = _____67E5_627E_8FD0_884C_65F6_4EFB_52A1_914D_7F6E(_____4EFB_52A1ID)
    if not _____8FD0_884C_65F6_4EFB_52A1 then
        _____4EFB_52A1_914D_7F6E_5217_8868[#_____4EFB_52A1_914D_7F6E_5217_8868 + 1] = _____4EFB_52A1
        _____8FD0_884C_65F6_4EFB_52A1 = _____4EFB_52A1
    end
    local _____8FD0_884C_65F6NPC = _____67E5_627E_8FD0_884C_65F6NPC_914D_7F6E(_____4EFB_52A1ID)
    if not _____8FD0_884C_65F6NPC and NPC then
        _____652F_7EBFNPC_914D_7F6E_5217_8868[#_____652F_7EBFNPC_914D_7F6E_5217_8868 + 1] = NPC
        _____8FD0_884C_65F6NPC = NPC
    end
    return _____6CE8_518C_5355_4E2A_4EFB_52A1_914D_7F6E_5230_4EFB_52A1_5E93(_____8FD0_884C_65F6_4EFB_52A1, _____8FD0_884C_65F6NPC)
end
return ____exports
