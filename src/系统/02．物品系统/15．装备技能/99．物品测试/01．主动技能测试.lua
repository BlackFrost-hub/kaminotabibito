local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
local _____53D1_653E_76D7_8D3C_795E_7B26_8FDC_8DDD_6D4B_8BD5, debugLogForce, IssueTargetOrder, CreateItem, GetUnitX, GetUnitY, GetPlayerId, GetOwningPlayer, _____6A21_5757_540D, _____76D7_8D3C_795E_7B26_8FDC_8DDD_6D4B_8BD5_8DDD_79BB
local ____01_FF0E_88C5_5907_6570_636E = require("系统.02．物品系统.01．装备数据")
local _____88C5_5907_6570_636E = ____01_FF0E_88C5_5907_6570_636E.items
local ____02_FF0E_901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.02．通用物品技能槽位配置")
local _____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E_8868 = ____02_FF0E_901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E["通用物品技能槽位配置表"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____5237_65B0_7269_54C1CD = ____20_FF0E_7269_54C1_8F85_52A9["刷新物品CD"]
local _____65BD_52A0_51CF_901F = ____20_FF0E_7269_54C1_8F85_52A9["施加减速"]
local ____00_FF0E_6D4B_8BD5_914D_7F6E = require("系统.02．物品系统.15．装备技能.99．物品测试.00．测试配置")
local _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_53D1_653E_987A_5E8F = ____00_FF0E_6D4B_8BD5_914D_7F6E["物品主动技能测试发放顺序"]
local _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_5217_8868 = ____00_FF0E_6D4B_8BD5_914D_7F6E["物品主动技能测试命令列表"]
local _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_8BF4_660E_6587_672C_5217_8868 = ____00_FF0E_6D4B_8BD5_914D_7F6E["物品主动技能测试命令说明文本列表"]
local _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_6E05_7406_88C5_5907_5217_8868 = ____00_FF0E_6D4B_8BD5_914D_7F6E["物品主动技能测试清理装备列表"]
local _____7CBE_7075_836F_6C34_6D4B_8BD5_88C5_5907_5217_8868 = ____00_FF0E_6D4B_8BD5_914D_7F6E["精灵药水测试装备列表"]
function _____53D1_653E_76D7_8D3C_795E_7B26_8FDC_8DDD_6D4B_8BD5(unit, _____88C5_5907_540D, rawId, itemTypeId)
    local offsetX = 0
    if rawId == "I0FL" then
        offsetX = _____76D7_8D3C_795E_7B26_8FDC_8DDD_6D4B_8BD5_8DDD_79BB
    elseif rawId == "I0FK" then
        offsetX = -_____76D7_8D3C_795E_7B26_8FDC_8DDD_6D4B_8BD5_8DDD_79BB
    else
        return false
    end
    local item = CreateItem(
        itemTypeId,
        GetUnitX(unit) + offsetX,
        GetUnitY(unit)
    )
    if item == nil or item == 0 then
        debugLogForce(
            _____6A21_5757_540D,
            "创建盗贼神符失败",
            _____88C5_5907_540D,
            rawId,
            itemTypeId
        )
        return true
    end
    local orderOk = IssueTargetOrder(unit, "smart", item)
    debugLogForce(
        _____6A21_5757_540D,
        "已创建盗贼神符远距测试并命令拾取",
        _____88C5_5907_540D,
        rawId,
        "距离",
        _____76D7_8D3C_795E_7B26_8FDC_8DDD_6D4B_8BD5_8DDD_79BB,
        "ownerPid",
        GetPlayerId(GetOwningPlayer(unit)),
        "orderOk",
        orderOk
    )
    return true
end
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_3["按名字反查物品ID"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.物品相关函数.index")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_5["创建物品并注册排泄监听"]
IssueTargetOrder = jass.IssueTargetOrder
CreateItem = jass.CreateItem
local UnitRemoveItem = jass.UnitRemoveItem
local UnitAddItem = jass.UnitAddItem
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetItemTypeId = jass.GetItemTypeId
local UnitItemInSlot = jass.UnitItemInSlot
GetPlayerId = jass.GetPlayerId
local GetPlayerName = jass.GetPlayerName
GetOwningPlayer = jass.GetOwningPlayer
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
_____6A21_5757_540D = "物品主动技能测试"
local _____7CBE_7075_836F_6C34_5957_88C5_6D4B_8BD5_547D_4EE4 = "192"
local _____7269_54C1_51B7_5374_5237_65B0_547D_4EE4 = "wpcd"
local _____7269_54C1_8D1F_9762_6E05_9664_6D4B_8BD5_51CF_901F_547D_4EE4 = "wpslow"
local _____6253_5370_6CE8_518C_547D_4EE4_65E5_5FD7 = false
local _____6D4B_8BD5_73A9_5BB6_540D_79F0 = "WorldEdit"
local _____7EA2_8272_73A9_5BB6ID = 0
local _____6D4B_8BD5_7269_54C1_6280_80FDID_8868 = {}
local _____6D4B_8BD5_7269_54C1_4E3B_52A8_6700_5927_51B7_5374_79D2_8868 = {}
_____76D7_8D3C_795E_7B26_8FDC_8DDD_6D4B_8BD5_8DDD_79BB = 700
local _____5DF2_521D_59CB_5316_6D4B_8BD5_7269_54C1_6280_80FDID_8868 = false
local function _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    local ____g_gg_unit_Hamg_0002_6 = g.gg_unit_Hamg_0002
    if ____g_gg_unit_Hamg_0002_6 == nil then
        ____g_gg_unit_Hamg_0002_6 = _G.bj_lastCreatedUnit
    end
    local ____g_gg_unit_Hamg_0002_6_7 = ____g_gg_unit_Hamg_0002_6
    if ____g_gg_unit_Hamg_0002_6_7 == nil then
        ____g_gg_unit_Hamg_0002_6_7 = nil
    end
    return ____g_gg_unit_Hamg_0002_6_7
end
local SetItemPosition = jass.SetItemPosition
local function _____4E22_5F03_6D4B_8BD5_88C5_5907(unit)
    if unit == nil or unit == 0 then
        return
    end
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    do
        local i = 0
        while i < 6 do
            do
                local item = UnitItemInSlot(unit, i)
                if item == nil or item == 0 then
                    goto __continue6
                end
                local itemTypeId = GetItemTypeId(item)
                do
                    local j = 0
                    while j < #_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_6E05_7406_88C5_5907_5217_8868 do
                        do
                            local _____88C5_5907_540D = _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_6E05_7406_88C5_5907_5217_8868[j + 1]
                            local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
                            if rawId == nil or rawId == "" then
                                goto __continue9
                            end
                            if stringToFourCCSafe(rawId) == itemTypeId then
                                UnitRemoveItem(unit, item)
                                SetItemPosition(item, x, y)
                                break
                            end
                        end
                        ::__continue9::
                        j = j + 1
                    end
                end
            end
            ::__continue6::
            i = i + 1
        end
    end
end
local function _____662F_5141_8BB8_7269_54C1_6D4B_8BD5_73A9_5BB6(player)
    if player == nil or player == 0 then
        return false
    end
    if GetPlayerId(player) ~= _____7EA2_8272_73A9_5BB6ID then
        return false
    end
    local playerName = GetPlayerName(player) or ""
    return playerName == _____6D4B_8BD5_73A9_5BB6_540D_79F0 or playerName == _____6D4B_8BD5_73A9_5BB6_540D_79F0 .. ":"
end
local function _____662F_6709_6548_82F1_96C4(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_HERO) == true and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____5355_4F4D_5C5E_4E8E_73A9_5BB6(unit, player)
    if not _____662F_6709_6548_82F1_96C4(unit) then
        return false
    end
    return GetPlayerId(GetOwningPlayer(unit)) == GetPlayerId(player)
end
local function _____6536_96C6_73A9_5BB6_82F1_96C4(player)
    local result = {}
    local seen = {}
    local function _____6DFB_52A0_82F1_96C4(hero)
        if not _____5355_4F4D_5C5E_4E8E_73A9_5BB6(hero, player) then
            return
        end
        local handleId = GetHandleId(hero)
        if handleId > 0 and seen[handleId] == true then
            return
        end
        if handleId > 0 then
            seen[handleId] = true
        end
        result[#result + 1] = hero
    end
    _____6DFB_52A0_82F1_96C4(getRegisteredPlayerHero(player))
    _____6DFB_52A0_82F1_96C4(_____83B7_53D6_6D4B_8BD5_5355_4F4D())
    local group = CreateGroup()
    GroupEnumUnitsOfPlayer(group, player, nil)
    local unit = FirstOfGroup(group)
    while unit ~= nil and unit ~= 0 do
        GroupRemoveUnit(group, unit)
        _____6DFB_52A0_82F1_96C4(unit)
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
    return result
end
local function _____83B7_53D6_73A9_5BB6_6D4B_8BD5_5355_4F4D(player)
    local heroes = _____6536_96C6_73A9_5BB6_82F1_96C4(player)
    if #heroes > 0 then
        return heroes[1]
    end
    return nil
end
local function _____53D1_653E_88C5_5907(unit, _____88C5_5907_540D)
    local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
    if rawId == nil or rawId == "" then
        debugLogForce(_____6A21_5757_540D, "未找到装备ID", _____88C5_5907_540D)
        return false
    end
    local itemTypeId = stringToFourCCSafe(rawId)
    if _____53D1_653E_76D7_8D3C_795E_7B26_8FDC_8DDD_6D4B_8BD5(unit, _____88C5_5907_540D, rawId, itemTypeId) then
        return true
    end
    local item = CreateItem(
        itemTypeId,
        GetUnitX(unit),
        GetUnitY(unit)
    )
    if item == nil or item == 0 then
        debugLogForce(
            _____6A21_5757_540D,
            "创建装备失败",
            _____88C5_5907_540D,
            rawId,
            itemTypeId
        )
        return false
    end
    IssueTargetOrder(unit, "smart", item)
    debugLogForce(_____6A21_5757_540D, "已创建在脚下并命令拾取", _____88C5_5907_540D, rawId)
    return true
end
local function _____6DFB_52A0_6D4B_8BD5_7269_54C1_6280_80FDID(rawId, abilList)
    if rawId == nil or rawId == "" or abilList == nil or abilList == "" then
        return
    end
    local itemTypeId = stringToFourCCSafe(rawId)
    if itemTypeId == 0 then
        return
    end
    local abilityIds = _____6D4B_8BD5_7269_54C1_6280_80FDID_8868[itemTypeId] or ({})
    local rawAbilityList = __TS__StringSplit(abilList, ",")
    do
        local i = 0
        while i < #rawAbilityList do
            do
                local abilityRawId = __TS__StringTrim(rawAbilityList[i + 1])
                if abilityRawId == "" then
                    goto __continue39
                end
                local abilityId = stringToFourCCSafe(abilityRawId)
                if abilityId ~= 0 and __TS__ArrayIndexOf(abilityIds, abilityId) < 0 then
                    abilityIds[#abilityIds + 1] = abilityId
                end
            end
            ::__continue39::
            i = i + 1
        end
    end
    if #abilityIds > 0 then
        _____6D4B_8BD5_7269_54C1_6280_80FDID_8868[itemTypeId] = abilityIds
    end
end
local function _____8BB0_5F55_6D4B_8BD5_7269_54C1_4E3B_52A8_6700_5927_51B7_5374(rawId, _____79D2_6570)
    if rawId == nil or rawId == "" or not (_____79D2_6570 > 0) then
        return
    end
    local itemTypeId = stringToFourCCSafe(rawId)
    if itemTypeId == 0 then
        return
    end
    local old = _____6D4B_8BD5_7269_54C1_4E3B_52A8_6700_5927_51B7_5374_79D2_8868[itemTypeId] or 0
    if _____79D2_6570 > old then
        _____6D4B_8BD5_7269_54C1_4E3B_52A8_6700_5927_51B7_5374_79D2_8868[itemTypeId] = _____79D2_6570
    end
end
local function _____521D_59CB_5316_6D4B_8BD5_7269_54C1_6280_80FDID_8868()
    if _____5DF2_521D_59CB_5316_6D4B_8BD5_7269_54C1_6280_80FDID_8868 then
        return
    end
    _____5DF2_521D_59CB_5316_6D4B_8BD5_7269_54C1_6280_80FDID_8868 = true
    local _____6D4B_8BD5_7269_54C1RawID_8868 = {}
    do
        local i = 0
        while i < #_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_6E05_7406_88C5_5907_5217_8868 do
            local _____88C5_5907_540D = _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_6E05_7406_88C5_5907_5217_8868[i + 1]
            local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
            if rawId ~= nil and rawId ~= "" then
                _____6D4B_8BD5_7269_54C1RawID_8868[rawId] = true
            end
            local _____88C5_5907_9879 = rawId ~= nil and _____88C5_5907_6570_636E[rawId] or nil
            _____6DFB_52A0_6D4B_8BD5_7269_54C1_6280_80FDID(rawId, _____88C5_5907_9879 and _____88C5_5907_9879.abilList)
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #_____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E_8868 do
            local _____914D_7F6E = _____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E_8868[i + 1]
            if _____6D4B_8BD5_7269_54C1RawID_8868[_____914D_7F6E["物编ID"]] == true then
                local itemTypeId = stringToFourCCSafe(_____914D_7F6E["物编ID"])
                if itemTypeId ~= 0 then
                    _____6D4B_8BD5_7269_54C1_6280_80FDID_8868[itemTypeId] = {}
                end
                _____6DFB_52A0_6D4B_8BD5_7269_54C1_6280_80FDID(_____914D_7F6E["物编ID"], _____914D_7F6E["技能ID"])
                _____8BB0_5F55_6D4B_8BD5_7269_54C1_4E3B_52A8_6700_5927_51B7_5374(_____914D_7F6E["物编ID"], _____914D_7F6E["冷却时间"])
            end
            i = i + 1
        end
    end
end
local function _____5237_65B0_82F1_96C4_88C5_5907_51B7_5374(hero)
    if not _____662F_6709_6548_82F1_96C4(hero) then
        return 0
    end
    _____521D_59CB_5316_6D4B_8BD5_7269_54C1_6280_80FDID_8868()
    local _____5237_65B0_6570_91CF = 0
    do
        local _____69FD_4F4D = 0
        while _____69FD_4F4D < 6 do
            do
                local item = UnitItemInSlot(hero, _____69FD_4F4D)
                if item == nil or item == 0 then
                    goto __continue59
                end
                local itemTypeId = GetItemTypeId(item)
                local abilityIds = _____6D4B_8BD5_7269_54C1_6280_80FDID_8868[itemTypeId]
                local activeMaxSec = _____6D4B_8BD5_7269_54C1_4E3B_52A8_6700_5927_51B7_5374_79D2_8868[itemTypeId]
                _____5237_65B0_6570_91CF = _____5237_65B0_6570_91CF + _____5237_65B0_7269_54C1CD({
                    unit = hero,
                    item = item,
                    ["主动技能ID"] = abilityIds,
                    ["主动最大冷却秒数"] = activeMaxSec,
                    ["范围"] = "全部"
                })
            end
            ::__continue59::
            _____69FD_4F4D = _____69FD_4F4D + 1
        end
    end
    return _____5237_65B0_6570_91CF
end
local function ____on_804A_5929_5237_65B0_7269_54C1_51B7_5374(player, _command)
    if not _____662F_5141_8BB8_7269_54C1_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local heroes = _____6536_96C6_73A9_5BB6_82F1_96C4(player)
    if #heroes <= 0 then
        debugLogForce(_____6A21_5757_540D, "未找到红色测试玩家英雄")
        return
    end
    local _____5237_65B0_6570_91CF = 0
    do
        local i = 0
        while i < #heroes do
            _____5237_65B0_6570_91CF = _____5237_65B0_6570_91CF + _____5237_65B0_82F1_96C4_88C5_5907_51B7_5374(heroes[i + 1])
            i = i + 1
        end
    end
    debugLogForce(
        _____6A21_5757_540D,
        "已刷新测试物品冷却",
        "英雄数",
        #heroes,
        "技能数",
        _____5237_65B0_6570_91CF
    )
end
local function ____on_804A_5929_6302_8F7D_51CF_901F_6D4B_8BD5(player, _command)
    if not _____662F_5141_8BB8_7269_54C1_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local unit = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_5355_4F4D(player)
    if unit == nil or unit == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到红色测试玩家英雄")
        return
    end
    _____65BD_52A0_51CF_901F(unit, unit, 0.5, 12)
    debugLogForce(
        _____6A21_5757_540D,
        "已给测试英雄施加减速Buff",
        "持续秒数",
        12,
        "减速比例",
        0.5
    )
end
local function _____53D1_653E_5355_4E2A_88C5_5907(unit, _____5E8F_53F7)
    _____4E22_5F03_6D4B_8BD5_88C5_5907(unit)
    if _____5E8F_53F7 == 192 then
        local _____521B_5EFA_6570_91CF = 0
        local x = GetUnitX(unit)
        local y = GetUnitY(unit)
        do
            local i = 0
            while i < #_____7CBE_7075_836F_6C34_6D4B_8BD5_88C5_5907_5217_8868 do
                do
                    local _____88C5_5907_540D = _____7CBE_7075_836F_6C34_6D4B_8BD5_88C5_5907_5217_8868[i + 1]
                    local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
                    local itemTypeId = stringToFourCCSafe(rawId)
                    if itemTypeId == 0 then
                        debugLogForce(_____6A21_5757_540D, "未找到精灵药水ID", _____88C5_5907_540D)
                        goto __continue72
                    end
                    local item = CreateItem(itemTypeId, x, y)
                    if item == nil or item == 0 then
                        debugLogForce(
                            _____6A21_5757_540D,
                            "创建精灵药水失败",
                            _____88C5_5907_540D,
                            rawId,
                            itemTypeId
                        )
                        goto __continue72
                    end
                    UnitAddItem(unit, item)
                    _____521B_5EFA_6570_91CF = _____521B_5EFA_6570_91CF + 1
                end
                ::__continue72::
                i = i + 1
            end
        end
        debugLogForce(_____6A21_5757_540D, "已发放全部精灵药水", "创建数量", _____521B_5EFA_6570_91CF)
        return
    end
    if _____5E8F_53F7 > 0 and _____5E8F_53F7 <= #_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_53D1_653E_987A_5E8F then
        local _____88C5_5907_540D = _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_53D1_653E_987A_5E8F[_____5E8F_53F7]
        if _____53D1_653E_88C5_5907(unit, _____88C5_5907_540D) then
            debugLogForce(_____6A21_5757_540D, "已发放测试装备", _____5E8F_53F7, _____88C5_5907_540D)
        end
    end
end
local function ____on_804A_5929wp_6D4B_8BD5(player, command)
    if not _____662F_5141_8BB8_7269_54C1_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local unit = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_5355_4F4D(player)
    if unit == nil or unit == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到红色测试玩家英雄")
        return
    end
    if command == _____7CBE_7075_836F_6C34_5957_88C5_6D4B_8BD5_547D_4EE4 then
        _____53D1_653E_5355_4E2A_88C5_5907(unit, 192)
        return
    end
    do
        local i = 0
        while i < #_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_5217_8868 do
            if command == _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_5217_8868[i + 1] then
                _____53D1_653E_5355_4E2A_88C5_5907(unit, i + 1)
                return
            end
            i = i + 1
        end
    end
end
do
    local i = 0
    while i < #_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_5217_8868 do
        _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_5217_8868[i + 1], ____on_804A_5929wp_6D4B_8BD5)
        i = i + 1
    end
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____7CBE_7075_836F_6C34_5957_88C5_6D4B_8BD5_547D_4EE4, ____on_804A_5929wp_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____7269_54C1_51B7_5374_5237_65B0_547D_4EE4, ____on_804A_5929_5237_65B0_7269_54C1_51B7_5374)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____7269_54C1_8D1F_9762_6E05_9664_6D4B_8BD5_51CF_901F_547D_4EE4, ____on_804A_5929_6302_8F7D_51CF_901F_6D4B_8BD5)
if _____6253_5370_6CE8_518C_547D_4EE4_65E5_5FD7 then
    debugLogForce(
        _____6A21_5757_540D,
        "已注册测试命令",
        table.concat(_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_8BF4_660E_6587_672C_5217_8868, " | "),
        _____7269_54C1_51B7_5374_5237_65B0_547D_4EE4 .. "=刷新当前玩家英雄装备冷却",
        _____7269_54C1_8D1F_9762_6E05_9664_6D4B_8BD5_51CF_901F_547D_4EE4 .. "=给当前测试英雄挂减速Buff"
    )
end
return ____exports
