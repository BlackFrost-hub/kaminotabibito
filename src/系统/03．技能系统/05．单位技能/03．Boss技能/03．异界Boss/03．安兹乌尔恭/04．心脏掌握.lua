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
local _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹模型动画配置"]
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.12．台词播放")
local _____64AD_653E_5B89_5179_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放安兹台词"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local GetRandomInt = jass.GetRandomInt
local IsUnitType = jass.IsUnitType
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local KillUnit = jass.KillUnit
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____5B89_5179_5355_4F4D_7C7B_578BID = stringToFourCC(_____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["正式单位ID"])
local _____5FC3_810F_638C_63E1_6280_80FDID = stringToFourCC(_____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["心脏掌握"])
local _____5FC3_810F_638C_63E1_6297_6027_5230_671FMs_8868 = {}
local _____5FC3_810F_638C_63E1_5DF2_6CE8_518C = false
local function _____9500_6BC1_5FC3_810F_638C_63E1_8868_73B0(instance)
    if instance["点名特效"] ~= nil and instance["点名特效"] ~= 0 then
        DestroyEffect(instance["点名特效"])
        instance["点名特效"] = 0
    end
    if instance["倒计时特效"] ~= nil and instance["倒计时特效"] ~= 0 then
        DestroyEffect(instance["倒计时特效"])
        instance["倒计时特效"] = 0
    end
end
local function _____53D6_5FC3_810F_638C_63E1_76EE_6807(boss)
    local now = getServerTime()
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local eligible = {}
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue7
                end
                local ____until = _____5FC3_810F_638C_63E1_6297_6027_5230_671FMs_8868[GetHandleId(hero)] or 0
                if ____until <= now then
                    eligible[#eligible + 1] = hero
                end
            end
            ::__continue7::
            i = i + 1
        end
    end
    if #eligible == 0 then
        return nil
    end
    return eligible[GetRandomInt(0, #eligible - 1) + 1]
end
local function _____7EDF_8BA1_6551_63F4_961F_53CB(boss, target, radius)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local x = GetUnitX(target)
    local y = GetUnitY(target)
    local radius2 = radius * radius
    local count = 0
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) or hero == target then
                    goto __continue13
                end
                local dx = GetUnitX(hero) - x
                local dy = GetUnitY(hero) - y
                if dx * dx + dy * dy <= radius2 then
                    count = count + 1
                end
            end
            ::__continue13::
            i = i + 1
        end
    end
    return count
end
local function _____7ED3_7B97_5FC3_810F_638C_63E1(instance)
    if instance["已结算"] then
        return
    end
    instance["已结算"] = true
    _____9500_6BC1_5FC3_810F_638C_63E1_8868_73B0(instance)
    local context = instance.context
    local boss = context["安兹单位"]
    local target = instance.target
    if context["挑战已结束"] or not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local rescuers = _____7EDF_8BA1_6551_63F4_961F_53CB(boss, target, config["普通技能"]["心脏掌握救援半径"])
    if rescuers >= config["普通技能"]["心脏掌握所需队友数"] then
        _____5FC3_810F_638C_63E1_6297_6027_5230_671FMs_8868[GetHandleId(target)] = getServerTime() + config["普通技能"]["心脏掌握破解抗性秒"] * 1000
        return
    end
    local effect = AddSpecialEffectTarget(config["表现资源"]["心脏掌握处决特效路径"], target, "chest")
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(config["普通技能"]["心脏掌握处决特效持续秒"], effect)
    end
    KillUnit(target)
end
local function _____521B_5EFA_5FC3_810F_638C_63E1_5012_8BA1_65F6(context, target)
    local config = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local instance = {
        context = context,
        target = target,
        ["点名特效"] = AddSpecialEffectTarget(config["表现资源"]["心脏掌握点名特效路径"], target, "chest"),
        ["倒计时特效"] = AddSpecialEffectTarget(config["表现资源"]["心脏掌握倒计时特效路径"], target, "overhead"),
        ["已结算"] = false
    }
    local ____self_4 = context["清理"]
    ____self_4["登记清理"](
        ____self_4,
        "安兹-心脏掌握表现",
        function()
            instance["已结算"] = true
            _____9500_6BC1_5FC3_810F_638C_63E1_8868_73B0(instance)
        end
    )
    local callbackId = addDelayedCallback(
        config["普通技能"]["心脏掌握倒计时秒"] * 1000,
        function()
            _____7ED3_7B97_5FC3_810F_638C_63E1(instance)
        end
    )
    local ____self_5 = context["清理"]
    ____self_5["登记延迟回调"](____self_5, "安兹-心脏掌握倒计时", callbackId)
end
____exports["释放安兹心脏掌握"] = function(context)
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return
    end
    local target = _____53D6_5FC3_810F_638C_63E1_76EE_6807(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    _____64AD_653E_5B89_5179_53F0_8BCD(boss, "心脏掌握")
    local config = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["普通技能"]
    _____6807_8BB0_5B89_5179_666E_901A_673A_5236_5FD9_788C(context, config["心脏掌握施法硬直秒"] + config["心脏掌握倒计时秒"])
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标单位"] = target,
        ["硬直秒"] = config["心脏掌握施法硬直秒"],
        ["动画编号"] = config["心脏掌握动画编号"],
        ["动画速度"] = config["心脏掌握动画速度"],
        ["恢复动画编号"] = _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E["待机编号"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["心脏掌握施法硬直秒"],
            ["颜色ID"] = 4,
            ["标题文本"] = "心脏掌握",
            ["提示文本"] = "靠近被点名队友，共同破解死亡处决"
        },
        ["on生效"] = function()
            _____521B_5EFA_5FC3_810F_638C_63E1_5012_8BA1_65F6(context, target)
        end
    })
end
____exports["注册安兹心脏掌握"] = function()
    if _____5FC3_810F_638C_63E1_5DF2_6CE8_518C then
        return
    end
    _____5FC3_810F_638C_63E1_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "安兹·心脏掌握",
        ["单位类型ID"] = _____5B89_5179_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____5FC3_810F_638C_63E1_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587,
        ["释放技能"] = function(context)
            ____exports["释放安兹心脏掌握"](context)
        end
    })
end
____exports["心脏掌握技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "单体",
    ["包含战斗自身位移"] = false,
    ["语义"] = "点名玩家并显示死亡倒计时，通过团队救援或灵魂锁机制破解，不允许无预警随机秒杀。"
}
return ____exports
