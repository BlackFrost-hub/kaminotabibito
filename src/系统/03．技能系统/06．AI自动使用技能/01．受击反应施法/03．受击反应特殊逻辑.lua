--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_53D7_51FB_53CD_5E94_6267_884C = require("系统.03．技能系统.06．AI自动使用技能.01．受击反应施法.04．受击反应执行")
local _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD = ____04_FF0E_53D7_51FB_53CD_5E94_6267_884C["尝试执行受击技能"]
local _____53D6_968F_673A_5750_6807_504F_79FB = ____04_FF0E_53D7_51FB_53CD_5E94_6267_884C["取随机坐标偏移"]
local _____83B7_53D6_6280_80FD_547D_4EE4_5B57_4E32 = ____04_FF0E_53D7_51FB_53CD_5E94_6267_884C["获取技能命令字串"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRangeOfUnit = ____require_result_0.getEnemyUnitsInRangeOfUnit
local ____require_result_1 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local GetUnitLifePercentBJ = ____require_result_1.GetUnitLifePercentBJ
local ____require_result_2 = require("系统.05．Buff系统.02．Buff数据表.01．Buff名反查工具")
local _____6309_540D_5B57_53CD_67E5BuffID = ____require_result_2["按名字反查BuffID"]
local BUFF_BLOODLUST = _____6309_540D_5B57_53CD_67E5BuffID("嗜血术") or "Bblo"
local IssuePointOrder = jass.IssuePointOrder
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.施法状态")
local _____5355_4F4D_662F_5426_6B63_5728_539F_751F_65BD_6CD5 = ____require_result_3["单位是否正在原生施法"]
local _____7279_6B8A_903B_8F91_6620_5C04 = {}
local function _____8718_86DB_5973_7687_53D7_51FB_55B7_5C04(_config, unit, source)
    if jass.GetRandomInt(1, 8) ~= 1 then
        return false
    end
    return _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["命令字串"] = "carrionswarm", ["施法方式"] = "对点", ["目标来源"] = "伤害来源坐标"}, unit, source)
end
local function _____8725_8734_602A_7269_53D7_51FB_55B7_706B(_config, unit, source)
    if jass.GetRandomInt(1, 8) ~= 1 then
        return false
    end
    return _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["命令字串"] = "breathoffire", ["施法方式"] = "对点", ["目标来源"] = "伤害来源坐标"}, unit, source)
end
local function _____6E56_5E95_5143_7D20_53D7_51FB_8FDE_62DB(_config, unit, source)
    local executed = false
    executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = "A04U", ["施法方式"] = "对单位", ["目标来源"] = "伤害来源", ["下单归属"] = "中立敌对"}, unit, source) or executed
    local skillId = jass.GetRandomInt(1, 2) == 1 and "A04Q" or "A04P"
    executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = skillId, ["施法方式"] = "对单位", ["目标来源"] = "伤害来源", ["下单归属"] = "中立敌对"}, unit, source) or executed
    return executed
end
local function _____795E_7F57_6218_58EB_53D7_51FB_968F_673A_6280_80FD(_config, unit, source)
    local roll = jass.GetRandomInt(1, 3)
    local executed = false
    executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = "A0HA", ["施法方式"] = "立即", ["下单归属"] = "中立敌对", ["与伤害来源距离不大于"] = 450}, unit, source) or executed
    if not executed and roll == 3 then
        executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = "A0HB", ["命令字段"] = "Orderon", ["施法方式"] = "立即", ["下单归属"] = "中立敌对"}, unit, source) or executed
    end
    return executed
end
local function _____6BD4_90A3_540D_5C45_5929_5B50_53D7_51FB_968F_673A_6280_80FD(_config, unit, source)
    if jass.GetRandomInt(1, 2) == 1 then
        return false
    end
    local executed = false
    if GetUnitLifePercentBJ(unit) <= 70 then
        executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = "A0H5", ["施法方式"] = "立即", ["下单归属"] = "中立敌对"}, unit, source) or executed
    end
    if (jass.GetUnitX(source) - jass.GetUnitX(unit)) * (jass.GetUnitX(source) - jass.GetUnitX(unit)) + (jass.GetUnitY(source) - jass.GetUnitY(unit)) * (jass.GetUnitY(source) - jass.GetUnitY(unit)) <= 1000 * 1000 then
        if GetUnitLifePercentBJ(unit) <= 85 then
            executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = "A0H3", ["施法方式"] = "立即", ["下单归属"] = "中立敌对"}, unit, source) or executed
        end
        if GetUnitLifePercentBJ(unit) <= 45 then
            executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = "A0H4", ["施法方式"] = "立即", ["下单归属"] = "中立敌对"}, unit, source) or executed
        end
    end
    return executed
end
local function _____6C34_89E6_987B_8303_56F4_7F20_7ED5(_config, unit, _source)
    local targets = getEnemyUnitsInRangeOfUnit(unit, 700)
    if #targets <= 0 then
        return false
    end
    return _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["命令字串"] = "entanglingroots", ["施法方式"] = "对单位", ["目标来源"] = "伤害来源"}, unit, targets[1])
end
local function _____5947_5999_9E7F_53D7_51FB_53CD_5236(_config, unit, source)
    if jass.GetUnitAbilityLevel(unit, BUFF_BLOODLUST) > 0 then
        return false
    end
    local executed = false
    executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["命令字串"] = "bloodlust", ["施法方式"] = "对单位", ["目标来源"] = "自己"}, unit, source) or executed
    executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = "A0I3", ["施法方式"] = "立即", ["下单归属"] = "中立敌对", ["与伤害来源距离不大于"] = 350}, unit, source) or executed
    executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = "A0I4", ["施法方式"] = "对单位", ["目标来源"] = "伤害来源", ["下单归属"] = "中立敌对"}, unit, source) or executed
    return executed
end
local function _____7075_6BD2_738B_86C7_53D7_51FB_8FDE_62DB(_config, unit, source)
    local executed = false
    executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = "A0IC", ["施法方式"] = "对单位", ["目标来源"] = "伤害来源", ["下单归属"] = "中立敌对"}, unit, source) or executed
    executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = "A0IE", ["施法方式"] = "立即", ["下单归属"] = "中立敌对"}, unit, source) or executed
    local point = _____53D6_968F_673A_5750_6807_504F_79FB(source, 400)
    local pointOrder = _____83B7_53D6_6280_80FD_547D_4EE4_5B57_4E32({["技能ID"] = "A0ID", ["施法方式"] = "对点"})
    if pointOrder ~= "" and IssuePointOrder(unit, pointOrder, point[1], point[2]) == true then
        executed = true
    else
        executed = _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD({["技能ID"] = "A0ID", ["施法方式"] = "对点", ["目标来源"] = "伤害来源坐标", ["下单归属"] = "中立敌对"}, unit, source) or executed
    end
    return executed
end
_____7279_6B8A_903B_8F91_6620_5C04["蜘蛛女皇受击喷射"] = _____8718_86DB_5973_7687_53D7_51FB_55B7_5C04
_____7279_6B8A_903B_8F91_6620_5C04["蜥蜴怪物受击喷火"] = _____8725_8734_602A_7269_53D7_51FB_55B7_706B
_____7279_6B8A_903B_8F91_6620_5C04["湖底元素受击连招"] = _____6E56_5E95_5143_7D20_53D7_51FB_8FDE_62DB
_____7279_6B8A_903B_8F91_6620_5C04["神罗战士受击随机技能"] = _____795E_7F57_6218_58EB_53D7_51FB_968F_673A_6280_80FD
_____7279_6B8A_903B_8F91_6620_5C04["比那名居天子受击随机技能"] = _____6BD4_90A3_540D_5C45_5929_5B50_53D7_51FB_968F_673A_6280_80FD
_____7279_6B8A_903B_8F91_6620_5C04["水触须范围缠绕"] = _____6C34_89E6_987B_8303_56F4_7F20_7ED5
_____7279_6B8A_903B_8F91_6620_5C04["奇妙鹿受击反制"] = _____5947_5999_9E7F_53D7_51FB_53CD_5236
_____7279_6B8A_903B_8F91_6620_5C04["灵毒王蛇受击连招"] = _____7075_6BD2_738B_86C7_53D7_51FB_8FDE_62DB
____exports["执行受击反应特殊逻辑"] = function(config, unit, source)
    if config["特殊逻辑名"] == nil or config["特殊逻辑名"] == "" then
        return false
    end
    if _____5355_4F4D_662F_5426_6B63_5728_539F_751F_65BD_6CD5(unit) then
        return false
    end
    local fn = _____7279_6B8A_903B_8F91_6620_5C04[config["特殊逻辑名"]]
    if fn == nil then
        return false
    end
    return fn(config, unit, source)
end
return ____exports
