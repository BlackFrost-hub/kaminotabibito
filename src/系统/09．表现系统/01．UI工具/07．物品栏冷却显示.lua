--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local _____51B7_5374_6570_5B57_6587_672C_6A21_5757 = require("系统.09．表现系统.01．UI工具.06．冷却数字文本")
local _____521B_5EFA_51B7_5374_6570_5B57_6587_672C_7EC4 = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["创建冷却数字文本组"]
local _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C_951A_70B9 = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["设置冷却数字文本锚点"]
local _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["设置冷却数字文本"]
local _____663E_793A_51B7_5374_6570_5B57_6587_672C = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["显示冷却数字文本"]
local GetLocalPlayer = jass.GetLocalPlayer
local GetPlayerId = jass.GetPlayerId
local GetOwningPlayer = jass.GetOwningPlayer
local UnitItemInSlot = jass.UnitItemInSlot
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local DzGetGameUI = japi.DzGetGameUI
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzFrameGetItemBarButton = japi.DzFrameGetItemBarButton
local DzFrameClearAllPoints = japi.DzFrameClearAllPoints
local DzFrameSetAllPoints = japi.DzFrameSetAllPoints
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameShow = japi.DzFrameShow
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameSetModel = japi.DzFrameSetModel
local DzFrameSetAnimate = japi.DzFrameSetAnimate
local DzFrameSetAnimateOffset = japi.DzFrameSetAnimateOffset
local _____7269_54C1_680F_69FD_4F4D_6570_91CF = 6
local _____5237_65B0_95F4_9694_6BEB_79D2 = 100
local _____51B7_5374_8F6C_5708_6A21_578B = "UI\\Feedback\\Cooldown\\UI-Cooldown-Indicator.mdl"
local _____7269_54C1_51B7_5374_6570_5B57_5C42 = {{
    ["后缀"] = "Text",
    ["偏移X"] = 0,
    ["偏移Y"] = 0,
    ["颜色码"] = "fffff2d8",
    r = 255,
    g = 242,
    b = 216,
    a = 255,
    ["优先级偏移"] = 0
}}
local _____51B7_5374_8BB0_5F55_5217_8868 = {}
local _____69FD_4F4DUI_5217_8868 = {}
local _____5DF2_521D_59CB_5316 = false
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____5F53_524D_6BEB_79D2()
    return os:clock() * 1000
end
local function _____5355_4F4D_6709_6548(unit)
    return _____53E5_67C4_6709_6548(unit) and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____662F_5426_672C_5730_73A9_5BB6_5355_4F4D(unit)
    if not _____5355_4F4D_6709_6548(unit) then
        return false
    end
    local owner = GetOwningPlayer(unit)
    if not _____53E5_67C4_6709_6548(owner) then
        return false
    end
    return GetPlayerId(owner) == GetPlayerId(GetLocalPlayer())
end
local function _____67E5_627E_7269_54C1_6240_5728_69FD_4F4D(hero, targetItem)
    if not _____5355_4F4D_6709_6548(hero) or not _____53E5_67C4_6709_6548(targetItem) then
        return -1
    end
    do
        local slot = 0
        while slot < _____7269_54C1_680F_69FD_4F4D_6570_91CF do
            if UnitItemInSlot(hero, slot) == targetItem then
                return slot
            end
            slot = slot + 1
        end
    end
    return -1
end
local function _____683C_5F0F_5316_5269_4F59_79D2(_____5269_4F59_6BEB_79D2)
    if _____5269_4F59_6BEB_79D2 <= 0 then
        return ""
    end
    local _____5341_5206_79D2 = math:floor(_____5269_4F59_6BEB_79D2 / 100 + 0.999)
    local _____79D2 = math:floor(_____5341_5206_79D2 / 10)
    local _____5C0F_6570 = _____5341_5206_79D2 - _____79D2 * 10
    return (tostring(nil, _____79D2) .. ".") .. tostring(nil, _____5C0F_6570)
end
local function _____8BA1_7B97_51B7_5374_8F6C_5708_8FDB_5EA6(_____5269_4F59_6BEB_79D2, _____603B_6BEB_79D2)
    if _____603B_6BEB_79D2 <= 0 then
        return 0
    end
    local progress = 1 - _____5269_4F59_6BEB_79D2 / _____603B_6BEB_79D2
    if progress <= 0 then
        return 0
    end
    if progress >= 1 then
        return 0.9999
    end
    return progress
end
local function _____9690_85CF_69FD_4F4DUI(ui)
    if ui == nil then
        return
    end
    if ui["转圈框体"] ~= 0 then
        DzFrameSetAnimateOffset(ui["转圈框体"], 0)
        DzFrameShow(ui["转圈框体"], false)
    end
    _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(ui["数字文本组"], "")
    _____663E_793A_51B7_5374_6570_5B57_6587_672C(ui["数字文本组"], false)
end
local function _____9690_85CF_5168_90E8_69FD_4F4DUI()
    do
        local i = 0
        while i < _____7269_54C1_680F_69FD_4F4D_6570_91CF do
            _____9690_85CF_69FD_4F4DUI(_____69FD_4F4DUI_5217_8868[i + 1])
            i = i + 1
        end
    end
end
local function _____9690_85CF_7269_54C1_6240_5728_69FD_4F4DUI(hero, item)
    if not _____662F_5426_672C_5730_73A9_5BB6_5355_4F4D(hero) then
        return
    end
    local slot = _____67E5_627E_7269_54C1_6240_5728_69FD_4F4D(hero, item)
    if slot < 0 then
        return
    end
    _____9690_85CF_69FD_4F4DUI(_____69FD_4F4DUI_5217_8868[slot + 1])
end
local function _____786E_4FDD_69FD_4F4DUI(slot)
    local old = _____69FD_4F4DUI_5217_8868[slot + 1]
    if old ~= nil then
        return old
    end
    local root = DzGetGameUI()
    if not _____53E5_67C4_6709_6548(root) then
        return nil
    end
    local _____8F6C_5708_6846_4F53 = DzCreateFrameByTagName(
        "SPRITE",
        "ItemBarCooldownSprite_" .. tostring(slot),
        root,
        "template",
        0
    )
    local _____6570_5B57_6587_672C_7EC4 = _____521B_5EFA_51B7_5374_6570_5B57_6587_672C_7EC4({
        ["名称前缀"] = ("ItemBarCooldownText_" .. tostring(slot)) .. "_",
        ["父级"] = root,
        ["宽度"] = 0.042,
        ["高度"] = 0.02,
        ["字体大小"] = 0.02,
        ["优先级"] = 9001,
        ["对齐"] = 18,
        ["层"] = _____7269_54C1_51B7_5374_6570_5B57_5C42
    })
    if not _____53E5_67C4_6709_6548(_____8F6C_5708_6846_4F53) or _____6570_5B57_6587_672C_7EC4 == nil then
        return nil
    end
    DzFrameSetModel(_____8F6C_5708_6846_4F53, _____51B7_5374_8F6C_5708_6A21_578B, 0, 0)
    DzFrameSetAnimate(_____8F6C_5708_6846_4F53, 0, false)
    DzFrameSetAnimateOffset(_____8F6C_5708_6846_4F53, 0)
    DzFrameSetPriority(_____8F6C_5708_6846_4F53, 9000)
    DzFrameSetSize(_____8F6C_5708_6846_4F53, 0.032, 0.032)
    DzFrameShow(_____8F6C_5708_6846_4F53, false)
    _____663E_793A_51B7_5374_6570_5B57_6587_672C(_____6570_5B57_6587_672C_7EC4, false)
    local ui = {["转圈框体"] = _____8F6C_5708_6846_4F53, ["数字文本组"] = _____6570_5B57_6587_672C_7EC4}
    _____69FD_4F4DUI_5217_8868[slot + 1] = ui
    return ui
end
local function _____5237_65B0_7269_54C1_680F_51B7_5374_663E_793A()
    local now = _____5F53_524D_6BEB_79D2()
    local writeIndex = 0
    _____9690_85CF_5168_90E8_69FD_4F4DUI()
    do
        local i = 0
        while i < #_____51B7_5374_8BB0_5F55_5217_8868 do
            do
                local record = _____51B7_5374_8BB0_5F55_5217_8868[i + 1]
                local remaining = record["结束毫秒"] - now
                if remaining <= 0 or not _____5355_4F4D_6709_6548(record.hero) or not _____53E5_67C4_6709_6548(record.item) then
                    goto __continue34
                end
                _____51B7_5374_8BB0_5F55_5217_8868[writeIndex + 1] = record
                writeIndex = writeIndex + 1
                if not _____662F_5426_672C_5730_73A9_5BB6_5355_4F4D(record.hero) then
                    goto __continue34
                end
                local slot = _____67E5_627E_7269_54C1_6240_5728_69FD_4F4D(record.hero, record.item)
                if slot < 0 then
                    goto __continue34
                end
                local button = DzFrameGetItemBarButton(slot)
                local ui = _____786E_4FDD_69FD_4F4DUI(slot)
                if not _____53E5_67C4_6709_6548(button) or ui == nil then
                    goto __continue34
                end
                DzFrameClearAllPoints(ui["转圈框体"])
                DzFrameSetAllPoints(ui["转圈框体"], button)
                DzFrameSetAnimateOffset(
                    ui["转圈框体"],
                    _____8BA1_7B97_51B7_5374_8F6C_5708_8FDB_5EA6(remaining, record["总毫秒"])
                )
                _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C_951A_70B9(
                    ui["数字文本组"],
                    button,
                    4,
                    4,
                    0,
                    0
                )
                _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(
                    ui["数字文本组"],
                    _____683C_5F0F_5316_5269_4F59_79D2(remaining)
                )
                DzFrameShow(ui["转圈框体"], true)
                _____663E_793A_51B7_5374_6570_5B57_6587_672C(ui["数字文本组"], true)
            end
            ::__continue34::
            i = i + 1
        end
    end
    do
        local i = #_____51B7_5374_8BB0_5F55_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____51B7_5374_8BB0_5F55_5217_8868)
            i = i - 1
        end
    end
end
____exports["初始化物品栏冷却显示"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    addPeriodicCallback(_____5237_65B0_95F4_9694_6BEB_79D2, _____5237_65B0_7269_54C1_680F_51B7_5374_663E_793A)
end
____exports["显示物品栏物品冷却"] = function(hero, item, durationMs)
    if not _____5355_4F4D_6709_6548(hero) or not _____53E5_67C4_6709_6548(item) or durationMs <= 0 then
        return
    end
    ____exports["初始化物品栏冷却显示"]()
    local now = _____5F53_524D_6BEB_79D2()
    local nextEnd = now + durationMs
    do
        local i = 0
        while i < #_____51B7_5374_8BB0_5F55_5217_8868 do
            local record = _____51B7_5374_8BB0_5F55_5217_8868[i + 1]
            if record.item == item then
                record.hero = hero
                if nextEnd > record["结束毫秒"] then
                    record["结束毫秒"] = nextEnd
                    record["总毫秒"] = durationMs
                end
                return
            end
            i = i + 1
        end
    end
    _____51B7_5374_8BB0_5F55_5217_8868[#_____51B7_5374_8BB0_5F55_5217_8868 + 1] = {hero = hero, item = item, ["结束毫秒"] = nextEnd, ["总毫秒"] = durationMs}
end
____exports["设置物品栏物品冷却"] = function(hero, item, durationMs)
    if not _____53E5_67C4_6709_6548(item) then
        return
    end
    ____exports["初始化物品栏冷却显示"]()
    if durationMs <= 0 then
        _____9690_85CF_7269_54C1_6240_5728_69FD_4F4DUI(hero, item)
        local writeIndex = 0
        do
            local i = 0
            while i < #_____51B7_5374_8BB0_5F55_5217_8868 do
                do
                    local record = _____51B7_5374_8BB0_5F55_5217_8868[i + 1]
                    if record.item == item then
                        goto __continue53
                    end
                    _____51B7_5374_8BB0_5F55_5217_8868[writeIndex + 1] = record
                    writeIndex = writeIndex + 1
                end
                ::__continue53::
                i = i + 1
            end
        end
        do
            local i = #_____51B7_5374_8BB0_5F55_5217_8868 - 1
            while i >= writeIndex do
                table.remove(_____51B7_5374_8BB0_5F55_5217_8868)
                i = i - 1
            end
        end
        _____5237_65B0_7269_54C1_680F_51B7_5374_663E_793A()
        _____9690_85CF_7269_54C1_6240_5728_69FD_4F4DUI(hero, item)
        return
    end
    if not _____5355_4F4D_6709_6548(hero) then
        return
    end
    local now = _____5F53_524D_6BEB_79D2()
    local nextEnd = now + durationMs
    do
        local i = 0
        while i < #_____51B7_5374_8BB0_5F55_5217_8868 do
            local record = _____51B7_5374_8BB0_5F55_5217_8868[i + 1]
            if record.item == item then
                record.hero = hero
                record["结束毫秒"] = nextEnd
                record["总毫秒"] = durationMs
                _____5237_65B0_7269_54C1_680F_51B7_5374_663E_793A()
                return
            end
            i = i + 1
        end
    end
    _____51B7_5374_8BB0_5F55_5217_8868[#_____51B7_5374_8BB0_5F55_5217_8868 + 1] = {hero = hero, item = item, ["结束毫秒"] = nextEnd, ["总毫秒"] = durationMs}
    _____5237_65B0_7269_54C1_680F_51B7_5374_663E_793A()
end
____exports["清除物品栏物品冷却"] = function(hero, item)
    ____exports["设置物品栏物品冷却"](hero, item, 0)
end
return ____exports
