--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5B62_5B50_4E91Tick, _____9020_6210AOE_6280_80FD_4F24_5BB3, _____521B_5EFA_70B9_7279_6548, _____521B_5EFA_6280_80FD_63D0_793A_5708, GetUnitStateJapi, GetUnitX, GetUnitY, GetRandomReal, IssuePointOrder, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS, UNIT_STATE_MAX_LIFE, removePeriodicCallback, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____8150_8D25_5B62_5B50_4E91_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.00．配置")
local _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["莫尔特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建莫尔特斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯音效配置"]
local ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.03．腐败值与根须领域")
local _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C = ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF["应用莫尔特斯腐败值"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____64AD_653E_83AB_5C14_7279_65AF_9650_65F6_52A8_4F5C = ____16_FF0E_516C_5171_5DE5_5177["播放莫尔特斯限时动作"]
local _____5F00_59CB_83AB_5C14_7279_65AF_5E38_89C4_65BD_6CD5 = ____16_FF0E_516C_5171_5DE5_5177["开始莫尔特斯常规施法"]
local _____6781_5750_6807X = ____16_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____16_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local stringToFourCC = ____16_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
function _____5B62_5B50_4E91Tick(data)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败孢子云"]
    local boss = data.context["Boss单位"]
    local spore = data["孢子单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(spore) or data["剩余跳数"] <= 0 then
        removePeriodicCallback(data["周期ID"])
        return
    end
    data["剩余跳数"] = data["剩余跳数"] - 1
    local currentX = GetUnitX(spore)
    local currentY = GetUnitY(spore)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue7
                end
                local dx = GetUnitX(hero) - currentX
                local dy = GetUnitY(hero) - currentY
                if dx * dx + dy * dy > cfg["半径"] * cfg["半径"] then
                    goto __continue7
                end
                local damage = GetUnitStateJapi(hero, UNIT_STATE_MAX_LIFE) * cfg["每秒目标最大生命比例"]
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["技能ID"] = _____8150_8D25_5B62_5B50_4E91_6280_80FDID,
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害"] = damage,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_PLANT,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
                _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = cfg["命中特效路径"],
                    X = GetUnitX(hero),
                    Y = GetUnitY(hero),
                    ["持续秒"] = cfg["瞬时特效持续秒"]
                })
                _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C(data.context, hero, cfg["每秒腐败值"])
            end
            ::__continue7::
            i = i + 1
        end
    end
    local angle = GetRandomReal(0, 360)
    local destinationX = _____6781_5750_6807X(currentX, angle, cfg["移动距离"])
    local destinationY = _____6781_5750_6807Y(currentY, angle, cfg["移动距离"])
    IssuePointOrder(spore, "move", destinationX, destinationY)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "敌方圆形",
        X = destinationX,
        Y = destinationY,
        ["半径"] = cfg["半径"],
        ["持续时间"] = cfg["Tick间隔毫秒"] / 1000,
        ["来源单位"] = boss
    })
end
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local jass = require("jass.common")
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
GetRandomReal = jass.GetRandomReal
IssuePointOrder = jass.IssuePointOrder
local GetUnitState = jass.GetUnitState
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
removePeriodicCallback = ____require_result_3.removePeriodicCallback
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_4["创建可攻击机制单位"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____8150_8D25_5B62_5B50_4E91_6280_80FDID = stringToFourCC(_____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败孢子云"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____83AB_5C14_7279_65AF_5B62_5B50_4E91_5468_671F(variable)
    local data = variable
    if data == nil then
        return
    end
    _____5B62_5B50_4E91Tick(data)
end
local function _____521B_5EFA_5355_56E2_5B62_5B50_4E91(context)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败孢子云"]
    local instance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-腐败孢子云",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = cfg["单位类型"],
        ["模型路径"] = cfg["模型路径"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["朝向"] = GetRandomReal(0, 360),
        ["最大生命"] = cfg["驱散所需伤害"],
        ["生命值受小怪倍率"] = cfg["受小怪倍率生命"],
        ["缩放"] = cfg["缩放"],
        ["持续时间"] = cfg["持续秒"]
    })
    if instance == nil or not _____5355_4F4D_6709_6548(instance["单位"]) then
        return
    end
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "敌方圆形",
        X = GetUnitX(instance["单位"]),
        Y = GetUnitY(instance["单位"]),
        ["半径"] = cfg["半径"],
        ["持续时间"] = cfg["Tick间隔毫秒"] / 1000,
        ["来源单位"] = boss
    })
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["腐败孢子云"]["成形"],
        GetUnitX(instance["单位"]),
        GetUnitY(instance["单位"]),
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    local data = {context = context, ["孢子单位"] = instance["单位"], ["剩余跳数"] = cfg["持续秒"], ["周期ID"] = 0}
    data["周期ID"] = addPeriodicCallback(cfg["Tick间隔毫秒"], _____83AB_5C14_7279_65AF_5B62_5B50_4E91_5468_671F, data)
    local ____self_6 = context["清理"]
    ____self_6["登记周期回调"](____self_6, "莫尔特斯-腐败孢子云周期", data["周期ID"])
end
local function _____8FFD_52A0_5B62_5B50_4E91_521B_5EFA_65F6_95F4_8F74(_____4E8B_4EF6_5217_8868, context, index)
    _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
        ["时点毫秒"] = index * 1000,
        ["名称"] = ("腐败孢子云第" .. tostring(index + 1)) .. "团",
        ["执行"] = function()
            _____521B_5EFA_5355_56E2_5B62_5B50_4E91(context)
        end
    }
end
____exports["释放莫尔特斯腐败孢子云"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败孢子云"]
    if cfg["数量"] <= 0 then
        return
    end
    if context["腐败孢子云组合执行器"] == nil then
        context["腐败孢子云组合执行器"] = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "莫尔特斯-腐败孢子云", ["清理"] = context["清理"], ["互斥组"] = "莫尔特斯腐败孢子云"})
    end
    local ____self_7 = context["腐败孢子云组合执行器"]
    if ____self_7["是否运行中"](____self_7) then
        return
    end
    local _____4E8B_4EF6_5217_8868 = {}
    do
        local i = 0
        while i < cfg["数量"] do
            _____8FFD_52A0_5B62_5B50_4E91_521B_5EFA_65F6_95F4_8F74(_____4E8B_4EF6_5217_8868, context, i)
            i = i + 1
        end
    end
    _____5F00_59CB_83AB_5C14_7279_65AF_5E38_89C4_65BD_6CD5(boss, cfg["动作播放秒"], "腐败孢子云", "莫尔特斯正在连续释放腐败孢子")
    _____64AD_653E_83AB_5C14_7279_65AF_9650_65F6_52A8_4F5C(boss, cfg["动画编号"], cfg["动画速度"], cfg["动作播放秒"])
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(boss, "腐败孢子云")
    local ____self_8 = context["腐败孢子云组合执行器"]
    ____self_8["开始"](
        ____self_8,
        {
            key = "腐败孢子云",
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = cfg["数量"] * 1000,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868(_____4E8B_4EF6_5217_8868)
        }
    )
end
local function ____on_83AB_5C14_7279_65AF_8150_8D25_5B62_5B50_4E91_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____8150_8D25_5B62_5B50_4E91_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放莫尔特斯腐败孢子云"](context)
end
____exports["注册莫尔特斯腐败孢子云"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "05．腐败孢子云",
        ["单位类型ID"] = _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8150_8D25_5B62_5B50_4E91_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_83AB_5C14_7279_65AF_8150_8D25_5B62_5B50_4E91_65BD_6CD5(boss, _____8150_8D25_5B62_5B50_4E91_6280_80FDID)
        end
    })
end
return ____exports
