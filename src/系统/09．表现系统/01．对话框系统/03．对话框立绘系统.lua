--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3 = require("系统.09．表现系统.01．对话框系统.01．对话框渲染核心")
local dzSetTexture = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzSetTexture
local dzShow = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzShow
local dzGetLocalPlayer = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzGetLocalPlayer
local dzPlayer = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzPlayer
local PORTRAIT_INDICES = {left = 101, mid = 102, right = 103}
--- 更新所有立绘
-- 
-- @param state 玩家对话框状态
-- @param leftTex 左侧立绘路径（空字符串表示隐藏）
-- @param midTex 中间立绘路径
-- @param rightTex 右侧立绘路径
function ____exports.updatePortraits(self, state, leftTex, midTex, rightTex)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    if leftTex ~= "" then
        dzSetTexture(nil, state.frames[102], leftTex)
        dzShow(nil, state.frames[102], true)
    else
        dzShow(nil, state.frames[102], false)
    end
    if midTex ~= "" then
        dzSetTexture(nil, state.frames[103], midTex)
        dzShow(nil, state.frames[103], true)
    else
        dzShow(nil, state.frames[103], false)
    end
    if rightTex ~= "" then
        dzSetTexture(nil, state.frames[104], rightTex)
        dzShow(nil, state.frames[104], true)
    else
        dzShow(nil, state.frames[104], false)
    end
end
--- 设置单个立绘
-- 
-- @param state 玩家对话框状态
-- @param position 立绘位置
-- @param texturePath 贴图路径（空字符串表示隐藏）
function ____exports.setPortrait(self, state, position, texturePath)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    local frameIdx = PORTRAIT_INDICES[position]
    if texturePath ~= "" then
        dzSetTexture(nil, state.frames[frameIdx + 1], texturePath)
        dzShow(nil, state.frames[frameIdx + 1], true)
    else
        dzShow(nil, state.frames[frameIdx + 1], false)
    end
end
--- 隐藏所有立绘
-- 
-- @param state 玩家对话框状态
function ____exports.hideAllPortraits(self, state)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    dzShow(nil, state.frames[102], false)
    dzShow(nil, state.frames[103], false)
    dzShow(nil, state.frames[104], false)
end
--- 显示所有立绘（使用当前已设置的贴图）
-- 
-- @param state 玩家对话框状态
function ____exports.showAllPortraits(self, state)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    dzShow(nil, state.frames[102], true)
    dzShow(nil, state.frames[103], true)
    dzShow(nil, state.frames[104], true)
end
--- 隐藏指定位置的立绘
-- 
-- @param state 玩家对话框状态
-- @param position 立绘位置
function ____exports.hidePortrait(self, state, position)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    local frameIdx = PORTRAIT_INDICES[position]
    dzShow(nil, state.frames[frameIdx + 1], false)
end
--- 显示指定位置的立绘
-- 
-- @param state 玩家对话框状态
-- @param position 立绘位置
function ____exports.showPortrait(self, state, position)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    local frameIdx = PORTRAIT_INDICES[position]
    dzShow(nil, state.frames[frameIdx + 1], true)
end
return ____exports
