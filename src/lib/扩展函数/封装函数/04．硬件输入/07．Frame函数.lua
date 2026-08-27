--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_5185_90E8_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.02．内部工具")
local runFalseLocalRegistration = ____02_FF0E_5185_90E8_5DE5_5177.runFalseLocalRegistration
--- 硬件输入 - Frame函数
-- 
-- 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致 DzFrameSetScriptByCode 等参数错位，全图 UI 点击失效。
local japi = require("jass.japi")
local jass = require("jass.common")
function ____exports.getGameUI()
    return japi:DzGetGameUI()
end
function ____exports.frameFindByName(name, id)
    return japi:DzFrameFindByName(name, id)
end
--- 获取鼠标当前悬停的帧
function ____exports.getMouseFocus()
    return japi:DzGetMouseFocus()
end
--- UI 回调：eventId 参考 DzAPI.j（1点击/2进入/3离开/4释放/6滚轮/12双击...），参数顺序与原生一致
function ____exports.frameSetScriptByCode(frame, eventId, action, sync, playerId)
    if sync then
        japi:DzFrameSetScriptByCode(frame, eventId, action, true)
        return
    end
    runFalseLocalRegistration(
        nil,
        function()
            japi:DzFrameSetScriptByCode(frame, eventId, action, false)
        end,
        playerId
    )
end
--- 程序化点击帧，触发该帧的 click 回调（含 sync=true 回调），用于键盘事件转全房同步触发
function ____exports.clickFrame(frame)
    japi:DzClickFrame(frame)
end
return ____exports
