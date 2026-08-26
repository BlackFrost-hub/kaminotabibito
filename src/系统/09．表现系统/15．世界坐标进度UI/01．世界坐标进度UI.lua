local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____5237_65B0_586B_5145, _____5237_65B0_6587_672C, _____4ECE_9A71_52A8_5217_8868_79FB_9664, _____5C1D_8BD5_505C_6B62_4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8, _____5237_65B0_4E16_754C_5750_6807_8FDB_5EA6UI_8DDF_968F, _____9A71_52A8_4E16_754C_5750_6807_8FDB_5EA6UI, offTick10ms, DzFrameSetSize, DzFrameSetText, DzFrameBindWorldPos, DzFrameUnBind, DzFrameShow, DzDestroyFrame, GetUnitX, GetUnitY, GetUnitFlyHeight, GetUnitTypeId, GetWidgetLife, _____9A71_52A8_95F4_9694_79D2, _____4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8_5DF2_542F_52A8, _____4E16_754C_5750_6807_8FDB_5EA6UI_5217_8868
local ____04_FF0E_6570_5B57_683C_5F0F_5316 = require("系统.09．表现系统.08．吟唱条.04．数字格式化")
local _____683C_5F0F_5316_4E00_4F4D_5C0F_6570 = ____04_FF0E_6570_5B57_683C_5F0F_5316["格式化一位小数"]
function _____5237_65B0_586B_5145(ui)
    local ratio = ui["最大值"] > 0 and ui["显示值"] / ui["最大值"] or 0
    DzFrameSetSize(ui["填充帧"], ui["内条宽度"] * ratio, ui["内条高度"])
    DzFrameShow(ui["填充帧"], ratio > 0)
end
function _____5237_65B0_6587_672C(ui)
    DzFrameSetText(
        ui["文本帧"],
        ((((((("|cffd8f4ee" .. ui["标题"]) .. "|r |cff") .. ui["数值颜色"]) .. _____683C_5F0F_5316_4E00_4F4D_5C0F_6570(ui["显示值"])) .. "|r|cff8fa7ad / ") .. _____683C_5F0F_5316_4E00_4F4D_5C0F_6570(ui["最大值"])) .. ui["数值后缀"]) .. "|r"
    )
end
function _____4ECE_9A71_52A8_5217_8868_79FB_9664(ui)
    do
        local i = #_____4E16_754C_5750_6807_8FDB_5EA6UI_5217_8868 - 1
        while i >= 0 do
            if _____4E16_754C_5750_6807_8FDB_5EA6UI_5217_8868[i + 1] == ui then
                __TS__ArraySplice(_____4E16_754C_5750_6807_8FDB_5EA6UI_5217_8868, i, 1)
                return
            end
            i = i - 1
        end
    end
end
function _____5C1D_8BD5_505C_6B62_4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8()
    if not _____4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8_5DF2_542F_52A8 or #_____4E16_754C_5750_6807_8FDB_5EA6UI_5217_8868 > 0 then
        return
    end
    _____4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8_5DF2_542F_52A8 = false
    offTick10ms(_____9A71_52A8_4E16_754C_5750_6807_8FDB_5EA6UI)
end
function _____5237_65B0_4E16_754C_5750_6807_8FDB_5EA6UI_8DDF_968F(ui)
    if ui["跟随单位"] == nil or ui["跟随单位"] == 0 then
        return true
    end
    if GetUnitTypeId(ui["跟随单位"]) == 0 or GetWidgetLife(ui["跟随单位"]) <= 0.405 then
        ____exports["销毁世界坐标进度UI"](ui)
        return false
    end
    DzFrameBindWorldPos(
        ui["根帧"],
        GetUnitX(ui["跟随单位"]) + ui["跟随X偏移"],
        GetUnitY(ui["跟随单位"]) + ui["跟随Y偏移"],
        GetUnitFlyHeight(ui["跟随单位"]) + ui["跟随Z偏移"],
        0,
        0,
        false
    )
    return true
end
function _____9A71_52A8_4E16_754C_5750_6807_8FDB_5EA6UI()
    do
        local i = #_____4E16_754C_5750_6807_8FDB_5EA6UI_5217_8868 - 1
        while i >= 0 do
            do
                local ui = _____4E16_754C_5750_6807_8FDB_5EA6UI_5217_8868[i + 1]
                if ui == nil or ui["已销毁"] then
                    __TS__ArraySplice(_____4E16_754C_5750_6807_8FDB_5EA6UI_5217_8868, i, 1)
                    goto __continue24
                end
                if not _____5237_65B0_4E16_754C_5750_6807_8FDB_5EA6UI_8DDF_968F(ui) then
                    goto __continue24
                end
                if ui["显示值"] ~= ui["目标值"] then
                    ui["动画已经过秒"] = ui["动画已经过秒"] + _____9A71_52A8_95F4_9694_79D2
                    local ratio = ui["动画已经过秒"] / ui["平滑过渡秒"]
                    if ratio >= 1 then
                        ratio = 1
                    end
                    ui["显示值"] = ui["动画起始值"] + (ui["目标值"] - ui["动画起始值"]) * ratio
                    if ratio >= 1 then
                        ui["显示值"] = ui["目标值"]
                    end
                    _____5237_65B0_586B_5145(ui)
                end
                ui["文本刷新Tick"] = ui["文本刷新Tick"] + 1
                if ui["文本刷新Tick"] >= 5 then
                    ui["文本刷新Tick"] = 0
                    _____5237_65B0_6587_672C(ui)
                end
            end
            ::__continue24::
            i = i - 1
        end
    end
    _____5C1D_8BD5_505C_6B62_4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8()
end
____exports["销毁世界坐标进度UI"] = function(ui)
    if ui == nil or ui["已销毁"] then
        return
    end
    ui["已销毁"] = true
    ui["已显示"] = false
    _____4ECE_9A71_52A8_5217_8868_79FB_9664(ui)
    DzFrameShow(ui["根帧"], false)
    DzFrameUnBind(ui["根帧"])
    DzDestroyFrame(ui["根帧"])
    _____5C1D_8BD5_505C_6B62_4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8()
end
local japi = require("jass.japi")
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
offTick10ms = ____require_result_0.offTick10ms
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzGetGameUI = japi.DzGetGameUI
local DzFrameGetLowerLevelFrame = japi.DzFrameGetLowerLevelFrame
DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetTexture = japi.DzFrameSetTexture
DzFrameSetText = japi.DzFrameSetText
local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
local DzFrameSetTextColor = japi.DzFrameSetTextColor
local DzFrameSetFont = japi.DzFrameSetFont
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameSetIgnoreTrackEvents = japi.DzFrameSetIgnoreTrackEvents
DzFrameBindWorldPos = japi.DzFrameBindWorldPos
DzFrameUnBind = japi.DzFrameUnBind
DzFrameShow = japi.DzFrameShow
DzDestroyFrame = japi.DzDestroyFrame
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFlyHeight = jass.GetUnitFlyHeight
GetUnitTypeId = jass.GetUnitTypeId
GetWidgetLife = jass.GetWidgetLife
local _____70B9_5DE6_4E0A = 0
local _____70B9_4E2D = 4
local _____9ED8_8BA4_5BBD_5EA6 = 0.082
local _____9ED8_8BA4_9AD8_5EA6 = 0.0205
local _____9ED8_8BA4_5185_6761_5DE6_504F_79FB = 0.005
local _____9ED8_8BA4_5185_6761_4E0A_504F_79FB = -0.0115
local _____9ED8_8BA4_5185_6761_5BBD_5EA6 = 0.072
local _____9ED8_8BA4_5185_6761_9AD8_5EA6 = 0.0062
local _____9ED8_8BA4_5C42_7EA7 = 6700
local _____9ED8_8BA4_5E73_6ED1_8FC7_6E21_79D2 = 0.2
_____9A71_52A8_95F4_9694_79D2 = 0.01
local _____9ED8_8BA4_5E95_6846_8D34_56FE = "UI\\WorldProgress\\world_progress_frame.tga"
local _____7C7B_578B_8868_73B0_8868 = {
    ["通用"] = {["贴图"] = "UI\\WorldProgress\\world_progress_fill.tga", ["颜色"] = "72cfff"},
    ["安魂"] = {["贴图"] = "UI\\WorldProgress\\world_progress_fill_soul.tga", ["颜色"] = "79e4d2"},
    ["危险"] = {["贴图"] = "UI\\WorldProgress\\world_progress_fill_danger.tga", ["颜色"] = "ff746d"},
    ["自然"] = {["贴图"] = "UI\\WorldProgress\\world_progress_fill_nature.tga", ["颜色"] = "8cdb86"},
    ["奥术"] = {["贴图"] = "UI\\WorldProgress\\world_progress_fill_arcane.tga", ["颜色"] = "9ab7ff"}
}
local _____4E16_754C_5750_6807_8FDB_5EA6UI_7236_5E27 = 0
local _____4E0B_4E00_4E2A_4E16_754C_5750_6807_8FDB_5EA6UIID = 1
_____4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8_5DF2_542F_52A8 = false
_____4E16_754C_5750_6807_8FDB_5EA6UI_5217_8868 = {}
local function _____53D6_4E16_754C_5750_6807_8FDB_5EA6UI_7236_5E27()
    if _____4E16_754C_5750_6807_8FDB_5EA6UI_7236_5E27 ~= 0 then
        return _____4E16_754C_5750_6807_8FDB_5EA6UI_7236_5E27
    end
    local lower = DzFrameGetLowerLevelFrame()
    local parent = lower ~= nil and lower ~= 0 and lower or DzGetGameUI()
    _____4E16_754C_5750_6807_8FDB_5EA6UI_7236_5E27 = DzCreateFrameByTagName(
        "FRAME",
        "WorldProgressUILayer",
        parent,
        "template",
        0
    )
    return _____4E16_754C_5750_6807_8FDB_5EA6UI_7236_5E27 ~= 0 and _____4E16_754C_5750_6807_8FDB_5EA6UI_7236_5E27 or parent
end
local function _____521B_5EFA_8D34_56FE_5E27(typeName, parent, texture, priority)
    local frame = DzCreateFrameByTagName(
        "BACKDROP",
        typeName,
        parent,
        "template",
        0
    )
    if frame == nil or frame == 0 then
        return 0
    end
    DzFrameSetTexture(frame, texture, 0)
    DzFrameSetPriority(frame, priority)
    DzFrameSetIgnoreTrackEvents(frame, true)
    return frame
end
local function _____9650_5236_8FDB_5EA6_503C(value, maximum)
    if not (value > 0) then
        return 0
    end
    if value > maximum then
        return maximum
    end
    return value
end
local function _____786E_4FDD_4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8()
    if _____4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8_5DF2_542F_52A8 then
        return
    end
    _____4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8_5DF2_542F_52A8 = true
    onTick10ms(_____9A71_52A8_4E16_754C_5750_6807_8FDB_5EA6UI)
end
____exports["创建世界坐标进度UI"] = function(_____53C2_6570)
    if not (_____53C2_6570["最大值"] > 0) then
        return nil
    end
    local id = _____4E0B_4E00_4E2A_4E16_754C_5750_6807_8FDB_5EA6UIID
    _____4E0B_4E00_4E2A_4E16_754C_5750_6807_8FDB_5EA6UIID = _____4E0B_4E00_4E2A_4E16_754C_5750_6807_8FDB_5EA6UIID + 1
    local suffix = tostring(id)
    local parent = _____53D6_4E16_754C_5750_6807_8FDB_5EA6UI_7236_5E27()
    local ____type = _____53C2_6570["类型"] or "通用"
    local typeVisual = _____7C7B_578B_8868_73B0_8868[____type]
    local root = _____521B_5EFA_8D34_56FE_5E27("WorldProgressUIRoot_" .. suffix, parent, _____53C2_6570["底框贴图"] or _____9ED8_8BA4_5E95_6846_8D34_56FE, _____9ED8_8BA4_5C42_7EA7)
    if root == 0 then
        return nil
    end
    local fill = _____521B_5EFA_8D34_56FE_5E27("WorldProgressUIFill_" .. suffix, root, _____53C2_6570["填充贴图"] or typeVisual["贴图"], _____9ED8_8BA4_5C42_7EA7 + 1)
    local text = DzCreateFrameByTagName(
        "TEXT",
        "WorldProgressUIText_" .. suffix,
        root,
        "template",
        0
    )
    if fill == 0 or text == nil or text == 0 then
        DzDestroyFrame(root)
        return nil
    end
    local width = _____53C2_6570["宽度"] or _____9ED8_8BA4_5BBD_5EA6
    local height = _____53C2_6570["高度"] or _____9ED8_8BA4_9AD8_5EA6
    local innerWidth = width * (_____9ED8_8BA4_5185_6761_5BBD_5EA6 / _____9ED8_8BA4_5BBD_5EA6)
    local innerHeight = height * (_____9ED8_8BA4_5185_6761_9AD8_5EA6 / _____9ED8_8BA4_9AD8_5EA6)
    DzFrameSetSize(root, width, height)
    DzFrameSetSize(fill, 0, innerHeight)
    DzFrameSetPoint(
        fill,
        _____70B9_5DE6_4E0A,
        root,
        _____70B9_5DE6_4E0A,
        width * (_____9ED8_8BA4_5185_6761_5DE6_504F_79FB / _____9ED8_8BA4_5BBD_5EA6),
        height * (_____9ED8_8BA4_5185_6761_4E0A_504F_79FB / _____9ED8_8BA4_9AD8_5EA6)
    )
    DzFrameSetSize(text, width * 1.08, height * 0.58)
    DzFrameSetPoint(
        text,
        _____70B9_4E2D,
        root,
        _____70B9_4E2D,
        0,
        height * 0.13
    )
    DzFrameSetTextAlignment(text, -1)
    DzFrameSetTextAlignment(text, 18)
    DzFrameSetTextColor(
        text,
        216,
        244,
        238,
        255
    )
    DzFrameSetFont(text, "UI\\unit_name_zcool_qingke.ttf", 0.0095, 0)
    DzFrameSetPriority(text, _____9ED8_8BA4_5C42_7EA7 + 2)
    DzFrameSetIgnoreTrackEvents(text, true)
    local ____53C2_6570__521D_59CB_663E_793A_1 = _____53C2_6570["初始显示"]
    if ____53C2_6570__521D_59CB_663E_793A_1 == nil then
        ____53C2_6570__521D_59CB_663E_793A_1 = false
    end
    local visible = ____53C2_6570__521D_59CB_663E_793A_1
    local current = _____9650_5236_8FDB_5EA6_503C(_____53C2_6570["当前值"] or 0, _____53C2_6570["最大值"])
    local smoothDuration = _____53C2_6570["平滑过渡秒"] ~= nil and _____53C2_6570["平滑过渡秒"] > 0 and _____53C2_6570["平滑过渡秒"] or _____9ED8_8BA4_5E73_6ED1_8FC7_6E21_79D2
    local ____53C2_6570__6700_5927_503C_3 = _____53C2_6570["最大值"]
    local ____temp_4 = _____53C2_6570["标题"] or "进度"
    local ____temp_5 = _____53C2_6570["数值后缀"] or ""
    local ____typeVisual__989C_8272_6 = typeVisual["颜色"]
    local ____53C2_6570__8DDF_968F_5355_4F4D_2 = _____53C2_6570["跟随单位"]
    if ____53C2_6570__8DDF_968F_5355_4F4D_2 == nil then
        ____53C2_6570__8DDF_968F_5355_4F4D_2 = nil
    end
    local ui = {
        ID = id,
        ["根帧"] = root,
        ["填充帧"] = fill,
        ["文本帧"] = text,
        ["最大值"] = ____53C2_6570__6700_5927_503C_3,
        ["目标值"] = current,
        ["显示值"] = current,
        ["动画起始值"] = current,
        ["动画已经过秒"] = smoothDuration,
        ["平滑过渡秒"] = smoothDuration,
        ["标题"] = ____temp_4,
        ["数值后缀"] = ____temp_5,
        ["类型"] = ____type,
        ["数值颜色"] = ____typeVisual__989C_8272_6,
        ["内条宽度"] = innerWidth,
        ["内条高度"] = innerHeight,
        ["文本刷新Tick"] = 0,
        ["已显示"] = visible,
        ["已销毁"] = false,
        ["跟随单位"] = ____53C2_6570__8DDF_968F_5355_4F4D_2,
        ["跟随X偏移"] = _____53C2_6570["跟随X偏移"] or 0,
        ["跟随Y偏移"] = _____53C2_6570["跟随Y偏移"] or 0,
        ["跟随Z偏移"] = _____53C2_6570["跟随Z偏移"] or 0
    }
    local z = _____53C2_6570.Z or 180
    local ____53C2_6570__96FE_4E2D_53EF_89C1_7 = _____53C2_6570["雾中可见"]
    if ____53C2_6570__96FE_4E2D_53EF_89C1_7 == nil then
        ____53C2_6570__96FE_4E2D_53EF_89C1_7 = false
    end
    local fogVisible = ____53C2_6570__96FE_4E2D_53EF_89C1_7
    DzFrameBindWorldPos(
        root,
        _____53C2_6570.X,
        _____53C2_6570.Y,
        z,
        _____53C2_6570["屏幕X偏移"] or 0,
        _____53C2_6570["屏幕Y偏移"] or 0,
        fogVisible
    )
    _____5237_65B0_586B_5145(ui)
    _____5237_65B0_6587_672C(ui)
    DzFrameShow(root, visible)
    _____4E16_754C_5750_6807_8FDB_5EA6UI_5217_8868[#_____4E16_754C_5750_6807_8FDB_5EA6UI_5217_8868 + 1] = ui
    _____786E_4FDD_4E16_754C_5750_6807_8FDB_5EA6UI_9A71_52A8()
    return ui
end
____exports["更新世界坐标进度UI"] = function(ui, _____5F53_524D_503C, _____7ACB_5373_66F4_65B0)
    if _____7ACB_5373_66F4_65B0 == nil then
        _____7ACB_5373_66F4_65B0 = false
    end
    if ui == nil or ui["已销毁"] then
        return
    end
    local target = _____9650_5236_8FDB_5EA6_503C(_____5F53_524D_503C, ui["最大值"])
    ui["目标值"] = target
    if _____7ACB_5373_66F4_65B0 then
        ui["显示值"] = target
        ui["动画起始值"] = target
        ui["动画已经过秒"] = ui["平滑过渡秒"]
        _____5237_65B0_586B_5145(ui)
        _____5237_65B0_6587_672C(ui)
        return
    end
    ui["动画起始值"] = ui["显示值"]
    ui["动画已经过秒"] = 0
end
____exports["设置世界坐标进度UI类型"] = function(ui, ____type)
    if ui == nil or ui["已销毁"] or ui["类型"] == ____type then
        return
    end
    local visual = _____7C7B_578B_8868_73B0_8868[____type]
    ui["类型"] = ____type
    ui["数值颜色"] = visual["颜色"]
    DzFrameSetTexture(ui["填充帧"], visual["贴图"], 0)
    _____5237_65B0_6587_672C(ui)
end
____exports["设置世界坐标进度UI显示"] = function(ui, visible)
    if ui == nil or ui["已销毁"] or ui["已显示"] == visible then
        return
    end
    ui["已显示"] = visible
    DzFrameShow(ui["根帧"], visible)
end
return ____exports
