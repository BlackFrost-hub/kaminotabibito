--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照")
local commandBarAbility = require("系统.03．技能系统.01．技能冷却.04．命令卡技能槽位")
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLog = ____require_result_1.debugLog
local fourCCConverter = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local function onDebugCommand(_player, _command)
    local snapshot = selectionSnapshotSystem["获取本地选中技能快照"]()
    local hero = snapshot.hero
    debugLog("QWERD调试", "===== -dc 快照转储 =====")
    debugLog(
        "QWERD调试",
        "快照 hero = " .. tostring(hero)
    )
    if hero ~= nil and hero ~= 0 then
        debugLog(
            "QWERD调试",
            (((((((("快照技能 Q=" .. tostring(snapshot.skills.Q)) .. " W=") .. tostring(snapshot.skills.W)) .. " E=") .. tostring(snapshot.skills.E)) .. " R=") .. tostring(snapshot.skills.R)) .. " D=") .. tostring(snapshot.skills.D)
        )
        debugLog(
            "QWERD调试",
            (((((((("快照技能ID文本 Q=" .. fourCCConverter.fourCCToStringSafe(snapshot.skills.Q)) .. " W=") .. fourCCConverter.fourCCToStringSafe(snapshot.skills.W)) .. " E=") .. fourCCConverter.fourCCToStringSafe(snapshot.skills.E)) .. " R=") .. fourCCConverter.fourCCToStringSafe(snapshot.skills.R)) .. " D=") .. fourCCConverter.fourCCToStringSafe(snapshot.skills.D)
        )
        debugLog(
            "QWERD调试",
            ((("快照槽位 D=(" .. tostring(snapshot.slots.D.x)) .. ",") .. tostring(snapshot.slots.D.y)) .. ")"
        )
        commandBarAbility["调试转储命令卡槽位"](hero)
    else
        debugLog("QWERD调试", "本地未选中英雄，快照为空；请先选中英雄再输入 -dc")
    end
    debugLog("QWERD调试", "===== -dc 转储完成 =====")
end
____exports["初始化QWERD调试命令"] = function()
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("-dc", onDebugCommand)
    debugLog("QWERD调试", "调试命令 -dc 已注册")
end
____exports["初始化QWERD调试命令"]()
return ____exports
