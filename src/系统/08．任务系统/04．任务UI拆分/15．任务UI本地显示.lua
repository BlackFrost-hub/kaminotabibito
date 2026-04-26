local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
local ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236 = require("系统.08．任务系统.04．任务UI拆分.09．任务UI列表控制")
local setVisible = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.setVisible
--- 切换展开/收起：隐藏当前页所有 variant，只显示目标 variant。
-- 收起 → variant 0（默认折叠态）
-- 展开 → variant rowIndex + 1
function ____exports.toggleExpandLocal(self, pool, category, pageIndex, expandedQuestId, questId)
    if not pool then
        return
    end
    local cv = pool.categories[category]
    if not cv then
        return
    end
    local page = cv.pages[pageIndex + 1]
    if not page then
        return
    end
    local targetVariant = 0
    if expandedQuestId ~= questId then
        local rowIndex = __TS__ArrayIndexOf(page.questIds, questId)
        if rowIndex >= 0 then
            targetVariant = rowIndex + 1
        end
    end
    do
        local i = 0
        while i < #page.variants do
            setVisible(nil, page.variants[i + 1].root, i == targetVariant)
            i = i + 1
        end
    end
end
--- 滚轮翻页：隐藏旧页 root + 所有 variant → 显示新页 root + variant 0。
function ____exports.switchPageLocal(self, pool, category, prevPageIndex, nextPageIndex)
    if not pool then
        return
    end
    local cv = pool.categories[category]
    if not cv then
        return
    end
    local prev = cv.pages[prevPageIndex + 1]
    if prev ~= nil then
        setVisible(nil, prev.root, false)
        do
            local i = 0
            while i < #prev.variants do
                setVisible(nil, prev.variants[i + 1].root, false)
                i = i + 1
            end
        end
    end
    local next = cv.pages[nextPageIndex + 1]
    if next ~= nil then
        do
            local i = 0
            while i < #next.variants do
                setVisible(nil, next.variants[i + 1].root, i == 0)
                i = i + 1
            end
        end
        setVisible(nil, next.root, true)
    end
end
return ____exports
