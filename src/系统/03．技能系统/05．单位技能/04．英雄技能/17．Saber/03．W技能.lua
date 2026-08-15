local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.17．Saber.00．配置")
local ____Saber_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["Saber技能配置"]
local ____08_FF0ESaber = require("系统.05．Buff系统.03．Buff表.02．英雄.08．Saber")
local SaberBuffID = ____08_FF0ESaber.SaberBuffID
local ____04_FF0EE_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.17．Saber.04．E技能")
local ____Saber_662F_5426E_5F00_542F = ____04_FF0EE_6280_80FD["Saber是否E开启"]
local _____6D88_8017SaberE = ____04_FF0EE_6280_80FD["消耗SaberE"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_1["开始击退"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.06．闪烁")
local _____5F00_59CB_95EA_70C1 = ____require_result_2["开始闪烁"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_3["造成单体技能伤害"]
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成批量AOE技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_4["获取范围敌军"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_5["施加眩晕"]
local _____65BD_52A0_51CF_901F = ____require_result_5["施加减速"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_7["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_7["移除单位暂停"]
local ____require_result_8 = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算")
local getCooldownReduction = ____require_result_8.getCooldownReduction
local ____require_result_9 = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算")
local setAbilityCooldown = ____require_result_9.setAbilityCooldown
local ____require_result_10 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_10["技能_设置技能冷却时间"]
local ____require_result_11 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_11.Sound3DII_UnitPlayReuse
local ____require_result_12 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_12["创建点特效"]
local createTimedUnitEffect = ____require_result_12.createTimedUnitEffect
local ____require_result_13 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____9500_6BC1_70B9_7279_6548 = ____require_result_13["销毁点特效"]
local ____require_result_14 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_14.registerDeathListener
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitTypeId = jass.GetUnitTypeId
local GetHandleId = jass.GetHandleId
local SetUnitFacing = jass.SetUnitFacing
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitAnimation = jass.SetUnitAnimation
local ResetUnitAnimation = jass.ResetUnitAnimation
local SetUnitPathing = jass.SetUnitPathing
local IsTerrainPathable = jass.IsTerrainPathable
local IsUnitInRange = jass.IsUnitInRange
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local SquareRoot = jass.SquareRoot
local bj_RADTODEG = jass.bj_RADTODEG
local bj_DEGTORAD = jass.bj_DEGTORAD
local PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local WEAPON_TYPE_METAL_MEDIUM_SLICE = jass.WEAPON_TYPE_METAL_MEDIUM_SLICE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local DzSetEffectPos = japi.DzSetEffectPos
local ____require_result_15 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_15.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local _____914D_7F6E = ____Saber_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____W_7C7B_578BID = stringToFourCC(_____914D_7F6E.W["技能ID"])
local function _____8BA1_7B97_4E24_70B9_89D2_5EA6(x1, y1, x2, y2)
    return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG
end
local function _____6E05_7406_9F99_5377_98CE_8868_73B0(ctx)
    for ____, path in ipairs(ctx["龙卷风列表"]) do
        if path["特效"] ~= nil and path["特效"] ~= 0 then
            _____9500_6BC1_70B9_7279_6548(path["特效"])
        end
        path["特效"] = nil
    end
    ctx["龙卷风列表"] = {}
end
local function _____63A8_8FDBW_9F99_5377_98CE(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx.caster
    local function _____6536_5C3E()
        if ctx["周期回调ID"] ~= 0 then
            removePeriodicCallback(ctx["周期回调ID"])
        end
        ctx["周期回调ID"] = 0
        _____6E05_7406_9F99_5377_98CE_8868_73B0(ctx)
    end
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6536_5C3E()
        return
    end
    ctx["Tick数"] = ctx["Tick数"] + 1
    if ctx["Tick数"] > _____914D_7F6E.W["地面分支"]["龙卷风"]["最大Tick数"] then
        _____6536_5C3E()
        return
    end
    local cfg = _____914D_7F6E.W["地面分支"]["龙卷风"]
    for ____, path in ipairs(ctx["龙卷风列表"]) do
        local _____5F27_5EA6 = path["角度"] * bj_DEGTORAD
        path.X = path.X + cfg["每Tick距离"] * Cos(_____5F27_5EA6)
        path.Y = path.Y + cfg["每Tick距离"] * Sin(_____5F27_5EA6)
        if path["特效"] ~= nil and path["特效"] ~= 0 then
            DzSetEffectPos(path["特效"], path.X, path.Y, cfg["飞行高度"])
        end
        local _____654C_519B_5217_8868 = _____83B7_53D6_8303_56F4_654C_519B(caster, path.X, path.Y, cfg["伤害半径"])
        local _____65B0_76EE_6807 = {}
        for ____, target in ipairs(_____654C_519B_5217_8868) do
            do
                if target == nil or target == 0 then
                    goto __continue15
                end
                if ctx["命中组"][GetHandleId(target)] == true then
                    _____5F00_59CB_51FB_9000(target, {
                        ["来源单位"] = caster,
                        ["距离"] = cfg["重复组击退距离"],
                        ["持续时间"] = 0.05,
                        ["检查地形"] = true,
                        ["暂停单位"] = false,
                        ["禁用碰撞"] = false
                    })
                    goto __continue15
                end
                ctx["命中组"][GetHandleId(target)] = true
                _____65B0_76EE_6807[#_____65B0_76EE_6807 + 1] = target
            end
            ::__continue15::
        end
        if #_____65B0_76EE_6807 > 0 then
            _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
                ["来源"] = caster,
                ["目标列表"] = _____65B0_76EE_6807,
                ["伤害"] = ctx["伤害快照"] * cfg["伤害攻击力倍率"],
                ["伤害类型"] = DAMAGE_TYPE_MIND,
                attackType = ATTACK_TYPE_NORMAL,
                weaponType = WEAPON_TYPE_METAL_MEDIUM_SLICE,
                ["来源类型"] = "单位技能",
                ["标签"] = "Saber-W-地面龙卷风",
                ["技能ID"] = ____W_7C7B_578BID,
                ["技能实例ID"] = ctx["技能实例ID"],
                ["每目标结算后处理器"] = function(target, ______7D22_5F15, _____6210_529F)
                    if not _____6210_529F or target == nil or target == 0 then
                        return
                    end
                    _____65BD_52A0_51CF_901F(
                        caster,
                        target,
                        cfg["控制"]["减速比例"],
                        cfg["控制"]["减速秒"],
                        SaberBuffID["风王减速"],
                        "技能"
                    )
                    registerManualBuff(
                        target,
                        SaberBuffID["风王减速"],
                        cfg["控制"]["减速秒"],
                        cfg["控制"]["减速比例"],
                        {["来源"] = caster, ["标签"] = "Saber-W-地面龙卷风"}
                    )
                end
            })
        end
    end
end
local function ____W_5730_9762_542F_52A8_9F99_5377_98CE(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx.caster
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    Sound3DII_UnitPlayReuse(_____914D_7F6E.W["地面分支"]["龙卷风"]["音效"]["路径"], caster, _____914D_7F6E.W["地面分支"]["龙卷风"]["音效"]["裁断距离"])
    SetUnitTimeScale(caster, 1)
    local cfg = _____914D_7F6E.W["地面分支"]["龙卷风"]
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    do
        local i = 1
        while i <= cfg["数量"] do
            local _____89D2_5EA6 = cfg["出生朝向步进度"] * i
            local ____ctx__9F99_5377_98CE_5217_8868_16 = ctx["龙卷风列表"]
            ____ctx__9F99_5377_98CE_5217_8868_16[#____ctx__9F99_5377_98CE_5217_8868_16 + 1] = {
                X = x,
                Y = y,
                ["角度"] = _____89D2_5EA6,
                ["特效"] = _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = cfg["模型路径"],
                    X = x,
                    Y = y,
                    Z = cfg["飞行高度"],
                    ["面向角度"] = _____89D2_5EA6,
                    ["缩放"] = cfg["模型缩放"],
                    ["持续秒"] = cfg["推进间隔秒"] * cfg["最大Tick数"] + 1
                })
            }
            i = i + 1
        end
    end
    ctx["Tick数"] = 0
    ctx["周期回调ID"] = addPeriodicCallback(
        math.floor(cfg["推进间隔秒"] * 1000 + 0.5),
        _____63A8_8FDBW_9F99_5377_98CE,
        ctx
    )
end
local ____W_5730_9762_4E0A_4E0B_6587_8868 = {}
local function _____91CA_653EW_5730_9762_5206_652F(caster, _____6280_80FD_5B9E_4F8BID)
    local cfg = _____914D_7F6E.W["地面分支"]
    local _____7F29_51CF = getCooldownReduction(caster)
    if _____7F29_51CF > cfg["冷却缩减上限"] then
        _____7F29_51CF = cfg["冷却缩减上限"]
    end
    local _____7B49_7EA7 = GetUnitAbilityLevel(caster, ____W_7C7B_578BID)
    setAbilityCooldown(caster, ____W_7C7B_578BID, _____7B49_7EA7, cfg["冷却秒"])
    _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(caster, ____W_7C7B_578BID, cfg["冷却秒"] - cfg["冷却秒"] * _____7F29_51CF, cfg["冷却秒"])
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local dx = _____76EE_6807X - GetUnitX(caster)
    local dy = _____76EE_6807Y - GetUnitY(caster)
    local _____8DDD_79BB = SquareRoot(dx * dx + dy * dy)
    local _____5B9E_9645_8DDD_79BB = _____8DDD_79BB > cfg["传送最大距离"] and cfg["传送最大距离"] or _____8DDD_79BB
    local _____65B9_5411 = _____8BA1_7B97_4E24_70B9_89D2_5EA6(
        GetUnitX(caster),
        GetUnitY(caster),
        _____76EE_6807X,
        _____76EE_6807Y
    )
    local _____5F27_5EA6 = _____65B9_5411 * bj_DEGTORAD
    local _____843D_70B9X = GetUnitX(caster) + _____5B9E_9645_8DDD_79BB * Cos(_____5F27_5EA6)
    local _____843D_70B9Y = GetUnitY(caster) + _____5B9E_9645_8DDD_79BB * Sin(_____5F27_5EA6)
    _____5F00_59CB_95EA_70C1(caster, {["目标X"] = _____843D_70B9X, ["目标Y"] = _____843D_70B9Y, ["持续时间"] = 0, ["闪烁期间暂停单位"] = false})
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["气势特效"]["模型路径"],
        X = _____843D_70B9X,
        Y = _____843D_70B9Y,
        ["动画速度"] = cfg["气势特效"]["动画速度"],
        ["持续秒"] = cfg["气势特效"]["持续秒"]
    })
    SetUnitAnimationByIndex(caster, cfg["动作索引"])
    SetUnitTimeScale(caster, cfg["时间流速"])
    local ctx = {
        caster = caster,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["伤害快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster),
        ["龙卷风列表"] = {},
        ["命中组"] = {},
        ["周期回调ID"] = 0,
        ["Tick数"] = 0
    }
    ____W_5730_9762_4E0A_4E0B_6587_8868[GetHandleId(caster)] = ctx
    addDelayedCallback(
        math.floor(cfg["龙卷风"]["启动延迟秒"] * 1000 + 0.5),
        ____W_5730_9762_542F_52A8_9F99_5377_98CE,
        ctx
    )
end
local ____require_result_17 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_17.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_17.YDUserDataSetSafe
local function ____WE_5730_9762_6062_590D_95EA_907F_7387(ctx)
    for ____, item in ipairs(ctx["闪避率记录"]) do
        do
            if item.unit == nil or item.unit == 0 or not _____5355_4F4D_5B58_6D3B(item.unit) then
                goto __continue31
            end
            YDUserDataSetSafe(
                "unit",
                item.unit,
                "闪避率",
                "real",
                item["原值"]
            )
        end
        ::__continue31::
    end
    ctx["闪避率记录"] = {}
end
local function _____63A8_8FDBWE_5730_9762_51B2_51FB(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx.caster
    local function _____6536_5C3E()
        if ctx["周期回调ID"] ~= 0 then
            removePeriodicCallback(ctx["周期回调ID"])
        end
        ctx["周期回调ID"] = 0
        ____WE_5730_9762_6062_590D_95EA_907F_7387(ctx)
        _____79FB_9664_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["W地面E联动"])
    end
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        if ctx["周期回调ID"] ~= 0 then
            removePeriodicCallback(ctx["周期回调ID"])
        end
        ctx["周期回调ID"] = 0
        return
    end
    ctx["Tick数"] = ctx["Tick数"] + 1
    if ctx["Tick数"] > _____914D_7F6E.W["E联动地面分支"]["路径"]["Tick数"] then
        _____6536_5C3E()
        return
    end
    local cfg = _____914D_7F6E.W["E联动地面分支"]
    local _____5F27_5EA6 = ctx["方向角度"] * bj_DEGTORAD
    local _____70B9X = ctx["起点X"] + cfg["路径"]["每Tick距离"] * ctx["Tick数"] * Cos(_____5F27_5EA6)
    local _____70B9Y = ctx["起点Y"] + cfg["路径"]["每Tick距离"] * ctx["Tick数"] * Sin(_____5F27_5EA6)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["表现特效"]["模型路径"],
        X = _____70B9X,
        Y = _____70B9Y,
        Z = cfg["表现特效"]["飞行高度"],
        ["面向角度"] = ctx["方向角度"] + cfg["表现特效"]["朝向偏移"],
        ["X轴角度"] = -90,
        ["缩放"] = cfg["表现特效"]["缩放"],
        ["持续秒"] = cfg["表现特效"]["持续秒"]
    })
    local _____654C_519B_5217_8868 = _____83B7_53D6_8303_56F4_654C_519B(caster, _____70B9X, _____70B9Y, cfg["路径"]["伤害半径"])
    local _____65B0_76EE_6807 = {}
    for ____, target in ipairs(_____654C_519B_5217_8868) do
        do
            if target == nil or target == 0 then
                goto __continue41
            end
            if ctx["重复组"][GetHandleId(target)] == true then
                _____5F00_59CB_51FB_9000(target, {
                    ["角度"] = ctx["方向角度"],
                    ["距离"] = cfg["持续击退距离"],
                    ["持续时间"] = cfg["路径"]["Tick间隔秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = false,
                    ["禁用碰撞"] = false
                })
                goto __continue41
            end
            ctx["重复组"][GetHandleId(target)] = true
            if IsUnitType(target, UNIT_TYPE_HERO) then
                local _____5F53_524D_95EA_907F = __TS__Number(YDUserDataGetSafe("unit", target, "闪避率", "real")) or 0
                local ____ctx__95EA_907F_7387_8BB0_5F55_18 = ctx["闪避率记录"]
                ____ctx__95EA_907F_7387_8BB0_5F55_18[#____ctx__95EA_907F_7387_8BB0_5F55_18 + 1] = {unit = target, ["原值"] = _____5F53_524D_95EA_907F}
                YDUserDataSetSafe(
                    "unit",
                    target,
                    "闪避率",
                    "real",
                    0
                )
            end
            _____65B0_76EE_6807[#_____65B0_76EE_6807 + 1] = target
        end
        ::__continue41::
    end
    for ____, target in ipairs(_____65B0_76EE_6807) do
        _____65BD_52A0_7729_6655(
            caster,
            target,
            cfg["首次控制秒"],
            SaberBuffID["风王冲击硬直"],
            "技能"
        )
        registerManualBuff(
            target,
            SaberBuffID["风王冲击硬直"],
            cfg["首次控制秒"],
            0,
            {["来源"] = caster, ["标签"] = "Saber-W-E联动地面"}
        )
    end
    local _____91CD_590D_76EE_6807 = {}
    local _____5168_90E8_654C_519B = _____83B7_53D6_8303_56F4_654C_519B(caster, _____70B9X, _____70B9Y, cfg["路径"]["伤害半径"] + cfg["路径"]["每Tick距离"])
    for ____, target in ipairs(_____5168_90E8_654C_519B) do
        do
            if target == nil or target == 0 then
                goto __continue48
            end
            if ctx["重复组"][GetHandleId(target)] ~= true then
                goto __continue48
            end
            _____91CD_590D_76EE_6807[#_____91CD_590D_76EE_6807 + 1] = target
        end
        ::__continue48::
    end
    if #_____91CD_590D_76EE_6807 > 0 then
        _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标列表"] = _____91CD_590D_76EE_6807,
            ["伤害"] = ctx["伤害快照"] * cfg["持续伤害攻击力倍率"],
            ["伤害类型"] = DAMAGE_TYPE_PLANT,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_METAL_MEDIUM_SLICE,
            ["来源类型"] = "单位技能",
            ["标签"] = "Saber-W-E联动地面-持续",
            ["技能ID"] = ____W_7C7B_578BID,
            ["技能实例ID"] = ctx["技能实例ID"]
        })
    end
end
local function _____91CA_653EWE_5730_9762_5206_652F(caster, _____6280_80FD_5B9E_4F8BID)
    local cfg = _____914D_7F6E.W["E联动地面分支"]
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["W地面E联动"])
    Sound3DII_UnitPlayReuse(cfg["音效"]["路径"], caster, cfg["音效"]["裁断距离"])
    local _____65B9_5411 = _____8BA1_7B97_4E24_70B9_89D2_5EA6(
        GetUnitX(caster),
        GetUnitY(caster),
        GetSpellTargetX(),
        GetSpellTargetY()
    )
    _____6D88_8017SaberE(caster)
    SetUnitAnimationByIndex(caster, cfg["动作索引"])
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["表现特效"]["模型路径"],
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        Z = cfg["表现特效"]["飞行高度"],
        ["面向角度"] = _____65B9_5411 + cfg["表现特效"]["朝向偏移"],
        ["X轴角度"] = -90,
        ["缩放"] = cfg["表现特效"]["缩放"],
        ["持续秒"] = cfg["表现特效"]["持续秒"]
    })
    local ctx = {
        caster = caster,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["伤害快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster),
        ["方向角度"] = _____65B9_5411,
        ["起点X"] = GetUnitX(caster),
        ["起点Y"] = GetUnitY(caster),
        ["重复组"] = {},
        ["闪避率记录"] = {},
        ["周期回调ID"] = 0,
        ["Tick数"] = 0
    }
    ctx["周期回调ID"] = addPeriodicCallback(
        math.floor(cfg["路径"]["Tick间隔秒"] * 1000 + 0.5),
        _____63A8_8FDBWE_5730_9762_51B2_51FB,
        ctx
    )
end
local function _____63A8_8FDBW_51B2_51FB_6CE2(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx.caster
    local cfg = _____914D_7F6E.W["敌人分支"]["E联动冲击波"]
    local function _____6536_5C3E()
        if ctx["周期回调ID"] ~= 0 then
            removePeriodicCallback(ctx["周期回调ID"])
        end
        ctx["周期回调ID"] = 0
        if ctx["特效"] ~= nil and ctx["特效"] ~= 0 then
            _____9500_6BC1_70B9_7279_6548(ctx["特效"])
        end
        ctx["特效"] = nil
    end
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6536_5C3E()
        return
    end
    ctx["Tick数"] = ctx["Tick数"] + 1
    if ctx["Tick数"] > cfg["最大Tick数"] then
        _____6536_5C3E()
        return
    end
    local _____5F27_5EA6 = ctx["角度"] * bj_DEGTORAD
    ctx.X = ctx.X + cfg["每Tick距离"] * Cos(_____5F27_5EA6)
    ctx.Y = ctx.Y + cfg["每Tick距离"] * Sin(_____5F27_5EA6)
    if ctx["特效"] ~= nil and ctx["特效"] ~= 0 then
        DzSetEffectPos(ctx["特效"], ctx.X, ctx.Y, cfg["飞行高度"])
    end
    local _____654C_519B_5217_8868 = _____83B7_53D6_8303_56F4_654C_519B(caster, ctx.X, ctx.Y, cfg["伤害半径"])
    local _____65B0_76EE_6807 = {}
    for ____, target in ipairs(_____654C_519B_5217_8868) do
        do
            if target == nil or target == 0 then
                goto __continue62
            end
            if ctx["命中组"][GetHandleId(target)] == true then
                _____5F00_59CB_51FB_9000(target, {
                    ["角度"] = ctx["角度"],
                    ["距离"] = cfg["重复组击退距离"],
                    ["持续时间"] = cfg["推进间隔秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = false,
                    ["禁用碰撞"] = false
                })
                goto __continue62
            end
            ctx["命中组"][GetHandleId(target)] = true
            _____65B0_76EE_6807[#_____65B0_76EE_6807 + 1] = target
        end
        ::__continue62::
    end
    if #_____65B0_76EE_6807 > 0 then
        _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标列表"] = _____65B0_76EE_6807,
            ["伤害"] = ctx["伤害快照"] * cfg["伤害攻击力倍率"],
            ["伤害类型"] = DAMAGE_TYPE_PLANT,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["标签"] = "Saber-W-E联动冲击波",
            ["技能ID"] = ____W_7C7B_578BID,
            ["技能实例ID"] = ctx["技能实例ID"]
        })
    end
end
local function _____542F_52A8W_51B2_51FB_6CE2(ctx)
    local caster = ctx.caster
    local cfg = _____914D_7F6E.W["敌人分支"]["E联动冲击波"]
    Sound3DII_UnitPlayReuse(cfg["音效"]["路径"], caster, cfg["音效"]["裁断距离"])
    local _____6CE2_4E0A_4E0B_6587 = {
        caster = caster,
        ["技能实例ID"] = ctx["技能实例ID"],
        ["伤害快照"] = ctx["伤害快照"],
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        ["角度"] = ctx["冲锋角度"],
        ["特效"] = _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = cfg["模型路径"],
            X = GetUnitX(caster),
            Y = GetUnitY(caster),
            Z = cfg["飞行高度"],
            ["面向角度"] = ctx["冲锋角度"],
            ["X轴角度"] = -90,
            ["缩放"] = cfg["缩放"],
            ["持续秒"] = cfg["推进间隔秒"] * cfg["最大Tick数"] + 1
        }),
        ["命中组"] = {},
        ["周期回调ID"] = 0,
        ["Tick数"] = 0
    }
    _____6CE2_4E0A_4E0B_6587["周期回调ID"] = addPeriodicCallback(
        math.floor(cfg["推进间隔秒"] * 1000 + 0.5),
        _____63A8_8FDBW_51B2_51FB_6CE2,
        _____6CE2_4E0A_4E0B_6587
    )
end
local function ____W_76EE_6807_786C_76F4_8868_73B0_6062_590D(variable)
    local target = variable
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    ResetUnitAnimation(target)
    SetUnitTimeScale(target, 1)
end
local function _____63A8_8FDBW_654C_4EBA_8FFD_51FB(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx.caster
    local target = ctx["目标"]
    local function _____6536_5C3E()
        if ctx["周期回调ID"] ~= 0 then
            removePeriodicCallback(ctx["周期回调ID"])
        end
        ctx["周期回调ID"] = 0
        SetUnitPathing(caster, true)
        if ctx["捕捉成功"] and _____5355_4F4D_5B58_6D3B(caster) and target ~= nil and target ~= 0 and _____5355_4F4D_5B58_6D3B(target) then
            _____79FB_9664_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["W敌人追击"])
            SetUnitFacing(
                caster,
                _____8BA1_7B97_4E24_70B9_89D2_5EA6(
                    GetUnitX(caster),
                    GetUnitY(caster),
                    GetUnitX(target),
                    GetUnitY(target)
                )
            )
            _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                ["来源"] = caster,
                ["目标"] = target,
                ["伤害"] = ctx["伤害快照"] * _____914D_7F6E.W["敌人分支"]["主伤害攻击力倍率"],
                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                attackType = ATTACK_TYPE_NORMAL,
                weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                ["来源类型"] = "单位技能",
                ["标签"] = "Saber-W-敌人捕捉",
                ["技能ID"] = ____W_7C7B_578BID,
                ["技能实例ID"] = ctx["技能实例ID"]
            })
            createTimedUnitEffect(target, _____914D_7F6E.W["敌人分支"]["命中特效"]["挂点"], _____914D_7F6E.W["敌人分支"]["命中特效"]["模型路径"], _____914D_7F6E.W["敌人分支"]["命中特效"]["持续秒"])
            _____65BD_52A0_7729_6655(
                caster,
                target,
                _____914D_7F6E.W["敌人分支"]["主控制秒"],
                SaberBuffID["风王硬直"],
                "技能"
            )
            registerManualBuff(
                target,
                SaberBuffID["风王硬直"],
                _____914D_7F6E.W["敌人分支"]["主控制秒"],
                0,
                {["来源"] = caster, ["标签"] = "Saber-W-敌人捕捉"}
            )
            SetUnitAnimation(target, "death")
            SetUnitTimeScale(target, 0)
            addDelayedCallback(
                math.floor(_____914D_7F6E.W["敌人分支"]["主控制秒"] * 1000 + 0.5),
                ____W_76EE_6807_786C_76F4_8868_73B0_6062_590D,
                target
            )
            _____5F00_59CB_51FB_9000(target, {
                ["来源单位"] = caster,
                ["距离"] = _____914D_7F6E.W["敌人分支"]["目标击退距离"],
                ["持续时间"] = 0.15,
                ["检查地形"] = true,
                ["暂停单位"] = false,
                ["禁用碰撞"] = true
            })
            if ctx["E开启快照"] then
                _____542F_52A8W_51B2_51FB_6CE2(ctx)
            end
        else
            SetUnitTimeScale(caster, 1)
            _____79FB_9664_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["W敌人追击"])
        end
    end
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        if ctx["周期回调ID"] ~= 0 then
            removePeriodicCallback(ctx["周期回调ID"])
        end
        ctx["周期回调ID"] = 0
        if caster ~= nil and caster ~= 0 then
            SetUnitPathing(caster, true)
            _____79FB_9664_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["W敌人追击"])
        end
        return
    end
    ctx["Tick数"] = ctx["Tick数"] + 1
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        _____6536_5C3E()
        return
    end
    if IsUnitInRange(caster, target, _____914D_7F6E.W["敌人分支"]["追击"]["捕捉半径"]) then
        ctx["捕捉成功"] = true
        _____6536_5C3E()
        return
    end
    if ctx["Tick数"] >= _____914D_7F6E.W["敌人分支"]["追击"]["最大Tick数"] then
        _____6536_5C3E()
        return
    end
    local _____5F27_5EA6 = ctx["冲锋角度"] * bj_DEGTORAD
    local _____79FB_52A8X = GetUnitX(caster) + _____914D_7F6E.W["敌人分支"]["追击"]["每Tick距离"] * Cos(_____5F27_5EA6)
    local _____79FB_52A8Y = GetUnitY(caster) + _____914D_7F6E.W["敌人分支"]["追击"]["每Tick距离"] * Sin(_____5F27_5EA6)
    if IsTerrainPathable(_____79FB_52A8X, _____79FB_52A8Y, PATHING_TYPE_WALKABILITY) then
        _____6536_5C3E()
        return
    end
    SetUnitX(caster, _____79FB_52A8X)
    SetUnitY(caster, _____79FB_52A8Y)
    SetUnitFacing(caster, ctx["冲锋角度"])
end
local function _____91CA_653EW_654C_4EBA_5206_652F(caster, target, _____6280_80FD_5B9E_4F8BID)
    local ctx = {
        caster = caster,
        ["目标"] = target,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["伤害快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster),
        ["冲锋角度"] = _____8BA1_7B97_4E24_70B9_89D2_5EA6(
            GetUnitX(caster),
            GetUnitY(caster),
            GetUnitX(target),
            GetUnitY(target)
        ),
        ["捕捉成功"] = false,
        ["周期回调ID"] = 0,
        ["Tick数"] = 0,
        ["E开启快照"] = ____Saber_662F_5426E_5F00_542F(caster)
    }
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["W敌人追击"])
    SetUnitAnimationByIndex(caster, _____914D_7F6E.W["敌人分支"]["动作索引"])
    SetUnitTimeScale(caster, _____914D_7F6E.W["敌人分支"]["时间流速"])
    SetUnitPathing(caster, false)
    ctx["周期回调ID"] = addPeriodicCallback(
        math.floor(_____914D_7F6E.W["敌人分支"]["追击"]["间隔秒"] * 1000 + 0.5),
        _____63A8_8FDBW_654C_4EBA_8FFD_51FB,
        ctx
    )
end
local ____W_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587(caster)
    local id = GetHandleId(caster)
    local record = ____W_4E0A_4E0B_6587_8868[id]
    if record == nil then
        record = {["施法者"] = caster}
        ____W_4E0A_4E0B_6587_8868[id] = record
    end
    return record
end
local function _____91CA_653EW_6280_80FD(_context, caster, _____6280_80FD_5B9E_4F8BID)
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    local target = GetSpellTargetUnit()
    if target ~= nil and target ~= 0 and _____5355_4F4D_5B58_6D3B(target) then
        _____91CA_653EW_654C_4EBA_5206_652F(caster, target, _____6280_80FD_5B9E_4F8BID)
    elseif ____Saber_662F_5426E_5F00_542F(caster) then
        _____91CA_653EWE_5730_9762_5206_652F(caster, _____6280_80FD_5B9E_4F8BID)
    else
        _____91CA_653EW_5730_9762_5206_652F(caster, _____6280_80FD_5B9E_4F8BID)
    end
end
local ____W_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function ____W_5355_4F4D_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if GetUnitTypeId(dyingUnit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    _____79FB_9664_5355_4F4D_6682_505C(dyingUnit, _____914D_7F6E["暂停来源"]["W敌人追击"])
    _____79FB_9664_5355_4F4D_6682_505C(dyingUnit, _____914D_7F6E["暂停来源"]["W地面E联动"])
    SetUnitPathing(dyingUnit, true)
    local _____5730_9762 = ____W_5730_9762_4E0A_4E0B_6587_8868[GetHandleId(dyingUnit)]
    if _____5730_9762 ~= nil and _____5730_9762["周期回调ID"] ~= 0 then
        removePeriodicCallback(_____5730_9762["周期回调ID"])
        _____5730_9762["周期回调ID"] = 0
        _____6E05_7406_9F99_5377_98CE_8868_73B0(_____5730_9762)
    end
end
____exports["注册SaberW"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "Saber-风王铁锤（W）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.W["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653EW_6280_80FD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 6
    })
    if not ____W_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        ____W_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____W_5355_4F4D_6B7B_4EA1_6E05_7406)
    end
end
____exports["注册SaberW"]()
return ____exports
