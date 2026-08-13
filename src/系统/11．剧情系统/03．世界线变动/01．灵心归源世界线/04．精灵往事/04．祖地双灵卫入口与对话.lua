--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____6CE8_518C_5267_60C5_8FDB_5EA6_53D8_66F4_76D1_542C = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["注册剧情进度变更监听"]
local ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.01．祖地双灵卫副本配置")
local _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["祖地双灵卫副本配置"]
local ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.02．祖地双灵卫副本状态")
local _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001["祖地双灵卫副本状态"]
local ____03_FF0E_7956_5730_53CC_7075_536B_8BD5_70BC = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.03．祖地双灵卫试炼")
local _____521B_5EFA_7956_5730_53CC_7075_536B_8BD5_70BC = ____03_FF0E_7956_5730_53CC_7075_536B_8BD5_70BC["创建祖地双灵卫试炼"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.11．剧情系统.00．公共.02．剧情NPC创建")
local _____521B_5EFA_5267_60C5NPC_5355_4F4D = ____require_result_0["创建剧情NPC单位"]
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.09．世界地图单位缓存")
local _____6D88_8D39_4E16_754C_5730_56FE_5355_4F4D_7F13_5B58 = ____require_result_1["消费世界地图单位缓存"]
local _____7956_5730_53CC_7075_536B_5B88_95E8_5355_4F4D_7F13_5B58_952E = ____require_result_1["祖地双灵卫守门单位缓存键"]
local ____require_result_2 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.10．世界地图单位总调度")
local _____6CE8_518C_4E16_754C_5730_56FE_5168_90E8_5355_4F4D_521B_5EFA_5B8C_6210_76D1_542C = ____require_result_2["注册世界地图全部单位创建完成监听"]
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local addSelectionListener = ____require_result_3.addSelectionListener
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
local _____521B_5EFA_77E9_5F62_8FDB_5165_76D1_542C = ____require_result_4["创建矩形进入监听"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_5.addDelayedCallback
local ____require_result_6 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_6["广播单位提示"]
local ____require_result_7 = require("lib.扩展函数.BJ函数.07．杂项")
local ModifyGateBJ = ____require_result_7.ModifyGateBJ
local ____require_result_8 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_8["是玩家英雄组单位"]
local getRegisteredPlayerHero = ____require_result_8.getRegisteredPlayerHero
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetTriggerUnit = jass.GetTriggerUnit
local PingMinimap = jass.PingMinimap
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local _____73A9_5BB6_6700_5C0FID = 0
local _____73A9_5BB6_6700_5927ID = 5
local _____5B88_95E8_89E6_53D1_534A_5F84 = 280
local _____5B88_95E8_8B66_544A_5DF2_64AD_653E_8868 = {}
local _____5165_53E3_6A21_5757_5DF2_521D_59CB_5316 = false
local _____5B88_95E8_8303_56F4_76D1_542C = nil
local _____672C_601D_96C5_5F85_5BF9_8BDD_73A9_5BB6 = nil
local _____672C_601D_96C5_5F85_5BF9_8BDD_82F1_96C4 = nil
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____662F_73A9_5BB6_69FD_4F4D(playerId)
    return playerId >= _____73A9_5BB6_6700_5C0FID and playerId <= _____73A9_5BB6_6700_5927ID
end
local function _____6253_5F00_914D_7F6E_95F8_95E8(variableName)
    local gate = jglobals[variableName]
    if not _____53E5_67C4_6709_6548(gate) then
        return false
    end
    ModifyGateBJ(jglobals.bj_GATEOPERATION_OPEN, gate)
    return true
end
local function _____786E_4FDD_521B_5EFA_5B88_95E8_5355_4F4D()
    if _____53E5_67C4_6709_6548(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门单位"]) then
        return _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门单位"]
    end
    local unit = _____6D88_8D39_4E16_754C_5730_56FE_5355_4F4D_7F13_5B58(_____7956_5730_53CC_7075_536B_5B88_95E8_5355_4F4D_7F13_5B58_952E)
    if not _____53E5_67C4_6709_6548(unit) then
        return nil
    end
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门单位"] = unit
    return unit
end
local function ____on_4E16_754C_5730_56FE_5355_4F4D_521B_5EFA_5B8C_6210()
    _____786E_4FDD_521B_5EFA_5B88_95E8_5355_4F4D()
end
local function _____786E_4FDD_521B_5EFA_672C_601D_96C5()
    if _____53E5_67C4_6709_6548(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["本思雅单位"]) then
        return _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["本思雅单位"]
    end
    local progress = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    if progress < _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["开放剧情进度最小值"] or progress > _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["开放剧情进度最大值"] then
        return nil
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["本思雅"]
    local unit = _____521B_5EFA_5267_60C5NPC_5355_4F4D({
        ["单位ID"] = cfg["单位ID"],
        X = cfg.X,
        Y = cfg.Y,
        ["朝向"] = cfg["朝向"],
        ["玩家ID"] = 15,
        ["初始化无敌"] = true,
        ["初始化固定站立"] = true
    })
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["本思雅单位"] = unit
    return unit
end
local function _____786E_4FDD_521B_5EFA_57C3_5FB7_91CC_5B89()
    if _____53E5_67C4_6709_6548(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"]) then
        return _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"]
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["埃德里安"]
    local unit = _____521B_5EFA_5267_60C5NPC_5355_4F4D({
        ["单位ID"] = cfg["单位ID"],
        X = cfg.X,
        Y = cfg.Y,
        ["朝向"] = cfg["朝向"],
        ["玩家ID"] = 15,
        ["初始化无敌"] = true,
        ["初始化固定站立"] = true
    })
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"] = unit
    return unit
end
local function _____6E05_7406_672C_601D_96C5_5F85_5BF9_8BDD_72B6_6001()
    _____672C_601D_96C5_5F85_5BF9_8BDD_73A9_5BB6 = nil
    _____672C_601D_96C5_5F85_5BF9_8BDD_82F1_96C4 = nil
end
local function ____on_62D2_7EDD_672C_601D_96C5_4EFB_52A1()
    _____6E05_7406_672C_601D_96C5_5F85_5BF9_8BDD_72B6_6001()
end
local function ____on_63A5_53D7_672C_601D_96C5_4EFB_52A1()
    if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["任务已接受"] then
        _____6E05_7406_672C_601D_96C5_5F85_5BF9_8BDD_72B6_6001()
        return
    end
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["任务已接受"] = true
    local adrian = _____786E_4FDD_521B_5EFA_57C3_5FB7_91CC_5B89()
    _____6E05_7406_672C_601D_96C5_5F85_5BF9_8BDD_72B6_6001()
    if _____53E5_67C4_6709_6548(adrian) then
        _____5E7F_64AD_5355_4F4D_63D0_793A(adrian, "带着长老的信物来见我。祖地只承认经得住考验的人。", 4800)
        PingMinimap(_____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["埃德里安"].X, _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["埃德里安"].Y, 5)
    end
end
local function _____6253_5F00_672C_601D_96C5_5DF2_63A5_53D7_5BF9_8BDD(player, hero)
    local ____UI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
    ____UI_51FD_6570.openNpcDialog(player, {lines = {{title = "本·思雅", text = "信物已经交给你们。守门者认得上面的灵印，埃德里安会在祖地入口等候。", duration = 4800}}, npcUnit = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["本思雅单位"], ["对话目标单位"] = hero, ["NPC配置朝向"] = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["本思雅"]["朝向"]})
end
local function _____6253_5F00_672C_601D_96C5_4EFB_52A1_5BF9_8BDD(player, hero)
    _____672C_601D_96C5_5F85_5BF9_8BDD_73A9_5BB6 = player
    _____672C_601D_96C5_5F85_5BF9_8BDD_82F1_96C4 = hero
    local ____UI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
    local opened = ____UI_51FD_6570.openNpcDialog(player, {
        lines = {{title = "本·思雅", text = "祖地深处的灵流近来反复震荡。那不是自然的回响，而是两道旧誓正在彼此撕扯。", duration = 4600}, {title = "本·思雅", text = "祖地从不轻易向外人开放。但若任由那股力量继续冲撞，沉睡的旧灵迟早会波及外界。", duration = 4800}},
        quest = {
            title = "精灵往事",
            text = "前往精灵祖地，通过守护官埃德里安的三项试炼，并查清祖地深处两道异常灵息的来源。",
            acceptText = "接受委托",
            rejectText = "稍后再谈",
            onAccept = ____on_63A5_53D7_672C_601D_96C5_4EFB_52A1,
            onReject = ____on_62D2_7EDD_672C_601D_96C5_4EFB_52A1
        },
        npcUnit = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["本思雅单位"],
        ["对话目标单位"] = hero,
        ["NPC配置朝向"] = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["本思雅"]["朝向"],
        restoreYellowQuestMarkerAfterDialog = true
    })
    if not opened then
        _____6E05_7406_672C_601D_96C5_5F85_5BF9_8BDD_72B6_6001()
    end
end
local function _____53D6_8BD5_70BC_8FDB_5EA6_6587_672C(completed)
    return completed and "已完成 √" or "未完成"
end
local function _____6253_5F00_57C3_5FB7_91CC_5B89_8BD5_70BC_5BF9_8BDD(player, hero)
    local trial = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]
    local text = (((((((("祖地认可的不是一时侥幸，而是足以承担后果的力量。\n\n" .. "持续输出：20 秒保持 2000 DPS（") .. _____53D6_8BD5_70BC_8FDB_5EA6_6587_672C(trial["持续伤害"]["已完成"])) .. "）\n") .. "爆发伤害：单次伤害超过 10000（") .. _____53D6_8BD5_70BC_8FDB_5EA6_6587_672C(trial["单次伤害"]["已完成"])) .. "）\n") .. "限时治疗：10 秒内将 1/5000 生命的目标治满（") .. _____53D6_8BD5_70BC_8FDB_5EA6_6587_672C(trial["治疗"]["已完成"])) .. "）"
    local ____UI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
    ____UI_51FD_6570.openNpcDialog(player, {lines = {{title = "埃德里安", text = text, duration = 9000}}, npcUnit = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"], ["对话目标单位"] = hero, ["NPC配置朝向"] = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["埃德里安"]["朝向"]})
end
local function ____on_7956_5730_53CC_7075_536BNPC_9009_62E9(player, playerId, unit, isSelected)
    if not isSelected or not _____662F_73A9_5BB6_69FD_4F4D(playerId) or not _____53E5_67C4_6709_6548(unit) then
        return
    end
    if unit == _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["本思雅单位"] then
        local progress = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
        if progress < _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["开放剧情进度最小值"] or progress > _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["开放剧情进度最大值"] then
            return
        end
        local hero = getRegisteredPlayerHero(player)
        if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["任务已接受"] then
            _____6253_5F00_672C_601D_96C5_5DF2_63A5_53D7_5BF9_8BDD(player, hero)
        else
            _____6253_5F00_672C_601D_96C5_4EFB_52A1_5BF9_8BDD(player, hero)
        end
        return
    end
    if unit == _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"] and _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["任务已接受"] then
        if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss战已完成"] then
            return
        end
        _____6253_5F00_57C3_5FB7_91CC_5B89_8BD5_70BC_5BF9_8BDD(
            player,
            getRegisteredPlayerHero(player)
        )
    end
end
local function ____on_5B88_95E8_653E_884C_5E7F_64AD_7ED3_675F()
    if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门已放行"] then
        return
    end
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门放行广播进行中"] = false
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门放行触发英雄"] = nil
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门已放行"] = true
    _____6253_5F00_914D_7F6E_95F8_95E8(_____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["守门闸门变量名"])
    _____786E_4FDD_521B_5EFA_57C3_5FB7_91CC_5B89()
    _____521B_5EFA_7956_5730_53CC_7075_536B_8BD5_70BC()
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"], "三座试炼靶已经准备好。每一项都必须由同一人独立完成。", 5200)
end
local function _____64AD_653E_5B88_95E8_653E_884C_7B2C_4E09_6BB5()
    if not _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门放行广播进行中"] then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门单位"], "……确实是长老的灵印。进去吧，埃德里安会决定你们是否有资格继续前行。", 5200)
    addDelayedCallback(5200, ____on_5B88_95E8_653E_884C_5E7F_64AD_7ED3_675F)
end
local function _____64AD_653E_5B88_95E8_653E_884C_7B2C_4E8C_6BB5()
    if not _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门放行广播进行中"] then
        return
    end
    local hero = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门放行触发英雄"]
    if hero == nil or hero == 0 then
        _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门放行广播进行中"] = false
        _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门放行触发英雄"] = nil
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(hero, "我们受本·思雅长老所托。这是她交给我们的信物。", 3800)
    addDelayedCallback(3800, _____64AD_653E_5B88_95E8_653E_884C_7B2C_4E09_6BB5)
end
local function _____5F00_59CB_5B88_95E8_653E_884C_5E7F_64AD(hero)
    if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门已放行"] or _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门放行广播进行中"] then
        return
    end
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门放行广播进行中"] = true
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门放行触发英雄"] = hero
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门单位"], "站住。祖地不接待外人。", 3000)
    addDelayedCallback(3000, _____64AD_653E_5B88_95E8_653E_884C_7B2C_4E8C_6BB5)
end
local function ____on_8FDB_5165_7956_5730_5B88_95E8_8303_56F4()
    local hero = GetTriggerUnit()
    if not _____53E5_67C4_6709_6548(hero) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(hero) then
        return
    end
    local player = GetOwningPlayer(hero)
    local playerId = _____53E5_67C4_6709_6548(player) and GetPlayerId(player) or -1
    if not _____662F_73A9_5BB6_69FD_4F4D(playerId) then
        return
    end
    if not _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["任务已接受"] then
        if _____5B88_95E8_8B66_544A_5DF2_64AD_653E_8868[playerId] == true then
            return
        end
        _____5B88_95E8_8B66_544A_5DF2_64AD_653E_8868[playerId] = true
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门单位"], _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["守门单位"]["靠近提示"], 4200)
        return
    end
    if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门已放行"] or _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["守门放行广播进行中"] then
        return
    end
    _____5F00_59CB_5B88_95E8_653E_884C_5E7F_64AD(hero)
end
local function _____6CE8_518C_5B88_95E8_8303_56F4()
    if _____5B88_95E8_8303_56F4_76D1_542C ~= nil then
        return
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["守门单位"]
    local rect = Rect(cfg.X - _____5B88_95E8_89E6_53D1_534A_5F84, cfg.Y - _____5B88_95E8_89E6_53D1_534A_5F84, cfg.X + _____5B88_95E8_89E6_53D1_534A_5F84, cfg.Y + _____5B88_95E8_89E6_53D1_534A_5F84)
    if not _____53E5_67C4_6709_6548(rect) then
        return
    end
    _____5B88_95E8_8303_56F4_76D1_542C = _____521B_5EFA_77E9_5F62_8FDB_5165_76D1_542C(rect, ____on_8FDB_5165_7956_5730_5B88_95E8_8303_56F4, nil)
    RemoveRect(rect)
end
local function ____on_7956_5730_53CC_7075_536B_5267_60C5_8FDB_5EA6_53D8_5316(newProgress, _oldProgress)
    if newProgress >= _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["开放剧情进度最小值"] and newProgress <= _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["开放剧情进度最大值"] then
        _____786E_4FDD_521B_5EFA_672C_601D_96C5()
    end
end
____exports["init祖地双灵卫入口与对话"] = function()
    if _____5165_53E3_6A21_5757_5DF2_521D_59CB_5316 then
        return
    end
    _____5165_53E3_6A21_5757_5DF2_521D_59CB_5316 = true
    _____6CE8_518C_4E16_754C_5730_56FE_5168_90E8_5355_4F4D_521B_5EFA_5B8C_6210_76D1_542C(____on_4E16_754C_5730_56FE_5355_4F4D_521B_5EFA_5B8C_6210)
    _____786E_4FDD_521B_5EFA_5B88_95E8_5355_4F4D()
    _____786E_4FDD_521B_5EFA_672C_601D_96C5()
    _____6CE8_518C_5B88_95E8_8303_56F4()
    _____6CE8_518C_5267_60C5_8FDB_5EA6_53D8_66F4_76D1_542C(____on_7956_5730_53CC_7075_536B_5267_60C5_8FDB_5EA6_53D8_5316)
    addSelectionListener(____on_7956_5730_53CC_7075_536BNPC_9009_62E9)
end
return ____exports
