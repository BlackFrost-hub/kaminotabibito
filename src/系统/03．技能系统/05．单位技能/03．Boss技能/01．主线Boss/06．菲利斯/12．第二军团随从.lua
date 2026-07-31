local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____5355_4F4D_5B58_6D3B, _____6E05_7406_672F_58EB_65BD_6CD5, _____4E2D_65AD_672F_58EB_65BD_6CD5, _____6E05_7406_72B6_6001, _____7ED3_7B97_8150_8680_6CD5_9635, _____83B7_53D6Boss_6280_80FD_654C_5BF9_76EE_6807_5217_8868, _____9020_6210AOE_6280_80FD_4F24_5BB3, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____83F2_5229_65AFBuffID, _____65BD_52A0_5FEB_901F_51CF_901FBuff, _____505C_6B62_5145_80FD, _____521B_5EFA_70B9_7279_6548, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitState, IsUnitType, GetUnitStateJapi, UNIT_TYPE_DEAD, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS, _____5F53_524D_72B6_6001
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.00．配置")
local _____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲利斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.02．数值与表现配置")
local _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲利斯数值与表现配置"]
function _____5355_4F4D_5B58_6D3B(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if GetUnitTypeId(unit) == 0 or IsUnitType(unit, UNIT_TYPE_DEAD) == true then
        return false
    end
    return GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
function _____6E05_7406_672F_58EB_65BD_6CD5(state)
    local record = state["当前术士施法"]
    if record == nil then
        return
    end
    state["当前术士施法"] = nil
end
function _____4E2D_65AD_672F_58EB_65BD_6CD5(state)
    local record = state["当前术士施法"]
    if record == nil then
        return
    end
    if record["充能ID"] > 0 and _____505C_6B62_5145_80FD(record["充能ID"]) then
        return
    end
    _____6E05_7406_672F_58EB_65BD_6CD5(state)
end
function _____6E05_7406_72B6_6001(state)
    _____4E2D_65AD_672F_58EB_65BD_6CD5(state)
    if _____5355_4F4D_5B58_6D3B(state["Boss单位"]) or state["Boss单位"] ~= nil then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(state["Boss单位"], _____83F2_5229_65AFBuffID["护主盾阵"])
    end
    if _____5F53_524D_72B6_6001 == state then
        _____5F53_524D_72B6_6001 = nil
    end
end
function _____7ED3_7B97_8150_8680_6CD5_9635(state, record)
    local boss = state["Boss单位"]
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["第二军团术士"]
    local warlock = record["术士单位"]
    if not _____5355_4F4D_5B58_6D3B(boss) or not _____5355_4F4D_5B58_6D3B(warlock) then
        return
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["爆炸特效路径"],
        X = record["目标X"],
        Y = record["目标Y"],
        ["缩放"] = cfg["爆炸缩放"],
        ["持续秒"] = cfg["爆炸持续秒"]
    })
    local targets = _____83B7_53D6Boss_6280_80FD_654C_5BF9_76EE_6807_5217_8868(boss)
    local radius2 = cfg["爆炸半径"] * cfg["爆炸半径"]
    local attack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(warlock) * cfg["术士攻击力比例"]
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____5355_4F4D_5B58_6D3B(target) then
                    goto __continue53
                end
                local dx = GetUnitX(target) - record["目标X"]
                local dy = GetUnitY(target) - record["目标Y"]
                if dx * dx + dy * dy > radius2 then
                    goto __continue53
                end
                local maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)
                local damage = attack + (maxLife > 0 and maxLife * cfg["目标最大生命比例"] or 0)
                if damage > 0 then
                    _____9020_6210AOE_6280_80FD_4F24_5BB3({
                        ["来源"] = warlock,
                        ["目标"] = target,
                        ["伤害"] = damage,
                        attack = false,
                        ranged = true,
                        attackType = ATTACK_TYPE_NORMAL,
                        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                        weaponType = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "Boss技能",
                        ["标签"] = "菲利斯-腐蚀法阵"
                    })
                end
                if not _____5355_4F4D_5B58_6D3B(target) then
                    goto __continue53
                end
                _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                    warlock,
                    target,
                    cfg["减速比例"],
                    cfg["减速比例"],
                    cfg["减速持续秒"],
                    "菲利斯-腐蚀法阵",
                    "技能"
                )
                registerManualBuff(
                    target,
                    _____83F2_5229_65AFBuffID["腐蚀迟滞"],
                    cfg["减速持续秒"],
                    cfg["减速比例"],
                    {sourceName = "菲利斯-腐蚀法阵", stack = 1}
                )
            end
            ::__continue53::
            i = i + 1
        end
    end
end
local jass = require("jass.common")
local japi = require("jass.japi")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("系统.01．单位系统.10．护卫系统.index")
local _____83B7_53D6Boss_62A4_536B_5217_8868 = ____require_result_3["获取Boss护卫列表"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4 = ____require_result_4["获取Boss技能最近敌对英雄"]
_____83B7_53D6Boss_6280_80FD_654C_5BF9_76EE_6807_5217_8868 = ____require_result_4["获取Boss技能敌对目标列表"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_5["造成AOE技能伤害"]
local ____require_result_6 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_6.registerDamageModifier
local ____require_result_7 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_7.registerManualBuff
local getBuffRuntime = ____require_result_7.getBuffRuntime
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_7["移除单位指定Buff"]
local ____require_result_8 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.05．菲利斯")
_____83F2_5229_65AFBuffID = ____require_result_8["菲利斯BuffID"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_9["施加快速减速Buff"]
local ____require_result_10 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_10["开始充能"]
_____505C_6B62_5145_80FD = ____require_result_10["停止充能"]
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_11["创建点特效"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_12["读取单位攻击力"]
local ____require_result_13 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_13["广播单位提示"]
local GetHandleId = jass.GetHandleId
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
IsUnitType = jass.IsUnitType
local SetUnitAnimation = jass.SetUnitAnimation
GetUnitStateJapi = japi.GetUnitState
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____83F2_5229_65AF_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____7B2C_4E8C_519B_56E2_62A4_536B_7C7B_578BID = stringToFourCCSafe("n063")
local _____7B2C_4E8C_519B_56E2_672F_58EB_7C7B_578BID = stringToFourCCSafe("n062")
local _____5DF2_6CE8_518C = false
local function _____53D6_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____5355_4F4D_7C7B_578B_662F_83F2_5229_65AF(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) == _____83F2_5229_65AF_5355_4F4D_7C7B_578BID
end
local function _____83B7_53D6_6216_521B_5EFA_72B6_6001(boss, now)
    local bossId = _____53D6_53E5_67C4ID(boss)
    if _____5F53_524D_72B6_6001 ~= nil and _____5F53_524D_72B6_6001["Boss单位"] == boss then
        return _____5F53_524D_72B6_6001
    end
    if _____5F53_524D_72B6_6001 ~= nil then
        _____6E05_7406_72B6_6001(_____5F53_524D_72B6_6001)
    end
    _____5F53_524D_72B6_6001 = {
        ["Boss单位"] = boss,
        ["Boss句柄ID"] = bossId,
        ["护主盾阵层数"] = 0,
        ["术士下次可施法Ms"] = now + _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["第二军团术士"]["首次施法延迟秒"] * 1000,
        ["当前术士施法"] = nil
    }
    return _____5F53_524D_72B6_6001
end
local function _____83B7_53D6_6709_6548_62A4_536B_5217_8868(boss)
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["第二军团护卫"]
    local result = {}
    local guards = _____83B7_53D6Boss_62A4_536B_5217_8868(boss, true)
    local range2 = cfg["生效范围"] * cfg["生效范围"]
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    do
        local i = 0
        while i < #guards do
            do
                local guard = guards[i + 1]
                if not _____5355_4F4D_5B58_6D3B(guard) or GetUnitTypeId(guard) ~= _____7B2C_4E8C_519B_56E2_62A4_536B_7C7B_578BID then
                    goto __continue21
                end
                local dx = GetUnitX(guard) - bossX
                local dy = GetUnitY(guard) - bossY
                if dx * dx + dy * dy <= range2 then
                    result[#result + 1] = guard
                end
            end
            ::__continue21::
            i = i + 1
        end
    end
    return result
end
local function _____5237_65B0_62A4_4E3B_76FE_9635(state)
    local boss = state["Boss单位"]
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["第二军团护卫"]
    if not _____5355_4F4D_5B58_6D3B(boss) then
        return
    end
    local guards = _____83B7_53D6_6709_6548_62A4_536B_5217_8868(boss)
    local layer = #guards < cfg["最大层数"] and #guards or cfg["最大层数"]
    state["护主盾阵层数"] = layer
    if layer <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____83F2_5229_65AFBuffID["护主盾阵"])
        return
    end
    local buffDuration = cfg["检查间隔毫秒"] / 1000 + 0.15
    registerManualBuff(
        boss,
        _____83F2_5229_65AFBuffID["护主盾阵"],
        buffDuration,
        layer * cfg["每层直接减伤比例"],
        {sourceName = "菲利斯-护主盾阵", stack = layer}
    )
    do
        local i = 0
        while i < #guards do
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = cfg["守护特效路径"],
                X = GetUnitX(guards[i + 1]),
                Y = GetUnitY(guards[i + 1]),
                ["缩放"] = cfg["守护特效缩放"],
                ["持续秒"] = cfg["守护特效持续秒"]
            })
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = cfg["守护特效路径"],
                X = GetUnitX(boss),
                Y = GetUnitY(boss),
                ["缩放"] = cfg["守护特效缩放"],
                ["持续秒"] = cfg["守护特效持续秒"]
            })
            i = i + 1
        end
    end
end
local function _____83F2_5229_65AF_62A4_4E3B_76FE_9635_4F24_5BB3_4FEE_6B63(context)
    if context == nil or _____5F53_524D_72B6_6001 == nil or context.target ~= _____5F53_524D_72B6_6001["Boss单位"] then
        local ____temp_14
        if context ~= nil then
            ____temp_14 = context.currentDamage
        else
            ____temp_14 = 0
        end
        return ____temp_14
    end
    if context.isDamageTransfer == true then
        return context.currentDamage
    end
    local currentDamage = __TS__Number(context.currentDamage)
    if not (currentDamage > 0) then
        return currentDamage
    end
    local runtime = getBuffRuntime(context.target, _____83F2_5229_65AFBuffID["护主盾阵"])
    if runtime == nil then
        return currentDamage
    end
    local ratio = __TS__Number(runtime.effect) or 0
    if not (ratio > 0) then
        return currentDamage
    end
    return currentDamage * (ratio < 1 and 1 - ratio or 0)
end
local function _____83B7_53D6_6709_6548_672F_58EB(boss)
    local guards = _____83B7_53D6Boss_62A4_536B_5217_8868(boss, true)
    do
        local i = 0
        while i < #guards do
            if _____5355_4F4D_5B58_6D3B(guards[i + 1]) and GetUnitTypeId(guards[i + 1]) == _____7B2C_4E8C_519B_56E2_672F_58EB_7C7B_578BID then
                return guards[i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
local function _____672F_58EB_5145_80FD_5B8C_6210_56DE_8C03(warlock, chargeId)
    local state = _____5F53_524D_72B6_6001
    if state == nil then
        return
    end
    local record = state["当前术士施法"]
    if record == nil or record["充能ID"] ~= chargeId or record["术士单位"] ~= warlock then
        return
    end
    _____6E05_7406_672F_58EB_65BD_6CD5(state)
    if _____5355_4F4D_5B58_6D3B(warlock) then
        SetUnitAnimation(warlock, "stand")
    end
    if not _____5355_4F4D_5B58_6D3B(state["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(warlock) then
        return
    end
    _____7ED3_7B97_8150_8680_6CD5_9635(state, record)
end
local function _____672F_58EB_5145_80FD_7ED3_675F_56DE_8C03(warlock, reason, chargeId)
    local state = _____5F53_524D_72B6_6001
    if state == nil then
        return
    end
    local record = state["当前术士施法"]
    if record == nil or record["充能ID"] ~= chargeId or record["术士单位"] ~= warlock then
        return
    end
    _____6E05_7406_672F_58EB_65BD_6CD5(state)
    if reason ~= "完成" and _____5355_4F4D_5B58_6D3B(warlock) then
        SetUnitAnimation(warlock, "stand")
    end
end
local function _____5F00_59CB_8150_8680_6CD5_9635_65BD_6CD5(state, warlock, target, now)
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["第二军团术士"]
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local chargeId = _____5F00_59CB_5145_80FD(warlock, {
        ["持续时间"] = cfg["施法秒"],
        ["主单位"] = state["Boss单位"],
        ["主单位死亡时中断"] = true,
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["进度条特效动画速度"] = cfg["施法秒"] > 0 and 1 / cfg["施法秒"] or 1,
        ["充能完成回调"] = _____672F_58EB_5145_80FD_5B8C_6210_56DE_8C03,
        ["结束回调"] = _____672F_58EB_5145_80FD_7ED3_675F_56DE_8C03
    })
    if chargeId <= 0 then
        return
    end
    SetUnitAnimation(warlock, "Spell")
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["法阵预警特效路径"],
        X = targetX,
        Y = targetY,
        ["缩放"] = cfg["法阵预警缩放"],
        ["持续秒"] = cfg["法阵预警持续秒"]
    })
    _____5E7F_64AD_5355_4F4D_63D0_793A(warlock, "第二军团术士施放腐蚀法阵（1秒后在法阵原位置爆炸，离开法阵即可躲避！）", cfg["广播持续时间Ms"])
    state["当前术士施法"] = {["术士单位"] = warlock, ["目标X"] = targetX, ["目标Y"] = targetY, ["充能ID"] = chargeId}
    state["术士下次可施法Ms"] = now + cfg["共享冷却秒"] * 1000
end
local function _____9A71_52A8_672F_58EB(state, now)
    if state["当前术士施法"] ~= nil or now < state["术士下次可施法Ms"] then
        return
    end
    local warlock = _____83B7_53D6_6709_6548_672F_58EB(state["Boss单位"])
    if not _____5355_4F4D_5B58_6D3B(warlock) then
        return
    end
    local target = _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4(state["Boss单位"])
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____5F00_59CB_8150_8680_6CD5_9635_65BD_6CD5(state, warlock, target, now)
end
____exports["立即触发菲利斯第二军团随从测试"] = function(boss)
    if not _____5355_4F4D_7C7B_578B_662F_83F2_5229_65AF(boss) or not _____5355_4F4D_5B58_6D3B(boss) then
        return false
    end
    local now = getServerTime()
    local state = _____83B7_53D6_6216_521B_5EFA_72B6_6001(boss, now)
    state["术士下次可施法Ms"] = now
    _____5237_65B0_62A4_4E3B_76FE_9635(state)
    if state["当前术士施法"] ~= nil then
        return true
    end
    _____9A71_52A8_672F_58EB(state, now)
    return state["当前术士施法"] ~= nil
end
local function _____83F2_5229_65AF_7B2C_4E8C_519B_56E2Tick()
    local globalBoss = jglobals.udg_Boss
    local _____5355_4F4D_7C7B_578B_662F_83F2_5229_65AF_result_15
    if _____5355_4F4D_7C7B_578B_662F_83F2_5229_65AF(globalBoss) then
        _____5355_4F4D_7C7B_578B_662F_83F2_5229_65AF_result_15 = globalBoss
    else
        _____5355_4F4D_7C7B_578B_662F_83F2_5229_65AF_result_15 = nil
    end
    local boss = _____5355_4F4D_7C7B_578B_662F_83F2_5229_65AF_result_15
    if boss == nil and _____5F53_524D_72B6_6001 ~= nil and _____5355_4F4D_7C7B_578B_662F_83F2_5229_65AF(_____5F53_524D_72B6_6001["Boss单位"]) then
        boss = _____5F53_524D_72B6_6001["Boss单位"]
    end
    if not _____5355_4F4D_7C7B_578B_662F_83F2_5229_65AF(boss) or not _____5355_4F4D_5B58_6D3B(boss) then
        if _____5F53_524D_72B6_6001 ~= nil then
            _____6E05_7406_72B6_6001(_____5F53_524D_72B6_6001)
        end
        return
    end
    local now = getServerTime()
    local state = _____83B7_53D6_6216_521B_5EFA_72B6_6001(boss, now)
    _____5237_65B0_62A4_4E3B_76FE_9635(state)
    _____9A71_52A8_672F_58EB(state, now)
end
local function ____on_83F2_5229_65AF_7B2C_4E8C_519B_56E2_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    if _____5F53_524D_72B6_6001 == nil then
        return
    end
    if _____5F53_524D_72B6_6001["Boss单位"] == dyingUnit then
        _____6E05_7406_72B6_6001(_____5F53_524D_72B6_6001)
        return
    end
    if _____5F53_524D_72B6_6001["当前术士施法"] ~= nil and _____5F53_524D_72B6_6001["当前术士施法"]["术士单位"] == dyingUnit then
        _____4E2D_65AD_672F_58EB_65BD_6CD5(_____5F53_524D_72B6_6001)
    end
end
____exports["注册菲利斯第二军团随从效果"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerDamageModifier(_____83F2_5229_65AF_62A4_4E3B_76FE_9635_4F24_5BB3_4FEE_6B63, 50)
    registerDeathListener(____on_83F2_5229_65AF_7B2C_4E8C_519B_56E2_5355_4F4D_6B7B_4EA1)
    addPeriodicCallback(_____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["第二军团护卫"]["检查间隔毫秒"], _____83F2_5229_65AF_7B2C_4E8C_519B_56E2Tick)
end
return ____exports
