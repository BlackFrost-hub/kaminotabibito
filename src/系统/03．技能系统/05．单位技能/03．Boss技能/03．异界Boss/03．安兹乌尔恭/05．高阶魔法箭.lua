--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建安兹运行时上下文"]
local _____6807_8BB0_5B89_5179_666E_901A_673A_5236_5FD9_788C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["标记安兹普通机制忙碌"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.00．配置")
local _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["安兹乌尔恭单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____08_FF0E_9AD8_9636_4EA1_7075_53EC_5524 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.08．高阶亡灵召唤")
local _____53D6_5B89_5179_4EA1_7075_7BAD_4F24_5BB3_500D_7387 = ____08_FF0E_9AD8_9636_4EA1_7075_53EC_5524["取安兹亡灵箭伤害倍率"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local ____02_FF0E_5206_6279_70B9_540D_843D_70B9_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.05．点名技能模板.02．分批点名落点模板")
local _____5F00_59CB_5206_6279_70B9_540D_843D_70B9_6A21_677F = ____02_FF0E_5206_6279_70B9_540D_843D_70B9_6A21_677F["开始分批点名落点模板"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.12．台词播放")
local _____64AD_653E_5B89_5179_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放安兹台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____require_result_0["计算组合技能伤害"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807 = ____require_result_2["获取Boss技能最高仇恨目标"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_2["获取Boss技能随机敌对英雄"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成AOE技能伤害"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_4.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local EXSetEffectSize = japi.EXSetEffectSize
local _____5B89_5179_5355_4F4D_7C7B_578BID = stringToFourCC(_____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["正式单位ID"])
local _____9AD8_9636_9B54_6CD5_7BAD_6280_80FDID = stringToFourCC(_____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["高阶魔法箭"])
local _____9AD8_9636_9B54_6CD5_7BAD_5DF2_6CE8_518C = false
____exports["高阶魔法箭技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = false,
    ["语义"] = "三轮骸骨魔法箭雨按时间差锁定不同玩家当前位置，鼓励分散与连续移动。"
}
local function _____53D6_4E3B_8981_76EE_6807(boss)
    local entry = _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807(boss)
    if entry ~= nil and _____5355_4F4D_6709_6548(entry.targetRef) then
        return entry.targetRef
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
end
local function _____8BA1_7B97_9AD8_9636_9B54_6CD5_7BAD_4F24_5BB3(context, boss, target)
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["普通技能"]
    return _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(
        boss,
        target,
        {
            ["来源攻击力比例"] = cfg["高阶魔法箭伤害Boss攻击力比例"],
            ["目标最大生命比例"] = cfg["高阶魔法箭伤害目标最大生命比例"],
            ["总倍率"] = _____53D6_5B89_5179_4EA1_7075_7BAD_4F24_5BB3_500D_7387(context)
        }
    )
end
local function _____9AD8_9636_9B54_6CD5_7BAD_7ED3_7B97(context, x, y)
    local boss = context["安兹单位"]
    local ____context__6311_6218_5DF2_7ED3_675F_6 = context["挑战已结束"]
    if not ____context__6311_6218_5DF2_7ED3_675F_6 then
        local ____self_5 = context["清理"]
        ____context__6311_6218_5DF2_7ED3_675F_6 = ____self_5["已清理"](____self_5)
    end
    if ____context__6311_6218_5DF2_7ED3_675F_6 or not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local effect = AddSpecialEffect(cfg["表现资源"]["高阶魔法箭特效路径"], x, y)
    if effect ~= nil and effect ~= 0 then
        EXSetEffectSize(effect, cfg["普通技能"]["高阶魔法箭特效缩放"])
        YDWETimerDestroyEffectSafe(cfg["普通技能"]["高阶魔法箭特效持续秒"], effect)
    end
    local targets = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local radius = cfg["普通技能"]["高阶魔法箭伤害半径"]
    local radiusSquared = radius * radius
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____5355_4F4D_6709_6548(target) then
                    goto __continue9
                end
                local dx = GetUnitX(target) - x
                local dy = GetUnitY(target) - y
                if dx * dx + dy * dy > radiusSquared then
                    goto __continue9
                end
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["技能ID"] = _____9AD8_9636_9B54_6CD5_7BAD_6280_80FDID,
                    ["来源"] = boss,
                    ["目标"] = target,
                    ["伤害"] = _____8BA1_7B97_9AD8_9636_9B54_6CD5_7BAD_4F24_5BB3(context, boss, target),
                    attack = false,
                    ranged = true,
                    attackType = ATTACK_TYPE_MAGIC,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
            end
            ::__continue9::
            i = i + 1
        end
    end
end
local function _____53D6_9AD8_9636_9B54_6CD5_7BAD_76EE_6807_5217_8868(context)
    local boss = context["安兹单位"]
    local ____context__6311_6218_5DF2_7ED3_675F_8 = context["挑战已结束"]
    if not ____context__6311_6218_5DF2_7ED3_675F_8 then
        local ____self_7 = context["清理"]
        ____context__6311_6218_5DF2_7ED3_675F_8 = ____self_7["已清理"](____self_7)
    end
    if ____context__6311_6218_5DF2_7ED3_675F_8 or not _____5355_4F4D_6709_6548(boss) then
        return {}
    end
    local targets = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local primary = _____53D6_4E3B_8981_76EE_6807(boss)
    if #targets <= 0 and _____5355_4F4D_6709_6548(primary) then
        targets[#targets + 1] = primary
    end
    return targets
end
local function _____5B89_6392_9AD8_9636_9B54_6CD5_7BAD_8F6E_6B21(context)
    local boss = context["安兹单位"]
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["普通技能"]
    _____5F00_59CB_5206_6279_70B9_540D_843D_70B9_6A21_677F({
        ["名称"] = "安兹·高阶魔法箭",
        ["清理"] = context["清理"],
        ["轮数"] = cfg["高阶魔法箭轮数"],
        ["轮次间隔秒"] = cfg["高阶魔法箭轮次间隔秒"],
        ["预警秒"] = cfg["高阶魔法箭落点预警秒"],
        ["锁定坐标"] = true,
        ["取目标列表"] = function()
            return _____53D6_9AD8_9636_9B54_6CD5_7BAD_76EE_6807_5217_8868(context)
        end,
        ["提示圈"] = {["类型"] = "敌方圆形", ["半径"] = cfg["高阶魔法箭伤害半径"], ["来源单位"] = boss},
        ["on结算"] = function(_____7ED3_679C)
            _____9AD8_9636_9B54_6CD5_7BAD_7ED3_7B97(context, _____7ED3_679C["锁定X"], _____7ED3_679C["锁定Y"])
        end
    })
end
____exports["释放安兹高阶魔法箭"] = function(context)
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["时间停止中"] or context["当前大型技能"] ~= nil then
        return
    end
    local target = _____53D6_4E3B_8981_76EE_6807(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["高阶魔法箭"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    _____64AD_653E_5B89_5179_53F0_8BCD(boss, "高阶魔法箭")
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["普通技能"]
    _____6807_8BB0_5B89_5179_666E_901A_673A_5236_5FD9_788C(context, cfg["高阶魔法箭施法前摇秒"] + (cfg["高阶魔法箭轮数"] - 1) * cfg["高阶魔法箭轮次间隔秒"] + cfg["高阶魔法箭落点预警秒"])
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标单位"] = target,
        ["硬直秒"] = cfg["高阶魔法箭施法前摇秒"],
        ["动画编号"] = 2,
        ["动画速度"] = 1,
        ["生效前重新面向"] = true,
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = cfg["高阶魔法箭施法前摇秒"],
            ["颜色ID"] = 4,
            ["标题文本"] = "高阶魔法箭",
            ["提示文本"] = "骸骨箭雨将连续锁定落点"
        },
        ["on生效"] = function()
            _____5B89_6392_9AD8_9636_9B54_6CD5_7BAD_8F6E_6B21(context)
        end
    })
end
____exports["注册安兹高阶魔法箭"] = function()
    if _____9AD8_9636_9B54_6CD5_7BAD_5DF2_6CE8_518C then
        return
    end
    _____9AD8_9636_9B54_6CD5_7BAD_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "安兹·高阶魔法箭",
        ["单位类型ID"] = _____5B89_5179_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____9AD8_9636_9B54_6CD5_7BAD_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587,
        ["释放技能"] = function(context)
            ____exports["释放安兹高阶魔法箭"](context)
        end
    })
end
return ____exports
