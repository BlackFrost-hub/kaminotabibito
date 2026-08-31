--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.09．表现系统.10．英雄语音.10．技能喊话.00．配置")
local _____82F1_96C4_6280_80FD_558A_8BDD_914D_7F6E_5217_8868 = ____00_FF0E_914D_7F6E["英雄技能喊话配置列表"]
local _____4F0A_857E_5A1CD_53D8_5F0F_558A_8BDD_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜D变式喊话配置"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetRandomInt = jass.GetRandomInt
local ____require_result_0 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_UnitPlayReuse = ____require_result_0.Sound3DII_UnitPlayReuse
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local _____6280_80FD_558A_8BDD_51B7_5374_8868 = {}
local function _____53D6_666E_901A_914D_7F6E(_____82F1_96C4_540D, _____6280_80FDID)
    do
        local i = 0
        while i < #_____82F1_96C4_6280_80FD_558A_8BDD_914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____82F1_96C4_6280_80FD_558A_8BDD_914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["英雄名"] == _____82F1_96C4_540D and _____914D_7F6E["技能ID"] == _____6280_80FDID then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
local function _____53D6D_53D8_5F0F_914D_7F6E(_____53D8_5F0F)
    if _____53D8_5F0F ~= "迅行" and _____53D8_5F0F ~= "镜界" and _____53D8_5F0F ~= "灰烬" then
        return nil
    end
    return _____4F0A_857E_5A1CD_53D8_5F0F_558A_8BDD_914D_7F6E[_____53D8_5F0F]
end
local function _____53D6_5019_9009_8BED_97F3(_____914D_7F6E)
    local _____5217_8868 = _____914D_7F6E["候选语音列表"]
    if #_____5217_8868 <= 1 or _____914D_7F6E["随机播放"] ~= true then
        return _____5217_8868[1] or ""
    end
    local _____7D22_5F15 = GetRandomInt(1, #_____5217_8868) - 1
    return _____5217_8868[_____7D22_5F15 + 1] or _____5217_8868[1]
end
--- 全局播放一次英雄技能喊话。
-- 不做 GetLocalPlayer 或玩家归属过滤；Sound3DII 的单位位置决定听到的距离。
-- 返回 true 仅表示本次已取得并启动声音句柄。
____exports["播放英雄技能喊话"] = function(_____65BD_6CD5_8005, _____82F1_96C4_540D, _____6280_80FDID, _____4F0A_857E_5A1C_53D8_5F0F)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        return false
    end
    local _____914D_7F6E = _____53D6_666E_901A_914D_7F6E(_____82F1_96C4_540D, _____6280_80FDID)
    if _____82F1_96C4_540D == "伊蕾娜" and _____6280_80FDID == "AID1" then
        _____914D_7F6E = _____53D6D_53D8_5F0F_914D_7F6E(_____4F0A_857E_5A1C_53D8_5F0F) or _____914D_7F6E
    end
    if _____914D_7F6E == nil then
        return false
    end
    local _____51B7_5374_952E = (((tostring(GetHandleId(_____65BD_6CD5_8005)) .. ":") .. _____82F1_96C4_540D) .. ":") .. _____6280_80FDID
    local _____5F53_524D_65F6_95F4 = getServerTime()
    local _____51B7_5374_7ED3_675F_65F6_95F4 = _____6280_80FD_558A_8BDD_51B7_5374_8868[_____51B7_5374_952E] or 0
    if _____51B7_5374_7ED3_675F_65F6_95F4 > _____5F53_524D_65F6_95F4 then
        return false
    end
    local _____58F0_97F3_8DEF_5F84 = _____53D6_5019_9009_8BED_97F3(_____914D_7F6E)
    if _____58F0_97F3_8DEF_5F84 == "" then
        return false
    end
    local _____58F0_97F3_53E5_67C4 = Sound3DII_UnitPlayReuse(_____58F0_97F3_8DEF_5F84, _____65BD_6CD5_8005, _____914D_7F6E["三D裁断距离"])
    if _____58F0_97F3_53E5_67C4 == nil or _____58F0_97F3_53E5_67C4 == 0 then
        return false
    end
    _____6280_80FD_558A_8BDD_51B7_5374_8868[_____51B7_5374_952E] = _____5F53_524D_65F6_95F4 + _____914D_7F6E["语音冷却秒"] * 1000
    return true
end
return ____exports
