local ____lualib = require("lualib_bundle")
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.00．配置")
local _____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派剑士单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建教派剑士上下文"]
local _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["教派剑士单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.02．数值与表现配置")
local _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派剑士技能配置"]
local _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派剑士音效配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.11．台词播放")
local _____64AD_653E_6559_6D3E_5251_58EB_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放教派剑士台词"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local _____9500_6BC1_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["销毁原生弹幕"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382["创建技能提示圈"]
local ____11_FF0E_6559_6D3E_5251_58EB = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.11．教派剑士")
local _____6559_6D3E_5251_58EBBuffID = ____11_FF0E_6559_6D3E_5251_58EB["教派剑士BuffID"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_3["开始硬直"]
local _____83B7_53D6_5355_4F4D_786C_76F4_5269_4F59_65F6_95F4 = ____require_result_3["获取单位硬直剩余时间"]
local _____8C03_6574_5355_4F4D_786C_76F4_65F6_95F4 = ____require_result_3["调整单位硬直时间"]
local _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6 = ____require_result_3["单位是否处于硬控制效果合集"]
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_3["施加快速减速Buff"]
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_4["移除单位指定Buff"]
local ____require_result_5 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_5["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_5["关闭吟唱条"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_6.getEnemyUnitsInRange
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local ____require_result_8 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_8.Sound3DII_CooPlayReuse
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_9.debugLogForce
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetRandomReal = jass.GetRandomReal
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitAnimation = jass.SetUnitAnimation
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6DF1_6E0A_65CB_98CE_6280_80FDID = stringToFourCCSafe(_____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["深渊旋风"])
local _____6DF1_6E0A_65CB_98CE_5F39_5E55_72B6_6001_8868 = {}
local _____6DF1_6E0A_65CB_98CE_5DF2_6CE8_518C = false
local function _____7ED3_675F_6DF1_6E0A_65CB_98CE(_____72B6_6001, _____539F_56E0)
    if _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["已结束"] = true
    if _____72B6_6001["周期回调ID"] ~= 0 then
        removePeriodicCallback(_____72B6_6001["周期回调ID"])
        _____72B6_6001["周期回调ID"] = 0
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local _____65BD_6CD5_786C_76F4_5269_4F59_79D2 = _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) and _____83B7_53D6_5355_4F4D_786C_76F4_5269_4F59_65F6_95F4(boss) or 0
    if _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) then
        _____8C03_6574_5355_4F4D_786C_76F4_65F6_95F4(boss, 1, _____65BD_6CD5_786C_76F4_5269_4F59_79D2)
    end
    local _____6E05_7406_540E_786C_76F4_5269_4F59_79D2 = _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) and _____83B7_53D6_5355_4F4D_786C_76F4_5269_4F59_65F6_95F4(boss) or 0
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____6559_6D3E_5251_58EBBuffID["深渊旋风"])
    _____5173_95ED_541F_5531_6761(_____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊旋风"]["读条通道"])
    if _____72B6_6001["上下文"]["旋风状态"] == _____72B6_6001 then
        _____72B6_6001["上下文"]["旋风状态"] = nil
    end
    debugLogForce(
        "教派剑士-深渊旋风",
        "技能结束",
        "bossHid=",
        boss ~= nil and boss ~= 0 and GetHandleId(boss) or 0,
        "reason=",
        _____539F_56E0,
        "rounds=",
        _____72B6_6001["已执行轮数"],
        "hardStunBefore=",
        _____65BD_6CD5_786C_76F4_5269_4F59_79D2,
        "hardStunAfter=",
        _____6E05_7406_540E_786C_76F4_5269_4F59_79D2,
        "hardStunCleared=",
        _____6E05_7406_540E_786C_76F4_5269_4F59_79D2 <= 0.001
    )
end
local function _____6E05_7406_6DF1_6E0A_65CB_98CE_5DF2_53D1_5C04_5F39_5E55(_____72B6_6001)
    local _____5F39_5E55ID_5217_8868 = __TS__ArraySlice(_____72B6_6001["弹幕ID列表"])
    __TS__ArraySetLength(_____72B6_6001["弹幕ID列表"], 0)
    do
        local i = 0
        while i < #_____5F39_5E55ID_5217_8868 do
            local _____5F39_5E55ID = _____5F39_5E55ID_5217_8868[i + 1]
            local _____5F39_5E55_72B6_6001 = _____6DF1_6E0A_65CB_98CE_5F39_5E55_72B6_6001_8868[_____5F39_5E55ID]
            if _____5F39_5E55_72B6_6001 ~= nil then
                _____5F39_5E55_72B6_6001["禁止结算"] = true
            end
            _____9500_6BC1_539F_751F_5F39_5E55(_____5F39_5E55ID, "手动销毁")
            debugLogForce(
                "教派剑士-深渊旋风",
                "上下文清理已发射弹幕",
                "barrageId=",
                _____5F39_5E55ID,
                "skipExplosion=",
                true
            )
            i = i + 1
        end
    end
end
local function ____on_6DF1_6E0A_65CB_98CE_6E05_7406(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil then
        return
    end
    if not _____72B6_6001["已结束"] then
        _____7ED3_675F_6DF1_6E0A_65CB_98CE(_____72B6_6001, "上下文清理")
    end
    _____6E05_7406_6DF1_6E0A_65CB_98CE_5DF2_53D1_5C04_5F39_5E55(_____72B6_6001)
end
local function ____on_6DF1_6E0A_65CB_98CE_5F39_5E55Tick(instance)
    if instance == nil or instance.id == nil then
        return
    end
    local _____72B6_6001 = _____6DF1_6E0A_65CB_98CE_5F39_5E55_72B6_6001_8868[instance.id]
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001.X = instance["当前X"]
    _____72B6_6001.Y = instance["当前Y"]
end
local function ____on_6DF1_6E0A_65CB_98CE_5F39_5E55_7ED3_675F(reason, barrageId)
    local _____72B6_6001 = _____6DF1_6E0A_65CB_98CE_5F39_5E55_72B6_6001_8868[barrageId]
    __TS__Delete(_____6DF1_6E0A_65CB_98CE_5F39_5E55_72B6_6001_8868, barrageId)
    if _____72B6_6001 ~= nil then
        local _____5F39_5E55ID_5217_8868 = _____72B6_6001["父状态"]["弹幕ID列表"]
        do
            local i = #_____5F39_5E55ID_5217_8868 - 1
            while i >= 0 do
                if _____5F39_5E55ID_5217_8868[i + 1] == barrageId then
                    __TS__ArraySplice(_____5F39_5E55ID_5217_8868, i, 1)
                    break
                end
                i = i - 1
            end
        end
    end
    if _____72B6_6001 == nil or _____72B6_6001["禁止结算"] or not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(_____72B6_6001["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊旋风"]
    local _____76EE_6807_5217_8868 = getEnemyUnitsInRange(boss, _____72B6_6001.X, _____72B6_6001.Y, _____914D_7F6E["爆炸半径"])
    local _____547D_4E2D_6570 = 0
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                boss,
                _____76EE_6807_5217_8868[i + 1],
                0,
                _____914D_7F6E["命中移速减幅"],
                _____914D_7F6E["命中减速秒"],
                "教派剑士-深渊旋风",
                "技能"
            )
            debugLogForce(
                "教派剑士-深渊旋风",
                "命中目标施加减速",
                "barrageId=",
                barrageId,
                "targetHid=",
                GetHandleId(_____76EE_6807_5217_8868[i + 1]),
                "moveSlow=",
                _____914D_7F6E["命中移速减幅"],
                "duration=",
                _____914D_7F6E["命中减速秒"]
            )
            local _____7ED3_679C = _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                ["来源"] = boss,
                ["目标"] = _____76EE_6807_5217_8868[i + 1],
                ["技能ID"] = _____6DF1_6E0A_65CB_98CE_6280_80FDID,
                ["伤害公式"] = {["来源攻击力比例"] = _____914D_7F6E["Boss攻击力比例"]},
                attack = false,
                ranged = false,
                attackType = ATTACK_TYPE_NORMAL,
                ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["标签"] = _____914D_7F6E["伤害标签"]
            })
            if _____7ED3_679C["是否造成伤害"] then
                _____547D_4E2D_6570 = _____547D_4E2D_6570 + 1
            end
            i = i + 1
        end
    end
    debugLogForce(
        "教派剑士-深渊旋风",
        "弹幕终点AOE结算",
        "barrageId=",
        barrageId,
        "reason=",
        reason,
        "x=",
        _____72B6_6001.X,
        "y=",
        _____72B6_6001.Y,
        "hitCount=",
        _____547D_4E2D_6570
    )
end
local function ____on_6DF1_6E0A_65CB_98CE_53D1_5C04(variable)
    local _____5FEB_7167 = variable
    if _____5FEB_7167 == nil or _____5FEB_7167["状态"]["已结束"] or not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(_____5FEB_7167["状态"]["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____5FEB_7167["状态"]["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊旋风"]
    local X = GetUnitX(boss)
    local Y = GetUnitY(boss)
    local _____5F39_5E55 = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = boss,
        ["载体模式"] = "特效",
        X = X,
        Y = Y,
        ["方向角"] = _____5FEB_7167["角度"],
        ["速度"] = _____914D_7F6E["弹幕速度"],
        ["生命周期"] = _____914D_7F6E["弹幕生命周期秒"],
        ["最大距离"] = _____914D_7F6E["弹幕速度"] * _____914D_7F6E["弹幕生命周期秒"],
        ["命中半径"] = _____914D_7F6E["弹幕命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = true,
        ["每单位最大命中次数"] = 1,
        ["最大总命中次数"] = 1,
        ["附加特效1"] = {["模型"] = _____914D_7F6E["弹幕特效路径"], ["缩放"] = _____914D_7F6E["弹幕特效缩放"], ["跟随主弹幕参数"] = true},
        onTick = ____on_6DF1_6E0A_65CB_98CE_5F39_5E55Tick,
        ["on结束"] = ____on_6DF1_6E0A_65CB_98CE_5F39_5E55_7ED3_675F
    })
    _____6DF1_6E0A_65CB_98CE_5F39_5E55_72B6_6001_8868[_____5F39_5E55["弹幕ID"]] = {
        ["父状态"] = _____5FEB_7167["状态"],
        ["上下文"] = _____5FEB_7167["状态"]["上下文"],
        X = X,
        Y = Y,
        ["禁止结算"] = false
    }
    local ____5FEB_7167__72B6_6001__5F39_5E55ID_5217_8868_10 = _____5FEB_7167["状态"]["弹幕ID列表"]
    ____5FEB_7167__72B6_6001__5F39_5E55ID_5217_8868_10[#____5FEB_7167__72B6_6001__5F39_5E55ID_5217_8868_10 + 1] = _____5F39_5E55["弹幕ID"]
    debugLogForce(
        "教派剑士-深渊旋风",
        "旋风弹幕发射",
        "bossHid=",
        GetHandleId(boss),
        "barrageId=",
        _____5F39_5E55["弹幕ID"],
        "angle=",
        _____5FEB_7167["角度"]
    )
end
local function ____on_6DF1_6E0A_65CB_98CE_672B_8F6E_6536_675F(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 ~= nil then
        _____7ED3_675F_6DF1_6E0A_65CB_98CE(_____72B6_6001, "全部轮次完成")
    end
end
local function ____on_6DF1_6E0A_65CB_98CE_8F6E_6B21(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    if not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) then
        _____7ED3_675F_6DF1_6E0A_65CB_98CE(_____72B6_6001, "Boss失效")
        return
    end
    if _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6(boss) then
        _____7ED3_675F_6DF1_6E0A_65CB_98CE(_____72B6_6001, "受到硬控制打断")
        return
    end
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊旋风"]
    _____72B6_6001["已执行轮数"] = _____72B6_6001["已执行轮数"] + 1
    local _____89D2_5EA6 = GetRandomReal(0, 360)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["宽度"] = _____914D_7F6E["弹幕命中半径"] * 2,
        ["长度"] = _____914D_7F6E["弹幕速度"] * _____914D_7F6E["弹幕生命周期秒"],
        ["朝向"] = _____89D2_5EA6,
        ["持续时间"] = _____914D_7F6E["预警秒"],
        ["来源单位"] = boss
    })
    local _____5FEB_7167 = {["状态"] = _____72B6_6001, ["角度"] = _____89D2_5EA6}
    local _____53D1_5C04_56DE_8C03ID = addDelayedCallback(_____914D_7F6E["预警秒"] * 1000, ____on_6DF1_6E0A_65CB_98CE_53D1_5C04, _____5FEB_7167)
    local ____self_11 = _____72B6_6001["上下文"]["清理"]
    ____self_11["登记延迟回调"](____self_11, "教派剑士-深渊旋风发射", _____53D1_5C04_56DE_8C03ID)
    debugLogForce(
        "教派剑士-深渊旋风",
        "轮次预警",
        "bossHid=",
        GetHandleId(boss),
        "round=",
        _____72B6_6001["已执行轮数"],
        "angle=",
        _____89D2_5EA6,
        "warning=",
        _____914D_7F6E["预警秒"]
    )
    if _____72B6_6001["已执行轮数"] >= _____914D_7F6E["轮数"] then
        if _____72B6_6001["周期回调ID"] ~= 0 then
            removePeriodicCallback(_____72B6_6001["周期回调ID"])
            _____72B6_6001["周期回调ID"] = 0
        end
        local _____6536_675F_56DE_8C03ID = addDelayedCallback((_____914D_7F6E["预警秒"] + _____914D_7F6E["末轮收束冗余秒"]) * 1000, ____on_6DF1_6E0A_65CB_98CE_672B_8F6E_6536_675F, _____72B6_6001)
        local ____self_12 = _____72B6_6001["上下文"]["清理"]
        ____self_12["登记延迟回调"](____self_12, "教派剑士-深渊旋风末轮收束", _____6536_675F_56DE_8C03ID)
    end
end
local function _____6559_6D3E_5251_58EB_65CB_98CE_9B54_6CD5_514D_75AB_4FEE_6B63(context)
    if context == nil or context.target == nil or context.target == 0 or context.isMagicDamage ~= true then
        local ____opt_result_15
        if context ~= nil then
            ____opt_result_15 = context.currentDamage
        end
        local ____opt_result_15_16 = ____opt_result_15
        if ____opt_result_15_16 == nil then
            ____opt_result_15_16 = 0
        end
        return ____opt_result_15_16
    end
    if GetUnitTypeId(context.target) ~= _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID then
        return context.currentDamage
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587(context.target)
    local _____72B6_6001 = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["旋风状态"]
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return context.currentDamage
    end
    debugLogForce(
        "教派剑士-深渊旋风",
        "施法期间免疫魔法伤害",
        "bossHid=",
        GetHandleId(context.target),
        "prevented=",
        context.currentDamage
    )
    return 0
end
____exports["释放教派剑士深渊旋风"] = function(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) or _____4E0A_4E0B_6587["旋风状态"] ~= nil then
        return false
    end
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊旋风"]
    local _____72B6_6001 = {
        ["已结束"] = false,
        ["上下文"] = _____4E0A_4E0B_6587,
        ["已执行轮数"] = 0,
        ["周期回调ID"] = 0,
        ["弹幕ID列表"] = {}
    }
    _____4E0A_4E0B_6587["旋风状态"] = _____72B6_6001
    local ____self_21 = _____4E0A_4E0B_6587["清理"]
    ____self_21["登记清理"](____self_21, "教派剑士-深渊旋风清理", ____on_6DF1_6E0A_65CB_98CE_6E05_7406, _____72B6_6001)
    _____5F00_59CB_786C_76F4(boss, _____914D_7F6E["施法硬直秒"])
    SetUnitAnimation(boss, _____914D_7F6E["动作名"])
    _____64AD_653E_6559_6D3E_5251_58EB_53F0_8BCD(boss, "深渊旋风")
    Sound3DII_CooPlayReuse(
        _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E["深渊旋风"]["旋风起手"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        _____6559_6D3E_5251_58EB_97F3_6548_914D_7F6E["音效裁断距离"]
    )
    registerManualBuff(
        boss,
        _____6559_6D3E_5251_58EBBuffID["深渊旋风"],
        _____914D_7F6E["施法硬直秒"],
        0,
        {sourceUnit = boss, effectSourceName = "深渊旋风", effectSourceType = "技能"}
    )
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____914D_7F6E["施法硬直秒"],
        ["颜色ID"] = _____914D_7F6E["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
    _____72B6_6001["周期回调ID"] = addPeriodicCallback(_____914D_7F6E["轮次间隔秒"] * 1000, ____on_6DF1_6E0A_65CB_98CE_8F6E_6B21, _____72B6_6001)
    local ____self_22 = _____4E0A_4E0B_6587["清理"]
    ____self_22["登记周期回调"](____self_22, "教派剑士-深渊旋风轮次", _____72B6_6001["周期回调ID"])
    debugLogForce(
        "教派剑士-深渊旋风",
        "施法开始",
        "bossHid=",
        GetHandleId(boss),
        "roundCount=",
        _____914D_7F6E["轮数"],
        "interval=",
        _____914D_7F6E["轮次间隔秒"]
    )
    return true
end
local function ____on_6559_6D3E_5251_58EB_6DF1_6E0A_65CB_98CE_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6DF1_6E0A_65CB_98CE_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587(castingUnit)
    local _____5DF2_5F00_59CB = _____4E0A_4E0B_6587 ~= nil and ____exports["释放教派剑士深渊旋风"](_____4E0A_4E0B_6587)
    debugLogForce(
        "教派剑士-深渊旋风",
        "正式SPELL_EFFECT入口",
        "bossHid=",
        GetHandleId(castingUnit),
        "started=",
        _____5DF2_5F00_59CB
    )
end
____exports["注册教派剑士深渊旋风"] = function()
    if _____6DF1_6E0A_65CB_98CE_5DF2_6CE8_518C then
        return
    end
    _____6DF1_6E0A_65CB_98CE_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_6559_6D3E_5251_58EB_6DF1_6E0A_65CB_98CE_751F_6548)
    registerDamageModifier(_____6559_6D3E_5251_58EB_65CB_98CE_9B54_6CD5_514D_75AB_4FEE_6B63, _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊旋风"]["魔法免疫修正优先级"])
end
return ____exports
