--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____745F_5170_8FEA_5C14_7684_51B3_5FC3_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["瑟兰迪尔的决心物品ID"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____8BBE_7F6E_7269_54C1CD = ____20_FF0E_7269_54C1_8F85_52A9["设置物品CD"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitName = jass.GetUnitName
local _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E = {
    ["单位类型"] = "e08P",
    ModelFileID = "war3mapImported\\ArcherGryphonKotSHV1.01.mdl",
    ["持续时间"] = 30,
    ["生命值"] = 5000,
    ["攻击力"] = 350,
    ["召唤者攻击力继承比例"] = 0.25,
    atkCd = 2,
    range = 600,
    missileModel = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareMissile.mdl",
    missileSpeed = 900,
    acquireRange = 1200,
    ["护甲"] = 35,
    ["缩放"] = 1.6,
    ["透明度"] = 170,
    ["红"] = 180,
    ["绿"] = 220,
    ["蓝"] = 255
}
local _____745F_5170_8FEA_5C14_7684_51B3_5FC3_4E3B_52A8_6280_80FD_58F3ID = "IN00"
local _____745F_5170_8FEA_5C14_7684_51B3_5FC3_51B7_5374_79D2_6570 = 120
local function _____662F_745F_5170_8FEA_5C14_7684_51B3_5FC3_7269_54C1(item)
    return item ~= nil and item ~= 0 and _____745F_5170_8FEA_5C14_7684_51B3_5FC3_7269_54C1ID ~= 0 and GetItemTypeId(item) == _____745F_5170_8FEA_5C14_7684_51B3_5FC3_7269_54C1ID
end
____exports["处理瑟兰迪尔的决心使用"] = function(ctx)
    local caster = ctx["施法单位"]
    if caster == nil or caster == 0 then
        return
    end
    if not _____662F_745F_5170_8FEA_5C14_7684_51B3_5FC3_7269_54C1(ctx["物品"]) then
        return
    end
    _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = caster,
        ["单位类型"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E["单位类型"],
        ["单位名称"] = GetUnitName(caster) .. "的水元素",
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        ["朝向"] = GetUnitFacing(caster),
        ModelFileID = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E.ModelFileID,
        ["持续时间"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E["持续时间"],
        ["生命值"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E["生命值"],
        ["攻击力"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E["攻击力"] + _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E["召唤者攻击力继承比例"],
        atkCd = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E.atkCd,
        range = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E.range,
        missileModel = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E.missileModel,
        missileSpeed = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E.missileSpeed,
        acquireRange = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E.acquireRange,
        ["护甲"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E["护甲"],
        ["缩放"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E["缩放"],
        ["透明度"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E["透明度"],
        ["红"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E["红"],
        ["绿"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E["绿"],
        ["蓝"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_914D_7F6E["蓝"]
    })
    _____8BBE_7F6E_7269_54C1CD({
        unit = caster,
        item = ctx["物品"],
        ["秒数"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_51B7_5374_79D2_6570,
        ["范围"] = "主动",
        ["主动技能ID"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_4E3B_52A8_6280_80FD_58F3ID,
        ["主动最大冷却秒数"] = _____745F_5170_8FEA_5C14_7684_51B3_5FC3_51B7_5374_79D2_6570
    })
end
return ____exports
