--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local platformAbilityApi = require("平台扩展API取值")
local _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4 = platformAbilityApi["技能_获取技能当前冷却时间"]
local _____9ED8_8BA4_51B7_5374_9608_503C_79D2 = 0.05
local function _____6709_6548_53E5_67C4(handle)
    return handle ~= nil and handle ~= 0
end
____exports["读取技能剩余冷却"] = function(_____5355_4F4D, _____6280_80FDID)
    if not _____6709_6548_53E5_67C4(_____5355_4F4D) or _____6280_80FDID == nil or _____6280_80FDID == 0 then
        return 0
    end
    return _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4(_____5355_4F4D, _____6280_80FDID) or 0
end
____exports["技能是否冷却中"] = function(_____5355_4F4D, _____6280_80FDID, _____9608_503C_79D2)
    if _____9608_503C_79D2 == nil then
        _____9608_503C_79D2 = _____9ED8_8BA4_51B7_5374_9608_503C_79D2
    end
    return ____exports["读取技能剩余冷却"](_____5355_4F4D, _____6280_80FDID) > _____9608_503C_79D2
end
____exports["读取技能冷却状态"] = function(_____5355_4F4D, _____6280_80FDID, _____9608_503C_79D2)
    if _____9608_503C_79D2 == nil then
        _____9608_503C_79D2 = _____9ED8_8BA4_51B7_5374_9608_503C_79D2
    end
    local _____5269_4F59_51B7_5374 = ____exports["读取技能剩余冷却"](_____5355_4F4D, _____6280_80FDID)
    return {["技能ID"] = _____6280_80FDID, ["剩余冷却"] = _____5269_4F59_51B7_5374, ["是否冷却中"] = _____5269_4F59_51B7_5374 > _____9608_503C_79D2}
end
____exports["指定技能是否全部冷却中"] = function(_____5355_4F4D, _____6280_80FDID_5217_8868, _____9608_503C_79D2)
    if _____9608_503C_79D2 == nil then
        _____9608_503C_79D2 = _____9ED8_8BA4_51B7_5374_9608_503C_79D2
    end
    if not _____6709_6548_53E5_67C4(_____5355_4F4D) or #_____6280_80FDID_5217_8868 <= 0 then
        return false
    end
    do
        local i = 0
        while i < #_____6280_80FDID_5217_8868 do
            local _____6280_80FDID = _____6280_80FDID_5217_8868[i + 1]
            if _____6280_80FDID == nil or _____6280_80FDID == 0 then
                return false
            end
            if not ____exports["技能是否冷却中"](_____5355_4F4D, _____6280_80FDID, _____9608_503C_79D2) then
                return false
            end
            i = i + 1
        end
    end
    return true
end
____exports["读取QWER冷却状态"] = function(_____5355_4F4D, _____6280_80FD_8868, _____9608_503C_79D2)
    if _____9608_503C_79D2 == nil then
        _____9608_503C_79D2 = _____9ED8_8BA4_51B7_5374_9608_503C_79D2
    end
    local q = ____exports["读取技能冷却状态"](_____5355_4F4D, _____6280_80FD_8868.Q or 0, _____9608_503C_79D2)
    local w = ____exports["读取技能冷却状态"](_____5355_4F4D, _____6280_80FD_8868.W or 0, _____9608_503C_79D2)
    local e = ____exports["读取技能冷却状态"](_____5355_4F4D, _____6280_80FD_8868.E or 0, _____9608_503C_79D2)
    local r = ____exports["读取技能冷却状态"](_____5355_4F4D, _____6280_80FD_8868.R or 0, _____9608_503C_79D2)
    local _____5168_90E8_5B58_5728 = q["技能ID"] ~= 0 and w["技能ID"] ~= 0 and e["技能ID"] ~= 0 and r["技能ID"] ~= 0
    return {
        Q = q,
        W = w,
        E = e,
        R = r,
        ["全部存在"] = _____5168_90E8_5B58_5728,
        ["全部冷却中"] = _____5168_90E8_5B58_5728 and q["是否冷却中"] and w["是否冷却中"] and e["是否冷却中"] and r["是否冷却中"]
    }
end
____exports["QWER技能是否全部冷却中"] = function(_____5355_4F4D, _____6280_80FD_8868, _____9608_503C_79D2)
    if _____9608_503C_79D2 == nil then
        _____9608_503C_79D2 = _____9ED8_8BA4_51B7_5374_9608_503C_79D2
    end
    return ____exports["读取QWER冷却状态"](_____5355_4F4D, _____6280_80FD_8868, _____9608_503C_79D2)["全部冷却中"]
end
return ____exports
