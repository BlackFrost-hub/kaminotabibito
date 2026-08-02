--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____542F_52A8_5F8B_6CD5_94FE_8DEF, _____6267_884C_745F_5170_8FEA_5C14_5F8B_6CD5_53EC_5524, ____on_745F_5170_8FEA_5C14_5F8B_6CD5_53EC_5524_751F_6548, _____521B_5EFA_53EC_5524_7269, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____542F_52A8_72EC_5360_5355_4F4D_8FDE_63A5, _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, Sound3DII_CooPlayReuse, jass, GetUnitStateJapi, GetUnitTypeId, GetUnitX, GetUnitY, Cos, Sin, UNIT_STATE_MAX_LIFE, _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID, _____5F8B_6CD5_53EC_5524_6280_80FDID, bj_DEGTORAD
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建瑟兰迪尔上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.00．配置")
local _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["瑟兰迪尔单位技能配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.15．台词播放")
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____63D0_4EA4_9884_8BA1_7B97Boss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["提交预计算Boss单体技能伤害"]
function _____542F_52A8_5F8B_6CD5_94FE_8DEF(boss, summon, _____5DF2_8FDE_63A5_76EE_6807)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["律法召唤"]
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * config["链接伤害Boss攻击力比例"]
    _____542F_52A8_72EC_5360_5355_4F4D_8FDE_63A5({
        ["来源单位"] = boss,
        ["连接单位"] = summon,
        ["候选目标列表"] = function()
            return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
        end,
        ["已占用目标"] = _____5DF2_8FDE_63A5_76EE_6807,
        ["持续秒"] = config["持续秒"],
        ["重试间隔秒"] = config["链接重试间隔秒"],
        ["连接半径"] = config["链接半径"],
        ["闪电类型"] = config["闪电类型"],
        ["闪电起点高度偏移"] = config["闪电起点高度偏移"],
        ["闪电终点高度偏移"] = config["闪电终点高度偏移"],
        ["闪电颜色"] = config["闪电颜色"],
        ["Tick间隔秒"] = config["链接伤害间隔秒"],
        ["on距离超出"] = function(source, _connector, target)
            if not _____5355_4F4D_6709_6548(source) or not _____5355_4F4D_6709_6548(target) then
                return
            end
            Sound3DII_CooPlayReuse(
                config["链接惩罚音效"],
                GetUnitX(target),
                GetUnitY(target),
                0,
                config["链接惩罚音效裁断距离"]
            )
            _____63D0_4EA4_9884_8BA1_7B97Boss_5355_4F53_6280_80FD_4F24_5BB3({
                ["技能ID"] = _____5F8B_6CD5_53EC_5524_6280_80FDID,
                ["来源"] = boss,
                ["目标"] = target,
                ["伤害"] = damage,
                attack = false,
                ranged = false,
                attackType = jass.ATTACK_TYPE_NORMAL,
                ["伤害类型"] = jass.DAMAGE_TYPE_MIND,
                weaponType = jass.WEAPON_TYPE_WHOKNOWS
            })
        end
    })
end
function _____6267_884C_745F_5170_8FEA_5C14_5F8B_6CD5_53EC_5524(boss)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["律法召唤"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local playerCount = _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570()
    local count = playerCount <= 1 and config["数量单人"] or config["数量多人"]
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    local hp = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * config["生命倍率"]
    local _____5DF2_8FDE_63A5_76EE_6807 = {}
    do
        local i = 0
        while i < count do
            local angle = 360 / count * i * bj_DEGTORAD
            local summon = _____521B_5EFA_53EC_5524_7269({
                ["主人单位"] = boss,
                ["单位类型"] = config["单位类型"],
                ["单位名称"] = config["单位名称"],
                ["模型文件"] = config["模型文件"],
                X = bossX + Cos(angle) * 360,
                Y = bossY + Sin(angle) * 360,
                ["持续时间"] = config["持续秒"],
                ["生命值"] = hp,
                ["护甲"] = config["护甲"],
                ["攻击范围"] = config["攻击范围"],
                ["普攻弹道模型"] = config["普攻弹道模型"],
                ["普攻弹道弧度"] = config["普攻弹道弧度"],
                ["普攻弹道速度"] = config["普攻弹道速度"],
                ["索敌范围"] = 900,
                ["飞行高度"] = 10
            })
            if _____5355_4F4D_6709_6548(summon) then
                _____542F_52A8_5F8B_6CD5_94FE_8DEF(boss, summon, _____5DF2_8FDE_63A5_76EE_6807)
            end
            i = i + 1
        end
    end
end
____exports["释放瑟兰迪尔律法召唤"] = function(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["律法召唤"]
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["硬直秒"] = config["施法硬直秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["施法动画速度"],
        ["重播动作延迟毫秒"] = 30,
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["施法硬直秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(boss, "律法召唤")
        end,
        ["on生效"] = function()
            _____6267_884C_745F_5170_8FEA_5C14_5F8B_6CD5_53EC_5524(boss)
        end
    })
end
function ____on_745F_5170_8FEA_5C14_5F8B_6CD5_53EC_5524_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____5F8B_6CD5_53EC_5524_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放瑟兰迪尔律法召唤"](context)
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
_____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_2["启动基础施法时间线"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.独占单位连接")
_____542F_52A8_72EC_5360_5355_4F4D_8FDE_63A5 = ____require_result_3["启动独占单位连接"]
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
_____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_4["取当前有效玩家人数"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local ____require_result_6 = require("lib.扩展函数.封装函数.02．音效系统.index")
Sound3DII_CooPlayReuse = ____require_result_6.Sound3DII_CooPlayReuse
jass = require("jass.common")
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
Cos = jass.Cos
Sin = jass.Sin
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
_____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____5F8B_6CD5_53EC_5524_6280_80FDID = stringToFourCC(_____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["律法召唤"]["技能槽位"])
local _____5F8B_6CD5_53EC_5524_5DF2_6CE8_518C = false
bj_DEGTORAD = jass.bj_DEGTORAD
____exports["注册瑟兰迪尔律法召唤"] = function()
    if _____5F8B_6CD5_53EC_5524_5DF2_6CE8_518C then
        return
    end
    _____5F8B_6CD5_53EC_5524_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "瑟兰迪尔律法召唤",
        ["单位类型ID"] = _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____5F8B_6CD5_53EC_5524_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_745F_5170_8FEA_5C14_5F8B_6CD5_53EC_5524_751F_6548(boss, _____5F8B_6CD5_53EC_5524_6280_80FDID)
        end
    })
end
return ____exports
