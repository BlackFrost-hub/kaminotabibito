local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.00．配置")
local _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["莫尔特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建莫尔特斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.03．腐败值与根须领域")
local _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C = ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF["应用莫尔特斯腐败值"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____16_FF0E_516C_5171_5DE5_5177.stringToFourCC
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local UnitDamageTarget = jass.UnitDamageTarget
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomInt = jass.GetRandomInt
local IsUnitEnemy = jass.IsUnitEnemy
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local AddSpecialEffect = jass.AddSpecialEffect
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_3["创建可攻击机制单位"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____8150_673D_6839_987B_7A7F_523A_6280_80FDID = stringToFourCC(_____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽根须穿刺"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____9009_62E9_6839_987B_7A7F_523A_683C_5B50(context)
    local grid = context["根须宫格"]
    local result = {}
    if grid == nil then
        return result
    end
    local pool = {}
    do
        local i = 0
        while i < grid["格子列表"].length do
            pool[#pool + 1] = grid["格子列表"][i]
            i = i + 1
        end
    end
    local count = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽根须穿刺"]["区域数量"]
    do
        local i = 0
        while i < count and #pool > 0 do
            local index = GetRandomInt(0, #pool - 1)
            result[#result + 1] = pool[index + 1]
            __TS__ArraySplice(pool, index, 1)
            i = i + 1
        end
    end
    return result
end
local function _____7ED3_7B97_5355_683C_6839_987B_7A7F_523A(context, cell)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽根须穿刺"]
    AddSpecialEffect(cfg["穿刺特效路径"], cell["中心X"], cell["中心Y"])
    _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-残留根须",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = cfg["障碍单位类型"],
        ["模型路径"] = cfg["根须模型路径"],
        X = cell["中心X"],
        Y = cell["中心Y"],
        ["最大生命"] = cfg["障碍生命值"],
        ["缩放"] = cfg["障碍缩放"],
        ["持续时间"] = cfg["根须停留秒"]
    })
    local group = CreateGroup()
    GroupEnumUnitsInRect(group, cell["矩形"], nil)
    local unit = FirstOfGroup(group)
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["Boss攻击力比例"]
    while unit ~= nil and unit ~= 0 do
        GroupRemoveUnit(group, unit)
        if _____5355_4F4D_6709_6548(unit) and IsUnitEnemy(
            unit,
            GetOwningPlayer(boss)
        ) == true then
            UnitDamageTarget(
                boss,
                unit,
                damage,
                false,
                false,
                ATTACK_TYPE_NORMAL,
                DAMAGE_TYPE_PLANT,
                WEAPON_TYPE_WHOKNOWS
            )
            _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C(context, unit, cfg["腐败值"])
        end
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
end
local function _____83AB_5C14_7279_65AF_6839_987B_7A7F_523A_5EF6_8FDF_7ED3_7B97(variable)
    local data = variable
    if data == nil then
        return
    end
    _____7ED3_7B97_5355_683C_6839_987B_7A7F_523A(data.context, data.cell)
end
local function _____91CA_653E_83AB_5C14_7279_65AF_8150_673D_6839_987B_7A7F_523A(context)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽根须穿刺"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(boss, "腐朽根须穿刺")
    local cells = _____9009_62E9_6839_987B_7A7F_523A_683C_5B50(context)
    do
        local i = 0
        while i < #cells do
            local cell = cells[i + 1]
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "矩形",
                X = cell["中心X"],
                Y = cell["中心Y"],
                ["宽度"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根须领域"]["单格边长"],
                ["长度"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根须领域"]["单格边长"],
                ["朝向"] = 0,
                ["持续时间"] = cfg["预警秒"]
            })
            local id = addDelayedCallback(cfg["预警秒"] * 1000, _____83AB_5C14_7279_65AF_6839_987B_7A7F_523A_5EF6_8FDF_7ED3_7B97, {context = context, cell = cell})
            local ____self_5 = context["清理"]
            ____self_5["登记延迟回调"](____self_5, "莫尔特斯-腐朽根须穿刺", id)
            i = i + 1
        end
    end
end
local function ____on_83AB_5C14_7279_65AF_8150_673D_6839_987B_7A7F_523A_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____8150_673D_6839_987B_7A7F_523A_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    _____91CA_653E_83AB_5C14_7279_65AF_8150_673D_6839_987B_7A7F_523A(context)
end
____exports["注册莫尔特斯腐朽根须穿刺"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_83AB_5C14_7279_65AF_8150_673D_6839_987B_7A7F_523A_65BD_6CD5)
end
return ____exports
