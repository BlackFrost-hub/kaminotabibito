--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.00．配置")
local _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["祖地双灵卫单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.01．机制清理篮子")
local _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50 = ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50["创建机制清理篮子"]
local ____20_FF0E_8054_5408_6218_6597_6210_5458_751F_547D_5468_671F = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.20．联合战斗成员生命周期")
local _____521B_5EFA_8054_5408_6218_6597_6210_5458_751F_547D_5468_671F = ____20_FF0E_8054_5408_6218_6597_6210_5458_751F_547D_5468_671F["创建联合战斗成员生命周期"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_0["读取Boss战运行上下文"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRectCenterX = jass.GetRectCenterX
local GetRectCenterY = jass.GetRectCenterY
local GetRectMinX = jass.GetRectMinX
local GetRectMaxX = jass.GetRectMaxX
local GetRectMinY = jass.GetRectMinY
local GetRectMaxY = jass.GetRectMaxY
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local _____8D64_8A93_6B63_5E38ID = stringToFourCC(_____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["赤誓灵卫"]["单位ID"])
local _____8D64_8A93_53D8_5F02ID = stringToFourCC(_____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["赤誓灵卫"]["变异单位ID"])
local _____82CD_5F71_6B63_5E38ID = stringToFourCC(_____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["苍影灵卫"]["单位ID"])
local _____82CD_5F71_53D8_5F02ID = stringToFourCC(_____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["苍影灵卫"]["变异单位ID"])
local _____4E0A_4E0B_6587_5217_8868 = {}
local _____5355_4F4D_4E0A_4E0B_6587_8868 = {}
local function _____662F_8D64_8A93_5355_4F4D(unit)
    local id = unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) or 0
    return id == _____8D64_8A93_6B63_5E38ID or id == _____8D64_8A93_53D8_5F02ID
end
local function _____662F_82CD_5F71_5355_4F4D(unit)
    local id = unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) or 0
    return id == _____82CD_5F71_6B63_5E38ID or id == _____82CD_5F71_53D8_5F02ID
end
local function _____67E5_627E_9644_8FD1_642D_6863(unit, _____5BFB_627E_8D64_8A93)
    local group = CreateGroup()
    GroupEnumUnitsInRange(
        group,
        GetUnitX(unit),
        GetUnitY(unit),
        3600,
        nil
    )
    local result = nil
    while true do
        local candidate = FirstOfGroup(group)
        if candidate == nil or candidate == 0 then
            break
        end
        GroupRemoveUnit(group, candidate)
        local ____temp_3 = candidate ~= unit
        if ____temp_3 then
            local _____5BFB_627E_8D64_8A93_2
            if _____5BFB_627E_8D64_8A93 then
                _____5BFB_627E_8D64_8A93_2 = _____662F_8D64_8A93_5355_4F4D(candidate)
            else
                _____5BFB_627E_8D64_8A93_2 = _____662F_82CD_5F71_5355_4F4D(candidate)
            end
            ____temp_3 = _____5BFB_627E_8D64_8A93_2
        end
        if ____temp_3 then
            result = candidate
            break
        end
    end
    DestroyGroup(group)
    return result
end
local function _____521B_5EFA_8282_70B9_5217_8868(centerX, centerY)
    local radius = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["节点中心偏移半径"]
    local angles = {30, 150, 270}
    local result = {}
    local CosBJ = jass.CosBJ
    local SinBJ = jass.SinBJ
    do
        local i = 0
        while i < #angles do
            result[#result + 1] = {
                ["序号"] = i + 1,
                X = centerX + CosBJ(angles[i + 1]) * radius,
                Y = centerY + SinBJ(angles[i + 1]) * radius,
                ["阶段"] = "未激活",
                ["校准截止Ms"] = 0,
                ["重试允许Ms"] = 0
            }
            i = i + 1
        end
    end
    return result
end
____exports["创建祖地双灵卫运行时上下文"] = function(_____8D64_8A93_7075_536B_5355_4F4D, _____82CD_5F71_7075_536B_5355_4F4D, _____573A_5730_77E9_5F62)
    local _____6E05_7406 = _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50("祖地双灵卫")
    local rect = _____573A_5730_77E9_5F62
    local fallbackX = _____8D64_8A93_7075_536B_5355_4F4D ~= nil and _____82CD_5F71_7075_536B_5355_4F4D ~= nil and (GetUnitX(_____8D64_8A93_7075_536B_5355_4F4D) + GetUnitX(_____82CD_5F71_7075_536B_5355_4F4D)) * 0.5 or 0
    local fallbackY = _____8D64_8A93_7075_536B_5355_4F4D ~= nil and _____82CD_5F71_7075_536B_5355_4F4D ~= nil and (GetUnitY(_____8D64_8A93_7075_536B_5355_4F4D) + GetUnitY(_____82CD_5F71_7075_536B_5355_4F4D)) * 0.5 or 0
    local centerX = rect ~= nil and rect ~= 0 and GetRectCenterX(rect) or fallbackX
    local centerY = rect ~= nil and rect ~= 0 and GetRectCenterY(rect) or fallbackY
    local halfWidth = rect ~= nil and rect ~= 0 and (GetRectMaxX(rect) - GetRectMinX(rect)) * 0.5 or 1000
    local halfHeight = rect ~= nil and rect ~= 0 and (GetRectMaxY(rect) - GetRectMinY(rect)) * 0.5 or 850
    local context
    local _____8054_5408_751F_547D_5468_671F = _____521B_5EFA_8054_5408_6218_6597_6210_5458_751F_547D_5468_671F({
        ["名称"] = "祖地双灵卫联合生命周期",
        ["清理"] = _____6E05_7406,
        ["默认最终状态列表"] = {"崩解"},
        ["成员列表"] = {{
            key = "赤誓灵卫",
            ["单位"] = _____8D64_8A93_7075_536B_5355_4F4D,
            ["角色"] = "搭档",
            ["初始状态"] = "活跃",
            ["参与最终结算"] = true,
            ["最终状态列表"] = {"崩解"}
        }, {
            key = "苍影灵卫",
            ["单位"] = _____82CD_5F71_7075_536B_5355_4F4D,
            ["角色"] = "搭档",
            ["初始状态"] = "活跃",
            ["参与最终结算"] = true,
            ["最终状态列表"] = {"崩解"}
        }},
        ["on满足最终结算"] = function()
            if context ~= nil then
                context["最终结算待处理"] = true
            end
        end
    })
    context = {
        ["赤誓灵卫单位"] = _____8D64_8A93_7075_536B_5355_4F4D,
        ["苍影灵卫单位"] = _____82CD_5F71_7075_536B_5355_4F4D,
        ["阶段"] = _____8D64_8A93_7075_536B_5355_4F4D ~= nil and _____82CD_5F71_7075_536B_5355_4F4D ~= nil and "P1双灵守门" or "未启动",
        ["赤誓灵卫形态"] = "正常",
        ["苍影灵卫形态"] = "正常",
        ["当前净化节点序号"] = 0,
        ["已净化节点数量"] = 0,
        ["崩解截止时间Ms"] = 0,
        ["同誓保护已启用"] = false,
        ["P2开始时间Ms"] = 0,
        ["大型机制忙碌到Ms"] = getServerTime() + 1800,
        ["下次联合机制Ms"] = getServerTime() + 22000,
        ["下次赤誓普通技能Ms"] = getServerTime() + 3200,
        ["下次苍影普通技能Ms"] = getServerTime() + 4700,
        ["空白灵域列表"] = {},
        ["净化节点列表"] = _____521B_5EFA_8282_70B9_5217_8868(centerX, centerY),
        ["P3共鸣层数"] = 3,
        ["净化易伤到Ms"] = 0,
        ["最终结算待处理"] = false,
        ["封门误判待触发"] = false,
        ["净化节点清理已登记"] = false,
        ["侵蚀生命下限保护列表"] = {},
        ["同息生命下限保护列表"] = {},
        ["战斗已结束"] = false,
        ["场地矩形"] = rect,
        ["场地中心X"] = centerX,
        ["场地中心Y"] = centerY,
        ["场地半宽"] = halfWidth,
        ["场地半高"] = halfHeight,
        ["联合生命周期"] = _____8054_5408_751F_547D_5468_671F,
        ["清理"] = _____6E05_7406,
        ["已初始化"] = _____8D64_8A93_7075_536B_5355_4F4D ~= nil and _____82CD_5F71_7075_536B_5355_4F4D ~= nil
    }
    return context
end
____exports["获取祖地双灵卫运行时上下文"] = function(unit)
    return _____5355_4F4D_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(unit)]
end
____exports["获取全部祖地双灵卫运行时上下文"] = function()
    local result = {}
    do
        local i = 0
        while i < #_____4E0A_4E0B_6587_5217_8868 do
            if not _____4E0A_4E0B_6587_5217_8868[i + 1]["战斗已结束"] then
                result[#result + 1] = _____4E0A_4E0B_6587_5217_8868[i + 1]
            end
            i = i + 1
        end
    end
    return result
end
____exports["获取或创建祖地双灵卫运行时上下文"] = function(_____542F_52A8_5355_4F4D)
    local existing = ____exports["获取祖地双灵卫运行时上下文"](_____542F_52A8_5355_4F4D)
    if existing ~= nil then
        return existing
    end
    local _____662F_8D64_8A93_5355_4F4D_result_4
    if _____662F_8D64_8A93_5355_4F4D(_____542F_52A8_5355_4F4D) then
        _____662F_8D64_8A93_5355_4F4D_result_4 = _____542F_52A8_5355_4F4D
    else
        _____662F_8D64_8A93_5355_4F4D_result_4 = _____67E5_627E_9644_8FD1_642D_6863(_____542F_52A8_5355_4F4D, true)
    end
    local red = _____662F_8D64_8A93_5355_4F4D_result_4
    local _____662F_82CD_5F71_5355_4F4D_result_5
    if _____662F_82CD_5F71_5355_4F4D(_____542F_52A8_5355_4F4D) then
        _____662F_82CD_5F71_5355_4F4D_result_5 = _____542F_52A8_5355_4F4D
    else
        _____662F_82CD_5F71_5355_4F4D_result_5 = _____67E5_627E_9644_8FD1_642D_6863(_____542F_52A8_5355_4F4D, false)
    end
    local azure = _____662F_82CD_5F71_5355_4F4D_result_5
    if red == nil or red == 0 or azure == nil or azure == 0 then
        return nil
    end
    local ____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587_result_6 = _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(_____542F_52A8_5355_4F4D)
    if ____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587_result_6 == nil then
        ____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587_result_6 = _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(red)
    end
    local ____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587_result_6_7 = ____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587_result_6
    if ____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587_result_6_7 == nil then
        ____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587_result_6_7 = _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(azure)
    end
    local battle = ____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587_result_6_7
    local ____exports__521B_5EFA_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587_11 = ____exports["创建祖地双灵卫运行时上下文"]
    local ____opt_result_10
    if battle ~= nil then
        ____opt_result_10 = battle["地点矩形"]
    end
    local context = ____exports__521B_5EFA_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587_11(red, azure, ____opt_result_10)
    _____4E0A_4E0B_6587_5217_8868[#_____4E0A_4E0B_6587_5217_8868 + 1] = context
    _____5355_4F4D_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(red)] = context
    _____5355_4F4D_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(azure)] = context
    return context
end
____exports["清理祖地双灵卫运行时上下文"] = function(context)
    if context["战斗已结束"] then
        return
    end
    context["战斗已结束"] = true
    context["阶段"] = "已结束"
    _____5355_4F4D_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(context["赤誓灵卫单位"])] = nil
    _____5355_4F4D_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(context["苍影灵卫单位"])] = nil
    local ____self_12 = context["清理"]
    ____self_12["清理全部"](____self_12)
end
return ____exports
