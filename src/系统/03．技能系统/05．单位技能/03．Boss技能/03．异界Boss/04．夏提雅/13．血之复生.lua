local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["重置夏提雅猎血连击"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.00．配置")
local _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["夏提雅单位技能配置"]
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
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_0["读取Boss战运行上下文"]
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_1["取当前有效玩家人数"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_3["显示大招吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_4["广播单位提示"]
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_5.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local PauseUnit = jass.PauseUnit
local SetUnitPathing = jass.SetUnitPathing
local IssueImmediateOrder = jass.IssueImmediateOrder
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local IsUnitType = jass.IsUnitType
local GetRectCenterX = jass.GetRectCenterX
local GetRectCenterY = jass.GetRectCenterY
local GetRectMinX = jass.GetRectMinX
local GetRectMinY = jass.GetRectMinY
local GetRectMaxX = jass.GetRectMaxX
local GetRectMaxY = jass.GetRectMaxY
local CosBJ = jass.CosBJ
local SinBJ = jass.SinBJ
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____8840_4E4B_590D_751F_6280_80FDKey = "血之复生"
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
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
    local ____opt_result_8
    if battle ~= nil then
        ____opt_result_8 = battle["地点矩形"]
    end
    local rect = ____opt_result_8
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
    local ____opt_result_11
    if battle ~= nil then
        ____opt_result_11 = battle["地点矩形"]
    end
    local rect = ____opt_result_11
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
        YDWETimerDestroyEffectSafe(0.05, effect)
    end
end
local function _____64AD_653E_590D_751F_6210_529F_8868_73B0(boss)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local weave = AddSpecialEffect(cfg["表现资源"]["血之复生重构丝流路径"], x, y)
    local burst = AddSpecialEffect(cfg["表现资源"]["血之复生成功爆发路径"], x, y)
    if weave ~= nil and weave ~= 0 then
        YDWETimerDestroyEffectSafe(cfg["血之复生"]["复生成功特效持续秒"], weave)
    end
    if burst ~= nil and burst ~= 0 then
        YDWETimerDestroyEffectSafe(cfg["血之复生"]["复生成功特效持续秒"], burst)
    end
end
local function _____7EDF_8BA1_5B58_6D3B_7ED3_6676(crystals)
    local count = 0
    do
        local i = 0
        while i < #crystals do
            if crystals[i + 1]["是否存活"]() then
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
            crystals[i + 1]["销毁"]()
            i = i + 1
        end
    end
end
local function _____5B8C_6210_590D_751F_6210_529F(context, _____5269_4F59_7ED3_6676)
    local boss = context["Boss单位"]
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血之复生"]
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    SetUnitState(boss, UNIT_STATE_LIFE, maxLife * cfg["单枚恢复生命比例"] * _____5269_4F59_7ED3_6676)
    _____64AD_653E_590D_751F_6210_529F_8868_73B0(boss)
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
            PauseUnit(boss, false)
            SetUnitInvulnerable(boss, false)
            if context["当前大型技能"] == _____8840_4E4B_590D_751F_6280_80FDKey then
                context["当前大型技能"] = nil
            end
        end
    )
    local ____self_12 = context["清理"]
    ____self_12["登记延迟回调"](____self_12, "夏提雅-复生成功恢复行动", delayedId)
end
____exports["启动夏提雅血之复生"] = function(context, ____on_590D_751F_5931_8D25)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["阶段"] ~= "复生仪式" or context["当前大型技能"] ~= _____8840_4E4B_590D_751F_6280_80FDKey then
        return false
    end
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血之复生"]
    local crystals = {}
    local points = _____53D6_590D_751F_7ED3_6676_70B9(boss)
    local hitCount = _____53D6_590D_751F_7ED3_6676_53D7_51FB_6B21_6570()
    local executor
    local executionId = 0
    IssueImmediateOrder(boss, "stop")
    SetUnitInvulnerable(boss, true)
    PauseUnit(boss, true)
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
                    ["缩放"] = cfg["结晶缩放"],
                    ["on受击"] = function(unit, remaining)
                        if remaining <= 0 then
                            return
                        end
                        SetUnitState(
                            unit,
                            UNIT_STATE_LIFE,
                            GetUnitState(unit, UNIT_STATE_MAX_LIFE) * remaining / hitCount
                        )
                    end,
                    ["on击破"] = function(unit)
                        _____64AD_653E_7ED3_6676_7834_88C2(unit)
                        local remaining = _____7EDF_8BA1_5B58_6D3B_7ED3_6676(crystals)
                        _____5E7F_64AD_5355_4F4D_63D0_793A(
                            boss,
                            ("|cffff99aa复生结晶破碎，剩余 " .. tostring(remaining)) .. " 枚。|r",
                            2200
                        )
                        if remaining == 0 and executionId ~= 0 then
                            if executor ~= nil then
                                executor["停止"](executor, executionId, "完成")
                            end
                        end
                    end
                })
                if crystal == nil then
                    goto __continue32
                end
                PauseUnit(crystal["单位"], true)
                SetUnitPathing(crystal["单位"], false)
                crystals[#crystals + 1] = crystal
            end
            ::__continue32::
            i = i + 1
        end
    end
    if #crystals <= 0 then
        PauseUnit(boss, false)
        SetUnitInvulnerable(boss, false)
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
                    _____6E05_7406_590D_751F_7ED3_6676(crystals)
                    return
                end
                local remaining = _____7EDF_8BA1_5B58_6D3B_7ED3_6676(crystals)
                _____6E05_7406_590D_751F_7ED3_6676(crystals)
                if remaining <= 0 then
                    _____5E7F_64AD_5355_4F4D_63D0_793A(boss, _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["广播台词"]["复生失败"], 3600)
                    ____on_590D_751F_5931_8D25(context)
                    return
                end
                _____5B8C_6210_590D_751F_6210_529F(context, remaining)
            end
        }
    )
    if executionId == 0 then
        _____6E05_7406_590D_751F_7ED3_6676(crystals)
        PauseUnit(boss, false)
        SetUnitInvulnerable(boss, false)
        return false
    end
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["仪式动画编号"], ["持续秒"] = cfg["仪式秒"], ["恢复动画编号"] = 0})
    _____663E_793A_5927_62DB_541F_5531_6761({
        ["通道"] = "大招",
        ["总时长"] = cfg["仪式秒"],
        ["颜色ID"] = 2,
        ["标题文本"] = "血之复生",
        ["提示文本"] = "在仪式结束前摧毁三枚复生结晶"
    })
    _____5E7F_64AD_5355_4F4D_63D0_793A(boss, _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["广播台词"]["血之复生"], 3600)
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
