--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY = ____01_FF0E_5E38_91CF_5B9A_4E49.KEY
local ____04_FF0E_952E_76D8_51FD_6570 = require("lib.扩展函数.封装函数.04．硬件输入.04．键盘函数")
local isKeyDown = ____04_FF0E_952E_76D8_51FD_6570.isKeyDown
local registerKeyEventRawStatus = ____04_FF0E_952E_76D8_51FD_6570.registerKeyEventRawStatus
--- 硬件输入 - 测试按键（B键广播9999）
local jass = require("jass.common")
local japi = require("jass.japi")
local function initTestKeyB(self)
    if type(jass.DisplayTimedTextToPlayer) ~= "function" or type(jass.Player) ~= "function" then
        return
    end
    --- 去抖 / 只在"松开"触发一次：
    -- 
    -- 平台环境里键盘事件（DzTriggerRegisterKeyEventByCode）存在以下实测特性：
    -- - 必须 `sync=false` 才会触发回调（sync=true 不触发）
    -- - `status` 参数在 Lua/ByCode 这条链上不严格（0/1/2 都可能触发；甚至按住会重复派发）
    -- 
    -- 因此不能指望只靠 status 区分按下/抬起。
    -- 这里改用 DzIsKeyDown(keyCode) 做"边沿检测"：
    -- - last=true 且 down=false 时，判定为"从按下→松开"，只触发一次。
    local lastDownByPid = {}
    local ____temp_0
    if type(jass.GetPlayerId) == "function" then
        ____temp_0 = jass.GetPlayerId
    else
        ____temp_0 = nil
    end
    local getPid = ____temp_0
    local function hook(____, st)
        registerKeyEventRawStatus(
            nil,
            KEY.B,
            st,
            false,
            function()
                local ____temp_1
                if type(japi.DzGetTriggerKeyPlayer) == "function" then
                    ____temp_1 = japi.DzGetTriggerKeyPlayer()
                else
                    ____temp_1 = nil
                end
                local p = ____temp_1
                local ____temp_2
                if getPid and p then
                    ____temp_2 = getPid(p)
                else
                    ____temp_2 = 0
                end
                local pid = ____temp_2
                local down = isKeyDown(nil, KEY.B)
                local last = not not lastDownByPid[pid]
                lastDownByPid[pid] = down
                if last and not down then
                    do
                        local i = 0
                        while i < 12 do
                            jass.DisplayTimedTextToPlayer(
                                jass.Player(i),
                                0,
                                0,
                                3,
                                "9999"
                            )
                            i = i + 1
                        end
                    end
                    if type(jass.GetPlayerName) == "function" and p then
                        jass.DisplayTimedTextToPlayer(
                            jass.Player(0),
                            0,
                            0,
                            3,
                            "from=" .. tostring(jass.GetPlayerName(p))
                        )
                    end
                end
            end
        )
    end
    hook(nil, 0)
    hook(nil, 1)
    hook(nil, 2)
    do
        local i = 0
        while i < 12 do
            lastDownByPid[i + 1] = false
            i = i + 1
        end
    end
end
initTestKeyB(nil)
return ____exports
