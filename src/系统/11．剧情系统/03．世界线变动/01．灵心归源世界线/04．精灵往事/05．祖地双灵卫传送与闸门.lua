--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.01．祖地双灵卫副本配置")
local _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["祖地双灵卫副本配置"]
local ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.02．祖地双灵卫副本状态")
local _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001["祖地双灵卫副本状态"]
local ____03_FF0E_7956_5730_53CC_7075_536B_8BD5_70BC = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.03．祖地双灵卫试炼")
local ____register_7956_5730_53CC_7075_536B_8BD5_70BC_5168_90E8_5B8C_6210Listener = ____03_FF0E_7956_5730_53CC_7075_536B_8BD5_70BC["register祖地双灵卫试炼全部完成Listener"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
local registerEnterRegionTrigger = ____require_result_0.registerEnterRegionTrigger
local ____require_result_1 = require("系统.00．核心系统.07．联机安全工具")
local safeTriggerAddAction = ____require_result_1.safeTriggerAddAction
local safeDestroyTrigger = ____require_result_1.safeDestroyTrigger
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_2["是玩家英雄组单位"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_3["创建点特效"]
local ____require_result_4 = require("lib.扩展函数.BJ函数.07．杂项")
local ModifyGateBJ = ____require_result_4.ModifyGateBJ
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_5["广播单位提示"]
local CreateRegion = jass.CreateRegion
local CreateTrigger = jass.CreateTrigger
local GetTriggerUnit = jass.GetTriggerUnit
local IssueImmediateOrder = jass.IssueImmediateOrder
local Rect = jass.Rect
local RegionAddRect = jass.RegionAddRect
local RemoveRect = jass.RemoveRect
local RemoveRegion = jass.RemoveRegion
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local _____4F20_9001_6A21_5757_5DF2_521D_59CB_5316 = false
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____6253_5F00_7956_5730_5185_95E8()
    local names = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["入口闸门变量名列表"]
    do
        local i = 0
        while i < #names do
            local gate = jglobals[names[i + 1]]
            if _____53E5_67C4_6709_6548(gate) then
                ModifyGateBJ(jglobals.bj_GATEOPERATION_OPEN, gate)
            end
            i = i + 1
        end
    end
end
local function ____on_8FDB_5165_7956_5730_53CC_7075_536B_4F20_9001_70B9()
    local unit = GetTriggerUnit()
    if not _____53E5_67C4_6709_6548(unit) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) then
        return
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["永久传送点"]
    SetUnitPosition(unit, cfg["目标X"], cfg["目标Y"])
    SetUnitFacing(unit, cfg["目标朝向"])
    IssueImmediateOrder(unit, "stop")
end
____exports["创建祖地双灵卫永久传送点"] = function()
    if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["传送点已创建"] then
        return true
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["永久传送点"]
    local region = CreateRegion()
    local rect = Rect(cfg.X - cfg["半径"], cfg.Y - cfg["半径"], cfg.X + cfg["半径"], cfg.Y + cfg["半径"])
    local trigger = CreateTrigger()
    if not _____53E5_67C4_6709_6548(region) or not _____53E5_67C4_6709_6548(rect) or not _____53E5_67C4_6709_6548(trigger) then
        if _____53E5_67C4_6709_6548(trigger) then
            safeDestroyTrigger(trigger)
        end
        if _____53E5_67C4_6709_6548(region) then
            RemoveRegion(region)
        end
        if _____53E5_67C4_6709_6548(rect) then
            RemoveRect(rect)
        end
        return false
    end
    RegionAddRect(region, rect)
    RemoveRect(rect)
    if safeTriggerAddAction(trigger, ____on_8FDB_5165_7956_5730_53CC_7075_536B_4F20_9001_70B9) == nil then
        safeDestroyTrigger(trigger)
        RemoveRegion(region)
        return false
    end
    registerEnterRegionTrigger(trigger, region, nil)
    local effect = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["特效"],
        X = cfg.X,
        Y = cfg.Y,
        ["Z轴角度"] = cfg["朝向"],
        ["缩放"] = 0.75
    })
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["传送点触发器"] = trigger
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["传送点区域"] = region
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["传送点特效"] = effect
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["传送点已创建"] = true
    _____6253_5F00_7956_5730_5185_95E8()
    if _____53E5_67C4_6709_6548(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"]) then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"], "三项考验都已完成。祖地内门已经开启，传送灵阵会送你们前往双灵沉眠之处。", 5600)
    end
    return true
end
local function ____on_7956_5730_53CC_7075_536B_8BD5_70BC_5168_90E8_5B8C_6210()
    ____exports["创建祖地双灵卫永久传送点"]()
end
____exports["init祖地双灵卫传送与闸门"] = function()
    if _____4F20_9001_6A21_5757_5DF2_521D_59CB_5316 then
        return
    end
    _____4F20_9001_6A21_5757_5DF2_521D_59CB_5316 = true
    ____register_7956_5730_53CC_7075_536B_8BD5_70BC_5168_90E8_5B8C_6210Listener(____on_7956_5730_53CC_7075_536B_8BD5_70BC_5168_90E8_5B8C_6210)
end
return ____exports
