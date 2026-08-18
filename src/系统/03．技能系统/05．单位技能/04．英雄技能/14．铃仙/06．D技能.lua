local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00．配置")
local _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["铃仙单位技能配置"]
local ____12_FF0E_94C3_4ED9 = require("系统.05．Buff系统.03．Buff表.02．英雄.12．铃仙")
local _____94C3_4ED9BuffID = ____12_FF0E_94C3_4ED9["铃仙BuffID"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00A．表现工具")
local _____64AD_653E_94C3_4ED9_5168_5C40_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放铃仙全局音效"]
local _____64AD_653E_94C3_4ED9_5355_4F4D_7ED1_5B9A_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放铃仙单位绑定音效"]
local ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00B．分身与状态管理")
local _____662F_94C3_4ED9_672C_4F53 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是铃仙本体"]
local _____662F_6709_6548_654C_5BF9_76EE_6807 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是有效敌对目标"]
local _____5168_56FE_82F1_96C4_514D_75AB_4F24_5BB3 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["全图英雄免疫伤害"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWESetUnitAbilityStateSafe = ____require_result_3.YDWESetUnitAbilityStateSafe
local YDWEGetUnitAbilityStateSafe = ____require_result_3.YDWEGetUnitAbilityStateSafe
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_4["造成技能伤害"]
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_5.getUnitsInRange
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_6["移除单位指定Buff"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_7["单位存活"]
local cfg = _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E
local ____D_6280_80FDID_6570_503C = stringToFourCCSafe(cfg["D技能ID"])
local ____Q_6280_80FDID_6570_503C = stringToFourCCSafe(cfg["Q技能ID"])
local ____W_6280_80FDID_6570_503C = stringToFourCCSafe(cfg["W技能ID"])
local _____5F39_5E55_9A6C_7532ID = stringToFourCCSafe(cfg.D["弹幕马甲ID"])
local _____6280_80FD_51B7_5374_72B6_6001 = 1
local _____89D2_5EA6_8F6C_5F27_5EA6 = math.pi / 180
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local DzSetUnitModel = japi.DzSetUnitModel
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetOwningPlayer = jass.GetOwningPlayer
local CreateUnit = jass.CreateUnit
local RemoveUnit = jass.RemoveUnit
local SetUnitPosition = jass.SetUnitPosition
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local DisplayCineFilter = jass.DisplayCineFilter
local ____require_result_8 = require("lib.扩展函数.BJ函数.05A．电影函数")
local CinematicFilterGenericBJ = ____require_result_8.CinematicFilterGenericBJ
local BLEND_MODE_BLEND = jass.BLEND_MODE_BLEND
--- 结束 D：移除推进回调、清理所有剩余弹幕（英雄死亡 / 弹幕全消 / 5 波后清理）
local function _____7ED3_675FD_5F39_5E55(ctx)
    if ctx["已结束"] then
        return
    end
    ctx["已结束"] = true
    if ctx["推进回调ID"] ~= 0 then
        removePeriodicCallback(ctx["推进回调ID"])
        ctx["推进回调ID"] = 0
    end
    do
        local i = 0
        while i < #ctx["弹幕列表"] do
            local _____5F39_5E55 = ctx["弹幕列表"][i + 1]
            if _____5F39_5E55 ~= nil and _____5F39_5E55 ~= 0 then
                RemoveUnit(_____5F39_5E55)
            end
            i = i + 1
        end
    end
    ctx["弹幕列表"] = {}
    ctx["重复命中表"] = {}
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(ctx["施法者"], _____94C3_4ED9BuffID["D波次"])
end
--- 发射一波：15 发弹幕，角度 = N × 24°（N = 1..15），设置朝向角度
local function _____53D1_5C04D_4E00_6CE2(ctx)
    local _____65BD_6CD5_8005 = ctx["施法者"]
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_8005)
    local _____4E2D_5FC3X = GetUnitX(_____65BD_6CD5_8005)
    local _____4E2D_5FC3Y = GetUnitY(_____65BD_6CD5_8005)
    local _____521B_5EFA_6570 = 0
    do
        local N = 1
        while N <= cfg.D["每波弹幕数"] do
            do
                local _____89D2_5EA6 = N * cfg.D["弹幕角度间隔"]
                local _____5F39_5E55 = CreateUnit(
                    _____73A9_5BB6,
                    _____5F39_5E55_9A6C_7532ID,
                    _____4E2D_5FC3X,
                    _____4E2D_5FC3Y,
                    _____89D2_5EA6
                )
                if _____5F39_5E55 == nil or _____5F39_5E55 == 0 then
                    goto __continue10
                end
                if DzSetUnitModel ~= nil then
                    DzSetUnitModel(_____5F39_5E55, cfg.D["弹幕模型"])
                end
                local ____ctx__5F39_5E55_5217_8868_9 = ctx["弹幕列表"]
                ____ctx__5F39_5E55_5217_8868_9[#____ctx__5F39_5E55_5217_8868_9 + 1] = _____5F39_5E55
                _____521B_5EFA_6570 = _____521B_5EFA_6570 + 1
            end
            ::__continue10::
            N = N + 1
        end
    end
end
--- 链式发射 5 波，每波间隔 1 秒
local function _____53D1_5C04D_4E0B_4E00_6CE2(ctx)
    if ctx["已结束"] then
        return
    end
    local _____65BD_6CD5_8005 = ctx["施法者"]
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        _____7ED3_675FD_5F39_5E55(ctx)
        return
    end
    ctx["波次数"] = ctx["波次数"] + 1
    ctx["重复命中表"] = {}
    DestroyEffect(AddSpecialEffectTarget("war3mapImported\\Whine.mdx", _____65BD_6CD5_8005, "overhead"))
    DestroyEffect(AddSpecialEffectTarget("war3mapImported\\Shockwave_Darkness.mdx", _____65BD_6CD5_8005, "origin"))
    _____64AD_653E_94C3_4ED9_5355_4F4D_7ED1_5B9A_97F3_6548(_____65BD_6CD5_8005, "gg_snd_tan2", 100)
    _____53D1_5C04D_4E00_6CE2(ctx)
    if ctx["波次数"] >= cfg.D["持续秒"] then
        addDelayedCallback(
            math.floor(cfg.D["清理延迟秒"] * 1000 + 0.5),
            function() return _____7ED3_675FD_5F39_5E55(ctx) end
        )
        return
    end
    addDelayedCallback(
        math.floor(cfg.D["波次间隔秒"] * 1000 + 0.5),
        function() return _____53D1_5C04D_4E0B_4E00_6CE2(ctx) end
    )
end
--- 弹幕推进：每 0.03 秒前移 30 码并检测 127 码内敌人（首次全额 / 重复 10%）
local function _____63A8_8FDBD_5F39_5E55(ctx)
    if ctx["已结束"] then
        return
    end
    local _____65BD_6CD5_8005 = ctx["施法者"]
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        _____7ED3_675FD_5F39_5E55(ctx)
        return
    end
    local _____5217_8868 = ctx["弹幕列表"]
    do
        local i = #_____5217_8868 - 1
        while i >= 0 do
            do
                local _____5F39_5E55 = _____5217_8868[i + 1]
                if _____5F39_5E55 == nil or _____5F39_5E55 == 0 or not _____5355_4F4D_5B58_6D3B(_____5F39_5E55) then
                    __TS__ArraySplice(_____5217_8868, i, 1)
                    goto __continue23
                end
                local _____671D_5411 = GetUnitFacing(_____5F39_5E55)
                local _____65B0X = GetUnitX(_____5F39_5E55) + math.cos(_____671D_5411 * _____89D2_5EA6_8F6C_5F27_5EA6) * cfg.D["弹幕每tick距离"]
                local _____65B0Y = GetUnitY(_____5F39_5E55) + math.sin(_____671D_5411 * _____89D2_5EA6_8F6C_5F27_5EA6) * cfg.D["弹幕每tick距离"]
                SetUnitPosition(_____5F39_5E55, _____65B0X, _____65B0Y)
                local _____5355_4F4D_5217_8868 = getUnitsInRange(_____65B0X, _____65B0Y, cfg.D["弹幕命中半径"])
                local _____5DF2_547D_4E2D = false
                do
                    local j = 0
                    while j < #_____5355_4F4D_5217_8868 do
                        do
                            local _____76EE_6807 = _____5355_4F4D_5217_8868[j + 1]
                            if not _____662F_6709_6548_654C_5BF9_76EE_6807(_____65BD_6CD5_8005, _____76EE_6807) then
                                goto __continue26
                            end
                            local id = GetHandleId(_____76EE_6807)
                            local _____91CD_590D_547D_4E2D = ctx["重复命中表"][id] == true
                            ctx["重复命中表"][id] = true
                            local _____4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * cfg.D["攻击力倍率"] * (_____91CD_590D_547D_4E2D and cfg.D["重复命中比例"] or 1)
                            if not (_____4F24_5BB3 > 0) then
                                goto __continue26
                            end
                            _____9020_6210_6280_80FD_4F24_5BB3({
                                ["来源"] = _____65BD_6CD5_8005,
                                ["目标"] = _____76EE_6807,
                                ["伤害"] = _____4F24_5BB3,
                                ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                                attack = false,
                                attackType = ATTACK_TYPE_NORMAL,
                                weaponType = WEAPON_TYPE_WHOKNOWS,
                                ["来源类型"] = "单位技能",
                                ["技能ID"] = ____D_6280_80FDID_6570_503C,
                                ["标签"] = "铃仙-D-幻胧月睨",
                                ["伤害形态"] = "AOE",
                                ["参与技能伤害加成"] = true
                            })
                            _____5DF2_547D_4E2D = true
                        end
                        ::__continue26::
                        j = j + 1
                    end
                end
                if _____5DF2_547D_4E2D then
                    RemoveUnit(_____5F39_5E55)
                    __TS__ArraySplice(_____5217_8868, i, 1)
                end
            end
            ::__continue23::
            i = i - 1
        end
    end
    if #_____5217_8868 <= 0 and ctx["波次数"] >= cfg.D["持续秒"] then
        _____7ED3_675FD_5F39_5E55(ctx)
    end
end
local function _____542F_52A8D_5F39_5E55(_____65BD_6CD5_8005)
    local ctx = {
        ["施法者"] = _____65BD_6CD5_8005,
        ["推进回调ID"] = 0,
        ["波次数"] = 0,
        ["弹幕列表"] = {},
        ["重复命中表"] = {},
        ["已结束"] = false
    }
    ctx["推进回调ID"] = addPeriodicCallback(
        math.floor(cfg.D["弹幕tick秒"] * 1000 + 0.5),
        function() return _____63A8_8FDBD_5F39_5E55(ctx) end
    )
    _____53D1_5C04D_4E0B_4E00_6CE2(ctx)
end
local function ____on_94C3_4ED9D_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    if _____6280_80FDID_6570_503C ~= ____D_6280_80FDID_6570_503C then
        return
    end
    if not _____662F_94C3_4ED9_672C_4F53(_____65BD_6CD5_5355_4F4D) then
        return
    end
    local ____q_51B7_5374 = YDWEGetUnitAbilityStateSafe(_____65BD_6CD5_5355_4F4D, ____Q_6280_80FDID_6570_503C, _____6280_80FD_51B7_5374_72B6_6001)
    YDWESetUnitAbilityStateSafe(
        _____65BD_6CD5_5355_4F4D,
        ____Q_6280_80FDID_6570_503C,
        _____6280_80FD_51B7_5374_72B6_6001,
        math.max(0, ____q_51B7_5374 - cfg.D["Q冷却减少"])
    )
    local ____w_51B7_5374 = YDWEGetUnitAbilityStateSafe(_____65BD_6CD5_5355_4F4D, ____W_6280_80FDID_6570_503C, _____6280_80FD_51B7_5374_72B6_6001)
    YDWESetUnitAbilityStateSafe(
        _____65BD_6CD5_5355_4F4D,
        ____W_6280_80FDID_6570_503C,
        _____6280_80FD_51B7_5374_72B6_6001,
        math.max(0, ____w_51B7_5374 - cfg.D["W冷却减少"])
    )
    _____5168_56FE_82F1_96C4_514D_75AB_4F24_5BB3(cfg.D["免伤秒"])
    _____64AD_653E_94C3_4ED9_5168_5C40_97F3_6548("gg_snd_LX_D_24343")
    _____64AD_653E_94C3_4ED9_5168_5C40_97F3_6548("gg_snd_LX_D")
    CinematicFilterGenericBJ(
        1.1,
        BLEND_MODE_BLEND,
        "222.blp",
        100,
        100,
        100,
        0,
        0,
        0,
        0,
        0
    )
    addDelayedCallback(
        1100,
        function() return DisplayCineFilter(false) end
    )
    registerManualBuff(_____65BD_6CD5_5355_4F4D, _____94C3_4ED9BuffID["D波次"], cfg.D["持续秒"], 0)
    _____542F_52A8D_5F39_5E55(_____65BD_6CD5_5355_4F4D)
end
registerSpellEffectListener(____on_94C3_4ED9D_751F_6548)
return ____exports
