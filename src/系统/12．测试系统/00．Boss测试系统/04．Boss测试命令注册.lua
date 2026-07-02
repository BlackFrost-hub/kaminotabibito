--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local jass = require("jass.common")
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local function _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, ____Boss_540D_79F0, text)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        (("[" .. ____Boss_540D_79F0) .. "测试] ") .. text
    )
end
local function _____751F_6210_547D_4EE4_8BF4_660E(_____914D_7F6E)
    local text = ""
    local list = _____914D_7F6E["技能命令列表"]
    do
        local i = 0
        while i < #list do
            text = ((text .. " ") .. tostring(list[i + 1]["序号"])) .. list[i + 1]["名称"]
            i = i + 1
        end
    end
    return (_____914D_7F6E["命令前缀"] .. text) .. "。"
end
____exports["注册Boss测试命令组"] = function(_____914D_7F6E)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(
        _____914D_7F6E["命令前缀"],
        function(player)
            local context = _____914D_7F6E["创建或获取上下文"](player)
            if context == nil then
                return
            end
            _____53D1_9001Boss_6D4B_8BD5_63D0_793A(
                player,
                _____914D_7F6E["Boss名称"],
                "已创建/复用测试场景。" .. _____751F_6210_547D_4EE4_8BF4_660E(_____914D_7F6E)
            )
        end
    )
    local list = _____914D_7F6E["技能命令列表"]
    do
        local i = 0
        while i < #list do
            local item = list[i + 1]
            _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(
                _____914D_7F6E["命令前缀"] .. tostring(item["序号"]),
                function(player)
                    local context = _____914D_7F6E["创建或获取上下文"](player)
                    if context == nil then
                        return
                    end
                    item["执行"](player, context)
                    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, _____914D_7F6E["Boss名称"], ("已测试：" .. item["名称"]) .. "。")
                end
            )
            i = i + 1
        end
    end
end
return ____exports
