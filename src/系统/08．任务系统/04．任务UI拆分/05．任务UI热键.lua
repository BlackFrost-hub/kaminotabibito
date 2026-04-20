--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local jass = require("jass.common")
--- 注册 J、1、2、3：J 随时可开关面板；1/2/3 仅在面板可见时切换 QuestType。
function ____exports.registerTaskUIHotkeys(self, opts)
    local ____opts_0 = opts
    local registerKeyDown = ____opts_0.registerKeyDown
    local KEY = ____opts_0.KEY
    local KEY_NUM = ____opts_0.KEY_NUM
    local onClickSound = ____opts_0.onClickSound
    local onTogglePanel = ____opts_0.onTogglePanel
    local onSwitchCategory = ____opts_0.onSwitchCategory
    local isVisible = ____opts_0.isVisible
    local setCurrentPlayerId = ____opts_0.setCurrentPlayerId
    if type(registerKeyDown) ~= "function" then
        return
    end
    registerKeyDown(
        nil,
        KEY.J,
        function(____, player)
            pcall(function ()
                    local lp = jass.GetLocalPlayer()
                    if lp == nil then
                        return
                    end
                    local getPid = jass.GetPlayerId
                    if getPid and player then
                        setCurrentPlayerId(
                            nil,
                            getPid(player)
                        )
                    end
                    onClickSound(nil)
                    onTogglePanel(nil)
                end
            )
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K1,
        function(____, _player)
            pcall(function ()
                    local lp = jass.GetLocalPlayer()
                    if lp == nil then
                        return
                    end
                    if not isVisible(nil) then
                        return
                    end
                    onClickSound(nil)
                    onSwitchCategory(nil, QuestType.MAIN)
                end
            )
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K2,
        function(____, _player)
            pcall(function ()
                    local lp = jass.GetLocalPlayer()
                    if lp == nil then
                        return
                    end
                    if not isVisible(nil) then
                        return
                    end
                    onClickSound(nil)
                    onSwitchCategory(nil, QuestType.SIDE)
                end
            )
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K3,
        function(____, _player)
            pcall(function ()
                    local lp = jass.GetLocalPlayer()
                    if lp == nil then
                        return
                    end
                    if not isVisible(nil) then
                        return
                    end
                    onClickSound(nil)
                    onSwitchCategory(nil, QuestType.DAILY)
                end
            )
        end
    )
end
return ____exports
