local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayFlatMap = ____lualib.__TS__ArrayFlatMap
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_516C_5F0F_914D_7F6E = require("系统.03．技能系统.07．动态技能文本.01．公式配置")
local _____5C5E_6027_540D_79F0_5217_8868 = ____01_FF0E_516C_5F0F_914D_7F6E["属性名称列表"]
local _____52A8_6001_6587_672C_767D_540D_5355 = ____01_FF0E_516C_5F0F_914D_7F6E["动态文本白名单"]
local _____52A8_6001_6587_672C_8DF3_8FC7_7247_6BB5_5217_8868 = ____01_FF0E_516C_5F0F_914D_7F6E["动态文本跳过片段列表"]
local _____52A8_6001_6587_672C_5C5E_6027_522B_540D_8868 = ____01_FF0E_516C_5F0F_914D_7F6E["动态文本属性别名表"]
local _____52A8_6001_6587_672C_589E_51CF_7C7B_524D_7F00_5217_8868 = ____01_FF0E_516C_5F0F_914D_7F6E["动态文本增减类前缀列表"]
local _____52A8_6001_6587_672C_76EE_6807_7C7B_524D_7F00_5217_8868 = ____01_FF0E_516C_5F0F_914D_7F6E["动态文本目标类前缀列表"]
local ____02_FF0E_5C5E_6027_8BA1_7B97 = require("系统.03．技能系统.07．动态技能文本.02．属性计算")
local _____8BA1_7B97_516C_5F0F_4F24_5BB3 = ____02_FF0E_5C5E_6027_8BA1_7B97["计算公式伤害"]
--- 动态技能文本 - 核心业务逻辑
-- 
-- 遍历本地玩家选中单位的命令卡技能，动态替换描述中的公式为实际伤害数值
local jass = require("jass.common")
local japi = require("jass.japi")
local selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_0.debugLog
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetHandleId = jass.GetHandleId
local DzGetUnitAbilityUberTip = japi.DzGetUnitAbilityUberTip
local DzSetUnitAbilityUberTip = japi.DzSetUnitAbilityUberTip
local DzSetUnitAbilityUpdate = japi.DzSetUnitAbilityUpdate
local MODULE_NAME = "动态技能文本"
local _____5355_5C5E_6027_6700_5927_66FF_6362_6B21_6570 = 8
local _____539F_59CB_63D0_793A_7F13_5B58 = {}
local _____5DF2_5904_7406_6280_80FD_7F13_5B58 = {}
local _____6392_5E8F_5C5E_6027_5339_914D_9879_5217_8868 = __TS__ArraySort(
    __TS__ArrayFlatMap(
        __TS__ArrayFilter(
            _____5C5E_6027_540D_79F0_5217_8868,
            function(self, _____5C5E_6027_540D)
                return __TS__ArrayIndexOf(_____52A8_6001_6587_672C_767D_540D_5355, _____5C5E_6027_540D) >= 0
            end
        ),
        function(self, _____5C5E_6027_540D)
            local _____5339_914D_9879_5217_8868 = {{["文本名"] = _____5C5E_6027_540D, ["计算属性名"] = _____5C5E_6027_540D}}
            local _____522B_540D_5217_8868 = _____52A8_6001_6587_672C_5C5E_6027_522B_540D_8868[_____5C5E_6027_540D]
            if _____522B_540D_5217_8868 ~= nil then
                do
                    local i = 0
                    while i < #_____522B_540D_5217_8868 do
                        _____5339_914D_9879_5217_8868[#_____5339_914D_9879_5217_8868 + 1] = {["文本名"] = _____522B_540D_5217_8868[i + 1], ["计算属性名"] = _____5C5E_6027_540D}
                        i = i + 1
                    end
                end
            end
            return _____5339_914D_9879_5217_8868
        end
    ),
    function(____, a, b) return #b["文本名"] - #a["文本名"] end
)
local _____589E_51CF_7C7B_5C5E_6027_663E_793A_540D_8868 = {
    ["攻击力"] = "点攻击力",
    ["生命值"] = "点生命值",
    ["最大生命值"] = "点生命值",
    ["魔法值"] = "点魔法值",
    ["最大魔法值"] = "点魔法值"
}
local function isValidHandle(handle)
    return handle ~= nil and handle ~= 0
end
local function _____662F_5426_4E3A_589E_51CF_7C7B_8BED_5883(text, _____5339_914D_5F00_59CB)
    do
        local i = 0
        while i < #_____52A8_6001_6587_672C_589E_51CF_7C7B_524D_7F00_5217_8868 do
            do
                local _____524D_7F00 = _____52A8_6001_6587_672C_589E_51CF_7C7B_524D_7F00_5217_8868[i + 1]
                local _____524D_7F00_5F00_59CB = _____5339_914D_5F00_59CB - #_____524D_7F00
                if _____524D_7F00_5F00_59CB < 0 then
                    goto __continue11
                end
                if __TS__StringSubstring(text, _____524D_7F00_5F00_59CB, _____5339_914D_5F00_59CB) == _____524D_7F00 then
                    return true
                end
            end
            ::__continue11::
            i = i + 1
        end
    end
    return false
end
local function _____662F_5426_4E3A_76EE_6807_7C7B_8BED_5883(text, _____5339_914D_5F00_59CB)
    do
        local i = 0
        while i < #_____52A8_6001_6587_672C_76EE_6807_7C7B_524D_7F00_5217_8868 do
            do
                local _____524D_7F00 = _____52A8_6001_6587_672C_76EE_6807_7C7B_524D_7F00_5217_8868[i + 1]
                local _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB - #_____524D_7F00 - 2
                if _____641C_7D22_8D77_70B9 < 0 then
                    goto __continue16
                end
                local _____7247_6BB5 = __TS__StringSubstring(text, _____641C_7D22_8D77_70B9, _____5339_914D_5F00_59CB)
                if (string.find(_____7247_6BB5, _____524D_7F00, nil, true) or 0) - 1 >= 0 then
                    return true
                end
            end
            ::__continue16::
            i = i + 1
        end
    end
    return false
end
local function _____662F_5426_4E3A_81EA_8EAB_7C7B_8BED_5883(text, _____5339_914D_5F00_59CB)
    local _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB - 8
    local _____8D77_70B9 = _____641C_7D22_8D77_70B9 > 0 and _____641C_7D22_8D77_70B9 or 0
    local _____7247_6BB5 = __TS__StringSubstring(text, _____8D77_70B9, _____5339_914D_5F00_59CB)
    return (string.find(_____7247_6BB5, "自身", nil, true) or 0) - 1 >= 0
end
local function _____83B7_53D6_5339_914D_524D_7A97_53E3(text, _____5339_914D_5F00_59CB)
    local _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB - 10
    local _____8D77_70B9 = _____641C_7D22_8D77_70B9 > 0 and _____641C_7D22_8D77_70B9 or 0
    return __TS__StringSubstring(text, _____8D77_70B9, _____5339_914D_5F00_59CB)
end
local function _____662F_5426_547D_4E2D_8DF3_8FC7_7247_6BB5(text)
    do
        local i = 0
        while i < #_____52A8_6001_6587_672C_8DF3_8FC7_7247_6BB5_5217_8868 do
            if (string.find(text, _____52A8_6001_6587_672C_8DF3_8FC7_7247_6BB5_5217_8868[i + 1], nil, true) or 0) - 1 >= 0 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____83B7_53D6_589E_51CF_7C7B_663E_793A_6587_672C(_____5C5E_6027_5339_914D_9879, _____6570_503C_6587_672C)
    local _____663E_793A_540D = _____589E_51CF_7C7B_5C5E_6027_663E_793A_540D_8868[_____5C5E_6027_5339_914D_9879["计算属性名"]]
    if _____663E_793A_540D ~= nil then
        return _____6570_503C_6587_672C .. _____663E_793A_540D
    end
    return (_____6570_503C_6587_672C .. "点") .. _____5C5E_6027_5339_914D_9879["文本名"]
end
local function _____83B7_53D6_5FEB_7167_6280_80FD_5217_8868(hero)
    local ids = {}
    local seen = {}
    local _____5FEB_7167 = selectionSnapshotSystem["获取本地选中技能快照"]()
    if not isValidHandle(hero) or _____5FEB_7167.hero ~= hero then
        return ids
    end
    local _____6280_80FD_70ED_952E_5217_8868 = {
        "Q",
        "W",
        "E",
        "R",
        "D"
    }
    do
        local i = 0
        while i < #_____6280_80FD_70ED_952E_5217_8868 do
            do
                local abilityId = _____5FEB_7167.skills[_____6280_80FD_70ED_952E_5217_8868[i + 1]]
                if abilityId == nil or abilityId == 0 or seen[abilityId] == true then
                    goto __continue30
                end
                seen[abilityId] = true
                ids[#ids + 1] = abilityId
            end
            ::__continue30::
            i = i + 1
        end
    end
    return ids
end
local function _____751F_6210_63D0_793A_7F13_5B58_952E(unit, abilityId)
    return (tostring(GetHandleId(unit)) .. ":") .. tostring(abilityId)
end
local function _____751F_6210_82F1_96C4_7F13_5B58_952E(unit)
    return tostring(GetHandleId(unit))
end
--- 从指定位置读取倍率字符串
-- 例如："3"、"50%"
local function _____63D0_53D6_500D_7387(text, _____6570_5B57_8D77_59CB)
    local _____6570_5B57_7ED3_675F = _____6570_5B57_8D77_59CB
    while _____6570_5B57_7ED3_675F < #text do
        local _____5B57_7B26 = __TS__StringCharAt(text, _____6570_5B57_7ED3_675F)
        if _____5B57_7B26 >= "0" and _____5B57_7B26 <= "9" or _____5B57_7B26 == "." then
            _____6570_5B57_7ED3_675F = _____6570_5B57_7ED3_675F + 1
        elseif _____5B57_7B26 == "%" then
            _____6570_5B57_7ED3_675F = _____6570_5B57_7ED3_675F + 1
            break
        else
            break
        end
    end
    if _____6570_5B57_7ED3_675F == _____6570_5B57_8D77_59CB then
        return nil
    end
    return __TS__StringSubstring(text, _____6570_5B57_8D77_59CB, _____6570_5B57_7ED3_675F)
end
local function _____67E5_627E_6700_540E_5339_914D_4F4D_7F6E(text, pattern, beforeIndex)
    local _____547D_4E2D_4F4D_7F6E = -1
    local _____641C_7D22_4F4D_7F6E = (string.find(text, pattern, nil, true) or 0) - 1
    while _____641C_7D22_4F4D_7F6E >= 0 and _____641C_7D22_4F4D_7F6E < beforeIndex do
        _____547D_4E2D_4F4D_7F6E = _____641C_7D22_4F4D_7F6E
        _____641C_7D22_4F4D_7F6E = (string.find(
            text,
            pattern,
            math.max(_____641C_7D22_4F4D_7F6E + #pattern + 1, 1),
            true
        ) or 0) - 1
    end
    return _____547D_4E2D_4F4D_7F6E
end
local function _____8C03_6574_524D_7F00_500D_7387_8D77_70B9_907F_5F00_989C_8272_7801(text, _____6570_5B57_8D77_59CB, _____5C5E_6027_4F4D_7F6E)
    local _____989C_8272_8D77_59CB = _____67E5_627E_6700_540E_5339_914D_4F4D_7F6E(text, "|cff", _____5C5E_6027_4F4D_7F6E)
    if _____989C_8272_8D77_59CB < 0 then
        return _____6570_5B57_8D77_59CB
    end
    local _____989C_8272_7ED3_675F = _____989C_8272_8D77_59CB + 10
    if _____989C_8272_7ED3_675F <= _____6570_5B57_8D77_59CB or _____989C_8272_7ED3_675F >= _____5C5E_6027_4F4D_7F6E then
        return _____6570_5B57_8D77_59CB
    end
    local _____989C_8272_503C = __TS__StringSubstring(text, _____989C_8272_8D77_59CB + 2, _____989C_8272_7ED3_675F)
    do
        local i = 0
        while i < #_____989C_8272_503C do
            local _____5B57_7B26 = __TS__StringCharAt(_____989C_8272_503C, i)
            local _____662F_6570_5B57 = _____5B57_7B26 >= "0" and _____5B57_7B26 <= "9"
            local _____662F_5C0F_5199_5341_516D_8FDB_5236_5B57_6BCD = _____5B57_7B26 >= "a" and _____5B57_7B26 <= "f"
            local _____662F_5927_5199_5341_516D_8FDB_5236_5B57_6BCD = _____5B57_7B26 >= "A" and _____5B57_7B26 <= "F"
            if not _____662F_6570_5B57 and not _____662F_5C0F_5199_5341_516D_8FDB_5236_5B57_6BCD and not _____662F_5927_5199_5341_516D_8FDB_5236_5B57_6BCD then
                return _____6570_5B57_8D77_59CB
            end
            i = i + 1
        end
    end
    local _____6700_8FD1_91CD_7F6E = _____67E5_627E_6700_540E_5339_914D_4F4D_7F6E(text, "|r", _____5C5E_6027_4F4D_7F6E)
    if _____6700_8FD1_91CD_7F6E > _____989C_8272_8D77_59CB then
        return _____6570_5B57_8D77_59CB
    end
    return _____989C_8272_7ED3_675F
end
local function _____63D0_53D6_524D_7F00_500D_7387_5339_914D(text, _____5C5E_6027_6587_672C_540D, _____8D77_59CB_4F4D_7F6E)
    local _____5C5E_6027_4F4D_7F6E = (string.find(
        text,
        _____5C5E_6027_6587_672C_540D,
        math.max(_____8D77_59CB_4F4D_7F6E + 1, 1),
        true
    ) or 0) - 1
    while _____5C5E_6027_4F4D_7F6E >= 0 do
        local _____6570_5B57_8D77_59CB = _____5C5E_6027_4F4D_7F6E
        while _____6570_5B57_8D77_59CB > 0 do
            local _____5B57_7B26 = __TS__StringCharAt(text, _____6570_5B57_8D77_59CB - 1)
            if _____5B57_7B26 >= "0" and _____5B57_7B26 <= "9" or _____5B57_7B26 == "." or _____5B57_7B26 == "%" then
                _____6570_5B57_8D77_59CB = _____6570_5B57_8D77_59CB - 1
            else
                break
            end
        end
        if _____6570_5B57_8D77_59CB < _____5C5E_6027_4F4D_7F6E then
            _____6570_5B57_8D77_59CB = _____8C03_6574_524D_7F00_500D_7387_8D77_70B9_907F_5F00_989C_8272_7801(text, _____6570_5B57_8D77_59CB, _____5C5E_6027_4F4D_7F6E)
            local _____5B8C_6574_5339_914D_5F00_59CB = _____6570_5B57_8D77_59CB
            if _____6570_5B57_8D77_59CB >= 2 and __TS__StringSubstring(text, _____6570_5B57_8D77_59CB - 2, _____6570_5B57_8D77_59CB) == "自身" then
                _____5B8C_6574_5339_914D_5F00_59CB = _____6570_5B57_8D77_59CB - 2
            end
            local _____500D_7387 = __TS__StringSubstring(text, _____6570_5B57_8D77_59CB, _____5C5E_6027_4F4D_7F6E)
            local _____672B_5B57_7B26 = __TS__StringCharAt(_____500D_7387, #_____500D_7387 - 1)
            local _____542B_6570_5B57 = false
            do
                local i = 0
                while i < #_____500D_7387 do
                    local _____5B57_7B26 = __TS__StringCharAt(_____500D_7387, i)
                    if _____5B57_7B26 >= "0" and _____5B57_7B26 <= "9" then
                        _____542B_6570_5B57 = true
                        break
                    end
                    i = i + 1
                end
            end
            if _____542B_6570_5B57 and (_____672B_5B57_7B26 == "%" or _____672B_5B57_7B26 >= "0" and _____672B_5B57_7B26 <= "9" or _____672B_5B57_7B26 == ".") then
                return {
                    ["完整匹配"] = __TS__StringSubstring(text, _____5B8C_6574_5339_914D_5F00_59CB, _____5C5E_6027_4F4D_7F6E + #_____5C5E_6027_6587_672C_540D),
                    ["倍率"] = _____500D_7387,
                    ["开始位置"] = _____5B8C_6574_5339_914D_5F00_59CB
                }
            end
        end
        _____5C5E_6027_4F4D_7F6E = (string.find(
            text,
            _____5C5E_6027_6587_672C_540D,
            math.max(_____5C5E_6027_4F4D_7F6E + #_____5C5E_6027_6587_672C_540D + 1, 1),
            true
        ) or 0) - 1
    end
    return nil
end
--- 提取一个可替换的公式片段
-- 支持：
-- 1. 属性名×数字 / 属性名×数字%
-- 2. 属性名数字 / 属性名数字%
local function _____63D0_53D6_516C_5F0F_5339_914D(text, _____5C5E_6027_6587_672C_540D, _____8D77_59CB_4F4D_7F6E)
    local _____4E58_53F7_524D_7F00 = _____5C5E_6027_6587_672C_540D .. "×"
    local _____4E58_53F7_4F4D_7F6E = (string.find(
        text,
        _____4E58_53F7_524D_7F00,
        math.max(_____8D77_59CB_4F4D_7F6E + 1, 1),
        true
    ) or 0) - 1
    if _____4E58_53F7_4F4D_7F6E >= 0 then
        local _____500D_7387 = _____63D0_53D6_500D_7387(text, _____4E58_53F7_4F4D_7F6E + #_____4E58_53F7_524D_7F00)
        if _____500D_7387 ~= nil then
            return {["完整匹配"] = _____4E58_53F7_524D_7F00 .. _____500D_7387, ["倍率"] = _____500D_7387, ["开始位置"] = _____4E58_53F7_4F4D_7F6E}
        end
    end
    local _____5C5E_6027_4F4D_7F6E = (string.find(
        text,
        _____5C5E_6027_6587_672C_540D,
        math.max(_____8D77_59CB_4F4D_7F6E + 1, 1),
        true
    ) or 0) - 1
    while _____5C5E_6027_4F4D_7F6E >= 0 do
        local _____6570_5B57_8D77_59CB = _____5C5E_6027_4F4D_7F6E + #_____5C5E_6027_6587_672C_540D
        local _____9996_5B57_7B26 = _____6570_5B57_8D77_59CB < #text and __TS__StringCharAt(text, _____6570_5B57_8D77_59CB) or ""
        if _____9996_5B57_7B26 >= "0" and _____9996_5B57_7B26 <= "9" or _____9996_5B57_7B26 == "." then
            local _____500D_7387 = _____63D0_53D6_500D_7387(text, _____6570_5B57_8D77_59CB)
            if _____500D_7387 ~= nil then
                return {["完整匹配"] = _____5C5E_6027_6587_672C_540D .. _____500D_7387, ["倍率"] = _____500D_7387, ["开始位置"] = _____5C5E_6027_4F4D_7F6E}
            end
        end
        _____5C5E_6027_4F4D_7F6E = (string.find(
            text,
            _____5C5E_6027_6587_672C_540D,
            math.max(_____5C5E_6027_4F4D_7F6E + #_____5C5E_6027_6587_672C_540D + 1, 1),
            true
        ) or 0) - 1
    end
    return _____63D0_53D6_524D_7F00_500D_7387_5339_914D(text, _____5C5E_6027_6587_672C_540D, _____8D77_59CB_4F4D_7F6E)
end
--- 动态替换技能提示中的公式
-- 例如：智力×3 -> 150（假设英雄智力50）
local function _____66FF_6362_516C_5F0F(unit, tip)
    if _____662F_5426_547D_4E2D_8DF3_8FC7_7247_6BB5(tip) then
        return tip
    end
    local result = tip
    do
        local i = 0
        while i < #_____6392_5E8F_5C5E_6027_5339_914D_9879_5217_8868 do
            local _____5C5E_6027_5339_914D_9879 = _____6392_5E8F_5C5E_6027_5339_914D_9879_5217_8868[i + 1]
            local _____641C_7D22_8D77_70B9 = 0
            local _____5339_914D_7ED3_679C = _____63D0_53D6_516C_5F0F_5339_914D(result, _____5C5E_6027_5339_914D_9879["文本名"], _____641C_7D22_8D77_70B9)
            local _____66FF_6362_6B21_6570 = 0
            while _____5339_914D_7ED3_679C ~= nil do
                do
                    local _____5339_914D_5F00_59CB = _____5339_914D_7ED3_679C["开始位置"]
                    if _____5339_914D_5F00_59CB < 0 then
                        break
                    end
                    local _____5B8C_6574_5339_914D_6587_672C = _____5339_914D_7ED3_679C["完整匹配"]
                    local _____5339_914D_524D_7A97_53E3 = _____83B7_53D6_5339_914D_524D_7A97_53E3(result, _____5339_914D_5F00_59CB)
                    if (string.find(_____5B8C_6574_5339_914D_6587_672C, "自身", nil, true) or 0) - 1 < 0 and _____5339_914D_5F00_59CB >= 2 and __TS__StringSubstring(result, _____5339_914D_5F00_59CB - 2, _____5339_914D_5F00_59CB) == "自身" then
                        _____5339_914D_5F00_59CB = _____5339_914D_5F00_59CB - 2
                        _____5B8C_6574_5339_914D_6587_672C = "自身" .. _____5B8C_6574_5339_914D_6587_672C
                    end
                    if ((string.find(_____5B8C_6574_5339_914D_6587_672C, "目标", nil, true) or 0) - 1 >= 0 or (string.find(_____5339_914D_524D_7A97_53E3, "目标", nil, true) or 0) - 1 >= 0) and (string.find(_____5B8C_6574_5339_914D_6587_672C, "自身", nil, true) or 0) - 1 < 0 and (string.find(_____5339_914D_524D_7A97_53E3, "自身", nil, true) or 0) - 1 < 0 then
                        _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB + #_____5B8C_6574_5339_914D_6587_672C
                        _____5339_914D_7ED3_679C = _____63D0_53D6_516C_5F0F_5339_914D(result, _____5C5E_6027_5339_914D_9879["文本名"], _____641C_7D22_8D77_70B9)
                        goto __continue70
                    end
                    if _____662F_5426_4E3A_589E_51CF_7C7B_8BED_5883(result, _____5339_914D_5F00_59CB) then
                        _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB + #_____5B8C_6574_5339_914D_6587_672C
                        _____5339_914D_7ED3_679C = _____63D0_53D6_516C_5F0F_5339_914D(result, _____5C5E_6027_5339_914D_9879["文本名"], _____641C_7D22_8D77_70B9)
                        goto __continue70
                    end
                    if _____662F_5426_4E3A_76EE_6807_7C7B_8BED_5883(result, _____5339_914D_5F00_59CB) and not _____662F_5426_4E3A_81EA_8EAB_7C7B_8BED_5883(result, _____5339_914D_5F00_59CB) then
                        _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB + #_____5B8C_6574_5339_914D_6587_672C
                        _____5339_914D_7ED3_679C = _____63D0_53D6_516C_5F0F_5339_914D(result, _____5C5E_6027_5339_914D_9879["文本名"], _____641C_7D22_8D77_70B9)
                        goto __continue70
                    end
                    local _____4F24_5BB3 = _____8BA1_7B97_516C_5F0F_4F24_5BB3(unit, _____5C5E_6027_5339_914D_9879["计算属性名"], _____5339_914D_7ED3_679C["倍率"])
                    local _____66FF_6362_503C = tostring(_____4F24_5BB3)
                    result = (__TS__StringSubstring(result, 0, _____5339_914D_5F00_59CB) .. _____66FF_6362_503C) .. __TS__StringSubstring(result, _____5339_914D_5F00_59CB + #_____5B8C_6574_5339_914D_6587_672C)
                    _____66FF_6362_6B21_6570 = _____66FF_6362_6B21_6570 + 1
                    if _____66FF_6362_6B21_6570 >= _____5355_5C5E_6027_6700_5927_66FF_6362_6B21_6570 then
                        debugLog(nil, MODULE_NAME, "单属性替换达到上限，提前中止", _____5C5E_6027_5339_914D_9879["文本名"])
                        break
                    end
                    _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB + #_____66FF_6362_503C
                    _____5339_914D_7ED3_679C = _____63D0_53D6_516C_5F0F_5339_914D(result, _____5C5E_6027_5339_914D_9879["文本名"], _____641C_7D22_8D77_70B9)
                end
                ::__continue70::
            end
            i = i + 1
        end
    end
    return result
end
--- 处理单个技能的提示文本
local function _____5904_7406_6280_80FD_63D0_793A(unit, abilityId)
    local currentTip = DzGetUnitAbilityUberTip(unit, abilityId)
    if not currentTip then
        return false
    end
    local _____7F13_5B58_952E = _____751F_6210_63D0_793A_7F13_5B58_952E(unit, abilityId)
    local originalTip = _____539F_59CB_63D0_793A_7F13_5B58[_____7F13_5B58_952E]
    if originalTip == nil then
        originalTip = currentTip
        _____539F_59CB_63D0_793A_7F13_5B58[_____7F13_5B58_952E] = originalTip
    end
    local newTip = _____66FF_6362_516C_5F0F(unit, originalTip)
    if newTip ~= currentTip then
        DzSetUnitAbilityUberTip(unit, abilityId, newTip)
        DzSetUnitAbilityUpdate(unit, abilityId)
        return true
    end
    return false
end
local function _____6062_590D_5355_4E2A_6280_80FD_539F_59CB_6587_672C(unit, abilityId)
    local originalTip = _____539F_59CB_63D0_793A_7F13_5B58[_____751F_6210_63D0_793A_7F13_5B58_952E(unit, abilityId)]
    if not originalTip then
        return false
    end
    local currentTip = DzGetUnitAbilityUberTip(unit, abilityId)
    if currentTip == originalTip then
        return false
    end
    DzSetUnitAbilityUberTip(unit, abilityId, originalTip)
    DzSetUnitAbilityUpdate(unit, abilityId)
    return true
end
--- 检查本地主控单位的命令卡技能
____exports["检查英雄技能"] = function(hero)
    if not isValidHandle(hero) then
        return
    end
    local abilityIds = _____83B7_53D6_5FEB_7167_6280_80FD_5217_8868(hero)
    _____5DF2_5904_7406_6280_80FD_7F13_5B58[_____751F_6210_82F1_96C4_7F13_5B58_952E(hero)] = abilityIds
    do
        local i = 0
        while i < #abilityIds do
            local level = GetUnitAbilityLevel(hero, abilityIds[i + 1])
            if level > 0 then
                _____5904_7406_6280_80FD_63D0_793A(hero, abilityIds[i + 1])
            end
            i = i + 1
        end
    end
end
____exports["恢复英雄技能原始文本"] = function(hero)
    if not isValidHandle(hero) then
        return
    end
    local abilityIds = _____5DF2_5904_7406_6280_80FD_7F13_5B58[_____751F_6210_82F1_96C4_7F13_5B58_952E(hero)] or _____83B7_53D6_5FEB_7167_6280_80FD_5217_8868(hero)
    do
        local i = 0
        while i < #abilityIds do
            _____6062_590D_5355_4E2A_6280_80FD_539F_59CB_6587_672C(hero, abilityIds[i + 1])
            i = i + 1
        end
    end
    __TS__Delete(
        _____5DF2_5904_7406_6280_80FD_7F13_5B58,
        _____751F_6210_82F1_96C4_7F13_5B58_952E(hero)
    )
end
return ____exports
