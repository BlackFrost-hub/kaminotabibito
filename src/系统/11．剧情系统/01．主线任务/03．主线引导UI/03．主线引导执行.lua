local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____02_FF0E_4E3B_7EBF_5F15_5BFC_6846_67B6 = require("系统.11．剧情系统.01．主线任务.03．主线引导UI.02．主线引导框架")
local _____5E27 = ____02_FF0E_4E3B_7EBF_5F15_5BFC_6846_67B6["帧"]
local ____01_FF0E_4E3B_7EBF_5F15_5BFC_914D_7F6E_8868 = require("系统.11．剧情系统.01．主线任务.03．主线引导UI.01．主线引导配置表")
local _____83B7_53D6_8FDB_5EA6_914D_7F6E = ____01_FF0E_4E3B_7EBF_5F15_5BFC_914D_7F6E_8868["获取进度配置"]
--- 主线引导执行逻辑
-- 
-- 点击回调与执行逻辑（读取剧情进度、移动镜头、GS_news）
-- 按钮点击注册必须 sync=true
-- Dz 回调必须是模块级具名函数，不允许匿名闭包/箭头函数
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.GS扩展库.index")
local GS_news = ____require_result_0.GS_news
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.index")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____require_result_2["读取语义单位引用"]
local DzFrameShow = japi.DzFrameShow
local DzFrameSetText = japi.DzFrameSetText
local DzGetTriggerUIEventPlayer = japi.DzGetTriggerUIEventPlayer
local GetLocalPlayer = jass.GetLocalPlayer
local CreateTimer = jass.CreateTimer
local TimerStart = jass.TimerStart
local DestroyTimer = jass.DestroyTimer
local GetExpiredTimer = jass.GetExpiredTimer
local GetHandleId = jass.GetHandleId
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____73A9_5BB6_5C55_5F00_72B6_6001_8868 = {}
local _____8BA1_65F6_5668_73A9_5BB6_8868 = {}
--- 获取镜头目标坐标
-- 优先跟随单位，其次固定坐标
local function _____83B7_53D6_955C_5934_76EE_6807(_____914D_7F6E)
    if _____914D_7F6E["镜头跟随单位"] ~= nil then
        local unit = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____914D_7F6E["镜头跟随单位"])
        if unit ~= nil and unit ~= 0 then
            return {
                x = GetUnitX(unit),
                y = GetUnitY(unit)
            }
        end
    end
    if _____914D_7F6E["镜头X"] ~= nil and _____914D_7F6E["镜头Y"] ~= nil then
        return {x = _____914D_7F6E["镜头X"], y = _____914D_7F6E["镜头Y"]}
    end
    return nil
end
--- 延时隐藏放大效果
-- 全端执行，本地显隐
local function ____on_9690_85CF_653E_5927_6548_679C()
    local timer = GetExpiredTimer()
    if timer == nil or timer == 0 then
        return
    end
    local key = GetHandleId(timer)
    local player = _____8BA1_65F6_5668_73A9_5BB6_8868[key]
    __TS__Delete(_____8BA1_65F6_5668_73A9_5BB6_8868, key)
    if GetLocalPlayer() == player then
        DzFrameShow(_____5E27["放大效果"], false)
    end
    DestroyTimer(timer)
end
--- 主线引导按钮点击回调
-- sync=true，全端执行
____exports["on主线引导按钮点击"] = function()
    local _____89E6_53D1_73A9_5BB6 = DzGetTriggerUIEventPlayer()
    if _____89E6_53D1_73A9_5BB6 == nil or _____89E6_53D1_73A9_5BB6 == 0 then
        return
    end
    local _____73A9_5BB6ID = GetPlayerId(_____89E6_53D1_73A9_5BB6)
    local _____5DF2_5C55_5F00 = _____73A9_5BB6_5C55_5F00_72B6_6001_8868[_____73A9_5BB6ID] == true
    if not _____5DF2_5C55_5F00 then
        _____73A9_5BB6_5C55_5F00_72B6_6001_8868[_____73A9_5BB6ID] = true
        if GetLocalPlayer() == _____89E6_53D1_73A9_5BB6 then
            DzFrameShow(_____5E27["放大效果"], true)
        end
        local timer = CreateTimer()
        _____8BA1_65F6_5668_73A9_5BB6_8868[GetHandleId(timer)] = _____89E6_53D1_73A9_5BB6
        TimerStart(timer, 0.25, false, ____on_9690_85CF_653E_5927_6548_679C)
    else
        _____73A9_5BB6_5C55_5F00_72B6_6001_8868[_____73A9_5BB6ID] = false
        DzFrameShow(_____5E27["放大效果"], false)
    end
    local config = _____83B7_53D6_8FDB_5EA6_914D_7F6E()
    if config == nil then
        return
    end
    DzFrameSetText(_____5E27["提示文本"], config["提示文本"])
    local target = _____83B7_53D6_955C_5934_76EE_6807(config)
    if target ~= nil then
        StarOther_PanCameraToTimedForPlayer(_____89E6_53D1_73A9_5BB6, target.x, target.y, 0.01)
    end
    GS_news(_____89E6_53D1_73A9_5BB6, config["提示文本"])
end
return ____exports
