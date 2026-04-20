--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 硬件输入 - Frame函数
-- 
-- 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致 DzFrameSetScriptByCode 等参数错位，全图 UI 点击失效。
local japi = require("jass.japi")
function ____exports.getGameUI(self)
    return japi.DzGetGameUI()
end
function ____exports.frameFindByName(self, name, id)
    return japi.DzFrameFindByName(name, id)
end
--- 获取鼠标当前悬停的帧
function ____exports.getMouseFocus(self)
    return japi.DzGetMouseFocus()
end
--- UI 回调：eventId 参考 DzAPI.j（1点击/2进入/3离开/4释放/6滚轮/12双击...），参数顺序与原生一致
function ____exports.frameSetScriptByCode(self, frame, eventId, action, sync)
    japi.DzFrameSetScriptByCode(frame, eventId, action, sync)
end
--- 程序化点击帧，触发该帧的 click 回调（含 sync=true 回调），用于键盘事件转全房同步触发
function ____exports.clickFrame(self, frame)
    japi.DzClickFrame(frame)
end
return ____exports
