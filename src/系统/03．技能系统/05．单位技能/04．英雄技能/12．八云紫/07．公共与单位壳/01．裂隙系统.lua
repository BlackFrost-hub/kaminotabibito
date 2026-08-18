local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____79FB_9664_4E34_65F6_88C2_9699, jass
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00．配置")
local _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["八云紫单位技能配置"]
function _____79FB_9664_4E34_65F6_88C2_9699(variable)
    local unit = variable
    if unit ~= nil and unit ~= 0 and jass.GetUnitTypeId(unit) ~= 0 then
        jass.RemoveUnit(unit)
    end
end
jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local getGameTime = ____require_result_0.getGameTime
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_2["创建单位并登记排泄安全"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_3.getEnemyUnitsInRange
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.06．精英单位判断")
local _____662F_5426_7CBE_82F1_5355_4F4D = ____require_result_4["是否精英单位"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local ____require_result_6 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_6["造成单体技能伤害"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_7["施加眩晕"]
local _____914D_7F6E = _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY
local _____88C2_9699_8BB0_5F55_8868 = {}
local _____82F1_96C4_957F_671F_88C2_9699_6570 = {}
local _____82F1_96C4R_671F_95F4D_6392_65A5_8C41_514D = {}
local _____82F1_96C4E_671F_95F4D_6392_65A5_8C41_514D = {}
local _____95F4_9699_547D_4E2D_6B21_6570 = {}
local _____5DF2_6CE8_518C_88C2_9699_6269_6563_53D1_5C04_5668
local _____88C2_9699_521B_5EFA_76D1_542C_5668_5217_8868 = {}
local function _____53E5_67C4ID(handle)
    return (handle == nil or handle == 0) and 0 or jass.GetHandleId(handle)
end
local function _____83B7_53D6_8303_56F4_5185_539F_751F_5355_4F4D(x, y, radius)
    local group = jass.CreateGroup()
    local result = {}
    jass.GroupEnumUnitsInRange(
        group,
        x,
        y,
        radius,
        nil
    )
    local unit = jass.FirstOfGroup(group)
    while unit ~= nil and unit ~= 0 do
        result[#result + 1] = unit
        jass.GroupRemoveUnit(group, unit)
        unit = jass.FirstOfGroup(group)
    end
    jass.DestroyGroup(group)
    return result
end
____exports["八云紫单位存活"] = function(unit)
    return unit ~= nil and unit ~= 0 and jass.GetUnitTypeId(unit) ~= 0 and jass.GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
____exports["是八云紫"] = function(unit)
    return ____exports["八云紫单位存活"](unit) and jass.GetUnitTypeId(unit) == _____914D_7F6E["单位"]["英雄类型ID"]
end
____exports["设置八云紫R期间D排斥豁免"] = function(hero, enabled)
    local heroId = _____53E5_67C4ID(hero)
    if heroId == 0 then
        return
    end
    if enabled then
        _____82F1_96C4R_671F_95F4D_6392_65A5_8C41_514D[heroId] = true
    else
        __TS__Delete(_____82F1_96C4R_671F_95F4D_6392_65A5_8C41_514D, heroId)
    end
end
____exports["设置八云紫E期间D排斥豁免"] = function(hero, enabled)
    local heroId = _____53E5_67C4ID(hero)
    if heroId == 0 then
        return
    end
    if enabled then
        _____82F1_96C4E_671F_95F4D_6392_65A5_8C41_514D[heroId] = true
    else
        __TS__Delete(_____82F1_96C4E_671F_95F4D_6392_65A5_8C41_514D, heroId)
    end
end
____exports["八云紫R期间D排斥已豁免"] = function(hero)
    local heroId = _____53E5_67C4ID(hero)
    return _____82F1_96C4R_671F_95F4D_6392_65A5_8C41_514D[heroId] == true or _____82F1_96C4E_671F_95F4D_6392_65A5_8C41_514D[heroId] == true
end
____exports["是八云紫合法敌人"] = function(hero, target)
    return ____exports["八云紫单位存活"](target) and jass.IsUnitEnemy(
        target,
        jass.GetOwningPlayer(hero)
    ) == true and jass.IsUnitType(target, UNIT_TYPE_STRUCTURE) ~= true and jass.IsUnitType(target, UNIT_TYPE_MECHANICAL) ~= true and jass.IsUnitType(target, UNIT_TYPE_ANCIENT) ~= true
end
local function _____9500_6BC1_70B9_7279_6548(variable)
    local effect = variable
    if effect ~= nil and effect ~= 0 then
        jass.DestroyEffect(effect)
    end
end
____exports["创建八云紫点特效"] = function(model, x, y, durationSec, scale, height)
    if scale == nil then
        scale = 1
    end
    if height == nil then
        height = 0
    end
    local effect = jass.AddSpecialEffect(model, x, y)
    if effect == nil or effect == 0 then
        return effect
    end
    if scale ~= 1 and japi.EXSetEffectSize ~= nil then
        japi.EXSetEffectSize(effect, scale)
    end
    if height ~= 0 and japi.EXSetEffectZ ~= nil then
        japi.EXSetEffectZ(effect, height)
    end
    addDelayedCallback(durationSec * 1000, _____9500_6BC1_70B9_7279_6548, effect)
    return effect
end
local function _____6E05_7406_95F4_9699_547D_4E2D_5C42(variable)
    local targetId = variable
    local count = _____95F4_9699_547D_4E2D_6B21_6570[targetId] or 0
    if count <= 1 then
        __TS__Delete(_____95F4_9699_547D_4E2D_6B21_6570, targetId)
    else
        _____95F4_9699_547D_4E2D_6B21_6570[targetId] = count - 1
    end
end
local function _____7ED3_7B97_88C2_9699_547D_4E2D(hero, target, skillId, skillInstanceId)
    local baseDamage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(hero) * _____914D_7F6E["裂隙"]["展开伤害攻击力比例"]
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = hero,
        ["目标"] = target,
        ["伤害"] = baseDamage,
        ["伤害类型"] = DAMAGE_TYPE_MIND,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = skillId,
        ["技能实例ID"] = skillInstanceId,
        ["标签"] = "八云紫-裂隙展开",
        ["参与技能伤害加成"] = true
    })
    local targetId = _____53E5_67C4ID(target)
    local next = (_____95F4_9699_547D_4E2D_6B21_6570[targetId] or 0) + 1
    _____95F4_9699_547D_4E2D_6B21_6570[targetId] = next
    if next >= 2 then
        __TS__Delete(_____95F4_9699_547D_4E2D_6B21_6570, targetId)
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = hero,
            ["目标"] = target,
            ["伤害"] = baseDamage * _____914D_7F6E["裂隙"]["二次命中额外倍率"],
            ["伤害类型"] = DAMAGE_TYPE_MIND,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["技能ID"] = skillId,
            ["技能实例ID"] = skillInstanceId,
            ["标签"] = "八云紫-裂隙二次展开",
            ["参与技能伤害加成"] = true
        })
        _____65BD_52A0_7729_6655(
            hero,
            target,
            _____914D_7F6E["裂隙"]["二次命中眩晕秒"],
            "八云紫-裂隙二次展开",
            "技能"
        )
        do
            local i = 0
            while i < #_____914D_7F6E["裂隙"]["二次特效"] do
                ____exports["创建八云紫点特效"](
                    _____914D_7F6E["裂隙"]["二次特效"][i + 1],
                    jass.GetUnitX(target),
                    jass.GetUnitY(target),
                    1.25
                )
                i = i + 1
            end
        end
    else
        addDelayedCallback(_____914D_7F6E["裂隙"]["二次命中窗口秒"] * 1000, _____6E05_7406_95F4_9699_547D_4E2D_5C42, targetId)
    end
end
____exports["结算八云紫裂隙展开"] = function(hero, x, y, skillId, skillInstanceId)
    if skillId == nil then
        skillId = _____914D_7F6E["技能"].D["类型ID"]
    end
    ____exports["创建八云紫点特效"](_____914D_7F6E["裂隙"]["冲击特效"], x, y, _____914D_7F6E["裂隙"]["冲击特效持续秒"])
    ____exports["创建八云紫点特效"](
        _____914D_7F6E["裂隙"]["出现特效"],
        x,
        y,
        _____914D_7F6E["裂隙"]["出现特效持续秒"],
        _____914D_7F6E["裂隙"]["出现特效缩放"],
        _____914D_7F6E["裂隙"]["出现特效高度"]
    )
    local targets = getEnemyUnitsInRange(hero, x, y, _____914D_7F6E["裂隙"]["展开范围"])
    do
        local i = 0
        while i < #targets do
            if ____exports["是八云紫合法敌人"](hero, targets[i + 1]) then
                _____7ED3_7B97_88C2_9699_547D_4E2D(hero, targets[i + 1], skillId, skillInstanceId)
            end
            i = i + 1
        end
    end
end
local function _____6E05_7406_88C2_9699_8BB0_5F55(record)
    if record["已结束"] then
        return
    end
    record["已结束"] = true
    local unitId = _____53E5_67C4ID(record["单位"])
    if _____88C2_9699_8BB0_5F55_8868[unitId] == record then
        __TS__Delete(_____88C2_9699_8BB0_5F55_8868, unitId)
    end
    if record["长期"] then
        local heroId = _____53E5_67C4ID(record["主人"])
        local next = (_____82F1_96C4_957F_671F_88C2_9699_6570[heroId] or 1) - 1
        if next > 0 then
            _____82F1_96C4_957F_671F_88C2_9699_6570[heroId] = next
        else
            __TS__Delete(_____82F1_96C4_957F_671F_88C2_9699_6570, heroId)
        end
    end
    if record["单位"] ~= nil and record["单位"] ~= 0 and jass.GetUnitTypeId(record["单位"]) ~= 0 then
        jass.RemoveUnit(record["单位"])
    end
end
local function _____88C2_9699_5230_671F(variable)
    local record = variable
    if record ~= nil then
        _____6E05_7406_88C2_9699_8BB0_5F55(record)
    end
end
local function _____9644_8FD1_5B58_5728_957F_671F_88C2_9699(x, y)
    local units = _____83B7_53D6_8303_56F4_5185_539F_751F_5355_4F4D(x, y, _____914D_7F6E["裂隙"]["附近检测范围"])
    do
        local i = 0
        while i < #units do
            local record = _____88C2_9699_8BB0_5F55_8868[_____53E5_67C4ID(units[i + 1])]
            if record ~= nil and not record["已结束"] and record["长期"] then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____9644_8FD1_5B58_5728_7CBE_82F1_654C_4EBA(hero, x, y)
    local units = getEnemyUnitsInRange(hero, x, y, _____914D_7F6E["裂隙"]["附近检测范围"])
    do
        local i = 0
        while i < #units do
            if ____exports["八云紫单位存活"](units[i + 1]) and _____662F_5426_7CBE_82F1_5355_4F4D(units[i + 1]) == true then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____9009_62E9_88C2_9699_6301_7EED_65F6_95F4(hero, x, y)
    local heroId = _____53E5_67C4ID(hero)
    if _____9644_8FD1_5B58_5728_7CBE_82F1_654C_4EBA(hero, x, y) then
        return {duration = _____914D_7F6E["裂隙"]["短期持续秒"], long = false}
    end
    if _____9644_8FD1_5B58_5728_957F_671F_88C2_9699(x, y) then
        return {duration = _____914D_7F6E["裂隙"]["短期持续秒"], long = false}
    end
    if (_____82F1_96C4_957F_671F_88C2_9699_6570[heroId] or 0) >= _____914D_7F6E["裂隙"]["最多长期裂隙"] then
        return {duration = _____914D_7F6E["裂隙"]["短期持续秒"], long = false}
    end
    return {duration = _____914D_7F6E["裂隙"]["长期持续秒"], long = true}
end
____exports["检查八云紫D裂隙放置"] = function(hero, x, y)
    if not ____exports["是八云紫"](hero) then
        return {["可创建"] = false, ["持续秒"] = 0, ["长期"] = false, ["失败原因"] = "施法者无效。"}
    end
    if _____9644_8FD1_5B58_5728_7CBE_82F1_654C_4EBA(hero, x, y) then
        return {["可创建"] = true, ["持续秒"] = _____914D_7F6E["裂隙"]["短期持续秒"], ["长期"] = false}
    end
    if not ____exports["八云紫R期间D排斥已豁免"](hero) and _____9644_8FD1_5B58_5728_957F_671F_88C2_9699(x, y) then
        return {["可创建"] = false, ["持续秒"] = 0, ["长期"] = false, ["失败原因"] = "附近已有长期『间隙』，无法再次放置。"}
    end
    local heroId = _____53E5_67C4ID(hero)
    if (_____82F1_96C4_957F_671F_88C2_9699_6570[heroId] or 0) >= _____914D_7F6E["裂隙"]["最多长期裂隙"] then
        return {["可创建"] = false, ["持续秒"] = 0, ["长期"] = false, ["失败原因"] = "长期『间隙』数量已达到上限。"}
    end
    return {["可创建"] = true, ["持续秒"] = _____914D_7F6E["裂隙"]["长期持续秒"], ["长期"] = true}
end
____exports["计算裂隙可达终点"] = function(startX, startY, targetX, targetY)
    local dx = targetX - startX
    local dy = targetY - startY
    local distance = math.sqrt(dx * dx + dy * dy)
    if distance <= 0.01 then
        return {x = startX, y = startY}
    end
    local maxDistance = math.min(distance, _____914D_7F6E["裂隙"]["放置距离"])
    local ux = dx / distance
    local uy = dy / distance
    local x = startX
    local y = startY
    local travelled = 0
    while travelled < maxDistance do
        local step = math.min(_____914D_7F6E["裂隙"]["移动步长"], maxDistance - travelled)
        local nextX = x + ux * step
        local nextY = y + uy * step
        if jass.IsTerrainPathable(nextX, nextY, PATHING_TYPE_WALKABILITY) == true then
            break
        end
        x = nextX
        y = nextY
        travelled = travelled + step
    end
    return {x = x, y = y}
end
____exports["创建八云紫裂隙"] = function(hero, x, y, skillId, skillInstanceId, _____6307_5B9A_5BFF_547D)
    if skillId == nil then
        skillId = _____914D_7F6E["技能"].D["类型ID"]
    end
    if not ____exports["是八云紫"](hero) then
        return nil
    end
    local lifetime = _____6307_5B9A_5BFF_547D ~= nil and ({duration = _____6307_5B9A_5BFF_547D["持续秒"], long = _____6307_5B9A_5BFF_547D["长期"]}) or _____9009_62E9_88C2_9699_6301_7EED_65F6_95F4(hero, x, y)
    if skillId == _____914D_7F6E["技能"].D["类型ID"] then
        local placement = ____exports["检查八云紫D裂隙放置"](hero, x, y)
        if not placement["可创建"] then
            return nil
        end
        lifetime = {duration = placement["持续秒"], long = placement["长期"]}
    end
    local gap = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        jass.GetOwningPlayer(hero),
        _____914D_7F6E["单位"]["裂隙类型ID"],
        x,
        y,
        0
    )
    if gap == nil or gap == 0 then
        return nil
    end
    local record = {
        ["单位"] = gap,
        ["主人"] = hero,
        ["长期"] = lifetime.long,
        ["到期时间"] = getGameTime() + lifetime.duration * 1000,
        ["扩散冷却到"] = 0,
        ["已结束"] = false
    }
    _____88C2_9699_8BB0_5F55_8868[_____53E5_67C4ID(gap)] = record
    if lifetime.long then
        local heroId = _____53E5_67C4ID(hero)
        _____82F1_96C4_957F_671F_88C2_9699_6570[heroId] = (_____82F1_96C4_957F_671F_88C2_9699_6570[heroId] or 0) + 1
    end
    jass.SetUnitState(gap, UNIT_STATE_MAX_LIFE, lifetime.duration)
    jass.SetUnitState(gap, UNIT_STATE_LIFE, lifetime.duration)
    addDelayedCallback(lifetime.duration * 1000, _____88C2_9699_5230_671F, record)
    ____exports["结算八云紫裂隙展开"](
        hero,
        x,
        y,
        skillId,
        skillInstanceId
    )
    do
        local i = 0
        while i < #_____88C2_9699_521B_5EFA_76D1_542C_5668_5217_8868 do
            _____88C2_9699_521B_5EFA_76D1_542C_5668_5217_8868[i + 1](hero, record, skillId, skillInstanceId)
            i = i + 1
        end
    end
    return record
end
____exports["创建八云紫临时裂隙"] = function(hero, x, y, durationSec)
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        jass.GetOwningPlayer(hero),
        _____914D_7F6E["单位"]["临时裂隙类型ID"],
        x,
        y,
        0
    )
    if unit == nil or unit == 0 then
        return unit
    end
    ____exports["结算八云紫裂隙展开"](hero, x, y, _____914D_7F6E["技能"].W["类型ID"])
    addDelayedCallback(durationSec * 1000, _____79FB_9664_4E34_65F6_88C2_9699, unit)
    return unit
end
____exports["获取八云紫裂隙记录"] = function(unit)
    local record = _____88C2_9699_8BB0_5F55_8868[_____53E5_67C4ID(unit)]
    return record ~= nil and not record["已结束"] and ____exports["八云紫单位存活"](record["单位"]) and record or nil
end
____exports["查找八云紫裂隙"] = function(x, y, radius, owner)
    local units = _____83B7_53D6_8303_56F4_5185_539F_751F_5355_4F4D(x, y, radius)
    do
        local i = 0
        while i < #units do
            do
                local record = ____exports["获取八云紫裂隙记录"](units[i + 1])
                if record == nil then
                    goto __continue80
                end
                if owner == nil or owner == 0 or jass.GetOwningPlayer(record["主人"]) == jass.GetOwningPlayer(owner) then
                    return record
                end
            end
            ::__continue80::
            i = i + 1
        end
    end
    return nil
end
____exports["获取范围内八云紫裂隙"] = function(x, y, radius, owner)
    local result = {}
    local units = _____83B7_53D6_8303_56F4_5185_539F_751F_5355_4F4D(x, y, radius)
    do
        local i = 0
        while i < #units do
            do
                local record = ____exports["获取八云紫裂隙记录"](units[i + 1])
                if record == nil then
                    goto __continue85
                end
                if owner ~= nil and owner ~= 0 and jass.GetOwningPlayer(record["主人"]) ~= jass.GetOwningPlayer(owner) then
                    goto __continue85
                end
                result[#result + 1] = record
            end
            ::__continue85::
            i = i + 1
        end
    end
    return result
end
____exports["注册八云紫裂隙扩散发射器"] = function(handler)
    _____5DF2_6CE8_518C_88C2_9699_6269_6563_53D1_5C04_5668 = handler
end
____exports["注册八云紫裂隙创建监听器"] = function(handler)
    if handler == nil then
        return
    end
    do
        local i = 0
        while i < #_____88C2_9699_521B_5EFA_76D1_542C_5668_5217_8868 do
            if _____88C2_9699_521B_5EFA_76D1_542C_5668_5217_8868[i + 1] == handler then
                return
            end
            i = i + 1
        end
    end
    _____88C2_9699_521B_5EFA_76D1_542C_5668_5217_8868[#_____88C2_9699_521B_5EFA_76D1_542C_5668_5217_8868 + 1] = handler
end
____exports["触发八云紫裂隙扩散"] = function(hero, centerGap)
    if _____5DF2_6CE8_518C_88C2_9699_6269_6563_53D1_5C04_5668 == nil or centerGap["已结束"] then
        return 0
    end
    local gaps = ____exports["获取范围内八云紫裂隙"](
        jass.GetUnitX(centerGap["单位"]),
        jass.GetUnitY(centerGap["单位"]),
        _____914D_7F6E["裂隙"]["附近检测范围"],
        hero
    )
    local now = getGameTime()
    local count = 0
    do
        local i = 0
        while i < #gaps do
            do
                local gap = gaps[i + 1]
                if gap["扩散冷却到"] > now then
                    goto __continue97
                end
                local life = jass.GetUnitState(gap["单位"], UNIT_STATE_LIFE)
                local maxLife = jass.GetUnitState(gap["单位"], UNIT_STATE_MAX_LIFE)
                local cost = maxLife * _____914D_7F6E["裂隙"]["扩散生命消耗比例"]
                if life <= cost + 0.405 then
                    _____6E05_7406_88C2_9699_8BB0_5F55(gap)
                    goto __continue97
                end
                jass.SetUnitState(gap["单位"], UNIT_STATE_LIFE, life - cost)
                gap["扩散冷却到"] = now + _____914D_7F6E["裂隙"]["扩散冷却秒"] * 1000
                _____5DF2_6CE8_518C_88C2_9699_6269_6563_53D1_5C04_5668(hero, gap)
                count = count + 1
            end
            ::__continue97::
            i = i + 1
        end
    end
    return count
end
local function _____76D1_542C_516B_4E91_7D2B_88C2_9699_81EA_6BC1(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____914D_7F6E["技能"].Afzy["类型ID"] or castingUnit == nil or castingUnit == 0 then
        return
    end
    local unitTypeId = jass.GetUnitTypeId(castingUnit)
    if unitTypeId == _____914D_7F6E["单位"]["裂隙类型ID"] then
        local record = ____exports["获取八云紫裂隙记录"](castingUnit)
        if record ~= nil then
            _____6E05_7406_88C2_9699_8BB0_5F55(record)
        end
        return
    end
    if unitTypeId == _____914D_7F6E["单位"]["临时裂隙类型ID"] and unitTypeId ~= 0 then
        jass.RemoveUnit(castingUnit)
    end
end
registerSpellEffectListener(_____76D1_542C_516B_4E91_7D2B_88C2_9699_81EA_6BC1)
return ____exports
