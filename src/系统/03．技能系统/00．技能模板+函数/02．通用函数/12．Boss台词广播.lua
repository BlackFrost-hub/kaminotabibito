--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_0["广播单位提示"]
local ____require_result_1 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_UnitPlayReuse = ____require_result_1.Sound3DII_UnitPlayReuse
local GetRandomInt = jass.GetRandomInt
local StopSound = jass.StopSound
local ____Boss_914D_97F3_53E5_67C4_8868 = {}
____exports["取Boss台词下标"] = function(_____53F0_8BCD_8868, _____7C7B_578B, index)
    local lines = _____53F0_8BCD_8868[_____7C7B_578B]
    if lines == nil or #lines <= 0 then
        return nil
    end
    if index ~= nil then
        return index
    end
    return GetRandomInt(0, #lines - 1)
end
____exports["取Boss台词文本"] = function(_____53F0_8BCD_8868, _____7C7B_578B, index)
    local lines = _____53F0_8BCD_8868[_____7C7B_578B]
    if lines == nil or #lines <= 0 then
        return nil
    end
    local lineIndex = ____exports["取Boss台词下标"](_____53F0_8BCD_8868, _____7C7B_578B, index)
    if lineIndex == nil then
        return nil
    end
    return lines[lineIndex + 1] or lines[1]
end
____exports["播放Boss台词配音"] = function(_____6765_6E90_5355_4F4D, _____914D_97F3_8D44_6E90_8868, _____7C7B_578B, index, _____88C1_65AD_8DDD_79BB, _____5141_8BB8_91CD_53E0, _____914D_97F3_7EC4)
    if _____914D_97F3_7EC4 == nil then
        _____914D_97F3_7EC4 = "BossVoice"
    end
    if _____914D_97F3_8D44_6E90_8868 == nil then
        return
    end
    local paths = _____914D_97F3_8D44_6E90_8868[_____7C7B_578B]
    if paths == nil or #paths <= 0 then
        return
    end
    local path = paths[index + 1] or paths[1]
    if path == nil or path == "" then
        return
    end
    local _____4E0A_4E00_6761_914D_97F3_53E5_67C4 = ____Boss_914D_97F3_53E5_67C4_8868[_____914D_97F3_7EC4]
    if not _____5141_8BB8_91CD_53E0 and _____4E0A_4E00_6761_914D_97F3_53E5_67C4 ~= nil and _____4E0A_4E00_6761_914D_97F3_53E5_67C4 ~= 0 then
        StopSound(_____4E0A_4E00_6761_914D_97F3_53E5_67C4, false, false)
    end
    ____Boss_914D_97F3_53E5_67C4_8868[_____914D_97F3_7EC4] = Sound3DII_UnitPlayReuse(path, _____6765_6E90_5355_4F4D, _____88C1_65AD_8DDD_79BB or 4000)
end
____exports["播放Boss台词广播"] = function(_____6765_6E90_5355_4F4D, _____53F0_8BCD_8868, _____7C7B_578B, _____6301_7EED_65F6_95F4Ms, index)
    local text = ____exports["取Boss台词文本"](_____53F0_8BCD_8868, _____7C7B_578B, index)
    if text == nil or text == "" then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____6765_6E90_5355_4F4D, text, _____6301_7EED_65F6_95F4Ms)
end
____exports["播放Boss台词"] = function(_____6765_6E90_5355_4F4D, _____914D_7F6E, _____7C7B_578B, index)
    local actualIndex = ____exports["取Boss台词下标"](_____914D_7F6E["台词"], _____7C7B_578B, index)
    if actualIndex == nil then
        return
    end
    ____exports["播放Boss台词广播"](
        _____6765_6E90_5355_4F4D,
        _____914D_7F6E["台词"],
        _____7C7B_578B,
        _____914D_7F6E["广播持续时间Ms"],
        actualIndex
    )
    local ____temp_2 = _____914D_7F6E["配音组"] or _____914D_7F6E.BossKey
    if ____temp_2 == nil then
        ____temp_2 = "BossVoice"
    end
    local _____914D_97F3_7EC4 = ____temp_2
    ____exports["播放Boss台词配音"](
        _____6765_6E90_5355_4F4D,
        _____914D_7F6E["配音资源"],
        _____7C7B_578B,
        actualIndex,
        _____914D_7F6E["配音裁断距离"],
        _____914D_7F6E["配音允许重叠"],
        _____914D_97F3_7EC4
    )
end
return ____exports
