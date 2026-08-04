local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local ObjectType = ____require_result_0.ObjectType
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local getObjectPropertySafe = ____require_result_1.getObjectPropertySafe
local YDWEDistanceBetweenUnitsSafe = ____require_result_1.YDWEDistanceBetweenUnitsSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_2.stringToFourCC
local ____require_result_3 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local GetUnitLifePercentBJ = ____require_result_3.GetUnitLifePercentBJ
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.施法状态")
local _____5355_4F4D_662F_5426_6B63_5728_539F_751F_65BD_6CD5 = ____require_result_4["单位是否正在原生施法"]
local GetOwningPlayer = jass.GetOwningPlayer
local GetRandomInt = jass.GetRandomInt
local GetRandomReal = jass.GetRandomReal
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueImmediateOrder = jass.IssueImmediateOrder
local IssueNeutralImmediateOrder = jass.IssueNeutralImmediateOrder
local IssuePointOrder = jass.IssuePointOrder
local IssueNeutralPointOrder = jass.IssueNeutralPointOrder
local IssueTargetOrder = jass.IssueTargetOrder
local IssueNeutralTargetOrder = jass.IssueNeutralTargetOrder
local Player = jass.Player
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
local _____6280_80FD_547D_4EE4_7F13_5B58 = {}
local _____6280_80FD_6570_503C_7F13_5B58 = {}
local ____Buff_6570_503C_7F13_5B58 = {}
local function _____83B7_53D6_6280_80FD_6570_503CID(rawcode)
    if rawcode == nil or rawcode == "" then
        return 0
    end
    local cached = _____6280_80FD_6570_503C_7F13_5B58[rawcode]
    if cached ~= nil then
        return cached
    end
    local value = stringToFourCC(rawcode)
    _____6280_80FD_6570_503C_7F13_5B58[rawcode] = value
    return value
end
local function _____83B7_53D6Buff_6570_503CID(rawcode)
    if rawcode == nil or rawcode == "" then
        return 0
    end
    local cached = ____Buff_6570_503C_7F13_5B58[rawcode]
    if cached ~= nil then
        return cached
    end
    local value = stringToFourCC(rawcode)
    ____Buff_6570_503C_7F13_5B58[rawcode] = value
    return value
end
local function _____83B7_53D6_5F53_524D_73A9_5BB6_4EBA_6570()
    local ____temp_5
    if jglobals.udg_T ~= nil then
        ____temp_5 = jglobals.udg_T
    else
        ____temp_5 = jglobals.T
    end
    local _____73A9_5BB6_4EBA_6570 = ____temp_5
    return __TS__Number(_____73A9_5BB6_4EBA_6570) or 0
end
____exports["获取技能命令字串"] = function(skill)
    if type(skill["命令字串"]) == "string" and skill["命令字串"] ~= "" then
        return skill["命令字串"]
    end
    if type(skill["技能ID"]) ~= "string" or skill["技能ID"] == "" then
        return ""
    end
    local _____547D_4EE4_5B57_6BB5 = skill["命令字段"] or "Order"
    local _____7F13_5B58_952E = (skill["技能ID"] .. ":") .. _____547D_4EE4_5B57_6BB5
    local cached = _____6280_80FD_547D_4EE4_7F13_5B58[_____7F13_5B58_952E]
    if cached ~= nil then
        return cached
    end
    local value = getObjectPropertySafe(ObjectType.ABILITY, skill["技能ID"], _____547D_4EE4_5B57_6BB5) or ""
    _____6280_80FD_547D_4EE4_7F13_5B58[_____7F13_5B58_952E] = value
    return value
end
____exports["受击技能是否满足条件"] = function(skill, unit, source)
    if skill["技能ID"] ~= nil and skill["技能ID"] ~= "" then
        local abilityId = _____83B7_53D6_6280_80FD_6570_503CID(skill["技能ID"])
        if abilityId == 0 or GetUnitAbilityLevel(unit, abilityId) <= 0 then
            return false
        end
    end
    if skill["触发概率分子"] ~= nil and skill["触发概率分母"] ~= nil then
        if skill["触发概率分母"] <= 0 then
            return false
        end
        if GetRandomInt(1, skill["触发概率分母"]) > skill["触发概率分子"] then
            return false
        end
    end
    if skill["最低玩家人数"] ~= nil then
        local _____5F53_524D_73A9_5BB6_4EBA_6570 = _____83B7_53D6_5F53_524D_73A9_5BB6_4EBA_6570()
        if _____5F53_524D_73A9_5BB6_4EBA_6570 < skill["最低玩家人数"] then
            return false
        end
    end
    if source ~= nil and source ~= 0 then
        local distance = YDWEDistanceBetweenUnitsSafe(unit, source)
        if skill["与伤害来源距离不大于"] ~= nil and distance > skill["与伤害来源距离不大于"] then
            return false
        end
        if skill["与伤害来源距离不小于"] ~= nil and distance < skill["与伤害来源距离不小于"] then
            return false
        end
    end
    if skill["自身生命值不高于"] ~= nil and GetUnitLifePercentBJ(unit) > skill["自身生命值不高于"] then
        return false
    end
    if skill["自身生命值不低于"] ~= nil and GetUnitLifePercentBJ(unit) < skill["自身生命值不低于"] then
        return false
    end
    if skill["需要无BuffID"] ~= nil and skill["需要无BuffID"] ~= "" then
        local buffId = _____83B7_53D6Buff_6570_503CID(skill["需要无BuffID"])
        if buffId ~= 0 and GetUnitAbilityLevel(unit, buffId) > 0 then
            return false
        end
    end
    return true
end
local function _____53D6_4E0B_5355_73A9_5BB6(unit, skill)
    if skill["下单归属"] == "中立敌对" then
        return _____4E2D_7ACB_654C_5BF9_73A9_5BB6
    end
    return GetOwningPlayer(unit)
end
local function _____53D6_76EE_6807_5355_4F4D(skill, unit, source)
    if skill["目标来源"] == "自己" then
        return unit
    end
    return source
end
local function _____53D6_76EE_6807_5750_6807(skill, unit, source)
    if skill["目标来源"] == "自己" then
        return {
            GetUnitX(unit),
            GetUnitY(unit)
        }
    end
    return {
        GetUnitX(source),
        GetUnitY(source)
    }
end
____exports["尝试执行受击技能"] = function(skill, unit, source)
    if _____5355_4F4D_662F_5426_6B63_5728_539F_751F_65BD_6CD5(unit) then
        return false
    end
    if not ____exports["受击技能是否满足条件"](skill, unit, source) then
        return false
    end
    local order = ____exports["获取技能命令字串"](skill)
    if order == "" then
        return false
    end
    local _____4E0B_5355_73A9_5BB6 = _____53D6_4E0B_5355_73A9_5BB6(unit, skill)
    if skill["施法方式"] == "立即" then
        if skill["下单归属"] == "中立敌对" then
            return IssueNeutralImmediateOrder(_____4E0B_5355_73A9_5BB6, unit, order) == true
        end
        return IssueImmediateOrder(unit, order) == true
    end
    if skill["施法方式"] == "对单位" then
        local target = _____53D6_76EE_6807_5355_4F4D(skill, unit, source)
        if target == nil or target == 0 then
            return false
        end
        if skill["下单归属"] == "中立敌对" then
            return IssueNeutralTargetOrder(_____4E0B_5355_73A9_5BB6, unit, order, target) == true
        end
        return IssueTargetOrder(unit, order, target) == true
    end
    if skill["施法方式"] == "对点" then
        local target = _____53D6_76EE_6807_5750_6807(skill, unit, source)
        if skill["下单归属"] == "中立敌对" then
            return IssueNeutralPointOrder(
                _____4E0B_5355_73A9_5BB6,
                unit,
                order,
                target[1],
                target[2]
            ) == true
        end
        return IssuePointOrder(unit, order, target[1], target[2]) == true
    end
    return false
end
____exports["取随机坐标偏移"] = function(source, range)
    return {
        GetUnitX(source) + GetRandomReal(-range, range),
        GetUnitY(source) + GetRandomReal(-range, range)
    }
end
return ____exports
