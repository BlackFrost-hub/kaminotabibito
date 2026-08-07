--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.01．祖地双灵卫副本配置")
local _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["祖地双灵卫副本配置"]
local ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.02．祖地双灵卫副本状态")
local _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001["祖地双灵卫副本状态"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local addSelectionListener = ____require_result_0.addSelectionListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面")
local _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762 = ____require_result_2["打开首领奖励选择界面"]
local ____require_result_3 = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.index")
local _____7956_5730_53CC_7075_536B_5956_52B1_6C60ID = ____require_result_3["祖地双灵卫奖励池ID"]
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_4["广播单位提示"]
local GetPlayerController = jass.GetPlayerController
local GetPlayerSlotState = jass.GetPlayerSlotState
local GetPlayerState = jass.GetPlayerState
local Player = jass.Player
local SetPlayerState = jass.SetPlayerState
local _____73A9_5BB6_6700_5C0FID = 0
local _____73A9_5BB6_6700_5927ID = 5
local _____5956_52B1_63D0_4EA4_6A21_5757_5DF2_521D_59CB_5316 = false
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____662F_5728_5C40_7528_6237(player)
    return _____53E5_67C4_6709_6548(player) and GetPlayerController(player) == jass.MAP_CONTROL_USER and GetPlayerSlotState(player) == jass.PLAYER_SLOT_STATE_PLAYING
end
local function _____53D1_653E_7956_5730_53CC_7075_536B_5168_961F_5956_52B1()
    do
        local playerId = _____73A9_5BB6_6700_5C0FID
        while playerId <= _____73A9_5BB6_6700_5927ID do
            do
                local player = Player(playerId)
                if not _____662F_5728_5C40_7528_6237(player) then
                    goto __continue6
                end
                local current = GetPlayerState(player, jass.PLAYER_STATE_RESOURCE_LUMBER)
                SetPlayerState(player, jass.PLAYER_STATE_RESOURCE_LUMBER, current + 1)
                _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762(_____7956_5730_53CC_7075_536B_5956_52B1_6C60ID, player)
            end
            ::__continue6::
            playerId = playerId + 1
        end
    end
end
local function ____on_62D2_7EDD_7956_5730_53CC_7075_536B_5956_52B1_63D0_4EA4()
end
local function ____on_63A5_53D7_7956_5730_53CC_7075_536B_5956_52B1_63D0_4EA4()
    if not _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss战已完成"] or _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["奖励已提交"] then
        return
    end
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["奖励已提交"] = true
    _____53D1_653E_7956_5730_53CC_7075_536B_5168_961F_5956_52B1()
    if _____53E5_67C4_6709_6548(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"]) then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"], "祖地会记住你们替双灵结束的这场旧争。收下谢意，愿这份力量不再被誓言束缚。", 5600)
    end
end
local function _____6253_5F00_5DF2_63D0_4EA4_5BF9_8BDD(player)
    local ____UI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
    ____UI_51FD_6570.openNpcDialog(
        player,
        {
            lines = {{title = "埃德里安", text = "双灵的回响已经归于平静。祖地会记住你们做过的事。", duration = 4600}},
            npcUnit = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"],
            ["对话目标单位"] = getRegisteredPlayerHero(player),
            ["NPC配置朝向"] = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["埃德里安"]["朝向"]
        }
    )
end
local function _____6253_5F00_5956_52B1_63D0_4EA4_5BF9_8BDD(player)
    local ____UI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
    ____UI_51FD_6570.openNpcDialog(
        player,
        {
            lines = {{title = "埃德里安", text = "你们身上还带着赤誓与苍影的灵息。看来守在深处的，果然是他们。", duration = 4600}, {title = "埃德里安", text = "他们曾共同守过祖地，后来却把彼此都当成背誓者。你们终结的，是一场拖得太久的争执。", duration = 5200}},
            quest = {
                title = "精灵往事·归还信物",
                text = "向埃德里安提交祖地调查结果。完成后，所有在局玩家获得双灵卫首领战利品选择与 1 能量碎片。",
                acceptText = "提交任务",
                rejectText = "稍后再谈",
                onAccept = ____on_63A5_53D7_7956_5730_53CC_7075_536B_5956_52B1_63D0_4EA4,
                onReject = ____on_62D2_7EDD_7956_5730_53CC_7075_536B_5956_52B1_63D0_4EA4
            },
            npcUnit = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"],
            ["对话目标单位"] = getRegisteredPlayerHero(player),
            ["NPC配置朝向"] = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["埃德里安"]["朝向"]
        }
    )
end
local function ____on_7956_5730_53CC_7075_536B_5956_52B1NPC_9009_62E9(player, playerId, unit, isSelected)
    if not isSelected or playerId < _____73A9_5BB6_6700_5C0FID or playerId > _____73A9_5BB6_6700_5927ID then
        return
    end
    if unit ~= _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"] or not _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss战已完成"] then
        return
    end
    if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["奖励已提交"] then
        _____6253_5F00_5DF2_63D0_4EA4_5BF9_8BDD(player)
    else
        _____6253_5F00_5956_52B1_63D0_4EA4_5BF9_8BDD(player)
    end
end
____exports["init祖地双灵卫奖励提交"] = function()
    if _____5956_52B1_63D0_4EA4_6A21_5757_5DF2_521D_59CB_5316 then
        return
    end
    _____5956_52B1_63D0_4EA4_6A21_5757_5DF2_521D_59CB_5316 = true
    addSelectionListener(____on_7956_5730_53CC_7075_536B_5956_52B1NPC_9009_62E9)
end
return ____exports
