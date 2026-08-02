--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.00．配置")
local _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["卡瑟拉单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建卡瑟拉上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local _____5361_745F_62C9_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉音效配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.11．台词播放")
local _____64AD_653E_5361_745F_62C9_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放卡瑟拉台词"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.14．公共工具")
local _____5355_4F4D_6709_6548 = ____14_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____14_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____8DDD_79BBXY = ____14_FF0E_516C_5171_5DE5_5177["距离XY"]
local _____9650_5236_6570_503C = ____14_FF0E_516C_5171_5DE5_5177["限制数值"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_2["创建点特效"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.方向抵抗牵引")
local _____5F00_59CB_65B9_5411_62B5_6297_7275_5F15 = ____require_result_4["开始方向抵抗牵引"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____65BD_52A0_7729_6655 = ____require_result_5["施加眩晕"]
local _____5361_745F_62C9_5355_4F4D_7C7B_578BID = stringToFourCC(_____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6DF1_6D77_6DA1_6D41_6280_80FDID = stringToFourCC(_____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["深海涡流"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____64AD_653E_9650_65F6_6DA1_6D41_7279_6548(context, x, y)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["深海涡流"]
    local model = cfg["涡流模型路径"]
    if model == "" then
        return
    end
    local effect = _____521B_5EFA_70B9_7279_6548({["模型路径"] = model, X = x, Y = y})
    local ____self_6 = context["清理"]
    ____self_6["登记限时特效"](____self_6, "卡瑟拉-深海涡流特效", effect, cfg["涡流特效持续秒"] * 1000)
end
local function _____7ED3_7B97_6DF1_6D77_6DA1_6D41_7206_53D1(context, x, y)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["深海涡流"]
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5361_745F_62C9_97F3_6548_914D_7F6E["深海涡流"]["爆发"], x, y, _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"])
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue7
                end
                local dist = _____8DDD_79BBXY(
                    GetUnitX(hero),
                    GetUnitY(hero),
                    x,
                    y
                )
                if dist > cfg["最大半径"] then
                    goto __continue7
                end
                local t = _____9650_5236_6570_503C(dist / cfg["最大半径"], 0, 1)
                local coeff = cfg["最近伤害系数"] - (cfg["最近伤害系数"] - cfg["最远伤害系数"]) * t
                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["技能ID"] = _____6DF1_6D77_6DA1_6D41_6280_80FDID,
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害公式"] = {["固定值"] = cfg["基础水伤害"] * coeff},
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_COLD,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["标签"] = "卡瑟拉深海涡流"
                })
                _____65BD_52A0_7729_6655(boss, hero, cfg["眩晕秒"])
            end
            ::__continue7::
            i = i + 1
        end
    end
end
____exports["释放卡瑟拉深海涡流"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["深海涡流"]
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5361_745F_62C9_97F3_6548_914D_7F6E["深海涡流"]["形成牵引"], x, y, _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"])
    _____64AD_653E_9650_65F6_6DA1_6D41_7279_6548(context, x, y)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = x,
        Y = y,
        ["半径"] = cfg["最大半径"],
        ["持续时间"] = cfg["爆发延迟秒"],
        ["来源单位"] = boss
    })
    _____5F00_59CB_65B9_5411_62B5_6297_7275_5F15({
        ["名称"] = "卡瑟拉-深海涡流牵引",
        ["目标单位列表"] = heroes,
        ["中心X"] = x,
        ["中心Y"] = y,
        ["持续秒"] = cfg["爆发延迟秒"],
        ["每秒拉力速度"] = cfg["拉力速度"],
        ["抵抗方向角度"] = GetUnitFacing(boss) + 180,
        ["抵抗夹角"] = cfg["抵抗夹角"],
        ["抵抗后拉力倍率"] = cfg["抵抗后拉力倍率"],
        ["清理篮子"] = context["清理"]
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "卡瑟拉-深海涡流",
        ["施法者"] = boss,
        ["硬直秒"] = cfg["爆发延迟秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["恢复动画编号"] = 5,
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = cfg["爆发延迟秒"],
            ["颜色ID"] = cfg["吟唱条颜色ID"],
            ["标题文本"] = cfg["吟唱条标题文本"],
            ["提示文本"] = cfg["吟唱条提示文本"]
        },
        ["清理"] = context["清理"],
        ["播放台词"] = function()
            _____64AD_653E_5361_745F_62C9_53F0_8BCD(boss, "深海涡流")
        end,
        ["on生效"] = function()
            _____7ED3_7B97_6DF1_6D77_6DA1_6D41_7206_53D1(context, x, y)
        end
    })
end
local function ____on_5361_745F_62C9_6DF1_6D77_6DA1_6D41_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6DF1_6D77_6DA1_6D41_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5361_745F_62C9_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放卡瑟拉深海涡流"](context)
end
____exports["注册卡瑟拉深海涡流"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "03．深海涡流",
        ["单位类型ID"] = _____5361_745F_62C9_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6DF1_6D77_6DA1_6D41_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5361_745F_62C9_6DF1_6D77_6DA1_6D41_65BD_6CD5(boss, _____6DF1_6D77_6DA1_6D41_6280_80FDID)
        end
    })
end
return ____exports
