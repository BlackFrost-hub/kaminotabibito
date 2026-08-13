--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
local PercentTo255 = ____require_result_0.PercentTo255
local ____jglobals_bj_lastCreatedMultiboard_1 = jglobals.bj_lastCreatedMultiboard
if ____jglobals_bj_lastCreatedMultiboard_1 == nil then
    ____jglobals_bj_lastCreatedMultiboard_1 = nil
end
____exports.bj_lastCreatedMultiboard = ____jglobals_bj_lastCreatedMultiboard_1
local ____jglobals_bj_lastCreatedMultiboardItem_2 = jglobals.bj_lastCreatedMultiboardItem
if ____jglobals_bj_lastCreatedMultiboardItem_2 == nil then
    ____jglobals_bj_lastCreatedMultiboardItem_2 = nil
end
____exports.bj_lastCreatedMultiboardItem = ____jglobals_bj_lastCreatedMultiboardItem_2
--- 创建多面板 - CreateMultiboardBJ
function ____exports.CreateMultiboardBJ(cols, rows, title)
    ____exports.bj_lastCreatedMultiboard = jass:CreateMultiboard()
    if ____exports.bj_lastCreatedMultiboard == nil then
        return nil
    end
    jass:MultiboardSetRowCount(____exports.bj_lastCreatedMultiboard, rows)
    jass:MultiboardSetColumnCount(____exports.bj_lastCreatedMultiboard, cols)
    jass:MultiboardSetTitleText(____exports.bj_lastCreatedMultiboard, title)
    jass:MultiboardDisplay(____exports.bj_lastCreatedMultiboard, true)
    return ____exports.bj_lastCreatedMultiboard
end
--- 销毁多面板 - DestroyMultiboardBJ
function ____exports.DestroyMultiboardBJ(mb)
    if mb == nil then
        return
    end
    jass:DestroyMultiboard(mb)
end
--- 获取最后创建的多面板 - GetLastCreatedMultiboard
function ____exports.GetLastCreatedMultiboard()
    return ____exports.bj_lastCreatedMultiboard
end
--- 显示/隐藏多面板 - MultiboardDisplayBJ
function ____exports.MultiboardDisplayBJ(show, mb)
    if mb == nil then
        return
    end
    jass:MultiboardDisplay(mb, show)
end
--- 最小化/还原多面板 - MultiboardMinimizeBJ
function ____exports.MultiboardMinimizeBJ(minimize, mb)
    if mb == nil then
        return
    end
    jass:MultiboardMinimize(mb, minimize)
end
--- 设置多面板标题颜色 - MultiboardSetTitleTextColorBJ
function ____exports.MultiboardSetTitleTextColorBJ(mb, red, green, blue, transparency)
    if mb == nil then
        return
    end
    jass:MultiboardSetTitleTextColor(
        mb,
        PercentTo255(red),
        PercentTo255(green),
        PercentTo255(blue),
        PercentTo255(100 - transparency)
    )
end
--- 允许/禁止多面板显示 - MultiboardAllowDisplayBJ
function ____exports.MultiboardAllowDisplayBJ(flag)
    jass:MultiboardSuppressDisplay(not flag)
end
--- 设置多面板项目样式 - MultiboardSetItemStyleBJ
function ____exports.MultiboardSetItemStyleBJ(mb, col, row, showValue, showIcon)
    if mb == nil then
        return
    end
    local numRows = jass:MultiboardGetRowCount(mb)
    local numCols = jass:MultiboardGetColumnCount(mb)
    do
        local curRow = 1
        while curRow <= numRows do
            do
                if row ~= 0 and row ~= curRow then
                    goto __continue17
                end
                do
                    local curCol = 1
                    while curCol <= numCols do
                        do
                            if col ~= 0 and col ~= curCol then
                                goto __continue20
                            end
                            local item = jass:MultiboardGetItem(mb, curRow - 1, curCol - 1)
                            if item ~= nil then
                                jass:MultiboardSetItemStyle(item, showValue, showIcon)
                                jass:MultiboardReleaseItem(item)
                            end
                        end
                        ::__continue20::
                        curCol = curCol + 1
                    end
                end
            end
            ::__continue17::
            curRow = curRow + 1
        end
    end
end
--- 设置多面板项目值 - MultiboardSetItemValueBJ
function ____exports.MultiboardSetItemValueBJ(mb, col, row, val)
    if mb == nil then
        return
    end
    local numRows = jass:MultiboardGetRowCount(mb)
    local numCols = jass:MultiboardGetColumnCount(mb)
    do
        local curRow = 1
        while curRow <= numRows do
            do
                if row ~= 0 and row ~= curRow then
                    goto __continue26
                end
                do
                    local curCol = 1
                    while curCol <= numCols do
                        do
                            if col ~= 0 and col ~= curCol then
                                goto __continue29
                            end
                            local item = jass:MultiboardGetItem(mb, curRow - 1, curCol - 1)
                            if item ~= nil then
                                jass:MultiboardSetItemValue(item, val)
                                jass:MultiboardReleaseItem(item)
                            end
                        end
                        ::__continue29::
                        curCol = curCol + 1
                    end
                end
            end
            ::__continue26::
            curRow = curRow + 1
        end
    end
end
--- 设置多面板项目颜色 - MultiboardSetItemColorBJ
function ____exports.MultiboardSetItemColorBJ(mb, col, row, red, green, blue, transparency)
    if mb == nil then
        return
    end
    local numRows = jass:MultiboardGetRowCount(mb)
    local numCols = jass:MultiboardGetColumnCount(mb)
    do
        local curRow = 1
        while curRow <= numRows do
            do
                if row ~= 0 and row ~= curRow then
                    goto __continue35
                end
                do
                    local curCol = 1
                    while curCol <= numCols do
                        do
                            if col ~= 0 and col ~= curCol then
                                goto __continue38
                            end
                            local item = jass:MultiboardGetItem(mb, curRow - 1, curCol - 1)
                            if item ~= nil then
                                jass:MultiboardSetItemValueColor(
                                    item,
                                    PercentTo255(red),
                                    PercentTo255(green),
                                    PercentTo255(blue),
                                    PercentTo255(100 - transparency)
                                )
                                jass:MultiboardReleaseItem(item)
                            end
                        end
                        ::__continue38::
                        curCol = curCol + 1
                    end
                end
            end
            ::__continue35::
            curRow = curRow + 1
        end
    end
end
--- 设置多面板项目宽度 - MultiboardSetItemWidthBJ
function ____exports.MultiboardSetItemWidthBJ(mb, col, row, width)
    if mb == nil then
        return
    end
    local numRows = jass:MultiboardGetRowCount(mb)
    local numCols = jass:MultiboardGetColumnCount(mb)
    do
        local curRow = 1
        while curRow <= numRows do
            do
                if row ~= 0 and row ~= curRow then
                    goto __continue44
                end
                do
                    local curCol = 1
                    while curCol <= numCols do
                        do
                            if col ~= 0 and col ~= curCol then
                                goto __continue47
                            end
                            local item = jass:MultiboardGetItem(mb, curRow - 1, curCol - 1)
                            if item ~= nil then
                                jass:MultiboardSetItemWidth(item, width / 100)
                                jass:MultiboardReleaseItem(item)
                            end
                        end
                        ::__continue47::
                        curCol = curCol + 1
                    end
                end
            end
            ::__continue44::
            curRow = curRow + 1
        end
    end
end
--- 设置多面板项目图标 - MultiboardSetItemIconBJ
function ____exports.MultiboardSetItemIconBJ(mb, col, row, iconFileName)
    if mb == nil then
        return
    end
    local numRows = jass:MultiboardGetRowCount(mb)
    local numCols = jass:MultiboardGetColumnCount(mb)
    do
        local curRow = 1
        while curRow <= numRows do
            do
                if row ~= 0 and row ~= curRow then
                    goto __continue53
                end
                do
                    local curCol = 1
                    while curCol <= numCols do
                        do
                            if col ~= 0 and col ~= curCol then
                                goto __continue56
                            end
                            local item = jass:MultiboardGetItem(mb, curRow - 1, curCol - 1)
                            if item ~= nil then
                                jass:MultiboardSetItemIcon(item, iconFileName)
                                jass:MultiboardReleaseItem(item)
                            end
                        end
                        ::__continue56::
                        curCol = curCol + 1
                    end
                end
            end
            ::__continue53::
            curRow = curRow + 1
        end
    end
end
--- 获取最后创建的多面板项目 - GetLastCreatedMultiboardItem
function ____exports.GetLastCreatedMultiboardItem()
    return ____exports.bj_lastCreatedMultiboardItem
end
return ____exports
