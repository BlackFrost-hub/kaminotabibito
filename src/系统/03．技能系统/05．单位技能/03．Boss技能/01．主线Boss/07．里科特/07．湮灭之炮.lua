--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.00．配置")
local _____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["里科特单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建里科特上下文"]
local _____5237_65B0_91CC_79D1_7279_9636_6BB5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新里科特阶段"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.02．数值与表现配置")
local _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特数值与表现配置"]
local _____91CC_79D1_7279_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特音效配置"]
local ____10_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.10．台词播放")
local _____64AD_653E_91CC_79D1_7279_53F0_8BCD = ____10_FF0E_53F0_8BCD_64AD_653E["播放里科特台词"]
local ____13_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.13．公共工具")
local _____5355_4F4D_6709_6548 = ____13_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____13_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_5750_6807_89D2_5EA6 = ____13_FF0E_516C_5171_5DE5_5177["取坐标角度"]
local _____6781_5750_6807X = ____13_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____13_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____13_FF0E_516C_5171_5DE5_5177["点到线段距离平方"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local CreateUnit = jass.CreateUnit
local RemoveUnit = jass.RemoveUnit
local SetUnitScale = jass.SetUnitScale
local SetUnitVertexColor = jass.SetUnitVertexColor
local UnitAddAbility = jass.UnitAddAbility
local SetUnitPathing = jass.SetUnitPathing
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_4["获取Boss技能随机敌对英雄"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local ____require_result_6 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.06．里科特")
local _____91CC_79D1_7279BuffID = ____require_result_6["里科特BuffID"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____65BD_52A0_7729_6655 = ____require_result_7["施加眩晕"]
local _____91CC_79D1_7279_5355_4F4D_7C7B_578BID = stringToFourCC(_____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6E6E_706D_4E4B_70AE_6280_80FDID = stringToFourCC(_____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]["技能槽位"])
local _____8757_866B_6280_80FDID = stringToFourCC("Aloc")
local _____5DF2_6CE8_518C = false
local function _____64AD_653E_9650_65F6_70B9_7279_6548(model, x, y, duration)
    if model == "" then
        return
    end
    local effect = AddSpecialEffect(model, x, y)
    addDelayedCallback(
        duration * 1000,
        function()
            DestroyEffect(effect)
        end
    )
end
local function _____521B_5EFA_6E6E_706D_6295_5F71_5355_4F4D(boss, x, y, face)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    local projection = CreateUnit(
        GetOwningPlayer(boss),
        stringToFourCC(cfg["投影单位类型"]),
        x,
        y,
        face
    )
    if projection == nil or projection == 0 then
        return projection
    end
    UnitAddAbility(projection, _____8757_866B_6280_80FDID)
    SetUnitPathing(projection, false)
    SetUnitScale(projection, cfg["投影缩放"], cfg["投影缩放"], cfg["投影缩放"])
    SetUnitVertexColor(
        projection,
        160,
        210,
        255,
        cfg["投影透明度"]
    )
    _____64AD_653E_9650_65F6_70B9_7279_6548(cfg["出现特效路径"], x, y, 1)
    return projection
end
local function _____521B_5EFA_6E6E_706D_4E4B_70AE_9884_8B66(data)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = data["起点X"],
        Y = data["起点Y"],
        ["宽度"] = 180,
        ["长度"] = cfg["射程"],
        ["朝向"] = data["朝向"],
        ["持续时间"] = cfg["tick秒"],
        ["来源单位"] = data.context["Boss单位"]
    })
end
local function _____7ED3_7B97_6E6E_706D_4E4B_70AE_4E00_8DF3(data)
    local boss = data.context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or data["剩余跳数"] <= 0 then
        removePeriodicCallback(data["周期ID"])
        if data["投影"] ~= nil and data["投影"] ~= 0 then
            RemoveUnit(data["投影"])
        end
        return
    end
    data["剩余跳数"] = data["剩余跳数"] - 1
    _____521B_5EFA_6E6E_706D_4E4B_70AE_9884_8B66(data)
    _____64AD_653E_9650_65F6_70B9_7279_6548(_____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]["射线特效路径"], data["终点X"], data["终点Y"], _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]["射线持续秒"])
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]["每跳Boss攻击力比例"]
    local radius2 = 90 * 90
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue12
                end
                local dist2 = _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                    GetUnitX(hero),
                    GetUnitY(hero),
                    data["起点X"],
                    data["起点Y"],
                    data["终点X"],
                    data["终点Y"]
                )
                if dist2 <= radius2 then
                    _____9020_6210AOE_6280_80FD_4F24_5BB3({
                        ["技能ID"] = _____6E6E_706D_4E4B_70AE_6280_80FDID,
                        ["来源"] = boss,
                        ["目标"] = hero,
                        ["伤害"] = damage,
                        attack = false,
                        ranged = false,
                        attackType = ATTACK_TYPE_MAGIC,
                        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                        weaponType = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "Boss技能"
                    })
                end
            end
            ::__continue12::
            i = i + 1
        end
    end
end
local function _____5F00_59CB_6E6E_706D_6295_5F71_70AE_51FB(data)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    _____64AD_653EBoss_5750_6807_97F3_6548(_____91CC_79D1_7279_97F3_6548_914D_7F6E["湮灭之炮"]["射线开火"], data["起点X"], data["起点Y"], _____91CC_79D1_7279_97F3_6548_914D_7F6E["默认裁断距离"])
    data["剩余跳数"] = cfg["锁定持续秒"] / cfg["tick秒"]
    data["周期ID"] = addPeriodicCallback(
        cfg["tick秒"] * 1000,
        function()
            _____7ED3_7B97_6E6E_706D_4E4B_70AE_4E00_8DF3(data)
        end
    )
    local ____self_8 = data.context["清理"]
    ____self_8["登记周期回调"](____self_8, "里科特-湮灭之炮周期", data["周期ID"])
end
local function _____8C03_5EA6_5355_4E2A_6E6E_706D_6295_5F71(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    local angle = _____53D6_5750_6807_89D2_5EA6(
        GetUnitX(boss),
        GetUnitY(boss),
        GetUnitX(target),
        GetUnitY(target)
    )
    local px = _____6781_5750_6807X(
        GetUnitX(target),
        angle,
        cfg["投影距离"]
    )
    local py = _____6781_5750_6807Y(
        GetUnitY(target),
        angle,
        cfg["投影距离"]
    )
    local face = _____53D6_5750_6807_89D2_5EA6(
        px,
        py,
        GetUnitX(target),
        GetUnitY(target)
    )
    local projection = _____521B_5EFA_6E6E_706D_6295_5F71_5355_4F4D(boss, px, py, face)
    _____64AD_653EBoss_5750_6807_97F3_6548(_____91CC_79D1_7279_97F3_6548_914D_7F6E["湮灭之炮"]["投影锁定"], px, py, _____91CC_79D1_7279_97F3_6548_914D_7F6E["默认裁断距离"])
    local data = {
        context = context,
        ["投影"] = projection,
        ["目标"] = target,
        ["起点X"] = px,
        ["起点Y"] = py,
        ["终点X"] = _____6781_5750_6807X(px, face, cfg["射程"]),
        ["终点Y"] = _____6781_5750_6807Y(py, face, cfg["射程"]),
        ["朝向"] = face,
        ["剩余跳数"] = 0,
        ["周期ID"] = 0
    }
    if projection ~= nil and projection ~= 0 then
        local ____self_9 = context["清理"]
        ____self_9["登记单位"](____self_9, "里科特-湮灭投影", projection)
    end
    registerManualBuff(
        target,
        _____91CC_79D1_7279BuffID["湮灭锁定"],
        cfg["锁定前延迟秒"] + cfg["锁定持续秒"],
        1,
        {sourceName = "里科特-湮灭锁定"}
    )
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = px,
        Y = py,
        ["宽度"] = 180,
        ["长度"] = cfg["射程"],
        ["朝向"] = face,
        ["持续时间"] = _____5237_65B0_91CC_79D1_7279_9636_6BB5(context) >= 2 and cfg["P2锁定前延迟秒"] or cfg["锁定前延迟秒"],
        ["来源单位"] = boss
    })
    local delay = _____5237_65B0_91CC_79D1_7279_9636_6BB5(context) >= 2 and cfg["P2锁定前延迟秒"] or cfg["锁定前延迟秒"]
    local id = addDelayedCallback(
        delay * 1000,
        function()
            _____5F00_59CB_6E6E_706D_6295_5F71_70AE_51FB(data)
        end
    )
    local ____self_10 = context["清理"]
    ____self_10["登记延迟回调"](____self_10, "里科特-湮灭投影开炮", id)
end
local function _____8C03_5EA6P3_7729_6655_70AE(context)
    if _____5237_65B0_91CC_79D1_7279_9636_6BB5(context) < 3 then
        return
    end
    local boss = context["Boss单位"]
    local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss, boss, 2000)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = GetUnitX(target),
        Y = GetUnitY(target),
        ["半径"] = cfg["P3眩晕炮半径"],
        ["持续时间"] = cfg["P3眩晕炮延迟秒"],
        ["来源单位"] = boss
    })
    local id = addDelayedCallback(
        cfg["P3眩晕炮延迟秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
                return
            end
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            local cx = GetUnitX(target)
            local cy = GetUnitY(target)
            local radius2 = cfg["P3眩晕炮半径"] * cfg["P3眩晕炮半径"]
            do
                local i = 0
                while i < #heroes do
                    do
                        local hero = heroes[i + 1]
                        if not _____5355_4F4D_6709_6548(hero) then
                            goto __continue27
                        end
                        local dx = GetUnitX(hero) - cx
                        local dy = GetUnitY(hero) - cy
                        if dx * dx + dy * dy <= radius2 then
                            _____65BD_52A0_7729_6655(boss, hero, cfg["P3眩晕秒"])
                        end
                    end
                    ::__continue27::
                    i = i + 1
                end
            end
        end
    )
    local ____self_11 = context["清理"]
    ____self_11["登记延迟回调"](____self_11, "里科特-P3湮灭眩晕炮", id)
end
____exports["释放里科特湮灭之炮"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    _____64AD_653E_91CC_79D1_7279_53F0_8BCD(boss, "湮灭之炮")
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            _____8C03_5EA6_5355_4E2A_6E6E_706D_6295_5F71(context, heroes[i + 1])
            i = i + 1
        end
    end
    _____8C03_5EA6P3_7729_6655_70AE(context)
end
local function ____on_91CC_79D1_7279_6E6E_706D_4E4B_70AE_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6E6E_706D_4E4B_70AE_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____91CC_79D1_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放里科特湮灭之炮"](context)
end
____exports["注册里科特湮灭之炮"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "07．湮灭之炮",
        ["单位类型ID"] = _____91CC_79D1_7279_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6E6E_706D_4E4B_70AE_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_91CC_79D1_7279_6E6E_706D_4E4B_70AE_65BD_6CD5(boss, _____6E6E_706D_4E4B_70AE_6280_80FDID)
        end
    })
end
return ____exports
