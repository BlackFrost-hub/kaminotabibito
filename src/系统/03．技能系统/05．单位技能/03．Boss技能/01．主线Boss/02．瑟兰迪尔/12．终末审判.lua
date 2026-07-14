--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_6709_6548, _____8DDD_79BB_5E73_65B9, _____64AD_653E_70B9_7279_6548, _____64AD_653EBoss_84C4_529BTick, _____521B_5EFA_7EC8_672B_5BA1_5224_7206_70B8_7279_6548, _____64AD_653E_7EC8_672B_5BA1_5224_7ED3_7B97_97F3_6548, _____8BA1_7B97_7206_70B8_7279_6548_524D_7F6E_5EF6_8FDF_6BEB_79D2, addDelayedCallback, addPeriodicCallback, removePeriodicCallback, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, YDWETimerDestroyEffectSafe, _____5F00_59CB_786C_76F4, _____663E_793A_5927_62DB_541F_5531_6761, _____5173_95ED_541F_5531_6761, _____521B_5EFA_767D_8272_5706_5F62_63D0_793A_5708, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, Sound3DII_CooPlayReuse, _____9020_6210AOE_6280_80FD_4F24_5BB3, _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B, jass, GetUnitX, GetUnitY, AddSpecialEffect, SetUnitAnimationByIndex, SetUnitTimeScale, R2I, GetUnitState, EXSetEffectSize, UNIT_STATE_MAX_LIFE
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.15．台词播放")
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
function _____8DDD_79BB_5E73_65B9(ax, ay, bx, by)
    local dx = ax - bx
    local dy = ay - by
    return dx * dx + dy * dy
end
function _____64AD_653E_70B9_7279_6548(model, x, y, duration, scale)
    if duration == nil then
        duration = 1
    end
    if scale == nil then
        scale = 1
    end
    local effect = AddSpecialEffect(model, x, y)
    if effect ~= nil and effect ~= 0 then
        if scale ~= 1 then
            EXSetEffectSize(effect, scale)
        end
        YDWETimerDestroyEffectSafe(duration, effect)
    end
end
function _____64AD_653EBoss_84C4_529BTick(boss)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    SetUnitTimeScale(boss, config["蓄力动画速度"])
    SetUnitAnimationByIndex(boss, config["蓄力动画编号"])
    _____64AD_653E_70B9_7279_6548(
        config["蓄力特效"],
        x,
        y,
        0.6,
        config["蓄力法阵缩放"]
    )
    _____64AD_653E_70B9_7279_6548(
        config["法阵叠加特效"],
        x,
        y,
        0.6,
        config["蓄力法阵缩放"]
    )
end
function _____521B_5EFA_7EC8_672B_5BA1_5224_7206_70B8_7279_6548(x, y)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    _____64AD_653E_70B9_7279_6548(config["爆炸特效"], x, y, 2)
    _____64AD_653E_70B9_7279_6548(config["爆炸特效2"], x, y, 2)
    _____64AD_653E_70B9_7279_6548(config["爆炸特效3"], x, y, 2)
end
function _____64AD_653E_7EC8_672B_5BA1_5224_7ED3_7B97_97F3_6548(x, y)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    Sound3DII_CooPlayReuse(
        config["结算主冲击音效"],
        x,
        y,
        0,
        config["结算音效裁断距离"]
    )
    addDelayedCallback(
        config["结算扩散音效延迟毫秒"],
        function()
            Sound3DII_CooPlayReuse(
                config["结算扩散音效"],
                x,
                y,
                0,
                config["结算音效裁断距离"]
            )
        end
    )
end
function _____8BA1_7B97_7206_70B8_7279_6548_524D_7F6E_5EF6_8FDF_6BEB_79D2()
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    local delayMs = R2I(config["爆炸延迟秒"] * 1000) - config["爆炸特效提前毫秒"]
    if delayMs < 0 then
        return 0
    end
    return delayMs
end
____exports["释放瑟兰迪尔终末审判"] = function(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local _____6280_80FD_5B9E_4F8BID = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["来源类型"] = "Boss技能", ["标签"] = "瑟兰迪尔终末审判", ["持续时间秒"] = config["引导秒"] + config["爆炸延迟秒"] + 2})
    _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(boss, "终末审判")
    _____5F00_59CB_786C_76F4(boss, config["引导秒"])
    _____663E_793A_5927_62DB_541F_5531_6761({["总时长"] = config["引导秒"], ["颜色ID"] = config["吟唱条颜色ID"], ["标题文本"] = config["吟唱条标题文本"], ["提示文本"] = config["吟唱条提示文本"]})
    _____64AD_653EBoss_84C4_529BTick(boss)
    local _____84C4_529BTickID
    _____84C4_529BTickID = addPeriodicCallback(
        config["蓄力Tick毫秒"],
        function()
            if not _____5355_4F4D_6709_6548(boss) then
                removePeriodicCallback(_____84C4_529BTickID)
                _____5173_95ED_541F_5531_6761("大招")
                return
            end
            _____64AD_653EBoss_84C4_529BTick(boss)
        end
    )
    addDelayedCallback(
        R2I(config["引导秒"] * 1000),
        function()
            removePeriodicCallback(_____84C4_529BTickID)
            _____5173_95ED_541F_5531_6761("大招")
            if not _____5355_4F4D_6709_6548(boss) then
                return
            end
            SetUnitTimeScale(boss, config["结算动画速度"])
            SetUnitAnimationByIndex(boss, config["结算动画编号"])
            local bossX = GetUnitX(boss)
            local bossY = GetUnitY(boss)
            _____64AD_653E_70B9_7279_6548(
                config["蓄力完成特效"],
                bossX,
                bossY,
                2,
                config["蓄力完成冲击缩放"]
            )
            _____64AD_653E_70B9_7279_6548(
                config["警示特效"],
                bossX,
                bossY,
                config["爆炸延迟秒"] + 0.5,
                config["场地法阵缩放"]
            )
            _____64AD_653E_70B9_7279_6548(
                config["法阵叠加特效"],
                bossX,
                bossY,
                config["爆炸延迟秒"] + 0.5,
                config["场地法阵缩放"]
            )
            _____521B_5EFA_767D_8272_5706_5F62_63D0_793A_5708(bossX, bossY, config["安全区半径"], config["爆炸延迟秒"] + 0.5)
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            local xs = {}
            local ys = {}
            local targets = {}
            do
                local i = 0
                while i < #heroes do
                    local target = heroes[i + 1]
                    xs[#xs + 1] = GetUnitX(target)
                    ys[#ys + 1] = GetUnitY(target)
                    targets[#targets + 1] = target
                    i = i + 1
                end
            end
            addDelayedCallback(
                config["恢复动作延迟Ms"],
                function()
                    if not _____5355_4F4D_6709_6548(boss) then
                        return
                    end
                    SetUnitTimeScale(boss, config["恢复动画速度"])
                    SetUnitAnimationByIndex(boss, config["恢复动画编号"])
                end
            )
            addDelayedCallback(
                _____8BA1_7B97_7206_70B8_7279_6548_524D_7F6E_5EF6_8FDF_6BEB_79D2(),
                function()
                    if not _____5355_4F4D_6709_6548(boss) then
                        return
                    end
                    do
                        local i = 0
                        while i < #targets do
                            do
                                if not _____5355_4F4D_6709_6548(targets[i + 1]) then
                                    goto __continue28
                                end
                                _____521B_5EFA_7EC8_672B_5BA1_5224_7206_70B8_7279_6548(xs[i + 1], ys[i + 1])
                            end
                            ::__continue28::
                            i = i + 1
                        end
                    end
                end
            )
            addDelayedCallback(
                R2I(config["爆炸延迟秒"] * 1000),
                function()
                    if not _____5355_4F4D_6709_6548(boss) then
                        return
                    end
                    local bossX = GetUnitX(boss)
                    local bossY = GetUnitY(boss)
                    _____64AD_653E_7EC8_672B_5BA1_5224_7ED3_7B97_97F3_6548(bossX, bossY)
                    local safeRadius2 = config["安全区半径"] * config["安全区半径"]
                    do
                        local i = 0
                        while i < #targets do
                            do
                                local target = targets[i + 1]
                                if not _____5355_4F4D_6709_6548(target) then
                                    goto __continue33
                                end
                                if _____8DDD_79BB_5E73_65B9(
                                    GetUnitX(target),
                                    GetUnitY(target),
                                    bossX,
                                    bossY
                                ) > safeRadius2 then
                                    local damage = (_____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * config["爆炸伤害Boss攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["爆炸伤害目标最大生命比例"]) * config["爆炸伤害总倍率"]
                                    _____9020_6210AOE_6280_80FD_4F24_5BB3({
                                        ["来源"] = boss,
                                        ["目标"] = target,
                                        ["伤害"] = damage,
                                        attack = false,
                                        ranged = false,
                                        attackType = jass.ATTACK_TYPE_NORMAL,
                                        ["伤害类型"] = jass.DAMAGE_TYPE_MAGIC,
                                        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
                                        ["来源类型"] = "Boss技能",
                                        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                                        ["标签"] = "瑟兰迪尔终末审判"
                                    })
                                end
                            end
                            ::__continue33::
                            i = i + 1
                        end
                    end
                end
            )
        end
    )
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
addDelayedCallback = ____require_result_0.addDelayedCallback
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDWETimerDestroyEffectSafe = ____require_result_2.YDWETimerDestroyEffectSafe
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____5F00_59CB_786C_76F4 = ____require_result_3["开始硬直"]
local ____require_result_4 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
_____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_4["显示大招吟唱条"]
_____5173_95ED_541F_5531_6761 = ____require_result_4["关闭吟唱条"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
_____521B_5EFA_767D_8272_5706_5F62_63D0_793A_5708 = ____require_result_5["创建白色圆形提示圈"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
local ____require_result_7 = require("lib.扩展函数.封装函数.02．音效系统.index")
Sound3DII_CooPlayReuse = ____require_result_7.Sound3DII_CooPlayReuse
local ____require_result_8 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_8["造成AOE技能伤害"]
_____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_8["创建独立技能伤害实例"]
jass = require("jass.common")
local japi = require("jass.japi")
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
AddSpecialEffect = jass.AddSpecialEffect
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitTimeScale = jass.SetUnitTimeScale
R2I = jass.R2I
GetUnitState = jass.GetUnitState
EXSetEffectSize = japi.EXSetEffectSize
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
____exports["尝试触发瑟兰迪尔终末审判"] = function(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    local now = getServerTime()
    if context["上次终末审判Ms"] > 0 and now - context["上次终末审判Ms"] < config["周期秒"] * 1000 then
        return
    end
    context["上次终末审判Ms"] = now
    ____exports["释放瑟兰迪尔终末审判"](context)
end
____exports["注册瑟兰迪尔终末审判"] = function()
end
return ____exports
