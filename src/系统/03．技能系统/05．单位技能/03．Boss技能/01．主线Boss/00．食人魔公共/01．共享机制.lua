local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6 = ____01_FF0E_63A7_5236_4E0EBuff["单位是否处于硬控制效果合集"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____03_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.00．食人魔公共.03．台词播放")
local _____64AD_653E_98DF_4EBA_9B54_516C_5171_53F0_8BCD = ____03_FF0E_53F0_8BCD_64AD_653E["播放食人魔公共台词"]
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local _____662F_5426_5DF2_767B_8BB0Boss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_3["是否已登记Boss技能测试目标"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local getGameDifficulty = ____require_result_4.getGameDifficulty
local addDelayedCallback = ____require_result_4.addDelayedCallback
local removeDelayedCallback = ____require_result_4.removeDelayedCallback
local addPeriodicCallback = ____require_result_4.addPeriodicCallback
local removePeriodicCallback = ____require_result_4.removePeriodicCallback
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_5["暂停并设置无敌安全"]
local _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_5["解除暂停并取消无敌安全"]
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_6.EC_CreateEffect
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码")
local _____95EA_7535_6548_679C_4EE3_7801 = ____require_result_7["闪电效果代码"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电")
local _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_8["创建单位绑定闪电"]
local _____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_8["销毁单位绑定闪电"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.方向抵抗牵引")
local _____5F00_59CB_65B9_5411_62B5_6297_7275_5F15 = ____require_result_9["开始方向抵抗牵引"]
local ____require_result_10 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_10["显示大招吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_10["关闭吟唱条"]
local ____require_result_11 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_11.debugLogForce
local ____require_result_12 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_12.Sound3DII_CooPlayReuse
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitTypeId = jass.GetUnitTypeId
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitAnimation = jass.SetUnitAnimation
local GetUnitStateJapi = japi.GetUnitState
local UnitResetCooldown = jass.UnitResetCooldown
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____666E_901A_98DF_4EBA_9B54ID = stringToFourCCSafe("N05J")
local _____6740_622E_98DF_4EBA_9B54ID = stringToFourCCSafe("N05K")
local _____5543_98DF_65E0_654C_6765_6E90 = "食人魔-击杀啃食"
local _____96F7_9706_9707_6012_65E0_654C_6765_6E90 = "食人魔-雷霆震怒"
local _____96F7_9706_9707_6012_97F3_6548_88C1_65AD_8DDD_79BB = 2800
local _____98DF_4EBA_9B54_5171_4EAB_673A_5236_5DF2_6CE8_518C = false
local _____5543_98DF_72B6_6001_8868 = {}
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and not IsUnitType(unit, UNIT_TYPE_DEAD) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____53D6_53E5_67C4ID(handle)
    return handle ~= nil and handle ~= 0 and GetHandleId(handle) or 0
end
local function _____521B_5EFA_98DF_4EBA_9B54_96F7_9706_9707_6012_8D77_624B_95EA_7535(boss, _____6301_7EED_79D2)
    local targets = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local _____95EA_7535_53E5_67C4_5217_8868 = {}
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____5355_4F4D_5B58_6D3B(target) then
                    goto __continue6
                end
                local lightning = _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535({
                    ["效果代码"] = _____95EA_7535_6548_679C_4EE3_7801["灵魂锁链"],
                    ["起点单位"] = boss,
                    ["终点单位"] = target,
                    ["持续时间"] = _____6301_7EED_79D2,
                    ["起点高度偏移"] = 80,
                    ["终点高度偏移"] = 80,
                    ["任一死亡时销毁"] = true
                })
                if lightning ~= nil and lightning ~= 0 then
                    _____95EA_7535_53E5_67C4_5217_8868[#_____95EA_7535_53E5_67C4_5217_8868 + 1] = lightning
                end
            end
            ::__continue6::
            i = i + 1
        end
    end
    return _____95EA_7535_53E5_67C4_5217_8868
end
local function _____9500_6BC1_98DF_4EBA_9B54_96F7_9706_9707_6012_8D77_624B_95EA_7535(data)
    do
        local i = 0
        while i < #data["起手闪电句柄列表"] do
            _____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535(data["起手闪电句柄列表"][i + 1])
            i = i + 1
        end
    end
    data["起手闪电句柄列表"] = {}
end
local function _____6E05_7406_5543_98DF_72B6_6001(_____72B6_6001)
    if _____72B6_6001["完成回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["完成回调ID"])
        _____72B6_6001["完成回调ID"] = 0
    end
    if _____72B6_6001["周期ID"] ~= 0 then
        removePeriodicCallback(_____72B6_6001["周期ID"])
        _____72B6_6001["周期ID"] = 0
    end
    __TS__Delete(
        _____5543_98DF_72B6_6001_8868,
        _____53D6_53E5_67C4ID(_____72B6_6001["Boss单位"])
    )
end
local function ____on_5543_98DF_5B8C_6210(variable)
    local data = variable
    if data == nil then
        debugLogForce("食人魔-共享机制", "啃食完成回调跳过：数据为空")
        return
    end
    if not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) then
        debugLogForce(
            "食人魔-共享机制",
            "啃食完成回调跳过：Boss已失效",
            "bossHid=",
            _____53D6_53E5_67C4ID(data["Boss单位"])
        )
        _____6E05_7406_5543_98DF_72B6_6001(data)
        return
    end
    local boss = data["Boss单位"]
    _____6E05_7406_5543_98DF_72B6_6001(data)
    local maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE)
    local maxMana = GetUnitStateJapi(boss, UNIT_STATE_MAX_MANA)
    UnitResetCooldown(boss)
    local _____89E3_9664_65E0_654C_6210_529F = _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(boss, _____5543_98DF_65E0_654C_6765_6E90)
    SetUnitState(boss, UNIT_STATE_LIFE, maxLife)
    SetUnitState(boss, UNIT_STATE_MANA, maxMana)
    debugLogForce(
        "食人魔-共享机制",
        "啃食完成：恢复生命魔法并重置冷却",
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "解除无敌成功=",
        _____89E3_9664_65E0_654C_6210_529F,
        "lifeAfterRestore=",
        GetUnitState(boss, UNIT_STATE_LIFE),
        "maxLife=",
        maxLife,
        "manaAfterRestore=",
        GetUnitState(boss, UNIT_STATE_MANA),
        "maxMana=",
        maxMana
    )
end
local function _____4E2D_65AD_5543_98DF(_____72B6_6001)
    local boss = _____72B6_6001["Boss单位"]
    _____6E05_7406_5543_98DF_72B6_6001(_____72B6_6001)
    if _____5355_4F4D_5B58_6D3B(boss) then
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(boss, _____5543_98DF_65E0_654C_6765_6E90)
    end
    _____64AD_653E_98DF_4EBA_9B54_516C_5171_53F0_8BCD(boss, "击杀啃食被打断")
    debugLogForce(
        "食人魔-共享机制",
        "击杀啃食被硬控制打断",
        "bossHid=",
        _____53D6_53E5_67C4ID(boss)
    )
end
local function ____on_5543_98DF_63A7_5236_6253_65AD_68C0_67E5(variable)
    local data = variable
    if data == nil or not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) then
        return
    end
    if not _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6(data["Boss单位"]) then
        return
    end
    _____4E2D_65AD_5543_98DF(data)
end
local function ____on_98DF_4EBA_9B54_51FB_6740(dyingUnit, killingUnit)
    if not _____5355_4F4D_5B58_6D3B(killingUnit) then
        return
    end
    local killerType = GetUnitTypeId(killingUnit)
    if killerType ~= _____666E_901A_98DF_4EBA_9B54ID and killerType ~= _____6740_622E_98DF_4EBA_9B54ID then
        return
    end
    local owner = GetOwningPlayer(dyingUnit)
    local _____662F_73A9_5BB6_82F1_96C4 = owner ~= nil and owner ~= 0 and getRegisteredPlayerHero(owner) == dyingUnit
    local _____662F_6D4B_8BD5_76EE_6807 = _____662F_5426_5DF2_767B_8BB0Boss_6280_80FD_6D4B_8BD5_76EE_6807(dyingUnit)
    if not _____662F_73A9_5BB6_82F1_96C4 and not _____662F_6D4B_8BD5_76EE_6807 then
        debugLogForce(
            "食人魔-共享机制",
            "击杀啃食忽略：目标不是玩家英雄或测试目标",
            "bossHid=",
            _____53D6_53E5_67C4ID(killingUnit),
            "targetHid=",
            _____53D6_53E5_67C4ID(dyingUnit),
            "killerType=",
            killerType
        )
        return
    end
    local difficulty = getGameDifficulty() > 0 and getGameDifficulty() or 1
    local duration = 2.6 - difficulty * 0.2
    local bossId = _____53D6_53E5_67C4ID(killingUnit)
    local _____65E7_72B6_6001 = _____5543_98DF_72B6_6001_8868[bossId]
    if _____65E7_72B6_6001 ~= nil then
        _____6E05_7406_5543_98DF_72B6_6001(_____65E7_72B6_6001)
    end
    _____5F00_59CB_786C_76F4(killingUnit, duration)
    local _____6682_505C_65E0_654C_6210_529F = _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(killingUnit, _____5543_98DF_65E0_654C_6765_6E90)
    local _____5543_98DF_52A8_753B_7F16_53F7 = killerType == _____666E_901A_98DF_4EBA_9B54ID and 3 or 11
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = killingUnit, ["动画编号"] = _____5543_98DF_52A8_753B_7F16_53F7, ["持续秒"] = duration, ["恢复动画编号"] = 1})
    EC_CreateEffect(
        "Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl",
        GetUnitX(killingUnit),
        GetUnitY(killingUnit),
        0,
        270,
        1,
        1,
        duration
    )
    _____64AD_653E_98DF_4EBA_9B54_516C_5171_53F0_8BCD(killingUnit, "击杀啃食")
    local _____72B6_6001 = {["Boss单位"] = killingUnit, ["完成回调ID"] = 0, ["周期ID"] = 0}
    _____72B6_6001["完成回调ID"] = addDelayedCallback(duration * 1000, ____on_5543_98DF_5B8C_6210, _____72B6_6001)
    _____72B6_6001["周期ID"] = addPeriodicCallback(250, ____on_5543_98DF_63A7_5236_6253_65AD_68C0_67E5, _____72B6_6001)
    _____5543_98DF_72B6_6001_8868[bossId] = _____72B6_6001
    debugLogForce(
        "食人魔-共享机制",
        "击杀啃食开始",
        "bossHid=",
        _____53D6_53E5_67C4ID(killingUnit),
        "targetHid=",
        _____53D6_53E5_67C4ID(dyingUnit),
        "difficulty=",
        difficulty,
        "duration=",
        duration,
        "动画编号=",
        _____5543_98DF_52A8_753B_7F16_53F7,
        "是玩家英雄=",
        _____662F_73A9_5BB6_82F1_96C4,
        "是测试目标=",
        _____662F_6D4B_8BD5_76EE_6807,
        "暂停无敌成功=",
        _____6682_505C_65E0_654C_6210_529F,
        "完成回调ID=",
        _____72B6_6001["完成回调ID"]
    )
end
local function _____83B7_53D6_96F7_9706_9707_6012_7275_5F15_76EE_6807(data)
    return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(data["Boss单位"])
end
local function _____8FC7_6EE4_96F7_9706_9707_6012_7275_5F15_76EE_6807(data, target)
    if not _____5355_4F4D_5B58_6D3B(target) or not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) then
        return false
    end
    local dx = GetUnitX(data["Boss单位"]) - GetUnitX(target)
    local dy = GetUnitY(data["Boss单位"]) - GetUnitY(target)
    return dx * dx + dy * dy <= data["配置"]["牵引范围"] * data["配置"]["牵引范围"]
end
local function ____on_96F7_9706_9707_6012_5F00_59CB_7275_5F15(variable)
    local data = variable
    if data == nil or not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) then
        return
    end
    data["牵引控制器"] = _____5F00_59CB_65B9_5411_62B5_6297_7275_5F15({
        ["名称"] = "食人魔-雷霆震怒",
        ["目标单位列表"] = {},
        ["目标单位提供器"] = function()
            return _____83B7_53D6_96F7_9706_9707_6012_7275_5F15_76EE_6807(data)
        end,
        ["中心单位"] = data["Boss单位"],
        ["持续秒"] = data["配置"]["牵引间隔秒"] * (data["配置"]["牵引次数"] + 1),
        ["每秒拉力速度"] = data["配置"]["每次牵引距离"] / data["配置"]["牵引间隔秒"],
        ["抵抗方向角度"] = 0,
        ["启用方向抵抗"] = false,
        ["Tick毫秒"] = data["配置"]["牵引间隔秒"] * 1000,
        ["最大执行次数"] = data["配置"]["牵引次数"],
        ["到达距离"] = 0,
        ["过滤单位"] = function(target)
            return _____8FC7_6EE4_96F7_9706_9707_6012_7275_5F15_76EE_6807(data, target)
        end
    })
end
local function ____on_96F7_9706_9707_6012_7ED3_7B97(variable)
    local data = variable
    if data == nil or not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) then
        return
    end
    local boss = data["Boss单位"]
    local cfg = data["配置"]
    if data["无敌尚未恢复"] then
        data["无敌尚未恢复"] = false
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(boss, _____96F7_9706_9707_6012_65E0_654C_6765_6E90)
    end
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["敲击动画编号"], ["持续秒"] = 1, ["恢复动画编号"] = 1})
    EC_CreateEffect(
        cfg["牵引结束特效"],
        GetUnitX(boss),
        GetUnitY(boss),
        50,
        270,
        4,
        1,
        2
    )
    local centers = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local bx = GetUnitX(boss)
    local by = GetUnitY(boss)
    local selectSquared = cfg["爆心筛选范围"] * cfg["爆心筛选范围"]
    local hitSquared = cfg["爆心范围"] * cfg["爆心范围"]
    do
        local i = 0
        while i < #centers do
            do
                local center = centers[i + 1]
                if not _____5355_4F4D_5B58_6D3B(center) then
                    goto __continue39
                end
                local cdx = GetUnitX(center) - bx
                local cdy = GetUnitY(center) - by
                if cdx * cdx + cdy * cdy > selectSquared then
                    goto __continue39
                end
                local cx = GetUnitX(center)
                local cy = GetUnitY(center)
                EC_CreateEffect(
                    cfg["结算附加特效"],
                    cx,
                    cy,
                    50,
                    270,
                    1.4,
                    1,
                    2
                )
                EC_CreateEffect(
                    cfg["结算特效"],
                    cx,
                    cy,
                    50,
                    270,
                    2,
                    1,
                    2
                )
                do
                    local j = 0
                    while j < #centers do
                        do
                            local target = centers[j + 1]
                            if not _____5355_4F4D_5B58_6D3B(target) then
                                goto __continue43
                            end
                            local dx = GetUnitX(target) - cx
                            local dy = GetUnitY(target) - cy
                            if dx * dx + dy * dy > hitSquared then
                                goto __continue43
                            end
                            _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                                ["来源"] = boss,
                                ["目标"] = target,
                                ["伤害公式"] = {["来源攻击力比例"] = cfg["攻击力比例"], ["目标最大生命比例"] = cfg["目标最大生命比例"]},
                                attack = true,
                                ranged = false,
                                attackType = ATTACK_TYPE_NORMAL,
                                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                                weaponType = WEAPON_TYPE_WHOKNOWS,
                                ["标签"] = "食人魔·雷霆震怒"
                            })
                        end
                        ::__continue43::
                        j = j + 1
                    end
                end
            end
            ::__continue39::
            i = i + 1
        end
    end
end
local function ____on_96F7_9706_9707_6012_786C_76F4_7ED3_675F(variable)
    local data = variable
    if data == nil then
        return
    end
    if data["牵引控制器"] ~= nil then
        data["牵引控制器"]["停止"]()
    end
    data["牵引控制器"] = nil
    if data["无敌尚未恢复"] then
        data["无敌尚未恢复"] = false
        if _____5355_4F4D_5B58_6D3B(data["Boss单位"]) then
            _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(data["Boss单位"], _____96F7_9706_9707_6012_65E0_654C_6765_6E90)
        end
    end
    _____9500_6BC1_98DF_4EBA_9B54_96F7_9706_9707_6012_8D77_624B_95EA_7535(data)
    _____5173_95ED_541F_5531_6761("大招")
end
____exports["施放食人魔雷霆震怒"] = function(boss, _____914D_7F6E)
    if not _____5355_4F4D_5B58_6D3B(boss) then
        return false
    end
    _____5F00_59CB_786C_76F4(boss, _____914D_7F6E["总硬直秒"])
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(boss, _____96F7_9706_9707_6012_65E0_654C_6765_6E90)
    if _____914D_7F6E["起手音效路径"] ~= nil and _____914D_7F6E["起手音效路径"] ~= "" then
        Sound3DII_CooPlayReuse(
            _____914D_7F6E["起手音效路径"],
            GetUnitX(boss),
            GetUnitY(boss),
            0,
            _____96F7_9706_9707_6012_97F3_6548_88C1_65AD_8DDD_79BB
        )
    end
    _____663E_793A_5927_62DB_541F_5531_6761({
        ["通道"] = "大招",
        ["总时长"] = _____914D_7F6E["总硬直秒"],
        ["颜色ID"] = 3,
        ["标题文本"] = "雷霆震怒",
        ["提示文本"] = "远离重叠爆心"
    })
    if _____914D_7F6E["起手动画名"] ~= nil and _____914D_7F6E["起手动画名"] ~= "" then
        SetUnitAnimation(boss, _____914D_7F6E["起手动画名"])
    else
        _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = _____914D_7F6E["起手动画编号"], ["持续秒"] = _____914D_7F6E["结算秒"], ["恢复动画编号"] = 1})
    end
    EC_CreateEffect(
        _____914D_7F6E["蓄力特效"],
        GetUnitX(boss),
        GetUnitY(boss),
        50,
        270,
        2,
        1,
        _____914D_7F6E["结算秒"]
    )
    local data = {
        ["Boss单位"] = boss,
        ["配置"] = _____914D_7F6E,
        ["牵引控制器"] = nil,
        ["无敌尚未恢复"] = true,
        ["起手闪电句柄列表"] = {}
    }
    data["起手闪电句柄列表"] = _____521B_5EFA_98DF_4EBA_9B54_96F7_9706_9707_6012_8D77_624B_95EA_7535(boss, _____914D_7F6E["总硬直秒"])
    addDelayedCallback(_____914D_7F6E["牵引开始秒"] * 1000, ____on_96F7_9706_9707_6012_5F00_59CB_7275_5F15, data)
    addDelayedCallback(_____914D_7F6E["结算秒"] * 1000, ____on_96F7_9706_9707_6012_7ED3_7B97, data)
    addDelayedCallback(_____914D_7F6E["总硬直秒"] * 1000, ____on_96F7_9706_9707_6012_786C_76F4_7ED3_675F, data)
    return true
end
____exports["注册食人魔共享机制"] = function()
    if _____98DF_4EBA_9B54_5171_4EAB_673A_5236_5DF2_6CE8_518C then
        debugLogForce("食人魔-共享机制", "重复注册请求已忽略")
        return
    end
    _____98DF_4EBA_9B54_5171_4EAB_673A_5236_5DF2_6CE8_518C = true
    registerDeathListener(____on_98DF_4EBA_9B54_51FB_6740)
    debugLogForce("食人魔-共享机制", "共享机制注册完成：击杀啃食与雷霆震怒")
end
return ____exports
