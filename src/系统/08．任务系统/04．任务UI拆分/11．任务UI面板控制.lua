--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
function ____exports.registerTaskUIRefreshCallback(self, ctx, refreshList)
    ctx.questManager:registerUIRefreshCallback(function(____, _playerId, _questId)
        pcall(function ()
                local lp = jass.GetLocalPlayer()
                if lp == nil then
                    return
                end
                if not ctx:isVisible() then
                    return
                end
                refreshList(nil)
            end
        )
    end)
end
--- 标签 hover 提示直接发给当前 UI 事件玩家，不走同步逻辑。
function ____exports.showTaskUITabTooltip(self, msg)
    local p = japi.DzGetTriggerUIEventPlayer()
    if p then
        jass.DisplayTextToPlayer(p, 0, 0, msg)
    end
end
--- 切分类时顺手清空展开态并回到顶部，保证列表状态可预期。
function ____exports.switchTaskUICategory(self, ctx, ____type, refreshList)
    pcall(function ()
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            ctx:setCurrentCategory(____type)
            ctx.expandedQuestIds:clear()
            ctx:setScrollOffset(0)
            refreshList(nil)
        end
    )
end
--- 只负责切换显隐状态；具体 show/hide 的副作用交给调用方传入。
function ____exports.toggleTaskUIPanel(self, ctx, show, hide)
    pcall(function ()
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            local nextVisible = not ctx:isVisible()
            ctx:setVisible(nextVisible)
            if nextVisible then
                show(
                    nil,
                    ctx:getCurrentPlayerId()
                )
            else
                hide(nil)
            end
        end
    )
end
--- 显示面板时记录当前玩家并立刻刷新列表，确保内容和分类状态同步。
function ____exports.showTaskUIPanel(self, ctx, playerId, refreshList)
    pcall(function ()
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            if not ctx.mainPanel then
                return
            end
            ctx:setCurrentPlayerId(playerId)
            ctx:setVisible(true)
            ctx:showFrame(ctx.mainPanel)
            refreshList(nil)
        end
    )
end
--- 隐藏前先取消可能进行中的 thumb 拖拽，避免下次打开残留交互状态。
function ____exports.hideTaskUIPanel(self, ctx)
    pcall(function ()
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            if not ctx.mainPanel then
                return
            end
            local ____opt_0 = ctx.vScrollTrack
            if ____opt_0 ~= nil then
                ____opt_0:cancelDrag()
            end
            ctx:setVisible(false)
            ctx:hideFrame(ctx.mainPanel)
        end
    )
end
return ____exports
