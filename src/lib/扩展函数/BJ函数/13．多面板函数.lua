--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
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
function ____exports.CreateMultiboardBJ(self, cols, rows, title)
    ____exports.bj_lastCreatedMultiboard = jass.CreateMultiboard()
    if ____exports.bj_lastCreatedMultiboard == nil then
        return nil
    end
    jass.MultiboardSetRowCount(____exports.bj_lastCreatedMultiboard, rows)
    jass.MultiboardSetColumnCount(____exports.bj_lastCreatedMultiboard, cols)
    jass.MultiboardSetTitleText(____exports.bj_lastCreatedMultiboard, title)
    jass.MultiboardDisplay(____exports.bj_lastCreatedMultiboard, true)
    return ____exports.bj_lastCreatedMultiboard
end
--- 销毁多面板 - DestroyMultiboardBJ
function ____exports.DestroyMultiboardBJ(self, mb)
    if mb == nil then
        return
    end
    jass.DestroyMultiboard(mb)
end
--- 获取最后创建的多面板 - GetLastCreatedMultiboard
function ____exports.GetLastCreatedMultiboard(self)
    return ____exports.bj_lastCreatedMultiboard
end
--- 显示/隐藏多面板 - MultiboardDisplayBJ
function ____exports.MultiboardDisplayBJ(self, show, mb)
    if mb == nil then
        return
    end
    jass.MultiboardDisplay(mb, show)
end
--- 最小化/还原多面板 - MultiboardMinimizeBJ
function ____exports.MultiboardMinimizeBJ(self, minimize, mb)
    if mb == nil then
        return
    end
    jass.MultiboardMinimize(mb, minimize)
end
--- 设置多面板标题颜色 - MultiboardSetTitleTextColorBJ
function ____exports.MultiboardSetTitleTextColorBJ(self, mb, red, green, blue, transparency)
    if mb == nil then
        return
    end
    jass.MultiboardSetTitleTextColor(
        mb,
        PercentTo255(nil, red),
        PercentTo255(nil, green),
        PercentTo255(nil, blue),
        PercentTo255(nil, 100 - transparency)
    )
end
--- 允许/禁止多面板显示 - MultiboardAllowDisplayBJ
function ____exports.MultiboardAllowDisplayBJ(self, flag)
    jass.MultiboardSuppressDisplay(not flag)
end
--- 设置多面板项目样式 - MultiboardSetItemStyleBJ
function ____exports.MultiboardSetItemStyleBJ(self, mb, col, row, showValue, showIcon)
    if mb == nil then
        return
    end
    local numRows = jass.MultiboardGetRowCount(mb)
    local numCols = jass.MultiboardGetColumnCount(mb)
    do
        local curRow = 1
        while curRow <= numRows do
            do
                local __continue17
                repeat
                    if row ~= 0 and row ~= curRow then
                        __continue17 = true
                        break
                    end
                    do
                        local curCol = 1
                        while curCol <= numCols do
                            do
                                local __continue20
                                repeat
                                    if col ~= 0 and col ~= curCol then
                                        __continue20 = true
                                        break
                                    end
                                    local item = jass.MultiboardGetItem(mb, curRow - 1, curCol - 1)
                                    if item ~= nil then
                                        jass.MultiboardSetItemStyle(item, showValue, showIcon)
                                        jass.MultiboardReleaseItem(item)
                                    end
                                    __continue20 = true
                                until true
                                if not __continue20 then
                                    break
                                end
                            end
                            curCol = curCol + 1
                        end
                    end
                    __continue17 = true
                until true
                if not __continue17 then
                    break
                end
            end
            curRow = curRow + 1
        end
    end
end
--- 设置多面板项目值 - MultiboardSetItemValueBJ
function ____exports.MultiboardSetItemValueBJ(self, mb, col, row, val)
    if mb == nil then
        return
    end
    local numRows = jass.MultiboardGetRowCount(mb)
    local numCols = jass.MultiboardGetColumnCount(mb)
    do
        local curRow = 1
        while curRow <= numRows do
            do
                local __continue26
                repeat
                    if row ~= 0 and row ~= curRow then
                        __continue26 = true
                        break
                    end
                    do
                        local curCol = 1
                        while curCol <= numCols do
                            do
                                local __continue29
                                repeat
                                    if col ~= 0 and col ~= curCol then
                                        __continue29 = true
                                        break
                                    end
                                    local item = jass.MultiboardGetItem(mb, curRow - 1, curCol - 1)
                                    if item ~= nil then
                                        jass.MultiboardSetItemValue(item, val)
                                        jass.MultiboardReleaseItem(item)
                                    end
                                    __continue29 = true
                                until true
                                if not __continue29 then
                                    break
                                end
                            end
                            curCol = curCol + 1
                        end
                    end
                    __continue26 = true
                until true
                if not __continue26 then
                    break
                end
            end
            curRow = curRow + 1
        end
    end
end
--- 设置多面板项目颜色 - MultiboardSetItemColorBJ
function ____exports.MultiboardSetItemColorBJ(self, mb, col, row, red, green, blue, transparency)
    if mb == nil then
        return
    end
    local numRows = jass.MultiboardGetRowCount(mb)
    local numCols = jass.MultiboardGetColumnCount(mb)
    do
        local curRow = 1
        while curRow <= numRows do
            do
                local __continue35
                repeat
                    if row ~= 0 and row ~= curRow then
                        __continue35 = true
                        break
                    end
                    do
                        local curCol = 1
                        while curCol <= numCols do
                            do
                                local __continue38
                                repeat
                                    if col ~= 0 and col ~= curCol then
                                        __continue38 = true
                                        break
                                    end
                                    local item = jass.MultiboardGetItem(mb, curRow - 1, curCol - 1)
                                    if item ~= nil then
                                        jass.MultiboardSetItemValueColor(
                                            item,
                                            PercentTo255(nil, red),
                                            PercentTo255(nil, green),
                                            PercentTo255(nil, blue),
                                            PercentTo255(nil, 100 - transparency)
                                        )
                                        jass.MultiboardReleaseItem(item)
                                    end
                                    __continue38 = true
                                until true
                                if not __continue38 then
                                    break
                                end
                            end
                            curCol = curCol + 1
                        end
                    end
                    __continue35 = true
                until true
                if not __continue35 then
                    break
                end
            end
            curRow = curRow + 1
        end
    end
end
--- 设置多面板项目宽度 - MultiboardSetItemWidthBJ
function ____exports.MultiboardSetItemWidthBJ(self, mb, col, row, width)
    if mb == nil then
        return
    end
    local numRows = jass.MultiboardGetRowCount(mb)
    local numCols = jass.MultiboardGetColumnCount(mb)
    do
        local curRow = 1
        while curRow <= numRows do
            do
                local __continue44
                repeat
                    if row ~= 0 and row ~= curRow then
                        __continue44 = true
                        break
                    end
                    do
                        local curCol = 1
                        while curCol <= numCols do
                            do
                                local __continue47
                                repeat
                                    if col ~= 0 and col ~= curCol then
                                        __continue47 = true
                                        break
                                    end
                                    local item = jass.MultiboardGetItem(mb, curRow - 1, curCol - 1)
                                    if item ~= nil then
                                        jass.MultiboardSetItemWidth(item, width / 100)
                                        jass.MultiboardReleaseItem(item)
                                    end
                                    __continue47 = true
                                until true
                                if not __continue47 then
                                    break
                                end
                            end
                            curCol = curCol + 1
                        end
                    end
                    __continue44 = true
                until true
                if not __continue44 then
                    break
                end
            end
            curRow = curRow + 1
        end
    end
end
--- 设置多面板项目图标 - MultiboardSetItemIconBJ
function ____exports.MultiboardSetItemIconBJ(self, mb, col, row, iconFileName)
    if mb == nil then
        return
    end
    local numRows = jass.MultiboardGetRowCount(mb)
    local numCols = jass.MultiboardGetColumnCount(mb)
    do
        local curRow = 1
        while curRow <= numRows do
            do
                local __continue53
                repeat
                    if row ~= 0 and row ~= curRow then
                        __continue53 = true
                        break
                    end
                    do
                        local curCol = 1
                        while curCol <= numCols do
                            do
                                local __continue56
                                repeat
                                    if col ~= 0 and col ~= curCol then
                                        __continue56 = true
                                        break
                                    end
                                    local item = jass.MultiboardGetItem(mb, curRow - 1, curCol - 1)
                                    if item ~= nil then
                                        jass.MultiboardSetItemIcon(item, iconFileName)
                                        jass.MultiboardReleaseItem(item)
                                    end
                                    __continue56 = true
                                until true
                                if not __continue56 then
                                    break
                                end
                            end
                            curCol = curCol + 1
                        end
                    end
                    __continue53 = true
                until true
                if not __continue53 then
                    break
                end
            end
            curRow = curRow + 1
        end
    end
end
--- 获取最后创建的多面板项目 - GetLastCreatedMultiboardItem
function ____exports.GetLastCreatedMultiboardItem(self)
    return ____exports.bj_lastCreatedMultiboardItem
end
return ____exports
