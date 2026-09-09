local ____lualib = require("lualib_bundle")
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____02_FF0E_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.02．任务配置表")
local _____4EFB_52A1_914D_7F6E_5217_8868 = ____02_FF0E_4EFB_52A1_914D_7F6E_8868["任务配置列表"]
local ____05_FF0E_4EFB_52A1_914D_7F6E_6CE8_518C = require("系统.08．任务系统.00．配置表.05．任务配置注册")
local _____6CE8_518C_5355_4E2A_4EFB_52A1_914D_7F6E_5230_4EFB_52A1_5E93 = ____05_FF0E_4EFB_52A1_914D_7F6E_6CE8_518C["注册单个任务配置到任务库"]
local ____01_FF0E_652F_7EBFNPC_914D_7F6E_8868 = require("系统.11．剧情系统.02．支线任务.01．支线NPC配置表")
local _____652F_7EBFNPC_914D_7F6E_5217_8868 = ____01_FF0E_652F_7EBFNPC_914D_7F6E_8868["支线NPC配置列表"]
local ____01_FF0E_4EFB_52A1ID_5206_533A = require("系统.08．任务系统.00．配置表.01．任务ID分区")
local _____4EFB_52A1ID_5206_533A = ____01_FF0E_4EFB_52A1ID_5206_533A["任务ID分区"]
local ____require_result_0 = require("系统.08．任务系统.00．配置表.04．NPC生成器")
local _____6309_4EFB_52A1ID_67E5_627E_5DF2_521B_5EFANPC = ____require_result_0["按任务ID查找已创建NPC"]
local _____6309_540D_79F0_67E5_627E_5DF2_521B_5EFANPC = ____require_result_0["按名称查找已创建NPC"]
local ____require_result_1 = require("系统.09．表现系统.02．对话框系统.09．NPC头顶与气泡特效")
local tryAttachQuestMarkerForConfigNpc = ____require_result_1.tryAttachQuestMarkerForConfigNpc
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
    if _____4EFB_52A1ID >= 11000 and (_____4EFB_52A1ID < _____4EFB_52A1ID_5206_533A["动态支线"]["起始"] or _____4EFB_52A1ID > _____4EFB_52A1ID_5206_533A["动态支线"]["结束"]) then
        error(
            __TS__New(
                Error,
                "动态支线任务ID超出分区: " .. tostring(_____4EFB_52A1ID)
            ),
            0
        )
    end
    local _____8FD0_884C_65F6_4EFB_52A1 = _____67E5_627E_8FD0_884C_65F6_4EFB_52A1_914D_7F6E(_____4EFB_52A1ID)
    if _____8FD0_884C_65F6_4EFB_52A1 and _____8FD0_884C_65F6_4EFB_52A1 ~= _____4EFB_52A1 and _____8FD0_884C_65F6_4EFB_52A1["名称"] ~= _____4EFB_52A1["名称"] then
        error(
            __TS__New(
                Error,
                (((("动态支线任务ID与已有任务冲突: " .. tostring(_____4EFB_52A1ID)) .. " / ") .. (_____8FD0_884C_65F6_4EFB_52A1["名称"] or "未命名")) .. " / ") .. (_____4EFB_52A1["名称"] or "未命名")
            ),
            0
        )
    end
    if not _____8FD0_884C_65F6_4EFB_52A1 then
        _____4EFB_52A1_914D_7F6E_5217_8868[#_____4EFB_52A1_914D_7F6E_5217_8868 + 1] = _____4EFB_52A1
        _____8FD0_884C_65F6_4EFB_52A1 = _____4EFB_52A1
    end
    local _____8FD0_884C_65F6NPC = _____67E5_627E_8FD0_884C_65F6NPC_914D_7F6E(_____4EFB_52A1ID)
    if not _____8FD0_884C_65F6NPC and NPC then
        _____652F_7EBFNPC_914D_7F6E_5217_8868[#_____652F_7EBFNPC_914D_7F6E_5217_8868 + 1] = NPC
        _____8FD0_884C_65F6NPC = NPC
    end
    local _____6CE8_518C_6210_529F = _____6CE8_518C_5355_4E2A_4EFB_52A1_914D_7F6E_5230_4EFB_52A1_5E93(_____8FD0_884C_65F6_4EFB_52A1, _____8FD0_884C_65F6NPC)
    if _____6CE8_518C_6210_529F and _____8FD0_884C_65F6NPC ~= nil then
        local _____5355_4F4D = _____6309_4EFB_52A1ID_67E5_627E_5DF2_521B_5EFANPC(_____4EFB_52A1ID)
        if _____5355_4F4D == nil or _____5355_4F4D == 0 then
            _____5355_4F4D = _____6309_540D_79F0_67E5_627E_5DF2_521B_5EFANPC(_____8FD0_884C_65F6NPC["NPC配置名"] or "")
        end
        if _____5355_4F4D == nil or _____5355_4F4D == 0 then
            _____5355_4F4D = _____6309_540D_79F0_67E5_627E_5DF2_521B_5EFANPC(_____8FD0_884C_65F6NPC["NPC名称"] or "")
        end
        if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 then
            tryAttachQuestMarkerForConfigNpc(_____5355_4F4D, _____8FD0_884C_65F6NPC)
        end
    end
    return _____6CE8_518C_6210_529F
end
return ____exports
