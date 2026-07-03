--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_547D_4EE4_5361_6280_80FD_69FD_4F4D = require("系统.03．技能系统.01．技能冷却.04．命令卡技能槽位")
local _____547D_4EE4_5361_70ED_952E_69FD_4F4D_8868 = ____04_FF0E_547D_4EE4_5361_6280_80FD_69FD_4F4D["命令卡热键槽位表"]
local _____8BFB_53D6_547D_4EE4_5361_6309_94AE_80FD_529BId = ____04_FF0E_547D_4EE4_5361_6280_80FD_69FD_4F4D["读取命令卡按钮能力Id"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local DzGetUnitAbilityCool = japi.DzGetUnitAbilityCool
____exports["取命令卡热键技能ID"] = function(_____70ED_952E)
    do
        local i = 0
        while i < #_____547D_4EE4_5361_70ED_952E_69FD_4F4D_8868 do
            local x, y, key = table.unpack(_____547D_4EE4_5361_70ED_952E_69FD_4F4D_8868[i + 1], 1, 3)
            if key == _____70ED_952E then
                return _____8BFB_53D6_547D_4EE4_5361_6309_94AE_80FD_529BId(x, y)
            end
            i = i + 1
        end
    end
    return 0
end
____exports["单位技能是否冷却中"] = function(_____5355_4F4D, _____6280_80FDID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____6280_80FDID == 0 then
        return false
    end
    if GetUnitAbilityLevel(_____5355_4F4D, _____6280_80FDID) <= 0 then
        return false
    end
    if type(DzGetUnitAbilityCool) ~= "function" then
        return false
    end
    return DzGetUnitAbilityCool(_____5355_4F4D, _____6280_80FDID) > 0
end
____exports["命令卡热键技能是否冷却中"] = function(_____5355_4F4D, _____70ED_952E)
    return ____exports["单位技能是否冷却中"](
        _____5355_4F4D,
        ____exports["取命令卡热键技能ID"](_____70ED_952E)
    )
end
____exports["命令卡技能是否全部冷却中"] = function(_____5355_4F4D, _____70ED_952E_5217_8868)
    if _____70ED_952E_5217_8868 == nil then
        _____70ED_952E_5217_8868 = {"Q", "W", "E", "R"}
    end
    do
        local i = 0
        while i < #_____70ED_952E_5217_8868 do
            if not ____exports["命令卡热键技能是否冷却中"](_____5355_4F4D, _____70ED_952E_5217_8868[i + 1]) then
                return false
            end
            i = i + 1
        end
    end
    return true
end
return ____exports
