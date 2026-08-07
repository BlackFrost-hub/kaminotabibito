--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.00．配置")
local _____5229_5C14_4F2F_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["利尔伯特单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.01．运行时")
local _____83B7_53D6_6216_521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6["获取或创建利尔伯特上下文"]
local _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6["利尔伯特单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.02．数值与表现配置")
local _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["利尔伯特技能配置"]
local ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382["创建技能提示圈"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_1["开始硬直"]
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_1["施加快速控制Buff"]
local ____require_result_2 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_2["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_2["关闭吟唱条"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_4.getEnemyUnitsInRange
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_6.EC_CreateEffect
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5229_5C14_4F2F_7279_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5229_5C14_4F2F_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____88C2_5730_65A9_6280_80FDID = stringToFourCCSafe(_____5229_5C14_4F2F_7279_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["裂地斩"])
local _____88C2_5730_65A9_5DF2_6CE8_518C = false
local function _____64AD_653E_88C2_5730_65A9_70B9_7279_6548(_____7279_6548, x, y)
    EC_CreateEffect(
        _____7279_6548["路径"],
        x,
        y,
        _____7279_6548.Z,
        _____7279_6548["朝向"],
        _____7279_6548["缩放"],
        _____7279_6548["动画速度"],
        _____7279_6548["持续秒"]
    )
end
local function ____on_88C2_5730_65A9_7ED3_7B97(variable)
    local _____5FEB_7167 = variable
    if _____5FEB_7167 == nil or not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(_____5FEB_7167["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____5FEB_7167["上下文"]["Boss单位"]
    local _____914D_7F6E = _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["裂地斩"]
    do
        local i = 0
        while i < #_____5FEB_7167["落点列表"] do
            local _____843D_70B9 = _____5FEB_7167["落点列表"][i + 1]
            _____64AD_653E_88C2_5730_65A9_70B9_7279_6548(_____914D_7F6E["命中特效"], _____843D_70B9.X, _____843D_70B9.Y)
            _____64AD_653E_88C2_5730_65A9_70B9_7279_6548(_____914D_7F6E["爆炸特效"], _____843D_70B9.X, _____843D_70B9.Y)
            local _____76EE_6807_5217_8868 = getEnemyUnitsInRange(boss, _____843D_70B9.X, _____843D_70B9.Y, _____914D_7F6E["作用半径"])
            do
                local j = 0
                while j < #_____76EE_6807_5217_8868 do
                    local _____76EE_6807 = _____76EE_6807_5217_8868[j + 1]
                    local _____7ED3_679C = _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                        ["来源"] = boss,
                        ["目标"] = _____76EE_6807,
                        ["技能ID"] = _____88C2_5730_65A9_6280_80FDID,
                        ["伤害公式"] = {["来源攻击力比例"] = _____914D_7F6E["Boss攻击力比例"]},
                        attack = true,
                        ranged = false,
                        attackType = ATTACK_TYPE_NORMAL,
                        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                        weaponType = WEAPON_TYPE_WHOKNOWS,
                        ["标签"] = "利尔·伯特·裂地斩"
                    })
                    if _____7ED3_679C["是否造成伤害"] then
                        _____65BD_52A0_5FEB_901F_63A7_5236Buff(
                            boss,
                            _____76EE_6807,
                            0,
                            _____914D_7F6E["眩晕秒"],
                            "利尔·伯特-裂地斩",
                            "技能"
                        )
                    end
                    j = j + 1
                end
            end
            i = i + 1
        end
    end
    _____5173_95ED_541F_5531_6761(_____914D_7F6E["读条通道"])
end
____exports["释放利尔伯特裂地斩"] = function(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(boss) then
        return false
    end
    local _____914D_7F6E = _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["裂地斩"]
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    local _____76EE_6807_5217_8868 = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local _____641C_7D22_534A_5F84_5E73_65B9 = _____914D_7F6E["搜索半径"] * _____914D_7F6E["搜索半径"]
    local _____843D_70B9_5217_8868 = {}
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            do
                local _____76EE_6807 = _____76EE_6807_5217_8868[i + 1]
                local X = GetUnitX(_____76EE_6807)
                local Y = GetUnitY(_____76EE_6807)
                local dx = X - bossX
                local dy = Y - bossY
                if dx * dx + dy * dy > _____641C_7D22_534A_5F84_5E73_65B9 then
                    goto __continue13
                end
                _____843D_70B9_5217_8868[#_____843D_70B9_5217_8868 + 1] = {X = X, Y = Y}
            end
            ::__continue13::
            i = i + 1
        end
    end
    if #_____843D_70B9_5217_8868 <= 0 then
        return false
    end
    _____5F00_59CB_786C_76F4(boss, _____914D_7F6E["施法硬直秒"])
    SetUnitAnimationByIndex(boss, _____914D_7F6E["动作编号"])
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____914D_7F6E["施法硬直秒"],
        ["颜色ID"] = _____914D_7F6E["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
    do
        local i = 0
        while i < #_____843D_70B9_5217_8868 do
            local _____843D_70B9 = _____843D_70B9_5217_8868[i + 1]
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "敌方圆形",
                X = _____843D_70B9.X,
                Y = _____843D_70B9.Y,
                ["半径"] = _____914D_7F6E["作用半径"],
                ["持续时间"] = _____914D_7F6E["预警秒"],
                ["来源单位"] = boss
            })
            _____64AD_653E_88C2_5730_65A9_70B9_7279_6548(_____914D_7F6E["起始特效"], _____843D_70B9.X, _____843D_70B9.Y)
            _____64AD_653E_88C2_5730_65A9_70B9_7279_6548(_____914D_7F6E["预警特效"], _____843D_70B9.X, _____843D_70B9.Y)
            i = i + 1
        end
    end
    local _____5FEB_7167 = {["上下文"] = _____4E0A_4E0B_6587, ["落点列表"] = _____843D_70B9_5217_8868}
    local _____56DE_8C03ID = addDelayedCallback(_____914D_7F6E["预警秒"] * 1000, ____on_88C2_5730_65A9_7ED3_7B97, _____5FEB_7167)
    local ____self_10 = _____4E0A_4E0B_6587["清理"]
    ____self_10["登记延迟回调"](____self_10, "裂地斩结算", _____56DE_8C03ID)
    return true
end
local function ____on_5229_5C14_4F2F_7279_88C2_5730_65A9_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____88C2_5730_65A9_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____5229_5C14_4F2F_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587(castingUnit)
    if _____4E0A_4E0B_6587 ~= nil then
        ____exports["释放利尔伯特裂地斩"](_____4E0A_4E0B_6587)
    end
end
____exports["注册利尔伯特裂地斩"] = function()
    if _____88C2_5730_65A9_5DF2_6CE8_518C then
        return
    end
    _____88C2_5730_65A9_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_5229_5C14_4F2F_7279_88C2_5730_65A9_751F_6548)
end
return ____exports
