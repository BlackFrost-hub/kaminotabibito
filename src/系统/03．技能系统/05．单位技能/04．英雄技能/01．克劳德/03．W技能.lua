local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____W_79FB_52A8_5355_4F4D, _____83B7_53D6_5355_4F4DX, _____83B7_53D6_5355_4F4DY, _____8BBE_7F6E_5355_4F4DX, _____8BBE_7F6E_5355_4F4DY, _____5224_65AD_5730_5F62, _____8BA1_7B97_4F59_5F26, _____8BA1_7B97_6B63_5F26, _____89D2_5EA6_8F6C_5F27_5EA6, _____53EF_884C_8D70_7C7B_578B
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.01．克劳德.00．配置")
local _____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["克劳德单位技能配置"]
local ____00A_FF0E_8054_52A8_72B6_6001 = require("系统.03．技能系统.05．单位技能.04．英雄技能.01．克劳德.00A．联动状态")
local _____6E05_7406_7A7A_7259Q_8054_52A8 = ____00A_FF0E_8054_52A8_72B6_6001["清理空牙Q联动"]
local _____8BFB_53D6_51F6_65A9_547D_4E2D = ____00A_FF0E_8054_52A8_72B6_6001["读取凶斩命中"]
local _____8BBE_7F6E_7A7A_7259Q_8054_52A8 = ____00A_FF0E_8054_52A8_72B6_6001["设置空牙Q联动"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
function ____W_79FB_52A8_5355_4F4D(unit, angle, distance, _____68C0_67E5_5730_5F62)
    if _____68C0_67E5_5730_5F62 == nil then
        _____68C0_67E5_5730_5F62 = true
    end
    if unit == nil or unit == 0 or not _____5355_4F4D_5B58_6D3B(unit) then
        return false
    end
    local x = _____83B7_53D6_5355_4F4DX(unit) + _____8BA1_7B97_4F59_5F26(angle * _____89D2_5EA6_8F6C_5F27_5EA6) * distance
    local y = _____83B7_53D6_5355_4F4DY(unit) + _____8BA1_7B97_6B63_5F26(angle * _____89D2_5EA6_8F6C_5F27_5EA6) * distance
    if not _____68C0_67E5_5730_5F62 or not _____5224_65AD_5730_5F62(x, y, _____53EF_884C_8D70_7C7B_578B) then
        _____8BBE_7F6E_5355_4F4DX(unit, x)
        _____8BBE_7F6E_5355_4F4DY(unit, y)
        return true
    end
    return false
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_1["减少魔法值"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_3["开始冲锋"]
local _____505C_6B62_4F4D_79FB = ____require_result_3["停止位移"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_5["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_5["移除单位暂停"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
local _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6 = ____require_result_6["确保单位可设置飞行高度"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_7["获取范围敌军"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_9["创建单位并登记排泄安全"]
local ____require_result_10 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_10["立即移除单位并取消排泄登记"]
local ____require_result_11 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_11.registerDeathListener
local ____require_result_12 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_12.stringToFourCCSafe
local ____require_result_13 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_13.debugLogForce
local _____6A21_5757_540D = "克劳德-W"
local jglobals = require("jass.globals")
local ____require_result_14 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundOnUnitBJ = ____require_result_14.PlaySoundOnUnitBJ
local _____83B7_53D6_53E5_67C4ID = jass.GetHandleId
local _____83B7_53D6_5355_4F4D_7C7B_578BID = jass.GetUnitTypeId
_____83B7_53D6_5355_4F4DX = jass.GetUnitX
_____83B7_53D6_5355_4F4DY = jass.GetUnitY
local _____83B7_53D6_5355_4F4D_9762_5411 = jass.GetUnitFacing
local _____83B7_53D6_968F_673A_5B9E_6570 = jass.GetRandomReal
local _____83B7_53D6_5355_4F4DZ = jass.GetUnitFlyHeight
_____8BBE_7F6E_5355_4F4DX = jass.SetUnitX
_____8BBE_7F6E_5355_4F4DY = jass.SetUnitY
local _____8BBE_7F6E_5355_4F4DZ = jass.SetUnitFlyHeight
local _____83B7_53D6_9ED8_8BA4_9AD8_5EA6 = jass.GetUnitDefaultFlyHeight
local _____8BBE_7F6E_52A8_4F5C = jass.SetUnitAnimationByIndex
local _____8BBE_7F6E_52A8_4F5C_540D = jass.SetUnitAnimation
local _____8BBE_7F6E_65F6_95F4_6D41_901F = jass.SetUnitTimeScale
local _____8BBE_7F6E_6280_80FD_53EF_7528 = jass.SetPlayerAbilityAvailable
local _____6DFB_52A0_6280_80FD = jass.UnitAddAbility
local _____79FB_9664_6280_80FD = jass.UnitRemoveAbility
local _____83B7_53D6_5355_4F4D_62E5_6709_8005 = jass.GetOwningPlayer
local _____83B7_53D6_6280_80FD_76EE_6807X = jass.GetSpellTargetX
local _____83B7_53D6_6280_80FD_76EE_6807Y = jass.GetSpellTargetY
local _____83B7_53D6_5355_4F4D_72B6_6001 = jass.GetUnitState
local _____5224_65AD_654C_4EBA = jass.IsUnitEnemy
local _____5224_65AD_7C7B_578B = jass.IsUnitType
_____5224_65AD_5730_5F62 = jass.IsTerrainPathable
_____8BA1_7B97_4F59_5F26 = jass.Cos
_____8BA1_7B97_6B63_5F26 = jass.Sin
local _____8BA1_7B97_53CD_6B63_5207 = jass.Atan2
_____89D2_5EA6_8F6C_5F27_5EA6 = jass.bj_DEGTORAD
local _____5F27_5EA6_8F6C_89D2_5EA6 = jass.bj_RADTODEG
local _____6700_5927_751F_547D_72B6_6001 = jass.UNIT_STATE_MAX_LIFE
local _____5F53_524D_751F_547D_72B6_6001 = jass.UNIT_STATE_LIFE
local _____6700_5927_9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MAX_MANA
local _____5F53_524D_9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MANA
local _____53E4_6811_7C7B_578B = jass.UNIT_TYPE_ANCIENT
local _____673A_68B0_7C7B_578B = jass.UNIT_TYPE_MECHANICAL
_____53EF_884C_8D70_7C7B_578B = jass.PATHING_TYPE_WALKABILITY
local _____653B_51FB_7C7B_578B = jass.ATTACK_TYPE_NORMAL
local _____7269_7406_4F24_5BB3_7C7B_578B = jass.DAMAGE_TYPE_NORMAL
local _____5F3A_5316_4F24_5BB3_7C7B_578B = jass.DAMAGE_TYPE_ENHANCED
local _____914D_7F6E = _____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E.W
local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____521D_6BB5_6280_80FDID = stringToFourCCSafe(_____914D_7F6E["初段技能ID"])
local _____4E8C_6BB5_6280_80FDID = stringToFourCCSafe(_____914D_7F6E["二段技能ID"])
local _____4E09_6BB5_6280_80FDID = stringToFourCCSafe(_____914D_7F6E["三段技能ID"])
local _____51B2_950B_7279_6548A_5355_4F4DID = stringToFourCCSafe(_____914D_7F6E["冲锋特效A单位ID"])
local _____51B2_950B_7279_6548B_5355_4F4DID = stringToFourCCSafe(_____914D_7F6E["冲锋特效B单位ID"])
local _____4E8C_6BB5_5200_5149_5355_4F4DID = stringToFourCCSafe(_____914D_7F6E["二段刀光单位ID"])
local _____547D_4E2D_5200_5149_5355_4F4DID = stringToFourCCSafe(_____914D_7F6E["命中刀光单位ID"])
local _____6765_6E90_524D_7F00 = "克劳德-W"
local _____91D1_5C5E_91CD_65A9_6B66_5668_7C7B_578B = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local function _____64AD_653EW_97F3_6548(caster, key)
    local sound = jglobals[key]
    if sound ~= nil then
        PlaySoundOnUnitBJ(sound, 100, caster)
    end
end
local function _____79FB_9664W_8868_73B0_5355_4F4D(variable)
    local record = variable
    if record == nil or record["已移除"] then
        return
    end
    record["已移除"] = true
    if record["单位"] ~= nil and record["单位"] ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(nil, record["单位"])
    end
end
local function _____521B_5EFAW_8868_73B0_5355_4F4D(owner, unitTypeId, x, y, facing, duration)
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        unitTypeId,
        x,
        y,
        facing
    )
    if unit == nil or unit == 0 then
        return nil
    end
    local record = {["单位"] = unit, ["已移除"] = false}
    if duration > 0 then
        addDelayedCallback(duration * 1000, _____79FB_9664W_8868_73B0_5355_4F4D, record)
    end
    return record
end
local function _____8BBE_7F6EW_8868_73B0_5355_4F4D_9AD8_5EA6(record, height)
    if record == nil or record["已移除"] or record["单位"] == nil or record["单位"] == 0 then
        return
    end
    _____8BBE_7F6E_5355_4F4DZ(record["单位"], height, 0)
end
local _____72B6_6001_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAW_72B6_6001(unit)
    local id = _____83B7_53D6_53E5_67C4ID(unit)
    local state = _____72B6_6001_8868[id]
    if state == nil then
        state = {
            ["施法者"] = unit,
            ["阶段"] = 0,
            ["进行中"] = false,
            ["等待输入"] = false,
            ["方向角"] = 0,
            ["目标X"] = 0,
            ["目标Y"] = 0,
            ["位移ID"] = 0,
            ["周期ID"] = 0,
            ["Tick数"] = 0,
            ["命中目标"] = {},
            ["冲锋特效A"] = nil,
            ["冲锋特效B"] = nil,
            ["冲锋特效周期ID"] = 0,
            ["冲锋特效Tick数"] = 0
        }
        _____72B6_6001_8868[id] = state
    end
    return state
end
local function _____76EE_6807_5408_6CD5(caster, target)
    return target ~= nil and target ~= 0 and _____5355_4F4D_5B58_6D3B(target) and target ~= caster and _____5224_65AD_654C_4EBA(
        target,
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster)
    ) and not _____5224_65AD_7C7B_578B(target, _____53E4_6811_7C7B_578B) and not _____5224_65AD_7C7B_578B(target, _____673A_68B0_7C7B_578B)
end
local function _____76EE_6807_672A_547D_4E2D(state, target)
    local targetId = _____83B7_53D6_53E5_67C4ID(target)
    for ____, old in ipairs(state["命中目标"]) do
        if _____83B7_53D6_53E5_67C4ID(old) == targetId then
            return false
        end
    end
    return true
end
local function _____9020_6210W_4F24_5BB3(state, target, _____500D_7387)
    local caster = state["施法者"]
    if not _____76EE_6807_5408_6CD5(caster, target) then
        return
    end
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标"] = target,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____500D_7387,
        ["伤害类型"] = _____7269_7406_4F24_5BB3_7C7B_578B,
        attack = true,
        ranged = false,
        attackType = _____653B_51FB_7C7B_578B,
        weaponType = _____91D1_5C5E_91CD_65A9_6B66_5668_7C7B_578B,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____521D_6BB5_6280_80FDID,
        ["技能实例ID"] = state["技能实例ID"],
        ["标签"] = ((_____6765_6E90_524D_7F00 .. "-") .. tostring(state["阶段"] + 1)) .. "段"
    })
    if state["阶段"] == 2 and _____8BFB_53D6_51F6_65A9_547D_4E2D(caster, target) then
        local maxLife = _____83B7_53D6_5355_4F4D_72B6_6001(target, _____6700_5927_751F_547D_72B6_6001) or 0
        local currentLife = _____83B7_53D6_5355_4F4D_72B6_6001(target, _____5F53_524D_751F_547D_72B6_6001) or 0
        local lostLife = maxLife > currentLife and maxLife - currentLife or 0
        if lostLife > 0 then
            _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                ["来源"] = caster,
                ["目标"] = target,
                ["伤害"] = lostLife * _____914D_7F6E["凶斩联动已损失生命比例"],
                ["伤害类型"] = _____5F3A_5316_4F24_5BB3_7C7B_578B,
                attack = true,
                ranged = false,
                attackType = _____653B_51FB_7C7B_578B,
                ["来源类型"] = "单位技能",
                ["技能ID"] = _____521D_6BB5_6280_80FDID,
                ["技能实例ID"] = state["技能实例ID"],
                ["标签"] = "克劳德-W-凶斩联动强化伤害"
            })
        end
    end
end
local function ____W_521D_6BB5_547D_4E2D_8FC7_6EE4(movingUnit, target, _moveId)
    local state = _____72B6_6001_8868[_____83B7_53D6_53E5_67C4ID(movingUnit)]
    return state ~= nil and state["阶段"] == 0 and _____76EE_6807_5408_6CD5(movingUnit, target) and _____76EE_6807_672A_547D_4E2D(state, target)
end
local function ____W_521D_6BB5_547D_4E2D(movingUnit, target, _moveId)
    local state = _____72B6_6001_8868[_____83B7_53D6_53E5_67C4ID(movingUnit)]
    if state == nil or not _____76EE_6807_5408_6CD5(movingUnit, target) or not _____76EE_6807_672A_547D_4E2D(state, target) then
        return
    end
    local ____state__547D_4E2D_76EE_6807_15 = state["命中目标"]
    ____state__547D_4E2D_76EE_6807_15[#____state__547D_4E2D_76EE_6807_15 + 1] = target
    _____9020_6210W_4F24_5BB3(state, target, _____914D_7F6E["初段伤害倍率"])
    _____65BD_52A0_7729_6655(
        movingUnit,
        target,
        _____914D_7F6E["初段控制秒"],
        _____6765_6E90_524D_7F00 .. "-初段硬直",
        "技能"
    )
    _____8BBE_7F6E_52A8_4F5C_540D(target, "Death")
end
local function _____6E05_7406W_4E00_6BB5_8868_73B0(state)
    if state["冲锋特效周期ID"] ~= 0 then
        removePeriodicCallback(state["冲锋特效周期ID"])
        state["冲锋特效周期ID"] = 0
    end
    _____79FB_9664W_8868_73B0_5355_4F4D(state["冲锋特效A"])
    _____79FB_9664W_8868_73B0_5355_4F4D(state["冲锋特效B"])
    state["冲锋特效A"] = nil
    state["冲锋特效B"] = nil
    state["冲锋特效Tick数"] = 0
end
local function _____505C_6B62W_4E00_6BB5_8868_73B0_8DDF_968F(state)
    if state["冲锋特效周期ID"] ~= 0 then
        removePeriodicCallback(state["冲锋特效周期ID"])
        state["冲锋特效周期ID"] = 0
    end
    state["冲锋特效A"] = nil
    state["冲锋特效B"] = nil
    state["冲锋特效Tick数"] = 0
end
local function ____W_4E09_6BB5_76EE_6807_9AD8_5EA6_6062_590D(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil then
        return
    end
    for ____, target in ipairs(_____53C2_6570["目标列表"]) do
        if _____5355_4F4D_5B58_6D3B(target) then
            _____8BBE_7F6E_5355_4F4DZ(
                target,
                _____83B7_53D6_9ED8_8BA4_9AD8_5EA6(target),
                0
            )
        end
    end
end
local function _____6E05_7406W_58F3(caster)
    local owner = _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster)
    _____8BBE_7F6E_6280_80FD_53EF_7528(owner, _____521D_6BB5_6280_80FDID, true)
    _____79FB_9664_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
    _____79FB_9664_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
end
local function _____6E05_7406W_72B6_6001(state, _____76EE_6807_9AD8_5EA6_6062_590D_5EF6_8FDF_79D2)
    if _____76EE_6807_9AD8_5EA6_6062_590D_5EF6_8FDF_79D2 == nil then
        _____76EE_6807_9AD8_5EA6_6062_590D_5EF6_8FDF_79D2 = 0
    end
    local caster = state["施法者"]
    debugLogForce(
        _____6A21_5757_540D,
        "清理W状态",
        "施法者",
        (caster == nil or caster == 0) and "nil" or _____83B7_53D6_53E5_67C4ID(caster),
        "阶段",
        state["阶段"],
        "位移ID",
        state["位移ID"],
        "周期ID",
        state["周期ID"],
        "Tick数",
        state["Tick数"]
    )
    if state["位移ID"] ~= 0 then
        _____505C_6B62_4F4D_79FB(state["位移ID"], "中断")
        state["位移ID"] = 0
    end
    if state["周期ID"] ~= 0 then
        removePeriodicCallback(state["周期ID"])
        state["周期ID"] = 0
    end
    _____6E05_7406W_4E00_6BB5_8868_73B0(state)
    if caster ~= nil and caster ~= 0 then
        _____6E05_7406_7A7A_7259Q_8054_52A8(caster)
        _____79FB_9664_5355_4F4D_6682_505C(caster, _____6765_6E90_524D_7F00 .. "-自身")
        _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, 1)
        _____8BBE_7F6E_5355_4F4DZ(
            caster,
            _____83B7_53D6_9ED8_8BA4_9AD8_5EA6(caster),
            0
        )
        _____6E05_7406W_58F3(caster)
    end
    if _____76EE_6807_9AD8_5EA6_6062_590D_5EF6_8FDF_79D2 > 0 then
        local _____76EE_6807_5217_8868 = {}
        for ____, target in ipairs(state["命中目标"]) do
            do
                if not _____5355_4F4D_5B58_6D3B(target) then
                    goto __continue41
                end
                _____8BBE_7F6E_5355_4F4DZ(target, 0, 0)
                _____76EE_6807_5217_8868[#_____76EE_6807_5217_8868 + 1] = target
            end
            ::__continue41::
        end
        if #_____76EE_6807_5217_8868 > 0 then
            local _____53C2_6570 = {["目标列表"] = _____76EE_6807_5217_8868}
            addDelayedCallback(_____76EE_6807_9AD8_5EA6_6062_590D_5EF6_8FDF_79D2 * 1000, ____W_4E09_6BB5_76EE_6807_9AD8_5EA6_6062_590D, _____53C2_6570)
        end
    else
        for ____, target in ipairs(state["命中目标"]) do
            if _____5355_4F4D_5B58_6D3B(target) then
                _____8BBE_7F6E_5355_4F4DZ(
                    target,
                    _____83B7_53D6_9ED8_8BA4_9AD8_5EA6(target),
                    0
                )
            end
        end
    end
    state["进行中"] = false
    state["等待输入"] = false
    state["阶段"] = 0
    state["Tick数"] = 0
    state["命中目标"] = {}
    if caster ~= nil and caster ~= 0 then
        local id = _____83B7_53D6_53E5_67C4ID(caster)
        if _____72B6_6001_8868[id] == state then
            __TS__Delete(_____72B6_6001_8868, id)
        end
    end
end
local function ____W_4E8C_6BB5_7A97_53E3_8D85_65F6(state)
    debugLogForce(
        _____6A21_5757_540D,
        "W二段窗口超时",
        "进行中",
        state and state["进行中"],
        "等待输入",
        state and state["等待输入"],
        "阶段",
        state and state["阶段"]
    )
    if state ~= nil and state["进行中"] and state["等待输入"] and state["阶段"] == 0 then
        _____6E05_7406W_72B6_6001(state)
    end
end
local function ____W_4E09_6BB5_7A97_53E3_8D85_65F6(state)
    debugLogForce(
        _____6A21_5757_540D,
        "W三段窗口超时",
        "进行中",
        state and state["进行中"],
        "等待输入",
        state and state["等待输入"],
        "阶段",
        state and state["阶段"]
    )
    if state ~= nil and state["进行中"] and state["等待输入"] and state["阶段"] == 1 then
        _____6E05_7406W_72B6_6001(state)
    end
end
local function ____W_521D_6BB5_7ED3_675F(caster, _reason, _moveId)
    local state = _____72B6_6001_8868[_____83B7_53D6_53E5_67C4ID(caster)]
    debugLogForce(
        _____6A21_5757_540D,
        "W初段结束",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "原因",
        _reason,
        "状态存在",
        state ~= nil,
        "进行中",
        state and state["进行中"],
        "阶段",
        state and state["阶段"]
    )
    if state == nil or not state["进行中"] or state["阶段"] ~= 0 then
        return
    end
    state["位移ID"] = 0
    if _reason ~= "完成" and _reason ~= "撞墙" then
        _____6E05_7406W_72B6_6001(state)
        return
    end
    _____505C_6B62W_4E00_6BB5_8868_73B0_8DDF_968F(state)
    state["等待输入"] = true
    _____79FB_9664_5355_4F4D_6682_505C(caster, _____6765_6E90_524D_7F00 .. "-自身")
    _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, 1)
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____521D_6BB5_6280_80FDID,
        false
    )
    _____6DFB_52A0_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
    addDelayedCallback(_____914D_7F6E["二段窗口秒"] * 1000, ____W_4E8C_6BB5_7A97_53E3_8D85_65F6, state)
end
local function _____8BBE_7F6EW_8868_73B0_5355_4F4D_4F4D_7F6E(record, x, y)
    if record == nil or record["已移除"] or record["单位"] == nil or record["单位"] == 0 then
        return
    end
    _____8BBE_7F6E_5355_4F4DX(record["单位"], x)
    _____8BBE_7F6E_5355_4F4DY(record["单位"], y)
end
local function ____W_4E00_6BB5_8868_73B0_5E27(state, _____540C_6B65_7279_6548_4F4D_7F6E)
    if not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        return
    end
    state["冲锋特效Tick数"] = state["冲锋特效Tick数"] + 1
    local caster = state["施法者"]
    local casterX = _____83B7_53D6_5355_4F4DX(caster)
    local casterY = _____83B7_53D6_5355_4F4DY(caster)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["沿途爆炸模型"],
        X = casterX,
        Y = casterY,
        Z = _____83B7_53D6_5355_4F4DZ(caster),
        ["持续秒"] = _____914D_7F6E["沿途爆炸持续秒"]
    })
    if _____540C_6B65_7279_6548_4F4D_7F6E then
        local radians = state["方向角"] * _____89D2_5EA6_8F6C_5F27_5EA6
        local effectX = casterX + _____8BA1_7B97_4F59_5F26(radians) * _____914D_7F6E["冲锋特效起点偏移"]
        local effectY = casterY + _____8BA1_7B97_6B63_5F26(radians) * _____914D_7F6E["冲锋特效起点偏移"]
        _____8BBE_7F6EW_8868_73B0_5355_4F4D_4F4D_7F6E(state["冲锋特效A"], effectX, effectY)
        _____8BBE_7F6EW_8868_73B0_5355_4F4D_4F4D_7F6E(state["冲锋特效B"], effectX, effectY)
    end
    for ____, target in ipairs(state["命中目标"]) do
        do
            if not _____5355_4F4D_5B58_6D3B(target) then
                goto __continue63
            end
            ____W_79FB_52A8_5355_4F4D(target, state["方向角"], _____914D_7F6E["冲锋特效每Tick距离"], false)
        end
        ::__continue63::
    end
end
local function ____W_4E00_6BB5_8868_73B0Tick(variable)
    local state = variable
    if state == nil or not state["进行中"] or state["阶段"] ~= 0 or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        if state ~= nil then
            _____6E05_7406W_4E00_6BB5_8868_73B0(state)
        end
        return
    end
    ____W_4E00_6BB5_8868_73B0_5E27(state, true)
end
local function _____542F_52A8W_4E00_6BB5_8868_73B0(state)
    local caster = state["施法者"]
    local radians = state["方向角"] * _____89D2_5EA6_8F6C_5F27_5EA6
    local x = _____83B7_53D6_5355_4F4DX(caster) + _____8BA1_7B97_4F59_5F26(radians) * _____914D_7F6E["冲锋特效起点偏移"]
    local y = _____83B7_53D6_5355_4F4DY(caster) + _____8BA1_7B97_6B63_5F26(radians) * _____914D_7F6E["冲锋特效起点偏移"]
    local owner = _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster)
    state["冲锋特效A"] = _____521B_5EFAW_8868_73B0_5355_4F4D(
        owner,
        _____51B2_950B_7279_6548A_5355_4F4DID,
        x,
        y,
        state["方向角"],
        _____914D_7F6E["冲锋特效持续秒"]
    )
    state["冲锋特效B"] = _____521B_5EFAW_8868_73B0_5355_4F4D(
        owner,
        _____51B2_950B_7279_6548B_5355_4F4DID,
        x,
        y,
        state["方向角"],
        _____914D_7F6E["冲锋特效持续秒"]
    )
    _____8BBE_7F6EW_8868_73B0_5355_4F4D_9AD8_5EA6(
        state["冲锋特效A"],
        _____83B7_53D6_5355_4F4DZ(caster)
    )
    _____8BBE_7F6EW_8868_73B0_5355_4F4D_9AD8_5EA6(
        state["冲锋特效B"],
        _____83B7_53D6_5355_4F4DZ(caster)
    )
    state["冲锋特效Tick数"] = 0
    state["冲锋特效周期ID"] = addPeriodicCallback(_____914D_7F6E["二段周期秒"] * 1000, ____W_4E00_6BB5_8868_73B0Tick, state)
end
local function ____W_4E00_6BB5_542F_52A8(state)
    if not state["进行中"] or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        debugLogForce(
            _____6A21_5757_540D,
            "W一段启动 前置不满足 清理",
            "进行中",
            state["进行中"],
            "施法者存活",
            _____5355_4F4D_5B58_6D3B(state["施法者"])
        )
        _____6E05_7406W_72B6_6001(state)
        return
    end
    _____64AD_653EW_97F3_6548(state["施法者"], _____914D_7F6E["初段音效键"])
    _____79FB_9664_5355_4F4D_6682_505C(state["施法者"], _____6765_6E90_524D_7F00 .. "-自身")
    _____542F_52A8W_4E00_6BB5_8868_73B0(state)
    state["位移ID"] = _____5F00_59CB_51B2_950B(state["施法者"], {
        ["角度"] = state["方向角"],
        ["距离"] = _____914D_7F6E["冲锋距离"],
        ["持续时间"] = _____914D_7F6E["冲锋持续秒"],
        ["检查地形"] = true,
        ["朝向跟随位移"] = true,
        ["暂停单位"] = true,
        ["禁用碰撞"] = true,
        ["命中半径"] = _____914D_7F6E["碰撞半径"],
        ["只命中敌人"] = true,
        ["允许重复命中"] = false,
        ["命中后结束"] = false,
        ["命中过滤"] = ____W_521D_6BB5_547D_4E2D_8FC7_6EE4,
        ["命中回调"] = ____W_521D_6BB5_547D_4E2D,
        ["结束回调"] = ____W_521D_6BB5_7ED3_675F,
        ["位移特效"] = "",
        ["附加位移特效"] = "",
        ["动画名"] = _____914D_7F6E["初段动作名"]
    })
    debugLogForce(
        _____6A21_5757_540D,
        "W一段启动 冲锋创建",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(state["施法者"]),
        "位移ID",
        state["位移ID"],
        "方向角",
        state["方向角"],
        "距离",
        _____914D_7F6E["冲锋距离"]
    )
    if state["位移ID"] == 0 then
        _____6E05_7406W_72B6_6001(state)
    end
end
local function ____W_4E8C_6BB5Tick(variable)
    local state = variable
    if state == nil or not state["进行中"] or state["阶段"] ~= 1 or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        local ____debugLogForce_40 = debugLogForce
        local ____array_39 = __TS__SparseArrayNew(
            _____6A21_5757_540D,
            "W二段Tick 前置不满足",
            "状态存在",
            state ~= nil,
            "进行中",
            state and state["进行中"],
            "阶段",
            state and state["阶段"],
            "施法者存活"
        )
        local ____temp_38
        if (state and state["施法者"]) == nil then
            ____temp_38 = false
        else
            ____temp_38 = _____5355_4F4D_5B58_6D3B(state["施法者"])
        end
        __TS__SparseArrayPush(____array_39, ____temp_38)
        ____debugLogForce_40(__TS__SparseArraySpread(____array_39))
        if state ~= nil then
            _____6E05_7406W_72B6_6001(state)
        end
        return
    end
    state["Tick数"] = state["Tick数"] + 1
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(state["施法者"])
    if ____W_79FB_52A8_5355_4F4D(state["施法者"], state["方向角"], _____914D_7F6E["二段移动距离"]) then
        _____8BBE_7F6E_5355_4F4DZ(
            state["施法者"],
            _____83B7_53D6_5355_4F4DZ(state["施法者"]) + _____914D_7F6E["二段升高距离"],
            0
        )
        for ____, target in ipairs(state["命中目标"]) do
            do
                if not _____5355_4F4D_5B58_6D3B(target) then
                    goto __continue80
                end
                _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(target)
                ____W_79FB_52A8_5355_4F4D(target, state["方向角"], _____914D_7F6E["二段移动距离"], false)
                _____8BBE_7F6E_5355_4F4DZ(
                    target,
                    _____83B7_53D6_5355_4F4DZ(target) + _____914D_7F6E["二段升高距离"],
                    0
                )
            end
            ::__continue80::
        end
    end
    if state["Tick数"] >= _____914D_7F6E["二段Tick数"] then
        debugLogForce(
            _____6A21_5757_540D,
            "W二段Tick 完成 进入等待三段",
            "施法者",
            _____83B7_53D6_53E5_67C4ID(state["施法者"]),
            "Tick数",
            state["Tick数"],
            "命中目标数",
            #state["命中目标"]
        )
        removePeriodicCallback(state["周期ID"])
        state["周期ID"] = 0
        state["Tick数"] = 0
        state["阶段"] = 1
        state["等待输入"] = true
        _____79FB_9664_5355_4F4D_6682_505C(state["施法者"], _____6765_6E90_524D_7F00 .. "-自身")
        _____8BBE_7F6E_65F6_95F4_6D41_901F(state["施法者"], 1)
        _____6DFB_52A0_6280_80FD(state["施法者"], _____4E09_6BB5_6280_80FDID)
        addDelayedCallback(_____914D_7F6E["三段窗口秒"] * 1000, ____W_4E09_6BB5_7A97_53E3_8D85_65F6, state)
    end
end
local function ____W_4E09_6BB5Tick(variable)
    local state = variable
    if state == nil or not state["进行中"] or state["阶段"] ~= 2 or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        local ____debugLogForce_49 = debugLogForce
        local ____array_48 = __TS__SparseArrayNew(
            _____6A21_5757_540D,
            "W三段Tick 前置不满足",
            "状态存在",
            state ~= nil,
            "进行中",
            state and state["进行中"],
            "阶段",
            state and state["阶段"],
            "施法者存活"
        )
        local ____temp_47
        if (state and state["施法者"]) == nil then
            ____temp_47 = false
        else
            ____temp_47 = _____5355_4F4D_5B58_6D3B(state["施法者"])
        end
        __TS__SparseArrayPush(____array_48, ____temp_47)
        ____debugLogForce_49(__TS__SparseArraySpread(____array_48))
        if state ~= nil then
            _____6E05_7406W_72B6_6001(state)
        end
        return
    end
    state["Tick数"] = state["Tick数"] + 1
    if ____W_79FB_52A8_5355_4F4D(state["施法者"], state["方向角"], _____914D_7F6E["二段移动距离"]) then
        _____8BBE_7F6E_5355_4F4DZ(
            state["施法者"],
            _____83B7_53D6_5355_4F4DZ(state["施法者"]) - _____914D_7F6E["三段下降距离"],
            0
        )
        for ____, target in ipairs(state["命中目标"]) do
            do
                if not _____5355_4F4D_5B58_6D3B(target) then
                    goto __continue88
                end
                ____W_79FB_52A8_5355_4F4D(target, state["方向角"], _____914D_7F6E["二段移动距离"], false)
                _____8BBE_7F6E_5355_4F4DZ(
                    target,
                    _____83B7_53D6_5355_4F4DZ(target) - _____914D_7F6E["三段下降距离"],
                    0
                )
            end
            ::__continue88::
        end
    end
    if state["Tick数"] >= _____914D_7F6E["二段Tick数"] then
        debugLogForce(
            _____6A21_5757_540D,
            "W三段Tick 完成 清理",
            "施法者",
            _____83B7_53D6_53E5_67C4ID(state["施法者"]),
            "Tick数",
            state["Tick数"]
        )
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E["三段践踏模型"],
            X = _____83B7_53D6_5355_4F4DX(state["施法者"]),
            Y = _____83B7_53D6_5355_4F4DY(state["施法者"]),
            Z = 0,
            ["缩放"] = _____914D_7F6E["三段践踏缩放"],
            ["持续秒"] = 1
        })
        _____6E05_7406W_72B6_6001(state, _____914D_7F6E["三段目标高度恢复延迟秒"])
    end
end
local function _____521B_5EFAW_9636_6BB5_5200_5149(state, _____9AD8_5EA6_504F_79FB)
    local caster = state["施法者"]
    local radians = state["方向角"] * _____89D2_5EA6_8F6C_5F27_5EA6
    local x = _____83B7_53D6_5355_4F4DX(caster) + _____8BA1_7B97_4F59_5F26(radians) * 75
    local y = _____83B7_53D6_5355_4F4DY(caster) + _____8BA1_7B97_6B63_5F26(radians) * 75
    local record = _____521B_5EFAW_8868_73B0_5355_4F4D(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____4E8C_6BB5_5200_5149_5355_4F4DID,
        x,
        y,
        state["方向角"],
        _____914D_7F6E["刀光持续秒"]
    )
    _____8BBE_7F6EW_8868_73B0_5355_4F4D_9AD8_5EA6(
        record,
        _____83B7_53D6_5355_4F4DZ(caster) + _____9AD8_5EA6_504F_79FB
    )
end
local function _____521B_5EFAW_547D_4E2D_5200_5149(caster, target)
    _____521B_5EFAW_8868_73B0_5355_4F4D(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____547D_4E2D_5200_5149_5355_4F4DID,
        _____83B7_53D6_5355_4F4DX(target),
        _____83B7_53D6_5355_4F4DY(target),
        _____83B7_53D6_968F_673A_5B9E_6570(0, 360),
        _____914D_7F6E["命中刀光持续秒"]
    )
end
local function _____6D88_8017W_540E_7EED_6BB5(caster, fixedCost)
    local maxMana = _____83B7_53D6_5355_4F4D_72B6_6001(caster, _____6700_5927_9B54_6CD5_72B6_6001) or 0
    local cost = fixedCost + maxMana * _____914D_7F6E["后续最大魔法消耗比例"]
    local currentMana = _____83B7_53D6_5355_4F4D_72B6_6001(caster, _____5F53_524D_9B54_6CD5_72B6_6001) or 0
    debugLogForce(
        _____6A21_5757_540D,
        "W后续段魔耗判断",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "固定",
        fixedCost,
        "总需求",
        cost,
        "当前蓝",
        currentMana
    )
    if cost <= 0 or currentMana < cost then
        debugLogForce(
            _____6A21_5757_540D,
            "W后续段魔耗不足 返回false",
            "总需求",
            cost,
            "当前蓝",
            currentMana
        )
        return false
    end
    _____51CF_5C11_9B54_6CD5_503C(caster, cost, false, false)
    return true
end
local function _____91CA_653EW_521D_6BB5(state, caster, skillInstanceId)
    debugLogForce(
        _____6A21_5757_540D,
        "释放W初段 进入",
        "施法者",
        caster == nil and "nil" or _____83B7_53D6_53E5_67C4ID(caster),
        "已在进行",
        state["进行中"],
        "技能实例ID",
        skillInstanceId
    )
    if state["进行中"] then
        return
    end
    _____6E05_7406W_58F3(caster)
    state["施法者"] = caster
    state["阶段"] = 0
    state["进行中"] = true
    state["等待输入"] = false
    state["目标X"] = _____83B7_53D6_6280_80FD_76EE_6807X()
    state["目标Y"] = _____83B7_53D6_6280_80FD_76EE_6807Y()
    state["方向角"] = _____8BA1_7B97_53CD_6B63_5207(
        state["目标Y"] - _____83B7_53D6_5355_4F4DY(caster),
        state["目标X"] - _____83B7_53D6_5355_4F4DX(caster)
    ) * _____5F27_5EA6_8F6C_89D2_5EA6
    debugLogForce(
        _____6A21_5757_540D,
        "释放W初段 正常路径",
        "目标X",
        state["目标X"],
        "目标Y",
        state["目标Y"],
        "方向角",
        state["方向角"]
    )
    state["技能实例ID"] = skillInstanceId
    state["命中目标"] = {}
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____6765_6E90_524D_7F00 .. "-自身")
    _____8BBE_7F6E_52A8_4F5C_540D(caster, _____914D_7F6E["初段动作名"])
    _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, _____914D_7F6E["动作时间流速"])
    addDelayedCallback(10, ____W_4E00_6BB5_542F_52A8, state)
end
local function _____91CA_653EW_4E8C_6BB5(state, caster)
    debugLogForce(
        _____6A21_5757_540D,
        "释放W二段 进入",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "进行中",
        state["进行中"],
        "等待输入",
        state["等待输入"],
        "阶段",
        state["阶段"]
    )
    if not state["进行中"] or not state["等待输入"] or state["阶段"] ~= 0 then
        return
    end
    if not _____6D88_8017W_540E_7EED_6BB5(caster, _____914D_7F6E["二段代码追加固定魔耗"]) then
        return
    end
    _____64AD_653EW_97F3_6548(caster, _____914D_7F6E["二段音效键"])
    state["等待输入"] = false
    _____79FB_9664_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
    state["阶段"] = 1
    state["Tick数"] = 0
    state["方向角"] = _____83B7_53D6_5355_4F4D_9762_5411(caster)
    local _____4E8C_6BB5_76EE_6807 = _____83B7_53D6_8303_56F4_654C_519B(
        caster,
        _____83B7_53D6_5355_4F4DX(caster),
        _____83B7_53D6_5355_4F4DY(caster),
        _____914D_7F6E["二段范围"]
    )
    state["命中目标"] = {}
    for ____, target in ipairs(_____4E8C_6BB5_76EE_6807) do
        if _____76EE_6807_5408_6CD5(caster, target) then
            local ____state__547D_4E2D_76EE_6807_50 = state["命中目标"]
            ____state__547D_4E2D_76EE_6807_50[#____state__547D_4E2D_76EE_6807_50 + 1] = target
        end
    end
    debugLogForce(
        _____6A21_5757_540D,
        "释放W二段 成功进入阶段1",
        "范围内敌军",
        #_____4E8C_6BB5_76EE_6807,
        "合法目标",
        #state["命中目标"]
    )
    _____8BBE_7F6E_7A7A_7259Q_8054_52A8(caster, state["方向角"], state["命中目标"])
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____6765_6E90_524D_7F00 .. "-自身")
    _____8BBE_7F6E_52A8_4F5C(caster, _____914D_7F6E["二段动作序号"])
    _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, _____914D_7F6E["动作时间流速"])
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(caster)
    _____521B_5EFAW_9636_6BB5_5200_5149(state, 0)
    for ____, target in ipairs(state["命中目标"]) do
        do
            if not _____76EE_6807_5408_6CD5(caster, target) then
                goto __continue104
            end
            _____9020_6210W_4F24_5BB3(state, target, _____914D_7F6E["二段伤害倍率"])
            _____65BD_52A0_7729_6655(
                caster,
                target,
                _____914D_7F6E["二段控制秒"],
                _____6765_6E90_524D_7F00 .. "-二段硬直",
                "技能"
            )
            _____8BBE_7F6E_52A8_4F5C_540D(target, "Death")
            _____521B_5EFAW_547D_4E2D_5200_5149(caster, target)
            _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(target)
        end
        ::__continue104::
    end
    state["周期ID"] = addPeriodicCallback(_____914D_7F6E["二段周期秒"] * 1000, ____W_4E8C_6BB5Tick, state)
end
local function _____91CA_653EW_4E09_6BB5(state, caster)
    debugLogForce(
        _____6A21_5757_540D,
        "释放W三段 进入",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "进行中",
        state["进行中"],
        "等待输入",
        state["等待输入"],
        "阶段",
        state["阶段"]
    )
    if not state["进行中"] or not state["等待输入"] or state["阶段"] ~= 1 then
        return
    end
    if not _____6D88_8017W_540E_7EED_6BB5(caster, _____914D_7F6E["三段代码追加固定魔耗"]) then
        return
    end
    _____64AD_653EW_97F3_6548(caster, _____914D_7F6E["三段音效键"])
    state["等待输入"] = false
    _____79FB_9664_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
    state["阶段"] = 2
    state["Tick数"] = 0
    state["方向角"] = _____83B7_53D6_5355_4F4D_9762_5411(caster)
    local _____4E09_6BB5_5019_9009 = _____83B7_53D6_8303_56F4_654C_519B(
        caster,
        _____83B7_53D6_5355_4F4DX(caster),
        _____83B7_53D6_5355_4F4DY(caster),
        _____914D_7F6E["三段范围"]
    )
    local _____6700_4F4E_547D_4E2D_9AD8_5EA6 = _____83B7_53D6_5355_4F4DZ(caster) - 100
    state["命中目标"] = {}
    for ____, target in ipairs(_____4E09_6BB5_5019_9009) do
        if _____76EE_6807_5408_6CD5(caster, target) and _____83B7_53D6_5355_4F4DZ(target) >= _____6700_4F4E_547D_4E2D_9AD8_5EA6 then
            local ____state__547D_4E2D_76EE_6807_51 = state["命中目标"]
            ____state__547D_4E2D_76EE_6807_51[#____state__547D_4E2D_76EE_6807_51 + 1] = target
        end
    end
    debugLogForce(
        _____6A21_5757_540D,
        "释放W三段 成功进入阶段2",
        "范围内敌军",
        #_____4E09_6BB5_5019_9009,
        "合法目标",
        #state["命中目标"],
        "施法者Z",
        _____83B7_53D6_5355_4F4DZ(caster),
        "最低命中高度",
        _____6700_4F4E_547D_4E2D_9AD8_5EA6
    )
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____6765_6E90_524D_7F00 .. "-自身")
    _____8BBE_7F6E_52A8_4F5C(caster, _____914D_7F6E["三段动作序号"])
    _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, _____914D_7F6E["动作时间流速"])
    _____521B_5EFAW_9636_6BB5_5200_5149(state, -200)
    for ____, target in ipairs(state["命中目标"]) do
        do
            if not _____76EE_6807_5408_6CD5(caster, target) then
                goto __continue113
            end
            _____9020_6210W_4F24_5BB3(state, target, _____914D_7F6E["三段伤害倍率"])
            _____65BD_52A0_7729_6655(
                caster,
                target,
                _____914D_7F6E["三段控制秒"],
                _____6765_6E90_524D_7F00 .. "-三段硬直",
                "技能"
            )
            _____8BBE_7F6E_52A8_4F5C_540D(target, "Death")
            _____521B_5EFAW_547D_4E2D_5200_5149(caster, target)
            _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(target)
        end
        ::__continue113::
    end
    state["周期ID"] = addPeriodicCallback(_____914D_7F6E["二段周期秒"] * 1000, ____W_4E09_6BB5Tick, state)
end
local function ____W_521D_6BB5_53EF_91CA_653E(state, _caster)
    return not state["进行中"]
end
local function ____W_4E8C_6BB5_53EF_91CA_653E(state, _caster)
    return state["进行中"] and state["等待输入"] and state["阶段"] == 0
end
local function ____W_4E09_6BB5_53EF_91CA_653E(state, _caster)
    return state["进行中"] and state["等待输入"] and state["阶段"] == 1
end
local function _____514B_52B3_5FB7W_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 or _____83B7_53D6_5355_4F4D_7C7B_578BID(dyingUnit) ~= _____5355_4F4D_7C7B_578BID then
        return
    end
    local state = _____72B6_6001_8868[_____83B7_53D6_53E5_67C4ID(dyingUnit)]
    debugLogForce(
        _____6A21_5757_540D,
        "克劳德W死亡清理",
        "死亡单位",
        _____83B7_53D6_53E5_67C4ID(dyingUnit),
        "状态存在",
        state ~= nil
    )
    if state ~= nil then
        _____6E05_7406W_72B6_6001(state)
    end
end
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "克劳德-空牙一段",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = _____521D_6BB5_6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAW_72B6_6001,
    ["可释放"] = ____W_521D_6BB5_53EF_91CA_653E,
    ["释放技能"] = _____91CA_653EW_521D_6BB5,
    ["创建独立技能实例"] = true,
    ["独立技能来源类型"] = "单位技能",
    ["技能实例持续时间秒"] = 5
})
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "克劳德-空牙二段",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = _____4E8C_6BB5_6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAW_72B6_6001,
    ["可释放"] = ____W_4E8C_6BB5_53EF_91CA_653E,
    ["释放技能"] = _____91CA_653EW_4E8C_6BB5,
    ["创建独立技能实例"] = false
})
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "克劳德-空牙三段",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = _____4E09_6BB5_6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAW_72B6_6001,
    ["可释放"] = ____W_4E09_6BB5_53EF_91CA_653E,
    ["释放技能"] = _____91CA_653EW_4E09_6BB5,
    ["创建独立技能实例"] = false
})
registerDeathListener(_____514B_52B3_5FB7W_6B7B_4EA1_6E05_7406)
return ____exports
