--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.01．属性读取")
local getRealAttr = ____require_result_0.getRealAttr
local getRealAttrWithLimit = ____require_result_0.getRealAttrWithLimit
local isPlayerUnit = ____require_result_0.isPlayerUnit
local _____6297_6027_5C5E_6027_540D_8868 = {
    ["金"] = "金属性抗性",
    ["木"] = "木属性抗性",
    ["水"] = "水属性抗性",
    ["火"] = "火属性抗性",
    ["雷"] = "雷属性抗性",
    ["光"] = "光属性抗性",
    ["暗"] = "暗属性抗性",
    ["物理"] = "物理抗性",
    ["魔法"] = "魔抗",
    ["技能"] = "技能抗性",
    ["普攻"] = "普攻抗性"
}
____exports["取单位属性抗性"] = function(_____5355_4F4D, _____7C7B_578B, _____5E94_7528_4E0A_9650)
    if _____5E94_7528_4E0A_9650 == nil then
        _____5E94_7528_4E0A_9650 = true
    end
    local attr = _____6297_6027_5C5E_6027_540D_8868[_____7C7B_578B] or ""
    if attr == "" then
        return 0
    end
    if _____5E94_7528_4E0A_9650 then
        return getRealAttrWithLimit(
            _____5355_4F4D,
            attr,
            isPlayerUnit(_____5355_4F4D)
        )
    end
    return getRealAttr(_____5355_4F4D, attr, 0)
end
____exports["满足属性抗性门槛"] = function(_____5355_4F4D, _____7C7B_578B, _____95E8_69DB, _____5E94_7528_4E0A_9650)
    if _____5E94_7528_4E0A_9650 == nil then
        _____5E94_7528_4E0A_9650 = true
    end
    return ____exports["取单位属性抗性"](_____5355_4F4D, _____7C7B_578B, _____5E94_7528_4E0A_9650) >= _____95E8_69DB
end
____exports["按抗性门槛选择数值"] = function(_____5355_4F4D, _____7C7B_578B, _____95E8_69DB, _____8FBE_6807_503C, _____672A_8FBE_6807_503C)
    return ____exports["满足属性抗性门槛"](_____5355_4F4D, _____7C7B_578B, _____95E8_69DB) and _____8FBE_6807_503C or _____672A_8FBE_6807_503C
end
return ____exports
