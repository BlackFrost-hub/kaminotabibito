local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local _____8DDD_79BB_5E73_65B9 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位间距离平方"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.04．伤害系统.01．伤害事件")
local registerDamageCallback = ____require_result_2.registerDamageCallback
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_3.registerDamageModifier
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____8150_5316_9ECF_6DB2_4E0A_4E0B_6587_8868 = {}
local _____7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42_5DF2_6CE8_518C = false
local function _____63D0_793A_8150_5316_9ECF_6DB2_8FD1_6218_53CD_566C(source, currentStack)
    local owner = GetOwningPlayer(source)
    if owner == nil or owner == 0 then
        return
    end
    DisplayTimedTextToPlayer(
        owner,
        0,
        0,
        4,
        ("|cffff4040腐化黏液反噬：|r你近战攻击米亚时被其黏液涂层污染，腐化感染+1（当前" .. tostring(currentStack)) .. "层）。"
    )
end
local function _____64AD_653E_8150_5316_9ECF_6DB2_5168_573A_7206_53D1_8868_73B0(x, y)
    local config = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = config["腐化黏液爆发地面"],
        X = x,
        Y = y,
        Z = 0,
        ["缩放"] = 4,
        ["持续秒"] = 1
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = config["腐化黏液爆发放射"],
        X = x,
        Y = y,
        Z = 0,
        ["缩放"] = 4,
        ["持续秒"] = 1
    })
end
local function _____53D6_8150_5316_9ECF_6DB2_4E0A_4E0B_6587(boss)
    local id = GetHandleId(boss) or 0
    if id == 0 then
        return nil
    end
    return _____8150_5316_9ECF_6DB2_4E0A_4E0B_6587_8868[id]
end
local function _____767B_8BB0_8150_5316_9ECF_6DB2_4E0A_4E0B_6587(context)
    local id = GetHandleId(context["Boss单位"]) or 0
    if id == 0 then
        return
    end
    if context["阶段"] ~= 3 or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        if _____8150_5316_9ECF_6DB2_4E0A_4E0B_6587_8868[id] == context then
            __TS__Delete(_____8150_5316_9ECF_6DB2_4E0A_4E0B_6587_8868, id)
        end
        return
    end
    if _____8150_5316_9ECF_6DB2_4E0A_4E0B_6587_8868[id] == context then
        return
    end
    _____8150_5316_9ECF_6DB2_4E0A_4E0B_6587_8868[id] = context
    local ____self_6 = context["清理"]
    ____self_6["登记清理"](
        ____self_6,
        "腐化黏液上下文索引",
        function()
            if _____8150_5316_9ECF_6DB2_4E0A_4E0B_6587_8868[id] == context then
                __TS__Delete(_____8150_5316_9ECF_6DB2_4E0A_4E0B_6587_8868, id)
            end
        end
    )
end
local function _____5237_65B0_8150_5316_9ECF_6DB2Buff(context)
    registerManualBuff(
        context["Boss单位"],
        _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E.BuffID["腐化黏液涂层"],
        1.2,
        _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化黏液涂层"]["Boss受伤提高"],
        {sourceName = "腐化黏液涂层", effectModelOverride = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["腐化高层"]}
    )
end
local function _____5904_7406_8150_5316_9ECF_6DB2_8FD1_6218_53CD_566C(target, _damage, _damageType, fromDotTickBatch, source, isNormalAttack)
    if fromDotTickBatch == true or isNormalAttack ~= true then
        return
    end
    if not _____5355_4F4D_6709_6548(target) or not _____5355_4F4D_6709_6548(source) then
        return
    end
    local context = _____53D6_8150_5316_9ECF_6DB2_4E0A_4E0B_6587(target)
    if context == nil or context["阶段"] ~= 3 then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化黏液涂层"]
    local sourceId = GetHandleId(source) or 0
    local distanceSquared = _____8DDD_79BB_5E73_65B9(target, source)
    if distanceSquared > 250 * 250 then
        return
    end
    if sourceId == 0 then
        return
    end
    local nowMs = getServerTime()
    local _____51B7_5374_8868 = context["腐化黏液近战冷却表"]
    local lastApplyMs = _____51B7_5374_8868[sourceId]
    if lastApplyMs ~= nil and nowMs - lastApplyMs < config["近战叠层冷却Ms"] then
        return
    end
    _____51B7_5374_8868[sourceId] = nowMs
    local newStack = _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, source, 1, "腐化黏液涂层近战反噬")
    _____63D0_793A_8150_5316_9ECF_6DB2_8FD1_6218_53CD_566C(source, newStack)
    _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "腐化黏液涂层", 1)
end
local function _____5904_7406_8150_5316_9ECF_6DB2Boss_53D7_4F24_63D0_9AD8(damageContext)
    local context = _____53D6_8150_5316_9ECF_6DB2_4E0A_4E0B_6587(damageContext.target)
    if context == nil or context["阶段"] ~= 3 then
        return damageContext.currentDamage
    end
    local bonus = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化黏液涂层"]["Boss受伤提高"]
    local originalDamage = damageContext.currentDamage
    local modifiedDamage = originalDamage * (1 + bonus)
    local nowMs = getServerTime()
    if nowMs - context["腐化黏液上次受伤提示Ms"] >= 12000 then
        context["腐化黏液上次受伤提示Ms"] = nowMs
        _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "腐化黏液涂层", 3)
    end
    return modifiedDamage
end
____exports["释放米亚全场腐化黏液"] = function(context)
    local boss = context["Boss单位"]
    local bossValid = _____5355_4F4D_6709_6548(boss)
    if not bossValid or context["阶段"] ~= 3 then
        return false
    end
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "腐化黏液涂层", 2)
    local effectPath = "war3mapImported\\archimonde_portal_state.mdx"
    local effectX = GetUnitX(boss)
    local effectY = GetUnitY(boss)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = effectPath,
        X = effectX,
        Y = effectY,
        Z = 80,
        ["缩放"] = 1.2,
        ["持续秒"] = 1
    })
    _____64AD_653E_8150_5316_9ECF_6DB2_5168_573A_7206_53D1_8868_73B0(effectX, effectY)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                local heroValid = _____5355_4F4D_6709_6548(hero)
                if not heroValid then
                    goto __continue28
                end
                _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, hero, 1, "腐化黏液涂层全场甩黏液")
            end
            ::__continue28::
            i = i + 1
        end
    end
    return true
end
____exports["注册米亚腐化黏液涂层"] = function()
    if _____7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42_5DF2_6CE8_518C then
        return
    end
    _____7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42_5DF2_6CE8_518C = true
    registerDamageCallback(_____5904_7406_8150_5316_9ECF_6DB2_8FD1_6218_53CD_566C, 0.03)
    registerDamageModifier(_____5904_7406_8150_5316_9ECF_6DB2Boss_53D7_4F24_63D0_9AD8, 35)
end
____exports["刷新米亚腐化黏液涂层被动状态"] = function(context)
    if context == nil then
        return
    end
    _____767B_8BB0_8150_5316_9ECF_6DB2_4E0A_4E0B_6587(context)
    if context["阶段"] ~= 3 then
        return
    end
    _____5237_65B0_8150_5316_9ECF_6DB2Buff(context)
end
return ____exports
