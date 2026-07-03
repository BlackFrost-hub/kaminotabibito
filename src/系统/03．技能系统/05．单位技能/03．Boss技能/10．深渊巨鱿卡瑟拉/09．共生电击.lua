--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____6D88_8017_73A9_5BB6_89E6_624B_6B8B_7247 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["消耗玩家触手残片"]
local _____5237_65B0_5361_745F_62C9_9636_6BB5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新卡瑟拉阶段"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.11．台词播放")
local _____64AD_653E_5361_745F_62C9_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放卡瑟拉台词"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.14．公共工具")
local _____5355_4F4D_6709_6548 = ____14_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____14_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____6781_5750_6807X = ____14_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____14_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____8DDD_79BB_5E73_65B9XY = ____14_FF0E_516C_5171_5DE5_5177["距离平方XY"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("lib.扩展函数.KK扩展API.00．装饰物函数")
local DzDoodadCreate = ____require_result_3.DzDoodadCreate
local DzDoodadSetModel = ____require_result_3.DzDoodadSetModel
local DzDoodadSetVisible = ____require_result_3.DzDoodadSetVisible
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_4["施加快速控制Buff"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local ____require_result_6 = require("系统.05．Buff系统.03．Buff表.01．Boss.08．卡瑟拉")
local _____5361_745F_62C9BuffID = ____require_result_6["卡瑟拉BuffID"]
local function _____64AD_653E_70B9_7279_6548(model, x, y)
    if model == "" then
        return
    end
    local effect = AddSpecialEffect(model, x, y)
    DestroyEffect(effect)
end
local function _____64AD_653E_5355_4F4D_7279_6548(model, unit)
    if model == "" or not _____5355_4F4D_6709_6548(unit) then
        return
    end
    local effect = AddSpecialEffectTarget(model, unit, "origin")
    DestroyEffect(effect)
end
local function _____786E_4FDD_7EDD_7F18_73CA_745A(context)
    if #context["绝缘珊瑚列表"] > 0 then
        return
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["共生电击"]
    local bx = GetUnitX(boss)
    local by = GetUnitY(boss)
    do
        local i = 0
        while i < cfg["珊瑚数量"] do
            local angle = i * 120 + 40
            local x = _____6781_5750_6807X(bx, angle, cfg["珊瑚距离"])
            local y = _____6781_5750_6807Y(by, angle, cfg["珊瑚距离"])
            local doodad = DzDoodadCreate(
                stringToFourCC(cfg["珊瑚装饰物ID"]),
                1,
                x,
                y,
                0,
                angle,
                cfg["珊瑚缩放"]
            )
            DzDoodadSetModel(doodad, cfg["珊瑚模型路径"])
            local ____self_7 = context["清理"]
            ____self_7["登记清理"](
                ____self_7,
                "卡瑟拉-绝缘珊瑚装饰物",
                function()
                    DzDoodadSetVisible(doodad, false)
                end
            )
            local ____context__7EDD_7F18_73CA_745A_5217_8868_8 = context["绝缘珊瑚列表"]
            ____context__7EDD_7F18_73CA_745A_5217_8868_8[#____context__7EDD_7F18_73CA_745A_5217_8868_8 + 1] = {X = x, Y = y, ["半径"] = cfg["安全半径"], ["装饰单位"] = doodad}
            i = i + 1
        end
    end
end
local function _____73A9_5BB6_5728_7EDD_7F18_73CA_745A_5185(context, hero)
    local hx = GetUnitX(hero)
    local hy = GetUnitY(hero)
    do
        local i = 0
        while i < #context["绝缘珊瑚列表"] do
            local coral = context["绝缘珊瑚列表"][i + 1]
            if _____8DDD_79BB_5E73_65B9XY(hx, hy, coral.X, coral.Y) <= coral["半径"] * coral["半径"] then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____9884_8B66_7EDD_7F18_73CA_745A(context)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["共生电击"]
    do
        local i = 0
        while i < #context["绝缘珊瑚列表"] do
            local coral = context["绝缘珊瑚列表"][i + 1]
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "白色安全圆",
                X = coral.X,
                Y = coral.Y,
                ["半径"] = coral["半径"],
                ["持续时间"] = cfg["预警秒"],
                ["来源单位"] = context["Boss单位"]
            })
            i = i + 1
        end
    end
end
local function _____7ED3_7B97_5361_745F_62C9_5171_751F_7535_51FB(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["Boss潜入中"] then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["共生电击"]
    _____64AD_653E_70B9_7279_6548(
        cfg["全屏命中特效路径"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue22
                end
                if _____73A9_5BB6_5728_7EDD_7F18_73CA_745A_5185(context, hero) then
                    registerManualBuff(
                        hero,
                        _____5361_745F_62C9BuffID["绝缘庇护"],
                        cfg["麻痹秒"],
                        1,
                        {sourceName = "卡瑟拉-绝缘庇护"}
                    )
                    goto __continue22
                end
                if _____6D88_8017_73A9_5BB6_89E6_624B_6B8B_7247(context, hero, cfg["抵消残片数"]) then
                    goto __continue22
                end
                UnitDamageTarget(
                    boss,
                    hero,
                    cfg["雷伤害"],
                    false,
                    false,
                    ATTACK_TYPE_NORMAL,
                    DAMAGE_TYPE_LIGHTNING,
                    WEAPON_TYPE_WHOKNOWS
                )
                _____64AD_653E_5355_4F4D_7279_6548(cfg["麻痹命中特效路径"], hero)
                _____65BD_52A0_5FEB_901F_63A7_5236Buff(boss, hero, 0, cfg["麻痹秒"])
                registerManualBuff(
                    hero,
                    _____5361_745F_62C9BuffID["麻痹电流"],
                    cfg["麻痹秒"],
                    1,
                    {sourceName = "卡瑟拉-麻痹电流"}
                )
            end
            ::__continue22::
            i = i + 1
        end
    end
end
____exports["尝试释放卡瑟拉共生电击"] = function(context, nowMs)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["Boss潜入中"] then
        return
    end
    if _____5237_65B0_5361_745F_62C9_9636_6BB5(context) < 3 then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["共生电击"]
    _____786E_4FDD_7EDD_7F18_73CA_745A(context)
    if context["下次共生电击时间"] <= 0 then
        context["下次共生电击时间"] = nowMs + cfg["间隔秒"] * 1000
        return
    end
    if nowMs < context["下次共生电击时间"] then
        return
    end
    context["下次共生电击时间"] = nowMs + cfg["间隔秒"] * 1000
    _____64AD_653E_5361_745F_62C9_53F0_8BCD(boss, "共生电击")
    _____64AD_653E_70B9_7279_6548(
        cfg["蓄力特效路径"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    _____9884_8B66_7EDD_7F18_73CA_745A(context)
    local id = addDelayedCallback(
        cfg["预警秒"] * 1000,
        function()
            _____7ED3_7B97_5361_745F_62C9_5171_751F_7535_51FB(context)
        end
    )
    local ____self_9 = context["清理"]
    ____self_9["登记延迟回调"](____self_9, "卡瑟拉-共生电击结算", id)
end
____exports["注册卡瑟拉共生电击"] = function()
end
return ____exports
