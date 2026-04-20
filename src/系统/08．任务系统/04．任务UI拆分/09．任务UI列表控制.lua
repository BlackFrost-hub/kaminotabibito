local ____lualib = require("lualib_bundle")
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
local ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8 = require("系统.08．任务系统.04．任务UI拆分.03．任务UI列表与滚动")
local refreshTaskUIList = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.refreshTaskUIList
local ____04_FF0E_4EFB_52A1UI_6E32_67D3 = require("系统.08．任务系统.04．任务UI拆分.04．任务UI渲染")
local renderQuestRow = ____04_FF0E_4EFB_52A1UI_6E32_67D3.renderQuestRow
local ____index = require("lib.扩展函数.封装函数.02．音效系统.index")
local SoundUI_ClickPlay = ____index.SoundUI_ClickPlay
local jass = require("jass.common")
local japi = require("jass.japi")
function ____exports.clearTaskUIList(self, ctx)
    for ____, f in ipairs(ctx.listItemFrames) do
        if type(japi.DzFrameShow) == "function" then
            japi.DzFrameShow(f, false)
        end
    end
    if type(japi.DzFrameShow) == "function" then
        for ____, f in __TS__Iterator(ctx.rowBackdropByQuestId:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
        for ____, f in __TS__Iterator(ctx.titleByQuestId:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
        for ____, f in __TS__Iterator(ctx.clickBtnByQuestId:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
        for ____, f in __TS__Iterator(ctx.objFrameByKey:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
        for ____, f in __TS__Iterator(ctx.failFrameByQuestId:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
        for ____, f in __TS__Iterator(ctx.rowIconByQuestId:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
    end
    __TS__ArraySetLength(ctx.listItemFrames, 0)
end
--- 只切换展开状态；真正的重排与滚动同步仍交给 `refreshList`。
function ____exports.toggleTaskUIQuestExpand(self, ctx, questId, refreshList)
    pcall(function ()
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            if ctx.expandedQuestIds:has(questId) then
                ctx.expandedQuestIds:delete(questId)
            else
                ctx.expandedQuestIds:add(questId)
            end
            refreshList(nil)
        end
    )
end
--- 渲染单行任务，行内点击/展开回调统一回到门面层的 `refreshList`。
function ____exports.createTaskUIListItem(self, ctx, quest, rowTopRel, expanded, refreshList)
    local listParent = ctx.listContainer
    if not ctx.mainPanel or not listParent then
        return nil
    end
    local ok = renderQuestRow(
        nil,
        {
            japi = japi,
            quest = quest,
            rowTopRel = rowTopRel,
            expanded = expanded,
            listParent = listParent,
            FrameType = ctx.FrameType,
            FramePoint = ctx.FramePoint,
            createFrame = ctx.createFrame,
            createTextLabel = ctx.createTextLabel,
            setFrameTexture = ctx.setFrameTexture,
            setFramePointRelative = ctx.setFramePointRelative,
            setFrameSize = ctx.setFrameSize,
            setFrameClickEvent = ctx.setFrameClickEvent,
            showFrame = ctx.showFrame,
            applyDzTextFontAndAlignment = ctx.applyDzTextFontAndAlignment,
            onToggleExpand = function(____, questId) return ____exports.toggleTaskUIQuestExpand(nil, ctx, questId, refreshList) end,
            onClickSound = function() return SoundUI_ClickPlay(nil) end,
            rowBackdropByQuestId = ctx.rowBackdropByQuestId,
            titleByQuestId = ctx.titleByQuestId,
            clickBtnByQuestId = ctx.clickBtnByQuestId,
            objFrameByKey = ctx.objFrameByKey,
            failFrameByQuestId = ctx.failFrameByQuestId,
            rowIconByQuestId = ctx.rowIconByQuestId,
            listItemFrames = ctx.listItemFrames
        }
    )
    if not ok then
        return nil
    end
    return 0
end
--- 门面层的列表刷新入口：先清旧帧，再把数据和回调委托给列表模块。
function ____exports.refreshTaskUIFacadeList(self, ctx, refreshList)
    pcall(function ()
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            if not ctx.mainPanel or not ctx.listContainer then
                return
            end
            ____exports.clearTaskUIList(nil, ctx)
            refreshTaskUIList(
                nil,
                {
                    currentPlayerId = ctx.currentPlayerId,
                    currentCategory = ctx.currentCategory,
                    scrollOffset = ctx:getScrollOffset(),
                    setScrollOffset = function(____, v)
                        ctx:setScrollOffset(v)
                    end,
                    setTotalContentHeight = function(____, v)
                        ctx:setTotalContentHeight(v)
                    end,
                    listContainer = ctx.listContainer,
                    expandedQuestIds = ctx.expandedQuestIds,
                    createTextLabel = ctx.createTextLabel,
                    FramePoint = ctx.FramePoint,
                    applyDzTextFontAndCenterAlignment = ctx.applyDzTextFontAndCenterAlignment,
                    pushListItemFrame = function(____, f)
                        local ____ctx_listItemFrames_0 = ctx.listItemFrames
                        local ____temp_1 = #____ctx_listItemFrames_0 + 1
                        ____ctx_listItemFrames_0[____temp_1] = f
                        return ____temp_1
                    end,
                    syncScrollThumb = function(____, maxScroll) return ctx:syncScrollThumb(maxScroll) end,
                    updateScrollBarVisibility = function(____, maxScroll, hasQuestRows) return ctx:updateScrollBarVisibility(maxScroll, hasQuestRows) end,
                    createListItem = function(____, quest, rowTopRel, expanded) return ____exports.createTaskUIListItem(
                        nil,
                        ctx,
                        quest,
                        rowTopRel,
                        expanded,
                        refreshList
                    ) end
                }
            )
        end
    )
end
return ____exports
