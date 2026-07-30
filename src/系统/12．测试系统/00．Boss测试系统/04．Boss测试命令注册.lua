local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
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
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local ____require_result_4 = require("系统.09．表现系统.14．镜头高度控制.index")
local _____62AC_9AD8Boss_6D4B_8BD5_955C_5934 = ____require_result_4["抬高Boss测试镜头"]
local jass = require("jass.common")
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local GetLocalPlayer = jass.GetLocalPlayer
local GetPlayerId = jass.GetPlayerId
local GetPlayerName = jass.GetPlayerName
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_5 = require("系统.12．测试系统.00．Boss测试系统.02．Boss测试单位")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_5["Boss测试单位存活"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_5["获取Boss测试玩家基准英雄"]
local _____521B_5EFABoss_6D4B_8BD5_4E34_65F6_6B65_5175 = ____require_result_5["创建Boss测试临时步兵"]
local _____51FB_6740_6700_8FD1Boss_6D4B_8BD5_4E34_65F6_6B65_5175 = ____require_result_5["击杀最近Boss测试临时步兵"]
local _____6E05_7406Boss_6D4B_8BD5_4E34_65F6_6B65_5175 = ____require_result_5["清理Boss测试临时步兵"]
local ____Boss_6D4B_8BD5_9009_62E9_547D_4EE4_8868 = {}
local ____Boss_6D4B_8BD5_914D_7F6E_5217_8868 = {}
local _____5DF2_6CE8_518C_6280_80FD_547D_4EE4_8868 = {}
local ____Boss_6D4B_8BD5_73A9_5BB6ID = 0
local ____Boss_6D4B_8BD5_73A9_5BB6_540D_79F0 = "WorldEdit"
local ____Boss_6D4B_8BD5_5907_7528_73A9_5BB6_540D_79F0 = "九条艾莉莎"
local ____Boss_6D4B_8BD5_5217_8868_547D_4EE4 = "Boss列表"
local ____Boss_6D4B_8BD5_91CD_7F6E_547D_4EE4 = "Boss重置"
local ____Boss_6D4B_8BD5_6E05_7406_547D_4EE4 = "Boss清理"
local ____Boss_6D4B_8BD5AI_5F00_542F_547D_4EE4 = "BossAI开启"
local ____Boss_6D4B_8BD5AI_5173_95ED_547D_4EE4 = "BossAI关闭"
local ____Boss_6D4B_8BD5_89E6_53D1_53D7_51FB_547D_4EE4 = "55"
local ____Boss_6D4B_8BD5_521B_5EFA_4E34_65F6_6B65_5175_547D_4EE4 = "77"
local ____Boss_6D4B_8BD5_51FB_6740_4E34_65F6_6B65_5175_547D_4EE4 = "77-kill"
local ____Boss_6D4B_8BD5_89E6_53D1_53D7_51FB_4F24_5BB3 = 1000
local ____Boss_6D4B_8BD5_89E6_53D1_53D7_51FB_641C_7D22_534A_5F84 = 1000
local ____Boss_6D4B_8BD5_89E6_53D1_53D7_51FB_65E5_5FD7_6A21_5757 = "Boss测试55"
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
local function _____83B7_53D6Boss_6D4B_8BD5_6280_80FD_547D_4EE4_6587_672C(item)
    if item["命令"] ~= nil and item["命令"] ~= "" then
        return item["命令"]
    end
    return tostring(item["序号"])
end
local function _____751F_6210_547D_4EE4_8BF4_660E(_____914D_7F6E)
    local text = ""
    local list = _____914D_7F6E["技能命令列表"]
    do
        local i = 0
        while i < #list do
            text = ((text .. " ") .. _____83B7_53D6Boss_6D4B_8BD5_6280_80FD_547D_4EE4_6587_672C(list[i + 1])) .. list[i + 1]["名称"]
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
    return playerName == ____Boss_6D4B_8BD5_73A9_5BB6_540D_79F0 or playerName == ____Boss_6D4B_8BD5_73A9_5BB6_540D_79F0 .. ":" or playerName == ____Boss_6D4B_8BD5_5907_7528_73A9_5BB6_540D_79F0 or playerName == ____Boss_6D4B_8BD5_5907_7528_73A9_5BB6_540D_79F0 .. ":"
end
local function _____4ECEBoss_6D4B_8BD5_4E0A_4E0B_6587_53D6Boss_5355_4F4D(context)
    if context == nil then
        return nil
    end
    local runtime = context["运行时"]
    local ____array_21 = __TS__SparseArrayNew(
        context["Boss单位"],
        context.Boss,
        context["安兹单位"],
        context["赤誓灵卫单位"],
        context.red
    )
    local ____opt_result_8
    if runtime ~= nil then
        ____opt_result_8 = runtime["Boss单位"]
    end
    __TS__SparseArrayPush(____array_21, ____opt_result_8)
    local ____opt_result_11
    if runtime ~= nil then
        ____opt_result_11 = runtime.Boss
    end
    __TS__SparseArrayPush(____array_21, ____opt_result_11)
    local ____opt_result_14
    if runtime ~= nil then
        ____opt_result_14 = runtime["安兹单位"]
    end
    __TS__SparseArrayPush(____array_21, ____opt_result_14)
    local ____opt_result_17
    if runtime ~= nil then
        ____opt_result_17 = runtime["赤誓灵卫单位"]
    end
    __TS__SparseArrayPush(____array_21, ____opt_result_17)
    local ____opt_result_20
    if runtime ~= nil then
        ____opt_result_20 = runtime.red
    end
    __TS__SparseArrayPush(____array_21, ____opt_result_20)
    local candidates = {__TS__SparseArraySpread(____array_21)}
    do
        local i = 0
        while i < #candidates do
            if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(candidates[i + 1]) then
                return candidates[i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
local function _____89E3_6790_5F53_524DBoss_6D4B_8BD5_5355_4F4D(context, _____4F1A_8BDDBoss)
    local contextBoss = _____4ECEBoss_6D4B_8BD5_4E0A_4E0B_6587_53D6Boss_5355_4F4D(context)
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(contextBoss) then
        return contextBoss
    end
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(globals.udg_Boss) then
        return globals.udg_Boss
    end
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____4F1A_8BDDBoss) then
        return _____4F1A_8BDDBoss
    end
    return nil
end
local function _____53D6_8BCA_65AD_53E5_67C4ID(unit)
    return unit ~= nil and unit ~= 0 and (GetHandleId(unit) or 0) or 0
end
local function _____53D6_8BCA_65AD_5355_4F4D_7C7B_578BID(unit)
    return unit ~= nil and unit ~= 0 and (GetUnitTypeId(unit) or 0) or 0
end
local function _____8BB0_5F55Boss_6D4B_8BD555_89E3_6790_65E5_5FD7(____Boss_540D_79F0, contextBoss, globalBoss, sessionBoss, resolvedBoss)
    debugLogForce(
        ____Boss_6D4B_8BD5_89E6_53D1_53D7_51FB_65E5_5FD7_6A21_5757,
        "Boss=",
        ____Boss_540D_79F0,
        "context(id/type/alive)=",
        _____53D6_8BCA_65AD_53E5_67C4ID(contextBoss),
        _____53D6_8BCA_65AD_5355_4F4D_7C7B_578BID(contextBoss),
        ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(contextBoss),
        "global(id/type/alive)=",
        _____53D6_8BCA_65AD_53E5_67C4ID(globalBoss),
        _____53D6_8BCA_65AD_5355_4F4D_7C7B_578BID(globalBoss),
        ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(globalBoss),
        "session(id/type/alive)=",
        _____53D6_8BCA_65AD_53E5_67C4ID(sessionBoss),
        _____53D6_8BCA_65AD_5355_4F4D_7C7B_578BID(sessionBoss),
        ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(sessionBoss),
        "resolved(id/type/alive)=",
        _____53D6_8BCA_65AD_53E5_67C4ID(resolvedBoss),
        _____53D6_8BCA_65AD_5355_4F4D_7C7B_578BID(resolvedBoss),
        ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(resolvedBoss)
    )
end
local function _____6E05_7406_5F53_524DBoss_6D4B_8BD5_4F1A_8BDD()
    local session = _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
    _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD = nil
    _____6E05_7406Boss_6D4B_8BD5_4E34_65F6_6B65_5175()
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
    _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD = {
        ["玩家"] = player,
        ["配置"] = _____914D_7F6E,
        ["上下文"] = context,
        ["Boss单位"] = _____89E3_6790_5F53_524DBoss_6D4B_8BD5_5355_4F4D(context, globals.udg_Boss)
    }
    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(
        player,
        _____914D_7F6E["Boss名称"],
        ("已创建玩家1 Boss、1个固定步兵靶与1个固定山丘之王靶，自动AI已关闭。输入技能序号：" .. _____751F_6210_547D_4EE4_8BF4_660E(_____914D_7F6E)) .. " 输入55可让测试单位对Boss造成伤害；输入77可在玩家英雄位置创建临时步兵，输入77-kill可击杀最近创建的临时步兵；输入BossAI开启可验证正式AI。"
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
    if player == GetLocalPlayer() then
        _____62AC_9AD8Boss_6D4B_8BD5_955C_5934()
    end
    _____6FC0_6D3BBoss_6D4B_8BD5_914D_7F6E(player, _____914D_7F6E)
end
local function ____onBoss_6D4B_8BD5_6280_80FD_547D_4EE4(player, command)
    if not _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local session = _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
    if session == nil or GetPlayerId(session["玩家"]) ~= GetPlayerId(player) then
        return
    end
    local list = session["配置"]["技能命令列表"]
    do
        local i = 0
        while i < #list do
            do
                local item = list[i + 1]
                if _____83B7_53D6Boss_6D4B_8BD5_6280_80FD_547D_4EE4_6587_672C(item) ~= command then
                    goto __continue35
                end
                local context = session["上下文"]
                if context == nil then
                    return
                end
                session["Boss单位"] = _____89E3_6790_5F53_524DBoss_6D4B_8BD5_5355_4F4D(context, session["Boss单位"])
                _____53D1_9001Boss_6D4B_8BD5_63D0_793A(
                    player,
                    session["配置"]["Boss名称"],
                    ((("正在测试：" .. _____83B7_53D6Boss_6D4B_8BD5_6280_80FD_547D_4EE4_6587_672C(item)) .. " ") .. item["名称"]) .. "。"
                )
                item["执行"](player, context)
                return
            end
            ::__continue35::
            i = i + 1
        end
    end
    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(
        player,
        session["配置"]["Boss名称"],
        (("没有测试命令 " .. command) .. "。可用命令：") .. _____751F_6210_547D_4EE4_8BF4_660E(session["配置"])
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
    local context = session["上下文"]
    session["Boss单位"] = _____89E3_6790_5F53_524DBoss_6D4B_8BD5_5355_4F4D(context, session["Boss单位"])
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
local function _____67E5_627EBoss_9644_8FD1_654C_4EBA(boss)
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    local bossOwner = GetOwningPlayer(boss)
    local group = CreateGroup()
    local nearest = nil
    local nearestDistanceSquared = ____Boss_6D4B_8BD5_89E6_53D1_53D7_51FB_641C_7D22_534A_5F84 * ____Boss_6D4B_8BD5_89E6_53D1_53D7_51FB_641C_7D22_534A_5F84 + 1
    GroupEnumUnitsInRange(
        group,
        bossX,
        bossY,
        ____Boss_6D4B_8BD5_89E6_53D1_53D7_51FB_641C_7D22_534A_5F84,
        nil
    )
    while true do
        local unit = FirstOfGroup(group)
        if unit == nil or unit == 0 then
            break
        end
        GroupRemoveUnit(group, unit)
        if unit ~= boss and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(unit) and IsUnitEnemy(unit, bossOwner) == true then
            local dx = GetUnitX(unit) - bossX
            local dy = GetUnitY(unit) - bossY
            local distanceSquared = dx * dx + dy * dy
            if distanceSquared < nearestDistanceSquared then
                nearest = unit
                nearestDistanceSquared = distanceSquared
            end
        end
    end
    DestroyGroup(group)
    return nearest
end
local function ____onBoss_6D4B_8BD5_89E6_53D1_53D7_51FB_547D_4EE4(player)
    if not _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local session = _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
    if session == nil or GetPlayerId(session["玩家"]) ~= GetPlayerId(player) then
        return
    end
    local context = session["上下文"]
    local sessionBossBeforeResolve = session["Boss单位"]
    local globalBoss = globals.udg_Boss
    local contextBoss = nil
    if context ~= nil then
        contextBoss = _____4ECEBoss_6D4B_8BD5_4E0A_4E0B_6587_53D6Boss_5355_4F4D(context)
    end
    session["Boss单位"] = _____89E3_6790_5F53_524DBoss_6D4B_8BD5_5355_4F4D(context, session["Boss单位"])
    local boss = session["Boss单位"]
    _____8BB0_5F55Boss_6D4B_8BD555_89E3_6790_65E5_5FD7(
        session["配置"]["Boss名称"],
        contextBoss,
        globalBoss,
        sessionBossBeforeResolve,
        boss
    )
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "触发受击失败：找不到当前测试Boss。")
        return
    end
    local source = _____67E5_627EBoss_9644_8FD1_654C_4EBA(boss)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(source) then
        _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "触发受击失败：Boss周围1000码内没有存活敌人。")
        return
    end
    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(
        player,
        session["配置"]["Boss名称"],
        ("正在测试受击/反击：" .. GetUnitName(source)) .. " 对Boss造成一次普通攻击伤害。"
    )
    if not UnitDamageTarget(
        source,
        boss,
        ____Boss_6D4B_8BD5_89E6_53D1_53D7_51FB_4F24_5BB3,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    ) then
        _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "触发受击失败：已找到敌人，但原生伤害调用失败。")
    end
end
local function ____onBoss_6D4B_8BD5_521B_5EFA_4E34_65F6_6B65_5175_547D_4EE4(player)
    if not _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local session = _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
    if session == nil or GetPlayerId(session["玩家"]) ~= GetPlayerId(player) then
        return
    end
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) then
        _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "创建临时步兵失败：找不到玩家英雄。")
        return
    end
    local infantry = _____521B_5EFABoss_6D4B_8BD5_4E34_65F6_6B65_5175(
        GetUnitX(hero),
        GetUnitY(hero)
    )
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(infantry) then
        _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "创建临时步兵失败：单位创建失败。")
        return
    end
    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "正在测试安全圈：已在玩家英雄位置创建中立敌对步兵。")
end
local function ____onBoss_6D4B_8BD5_51FB_6740_4E34_65F6_6B65_5175_547D_4EE4(player)
    if not _____662F_5141_8BB8Boss_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local session = _____5F53_524DBoss_6D4B_8BD5_4F1A_8BDD
    if session == nil or GetPlayerId(session["玩家"]) ~= GetPlayerId(player) then
        return
    end
    local infantry = _____51FB_6740_6700_8FD1Boss_6D4B_8BD5_4E34_65F6_6B65_5175()
    if infantry == nil or infantry == 0 then
        _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "没有可击杀的77临时步兵。")
        return
    end
    _____53D1_9001Boss_6D4B_8BD5_63D0_793A(player, session["配置"]["Boss名称"], "已击杀最近创建的77临时步兵。")
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
    _____5DF2_6CE8_518C_6280_80FD_547D_4EE4_8868[____Boss_6D4B_8BD5_89E6_53D1_53D7_51FB_547D_4EE4] = true
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(____Boss_6D4B_8BD5_89E6_53D1_53D7_51FB_547D_4EE4, ____onBoss_6D4B_8BD5_89E6_53D1_53D7_51FB_547D_4EE4)
    _____5DF2_6CE8_518C_6280_80FD_547D_4EE4_8868[____Boss_6D4B_8BD5_521B_5EFA_4E34_65F6_6B65_5175_547D_4EE4] = true
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(____Boss_6D4B_8BD5_521B_5EFA_4E34_65F6_6B65_5175_547D_4EE4, ____onBoss_6D4B_8BD5_521B_5EFA_4E34_65F6_6B65_5175_547D_4EE4)
    _____5DF2_6CE8_518C_6280_80FD_547D_4EE4_8868[____Boss_6D4B_8BD5_51FB_6740_4E34_65F6_6B65_5175_547D_4EE4] = true
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(____Boss_6D4B_8BD5_51FB_6740_4E34_65F6_6B65_5175_547D_4EE4, ____onBoss_6D4B_8BD5_51FB_6740_4E34_65F6_6B65_5175_547D_4EE4)
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
                local _____547D_4EE4 = _____83B7_53D6Boss_6D4B_8BD5_6280_80FD_547D_4EE4_6587_672C(item)
                if _____5DF2_6CE8_518C_6280_80FD_547D_4EE4_8868[_____547D_4EE4] == true then
                    goto __continue84
                end
                _____5DF2_6CE8_518C_6280_80FD_547D_4EE4_8868[_____547D_4EE4] = true
                _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____547D_4EE4, ____onBoss_6D4B_8BD5_6280_80FD_547D_4EE4)
            end
            ::__continue84::
            i = i + 1
        end
    end
end
____exports["清理当前Boss测试"] = function()
    _____6E05_7406_5F53_524DBoss_6D4B_8BD5_4F1A_8BDD()
end
return ____exports
