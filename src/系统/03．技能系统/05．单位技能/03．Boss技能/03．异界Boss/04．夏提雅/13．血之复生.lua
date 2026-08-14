local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["重置夏提雅猎血连击"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.01．多阶段技能编排.06．技能阶段链执行器")
local _____521B_5EFA_5EF6_8FDF_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建延迟阶段"]
local ____03_FF0E_56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.03．固定受击次数机制单位")
local _____521B_5EFA_56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D = ____03_FF0E_56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D["创建固定受击次数机制单位"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["执行战斗自身传送到坐标"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
local _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6 = ____00_FF0E_5171_4EAB["确保单位可设置飞行高度"]
local GetUnitFlyHeight = ____00_FF0E_5171_4EAB.GetUnitFlyHeight
local SetUnitFlyHeight = ____00_FF0E_5171_4EAB.SetUnitFlyHeight
local ____18_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.18．台词播放")
local _____64AD_653E_590F_63D0_96C5_53F0_8BCD = ____18_FF0E_53F0_8BCD_64AD_653E["播放夏提雅台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_0["暂停并设置无敌安全"]
local _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_0["解除暂停并取消无敌安全"]
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_2["读取Boss战运行上下文"]
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_3["取当前有效玩家人数"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_4.getServerTime
local addDelayedCallback = ____require_result_4.addDelayedCallback
local ____require_result_5 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_5["显示大招吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_5["关闭吟唱条"]
local ____require_result_6 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_6["广播单位提示"]
local ____require_result_7 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_7.YDWETimerDestroyEffectSafe
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____8BBE_7F6E_7279_6548_7F29_653E = ____require_result_8["设置特效缩放"]
local ____require_result_9 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_9.doHeal
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_10 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_10.CosBJ
local SinBJ = ____require_result_10.SinBJ
local GetUnitStateJapi = japi.GetUnitState
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local SetUnitPathing = jass.SetUnitPathing
local IssueImmediateOrder = jass.IssueImmediateOrder
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local IsUnitType = jass.IsUnitType
local GetRectCenterX = jass.GetRectCenterX
local GetRectCenterY = jass.GetRectCenterY
local GetRectMinX = jass.GetRectMinX
local GetRectMinY = jass.GetRectMinY
local GetRectMaxX = jass.GetRectMaxX
local GetRectMaxY = jass.GetRectMaxY
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____8840_4E4B_590D_751F_6280_80FDKey = "血之复生"
local _____8840_4E4B_590D_751FBoss_6682_505C_6765_6E90 = "Boss:夏提雅:血之复生"
local _____8840_4E4B_590D_751F_7ED3_6676_6682_505C_6765_6E90 = "Boss:夏提雅:血之复生结晶"
local function _____53D6_590D_751F_7ED3_6676_53D7_51FB_6B21_6570()
    local _____73A9_5BB6_4EBA_6570 = __TS__Number(_____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570()) or 1
    if _____73A9_5BB6_4EBA_6570 < 1 then
        _____73A9_5BB6_4EBA_6570 = 1
    end
    if _____73A9_5BB6_4EBA_6570 > 5 then
        _____73A9_5BB6_4EBA_6570 = 5
    end
    return _____73A9_5BB6_4EBA_6570 * _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血之复生"]["每名玩家受击次数"]
end
local function _____53D6_590D_751F_7ED3_6676_70B9(boss)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血之复生"]
    local battle = _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(boss)
    local ____opt_result_13
    if battle ~= nil then
        ____opt_result_13 = battle["地点矩形"]
    end
    local rect = ____opt_result_13
    if rect ~= nil and rect ~= 0 then
        local inset = cfg["场地边缘内缩"]
        return {
            {
                X = GetRectCenterX(rect),
                Y = GetRectMaxY(rect) - inset
            },
            {
                X = GetRectMinX(rect) + inset,
                Y = GetRectMinY(rect) + inset
            },
            {
                X = GetRectMaxX(rect) - inset,
                Y = GetRectMinY(rect) + inset
            }
        }
    end
    local centerX = GetUnitX(boss)
    local centerY = GetUnitY(boss)
    local radius = cfg["无场地矩形摆放半径"]
    local facings = {90, 210, 330}
    local result = {}
    do
        local i = 0
        while i < #facings do
            result[#result + 1] = {
                X = centerX + CosBJ(facings[i + 1]) * radius,
                Y = centerY + SinBJ(facings[i + 1]) * radius
            }
            i = i + 1
        end
    end
    return result
end
local function _____79FB_52A8_590F_63D0_96C5_5230_573A_5730_4E2D_5FC3(boss)
    local battle = _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(boss)
    local ____opt_result_16
    if battle ~= nil then
        ____opt_result_16 = battle["地点矩形"]
    end
    local rect = ____opt_result_16
    if rect ~= nil and rect ~= 0 then
        _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(
            boss,
            GetRectCenterX(rect),
            GetRectCenterY(rect)
        )
    end
end
local function _____64AD_653E_7ED3_6676_7834_88C2(unit)
    if unit == nil or unit == 0 then
        return
    end
    local effect = AddSpecialEffect(
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["血之复生结晶模型路径"],
        GetUnitX(unit),
        GetUnitY(unit)
    )
    if effect ~= nil and effect ~= 0 then
        _____8BBE_7F6E_7279_6548_7F29_653E(effect, _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血之复生"]["结晶缩放"])
        YDWETimerDestroyEffectSafe(0.05, effect)
    end
end
local function _____64AD_653E_590D_751F_6210_529F_7279_6548_6279_6B21(boss, _____6301_7EED_79D2)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E
    if not _____5355_4F4D_6709_6548(boss) or not (_____6301_7EED_79D2 > 0) then
        return
    end
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local weave = AddSpecialEffect(cfg["表现资源"]["血之复生重构丝流路径"], x, y)
    local burst = AddSpecialEffect(cfg["表现资源"]["血之复生成功爆发路径"], x, y)
    if weave ~= nil and weave ~= 0 then
        _____8BBE_7F6E_7279_6548_7F29_653E(weave, cfg["血之复生"]["复生成功重构丝流缩放"])
        YDWETimerDestroyEffectSafe(_____6301_7EED_79D2, weave)
    end
    if burst ~= nil and burst ~= 0 then
        _____8BBE_7F6E_7279_6548_7F29_653E(burst, cfg["血之复生"]["复生成功爆发缩放"])
        YDWETimerDestroyEffectSafe(_____6301_7EED_79D2, burst)
    end
end
local function _____767B_8BB0_590D_751F_6210_529F_7279_6548_6279_6B21(context, boss, _____5EF6_8FDF_79D2, _____6301_7EED_79D2, _____5E8F_53F7)
    local delayedId = addDelayedCallback(
        _____5EF6_8FDF_79D2 * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
                return
            end
            _____64AD_653E_590D_751F_6210_529F_7279_6548_6279_6B21(boss, _____6301_7EED_79D2)
        end
    )
    local ____self_17 = context["清理"]
    ____self_17["登记延迟回调"](
        ____self_17,
        "夏提雅-复生成功特效-" .. tostring(_____5E8F_53F7),
        delayedId
    )
end
local function _____64AD_653E_590D_751F_6210_529F_8868_73B0(context)
    local boss = context["Boss单位"]
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血之复生"]
    local _____603B_65F6_957F = cfg["复生成功特效持续秒"]
    local _____95F4_9694 = cfg["复生成功特效间隔秒"] > 0 and cfg["复生成功特效间隔秒"] or _____603B_65F6_957F
    if not (_____603B_65F6_957F > 0) or not (_____95F4_9694 > 0) then
        return
    end
    local _____5DF2_7ECF_8FC7_79D2 = 0
    local _____5E8F_53F7 = 1
    while _____5DF2_7ECF_8FC7_79D2 < _____603B_65F6_957F do
        local _____5269_4F59_79D2 = _____603B_65F6_957F - _____5DF2_7ECF_8FC7_79D2
        if _____5DF2_7ECF_8FC7_79D2 == 0 then
            _____64AD_653E_590D_751F_6210_529F_7279_6548_6279_6B21(boss, _____5269_4F59_79D2)
        else
            _____767B_8BB0_590D_751F_6210_529F_7279_6548_6279_6B21(
                context,
                boss,
                _____5DF2_7ECF_8FC7_79D2,
                _____5269_4F59_79D2,
                _____5E8F_53F7
            )
        end
        _____5DF2_7ECF_8FC7_79D2 = _____5DF2_7ECF_8FC7_79D2 + _____95F4_9694
        _____5E8F_53F7 = _____5E8F_53F7 + 1
    end
end
local function _____6267_884C_590D_751F_6210_529F_56DE_8840(context, boss, _____6062_590D_91CF)
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or not (_____6062_590D_91CF > 0) then
        return
    end
    doHeal({
        HealSource = boss,
        HealTarget = boss,
        HealAmount = _____6062_590D_91CF,
        ItemHeal = false,
        HealEffect = false
    })
end
local function _____767B_8BB0_590D_751F_6210_529F_56DE_8840(context, boss, _____5EF6_8FDF_79D2, _____6062_590D_91CF, _____5E8F_53F7)
    local delayedId = addDelayedCallback(
        _____5EF6_8FDF_79D2 * 1000,
        function()
            _____6267_884C_590D_751F_6210_529F_56DE_8840(context, boss, _____6062_590D_91CF)
        end
    )
    local ____self_18 = context["清理"]
    ____self_18["登记延迟回调"](
        ____self_18,
        "夏提雅-复生成功回血-" .. tostring(_____5E8F_53F7),
        delayedId
    )
end
local function _____5B89_6392_590D_751F_6210_529F_56DE_8840(context, boss, _____603B_6062_590D_91CF)
    local _____603B_65F6_957F = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血之复生"]["复生成功特效持续秒"]
    local _____6B21_6570 = 4
    if not (_____603B_6062_590D_91CF > 0) or not (_____603B_65F6_957F > 0) then
        return
    end
    local _____5355_6B21_6062_590D_91CF = _____603B_6062_590D_91CF / _____6B21_6570
    local _____95F4_9694_79D2 = _____603B_65F6_957F / _____6B21_6570
    do
        local i = 0
        while i < _____6B21_6570 do
            local _____5EF6_8FDF_79D2 = i * _____95F4_9694_79D2
            if i == 0 then
                _____6267_884C_590D_751F_6210_529F_56DE_8840(context, boss, _____5355_6B21_6062_590D_91CF)
            else
                _____767B_8BB0_590D_751F_6210_529F_56DE_8840(
                    context,
                    boss,
                    _____5EF6_8FDF_79D2,
                    _____5355_6B21_6062_590D_91CF,
                    i + 1
                )
            end
            i = i + 1
        end
    end
end
local function _____6062_590D_590F_63D0_96C5_590D_751F_52A8_753B_901F_5EA6(boss)
    if boss == nil or boss == 0 then
        return
    end
    SetUnitTimeScale(boss, 1)
end
local function _____7EDF_8BA1_5B58_6D3B_7ED3_6676(crystals)
    local count = 0
    do
        local i = 0
        while i < #crystals do
            local ____self_19 = crystals[i + 1]
            if ____self_19["是否存活"](____self_19) then
                count = count + 1
            end
            i = i + 1
        end
    end
    return count
end
local function _____6E05_7406_590D_751F_7ED3_6676(crystals)
    do
        local i = 0
        while i < #crystals do
            _____79FB_9664_5355_4F4D_6682_505C(crystals[i + 1]["单位"], _____8840_4E4B_590D_751F_7ED3_6676_6682_505C_6765_6E90)
            local ____self_20 = crystals[i + 1]
            ____self_20["销毁"](____self_20)
            i = i + 1
        end
    end
end
local function _____6E05_7406_590F_63D0_96C5_8840_4E4B_590D_751F_6682_505C_72B6_6001(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001["恢复复生表现"]()
    _____6E05_7406_590D_751F_7ED3_6676(_____72B6_6001["结晶列表"])
    _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(_____72B6_6001["Boss单位"], _____8840_4E4B_590D_751FBoss_6682_505C_6765_6E90)
end
local function _____5B8C_6210_590D_751F_6210_529F(context, _____5269_4F59_7ED3_6676, _____6062_590D_590D_751F_8868_73B0)
    local boss = context["Boss单位"]
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血之复生"]
    local maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE)
    local _____603B_6062_590D_91CF = maxLife * cfg["单枚恢复生命比例"] * _____5269_4F59_7ED3_6676
    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "复生成功")
    _____5B89_6392_590D_751F_6210_529F_56DE_8840(context, boss, _____603B_6062_590D_91CF)
    _____6062_590D_590D_751F_8868_73B0()
    _____64AD_653E_590D_751F_6210_529F_8868_73B0(context)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["血之复生成功"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    context["阶段"] = "P3真祖血宴"
    context["上次阶段变化Ms"] = getServerTime()
    context["普通机制忙碌到Ms"] = context["上次阶段变化Ms"] + (cfg["复生成功恢复动作延迟秒"] + 1) * 1000
    local delayedId = addDelayedCallback(
        cfg["复生成功恢复动作延迟秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["阶段"] ~= "P3真祖血宴" then
                return
            end
            SetUnitAnimationByIndex(boss, 0)
            _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(boss, _____8840_4E4B_590D_751FBoss_6682_505C_6765_6E90)
            if context["当前大型技能"] == _____8840_4E4B_590D_751F_6280_80FDKey then
                context["当前大型技能"] = nil
            end
        end
    )
    local ____self_21 = context["清理"]
    ____self_21["登记延迟回调"](____self_21, "夏提雅-复生成功恢复行动", delayedId)
end
____exports["启动夏提雅血之复生"] = function(context, ____on_590D_751F_5931_8D25)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["阶段"] ~= "复生仪式" or context["当前大型技能"] ~= _____8840_4E4B_590D_751F_6280_80FDKey then
        return false
    end
    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "血之复生")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["血之复生仪式"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血之复生"]
    local _____51BB_7ED3_524D_98DE_884C_9AD8_5EA6 = 0
    local _____5DF2_5E94_7528_51BB_7ED3_9AD8_5EA6 = false
    local function _____6062_590D_590D_751F_8868_73B0()
        _____6062_590D_590F_63D0_96C5_590D_751F_52A8_753B_901F_5EA6(boss)
        if not _____5DF2_5E94_7528_51BB_7ED3_9AD8_5EA6 or not _____5355_4F4D_6709_6548(boss) then
            return
        end
        _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(boss)
        SetUnitFlyHeight(boss, _____51BB_7ED3_524D_98DE_884C_9AD8_5EA6, 0)
        _____5DF2_5E94_7528_51BB_7ED3_9AD8_5EA6 = false
    end
    local function _____5E94_7528_590D_751F_51BB_7ED3_9AD8_5EA6()
        if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= _____8840_4E4B_590D_751F_6280_80FDKey or _____5DF2_5E94_7528_51BB_7ED3_9AD8_5EA6 then
            return
        end
        _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(boss)
        _____51BB_7ED3_524D_98DE_884C_9AD8_5EA6 = GetUnitFlyHeight(boss)
        SetUnitFlyHeight(boss, _____51BB_7ED3_524D_98DE_884C_9AD8_5EA6 + cfg["仪式动画冻结高度增加"], 0)
        _____5DF2_5E94_7528_51BB_7ED3_9AD8_5EA6 = true
    end
    local crystals = {}
    local points = _____53D6_590D_751F_7ED3_6676_70B9(boss)
    local hitCount = _____53D6_590D_751F_7ED3_6676_53D7_51FB_6B21_6570()
    local executor
    local executionId = 0
    IssueImmediateOrder(boss, "stop")
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(boss, _____8840_4E4B_590D_751FBoss_6682_505C_6765_6E90)
    local ____self_22 = context["清理"]
    ____self_22["登记清理"](____self_22, "夏提雅-血之复生暂停来源", _____6E05_7406_590F_63D0_96C5_8840_4E4B_590D_751F_6682_505C_72B6_6001, {["Boss单位"] = boss, ["结晶列表"] = crystals, ["恢复复生表现"] = _____6062_590D_590D_751F_8868_73B0})
    _____79FB_52A8_590F_63D0_96C5_5230_573A_5730_4E2D_5FC3(boss)
    _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
    context["普通机制忙碌到Ms"] = getServerTime() + cfg["仪式秒"] * 1000
    do
        local i = 0
        while i < cfg["结晶数量"] and i < #points do
            do
                local point = points[i + 1]
                local crystal = _____521B_5EFA_56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D({
                    ["清理"] = context["清理"],
                    ["名称"] = "夏提雅-血之复生结晶-" .. tostring(i + 1),
                    ["主人单位"] = boss,
                    ["所属玩家"] = GetOwningPlayer(boss),
                    ["单位类型"] = cfg["结晶单位ID"],
                    ["模型路径"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["血之复生结晶模型路径"],
                    X = point.X,
                    Y = point.Y,
                    ["最大生命"] = 999999,
                    ["生命值受小怪倍率"] = false,
                    ["受击次数"] = hitCount,
                    ["计数模式"] = "纯普攻或最终伤害阈值",
                    ["最终伤害计数阈值"] = cfg["技能伤害计数阈值"],
                    ["同步生命条"] = true,
                    ["缩放"] = cfg["结晶缩放"],
                    ["on击破"] = function(unit)
                        _____64AD_653E_7ED3_6676_7834_88C2(unit)
                        _____79FB_9664_5355_4F4D_6682_505C(unit, _____8840_4E4B_590D_751F_7ED3_6676_6682_505C_6765_6E90)
                        local remaining = _____7EDF_8BA1_5B58_6D3B_7ED3_6676(crystals)
                        if remaining > 0 then
                            _____5E7F_64AD_5355_4F4D_63D0_793A(
                                boss,
                                ((("|cffff99aa复生结晶破碎，剩余" .. tostring(remaining)) .. "枚；仪式结束时每枚存活结晶使夏提雅恢复") .. tostring(cfg["单枚恢复生命比例"] * 100)) .. "%最大生命。（继续击破剩余结晶，全部摧毁即可阻止复生。）|r",
                                3600
                            )
                        else
                            _____5E7F_64AD_5355_4F4D_63D0_793A(
                                boss,
                                ("|cffff99aa复生结晶已全部摧毁。（" .. tostring(cfg["仪式秒"])) .. "秒仪式将失败，保持输出。）|r",
                                2400
                            )
                        end
                        if remaining == 0 and executionId ~= 0 then
                            if executor ~= nil then
                                executor["停止"](executor, executionId, "完成")
                            end
                        end
                    end
                })
                if crystal == nil then
                    goto __continue58
                end
                _____6DFB_52A0_5355_4F4D_6682_505C(crystal["单位"], _____8840_4E4B_590D_751F_7ED3_6676_6682_505C_6765_6E90)
                SetUnitPathing(crystal["单位"], false)
                crystals[#crystals + 1] = crystal
            end
            ::__continue58::
            i = i + 1
        end
    end
    if #crystals <= 0 then
        _____6062_590D_590D_751F_8868_73B0()
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(boss, _____8840_4E4B_590D_751FBoss_6682_505C_6765_6E90)
        return false
    end
    executor = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "夏提雅-血之复生", ["清理"] = context["清理"], ["互斥组"] = "夏提雅大型技能"})
    executionId = executor["开始"](
        executor,
        {
            key = _____8840_4E4B_590D_751F_6280_80FDKey,
            ["单位"] = boss,
            ["上下文"] = context,
            ["阶段列表"] = {_____521B_5EFA_5EF6_8FDF_9636_6BB5(cfg["仪式秒"] * 1000, "复生仪式倒计时")},
            ["最大持续毫秒"] = (cfg["仪式秒"] + 1) * 1000,
            ["结束回调"] = function(event)
                _____5173_95ED_541F_5531_6761("大招")
                if event["原因"] ~= "完成" or context["挑战已结束"] then
                    _____6062_590D_590D_751F_8868_73B0()
                    _____6E05_7406_590D_751F_7ED3_6676(crystals)
                    _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(boss, _____8840_4E4B_590D_751FBoss_6682_505C_6765_6E90)
                    return
                end
                local remaining = _____7EDF_8BA1_5B58_6D3B_7ED3_6676(crystals)
                _____6E05_7406_590D_751F_7ED3_6676(crystals)
                if remaining <= 0 then
                    _____6062_590D_590D_751F_8868_73B0()
                    _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(boss, _____8840_4E4B_590D_751FBoss_6682_505C_6765_6E90)
                    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "复生失败")
                    _____64AD_653EBoss_5750_6807_97F3_6548(
                        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["血之复生失败"],
                        GetUnitX(boss),
                        GetUnitY(boss),
                        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
                    )
                    ____on_590D_751F_5931_8D25(context)
                    return
                end
                _____5B8C_6210_590D_751F_6210_529F(context, remaining, _____6062_590D_590D_751F_8868_73B0)
            end
        }
    )
    if executionId == 0 then
        _____6062_590D_590D_751F_8868_73B0()
        _____6E05_7406_590D_751F_7ED3_6676(crystals)
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(boss, _____8840_4E4B_590D_751FBoss_6682_505C_6765_6E90)
        return false
    end
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["仪式动画编号"], ["持续秒"] = cfg["仪式秒"], ["恢复动画编号"] = 0})
    local _____62AC_9AD8_5EF6_8FDF_79D2 = cfg["仪式动画冻结秒"] - cfg["仪式动画冻结高度提前秒"]
    local _____62AC_9AD8_52A8_753BID = addDelayedCallback(
        (_____62AC_9AD8_5EF6_8FDF_79D2 > 0 and _____62AC_9AD8_5EF6_8FDF_79D2 or 0) * 1000,
        function()
            _____5E94_7528_590D_751F_51BB_7ED3_9AD8_5EA6()
        end
    )
    local ____self_25 = context["清理"]
    ____self_25["登记延迟回调"](____self_25, "夏提雅-血之复生提前抬高", _____62AC_9AD8_52A8_753BID)
    local _____51BB_7ED3_52A8_753BID = addDelayedCallback(
        cfg["仪式动画冻结秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= _____8840_4E4B_590D_751F_6280_80FDKey then
                return
            end
            _____5E94_7528_590D_751F_51BB_7ED3_9AD8_5EA6()
            SetUnitTimeScale(boss, 0)
        end
    )
    local ____self_26 = context["清理"]
    ____self_26["登记延迟回调"](____self_26, "夏提雅-血之复生冻结施法动画", _____51BB_7ED3_52A8_753BID)
    _____663E_793A_5927_62DB_541F_5531_6761({
        ["通道"] = "大招",
        ["总时长"] = cfg["仪式秒"],
        ["颜色ID"] = 2,
        ["标题文本"] = "血之复生",
        ["提示文本"] = ((((tostring(cfg["仪式秒"]) .. "秒内摧毁") .. tostring(cfg["结晶数量"])) .. "枚复生结晶；每枚存活结晶恢复") .. tostring(cfg["单枚恢复生命比例"] * 100)) .. "%最大生命（全部击破即可阻止复生）"
    })
    return true
end
____exports["血之复生机制状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["类型"] = "一次性锁血复生机制",
    ["语义"] = "第一次归零后生成三枚复生结晶；每剩一枚恢复10%生命，全部摧毁则直接结束挑战。",
    ["实现要求"] = "只触发一次，结晶耐久按有效玩家人数调整；公共固定组合时间轴负责12秒仪式，公共机制单位负责受击次数与统一清理。"
}
return ____exports
