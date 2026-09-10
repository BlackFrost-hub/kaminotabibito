--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C = require("系统.09．表现系统.02．对话框系统.08．任务奖励执行")
local getPlayerFirstHero = ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C.getPlayerFirstHero
local ____00_FF0E_8BA2_5355_914D_7F6E_8868 = require("系统.11．剧情系统.02．支线任务.03．渔夫收购.00．订单配置表")
local _____6E14_592B_8BA2_5355_8868 = ____00_FF0E_8BA2_5355_914D_7F6E_8868["渔夫订单表"]
local _____7194_5CA9_9C7C_7269_54C1ID_5217_8868 = ____00_FF0E_8BA2_5355_914D_7F6E_8868["熔岩鱼物品ID列表"]
local _____6E14_592B_62D2_7EDD_5BF9_767D = ____00_FF0E_8BA2_5355_914D_7F6E_8868["渔夫拒绝对白"]
local _____6E14_592B_5F00_573A_5BF9_767D = ____00_FF0E_8BA2_5355_914D_7F6E_8868["渔夫开场对白"]
local _____6E14_592B_6536_8D2D_4EFB_52A1ID = ____00_FF0E_8BA2_5355_914D_7F6E_8868["渔夫收购任务ID"]
--- 默洛克渔夫 · 渔获收购结算
-- 
-- 挂在任务的「完成后动作」上。任务本身**不写需求物品**，所以玩家点提交必定进入这里，
-- 由本模块自己判断背包里凑得出哪一档订单：
--   1. 按 订单表 顺序（苛刻→宽松）找第一个完全满足的
--   2. 命中 → 扣鱼 + 给金币 + 给装备 + 渔夫开口
--   3. 都不满足 → 渔夫拒绝
-- 这样"奖励是什么"完全不由任务界面公示，玩家只能从渔夫的话里猜。
local jass = require("jass.common")
local ____require_result_0 = require("系统.08．任务系统.01．任务数据")
local questDB = ____require_result_0.questDB
local ____require_result_1 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____require_result_1.questManager
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local ____require_result_3 = require("系统.03．技能系统.04．快捷键技能.02．按Ctrl切换背包")
local _____73A9_5BB6_4E3B_526F_80CC_5305_6301_6709_7269_54C1 = ____require_result_3["玩家主副背包持有物品"]
local ____require_result_4 = require("lib.扩展函数.物品相关函数.物品判断函数")
local GetItemTypeTotalCountByChargesBJ = ____require_result_4.GetItemTypeTotalCountByChargesBJ
local ConsumeItemTypeCountByChargesBJ = ____require_result_4.ConsumeItemTypeCountByChargesBJ
local ____require_result_5 = require("lib.扩展函数.物品相关函数.index")
local _____521B_5EFA_7269_54C1_5E76_7ED9_4E88_5355_4F4D = ____require_result_5["创建物品并给予单位"]
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_5["创建物品并注册排泄监听"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.05．玩家工具")
local AddGoldWithFeedback = ____require_result_6.AddGoldWithFeedback
local ____require_result_7 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_7["解析配置内部ID"]
local GetRandomInt = jass.GetRandomInt
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local ____require_result_8 = require("lib.扩展函数.BJ函数.index")
local UnitItemInSlotBJ = ____require_result_8.UnitItemInSlotBJ
local IsUnitType = jass.IsUnitType
local Player = jass.Player
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
--- 以渔夫的口吻说话。
local function _____6E14_592B_8BF4_8BDD(_____73A9_5BB6ID, _____6587_672C)
    jass.DisplayTimedTextToPlayer(
        Player(_____73A9_5BB6ID),
        0,
        0,
        8,
        "|cFFFFFF00『默洛克渔夫』：|r" .. _____6587_672C
    )
end
local function _____6570_91CF(_____82F1_96C4, _____7269_54C1ID)
    local _____7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____7269_54C1ID)
    if _____7C7B_578BID == 0 then
        return 0
    end
    return GetItemTypeTotalCountByChargesBJ(_____82F1_96C4, _____7C7B_578BID)
end
--- 指定需求是否全部满足。
local function _____6EE1_8DB3_6307_5B9A_9700_6C42(_____82F1_96C4, _____8BA2_5355)
    local _____9700_6C42_5217_8868 = _____8BA2_5355["指定需求"]
    if _____9700_6C42_5217_8868 == nil then
        return true
    end
    do
        local i = 0
        while i < #_____9700_6C42_5217_8868 do
            if _____6570_91CF(_____82F1_96C4, _____9700_6C42_5217_8868[i + 1]["物品ID"]) < _____9700_6C42_5217_8868[i + 1]["数量"] then
                return false
            end
            i = i + 1
        end
    end
    return true
end
--- 任意熔岩鱼总数是否够。
local function _____6EE1_8DB3_4EFB_610F_9700_6C42(_____82F1_96C4, _____8BA2_5355)
    local _____9700_8981 = _____8BA2_5355["任意数量"] or 0
    if _____9700_8981 <= 0 then
        return true
    end
    local _____5408_8BA1 = 0
    do
        local i = 0
        while i < #_____7194_5CA9_9C7C_7269_54C1ID_5217_8868 do
            _____5408_8BA1 = _____5408_8BA1 + _____6570_91CF(_____82F1_96C4, _____7194_5CA9_9C7C_7269_54C1ID_5217_8868[i + 1])
            i = i + 1
        end
    end
    return _____5408_8BA1 >= _____9700_8981
end
local function _____6EE1_8DB3_8BA2_5355(_____82F1_96C4, _____8BA2_5355)
    return _____6EE1_8DB3_6307_5B9A_9700_6C42(_____82F1_96C4, _____8BA2_5355) and _____6EE1_8DB3_4EFB_610F_9700_6C42(_____82F1_96C4, _____8BA2_5355)
end
--- 扣掉指定需求。
local function _____6D88_8017_6307_5B9A_9700_6C42(_____82F1_96C4, _____8BA2_5355)
    local _____9700_6C42_5217_8868 = _____8BA2_5355["指定需求"]
    if _____9700_6C42_5217_8868 == nil then
        return
    end
    do
        local i = 0
        while i < #_____9700_6C42_5217_8868 do
            ConsumeItemTypeCountByChargesBJ(
                _____82F1_96C4,
                _____89E3_6790_914D_7F6E_5185_90E8ID(_____9700_6C42_5217_8868[i + 1]["物品ID"]),
                _____9700_6C42_5217_8868[i + 1]["数量"]
            )
            i = i + 1
        end
    end
end
--- 从任意熔岩鱼里凑数扣，按种类依次扣够为止。
local function _____6D88_8017_4EFB_610F_9700_6C42(_____82F1_96C4, _____8BA2_5355)
    local _____8FD8_5DEE = _____8BA2_5355["任意数量"] or 0
    if _____8FD8_5DEE <= 0 then
        return
    end
    do
        local i = 0
        while i < #_____7194_5CA9_9C7C_7269_54C1ID_5217_8868 and _____8FD8_5DEE > 0 do
            do
                local _____7269_54C1ID = _____7194_5CA9_9C7C_7269_54C1ID_5217_8868[i + 1]
                local _____6301_6709 = _____6570_91CF(_____82F1_96C4, _____7269_54C1ID)
                if _____6301_6709 <= 0 then
                    goto __continue22
                end
                local _____6263 = _____6301_6709 < _____8FD8_5DEE and _____6301_6709 or _____8FD8_5DEE
                ConsumeItemTypeCountByChargesBJ(
                    _____82F1_96C4,
                    _____89E3_6790_914D_7F6E_5185_90E8ID(_____7269_54C1ID),
                    _____6263
                )
                _____8FD8_5DEE = _____8FD8_5DEE - _____6263
            end
            ::__continue22::
            i = i + 1
        end
    end
end
--- 取英雄的副背包马甲单位（与 Ctrl 切包同一份数据）。
local function _____53D6_526F_80CC_5305_9A6C_7532(_____82F1_96C4)
    local _____73A9_5BB6 = GetOwningPlayer(_____82F1_96C4)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return nil
    end
    local _____9A6C_7532 = YDUserDataGetSafe("player", _____73A9_5BB6, "切换背包辅助", "unit")
    if _____9A6C_7532 == nil or _____9A6C_7532 == 0 or _____9A6C_7532 == _____82F1_96C4 then
        return nil
    end
    return _____9A6C_7532
end
--- 统计主背包 + 副背包马甲的空闲格数。
local function _____7EDF_8BA1_7A7A_95F2_683C_6570(_____82F1_96C4)
    local _____7A7A_95F2 = 0
    do
        local slot = 1
        while slot <= 6 do
            local _____4E3B = UnitItemInSlotBJ(_____82F1_96C4, slot)
            if _____4E3B == nil or _____4E3B == 0 then
                _____7A7A_95F2 = _____7A7A_95F2 + 1
            end
            slot = slot + 1
        end
    end
    local _____9A6C_7532 = _____53D6_526F_80CC_5305_9A6C_7532(_____82F1_96C4)
    if _____9A6C_7532 ~= nil then
        do
            local slot = 1
            while slot <= 6 do
                local _____526F = UnitItemInSlotBJ(_____9A6C_7532, slot)
                if _____526F == nil or _____526F == 0 then
                    _____7A7A_95F2 = _____7A7A_95F2 + 1
                end
                slot = slot + 1
            end
        end
    end
    return _____7A7A_95F2
end
--- 背包感知的装备发放：
--   1. 先塞英雄主背包（原生 6 格，触发拾取结算）；
--   2. 放不下 → 塞副背包马甲（Ctrl 可切到的那 6 格）；
--   3. 都满 → 掉在英雄脚下。绝不让奖励静默销毁。
-- （原生 UnitAddItem 只写英雄 6 格——这就是此前"有格却发不出"的原因。）
local function _____53D1_653E_88C5_5907_5230_80CC_5305(_____73A9_5BB6ID, _____82F1_96C4, _____88C5_5907_7C7B_578BID)
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_7ED9_4E88_5355_4F4D(_____82F1_96C4, _____88C5_5907_7C7B_578BID)
    if _____7269_54C1 ~= nil and _____7269_54C1 ~= 0 then
        return
    end
    local _____9A6C_7532 = _____53D6_526F_80CC_5305_9A6C_7532(_____82F1_96C4)
    if _____9A6C_7532 ~= nil then
        local _____526F_7269_54C1 = _____521B_5EFA_7269_54C1_5E76_7ED9_4E88_5355_4F4D(_____9A6C_7532, _____88C5_5907_7C7B_578BID)
        if _____526F_7269_54C1 ~= nil and _____526F_7269_54C1 ~= 0 then
            _____6E14_592B_8BF4_8BDD(_____73A9_5BB6ID, "主包满了，东西塞你副包了——Ctrl 切换看看。")
            return
        end
    end
    _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____88C5_5907_7C7B_578BID,
        GetUnitX(_____82F1_96C4),
        GetUnitY(_____82F1_96C4)
    )
    _____6E14_592B_8BF4_8BDD(_____73A9_5BB6ID, "背包全满了。东西放你脚边了，自己捡。")
end
local function _____53D1_5956(_____73A9_5BB6ID, _____82F1_96C4, _____8BA2_5355)
    if _____8BA2_5355["金币"] > 0 then
        AddGoldWithFeedback(
            nil,
            {
                delta = _____8BA2_5355["金币"],
                player = Player(_____73A9_5BB6ID)
            }
        )
    end
    if _____8BA2_5355["装备ID"] ~= nil and _____8BA2_5355["装备ID"] ~= "" then
        local _____88C5_5907_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____8BA2_5355["装备ID"])
        if _____88C5_5907_7C7B_578BID ~= 0 then
            _____53D1_653E_88C5_5907_5230_80CC_5305(_____73A9_5BB6ID, _____82F1_96C4, _____88C5_5907_7C7B_578BID)
        end
    end
end
--- 成功提交目标次数：满 15 次任务才算真正完成。
____exports["渔获收购目标次数"] = 15
--- 成功提交计数（与任务状态一致，全队共享，一局内有效）。
local _____6210_529F_63D0_4EA4_6B21_6570 = 0
--- 任务「完成后动作」。签名与项目既有回调一致（编译为 (quest, 玩家ID) 双参调用）。
____exports["渔夫收购结算"] = function(_____73A9_5BB6ID)
    local function _____6536_5C3E()
        if _____6210_529F_63D0_4EA4_6B21_6570 >= ____exports["渔获收购目标次数"] then
            return
        end
        local _____4EFB_52A1_952E = tostring(_____6E14_592B_6536_8D2D_4EFB_52A1ID)
        local globalData = questDB.globalData
        if globalData ~= nil and globalData.completedQuests ~= nil then
            globalData.completedQuests:delete(_____4EFB_52A1_952E)
        end
        questManager:onQuestAccepted(_____73A9_5BB6ID, _____4EFB_52A1_952E)
    end
    local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____82F1_96C4 = getPlayerFirstHero(nil, _____73A9_5BB6)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    if IsUnitType(_____82F1_96C4, UNIT_TYPE_DEAD) then
        return
    end
    _____6E14_592B_8BF4_8BDD(_____73A9_5BB6ID, _____6E14_592B_5F00_573A_5BF9_767D)
    if _____7EDF_8BA1_7A7A_95F2_683C_6570(_____82F1_96C4) <= 0 then
        _____6E14_592B_8BF4_8BDD(_____73A9_5BB6ID, "你背包塞得死死的。先腾出一格，再来把鱼给我。")
        _____6536_5C3E()
        return
    end
    do
        local i = 0
        while i < #_____6E14_592B_8BA2_5355_8868 do
            do
                local _____8BA2_5355 = _____6E14_592B_8BA2_5355_8868[i + 1]
                if not _____6EE1_8DB3_8BA2_5355(_____82F1_96C4, _____8BA2_5355) then
                    goto __continue52
                end
                _____6D88_8017_6307_5B9A_9700_6C42(_____82F1_96C4, _____8BA2_5355)
                _____6D88_8017_4EFB_610F_9700_6C42(_____82F1_96C4, _____8BA2_5355)
                _____53D1_5956(_____73A9_5BB6ID, _____82F1_96C4, _____8BA2_5355)
                _____6210_529F_63D0_4EA4_6B21_6570 = _____6210_529F_63D0_4EA4_6B21_6570 + 1
                _____6E14_592B_8BF4_8BDD(_____73A9_5BB6ID, _____8BA2_5355["提交对白"])
                if _____6210_529F_63D0_4EA4_6B21_6570 >= ____exports["渔获收购目标次数"] then
                    _____6E14_592B_8BF4_8BDD(_____73A9_5BB6ID, "……十五次了。你这双手，比我的还懂这片水。\\n渔民：行了，以后不用再给我送鱼了——拿着这些，该干嘛干嘛去。")
                end
                _____6536_5C3E()
                return
            end
            ::__continue52::
            i = i + 1
        end
    end
    local _____62D2_7EDD = _____6E14_592B_62D2_7EDD_5BF9_767D[GetRandomInt(1, #_____6E14_592B_62D2_7EDD_5BF9_767D)]
    _____6E14_592B_8BF4_8BDD(_____73A9_5BB6ID, _____62D2_7EDD)
    _____6536_5C3E()
end
return ____exports
