--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_1["创建物品并注册排泄监听"]
local ____require_result_2 = require("lib.扩展函数.物品相关函数.装备数据查询")
local getItemDataEntry = ____require_result_2.getItemDataEntry
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_5["应用Boss战启动属性配置"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.07．技能入口")
local _____6CE8_518C_5229_5C14_4F2F_7279_6280_80FD_7ED3_6784 = ____require_result_6["注册利尔伯特技能结构"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.01．运行时")
local _____83B7_53D6_6216_521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587 = ____require_result_7["获取或创建利尔伯特上下文"]
local _____6E05_7406_5229_5C14_4F2F_7279_4E0A_4E0B_6587 = ____require_result_7["清理利尔伯特上下文"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.04．裂地斩")
local _____91CA_653E_5229_5C14_4F2F_7279_88C2_5730_65A9 = ____require_result_8["释放利尔伯特裂地斩"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.05．审判拷问")
local _____91CA_653E_5229_5C14_4F2F_7279_5BA1_5224_62F7_95EE = ____require_result_9["释放利尔伯特审判拷问"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.06．检查")
local _____91CA_653E_5229_5C14_4F2F_7279_68C0_67E5 = ____require_result_10["释放利尔伯特检查"]
local ____require_result_11 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_11["注册Boss技能测试目标"]
local _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_11["注销Boss技能测试目标"]
local ____require_result_12 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_12["标记测试Boss跳过死亡结算"]
local ____require_result_13 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_13["Boss测试单位存活"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_13["准备Boss测试固定山丘之王"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_13["设置Boss测试单位满血"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_13["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_13["注册Boss测试命令组"]
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local GetPlayerId = jass.GetPlayerId
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local SetUnitFacing = jass.SetUnitFacing
local SetUnitAcquireRange = jass.SetUnitAcquireRange
local IssueImmediateOrder = jass.IssueImmediateOrder
local UnitDamageTarget = jass.UnitDamageTarget
local UnitItemInSlot = jass.UnitItemInSlot
local UnitAddItem = jass.UnitAddItem
local UnitRemoveItem = jass.UnitRemoveItem
local GetItemTypeId = jass.GetItemTypeId
local RemoveItem = jass.RemoveItem
local RemoveUnit = jass.RemoveUnit
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local DzUnitDisableAttack = japi.DzUnitDisableAttack
local EXSetUnitFacing = japi.EXSetUnitFacing
local _____6D4B_8BD5_671D_5411_89D2_5EA6_8F6C_5F27_5EA6 = 0.017453292519943295
local function _____7981_7528_5229_5C14_6D4B_8BD5_9776_653B_51FB(target)
    if target == nil or target == 0 or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return
    end
    SetUnitAcquireRange(target, 0)
    if DzUnitDisableAttack ~= nil then
        DzUnitDisableAttack(target, true)
    end
    IssueImmediateOrder(target, "stop")
end
local function _____8BBE_7F6E_5229_5C14_6D4B_8BD5_9776_671D_5411(target, facing)
    if target == nil or target == 0 or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return
    end
    EXSetUnitFacing(target, facing * _____6D4B_8BD5_671D_5411_89D2_5EA6_8F6C_5F27_5EA6)
    SetUnitFacing(target, facing)
end
local _____5229_5C14_4F2F_7279_5355_4F4DID = stringToFourCCSafe("N05L")
local _____6B65_5175_5355_4F4DID = stringToFourCCSafe("hfoo")
local _____6D4B_8BD5_88C5_5907ID = stringToFourCCSafe("I000")
local _____6D4B_8BD5_4E2D_5FC3X = -540.6
local _____6D4B_8BD5_4E2D_5FC3Y = -2495.2
local _____7EA2_8272_73A9_5BB6ID = 0
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
local _____6700_8FD1Boss = {}
local _____6700_8FD1_5C71_4E18_4E4B_738B = {}
local _____6700_8FD1_4F24_5BB3_6B65_5175 = {}
local _____6D4B_8BD5_521B_5EFA_88C5_5907 = {}
local function _____7269_54C1_6709_6548(item)
    return item ~= nil and item ~= 0 and GetItemTypeId(item) ~= 0
end
local function _____67E5_627E_5C71_4E18_4E4B_738B_53EF_8BC6_522B_88C5_5907(_____5C71_4E18_4E4B_738B)
    do
        local slot = 0
        while slot <= 5 do
            local item = UnitItemInSlot(_____5C71_4E18_4E4B_738B, slot)
            if _____7269_54C1_6709_6548(item) and getItemDataEntry(item) ~= nil then
                return item
            end
            slot = slot + 1
        end
    end
    return nil
end
local function _____83B7_53D6_5C71_4E18_4E4B_738B_53EF_8BC6_522B_88C5_5907_6570_91CF(_____5C71_4E18_4E4B_738B)
    local count = 0
    do
        local slot = 0
        while slot <= 5 do
            local item = UnitItemInSlot(_____5C71_4E18_4E4B_738B, slot)
            if _____7269_54C1_6709_6548(item) and getItemDataEntry(item) ~= nil then
                count = count + 1
            end
            slot = slot + 1
        end
    end
    return count
end
local function _____79FB_9664_5C71_4E18_4E4B_738B_53EF_8BC6_522B_88C5_5907(playerId, _____5C71_4E18_4E4B_738B)
    local removedCount = 0
    do
        local slot = 0
        while slot <= 5 do
            do
                local item = UnitItemInSlot(_____5C71_4E18_4E4B_738B, slot)
                if not _____7269_54C1_6709_6548(item) or getItemDataEntry(item) == nil then
                    goto __continue18
                end
                UnitRemoveItem(_____5C71_4E18_4E4B_738B, item)
                if _____7269_54C1_6709_6548(item) then
                    RemoveItem(item)
                end
                removedCount = removedCount + 1
            end
            ::__continue18::
            slot = slot + 1
        end
    end
    return removedCount
end
local function _____786E_4FDD_5C71_4E18_4E4B_738B_62E5_6709_6D4B_8BD5_88C5_5907(playerId, _____5C71_4E18_4E4B_738B)
    local _____5DF2_6709_88C5_5907 = _____67E5_627E_5C71_4E18_4E4B_738B_53EF_8BC6_522B_88C5_5907(_____5C71_4E18_4E4B_738B)
    if _____5DF2_6709_88C5_5907 ~= nil and _____5DF2_6709_88C5_5907 ~= 0 then
        return _____5DF2_6709_88C5_5907
    end
    local item = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____6D4B_8BD5_88C5_5907ID,
        GetUnitX(_____5C71_4E18_4E4B_738B),
        GetUnitY(_____5C71_4E18_4E4B_738B)
    )
    if not _____7269_54C1_6709_6548(item) or getItemDataEntry(item) == nil or not UnitAddItem(_____5C71_4E18_4E4B_738B, item) then
        if _____7269_54C1_6709_6548(item) then
            RemoveItem(item)
        end
        return nil
    end
    local _____5217_8868 = _____6D4B_8BD5_521B_5EFA_88C5_5907[playerId]
    if _____5217_8868 == nil then
        _____5217_8868 = {}
        _____6D4B_8BD5_521B_5EFA_88C5_5907[playerId] = _____5217_8868
    end
    _____5217_8868[#_____5217_8868 + 1] = item
    return item
end
local function _____521B_5EFA_6216_83B7_53D6_5229_5C14_4F2F_7279_6D4B_8BD5_4E0A_4E0B_6587(player)
    local playerId = GetPlayerId(player)
    _____6CE8_518C_5229_5C14_4F2F_7279_6280_80FD_7ED3_6784()
    local boss = _____6700_8FD1Boss[playerId]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        boss = CreateUnit(
            Player(_____7EA2_8272_73A9_5BB6ID),
            _____5229_5C14_4F2F_7279_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X,
            _____6D4B_8BD5_4E2D_5FC3Y,
            0
        )
        _____6700_8FD1Boss[playerId] = boss
    end
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    SetUnitPosition(boss, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(boss, 0)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss, 100000)
    _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
    local _____5C71_4E18_4E4B_738B = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____6700_8FD1_5C71_4E18_4E4B_738B[playerId], _____6D4B_8BD5_4E2D_5FC3X + 450, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____5C71_4E18_4E4B_738B) then
        return nil
    end
    _____6700_8FD1_5C71_4E18_4E4B_738B[playerId] = _____5C71_4E18_4E4B_738B
    _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807(_____5C71_4E18_4E4B_738B)
    local _____6B65_5175 = _____6700_8FD1_4F24_5BB3_6B65_5175[playerId]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6B65_5175) then
        _____6B65_5175 = CreateUnit(
            Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
            _____6B65_5175_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X - 350,
            _____6D4B_8BD5_4E2D_5FC3Y,
            0
        )
        _____6700_8FD1_4F24_5BB3_6B65_5175[playerId] = _____6B65_5175
    end
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6B65_5175) then
        return nil
    end
    SetUnitPosition(_____6B65_5175, _____6D4B_8BD5_4E2D_5FC3X - 350, _____6D4B_8BD5_4E2D_5FC3Y)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(_____6B65_5175, 100000)
    _____7981_7528_5229_5C14_6D4B_8BD5_9776_653B_51FB(_____5C71_4E18_4E4B_738B)
    local _____8FD0_884C_65F6 = _____83B7_53D6_6216_521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587(boss)
    if _____8FD0_884C_65F6 == nil then
        return nil
    end
    globals.udg_Boss = boss
    return {["Boss单位"] = boss, ["山丘之王"] = _____5C71_4E18_4E4B_738B, ["伤害步兵"] = _____6B65_5175, ["运行时"] = _____8FD0_884C_65F6}
end
local function _____6E05_7406_5229_5C14_4F2F_7279_6D4B_8BD5_4E0A_4E0B_6587(player, context)
    local playerId = GetPlayerId(player)
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context and context["Boss单位"]) then
        _____6E05_7406_5229_5C14_4F2F_7279_4E0A_4E0B_6587(context["Boss单位"])
    end
    local _____88C5_5907_5217_8868 = _____6D4B_8BD5_521B_5EFA_88C5_5907[playerId] or ({})
    do
        local i = #_____88C5_5907_5217_8868 - 1
        while i >= 0 do
            local item = _____88C5_5907_5217_8868[i + 1]
            if _____7269_54C1_6709_6548(item) then
                RemoveItem(item)
            end
            i = i - 1
        end
    end
    _____6D4B_8BD5_521B_5EFA_88C5_5907[playerId] = {}
    _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807(context and context["山丘之王"])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_5C71_4E18_4E4B_738B[playerId])
    if _____6700_8FD1_4F24_5BB3_6B65_5175[playerId] ~= nil and _____6700_8FD1_4F24_5BB3_6B65_5175[playerId] ~= 0 then
        RemoveUnit(_____6700_8FD1_4F24_5BB3_6B65_5175[playerId])
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1Boss[playerId])
    _____6700_8FD1_5C71_4E18_4E4B_738B[playerId] = nil
    _____6700_8FD1_4F24_5BB3_6B65_5175[playerId] = nil
    _____6700_8FD1Boss[playerId] = nil
    if globals.udg_Boss == (context and context["Boss单位"]) then
        globals.udg_Boss = nil
    end
end
local function _____91CD_7F6E_80CC_5BF9_7AD9_4F4D(context)
    SetUnitPosition(context["Boss单位"], _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(context["Boss单位"], 0)
    IssueImmediateOrder(context["Boss单位"], "holdposition")
    SetUnitPosition(context["山丘之王"], _____6D4B_8BD5_4E2D_5FC3X + 450, _____6D4B_8BD5_4E2D_5FC3Y)
    _____7981_7528_5229_5C14_6D4B_8BD5_9776_653B_51FB(context["山丘之王"])
    _____8BBE_7F6E_5229_5C14_6D4B_8BD5_9776_671D_5411(context["山丘之王"], 0)
    IssueImmediateOrder(context["山丘之王"], "stop")
end
local function _____91CD_7F6E_9762_5411_7AD9_4F4D(context)
    _____91CD_7F6E_80CC_5BF9_7AD9_4F4D(context)
    _____8BBE_7F6E_5229_5C14_6D4B_8BD5_9776_671D_5411(context["山丘之王"], 180)
end
local function _____91CD_7F6E_539F_4F4D_80CC_5BF9_7AD9_4F4D(context)
    _____91CD_7F6E_80CC_5BF9_7AD9_4F4D(context)
    _____8BBE_7F6E_5229_5C14_6D4B_8BD5_9776_671D_5411(context["山丘之王"], 0)
end
local function ____on_5229_5C14_4F2F_7279_6B63_4E49_5BA1_5224_5EF6_8FDF_4F24_5BB3(variable)
    local data = variable
    if data == nil then
        return
    end
    local context = data["上下文"]
    local target = context["山丘之王"]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["Boss单位"]) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
            _____79FB_9664_5355_4F4D_6682_505C(target, data["暂停来源"])
            _____8BBE_7F6E_5229_5C14_6D4B_8BD5_9776_671D_5411(target, data["朝向"])
            IssueImmediateOrder(target, "stop")
        end
        return
    end
    UnitDamageTarget(
        context["Boss单位"],
        target,
        200,
        data["是否攻击"],
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
    _____79FB_9664_5355_4F4D_6682_505C(target, data["暂停来源"])
    _____8BBE_7F6E_5229_5C14_6D4B_8BD5_9776_671D_5411(target, data["朝向"])
    IssueImmediateOrder(target, "stop")
end
local function _____6D4B_8BD5_6B63_4E49_5BA1_5224_88AB_52A8(_player, context)
    _____91CD_7F6E_80CC_5BF9_7AD9_4F4D(context)
    local _____671D_5411_9501_5B9A_6765_6E90 = "利尔伯特测试-正义审判朝向锁定"
    _____6DFB_52A0_5355_4F4D_6682_505C(context["山丘之王"], _____671D_5411_9501_5B9A_6765_6E90)
    _____8BBE_7F6E_5229_5C14_6D4B_8BD5_9776_671D_5411(context["山丘之王"], 0)
    local callbackId = addDelayedCallback(1000, ____on_5229_5C14_4F2F_7279_6B63_4E49_5BA1_5224_5EF6_8FDF_4F24_5BB3, {["上下文"] = context, ["暂停来源"] = _____671D_5411_9501_5B9A_6765_6E90, ["朝向"] = 0, ["是否攻击"] = false})
    local ____opt_24 = context["运行时"]
    if ____opt_24 ~= nil then
        ____opt_24 = ____opt_24["清理"]
    end
    local ____opt_result_26
    if ____opt_24 ~= nil then
        ____opt_result_26 = ____opt_24["登记延迟回调"]
    end
    if ____opt_result_26 ~= nil then
        ____opt_result_26(____opt_24, "利尔伯特测试-正义审判背对伤害", callbackId)
    end
end
local function _____6D4B_8BD5_6B63_4E49_5BA1_5224_9762_5411_5B89_5168(_player, context)
    _____91CD_7F6E_9762_5411_7AD9_4F4D(context)
    local _____671D_5411_9501_5B9A_6765_6E90 = "利尔伯特测试-正义审判面向朝向锁定"
    _____6DFB_52A0_5355_4F4D_6682_505C(context["山丘之王"], _____671D_5411_9501_5B9A_6765_6E90)
    _____8BBE_7F6E_5229_5C14_6D4B_8BD5_9776_671D_5411(context["山丘之王"], 180)
    local callbackId = addDelayedCallback(1000, ____on_5229_5C14_4F2F_7279_6B63_4E49_5BA1_5224_5EF6_8FDF_4F24_5BB3, {["上下文"] = context, ["暂停来源"] = _____671D_5411_9501_5B9A_6765_6E90, ["朝向"] = 180, ["是否攻击"] = true})
    local ____opt_31 = context["运行时"]
    if ____opt_31 ~= nil then
        ____opt_31 = ____opt_31["清理"]
    end
    local ____opt_result_33
    if ____opt_31 ~= nil then
        ____opt_result_33 = ____opt_31["登记延迟回调"]
    end
    if ____opt_result_33 ~= nil then
        ____opt_result_33(____opt_31, "利尔伯特测试-正义审判面向安全", callbackId)
    end
end
local function _____6D4B_8BD5_88C2_5730_65A9(_player, context)
    _____91CD_7F6E_80CC_5BF9_7AD9_4F4D(context)
    _____91CA_653E_5229_5C14_4F2F_7279_88C2_5730_65A9(context["运行时"])
end
local function _____6D4B_8BD5_5BA1_5224_62F7_95EE(_player, context)
    _____91CD_7F6E_80CC_5BF9_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_5229_5C14_4F2F_7279_5BA1_5224_62F7_95EE(context["运行时"], context["山丘之王"])
    if _____662F_5426_5F00_59CB then
        SetUnitPosition(context["山丘之王"], _____6D4B_8BD5_4E2D_5FC3X + 800, _____6D4B_8BD5_4E2D_5FC3Y)
        _____8BBE_7F6E_5229_5C14_6D4B_8BD5_9776_671D_5411(context["山丘之王"], 0)
        IssueImmediateOrder(context["山丘之王"], "stop")
    end
end
local function _____6D4B_8BD5_5BA1_5224_62F7_95EE_539F_4F4D_5B89_5168(_player, context)
    _____91CD_7F6E_539F_4F4D_80CC_5BF9_7AD9_4F4D(context)
    _____91CA_653E_5229_5C14_4F2F_7279_5BA1_5224_62F7_95EE(context["运行时"], context["山丘之王"])
end
local function _____6D4B_8BD5_68C0_67E5_65E0_88C5_5907(player, context)
    local playerId = GetPlayerId(player)
    _____91CD_7F6E_80CC_5BF9_7AD9_4F4D(context)
    _____79FB_9664_5C71_4E18_4E4B_738B_53EF_8BC6_522B_88C5_5907(playerId, context["山丘之王"])
    _____91CA_653E_5229_5C14_4F2F_7279_68C0_67E5(context["运行时"], context["山丘之王"])
end
local function _____6D4B_8BD5_68C0_67E5_6B63_5E38(player, context)
    local playerId = GetPlayerId(player)
    _____91CD_7F6E_80CC_5BF9_7AD9_4F4D(context)
    local item = _____786E_4FDD_5C71_4E18_4E4B_738B_62E5_6709_6D4B_8BD5_88C5_5907(playerId, context["山丘之王"])
    if item ~= nil then
        _____91CA_653E_5229_5C14_4F2F_7279_68C0_67E5(context["运行时"], context["山丘之王"])
    end
end
local function _____6D4B_8BD5_68C0_67E5_5931_8D25(player, context)
    local playerId = GetPlayerId(player)
    _____91CD_7F6E_80CC_5BF9_7AD9_4F4D(context)
    local item = _____786E_4FDD_5C71_4E18_4E4B_738B_62E5_6709_6D4B_8BD5_88C5_5907(playerId, context["山丘之王"])
    local _____662F_5426_5F00_59CB = item ~= nil and _____91CA_653E_5229_5C14_4F2F_7279_68C0_67E5(context["运行时"], context["山丘之王"])
    if _____662F_5426_5F00_59CB then
        UnitDamageTarget(
            context["伤害步兵"],
            context["Boss单位"],
            5000,
            true,
            false,
            ATTACK_TYPE_NORMAL,
            DAMAGE_TYPE_NORMAL,
            WEAPON_TYPE_WHOKNOWS
        )
        IssueImmediateOrder(context["Boss单位"], "holdposition")
    end
end
local _____5229_5C14_4F2F_7279_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["命令"] = "利尔1", ["名称"] = "正义审判真实伤害", ["执行"] = _____6D4B_8BD5_6B63_4E49_5BA1_5224_88AB_52A8},
    {["序号"] = 1, ["命令"] = "利尔1-2", ["名称"] = "正义审判面向安全", ["执行"] = _____6D4B_8BD5_6B63_4E49_5BA1_5224_9762_5411_5B89_5168},
    {["序号"] = 2, ["命令"] = "利尔2", ["名称"] = "裂地斩", ["执行"] = _____6D4B_8BD5_88C2_5730_65A9},
    {["序号"] = 3, ["命令"] = "利尔3", ["名称"] = "审判拷问背对离位", ["执行"] = _____6D4B_8BD5_5BA1_5224_62F7_95EE},
    {["序号"] = 3, ["命令"] = "利尔3-2", ["名称"] = "审判拷问原位安全", ["执行"] = _____6D4B_8BD5_5BA1_5224_62F7_95EE_539F_4F4D_5B89_5168},
    {["序号"] = 4, ["命令"] = "利尔4", ["名称"] = "检查无装备安全跳过", ["执行"] = _____6D4B_8BD5_68C0_67E5_65E0_88C5_5907},
    {["序号"] = 4, ["命令"] = "利尔4-2", ["名称"] = "检查有装备正常完成", ["执行"] = _____6D4B_8BD5_68C0_67E5_6B63_5E38},
    {["序号"] = 5, ["命令"] = "利尔5", ["名称"] = "检查有装备超阈值失败", ["执行"] = _____6D4B_8BD5_68C0_67E5_5931_8D25}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "利尔伯特",
    ["Boss名称"] = "利尔·伯特",
    ["场地"] = {["正式中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}, ["测试空地中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}},
    ["创建或获取上下文"] = _____521B_5EFA_6216_83B7_53D6_5229_5C14_4F2F_7279_6D4B_8BD5_4E0A_4E0B_6587,
    ["清理上下文"] = _____6E05_7406_5229_5C14_4F2F_7279_6D4B_8BD5_4E0A_4E0B_6587,
    ["技能命令列表"] = _____5229_5C14_4F2F_7279_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
