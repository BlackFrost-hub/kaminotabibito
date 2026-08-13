--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.01．祖地双灵卫副本配置")
local _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["祖地双灵卫副本配置"]
local ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.02．祖地双灵卫副本状态")
local _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001["祖地双灵卫副本状态"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____require_result_0["创建并冻结剧情Boss预置"]
local _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90 = ____require_result_0["剧情Boss预置暂停来源"]
local ____require_result_1 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____require_result_1["启动剧情Boss战"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.13．战斗结束事件")
local ____register_7956_5730_53CC_7075_536B_6218_6597_7ED3_675FListener = ____require_result_2["register祖地双灵卫战斗结束Listener"]
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
local _____521B_5EFA_77E9_5F62_8FDB_5165_76D1_542C = ____require_result_3["创建矩形进入监听"]
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_4["是玩家英雄组单位"]
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_5["广播单位提示"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local _____521B_5EFA_5355_4F4D_811A_4E0B_70B9_7279_6548 = ____require_result_6["创建单位脚下点特效"]
local ____require_result_7 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_7.addDelayedCallback
local addPeriodicCallback = ____require_result_7.addPeriodicCallback
local removePeriodicCallback = ____require_result_7.removePeriodicCallback
local getServerTime = ____require_result_7.getServerTime
local GetTriggerUnit = jass.GetTriggerUnit
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local ____Boss_9884_8B66_5237_65B0_6BEB_79D2 = 100
local ____Boss_573A_666F_6A21_5757_5DF2_521D_59CB_5316 = false
local ____Boss_5165_53E3_76D1_542C = nil
local ____Boss_9884_8B66_5468_671FID = 0
local ____Boss_9884_8B66_7ED3_675F_6BEB_79D2 = 0
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____8BFB_53D6Boss_5355_4F4D(index)
    return _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss单位列表"][index + 1]
end
local function ____onBoss_9884_8B66Tick()
    if ____Boss_9884_8B66_7ED3_675F_6BEB_79D2 <= 0 or getServerTime() >= ____Boss_9884_8B66_7ED3_675F_6BEB_79D2 then
        if ____Boss_9884_8B66_5468_671FID ~= 0 then
            removePeriodicCallback(____Boss_9884_8B66_5468_671FID)
        end
        ____Boss_9884_8B66_5468_671FID = 0
        ____Boss_9884_8B66_7ED3_675F_6BEB_79D2 = 0
        return
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["Boss预警点"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["特效"],
        X = cfg.X,
        Y = cfg.Y,
        ["缩放"] = cfg["缩放"],
        ["持续秒"] = 0.45
    })
end
local function _____521B_5EFA_53CC_7075_536B_9884_7F6E()
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss单位列表"] = {}
    do
        local i = 0
        while i < #_____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["Boss列表"] do
            local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["Boss列表"][i + 1]
            local boss = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E({
                ["Boss键"] = cfg["Boss键"],
                ["Boss名"] = cfg["Boss名"],
                ["允许单位类型"] = {cfg["单位ID"]},
                X = cfg.X,
                Y = cfg.Y,
                ["朝向"] = cfg["朝向"],
                ["预创建后暂停"] = true,
                ["预创建后无敌"] = true
            })
            if not _____53E5_67C4_6709_6548(boss) then
                return false
            end
            local ____7956_5730_53CC_7075_536B_526F_672C_72B6_6001_Boss_5355_4F4D_5217_8868_8 = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss单位列表"]
            ____7956_5730_53CC_7075_536B_526F_672C_72B6_6001_Boss_5355_4F4D_5217_8868_8[#____7956_5730_53CC_7075_536B_526F_672C_72B6_6001_Boss_5355_4F4D_5217_8868_8 + 1] = boss
            _____521B_5EFA_5355_4F4D_811A_4E0B_70B9_7279_6548(boss, {["模型路径"] = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["Boss脚下特效"]["路径"], ["缩放"] = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["Boss脚下特效"]["缩放"], ["持续秒"] = 3.2})
            i = i + 1
        end
    end
    return #_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss单位列表"] == #_____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["Boss列表"]
end
local function _____542F_52A8_7956_5730_53CC_7075_536BBoss_6218()
    if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss战已启动"] then
        return
    end
    local red = _____8BFB_53D6Boss_5355_4F4D(0)
    local azure = _____8BFB_53D6Boss_5355_4F4D(1)
    if not _____53E5_67C4_6709_6548(red) or not _____53E5_67C4_6709_6548(azure) then
        return
    end
    local triggerHero = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss场景触发英雄"]
    local redStarted = _____542F_52A8_5267_60C5Boss_6218(red, {["触发单位"] = triggerHero, ["暂停来源"] = _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90})
    local azureStarted = _____542F_52A8_5267_60C5Boss_6218(azure, {["触发单位"] = triggerHero, ["暂停来源"] = _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90})
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss战已启动"] = redStarted and azureStarted
end
local function _____64AD_653EBoss_5F00_6218_6700_540E_4E00_6BB5()
    local red = _____8BFB_53D6Boss_5355_4F4D(0)
    if _____53E5_67C4_6709_6548(red) then
        _____5E7F_64AD_5355_4F4D_63D0_793A(red, "刀剑之后，再谈你们有没有资格知道。", 3600)
    end
    addDelayedCallback(5000, _____542F_52A8_7956_5730_53CC_7075_536BBoss_6218)
end
local function _____64AD_653EBoss_5F00_6218_7B2C_4E09_6BB5()
    local hero = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss场景触发英雄"]
    if _____53E5_67C4_6709_6548(hero) then
        _____5E7F_64AD_5355_4F4D_63D0_793A(hero, "我们不是来夺取祖地。先停手，告诉我这里发生了什么。", 4600)
    end
    addDelayedCallback(6000, _____64AD_653EBoss_5F00_6218_6700_540E_4E00_6BB5)
end
local function _____64AD_653EBoss_5F00_6218_7B2C_4E8C_6BB5()
    local azure = _____8BFB_53D6Boss_5355_4F4D(1)
    if _____53E5_67C4_6709_6548(azure) then
        _____5E7F_64AD_5355_4F4D_63D0_793A(azure, "来者身上没有旧印。按祖地之律，止步于此。", 4200)
    end
    addDelayedCallback(5600, _____64AD_653EBoss_5F00_6218_7B2C_4E09_6BB5)
end
local function _____5B8C_6210Boss_9884_8B66_5E76_521B_5EFA()
    if ____Boss_9884_8B66_5468_671FID ~= 0 then
        removePeriodicCallback(____Boss_9884_8B66_5468_671FID)
        ____Boss_9884_8B66_5468_671FID = 0
    end
    ____Boss_9884_8B66_7ED3_675F_6BEB_79D2 = 0
    if not _____521B_5EFA_53CC_7075_536B_9884_7F6E() then
        _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss场景已触发"] = false
        return
    end
    local red = _____8BFB_53D6Boss_5355_4F4D(0)
    if _____53E5_67C4_6709_6548(red) then
        _____5E7F_64AD_5355_4F4D_63D0_793A(red, "长老把祖地的门交给外人，连最后的誓约也要一并抛下吗？", 4800)
    end
    addDelayedCallback(6200, _____64AD_653EBoss_5F00_6218_7B2C_4E8C_6BB5)
end
local function _____5F00_59CBBoss_9884_8B66()
    ____Boss_9884_8B66_7ED3_675F_6BEB_79D2 = getServerTime() + _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["Boss前导毫秒"]
    ____onBoss_9884_8B66Tick()
    ____Boss_9884_8B66_5468_671FID = addPeriodicCallback(____Boss_9884_8B66_5237_65B0_6BEB_79D2, ____onBoss_9884_8B66Tick)
    addDelayedCallback(_____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["Boss前导毫秒"], _____5B8C_6210Boss_9884_8B66_5E76_521B_5EFA)
end
local function ____on_8FDB_5165_7956_5730_53CC_7075_536BBoss_5165_53E3()
    if not _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["传送点已创建"] or _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss场景已触发"] then
        return
    end
    local hero = GetTriggerUnit()
    if not _____53E5_67C4_6709_6548(hero) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(hero) then
        return
    end
    if ____Boss_5165_53E3_76D1_542C ~= nil then
        ____Boss_5165_53E3_76D1_542C["取消"]()
    end
    ____Boss_5165_53E3_76D1_542C = nil
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss场景已触发"] = true
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss场景触发英雄"] = hero
    _____5E7F_64AD_5355_4F4D_63D0_793A(hero, "怎么什么都没有？这里明明残留着很强的气息。", 4200)
    addDelayedCallback(5600, _____5F00_59CBBoss_9884_8B66)
end
local function _____6CE8_518CBoss_5165_53E3()
    if ____Boss_5165_53E3_76D1_542C ~= nil then
        return
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["Boss入口"]
    local rect = Rect(cfg.X - cfg["半径"], cfg.Y - cfg["半径"], cfg.X + cfg["半径"], cfg.Y + cfg["半径"])
    if not _____53E5_67C4_6709_6548(rect) then
        return
    end
    ____Boss_5165_53E3_76D1_542C = _____521B_5EFA_77E9_5F62_8FDB_5165_76D1_542C(rect, ____on_8FDB_5165_7956_5730_53CC_7075_536BBoss_5165_53E3, nil)
    RemoveRect(rect)
end
local function ____on_7956_5730_53CC_7075_536B_6218_6597_7ED3_675F(_red, _azure)
    if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss战已完成"] then
        return
    end
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["Boss战已完成"] = true
    if _____53E5_67C4_6709_6548(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"]) then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"], "祖地深处的躁动停下来了。回来吧，这段延续太久的旧誓该有一个交代了。", 5600)
    end
end
____exports["init祖地双灵卫Boss场景"] = function()
    if ____Boss_573A_666F_6A21_5757_5DF2_521D_59CB_5316 then
        return
    end
    ____Boss_573A_666F_6A21_5757_5DF2_521D_59CB_5316 = true
    _____6CE8_518CBoss_5165_53E3()
    ____register_7956_5730_53CC_7075_536B_6218_6597_7ED3_675FListener(____on_7956_5730_53CC_7075_536B_6218_6597_7ED3_675F)
end
return ____exports
