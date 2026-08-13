local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____07_FF0E_62A4_76FE_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统")
local _____5F00_59CB_62A4_76FE = ____07_FF0E_62A4_76FE_7CFB_7EDF["开始护盾"]
local _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C = ____07_FF0E_62A4_76FE_7CFB_7EDF["查询单位标签护盾值"]
local _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE = ____07_FF0E_62A4_76FE_7CFB_7EDF["移除单位标签护盾"]
local jass = require("jass.common")
local GetOwningPlayer = jass.GetOwningPlayer
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local _____4E3B_52A8_5F15_7206_62A4_76FE_8868 = {}
local _____5F85_767B_8BB0_4E3B_52A8_5F15_7206_62A4_76FE_5217_8868 = {}
local function _____5355_4F4D_5B58_5728(unit)
    return unit ~= nil and unit ~= 0
end
local function _____8BBE_7F6E_4E3B_52A8_5F15_7206_6280_80FD_72B6_6001(_____63A7_5236_5668)
    local owner = GetOwningPlayer(_____63A7_5236_5668["施法者"])
    if owner ~= nil and owner ~= 0 then
        SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["主技能ID"], false)
        _____63A7_5236_5668["主技能已禁用"] = true
    end
    UnitAddAbility(_____63A7_5236_5668["施法者"], _____63A7_5236_5668["引爆技能ID"])
    if owner ~= nil and owner ~= 0 then
        SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["引爆技能ID"], true)
    end
end
local function _____6062_590D_4E3B_52A8_5F15_7206_6280_80FD_72B6_6001(_____63A7_5236_5668)
    UnitRemoveAbility(_____63A7_5236_5668["施法者"], _____63A7_5236_5668["引爆技能ID"])
    if not _____63A7_5236_5668["主技能已禁用"] then
        return
    end
    local owner = GetOwningPlayer(_____63A7_5236_5668["施法者"])
    if owner ~= nil and owner ~= 0 then
        SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["主技能ID"], true)
    end
    _____63A7_5236_5668["主技能已禁用"] = false
end
____exports["清理主动引爆护盾"] = function(_____63A7_5236_5668, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "外部清理"
    end
    if _____63A7_5236_5668 == nil or _____63A7_5236_5668["已清理"] then
        return
    end
    _____63A7_5236_5668["已清理"] = true
    local _____62A4_76FEID = _____63A7_5236_5668["护盾ID"]
    _____63A7_5236_5668["护盾ID"] = 0
    if _____62A4_76FEID ~= 0 and _____4E3B_52A8_5F15_7206_62A4_76FE_8868[_____62A4_76FEID] == _____63A7_5236_5668 then
        _____4E3B_52A8_5F15_7206_62A4_76FE_8868[_____62A4_76FEID] = nil
    end
    if _____63A7_5236_5668["on清理"] ~= nil then
        _____63A7_5236_5668["on清理"](_____63A7_5236_5668, _____539F_56E0)
    end
    _____6062_590D_4E3B_52A8_5F15_7206_6280_80FD_72B6_6001(_____63A7_5236_5668)
end
local function _____7ED3_675F_4E3B_52A8_5F15_7206_62A4_76FE(_____62A4_76FEID, _____539F_56E0)
    ____exports["清理主动引爆护盾"](_____4E3B_52A8_5F15_7206_62A4_76FE_8868[_____62A4_76FEID], _____539F_56E0)
end
local function _____4E3B_52A8_5F15_7206_62A4_76FE_7834_788E(_unit, shieldId, _absorbed)
    _____7ED3_675F_4E3B_52A8_5F15_7206_62A4_76FE(shieldId, "破碎")
end
local function _____4E3B_52A8_5F15_7206_62A4_76FE_5F00_59CB(_unit, shieldId)
    local _____63A7_5236_5668 = _____5F85_767B_8BB0_4E3B_52A8_5F15_7206_62A4_76FE_5217_8868[#_____5F85_767B_8BB0_4E3B_52A8_5F15_7206_62A4_76FE_5217_8868]
    if _____63A7_5236_5668 == nil then
        return
    end
    _____63A7_5236_5668["护盾ID"] = shieldId
    _____4E3B_52A8_5F15_7206_62A4_76FE_8868[shieldId] = _____63A7_5236_5668
end
local function _____4E3B_52A8_5F15_7206_62A4_76FE_5230_671F(_unit, shieldId)
    _____7ED3_675F_4E3B_52A8_5F15_7206_62A4_76FE(shieldId, "到期")
end
local function _____4E3B_52A8_5F15_7206_62A4_76FE_7ED3_675F(_unit, shieldId, reason)
    _____7ED3_675F_4E3B_52A8_5F15_7206_62A4_76FE(shieldId, reason)
end
____exports["创建主动引爆护盾"] = function(_____53C2_6570)
    if not _____5355_4F4D_5B58_5728(_____53C2_6570["施法者"]) or not _____5355_4F4D_5B58_5728(_____53C2_6570["护盾目标"]) then
        return nil
    end
    if _____53C2_6570["主技能ID"] == 0 or _____53C2_6570["引爆技能ID"] == 0 or _____53C2_6570["护盾标签"] == "" then
        return nil
    end
    if _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(_____53C2_6570["护盾目标"], _____53C2_6570["护盾标签"]) > 0 then
        return nil
    end
    local _____63A7_5236_5668 = {
        ["名称"] = _____53C2_6570["名称"],
        ["施法者"] = _____53C2_6570["施法者"],
        ["护盾目标"] = _____53C2_6570["护盾目标"],
        ["主技能ID"] = _____53C2_6570["主技能ID"],
        ["引爆技能ID"] = _____53C2_6570["引爆技能ID"],
        ["护盾标签"] = _____53C2_6570["护盾标签"],
        ["护盾ID"] = 0,
        ["已清理"] = false,
        ["主技能已禁用"] = false,
        ["on清理"] = _____53C2_6570["on清理"],
        ["on引爆前"] = _____53C2_6570["on引爆前"],
        ["on引爆后"] = _____53C2_6570["on引爆后"]
    }
    _____8BBE_7F6E_4E3B_52A8_5F15_7206_6280_80FD_72B6_6001(_____63A7_5236_5668)
    if _____53C2_6570["on创建前"] ~= nil then
        _____53C2_6570["on创建前"](_____63A7_5236_5668)
    end
    _____5F85_767B_8BB0_4E3B_52A8_5F15_7206_62A4_76FE_5217_8868[#_____5F85_767B_8BB0_4E3B_52A8_5F15_7206_62A4_76FE_5217_8868 + 1] = _____63A7_5236_5668
    local _____62A4_76FEID = _____5F00_59CB_62A4_76FE(
        _____53C2_6570["护盾目标"],
        __TS__ObjectAssign({}, _____53C2_6570["护盾参数"], {
            ["标签"] = _____53C2_6570["护盾标签"],
            ["开始回调"] = _____4E3B_52A8_5F15_7206_62A4_76FE_5F00_59CB,
            ["破碎回调"] = _____4E3B_52A8_5F15_7206_62A4_76FE_7834_788E,
            ["到期回调"] = _____4E3B_52A8_5F15_7206_62A4_76FE_5230_671F,
            ["结束回调"] = _____4E3B_52A8_5F15_7206_62A4_76FE_7ED3_675F
        })
    )
    table.remove(_____5F85_767B_8BB0_4E3B_52A8_5F15_7206_62A4_76FE_5217_8868)
    if _____62A4_76FEID == 0 then
        ____exports["清理主动引爆护盾"](_____63A7_5236_5668, "创建失败")
        return nil
    end
    if _____63A7_5236_5668["已清理"] then
        return nil
    end
    if _____63A7_5236_5668["护盾ID"] == 0 then
        _____63A7_5236_5668["护盾ID"] = _____62A4_76FEID
        _____4E3B_52A8_5F15_7206_62A4_76FE_8868[_____62A4_76FEID] = _____63A7_5236_5668
    end
    if _____53C2_6570["on创建成功"] ~= nil then
        _____53C2_6570["on创建成功"](_____63A7_5236_5668)
    end
    return _____63A7_5236_5668
end
____exports["主动引爆护盾仍有效"] = function(_____63A7_5236_5668)
    return _____63A7_5236_5668 ~= nil and not _____63A7_5236_5668["已清理"] and _____63A7_5236_5668["护盾ID"] ~= 0 and _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(_____63A7_5236_5668["护盾目标"], _____63A7_5236_5668["护盾标签"]) > 0
end
____exports["引爆主动引爆护盾"] = function(_____63A7_5236_5668)
    if not ____exports["主动引爆护盾仍有效"](_____63A7_5236_5668) then
        ____exports["清理主动引爆护盾"](_____63A7_5236_5668, "引爆时无有效护盾")
        return false
    end
    local _____5F53_524D_63A7_5236_5668 = _____63A7_5236_5668
    local _____5269_4F59_62A4_76FE_503C = _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(_____5F53_524D_63A7_5236_5668["护盾目标"], _____5F53_524D_63A7_5236_5668["护盾标签"])
    if _____5F53_524D_63A7_5236_5668["on引爆前"] ~= nil then
        _____5F53_524D_63A7_5236_5668["on引爆前"](_____5F53_524D_63A7_5236_5668, _____5269_4F59_62A4_76FE_503C)
    end
    _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE(_____5F53_524D_63A7_5236_5668["护盾目标"], _____5F53_524D_63A7_5236_5668["护盾标签"])
    if _____5F53_524D_63A7_5236_5668["on引爆后"] ~= nil then
        _____5F53_524D_63A7_5236_5668["on引爆后"](_____5F53_524D_63A7_5236_5668, _____5269_4F59_62A4_76FE_503C)
    end
    return true
end
return ____exports
