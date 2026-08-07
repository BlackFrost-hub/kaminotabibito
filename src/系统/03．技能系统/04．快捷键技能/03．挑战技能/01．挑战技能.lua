--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_6311_6218_6280_80FD_914D_7F6E = require("系统.03．技能系统.04．快捷键技能.03．挑战技能.00．挑战技能配置")
local _____6311_6218_6280_80FD_914D_7F6E_8868 = ____00_FF0E_6311_6218_6280_80FD_914D_7F6E["挑战技能配置表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_1["是玩家英雄组单位"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____require_result_3["启动剧情Boss战"]
local ____require_result_4 = require("系统.11．剧情系统.02．支线任务.01．被驱逐的水怪.00．入口配置")
local _____8BFB_53D6_5361_745F_62C9_5355_4F4D = ____require_result_4["读取卡瑟拉单位"]
local _____662F_5426_5361_745F_62C9_5165_53E3_5BF9_767D_5DF2_5B8C_6210 = ____require_result_4["是否卡瑟拉入口对白已完成"]
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitTypeId = jass.GetUnitTypeId
local _____5DF2_521D_59CB_5316_6311_6218_6280_80FD = false
local _____5361_745F_62C9Boss_6218_5DF2_542F_52A8 = false
local function _____8BFB_53D6_6311_6218_6280_80FD_914D_7F6E(_____6280_80FDID)
    for ____, _____914D_7F6E in ipairs(_____6311_6218_6280_80FD_914D_7F6E_8868) do
        if stringToFourCCSafe(_____914D_7F6E["技能ID"]) == _____6280_80FDID then
            return _____914D_7F6E
        end
    end
    return nil
end
local function ____on_6311_6218_6280_80FD_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if _____5361_745F_62C9Boss_6218_5DF2_542F_52A8 or _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local _____914D_7F6E = _____8BFB_53D6_6311_6218_6280_80FD_914D_7F6E(_____6280_80FDID)
    if _____914D_7F6E == nil or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____65BD_6CD5_5355_4F4D) then
        return
    end
    local _____76EE_6807_5355_4F4D = GetSpellTargetUnit()
    local _____5361_745F_62C9 = _____8BFB_53D6_5361_745F_62C9_5355_4F4D()
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 or _____5361_745F_62C9 == nil or _____5361_745F_62C9 == 0 then
        return
    end
    if not _____662F_5426_5361_745F_62C9_5165_53E3_5BF9_767D_5DF2_5B8C_6210() then
        return
    end
    if _____76EE_6807_5355_4F4D ~= _____5361_745F_62C9 then
        return
    end
    if GetUnitTypeId(_____76EE_6807_5355_4F4D) ~= stringToFourCCSafe(_____914D_7F6E["目标单位ID"]) then
        return
    end
    if _____542F_52A8_5267_60C5Boss_6218(_____5361_745F_62C9, {["触发单位"] = _____65BD_6CD5_5355_4F4D}) then
        _____5361_745F_62C9Boss_6218_5DF2_542F_52A8 = true
    end
end
____exports["init挑战技能"] = function()
    if _____5DF2_521D_59CB_5316_6311_6218_6280_80FD then
        return
    end
    _____5DF2_521D_59CB_5316_6311_6218_6280_80FD = true
    registerSpellEffectListener(____on_6311_6218_6280_80FD_751F_6548)
end
return ____exports
