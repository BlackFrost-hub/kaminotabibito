local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.00．配置")
local _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶技能配置"]
local _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶表现配置"]
local _____6731_96C0_9662_7EA2_53F6Buff_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶Buff配置"]
local _____6731_96C0_9662_7EA2_53F6_88AB_52A8_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶被动配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_1.getGameTime
local addDelayedCallback = ____require_result_1.addDelayedCallback
local removeDelayedCallback = ____require_result_1.removeDelayedCallback
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_3.registerAppliedFinalDamageListener
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_4["造成技能伤害"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_5["移除单位指定Buff"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_6["单位存活"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_7.createUnitEffect
local destroyUnitEffect = ____require_result_7.destroyUnitEffect
local _____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local _____8BBE_7F6E_7279_6548_7F29_653E = ____require_result_7["设置特效缩放"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E["单位类型ID"])
local _____7834_7EFDBuffID = _____6731_96C0_9662_7EA2_53F6Buff_914D_7F6E["破绽"]
local _____5200_52BFBuffID = _____6731_96C0_9662_7EA2_53F6Buff_914D_7F6E["刀势"]
local _____5200_52BF_4E0A_9650 = _____6731_96C0_9662_7EA2_53F6_88AB_52A8_914D_7F6E["刀势上限"]
local _____5200_52BF_7279_6548_952E = "朱雀院红叶刀势"
local _____7834_7EFD_7279_6548_952E = "朱雀院红叶破绽"
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetHandleId = jass.GetHandleId
local _____82F1_96C4_72B6_6001_8868 = {}
local function _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    local id = GetHandleId(_____82F1_96C4)
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {["刀势层数"] = 0, ["技能清理表"] = {}}
        _____82F1_96C4_72B6_6001_8868[id] = _____72B6_6001
    end
    return _____72B6_6001
end
--- 登记技能清理函数（Q/W/E/R/D 各模块调用；英雄死亡/场景清理统一执行，幂等）
____exports["登记朱雀院清理"] = function(_____82F1_96C4, _____540D_79F0, _____6E05_7406)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)["技能清理表"][_____540D_79F0] = _____6E05_7406
end
--- 是否是朱雀院红叶（按单位类型）
____exports["是朱雀院红叶"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return jass:GetUnitTypeId(unit) == _____82F1_96C4_5355_4F4D_7C7B_578BID
end
--- 获取当前刀势层数（0~3）
____exports["获取刀势层数"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return 0
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and _____72B6_6001["刀势层数"] or 0
end
--- 幂等统一清理：英雄死亡/离场/场景清理入口
____exports["清理朱雀院红叶状态"] = function(_____82F1_96C4, ______539F_56E0)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local id = GetHandleId(_____82F1_96C4)
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return
    end
    destroyUnitEffect(_____82F1_96C4, _____5200_52BF_7279_6548_952E)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____5200_52BFBuffID)
    for key in pairs(_____72B6_6001["技能清理表"]) do
        local _____6E05_7406 = _____72B6_6001["技能清理表"][key]
        if _____6E05_7406 ~= nil then
            _____6E05_7406()
        end
    end
    __TS__Delete(_____82F1_96C4_72B6_6001_8868, id)
end
local _____7834_7EFD_76EE_6807_8868 = {}
--- 红叶句柄 -> 目标句柄 -> 冷却到期；独立于会被消费删除的破绽状态。
local _____7834_7EFD_65A9_51B7_5374_8868 = {}
--- 目标当前是否带有朱雀院红叶的破绽
____exports["目标有破绽"] = function(_____76EE_6807)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return false
    end
    return _____7834_7EFD_76EE_6807_8868[GetHandleId(_____76EE_6807)] ~= nil
end
--- 移除目标破绽（特效/Buff/回调/表项，幂等）
____exports["移除目标破绽"] = function(_____76EE_6807)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return
    end
    local id = GetHandleId(_____76EE_6807)
    local _____72B6_6001 = _____7834_7EFD_76EE_6807_8868[id]
    if _____72B6_6001 == nil then
        return
    end
    if _____72B6_6001["到期回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["到期回调ID"])
    end
    destroyUnitEffect(_____76EE_6807, _____7834_7EFD_7279_6548_952E)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____76EE_6807, _____7834_7EFDBuffID)
    __TS__Delete(_____7834_7EFD_76EE_6807_8868, id)
end
--- 统一施加或刷新破绽（Q/W/E/R 技能命中调用）；刷新持续时间和表现
____exports["施加朱雀院破绽"] = function(_____7EA2_53F6, _____76EE_6807)
    if _____7EA2_53F6 == nil or _____7EA2_53F6 == 0 or _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return
    end
    if _____76EE_6807 == _____7EA2_53F6 then
        return
    end
    local id = GetHandleId(_____76EE_6807)
    local _____65E7_72B6_6001 = _____7834_7EFD_76EE_6807_8868[id]
    if _____65E7_72B6_6001 ~= nil and _____65E7_72B6_6001["到期回调ID"] ~= 0 then
        removeDelayedCallback(_____65E7_72B6_6001["到期回调ID"])
    end
    local _____6301_7EED_6BEB_79D2 = _____6731_96C0_9662_7EA2_53F6_88AB_52A8_914D_7F6E["破绽持续秒"] * 1000
    local _____72B6_6001 = {
        ["来源英雄"] = _____7EA2_53F6,
        ["到期时间"] = getGameTime() + _____6731_96C0_9662_7EA2_53F6_88AB_52A8_914D_7F6E["破绽持续秒"],
        ["到期回调ID"] = 0
    }
    _____72B6_6001["到期回调ID"] = addDelayedCallback(
        _____6301_7EED_6BEB_79D2,
        function()
            local _____5F53_524D = _____7834_7EFD_76EE_6807_8868[GetHandleId(_____76EE_6807)]
            if _____5F53_524D == _____72B6_6001 then
                ____exports["移除目标破绽"](_____76EE_6807)
            end
        end
    )
    _____7834_7EFD_76EE_6807_8868[id] = _____72B6_6001
    destroyUnitEffect(_____76EE_6807, _____7834_7EFD_7279_6548_952E)
    local _____7834_7EFD_7279_6548 = createUnitEffect(
        _____76EE_6807,
        "origin",
        _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["破绽标记"],
        _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["参数"]["破绽标记"]["持续秒"],
        _____7834_7EFD_7279_6548_952E
    )
    _____8BBE_7F6E_7279_6548_7F29_653E(_____7834_7EFD_7279_6548, _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["参数"]["破绽标记"]["缩放"])
    registerManualBuff(
        _____76EE_6807,
        _____7834_7EFDBuffID,
        _____6731_96C0_9662_7EA2_53F6_88AB_52A8_914D_7F6E["破绽持续秒"],
        1,
        {stack = 1}
    )
end
local function _____5237_65B0_5200_52BF_8868_73B0(_____82F1_96C4, _____5C42_6570)
    destroyUnitEffect(_____82F1_96C4, _____5200_52BF_7279_6548_952E)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____5200_52BFBuffID)
    if _____5C42_6570 <= 0 then
        return
    end
    local _____6A21_578B = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["刀势层数"][_____5C42_6570]
    if _____6A21_578B ~= nil then
        local _____5200_52BF_7279_6548 = createUnitEffect(
            _____82F1_96C4,
            "origin",
            _____6A21_578B,
            nil,
            _____5200_52BF_7279_6548_952E
        )
        _____8BBE_7F6E_7279_6548_7F29_653E(_____5200_52BF_7279_6548, _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["参数"]["刀势层数"]["缩放"])
    end
    registerManualBuff(
        _____82F1_96C4,
        _____5200_52BFBuffID,
        9999,
        _____5C42_6570,
        {stack = _____5C42_6570}
    )
end
--- 增加刀势（+层数，最大 3 层；到达上限时播放一次提示）
____exports["增加刀势"] = function(_____82F1_96C4, _____5C42_6570)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____5C42_6570 <= 0 then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    local _____539F_5C42_6570 = _____72B6_6001["刀势层数"]
    local _____65B0_5C42_6570 = _____539F_5C42_6570 + _____5C42_6570 > _____5200_52BF_4E0A_9650 and _____5200_52BF_4E0A_9650 or _____539F_5C42_6570 + _____5C42_6570
    if _____65B0_5C42_6570 == _____539F_5C42_6570 then
        return
    end
    _____72B6_6001["刀势层数"] = _____65B0_5C42_6570
    _____5237_65B0_5200_52BF_8868_73B0(_____82F1_96C4, _____65B0_5C42_6570)
    if _____65B0_5C42_6570 >= _____5200_52BF_4E0A_9650 and _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["满刀势提示特效"] ~= nil and _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["满刀势提示特效"] ~= "" then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["满刀势提示特效"],
            X = jass:GetUnitX(_____82F1_96C4),
            Y = jass:GetUnitY(_____82F1_96C4),
            Z = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["参数"]["满刀势提示"]["高度"],
            ["缩放"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["参数"]["满刀势提示"]["缩放"],
            ["持续秒"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["参数"]["满刀势提示"]["持续秒"]
        })
    end
end
--- 尝试消费 1 层刀势（无则 false，技能仍执行基础效果）
____exports["尝试消费一层刀势"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["刀势层数"] <= 0 then
        return false
    end
    _____72B6_6001["刀势层数"] = _____72B6_6001["刀势层数"] - 1
    _____5237_65B0_5200_52BF_8868_73B0(_____82F1_96C4, _____72B6_6001["刀势层数"])
    return true
end
--- 消费全部刀势，返回实际消费层数（R 终式用）
____exports["消费全部刀势"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return 0
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    local _____5C42_6570 = _____72B6_6001["刀势层数"]
    if _____5C42_6570 <= 0 then
        return 0
    end
    _____72B6_6001["刀势层数"] = 0
    _____5237_65B0_5200_52BF_8868_73B0(_____82F1_96C4, 0)
    return _____5C42_6570
end
local _____7834_7EFD_65A9_76D1_542C_5217_8868 = {}
--- 注册破绽斩事件监听（幂等注册方自行控制）
____exports["注册破绽斩监听"] = function(_____56DE_8C03)
    _____7834_7EFD_65A9_76D1_542C_5217_8868[#_____7834_7EFD_65A9_76D1_542C_5217_8868 + 1] = _____56DE_8C03
end
local function _____5904_7406_7EA2_53F6_666E_653B_7834_7EFD_65A9(target, attacker, applied, snapshot)
    if not ____exports["是朱雀院红叶"](attacker) then
        return
    end
    if snapshot == nil then
        return
    end
    if snapshot.isNormalAttack ~= true then
        return
    end
    if snapshot.isWrappedSkillDamage == true then
        return
    end
    if target == nil or target == 0 then
        return
    end
    local id = GetHandleId(target)
    local _____7834_7EFD = _____7834_7EFD_76EE_6807_8868[id]
    if _____7834_7EFD == nil then
        return
    end
    if _____7834_7EFD["来源英雄"] ~= attacker then
        return
    end
    local _____73B0_5728 = getGameTime()
    local _____7EA2_53F6ID = GetHandleId(attacker)
    local _____76EE_6807_51B7_5374_8868 = _____7834_7EFD_65A9_51B7_5374_8868[_____7EA2_53F6ID]
    if _____76EE_6807_51B7_5374_8868 == nil then
        _____76EE_6807_51B7_5374_8868 = {}
        _____7834_7EFD_65A9_51B7_5374_8868[_____7EA2_53F6ID] = _____76EE_6807_51B7_5374_8868
    end
    if _____73B0_5728 < (_____76EE_6807_51B7_5374_8868[id] or 0) then
        return
    end
    local _____8FFD_52A0_4F24_5BB3 = applied * _____6731_96C0_9662_7EA2_53F6_88AB_52A8_914D_7F6E["破绽斩伤害倍率"]
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = attacker,
        ["目标"] = target,
        ["伤害"] = _____8FFD_52A0_4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = 0,
        ["标签"] = "朱雀院红叶-破绽斩",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false
    })
    if _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["破绽斩特效"] ~= nil and _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["破绽斩特效"] ~= "" then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["破绽斩特效"],
            X = jass:GetUnitX(target),
            Y = jass:GetUnitY(target),
            Z = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["参数"]["破绽斩"]["高度"],
            ["缩放"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["参数"]["破绽斩"]["缩放"],
            ["持续秒"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["参数"]["破绽斩"]["持续秒"]
        })
    end
    _____76EE_6807_51B7_5374_8868[id] = _____73B0_5728 + _____6731_96C0_9662_7EA2_53F6_88AB_52A8_914D_7F6E["破绽斩内部冷却秒"]
    ____exports["移除目标破绽"](target)
    ____exports["增加刀势"](attacker, 1)
    do
        local i = 0
        while i < #_____7834_7EFD_65A9_76D1_542C_5217_8868 do
            _____7834_7EFD_65A9_76D1_542C_5217_8868[i + 1](attacker, target)
            i = i + 1
        end
    end
end
local _____5DF2_6CE8_518C = false
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____786E_4FDD_6B7B_4EA1_6E05_7406()
    if _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(function(dyingUnit, _killingUnit)
        if dyingUnit == nil or dyingUnit == 0 then
            return
        end
        local id = GetHandleId(dyingUnit)
        if _____7834_7EFD_76EE_6807_8868[id] ~= nil then
            ____exports["移除目标破绽"](dyingUnit)
        end
        for _____7EA2_53F6ID in pairs(_____7834_7EFD_65A9_51B7_5374_8868) do
            local _____76EE_6807_51B7_5374_8868 = _____7834_7EFD_65A9_51B7_5374_8868[_____7EA2_53F6ID]
            if _____76EE_6807_51B7_5374_8868 ~= nil then
                __TS__Delete(_____76EE_6807_51B7_5374_8868, id)
            end
        end
        if ____exports["是朱雀院红叶"](dyingUnit) then
            __TS__Delete(_____7834_7EFD_65A9_51B7_5374_8868, id)
            ____exports["清理朱雀院红叶状态"](dyingUnit, "英雄死亡")
        end
    end)
end
--- 注册朱雀院红叶被动（普攻破绽斩 + 死亡清理；幂等）
____exports["注册朱雀院红叶被动"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____786E_4FDD_6B7B_4EA1_6E05_7406()
    registerAppliedFinalDamageListener(_____5904_7406_7EA2_53F6_666E_653B_7834_7EFD_65A9)
end
____exports["朱雀院红叶被动模块"] = {["英雄ID"] = _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E["单位类型ID"], ["已注册"] = false, ["注册"] = ____exports["注册朱雀院红叶被动"]}
--- 播放红叶施法动作（接收动作槽，索引/持续秒全部配置驱动；0 跳过），持续后恢复 stand；随英雄清理移除恢复回调
____exports["播放红叶动作"] = function(_____82F1_96C4, _____69FD)
    local _____52A8_4F5C_7D22_5F15 = _____69FD["索引"]
    local _____6301_7EED_79D2 = _____69FD["持续秒"]
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____52A8_4F5C_7D22_5F15 <= 0 then
        return
    end
    jass:SetUnitAnimationByIndex(_____82F1_96C4, _____52A8_4F5C_7D22_5F15)
    if _____6301_7EED_79D2 > 0 then
        local _____6062_590DID = addDelayedCallback(
            _____6301_7EED_79D2 * 1000,
            function()
                if _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                    jass:SetUnitAnimation(_____82F1_96C4, "stand")
                end
            end
        )
        ____exports["登记朱雀院清理"](
            _____82F1_96C4,
            "红叶动作-" .. tostring(_____52A8_4F5C_7D22_5F15),
            function()
                removeDelayedCallback(_____6062_590DID)
            end
        )
    end
end
return ____exports
