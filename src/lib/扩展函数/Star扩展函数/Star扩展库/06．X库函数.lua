local ____lualib = require("lualib_bundle")
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
--- Star扩展库 - X库函数
-- 
-- 来源于 X.j，提供地形检测、坐标工具、单位移动控制等功能。
-- 
-- 公开接口：
--   X_IsTerrainWalkable(x, y)     - 检测坐标是否可通行
--   X_GetAbleX()                  - 获取最近可通行X坐标（需先调用IsTerrainWalkable）
--   X_GetAbleY()                  - 获取最近可通行Y坐标（需先调用IsTerrainWalkable）
--   X_IsTerrainDeepWater(x, y)    - 深水检测
--   X_IsTerrainShallowWater(x, y) - 浅水检测
--   X_IsTerrainLand(x, y)         - 陆地检测
--   X_IsTerrainPlatform(x, y)     - 平台检测
--   X_SetUnitMovable(u, b)        - 设置单位是否可移动
--   X_GDBC(x1, y1, x2, y2)       - 坐标间距离
--   X_GAFC(x1, y1, x2, y2)       - 坐标间角度
--   X_R2I2(r)                     - 实数转整数（四舍五入）
local jass = require("jass.common")
local MAX_RANGE = 10
local DUMMY_ITEM_ID = (function(self)
    local b1 = string:byte("wolg", 1)
    local b2 = string:byte("wolg", 2)
    local b3 = string:byte("wolg", 3)
    local b4 = string:byte("wolg", 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end)(nil)
local PATHING_TYPE_WALKABILITY = jass:ConvertPathingType(0)
local PATHING_TYPE_FLOATABILITY = jass:ConvertPathingType(1)
local PATHING_TYPE_BUILDABILITY = jass:ConvertPathingType(2)
local dummyItem = nil
local searchRect = nil
local lastAbleX = 0
local lastAbleY = 0
local hiddenItems = {}
local function initXLib(self)
    if dummyItem ~= nil then
        return
    end
    searchRect = jass:Rect(0, 0, 128, 128)
    if DUMMY_ITEM_ID ~= 0 then
        dummyItem = jass:CreateItem(DUMMY_ITEM_ID, 0, 0)
        if dummyItem then
            jass:SetItemVisible(dummyItem, false)
        end
    end
end
--- 隐藏区域内的可见物品，防止物品间碰撞导致检测bug
local function hideItemsInRect(self)
    if not searchRect then
        return
    end
    __TS__ArraySetLength(hiddenItems, 0)
    jass:EnumItemsInRect(
        searchRect,
        nil,
        function()
            local it = jass:GetEnumItem()
            if it and jass:IsItemVisible(it) then
                hiddenItems[#hiddenItems + 1] = it
                jass:SetItemVisible(it, false)
            end
        end
    )
end
--- 恢复之前隐藏的物品
local function restoreHiddenItems(self)
    do
        local i = #hiddenItems - 1
        while i >= 0 do
            local it = hiddenItems[i + 1]
            if it then
                jass:SetItemVisible(it, true)
            end
            hiddenItems[i + 1] = nil
            i = i - 1
        end
    end
    __TS__ArraySetLength(hiddenItems, 0)
end
--- 检测坐标是否可通行（物品法 + IsTerrainPathable双重检测）
-- 调用后可通过 X_GetAbleX/Y 获取最近可通行坐标
-- 
-- @param x X坐标
-- @param y Y坐标
-- @returns 是否可通行
function ____exports.X_IsTerrainWalkable(self, x, y)
    initXLib(nil)
    if not dummyItem or not searchRect then
        return not jass:IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
    end
    jass:MoveRectTo(searchRect, x, y)
    hideItemsInRect(nil)
    jass:SetItemPosition(dummyItem, x, y)
    local itemX = jass:GetItemX(dummyItem)
    local itemY = jass:GetItemY(dummyItem)
    lastAbleX = itemX
    lastAbleY = itemY
    jass:SetItemVisible(dummyItem, false)
    restoreHiddenItems(nil)
    local dx = itemX - x
    local dy = itemY - y
    local distOk = dx * dx + dy * dy <= MAX_RANGE * MAX_RANGE
    return distOk and not jass:IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
end
--- 获取最近可通行X坐标（需先调用X_IsTerrainWalkable）
function ____exports.X_GetAbleX(self)
    return lastAbleX
end
--- 获取最近可通行Y坐标（需先调用X_IsTerrainWalkable）
function ____exports.X_GetAbleY(self)
    return lastAbleY
end
--- 深水检测
function ____exports.X_IsTerrainDeepWater(self, x, y)
    return not jass:IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and jass:IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
end
--- 浅水检测
function ____exports.X_IsTerrainShallowWater(self, x, y)
    return not jass:IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not jass:IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) and jass:IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
end
--- 陆地检测
function ____exports.X_IsTerrainLand(self, x, y)
    return jass:IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
end
--- 平台检测
function ____exports.X_IsTerrainPlatform(self, x, y)
    return not jass:IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not jass:IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) and not jass:IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
end
--- 设置单位是否可以移动
-- 通过设置转向窗口(PropWindow)实现：0=不可移动，默认值=可移动
-- 
-- @param u 目标单位
-- @param b 是否可移动
function ____exports.X_SetUnitMovable(self, u, b)
    if not u then
        return
    end
    if b then
        local defaultWindow = jass:GetUnitDefaultPropWindow(u)
        jass:SetUnitPropWindow(u, defaultWindow)
    else
        jass:SetUnitPropWindow(u, 0)
    end
end
--- 坐标间距离
function ____exports.X_GDBC(self, x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end
--- 坐标间角度（度数）
function ____exports.X_GAFC(self, x1, y1, x2, y2)
    return jass:Atan2(y2 - y1, x2 - x1) * (180 / math.pi)
end
--- 实数转整数（四舍五入）
function ____exports.X_R2I2(self, r)
    return math.floor(r + 0.5)
end
return ____exports
