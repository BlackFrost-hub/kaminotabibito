local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local globals = require("jass.globals")
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.04．Boss自动施法开关")
local _____8BBE_7F6EBoss_81EA_52A8_65BD_6CD5_5F00_542F = ____require_result_0["设置Boss自动施法开启"]
local ____Boss_81EA_52A8_65BD_6CD5_662F_5426_5F00_542F = ____require_result_0["Boss自动施法是否开启"]
local ____require_result_1 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8 = ____require_result_1["记录Boss自动技能启动"]
local _____6E05_7406Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587 = ____require_result_1["清理Boss自动技能启动上下文"]
local _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD = ____require_result_1["是否已登记Boss自动技能"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_2["注册聊天命令监听"]
local jass = require("jass.common")
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local GetPlayerId = jass.GetPlayerId
local GetPlayerName = jass.GetPlayerName
local ____Boss_6D4B_8BD5_9009_62E9_547D_4EE4_8868 = {}
local ____Boss_6D4B_8BD5_914D_7F6E_5217_8868 = {}
local _____5DF2_6CE8_518C_6280_80FD_6570_5B57_547D_4EE4_8868 = {}
local ____Boss_6D4B_8BD5_73A9_5BB6ID = 0
local ____Boss_6D4B_8BD5_73A9_5BB6_540D_79F0 = "WorldEdit"
local ____Boss_6D4B_8BD5_5217_8868_547D_4EE4 = "Boss列表"
local ____Boss_6D4B_8BD5_91CD_7F6E_547D_4EE4 = "Boss重置"
local ____Boss_6D4B_8BD5_6E05_7406_547D_4EE4 = "Boss清理"
local ____Boss_6D4B_8BD5AI_5F00_542F_547D_4EE4 = "BossAI开启"
local ____Boss_6D4B_8BD5AI_5173_95ED_547D_4EE4 = "BossAI关闭"
local _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
local _____5DF2_6CE8_518CBoss_6D4B_8BD5_516C_5171_547D_4EE4 = false
local function _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, ____Boss_540D_79F0, text)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        12,
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
    return text .. "。"
end
local function _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player)
    if player == nil or player == 0 then
        return false
    end
    if GetPlayerId(player) ~= ____Boss_6D4B_8BD5_73A9_5BB6ID then
        return false
    end
    local playerName = GetPlayerName(player) or ""
    return playerName == ____Boss_6D4B_8BD5_73A9_5BB6_540D_79F0 or playerName == ____Boss_6D4B_8BD5_73A9_5BB6_540D_79F0 .. ":"
end
local function _____6E05_7406_5F53_524DBoss_6D4B_8BD5_4F1A_8BDD()
    local session = _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
    _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD = nil
    if session ~= nil then
        _____6E05_7406Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587(session["Boss单位"])
        session["配置"]["清理上下文"](session["玩家"], session["上下文"])
    end
    _____8BBE_7F6EBoss_81EA_52A8_65BD_6CD5_5F00_542F(true)
end
local function _____6FC0_6D3BBoss_6D4B_8BD5_914D_7F6E(player, _____914D_7F6E)
    _____6E05_7406_5F53_524DBoss_6D4B_8BD5_4F1A_8BDD()
    _____8BBE_7F6EBoss_81EA_52A8_65BD_6CD5_5F00_542F(false)
    local context = _____914D_7F6E["创建或获取上下文"](player)
    if context == nil then
        _____8BBE_7F6EBoss_81EA_52A8_65BD_6CD5_5F00_542F(true)
        _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, _____914D_7F6E["Boss名称"], "测试场景创建失败。")
        return
    end
    _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD = {["玩家"] = player, ["配置"] = _____914D_7F6E, ["上下文"] = context, ["Boss单位"] = globals.udg_Boss}
    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(
        player,
        _____914D_7F6E["Boss名称"],
        ("已创建玩家1 Boss 与两个固定步兵靶，自动AI已关闭。输入技能序号：" .. _____751F_6210_547D_4EE4_8BF4_660E(_____914D_7F6E)) .. " 输入BossAI开启可验证正式AI。"
    )
end
local function ____onBoss_6D4B_8BD5_9009_62E9_547D_4EE4(player, command)
    if not _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local _____914D_7F6E = ____Boss_6D4B_8BD5_9009_62E9_547D_4EE4_8868[command]
    if _____914D_7F6E == nil then
        return
    end
    _____6FC0_6D3BBoss_6D4B_8BD5_914D_7F6E(player, _____914D_7F6E)
end
local function ____onBoss_6D4B_8BD5_6280_80FD_6570_5B57_547D_4EE4(player, command)
    if not _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local session = _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
    if session == nil or GetPlayerId(session["玩家"]) ~= GetPlayerId(player) then
        return
    end
    local _____5E8F_53F7 = __TS__Number(command)
    local list = session["配置"]["技能命令列表"]
    do
        local i = 0
        while i < #list do
            do
                local item = list[i + 1]
                if item["序号"] ~= _____5E8F_53F7 then
                    goto __continue20
                end
                local context = session["配置"]["创建或获取上下文"](player)
                if context == nil then
                    return
                end
                session["上下文"] = context
                session["Boss单位"] = globals.udg_Boss
                _____53D1_9001Boss_6D4B_8BD5_63D0_793A(
                    player,
                    session["配置"]["Boss名称"],
                    ((("正在测试：" .. tostring(item["序号"])) .. " ") .. item["名称"]) .. "。"
                )
                item["执行"](player, context)
                return
            end
            ::__continue20::
            i = i + 1
        end
    end
    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(
        player,
        session["配置"]["Boss名称"],
        (("没有技能序号 " .. command) .. "。可用序号：") .. _____751F_6210_547D_4EE4_8BF4_660E(session["配置"])
    )
end
local function ____onBoss_6D4B_8BD5_5217_8868_547D_4EE4(player)
    if not _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local text = ""
    do
        local i = 0
        while i < #____Boss_6D4B_8BD5_914D_7F6E_5217_8868 do
            text = ((text .. (i > 0 and "、" or "")) .. "Boss") .. ____Boss_6D4B_8BD5_914D_7F6E_5217_8868[i + 1]["命令单位名"]
            i = i + 1
        end
    end
    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, "Boss", ("可用场景：" .. text) .. "。")
end
local function ____onBoss_6D4B_8BD5_91CD_7F6E_547D_4EE4(player)
    if not _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local session = _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
    if session == nil or GetPlayerId(session["玩家"]) ~= GetPlayerId(player) then
        return
    end
    _____6FC0_6D3BBoss_6D4B_8BD5_914D_7F6E(player, session["配置"])
end
local function ____onBoss_6D4B_8BD5_6E05_7406_547D_4EE4(player)
    if not _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local session = _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
    if session == nil or GetPlayerId(session["玩家"]) ~= GetPlayerId(player) then
        return
    end
    local ____Boss_540D_79F0 = session["配置"]["Boss名称"]
    _____6E05_7406_5F53_524DBoss_6D4B_8BD5_4F1A_8BDD()
    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, ____Boss_540D_79F0, "测试场景已清理。")
end
local function ____onBoss_6D4B_8BD5AI_5F00_542F_547D_4EE4(player)
    if not _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local session = _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
    if session == nil or GetPlayerId(session["玩家"]) ~= GetPlayerId(player) then
        return
    end
    if ____Boss_81EA_52A8_65BD_6CD5_662F_5426_5F00_542F() then
        _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "自动AI已经处于开启状态。")
        return
    end
    local context = session["配置"]["创建或获取上下文"](player)
    if context ~= nil then
        session["上下文"] = context
        session["Boss单位"] = globals.udg_Boss
    end
    if session["Boss单位"] == nil or session["Boss单位"] == 0 then
        _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "自动AI开启失败：找不到当前测试Boss。")
        return
    end
    if not _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD(session["Boss单位"]) then
        _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(session["Boss单位"], "Boss测试")
    end
    _____8BBE_7F6EBoss_81EA_52A8_65BD_6CD5_5F00_542F(true)
    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "自动AI已开启，将按正式逻辑自动施法。")
end
local function ____onBoss_6D4B_8BD5AI_5173_95ED_547D_4EE4(player)
    if not _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local session = _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
    if session == nil or GetPlayerId(session["玩家"]) ~= GetPlayerId(player) then
        return
    end
    if not ____Boss_81EA_52A8_65BD_6CD5_662F_5426_5F00_542F() then
        _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "自动AI已经处于关闭状态。")
        return
    end
    _____8BBE_7F6EBoss_81EA_52A8_65BD_6CD5_5F00_542F(false)
    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "自动AI已关闭，仅数字命令会主动施法。")
end
local function _____786E_4FDD_6CE8_518CBoss_6D4B_8BD5_516C_5171_547D_4EE4()
    if _____5DF2_6CE8_518CBoss_6D4B_8BD5_516C_5171_547D_4EE4 then
        return
    end
    _____5DF2_6CE8_518CBoss_6D4B_8BD5_516C_5171_547D_4EE4 = true
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(____Boss_6D4B_8BD5_5217_8868_547D_4EE4, ____onBoss_6D4B_8BD5_5217_8868_547D_4EE4)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(____Boss_6D4B_8BD5_91CD_7F6E_547D_4EE4, ____onBoss_6D4B_8BD5_91CD_7F6E_547D_4EE4)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(____Boss_6D4B_8BD5_6E05_7406_547D_4EE4, ____onBoss_6D4B_8BD5_6E05_7406_547D_4EE4)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(____Boss_6D4B_8BD5AI_5F00_542F_547D_4EE4, ____onBoss_6D4B_8BD5AI_5F00_542F_547D_4EE4)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(____Boss_6D4B_8BD5AI_5173_95ED_547D_4EE4, ____onBoss_6D4B_8BD5AI_5173_95ED_547D_4EE4)
end
____exports["注册Boss测试命令组"] = function(_____914D_7F6E)
    _____786E_4FDD_6CE8_518CBoss_6D4B_8BD5_516C_5171_547D_4EE4()
    local _____9009_62E9_547D_4EE4 = "Boss" .. _____914D_7F6E["命令单位名"]
    if ____Boss_6D4B_8BD5_9009_62E9_547D_4EE4_8868[_____9009_62E9_547D_4EE4] == nil then
        ____Boss_6D4B_8BD5_914D_7F6E_5217_8868[#____Boss_6D4B_8BD5_914D_7F6E_5217_8868 + 1] = _____914D_7F6E
        _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____9009_62E9_547D_4EE4, ____onBoss_6D4B_8BD5_9009_62E9_547D_4EE4)
    end
    ____Boss_6D4B_8BD5_9009_62E9_547D_4EE4_8868[_____9009_62E9_547D_4EE4] = _____914D_7F6E
    local list = _____914D_7F6E["技能命令列表"]
    do
        local i = 0
        while i < #list do
            do
                local item = list[i + 1]
                if _____5DF2_6CE8_518C_6280_80FD_6570_5B57_547D_4EE4_8868[item["序号"]] == true then
                    goto __continue49
                end
                _____5DF2_6CE8_518C_6280_80FD_6570_5B57_547D_4EE4_8868[item["序号"]] = true
                _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(
                    tostring(item["序号"]),
                    ____onBoss_6D4B_8BD5_6280_80FD_6570_5B57_547D_4EE4
                )
            end
            ::__continue49::
            i = i + 1
        end
    end
end
____exports["清理当前Boss测试"] = function()
    _____6E05_7406_5F53_524DBoss_6D4B_8BD5_4F1A_8BDD()
end
return ____exports
