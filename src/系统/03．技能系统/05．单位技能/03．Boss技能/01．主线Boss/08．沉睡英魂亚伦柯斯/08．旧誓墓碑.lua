--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.01．运行时上下文")
local _____8FDB_5165_4E9A_4F26_67EF_65AFP3 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["进入亚伦柯斯P3"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.02．数值与表现配置")
local _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["亚伦柯斯正式设计配置"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.00．配置")
local _____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["亚伦柯斯单位技能配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.11．台词播放")
local _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放亚伦柯斯台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____07_FF0E_4E9A_4F26_67EF_65AF = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.07．亚伦柯斯")
local _____4E9A_4F26_67EF_65AFBuffID = ____07_FF0E_4E9A_4F26_67EF_65AF["亚伦柯斯BuffID"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local _____521B_5EFA_76F4_7EBF_5B9A_70B9_8F68_8FF9 = ____01_FF0ETS_539F_751F_5F39_5E55["创建直线定点轨迹"]
local ____22_FF0E_9650_6B21_5468_671F_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.22．限次周期执行器")
local _____521B_5EFA_5468_671F_884C_4E3A = ____22_FF0E_9650_6B21_5468_671F_6267_884C_5668["创建周期行为"]
local ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI = require("系统.09．表现系统.15．世界坐标进度UI.index")
local _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["创建世界坐标进度UI"]
local _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["更新世界坐标进度UI"]
local _____8BBE_7F6E_4E16_754C_5750_6807_8FDB_5EA6UI_663E_793A = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["设置世界坐标进度UI显示"]
local _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["销毁世界坐标进度UI"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_1["获取Boss技能随机敌对英雄"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_3["读取Boss战运行上下文"]
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_4["取当前有效玩家人数"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_5.getServerTime
local addDelayedCallback = ____require_result_5.addDelayedCallback
local ____require_result_6 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_6.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local GetRectCenterX = jass.GetRectCenterX
local GetRectCenterY = jass.GetRectCenterY
local Atan2 = jass.Atan2
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
local _____65E7_8A93_6B8B_5F71_6280_80FDKey = "旧誓墓碑残影"
local function _____9500_6BC1_5893_7891_7279_6548(state)
    if state["墓碑特效"] ~= nil and state["墓碑特效"] ~= 0 then
        DestroyEffect(state["墓碑特效"])
    end
    if state["范围特效"] ~= nil and state["范围特效"] ~= 0 then
        DestroyEffect(state["范围特效"])
    end
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(state["安魂进度UI"])
    state["墓碑特效"] = nil
    state["范围特效"] = nil
    state["安魂进度UI"] = nil
end
local function _____6E05_7406_5893_7891_5217_8868(context)
    do
        local i = 0
        while i < #context["墓碑状态列表"] do
            _____9500_6BC1_5893_7891_7279_6548(context["墓碑状态列表"][i + 1])
            i = i + 1
        end
    end
    context["墓碑状态列表"] = {}
    if _____5355_4F4D_6709_6548(context["Boss单位"]) then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____4E9A_4F26_67EF_65AFBuffID["旧誓加护"])
    end
end
local function _____5237_65B0_65E7_8A93_52A0_62A4Buff(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local count = context["未安魂墓碑数量"]
    if count <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____4E9A_4F26_67EF_65AFBuffID["旧誓加护"])
        return
    end
    local reduction = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["旧誓墓碑"]["未安魂减伤每层"] * 100
    registerManualBuff(
        boss,
        _____4E9A_4F26_67EF_65AFBuffID["旧誓加护"],
        3600,
        reduction,
        {stack = count, sourceName = "亚伦柯斯-旧誓墓碑"}
    )
end
local function _____5B8C_6210_5893_7891_5B89_9B42(context, state)
    if state["已安魂"] then
        return
    end
    state["已安魂"] = true
    _____9500_6BC1_5893_7891_7279_6548(state)
    context["已安魂墓碑数量"] = context["已安魂墓碑数量"] + 1
    context["未安魂墓碑数量"] = context["未安魂墓碑数量"] - 1
    if context["未安魂墓碑数量"] < 0 then
        context["未安魂墓碑数量"] = 0
    end
    _____5237_65B0_65E7_8A93_52A0_62A4Buff(context)
    local release = AddSpecialEffect(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["墓碑安魂完成特效路径"], state.X, state.Y)
    _____64AD_653EBoss_5750_6807_97F3_6548(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效"]["墓碑安魂"], state.X, state.Y, _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效默认裁断距离"])
    if release ~= nil and release ~= 0 then
        YDWETimerDestroyEffectSafe(1.4, release)
    end
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(context["Boss单位"], "墓碑安魂")
    if context["未安魂墓碑数量"] <= 0 then
        _____8FDB_5165_4E9A_4F26_67EF_65AFP3(context)
    end
end
local function _____53D6_672C_8F6E_5B89_9B42_6301_7EED_79D2()
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["旧誓墓碑"]
    return _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570() <= 1 and cfg["单人安魂持续秒"] or cfg["多人安魂持续秒"]
end
local function _____8303_56F4_5185_5B58_5728_73A9_5BB6(context, state)
    local radius = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["旧誓墓碑"]["安魂范围"]
    local testHero = context["测试安魂英雄"]
    if _____5355_4F4D_6709_6548(testHero) then
        local testDx = GetUnitX(testHero) - state.X
        local testDy = GetUnitY(testHero) - state.Y
        if testDx * testDx + testDy * testDy <= radius * radius then
            return true
        end
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    do
        local i = 0
        while i < #heroes do
            local dx = GetUnitX(heroes[i + 1]) - state.X
            local dy = GetUnitY(heroes[i + 1]) - state.Y
            if dx * dx + dy * dy <= radius * radius then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____5C1D_8BD5_91CA_653E_5893_7891_6B8B_5F71(context, state, now)
    local boss = context["Boss单位"]
    if context["当前大型技能"] ~= _____65E7_8A93_6B8B_5F71_6280_80FDKey and (context["当前大型技能"] ~= nil or now < context["普通机制忙碌到Ms"]) then
        return false
    end
    local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["旧誓墓碑"]
    local dx = GetUnitX(target) - state.X
    local dy = GetUnitY(target) - state.Y
    local facing = Atan2(dy, dx) * RAD_TO_DEG
    local endX = _____6781_5750_6807X(state.X, facing, cfg["残影斩击长度"])
    local endY = _____6781_5750_6807Y(state.Y, facing, cfg["残影斩击长度"])
    context["当前大型技能"] = _____65E7_8A93_6B8B_5F71_6280_80FDKey
    context["普通机制忙碌到Ms"] = now + (cfg["残影斩击预警秒"] + cfg["残影斩击飞行秒"] + 0.4) * 1000
    state["下次残影Ms"] = now + cfg["残影斩击间隔秒"] * 1000
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = state.X,
        Y = state.Y,
        ["宽度"] = cfg["残影斩击宽度"],
        ["长度"] = cfg["残影斩击长度"],
        ["朝向"] = facing,
        ["持续时间"] = cfg["残影斩击预警秒"],
        ["来源单位"] = boss
    })
    local delayedId = addDelayedCallback(
        cfg["残影斩击预警秒"] * 1000,
        function()
            if not context["战斗已结束"] and context["阶段"] == "P2旧誓回响" and not state["已安魂"] then
                local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
                _____521B_5EFA_539F_751F_5F39_5E55({
                    ["所有者"] = boss,
                    ["载体模式"] = "特效",
                    X = state.X,
                    Y = state.Y,
                    ["方向角"] = facing,
                    ["速度"] = cfg["残影斩击长度"] / cfg["残影斩击飞行秒"],
                    ["生命周期"] = cfg["残影斩击飞行秒"],
                    ["最大距离"] = cfg["残影斩击长度"],
                    ["轨迹采样器"] = _____521B_5EFA_76F4_7EBF_5B9A_70B9_8F68_8FF9(state.X, state.Y, endX, endY),
                    ["命中半径"] = cfg["残影斩击宽度"] * 0.5,
                    ["影响目标"] = "敌方",
                    ["每单位最大命中次数"] = 1,
                    ["碰撞消失"] = false,
                    ["禁用碰撞"] = true,
                    ["附加特效1"] = {["模型"] = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["墓碑残影模型路径"], ["跟随主弹幕参数"] = true},
                    ["目标筛选"] = function(unit)
                        do
                            local i = 0
                            while i < #heroes do
                                if heroes[i + 1] == unit then
                                    return true
                                end
                                i = i + 1
                            end
                        end
                        return false
                    end,
                    ["on命中"] = function(hit)
                        if not _____5355_4F4D_6709_6548(hit) then
                            return
                        end
                        _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                            ["来源"] = boss,
                            ["目标"] = hit,
                            ["伤害公式"] = {["来源攻击力比例"] = cfg["残影斩击伤害攻击力比例"], ["目标最大生命比例"] = cfg["残影斩击伤害目标最大生命比例"]},
                            attack = false,
                            ranged = true,
                            attackType = ATTACK_TYPE_NORMAL,
                            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                            weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                            ["标签"] = "亚伦柯斯·旧誓墓碑残影"
                        })
                    end
                })
            end
            local clearId = addDelayedCallback(
                cfg["残影斩击飞行秒"] * 1000,
                function()
                    if context["当前大型技能"] == _____65E7_8A93_6B8B_5F71_6280_80FDKey then
                        context["当前大型技能"] = nil
                    end
                end
            )
            local ____self_7 = context["清理"]
            ____self_7["登记延迟回调"](____self_7, "亚伦柯斯-墓碑残影飞行结束", clearId)
        end
    )
    local ____self_8 = context["清理"]
    ____self_8["登记延迟回调"](____self_8, "亚伦柯斯-墓碑残影", delayedId)
    return true
end
local function _____4E9A_4F26_67EF_65AF_5893_7891_63A8_8FDB_5468_671F(______6267_884C_6B21_6570, variable)
    local data = variable
    local context = data and data.context
    local cfg = data and data.cfg
    local _____5B89_9B42_6301_7EED_79D2 = data and data["安魂持续秒"]
    if context == nil or cfg == nil or _____5B89_9B42_6301_7EED_79D2 == nil then
        return false
    end
    if context["战斗已结束"] or context["阶段"] ~= "P2旧誓回响" then
        return false
    end
    local current = getServerTime()
    do
        local i = 0
        while i < #context["墓碑状态列表"] do
            do
                local state = context["墓碑状态列表"][i + 1]
                if state["已安魂"] then
                    goto __continue41
                end
                local hasPlayer = _____8303_56F4_5185_5B58_5728_73A9_5BB6(context, state)
                if hasPlayer then
                    state["安魂进度秒"] = state["安魂进度秒"] + cfg["检查间隔秒"]
                else
                    state["安魂进度秒"] = state["安魂进度秒"] - cfg["离开每次回退秒"]
                    if state["安魂进度秒"] < 0 then
                        state["安魂进度秒"] = 0
                    end
                end
                _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(state["安魂进度UI"], state["安魂进度秒"])
                _____8BBE_7F6E_4E16_754C_5750_6807_8FDB_5EA6UI_663E_793A(state["安魂进度UI"], true)
                if state["安魂进度秒"] >= _____5B89_9B42_6301_7EED_79D2 then
                    _____5B8C_6210_5893_7891_5B89_9B42(context, state)
                    goto __continue41
                end
                if current >= state["下次残影Ms"] then
                    _____5C1D_8BD5_91CA_653E_5893_7891_6B8B_5F71(context, state, current)
                end
            end
            ::__continue41::
            i = i + 1
        end
    end
    return true
end
____exports["启动亚伦柯斯旧誓墓碑"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] or context["阶段"] ~= "P2旧誓回响" or context["墓碑机制已启动"] then
        return false
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["旧誓墓碑"]
    local _____5B89_9B42_6301_7EED_79D2 = _____53D6_672C_8F6E_5B89_9B42_6301_7EED_79D2()
    local battle = _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(boss)
    local ____opt_result_17
    if battle ~= nil then
        ____opt_result_17 = battle["地点矩形"]
    end
    local rect = ____opt_result_17
    local centerX = rect ~= nil and rect ~= 0 and GetRectCenterX(rect) or _____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["中心X"]
    local centerY = rect ~= nil and rect ~= 0 and GetRectCenterY(rect) or _____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["中心Y"]
    local facings = {90, 210, 330}
    local now = getServerTime()
    context["墓碑机制已启动"] = true
    context["普通机制忙碌到Ms"] = now + cfg["启动硬直秒"] * 1000
    _____5F00_59CB_786C_76F4(boss, cfg["启动硬直秒"])
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["启动动画编号"], ["持续秒"] = cfg["启动硬直秒"], ["恢复动画编号"] = 1})
    context["已安魂墓碑数量"] = 0
    context["未安魂墓碑数量"] = cfg["数量"]
    context["墓碑状态列表"] = {}
    do
        local i = 0
        while i < cfg["数量"] and i < #facings do
            local x = _____6781_5750_6807X(centerX, facings[i + 1], cfg["场地中心偏移半径"])
            local y = _____6781_5750_6807Y(centerY, facings[i + 1], cfg["场地中心偏移半径"])
            local state = {
                X = x,
                Y = y,
                ["安魂进度秒"] = 0,
                ["已安魂"] = false,
                ["墓碑特效"] = AddSpecialEffect(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["誓约墓碑模型路径"], x, y),
                ["范围特效"] = AddSpecialEffect(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["墓碑安魂范围特效路径"], x, y),
                ["安魂进度UI"] = _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI({
                    X = x,
                    Y = y,
                    Z = 220,
                    ["最大值"] = _____5B89_9B42_6301_7EED_79D2,
                    ["当前值"] = 0,
                    ["标题"] = "安魂",
                    ["数值后缀"] = "秒",
                    ["类型"] = "安魂",
                    ["平滑过渡秒"] = cfg["检查间隔秒"],
                    ["初始显示"] = true,
                    ["雾中可见"] = false
                }),
                ["下次残影Ms"] = now + cfg["残影斩击间隔秒"] * 1000
            }
            local ____context__5893_7891_72B6_6001_5217_8868_18 = context["墓碑状态列表"]
            ____context__5893_7891_72B6_6001_5217_8868_18[#____context__5893_7891_72B6_6001_5217_8868_18 + 1] = state
            i = i + 1
        end
    end
    local ____self_19 = context["清理"]
    ____self_19["登记清理"](
        ____self_19,
        "亚伦柯斯-旧誓墓碑统一清理",
        function()
            _____6E05_7406_5893_7891_5217_8868(context)
        end
    )
    _____5237_65B0_65E7_8A93_52A0_62A4Buff(context)
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(boss, "旧誓墓碑")
    _____521B_5EFA_5468_671F_884C_4E3A({
        ["名称"] = "亚伦柯斯-旧誓墓碑推进",
        ["间隔毫秒"] = cfg["检查间隔秒"] * 1000,
        ["清理"] = context["清理"],
        ["变量"] = {context = context, cfg = cfg, ["安魂持续秒"] = _____5B89_9B42_6301_7EED_79D2},
        onTick = _____4E9A_4F26_67EF_65AF_5893_7891_63A8_8FDB_5468_671F
    })
    return true
end
____exports["旧誓墓碑机制状态"] = {
    ["类型"] = "P2阶段机制",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "固定生成三座不可攻击的誓约墓碑，玩家连续站入完成安魂；未安魂层数同步减伤Buff并锁定35%最低生命。",
    ["实现要求"] = "安魂进度、残影斩击、减伤层数和阶段血量锁统一挂入运行时清理篮子。"
}
return ____exports
