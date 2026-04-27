--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.09．表现系统.01．UI工具.index")
local createFrame = ____index.createFrame
local setButtonText = ____index.setButtonText
local FrameType = ____index.FrameType
local ____00_FF0E_5BF9_8BDD_6846UI_5165_53E3 = require("系统.09．表现系统.02．对话框系统.00．对话框UI入口")
local displayText = ____00_FF0E_5BF9_8BDD_6846UI_5165_53E3.displayText
local displayQuest = ____00_FF0E_5BF9_8BDD_6846UI_5165_53E3.displayQuest
local isDialogActive = ____00_FF0E_5BF9_8BDD_6846UI_5165_53E3.isDialogActive
local setDialogFinishCallback = ____00_FF0E_5BF9_8BDD_6846UI_5165_53E3.setDialogFinishCallback
local ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548 = require("系统.09．表现系统.02．对话框系统.15．NPC头顶与气泡特效")
local destroyBubbleEffect = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.destroyBubbleEffect
local releaseNpcOccupation = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.releaseNpcOccupation
local removeQuestMarkerAfterNpcTriggered = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.removeQuestMarkerAfterNpcTriggered
local scheduleBubbleEffectAfterOverheadClear = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.scheduleBubbleEffectAfterOverheadClear
local scheduleGrayQuestMarkerAfterBubbleFade = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.scheduleGrayQuestMarkerAfterBubbleFade
local scheduleYellowQuestMarkerAfterBubbleFade = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.scheduleYellowQuestMarkerAfterBubbleFade
local setDialogNpcUnit = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.setDialogNpcUnit
local shouldSkipNewBubbleSchedule = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.shouldSkipNewBubbleSchedule
local tryOccupyNpc = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.tryOccupyNpc
--- 全图通用 UI 辅助（DzAPI / Frame）。
-- 
-- **联机与 desync**
-- - 本文件内均为 **本地帧操作**（`DzFrameSetFont` / `DzFrameSetTextAlignment` / `DzFrameSetParent` 等），**不**经网络同步。
-- - 需要注册 **点击/滚轮** 时，**强烈建议都用 `sync=true`**，但必须严格遵守以下规则：
--   - ✅ **按钮帧必须在所有玩家上创建**（不能在本地玩家判断内创建）
--   - ✅ **回调必须在所有玩家上注册**（不能在本地玩家判断内注册）
--   - ✅ **回调必须是全局函数**（不能是匿名闭包，闭包会导致 desync！）
--   - ✅ **回调内部严格区分操作类型**：
--     - 全局同步操作（游戏状态修改等）：必须在本地玩家判断之外执行
--     - 异步操作（UI 操作、音效等）：必须在本地玩家判断之内执行
--     - ⚠️ 不可以互相混淆！非常严格！
-- - 勿用会走 `ExecuteFunc` 的 `DzFrameSetScript` 同步字符串去驱动 Lua 逻辑。
-- - 若 UI 回调里要 **发同步数据**，应走项目既有 **Sync** 封装，勿在帧回调里直接改游戏状态而不同步。
-- 
-- 详细避坑经验见 `.cursor/rules/dzapi/ui-frame-types.mdc`。
local japi = require("jass.japi")
local jass = require("jass.common")
--- 通用 NPC 对话框入口。
-- - 若该玩家对话框正在播放（`isDialogActive(p) === true`），直接返回，不重复展开。
-- - 若该玩家对话框空闲（`isDialogActive(p) === false`），按 data 顺序入队播放。
-- - 文本数据由调用方传入，函数本身不硬编码任何内容。
-- - 每个玩家状态独立，互不影响。
-- - 如果NPC已被其他玩家占用，直接返回 false。
-- 
-- @returns 成功开始对话返回 true，否则返回 false
function ____exports.openNpcDialog(self, p, data)
    if isDialogActive(nil, p) then
        return false
    end
    if data.npcUnit then
        if not tryOccupyNpc(nil, p, data.npcUnit) then
            return false
        end
        setDialogNpcUnit(nil, p, data.npcUnit)
        local removedOverheadMarker = removeQuestMarkerAfterNpcTriggered(nil, data.npcUnit)
        local pid = jass:GetPlayerId(p)
        --- 必须用配置位而非「本地是否拆掉过叹号」：各客户端本地头顶表可能不一致，会导致 qipao 分支不同 → desync
        local waitQipaoAfterOverheadClear = data.removeOverheadMarkerOnOpen == true
        if not shouldSkipNewBubbleSchedule(nil, pid, data.npcUnit) then
            scheduleBubbleEffectAfterOverheadClear(nil, pid, data.npcUnit, waitQipaoAfterOverheadClear)
        end
        setDialogFinishCallback(
            nil,
            p,
            function()
                local pid = jass:GetPlayerId(p)
                releaseNpcOccupation(nil, pid)
                destroyBubbleEffect(nil, pid)
                if data.applyGrayQuestMarkerAfterDialog == true and data.npcUnit then
                    scheduleGrayQuestMarkerAfterBubbleFade(nil, data.npcUnit)
                end
                if data.restoreYellowQuestMarkerAfterDialog == true and data.npcUnit then
                    scheduleYellowQuestMarkerAfterBubbleFade(nil, data.npcUnit)
                end
            end
        )
    end
    for ____, line in ipairs(data.lines) do
        displayText(
            nil,
            p,
            line.title,
            line.text,
            line.duration
        )
    end
    if data.quest then
        local q = data.quest
        displayQuest(
            nil,
            p,
            q.title,
            q.text,
            q.onAccept,
            q.onReject,
            q.acceptText,
            q.rejectText
        )
    end
    return true
end
--- `DzFrameSetTextAlignment`：改对齐前重置，避免叠加
____exports.DZ_TEXT_ALIGN_RESET = -1
--- 居中
____exports.DZ_TEXT_ALIGN_CENTER = 18
--- 左对齐
____exports.DZ_TEXT_ALIGN_LEFT = 2
____exports.DEFAULT_UI_FONT_FILE = "UI\\uizt.ttf"
____exports.DEFAULT_UI_FONT_FLAG = 0
--- 列表/入口等默认字号（`DzFrameSetFont` 第三参）
____exports.DEFAULT_UI_FONT_SCALE = 0.016
--- 设置字体与文本对齐；`fontScale` 省略则用 `DEFAULT_UI_FONT_SCALE`。
function ____exports.applyDzTextFontAndAlignment(self, frame, textAlignment, fontScale, fontFile, fontFlag)
    if fontFile == nil then
        fontFile = ____exports.DEFAULT_UI_FONT_FILE
    end
    if fontFlag == nil then
        fontFlag = ____exports.DEFAULT_UI_FONT_FLAG
    end
    if not frame or frame == 0 then
        return
    end
    local scale = fontScale ~= nil and fontScale ~= nil and fontScale or ____exports.DEFAULT_UI_FONT_SCALE
    japi:DzFrameSetFont(frame, fontFile, scale, fontFlag)
    japi:DzFrameSetTextAlignment(frame, ____exports.DZ_TEXT_ALIGN_RESET)
    japi:DzFrameSetTextAlignment(frame, textAlignment)
end
function ____exports.applyDzTextFontAndCenterAlignment(self, frame, fontScale, fontFile, fontFlag)
    if fontFile == nil then
        fontFile = ____exports.DEFAULT_UI_FONT_FILE
    end
    if fontFlag == nil then
        fontFlag = ____exports.DEFAULT_UI_FONT_FLAG
    end
    ____exports.applyDzTextFontAndAlignment(
        nil,
        frame,
        ____exports.DZ_TEXT_ALIGN_CENTER,
        fontScale,
        fontFile,
        fontFlag
    )
end
--- `TEXT` 子帧与 `BACKDROP` 同大（`SetAllPoints(text, backdrop)`），便于对齐相对整块底图。
function ____exports.createTextFrameFillBackdrop(self, backdrop, name, text)
    if not backdrop or backdrop == 0 then
        return nil
    end
    local tf = createFrame(nil, {
        type = FrameType.TEXT,
        name = name,
        parent = backdrop,
        template = "template",
        visible = true
    })
    if not tf or tf == 0 then
        return nil
    end
    pcall(
        nil,
        function() return japi:DzFrameClearAllPoints(tf) end
    )
    pcall(
        nil,
        function() return japi:DzFrameSetAllPoints(tf, backdrop) end
    )
    japi:DzFrameSetText(tf, text)
    return tf
end
--- Tab 标签：`TEXT` 铺满背景 + 居中 + 指定 Tab 字号。
function ____exports.createTabLabelTextOnBackdrop(self, backdrop, name, text, tabLabelFontScale, fontFile, fontFlag)
    if fontFile == nil then
        fontFile = ____exports.DEFAULT_UI_FONT_FILE
    end
    if fontFlag == nil then
        fontFlag = ____exports.DEFAULT_UI_FONT_FLAG
    end
    local tf = ____exports.createTextFrameFillBackdrop(nil, backdrop, name, text)
    if not tf then
        return nil
    end
    ____exports.applyDzTextFontAndAlignment(
        nil,
        tf,
        ____exports.DZ_TEXT_ALIGN_CENTER,
        tabLabelFontScale,
        fontFile,
        fontFlag
    )
    return tf
end
--- `GLUETEXTBUTTON` 作点击层：挂到 `backdrop` 下、`SetAllPoints` 铺满。
function ____exports.layoutGlueTextButtonOverBackdrop(self, backdrop, button)
    if not backdrop or backdrop == 0 or not button or button == 0 then
        return
    end
    pcall(
        nil,
        function() return japi:DzFrameSetParent(button, backdrop) end
    )
    pcall(
        nil,
        function() return japi:DzFrameClearAllPoints(button) end
    )
    pcall(
        nil,
        function() return japi:DzFrameSetAllPoints(button, backdrop) end
    )
end
--- 透明命中层：铺满背景后清空按钮字并 `alpha=0`（文案由同背景的 `TEXT` 负责）。
function ____exports.setupTransparentGlueHitLayer(self, backdrop, button)
    ____exports.layoutGlueTextButtonOverBackdrop(nil, backdrop, button)
    setButtonText(nil, button, "")
    pcall(
        nil,
        function() return japi:DzFrameSetAlpha(button, 0) end
    )
end
return ____exports
