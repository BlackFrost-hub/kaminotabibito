local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.00．配置")
local _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["黑崎一护技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.01．状态表")
local _____9ED1_5D0E_4E00_62A4_662F_5426_534D_89E3 = ____01_FF0E_72B6_6001_8868["黑崎一护是否卍解"]
local ____09_FF0E_9ED1_5D0E_4E00_62A4 = require("系统.05．Buff系统.03．Buff表.02．英雄.09．黑崎一护")
local _____9ED1_5D0E_4E00_62A4BuffID = ____09_FF0E_9ED1_5D0E_4E00_62A4["黑崎一护BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____24_FF0E_6574_6570_4E0E_65F6_95F4_6362_7B97 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算")
local _____79D2_8F6C_6BEB_79D2 = ____24_FF0E_6574_6570_4E0E_65F6_95F4_6362_7B97["秒转毫秒"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_1["获取范围敌军"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_51CF_901F = ____require_result_2["施加减速"]
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____8BBE_7F6E_5355_4F4D_6682_505C_65F6_95F4 = ____require_result_4["设置单位暂停时间"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528 = ____require_result_4["单位是否存在其他暂停占用"]
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_5.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_5.YDUserDataSetSafe
local ____require_result_6 = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心")
local registerSyncHardwareKey = ____require_result_6.registerSyncHardwareKey
local ____require_result_7 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY = ____require_result_7.KEY
local KEY_STATE = ____require_result_7.KEY_STATE
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_9.IsUnitAliveBJ
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitState = jass.GetUnitState
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_10.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local _____914D_7F6E = _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____T_4E0A_4E0B_6587_8868 = {}
local _____5F53_524D_8FDB_884C_4E2D_7684T = nil
local function _____83B7_53D6_6216_521B_5EFAT_4E0A_4E0B_6587(unit)
    local id = GetHandleId(unit)
    local ctx = ____T_4E0A_4E0B_6587_8868[id]
    if ctx == nil then
        ctx = {
            ["施法者"] = unit,
            ["已启动"] = false,
            ["周期回调ID"] = 0,
            ["Tick数"] = 0,
            ["减伤已加"] = false
        }
        ____T_4E0A_4E0B_6587_8868[id] = ctx
    end
    return ctx
end
local function ____T_53EF_91CA_653E(context, _caster)
    return context["已启动"] ~= true
end
local function _____8C03_6574_73A9_5BB6_53D7_4F24_51CF_5C11(caster, _____589E_91CF)
    local player = GetOwningPlayer(caster)
    local _____5F53_524D_503C = __TS__Number(YDUserDataGetSafe("player", player, "受到伤害减少", "real")) or 0
    YDUserDataSetSafe(
        "player",
        player,
        "受到伤害减少",
        "real",
        _____5F53_524D_503C + _____589E_91CF
    )
end
local function _____5237_65B0T_533A_57DF_51CF_901F(ctx)
    local caster = ctx["施法者"]
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.T["周期"]["踩地特效"]["模型"],
        X = x,
        Y = y,
        Z = 0,
        ["面向角度"] = 270,
        ["缩放"] = _____914D_7F6E.T["周期"]["踩地特效"]["缩放"],
        ["持续秒"] = _____914D_7F6E.T["周期"]["踩地特效"]["持续秒"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.T["周期"]["裂地特效"]["模型"],
        X = x,
        Y = y,
        Z = 0,
        ["面向角度"] = 270,
        ["缩放"] = _____914D_7F6E.T["周期"]["裂地特效"]["缩放"],
        ["持续秒"] = _____914D_7F6E.T["周期"]["裂地特效"]["持续秒"]
    })
    local _____654C_519B = _____83B7_53D6_8303_56F4_654C_519B(caster, x, y, _____914D_7F6E.T["半径码"])
    if _____654C_519B == nil then
        return
    end
    do
        local i = 0
        while i < #_____654C_519B do
            do
                local target = _____654C_519B[i + 1]
                if target == nil or target == 0 then
                    goto __continue9
                end
                _____65BD_52A0_51CF_901F(
                    caster,
                    target,
                    _____914D_7F6E.T["周期"]["减速比例"],
                    _____914D_7F6E.T["周期"]["减速持续秒"],
                    "黑崎一护-地蹦裂击",
                    "技能"
                )
                registerManualBuff(target, _____9ED1_5D0E_4E00_62A4BuffID["地蹦裂击减速"], _____914D_7F6E.T["周期"]["减速持续秒"], 0)
            end
            ::__continue9::
            i = i + 1
        end
    end
end
local function _____7ED3_675FT(ctx)
    if ctx["周期回调ID"] ~= 0 then
        removePeriodicCallback(ctx["周期回调ID"])
    end
    ctx["周期回调ID"] = 0
    ctx["已启动"] = false
    local caster = ctx["施法者"]
    if caster ~= nil and caster ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["T施法硬直"])
        SetUnitTimeScale(caster, 1)
        if ctx["减伤已加"] then
            _____8C03_6574_73A9_5BB6_53D7_4F24_51CF_5C11(caster, -_____914D_7F6E.T["受伤减少比例"])
        end
        ctx["减伤已加"] = false
    end
    if _____5F53_524D_8FDB_884C_4E2D_7684T == ctx then
        _____5F53_524D_8FDB_884C_4E2D_7684T = nil
    end
end
local function _____63A8_8FDBT_5468_671F(variable)
    local ctx = variable
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) then
        _____7ED3_675FT(ctx)
        return
    end
    _____5237_65B0T_533A_57DF_51CF_901F(ctx)
    ctx["Tick数"] = ctx["Tick数"] + 1
    if _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528(caster, _____914D_7F6E["暂停来源"]["T施法硬直"]) then
        local _____514D_6253_65AD = _____9ED1_5D0E_4E00_62A4_662F_5426_534D_89E3(caster) and GetUnitState(caster, UNIT_STATE_LIFE) >= GetUnitState(caster, UNIT_STATE_MAX_LIFE) * _____914D_7F6E.T["卍解免打断血量阈值"]
        if not _____514D_6253_65AD then
            ctx["Tick数"] = _____914D_7F6E.T["周期"]["次数"]
        end
    end
    if ctx["Tick数"] >= _____914D_7F6E.T["周期"]["次数"] then
        _____7ED3_675FT(ctx)
    end
end
local function ____T_8FDB_5165_4E3B_9636_6BB5(variable)
    local ctx = variable
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) then
        _____7ED3_675FT(ctx)
        return
    end
    SetUnitTimeScale(caster, 0)
    ctx["Tick数"] = 0
    ctx["周期回调ID"] = addPeriodicCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.T["周期"]["间隔秒"]),
        _____63A8_8FDBT_5468_671F,
        ctx
    )
end
local function ____T_5B8C_6210_51C6_5907(variable)
    local ctx = variable
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) then
        _____7ED3_675FT(ctx)
        return
    end
    SetUnitAnimationByIndex(caster, _____914D_7F6E.T["动作索引"])
    _____8C03_6574_73A9_5BB6_53D7_4F24_51CF_5C11(caster, _____914D_7F6E.T["受伤减少比例"])
    ctx["减伤已加"] = true
    registerManualBuff(caster, _____9ED1_5D0E_4E00_62A4BuffID["地蹦裂击防御"], _____914D_7F6E.T["周期"]["间隔秒"] * _____914D_7F6E.T["周期"]["次数"] + 0.75, 0)
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.T["准备第二延迟秒"]),
        ____T_8FDB_5165_4E3B_9636_6BB5,
        ctx
    )
end
local function _____91CA_653E_5730_8E66_88C2_51FB(context, caster, _____6280_80FD_5B9E_4F8BID)
    context["施法者"] = caster
    context["已启动"] = true
    context["Tick数"] = 0
    context["减伤已加"] = false
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    _____5F53_524D_8FDB_884C_4E2D_7684T = context
    _____8BBE_7F6E_5355_4F4D_6682_505C_65F6_95F4(caster, _____914D_7F6E["暂停来源"]["T施法硬直"], _____914D_7F6E.T["硬直持续秒"])
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    local _____654C_519B = _____83B7_53D6_8303_56F4_654C_519B(caster, x, y, _____914D_7F6E.T["半径码"])
    if _____654C_519B ~= nil then
        do
            local i = 0
            while i < #_____654C_519B do
                do
                    local target = _____654C_519B[i + 1]
                    if target == nil or target == 0 then
                        goto __continue31
                    end
                    _____65BD_52A0_51CF_901F(
                        caster,
                        target,
                        _____914D_7F6E.T["周期"]["减速比例"],
                        _____914D_7F6E.T["周期"]["减速持续秒"],
                        "黑崎一护-地蹦裂击",
                        "技能"
                    )
                    registerManualBuff(target, _____9ED1_5D0E_4E00_62A4BuffID["地蹦裂击减速"], _____914D_7F6E.T["周期"]["减速持续秒"], 0)
                end
                ::__continue31::
                i = i + 1
            end
        end
    end
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.T["准备第一延迟秒"]),
        ____T_5B8C_6210_51C6_5907,
        context
    )
end
local function ____S_952E_6253_65AD_56DE_8C03(event)
    if _____5F53_524D_8FDB_884C_4E2D_7684T == nil or event == nil or event.player == nil or event.player == 0 then
        return
    end
    local ctx = _____5F53_524D_8FDB_884C_4E2D_7684T
    if ctx["已启动"] ~= true then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 then
        return
    end
    if GetPlayerId(GetOwningPlayer(caster)) ~= GetPlayerId(event.player) then
        return
    end
    ctx["Tick数"] = _____914D_7F6E.T["周期"]["次数"]
    if ctx["周期回调ID"] == 0 then
        _____7ED3_675FT(ctx)
    end
end
local ____S_952E_76D1_542C_5DF2_6CE8_518C = false
____exports["注册黑崎一护T"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "黑崎一护-地蹦裂击（T）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.T["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAT_4E0A_4E0B_6587,
        ["可释放"] = ____T_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653E_5730_8E66_88C2_51FB,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 5
    })
    if not ____S_952E_76D1_542C_5DF2_6CE8_518C then
        ____S_952E_76D1_542C_5DF2_6CE8_518C = true
        registerSyncHardwareKey(KEY.S, KEY_STATE.DOWN, ____S_952E_6253_65AD_56DE_8C03)
    end
end
____exports["注册黑崎一护T"]()
return ____exports
