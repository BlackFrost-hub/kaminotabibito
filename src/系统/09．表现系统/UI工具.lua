--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local japi
local _____786C_4EF6_51FD_6570 = require("系统.00．核心系统.硬件函数")
local getGameUI = _____786C_4EF6_51FD_6570.getGameUI
local frameSetScriptByCode = _____786C_4EF6_51FD_6570.frameSetScriptByCode
--- 销毁Frame
function ____exports.destroyFrame(self, frame)
    if not frame or type(japi.DzDestroyFrame) ~= "function" then
        return false
    end
    japi.DzDestroyFrame(frame)
    return true
end
--- UI工具函数 - 通用的UI创建和管理函数
-- 只使用 BACKDROP + GLUETEXTBUTTON（War3 JAPI 兼容的帧类型）
local jass = require("jass.common")
japi = require("jass.japi")
--- Frame类型常量（DzAPI 支持的类型）
____exports.FrameType = {
    BACKDROP = "BACKDROP",
    TEXT = "TEXT",
    TEXTAREA = "TEXTAREA",
    GLUETEXTBUTTON = "GLUETEXTBUTTON",
    GLUECHECKBOX = "GLUECHECKBOX",
    POPUPMENU = "POPUPMENU",
    SCROLLBAR = "SCROLLBAR",
    SPRITE = "SPRITE",
    SLIDER = "SLIDER",
    BUTTON = "BUTTON",
    EDITBOX = "EDITBOX",
    HIGHLIGHT = "HIGHLIGHT",
    MENU = "MENU",
    DIALOG = "DIALOG",
    SIMPLEFRAME = "SIMPLEFRAME",
    SIMPLESTATUSBAR = "SIMPLESTATUSBAR",
    SIMPLECHECKBOX = "SIMPLECHECKBOX"
}
--- FDF 层：Layer "ARTWORK" = 插图层
____exports.FrameLayer = {ARTWORK = "ARTWORK"}
--- Frame点常量（对应DzFrameSetAbsolutePoint的point参数）
____exports.FramePoint = {
    TOPLEFT = 0,
    TOP = 1,
    TOPRIGHT = 2,
    LEFT = 3,
    CENTER = 4,
    RIGHT = 5,
    BOTTOMLEFT = 6,
    BOTTOM = 7,
    BOTTOMRIGHT = 8
}
--- 事件类型常量（对应 DzFrameSetScript / DzFrameSetScriptByCode 的 eventId，与 Blizzard Frame 事件编号一致）。
-- 说明：部分 GUI/1.27e 下 Frame 层**不保证**单独派发「按下」；若 ID5 无效，拖拽起点请用 **DzTriggerRegisterMouseEventByCode**（全局鼠标），勿死绑帧上 MOUSE_DOWN。
____exports.EventType = {
    MOUSE_CLICK = 1,
    MOUSE_ENTER = 2,
    MOUSE_LEAVE = 3,
    MOUSE_UP = 4,
    MOUSE_DOWN = 5,
    MOUSE_WHEEL = 6,
    MOUSE_DOUBLE_CLICK = 12,
    SLIDER_VALUE_CHANGED = 11
}
--- 创建Frame
function ____exports.createFrame(self, config)
    local ____config_0 = config
    local ____type = ____config_0.type
    local name = ____config_0.name
    local parent = ____config_0.parent
    if parent == nil then
        parent = 0
    end
    local template = ____config_0.template
    if template == nil then
        template = "template"
    end
    local id = ____config_0.id
    if id == nil then
        id = 0
    end
    if type(japi.DzCreateFrameByTagName) ~= "function" then
        return nil
    end
    if ____type == ____exports.FrameType.SIMPLEFRAME then
        return nil
    end
    local frame = japi.DzCreateFrameByTagName(
        ____type,
        name,
        parent,
        template,
        id
    )
    if frame == nil or frame == 0 then
        return nil
    end
    if config.visible ~= nil and type(japi.DzFrameShow) == "function" then
        pcall(function ()
                japi.DzFrameShow(frame, config.visible)
            end
        )
    end
    if config.enable == false and type(japi.DzFrameSetEnable) == "function" then
        pcall(function ()
                japi.DzFrameSetEnable(frame, false)
            end
        )
    end
    if config.alpha ~= nil and type(japi.DzFrameSetAlpha) == "function" then
        pcall(function ()
                japi.DzFrameSetAlpha(frame, config.alpha)
            end
        )
    end
    if config.level ~= nil and type(japi.DzFrameSetLevel) == "function" then
        pcall(function ()
                japi.DzFrameSetLevel(frame, config.level)
            end
        )
    end
    return frame
end
--- 安全加载 TOC（只加载一次）：
-- - 允许同时传多个可能路径（你这套项目里常见：`UI\\xxx.toc` 与 `war3mapImported\\UI\\xxx.toc`）
-- - 用 `pcall` 包住 Lua 层异常，避免初始化流程被 Lua 报错打断
-- 
-- 注意：如果客户端在绘制/交互阶段对某些 FDF 帧直接“引擎级崩溃”，`pcall` 也拦不住；
-- 所以仍建议“分阶段/白名单”逐步替换控件类型。
local __tocLoadedOnce = {}
function ____exports.loadTocOnce(self, tocLoadKey, tocPaths, debugPrefix)
    if debugPrefix == nil then
        debugPrefix = "UI"
    end
    if __tocLoadedOnce[tocLoadKey] then
        return
    end
    __tocLoadedOnce[tocLoadKey] = true
    if type(japi.DzLoadToc) ~= "function" then
        return
    end
    for ____, p in ipairs(tocPaths) do
        local ok = pcall(function ()
                japi.DzLoadToc(p)
            end
        )
        if not ok then
            local pr = _G.print
            if type(pr) == "function" then
                pr((("[" .. debugPrefix) .. "] DzLoadToc fail: ") .. p)
            end
        end
    end
end
--- `DzLoadToc` + `DzCreateFrame` try/fallback 的通用封装。
-- 
-- 用法示例（放在某个 UI 模块里）：
-- ```ts
-- const f = tryCreateFromFdfSafe("TaskEntryIcon", parent, () =>
--   createFrame({ type: FrameType.BACKDROP, name: "TaskEntryIcon", parent, template: "template", visible: true })
-- , {
--   tocLoadKey: "TaskUI",
--   tocPaths: ["UI\\\\TaskUI.toc", "war3mapImported\\\\UI\\\\TaskUI.toc"],
--   debugPrefix: "TaskUI"
-- });
-- ```
-- 
-- @returns 失败时返回 fallback 的结果（允许 fallback 返回 null）
function ____exports.tryCreateFromFdfSafe(self, frameName, parent, fallback, opts)
    ____exports.loadTocOnce(nil, opts.tocLoadKey, opts.tocPaths, opts.debugPrefix or "UI")
    if type(japi.DzCreateFrame) ~= "function" then
        return fallback(nil)
    end
    local f = 0
    local ok = pcall(function ()
            f = japi.DzCreateFrame(frameName, parent, 0)
        end
    )
    if ok and f ~= nil and f ~= 0 then
        return f
    end
    return fallback(nil)
end
--- 设置Frame位置（绝对坐标，屏幕）
function ____exports.setFramePosition(self, frame, position)
    if frame == 0 or frame == nil or type(japi.DzFrameSetAbsolutePoint) ~= "function" then
        return false
    end
    japi.DzFrameSetAbsolutePoint(frame, position.point, position.x, position.y)
    return true
end
--- 设置Frame相对位置（相对父/参考帧，用于子控件）
function ____exports.setFramePointRelative(self, frame, point, relativeFrame, relativePoint, x, y)
    if frame == 0 or frame == nil or relativeFrame == 0 or relativeFrame == nil or type(japi.DzFrameSetPoint) ~= "function" then
        return false
    end
    japi.DzFrameSetPoint(
        frame,
        point,
        relativeFrame,
        relativePoint,
        x,
        y
    )
    return true
end
--- 设置Frame尺寸
function ____exports.setFrameSize(self, frame, size)
    if frame == 0 or frame == nil or type(japi.DzFrameSetSize) ~= "function" then
        return false
    end
    japi.DzFrameSetSize(frame, size.width, size.height)
    return true
end
--- 设置Frame纹理（仅设置纹理和透明度，不使用DzFrameSetVertexColor）
function ____exports.setFrameTexture(self, frame, texture)
    if frame == 0 or frame == nil then
        return false
    end
    if texture and type(japi.DzFrameSetTexture) == "function" then
        japi.DzFrameSetTexture(frame, texture, 0)
    end
    return true
end
--- 设置Frame点击事件
function ____exports.setFrameClickEvent(self, frame, callback, sync)
    if sync == nil then
        sync = true
    end
    if frame == 0 or frame == nil then
        return false
    end
    frameSetScriptByCode(
        nil,
        frame,
        ____exports.EventType.MOUSE_CLICK,
        callback,
        sync
    )
    return true
end
--- 设置Frame悬停事件
function ____exports.setFrameHoverEvents(self, frame, onEnter, onLeave, sync)
    if sync == nil then
        sync = true
    end
    if frame == 0 or frame == nil then
        return false
    end
    frameSetScriptByCode(
        nil,
        frame,
        ____exports.EventType.MOUSE_ENTER,
        onEnter,
        sync
    )
    frameSetScriptByCode(
        nil,
        frame,
        ____exports.EventType.MOUSE_LEAVE,
        onLeave,
        sync
    )
    return true
end
--- 设置GLUETEXTBUTTON的文本（DzFrameSetText仅对GLUETEXTBUTTON有效）
function ____exports.setButtonText(self, frame, text)
    if not frame or type(japi.DzFrameSetText) ~= "function" then
        return false
    end
    japi.DzFrameSetText(frame, text)
    return true
end
--- 创建可点击的图标（BACKDROP + GLUETEXTBUTTON组合）
function ____exports.createClickableIcon(self, name, parent, texture, position, size, onClick)
    local backdrop = ____exports.createFrame(nil, {
        type = ____exports.FrameType.BACKDROP,
        name = name .. "_Backdrop",
        parent = parent,
        template = "template",
        visible = true
    })
    if not backdrop then
        return nil
    end
    ____exports.setFramePosition(nil, backdrop, position)
    ____exports.setFrameSize(nil, backdrop, size)
    ____exports.setFrameTexture(nil, backdrop, texture)
    local button = ____exports.createFrame(nil, {
        type = ____exports.FrameType.GLUETEXTBUTTON,
        name = name .. "_Button",
        parent = backdrop,
        template = "template",
        visible = true,
        enable = true,
        alpha = 0
    })
    if not button then
        return nil
    end
    if type(japi.DzFrameSetAllPoints) == "function" then
        japi.DzFrameSetAllPoints(button, backdrop)
    else
        ____exports.setFramePosition(nil, button, position)
        ____exports.setFrameSize(nil, button, size)
    end
    ____exports.setFrameClickEvent(nil, button, onClick)
    return {backdrop = backdrop, button = button}
end
--- 创建文本按钮（GLUETEXTBUTTON显示文本，可点击）
function ____exports.createTextButton(self, name, parent, text, position, size, onClick)
    local frame = ____exports.createFrame(nil, {
        type = ____exports.FrameType.GLUETEXTBUTTON,
        name = name,
        parent = parent,
        template = "template",
        visible = true,
        enable = true
    })
    if not frame then
        return nil
    end
    ____exports.setFramePosition(nil, frame, position)
    ____exports.setFrameSize(nil, frame, size)
    ____exports.setButtonText(nil, frame, text)
    if onClick then
        ____exports.setFrameClickEvent(nil, frame, onClick)
    end
    return frame
end
--- 创建纯文本标签（使用TEXT类型）
-- position 支持 PositionConfig（绝对）或 RelativePositionConfig（相对父帧）
function ____exports.createTextLabel(self, name, parent, text, position, size)
    local isRelative = position.relativeTo ~= nil
    local function setPos(____, f)
        if isRelative then
            local r = position
            ____exports.setFramePointRelative(
                nil,
                f,
                r.point,
                r.relativeTo,
                r.relativePoint,
                r.x,
                r.y
            )
        else
            ____exports.setFramePosition(nil, f, position)
        end
    end
    local frame = ____exports.createFrame(nil, {
        type = ____exports.FrameType.TEXT,
        name = name,
        parent = parent,
        template = "template",
        visible = true
    })
    if frame then
        setPos(nil, frame)
        ____exports.setFrameSize(nil, frame, size)
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(frame, text)
        end
        return frame
    end
    local fallbackFrame = ____exports.createFrame(nil, {
        type = ____exports.FrameType.GLUETEXTBUTTON,
        name = name,
        parent = parent,
        template = "template",
        visible = true
    })
    if not fallbackFrame then
        return nil
    end
    setPos(nil, fallbackFrame)
    ____exports.setFrameSize(nil, fallbackFrame, size)
    ____exports.setButtonText(nil, fallbackFrame, text)
    return fallbackFrame
end
--- 创建文本框（使用TEXTAREA类型，带背景）
function ____exports.createTextArea(self, name, parent, text, position, size, backgroundTexture)
    local backdrop = ____exports.createFrame(nil, {
        type = ____exports.FrameType.BACKDROP,
        name = name .. "_Backdrop",
        parent = parent,
        template = "template",
        visible = true
    })
    if backdrop then
        ____exports.setFramePosition(nil, backdrop, position)
        ____exports.setFrameSize(nil, backdrop, size)
        if backgroundTexture and type(japi.DzFrameSetTexture) == "function" then
            japi.DzFrameSetTexture(backdrop, backgroundTexture, 0)
        end
    end
    local frame = ____exports.createFrame(nil, {
        type = ____exports.FrameType.TEXTAREA,
        name = name,
        parent = backdrop or parent,
        template = "template",
        visible = true
    })
    if frame then
        if backdrop and type(japi.DzFrameSetAllPoints) == "function" then
            japi.DzFrameSetAllPoints(frame, backdrop)
        else
            ____exports.setFramePosition(nil, frame, position)
            ____exports.setFrameSize(nil, frame, size)
        end
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(frame, text)
        end
        return frame
    end
    return ____exports.createTextLabel(
        nil,
        name,
        parent,
        text,
        position,
        size
    )
end
--- 创建带背景的文本框容器
function ____exports.createTextBox(self, name, parent, text, position, size, backgroundTexture)
    local backdrop = ____exports.createFrame(nil, {
        type = ____exports.FrameType.BACKDROP,
        name = name .. "_Backdrop",
        parent = parent,
        template = "template",
        visible = true
    })
    if not backdrop then
        return nil
    end
    ____exports.setFramePosition(nil, backdrop, position)
    ____exports.setFrameSize(nil, backdrop, size)
    ____exports.setFrameTexture(nil, backdrop, backgroundTexture)
    local textFrame = ____exports.createFrame(nil, {
        type = ____exports.FrameType.TEXT,
        name = name .. "_Text",
        parent = backdrop,
        template = "template",
        visible = true
    })
    if not textFrame then
        ____exports.destroyFrame(nil, backdrop)
        return nil
    end
    local innerPos = {point = position.point, x = position.x + 0.005, y = position.y - 0.005}
    local innerSize = {width = size.width - 0.01, height = size.height - 0.01}
    ____exports.setFramePosition(nil, textFrame, innerPos)
    ____exports.setFrameSize(nil, textFrame, innerSize)
    if type(japi.DzFrameSetText) == "function" then
        japi.DzFrameSetText(textFrame, text)
    end
    return {backdrop = backdrop, text = textFrame}
end
--- 隐藏Frame
function ____exports.hideFrame(self, frame)
    if not frame or type(japi.DzFrameShow) ~= "function" then
        return false
    end
    japi.DzFrameShow(frame, false)
    return true
end
--- 显示Frame
function ____exports.showFrame(self, frame)
    if not frame or type(japi.DzFrameShow) ~= "function" then
        return false
    end
    japi.DzFrameShow(frame, true)
    return true
end
--- 获取游戏UI根Frame
function ____exports.getGameUIFrame(self)
    return getGameUI(nil)
end
return ____exports
