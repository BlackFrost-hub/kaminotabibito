local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayFlatMap = ____lualib.__TS__ArrayFlatMap
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringReplace = ____lualib.__TS__StringReplace
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____63D0_53D6_500D_7387
local ____01_FF0E_516C_5F0F_914D_7F6E = require("系统.03．技能系统.07．动态技能文本.01．公式配置")
local _____5C5E_6027_540D_79F0_5217_8868 = ____01_FF0E_516C_5F0F_914D_7F6E["属性名称列表"]
local _____52A8_6001_6587_672C_767D_540D_5355 = ____01_FF0E_516C_5F0F_914D_7F6E["动态文本白名单"]
local _____52A8_6001_6587_672C_8DF3_8FC7_7247_6BB5_5217_8868 = ____01_FF0E_516C_5F0F_914D_7F6E["动态文本跳过片段列表"]
local _____52A8_6001_6587_672C_5C5E_6027_522B_540D_8868 = ____01_FF0E_516C_5F0F_914D_7F6E["动态文本属性别名表"]
local _____52A8_6001_6587_672C_589E_51CF_7C7B_524D_7F00_5217_8868 = ____01_FF0E_516C_5F0F_914D_7F6E["动态文本增减类前缀列表"]
local _____52A8_6001_6587_672C_76EE_6807_7C7B_524D_7F00_5217_8868 = ____01_FF0E_516C_5F0F_914D_7F6E["动态文本目标类前缀列表"]
local ____02_FF0E_5C5E_6027_8BA1_7B97 = require("系统.03．技能系统.07．动态技能文本.02．属性计算")
local _____8BA1_7B97_516C_5F0F_4F24_5BB3 = ____02_FF0E_5C5E_6027_8BA1_7B97["计算公式伤害"]
function _____63D0_53D6_500D_7387(text, _____6570_5B57_8D77_59CB)
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
--- 动态技能文本 - 核心业务逻辑
-- 
-- 遍历本地玩家选中单位的命令卡技能，动态替换描述中的公式为实际伤害数值
local jass = require("jass.common")
local japi = require("jass.japi")
local heroConfigTool = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照")
local dynamicSkillData = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．动态技能数据")
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_1.debugLog
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetHandleId = jass.GetHandleId
local R2I = jass.R2I
local DzGetUnitAbilityUberTip = japi.DzGetUnitAbilityUberTip
local DzSetUnitAbilityUberTip = japi.DzSetUnitAbilityUberTip
local DzSetUnitAbilityUpdate = japi.DzSetUnitAbilityUpdate
local MODULE_NAME = "动态技能文本"
local _____5355_5C5E_6027_6700_5927_66FF_6362_6B21_6570 = 8
local _____52A8_6001_6570_503C_6807_8BB0_524D_7F00 = "__DYN_NUM_"
local _____52A8_6001_6570_503C_6807_8BB0_540E_7F00 = "__"
local ____ALT_63D0_793A_5C3E_6CE8 = "|n|cff99ccff（按下Alt显示详细信息）|r"
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
local function _____662F_5426_547D_4E2D_8DF3_8FC7_7247_6BB5(text, _____5FFD_7565_901A_7528_6D88_8017_4FDD_62A4)
    do
        local i = 0
        while i < #_____52A8_6001_6587_672C_8DF3_8FC7_7247_6BB5_5217_8868 do
            do
                local _____7247_6BB5 = _____52A8_6001_6587_672C_8DF3_8FC7_7247_6BB5_5217_8868[i + 1]
                if _____5FFD_7565_901A_7528_6D88_8017_4FDD_62A4 == true and _____7247_6BB5 == "消耗" then
                    goto __continue23
                end
                if (string.find(text, _____7247_6BB5, nil, true) or 0) - 1 >= 0 then
                    return true
                end
            end
            ::__continue23::
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
local function _____5C1D_8BD5_5339_914D_5C5E_6027_6587_672C(text, _____8D77_59CB_4F4D_7F6E)
    do
        local i = 0
        while i < #_____6392_5E8F_5C5E_6027_5339_914D_9879_5217_8868 do
            local _____5C5E_6027_6587_672C_540D = _____6392_5E8F_5C5E_6027_5339_914D_9879_5217_8868[i + 1]["文本名"]
            if __TS__StringSubstring(text, _____8D77_59CB_4F4D_7F6E, _____8D77_59CB_4F4D_7F6E + #_____5C5E_6027_6587_672C_540D) == _____5C5E_6027_6587_672C_540D then
                return _____5C5E_6027_6587_672C_540D
            end
            i = i + 1
        end
    end
    return nil
end
local function _____4FDD_62A4_76EE_6807_524D_7F00_516C_5F0F(text, _____524D_7F00, _____4FDD_62A4_7247_6BB5_8868)
    local result = text
    local _____641C_7D22_8D77_70B9 = 0
    while true do
        do
            local _____524D_7F00_4F4D_7F6E = (string.find(
                result,
                _____524D_7F00,
                math.max(_____641C_7D22_8D77_70B9 + 1, 1),
                true
            ) or 0) - 1
            if _____524D_7F00_4F4D_7F6E < 0 then
                break
            end
            local _____5F53_524D_4F4D_7F6E = _____524D_7F00_4F4D_7F6E + #_____524D_7F00
            local _____500D_7387 = _____63D0_53D6_500D_7387(result, _____5F53_524D_4F4D_7F6E)
            if _____500D_7387 == nil then
                _____641C_7D22_8D77_70B9 = _____524D_7F00_4F4D_7F6E + #_____524D_7F00
                goto __continue33
            end
            _____5F53_524D_4F4D_7F6E = _____5F53_524D_4F4D_7F6E + #_____500D_7387
            local _____547D_4E2D_5C5E_6027 = false
            while true do
                local _____5C5E_6027_6587_672C_540D = _____5C1D_8BD5_5339_914D_5C5E_6027_6587_672C(result, _____5F53_524D_4F4D_7F6E)
                if _____5C5E_6027_6587_672C_540D == nil then
                    break
                end
                _____547D_4E2D_5C5E_6027 = true
                _____5F53_524D_4F4D_7F6E = _____5F53_524D_4F4D_7F6E + #_____5C5E_6027_6587_672C_540D
            end
            if not _____547D_4E2D_5C5E_6027 then
                _____641C_7D22_8D77_70B9 = _____524D_7F00_4F4D_7F6E + #_____524D_7F00
                goto __continue33
            end
            local _____539F_6587 = __TS__StringSubstring(result, _____524D_7F00_4F4D_7F6E, _____5F53_524D_4F4D_7F6E)
            local _____6807_8BB0 = ("__DYN_SKIP_" .. tostring(#_____4FDD_62A4_7247_6BB5_8868)) .. "__"
            _____4FDD_62A4_7247_6BB5_8868[#_____4FDD_62A4_7247_6BB5_8868 + 1] = {["标记"] = _____6807_8BB0, ["原文"] = _____539F_6587}
            result = (__TS__StringSubstring(result, 0, _____524D_7F00_4F4D_7F6E) .. _____6807_8BB0) .. __TS__StringSubstring(result, _____5F53_524D_4F4D_7F6E)
            _____641C_7D22_8D77_70B9 = _____524D_7F00_4F4D_7F6E + #_____6807_8BB0
        end
        ::__continue33::
    end
    return result
end
local function _____4FDD_62A4_76EE_6807_7C7B_516C_5F0F(text)
    local _____4FDD_62A4_7247_6BB5_8868 = {}
    local result = text
    result = _____4FDD_62A4_76EE_6807_524D_7F00_516C_5F0F(result, "目标已损失", _____4FDD_62A4_7247_6BB5_8868)
    result = _____4FDD_62A4_76EE_6807_524D_7F00_516C_5F0F(result, "目标", _____4FDD_62A4_7247_6BB5_8868)
    result = _____4FDD_62A4_76EE_6807_524D_7F00_516C_5F0F(result, "主目标", _____4FDD_62A4_7247_6BB5_8868)
    result = _____4FDD_62A4_76EE_6807_524D_7F00_516C_5F0F(result, "副目标", _____4FDD_62A4_7247_6BB5_8868)
    return {result, _____4FDD_62A4_7247_6BB5_8868}
end
local function _____6062_590D_4FDD_62A4_7247_6BB5(text, _____4FDD_62A4_7247_6BB5_8868)
    local result = text
    do
        local i = 0
        while i < #_____4FDD_62A4_7247_6BB5_8868 do
            local _____4FDD_62A4_7247_6BB5 = _____4FDD_62A4_7247_6BB5_8868[i + 1]
            result = __TS__StringReplace(result, _____4FDD_62A4_7247_6BB5["标记"], _____4FDD_62A4_7247_6BB5["原文"])
            i = i + 1
        end
    end
    return result
end
local function _____6D88_9664_9020_6210_81EA_8EAB_6570_503C_524D_7F00(text)
    local result = text
    local _____76EE_6807_524D_7F00 = "造成自身"
    local _____4F4D_7F6E = (string.find(result, _____76EE_6807_524D_7F00, nil, true) or 0) - 1
    while _____4F4D_7F6E >= 0 do
        local _____6570_5B57_5F00_59CB = _____4F4D_7F6E + #_____76EE_6807_524D_7F00
        local _____4E0B_4E00_4E2A_5B57_7B26_4F4D_7F6E = _____6570_5B57_5F00_59CB
        local _____5B57_7B26 = _____4E0B_4E00_4E2A_5B57_7B26_4F4D_7F6E < #result and __TS__StringCharAt(result, _____4E0B_4E00_4E2A_5B57_7B26_4F4D_7F6E) or ""
        if _____5B57_7B26 >= "0" and _____5B57_7B26 <= "9" or _____5B57_7B26 == "." then
            result = (__TS__StringSubstring(result, 0, _____4F4D_7F6E) .. "造成") .. __TS__StringSubstring(result, _____6570_5B57_5F00_59CB)
            _____4F4D_7F6E = (string.find(
                result,
                _____76EE_6807_524D_7F00,
                math.max(_____4F4D_7F6E + 2 + 1, 1),
                true
            ) or 0) - 1
        else
            _____4F4D_7F6E = (string.find(
                result,
                _____76EE_6807_524D_7F00,
                math.max(_____4F4D_7F6E + 2 + 1, 1),
                true
            ) or 0) - 1
        end
    end
    return result
end
local function _____8FFD_52A0Alt_63D0_793A_5C3E_6CE8(text)
    if (string.find(text, ____ALT_63D0_793A_5C3E_6CE8, nil, true) or 0) - 1 >= 0 then
        return text
    end
    return text .. ____ALT_63D0_793A_5C3E_6CE8
end
local function _____5305_88C5_52A8_6001_6570_503C(_____6570_503C_6587_672C)
    return (_____52A8_6001_6570_503C_6807_8BB0_524D_7F00 .. _____6570_503C_6587_672C) .. _____52A8_6001_6570_503C_6807_8BB0_540E_7F00
end
local function _____683C_5F0F_5316_52A8_6001_6574_6570(value)
    if value >= 0 then
        return tostring(R2I(value + 0.5)
        )
    end
    return "-" .. tostring(R2I(-value + 0.5)
    )
end
local function _____89E3_6790_52A8_6001_6570_503C_6807_8BB0(text, _____8D77_59CB_4F4D_7F6E)
    if __TS__StringSubstring(text, _____8D77_59CB_4F4D_7F6E, _____8D77_59CB_4F4D_7F6E + #_____52A8_6001_6570_503C_6807_8BB0_524D_7F00) ~= _____52A8_6001_6570_503C_6807_8BB0_524D_7F00 then
        return nil
    end
    local _____6570_503C_5F00_59CB = _____8D77_59CB_4F4D_7F6E + #_____52A8_6001_6570_503C_6807_8BB0_524D_7F00
    local _____6807_8BB0_7ED3_675F = (string.find(
        text,
        _____52A8_6001_6570_503C_6807_8BB0_540E_7F00,
        math.max(_____6570_503C_5F00_59CB + 1, 1),
        true
    ) or 0) - 1
    if _____6807_8BB0_7ED3_675F < 0 then
        return nil
    end
    local _____6570_503C_6587_672C = __TS__StringSubstring(text, _____6570_503C_5F00_59CB, _____6807_8BB0_7ED3_675F)
    local _____6570_503C = __TS__ParseFloat(_____6570_503C_6587_672C)
    if _____6570_503C ~= _____6570_503C then
        return nil
    end
    return {["结束位置"] = _____6807_8BB0_7ED3_675F + #_____52A8_6001_6570_503C_6807_8BB0_540E_7F00, ["数值文本"] = _____6570_503C_6587_672C, ["数值"] = _____6570_503C}
end
local function _____5408_5E76_52A8_6001_6570_503C_52A0_6CD5(text)
    local result = ""
    local _____4F4D_7F6E = 0
    while _____4F4D_7F6E < #text do
        do
            local _____7B2C_4E00_4E2A_6807_8BB0 = _____89E3_6790_52A8_6001_6570_503C_6807_8BB0(text, _____4F4D_7F6E)
            if _____7B2C_4E00_4E2A_6807_8BB0 == nil then
                result = result .. __TS__StringCharAt(text, _____4F4D_7F6E)
                _____4F4D_7F6E = _____4F4D_7F6E + 1
                goto __continue57
            end
            local _____6C42_548C = _____7B2C_4E00_4E2A_6807_8BB0["数值"]
            local _____5F53_524D_7ED3_675F = _____7B2C_4E00_4E2A_6807_8BB0["结束位置"]
            local _____662F_5426_53D1_751F_5408_5E76 = false
            while _____5F53_524D_7ED3_675F < #text and __TS__StringCharAt(text, _____5F53_524D_7ED3_675F) == "+" do
                local _____4E0B_4E00_4E2A_6807_8BB0 = _____89E3_6790_52A8_6001_6570_503C_6807_8BB0(text, _____5F53_524D_7ED3_675F + 1)
                if _____4E0B_4E00_4E2A_6807_8BB0 == nil then
                    break
                end
                _____6C42_548C = _____6C42_548C + _____4E0B_4E00_4E2A_6807_8BB0["数值"]
                _____5F53_524D_7ED3_675F = _____4E0B_4E00_4E2A_6807_8BB0["结束位置"]
                _____662F_5426_53D1_751F_5408_5E76 = true
            end
            if _____662F_5426_53D1_751F_5408_5E76 then
                result = result .. tostring(_____6C42_548C)
            else
                result = result .. _____7B2C_4E00_4E2A_6807_8BB0["数值文本"]
            end
            _____4F4D_7F6E = _____5F53_524D_7ED3_675F
        end
        ::__continue57::
    end
    return result
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
                    goto __continue66
                end
                seen[abilityId] = true
                ids[#ids + 1] = abilityId
            end
            ::__continue66::
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
local function _____662F_5426_5341_516D_8FDB_5236_5B57_7B26(_____5B57_7B26)
    if _____5B57_7B26 >= "0" and _____5B57_7B26 <= "9" then
        return true
    end
    if _____5B57_7B26 >= "a" and _____5B57_7B26 <= "f" then
        return true
    end
    return _____5B57_7B26 >= "A" and _____5B57_7B26 <= "F"
end
--- 跳过指定位置开始的连续颜色码（|cffXXXXXXXX 或 |r），返回跳过后的位置。
-- 着色文案中属性名与数值之间会插入颜色码（攻击力|cff87ceeb120%|r），
-- 公式匹配必须越过它们才能重新邻接。
local function _____8DF3_8FC7_989C_8272_7801(text, _____4F4D_7F6E)
    local _____5F53_524D = _____4F4D_7F6E
    while _____5F53_524D < #text do
        do
            if __TS__StringSubstring(text, _____5F53_524D, _____5F53_524D + 2) == "|r" then
                _____5F53_524D = _____5F53_524D + 2
                goto __continue82
            end
            if _____5F53_524D + 10 <= #text and __TS__StringSubstring(text, _____5F53_524D, _____5F53_524D + 2) == "|c" then
                local _____5408_6CD5 = true
                do
                    local i = 0
                    while i < 8 do
                        if not _____662F_5426_5341_516D_8FDB_5236_5B57_7B26(__TS__StringCharAt(text, _____5F53_524D + 2 + i)) then
                            _____5408_6CD5 = false
                            break
                        end
                        i = i + 1
                    end
                end
                if _____5408_6CD5 then
                    _____5F53_524D = _____5F53_524D + 10
                    goto __continue82
                end
            end
            break
        end
        ::__continue82::
    end
    return _____5F53_524D
end
local function _____500D_7387_662F_5426_53EF_9690_5F0F_5339_914D(_____500D_7387)
    return (string.find(_____500D_7387, "%", nil, true) or 0) - 1 >= 0
end
local function _____67E5_627E_6700_540E_989C_8272_7801_8D77_59CB(text, beforeIndex)
    local _____547D_4E2D_4F4D_7F6E = -1
    local _____641C_7D22_4F4D_7F6E = (string.find(text, "|c", nil, true) or 0) - 1
    while _____641C_7D22_4F4D_7F6E >= 0 and _____641C_7D22_4F4D_7F6E < beforeIndex do
        local _____662F_989C_8272_7801 = _____641C_7D22_4F4D_7F6E + 10 <= #text
        do
            local i = 0
            while i < 8 and _____662F_989C_8272_7801 do
                if not _____662F_5426_5341_516D_8FDB_5236_5B57_7B26(__TS__StringCharAt(text, _____641C_7D22_4F4D_7F6E + 2 + i)) then
                    _____662F_989C_8272_7801 = false
                end
                i = i + 1
            end
        end
        if _____662F_989C_8272_7801 then
            _____547D_4E2D_4F4D_7F6E = _____641C_7D22_4F4D_7F6E
        end
        _____641C_7D22_4F4D_7F6E = (string.find(
            text,
            "|c",
            math.max(_____641C_7D22_4F4D_7F6E + 2 + 1, 1),
            true
        ) or 0) - 1
    end
    return _____547D_4E2D_4F4D_7F6E
end
local function _____8C03_6574_524D_7F00_500D_7387_8D77_70B9_907F_5F00_989C_8272_7801(text, _____6570_5B57_8D77_59CB, _____5C5E_6027_4F4D_7F6E)
    local _____989C_8272_8D77_59CB = _____67E5_627E_6700_540E_989C_8272_7801_8D77_59CB(text, _____5C5E_6027_4F4D_7F6E)
    if _____989C_8272_8D77_59CB < 0 then
        return _____6570_5B57_8D77_59CB
    end
    local _____989C_8272_7ED3_675F = _____989C_8272_8D77_59CB + 10
    if _____989C_8272_7ED3_675F <= _____6570_5B57_8D77_59CB or _____989C_8272_7ED3_675F > _____5C5E_6027_4F4D_7F6E then
        return _____6570_5B57_8D77_59CB
    end
    local _____989C_8272_503C = __TS__StringSubstring(text, _____989C_8272_8D77_59CB + 2, _____989C_8272_7ED3_675F)
    do
        local i = 0
        while i < #_____989C_8272_503C do
            if not _____662F_5426_5341_516D_8FDB_5236_5B57_7B26(__TS__StringCharAt(_____989C_8272_503C, i)) then
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
        do
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
                if _____6570_5B57_8D77_59CB >= _____5C5E_6027_4F4D_7F6E then
                    _____5C5E_6027_4F4D_7F6E = (string.find(
                        text,
                        _____5C5E_6027_6587_672C_540D,
                        math.max(_____5C5E_6027_4F4D_7F6E + #_____5C5E_6027_6587_672C_540D + 1, 1),
                        true
                    ) or 0) - 1
                    goto __continue104
                end
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
                if _____542B_6570_5B57 and _____500D_7387_662F_5426_53EF_9690_5F0F_5339_914D(_____500D_7387) then
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
        ::__continue104::
    end
    return nil
end
--- 提取一个可替换的公式片段
-- 支持：
-- 1. 属性名×数字 / 属性名×数字%
-- 2. 属性名数字 / 属性名数字%
-- 3. 属性名的数字% —— 例如「最大魔法值的6%」（倍率必须带 %，避免误匹配）
-- 4. 数字%属性名 / 数字属性名（前缀倍率）
local function _____63D0_53D6_516C_5F0F_5339_914D(text, _____5C5E_6027_6587_672C_540D, _____8D77_59CB_4F4D_7F6E)
    local _____4E58_53F7_524D_7F00 = _____5C5E_6027_6587_672C_540D .. "×"
    local _____4E58_53F7_4F4D_7F6E = (string.find(
        text,
        _____4E58_53F7_524D_7F00,
        math.max(_____8D77_59CB_4F4D_7F6E + 1, 1),
        true
    ) or 0) - 1
    if _____4E58_53F7_4F4D_7F6E >= 0 then
        local _____4E58_53F7_6570_5B57_8D77_70B9 = _____8DF3_8FC7_989C_8272_7801(text, _____4E58_53F7_4F4D_7F6E + #_____4E58_53F7_524D_7F00)
        local _____500D_7387 = _____63D0_53D6_500D_7387(text, _____4E58_53F7_6570_5B57_8D77_70B9)
        if _____500D_7387 ~= nil then
            return {
                ["完整匹配"] = __TS__StringSubstring(text, _____4E58_53F7_4F4D_7F6E, _____4E58_53F7_6570_5B57_8D77_70B9 + #_____500D_7387),
                ["倍率"] = _____500D_7387,
                ["开始位置"] = _____4E58_53F7_4F4D_7F6E,
                ["数值颜色前缀"] = __TS__StringSubstring(text, _____4E58_53F7_4F4D_7F6E + #_____4E58_53F7_524D_7F00, _____4E58_53F7_6570_5B57_8D77_70B9)
            }
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
        local _____76F4_8FDE_500D_7387 = _____63D0_53D6_500D_7387(text, _____6570_5B57_8D77_59CB)
        if _____76F4_8FDE_500D_7387 ~= nil and _____500D_7387_662F_5426_53EF_9690_5F0F_5339_914D(_____76F4_8FDE_500D_7387) then
            return {["完整匹配"] = _____5C5E_6027_6587_672C_540D .. _____76F4_8FDE_500D_7387, ["倍率"] = _____76F4_8FDE_500D_7387, ["开始位置"] = _____5C5E_6027_4F4D_7F6E}
        end
        local _____8DF3_8FC7_540E = _____8DF3_8FC7_989C_8272_7801(text, _____6570_5B57_8D77_59CB)
        if _____8DF3_8FC7_540E > _____6570_5B57_8D77_59CB then
            local _____7740_8272_500D_7387 = _____63D0_53D6_500D_7387(text, _____8DF3_8FC7_540E)
            if _____7740_8272_500D_7387 ~= nil and _____500D_7387_662F_5426_53EF_9690_5F0F_5339_914D(_____7740_8272_500D_7387) then
                return {
                    ["完整匹配"] = __TS__StringSubstring(text, _____5C5E_6027_4F4D_7F6E, _____8DF3_8FC7_540E + #_____7740_8272_500D_7387),
                    ["倍率"] = _____7740_8272_500D_7387,
                    ["开始位置"] = _____5C5E_6027_4F4D_7F6E,
                    ["数值颜色前缀"] = __TS__StringSubstring(text, _____6570_5B57_8D77_59CB, _____8DF3_8FC7_540E)
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
    local _____7684_8FDE_63A5_524D_7F00 = _____5C5E_6027_6587_672C_540D .. "的"
    local _____7684_4F4D_7F6E = (string.find(
        text,
        _____7684_8FDE_63A5_524D_7F00,
        math.max(_____8D77_59CB_4F4D_7F6E + 1, 1),
        true
    ) or 0) - 1
    while _____7684_4F4D_7F6E >= 0 do
        local _____6570_5B57_8D77_59CB = _____7684_4F4D_7F6E + #_____7684_8FDE_63A5_524D_7F00
        local _____76F4_8FDE_500D_7387 = _____63D0_53D6_500D_7387(text, _____6570_5B57_8D77_59CB)
        if _____76F4_8FDE_500D_7387 ~= nil and _____500D_7387_662F_5426_53EF_9690_5F0F_5339_914D(_____76F4_8FDE_500D_7387) then
            return {["完整匹配"] = _____7684_8FDE_63A5_524D_7F00 .. _____76F4_8FDE_500D_7387, ["倍率"] = _____76F4_8FDE_500D_7387, ["开始位置"] = _____7684_4F4D_7F6E}
        end
        local _____8DF3_8FC7_540E = _____8DF3_8FC7_989C_8272_7801(text, _____6570_5B57_8D77_59CB)
        if _____8DF3_8FC7_540E > _____6570_5B57_8D77_59CB then
            local _____7740_8272_500D_7387 = _____63D0_53D6_500D_7387(text, _____8DF3_8FC7_540E)
            if _____7740_8272_500D_7387 ~= nil and _____500D_7387_662F_5426_53EF_9690_5F0F_5339_914D(_____7740_8272_500D_7387) then
                return {
                    ["完整匹配"] = __TS__StringSubstring(text, _____7684_4F4D_7F6E, _____8DF3_8FC7_540E + #_____7740_8272_500D_7387),
                    ["倍率"] = _____7740_8272_500D_7387,
                    ["开始位置"] = _____7684_4F4D_7F6E,
                    ["数值颜色前缀"] = __TS__StringSubstring(text, _____6570_5B57_8D77_59CB, _____8DF3_8FC7_540E)
                }
            end
        end
        _____7684_4F4D_7F6E = (string.find(
            text,
            _____7684_8FDE_63A5_524D_7F00,
            math.max(_____7684_4F4D_7F6E + #_____7684_8FDE_63A5_524D_7F00 + 1, 1),
            true
        ) or 0) - 1
    end
    return _____63D0_53D6_524D_7F00_500D_7387_5339_914D(text, _____5C5E_6027_6587_672C_540D, _____8D77_59CB_4F4D_7F6E)
end
local function _____66FF_6362_516C_5F0F(unit, tip, options)
    local _____4FDD_62A4_7ED3_679C = _____4FDD_62A4_76EE_6807_7C7B_516C_5F0F(tip)
    local result = _____4FDD_62A4_7ED3_679C[1]
    local _____4FDD_62A4_7247_6BB5_8868 = _____4FDD_62A4_7ED3_679C[2]
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
                    if ((string.find(_____5B8C_6574_5339_914D_6587_672C, "目标", nil, true) or 0) - 1 >= 0 or (string.find(_____5339_914D_524D_7A97_53E3, "目标", nil, true) or 0) - 1 >= 0 or (string.find(_____5339_914D_524D_7A97_53E3, "目标已损失", nil, true) or 0) - 1 >= 0) and (string.find(_____5B8C_6574_5339_914D_6587_672C, "自身", nil, true) or 0) - 1 < 0 and (string.find(_____5339_914D_524D_7A97_53E3, "自身", nil, true) or 0) - 1 < 0 then
                        _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB + #_____5B8C_6574_5339_914D_6587_672C
                        _____5339_914D_7ED3_679C = _____63D0_53D6_516C_5F0F_5339_914D(result, _____5C5E_6027_5339_914D_9879["文本名"], _____641C_7D22_8D77_70B9)
                        goto __continue129
                    end
                    local _____5FFD_7565_901A_7528_6D88_8017_4FDD_62A4 = _____5C5E_6027_5339_914D_9879["计算属性名"] == "最大魔法值"
                    if _____662F_5426_547D_4E2D_8DF3_8FC7_7247_6BB5(_____5B8C_6574_5339_914D_6587_672C, _____5FFD_7565_901A_7528_6D88_8017_4FDD_62A4) or _____662F_5426_547D_4E2D_8DF3_8FC7_7247_6BB5(_____5339_914D_524D_7A97_53E3 .. _____5B8C_6574_5339_914D_6587_672C, _____5FFD_7565_901A_7528_6D88_8017_4FDD_62A4) then
                        _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB + #_____5B8C_6574_5339_914D_6587_672C
                        _____5339_914D_7ED3_679C = _____63D0_53D6_516C_5F0F_5339_914D(result, _____5C5E_6027_5339_914D_9879["文本名"], _____641C_7D22_8D77_70B9)
                        goto __continue129
                    end
                    if _____662F_5426_4E3A_589E_51CF_7C7B_8BED_5883(result, _____5339_914D_5F00_59CB) then
                        _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB + #_____5B8C_6574_5339_914D_6587_672C
                        _____5339_914D_7ED3_679C = _____63D0_53D6_516C_5F0F_5339_914D(result, _____5C5E_6027_5339_914D_9879["文本名"], _____641C_7D22_8D77_70B9)
                        goto __continue129
                    end
                    if _____662F_5426_4E3A_76EE_6807_7C7B_8BED_5883(result, _____5339_914D_5F00_59CB) and not _____662F_5426_4E3A_81EA_8EAB_7C7B_8BED_5883(result, _____5339_914D_5F00_59CB) then
                        _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB + #_____5B8C_6574_5339_914D_6587_672C
                        _____5339_914D_7ED3_679C = _____63D0_53D6_516C_5F0F_5339_914D(result, _____5C5E_6027_5339_914D_9879["文本名"], _____641C_7D22_8D77_70B9)
                        goto __continue129
                    end
                    local _____4F24_5BB3 = _____8BA1_7B97_516C_5F0F_4F24_5BB3(unit, _____5C5E_6027_5339_914D_9879["计算属性名"], _____5339_914D_7ED3_679C["倍率"])
                    local _____52A8_6001_6570_503C = _____5305_88C5_52A8_6001_6570_503C(_____683C_5F0F_5316_52A8_6001_6574_6570(_____4F24_5BB3))
                    local _____66FF_6362_503C = (_____5339_914D_7ED3_679C["数值颜色前缀"] ~= nil and _____5339_914D_7ED3_679C["数值颜色前缀"] or "") .. _____52A8_6001_6570_503C
                    if options ~= nil and options.preserveFormula == true then
                        local _____4FDD_62A4_6807_8BB0 = ("__DYN_SKIP_" .. tostring(#_____4FDD_62A4_7247_6BB5_8868)) .. "__"
                        _____4FDD_62A4_7247_6BB5_8868[#_____4FDD_62A4_7247_6BB5_8868 + 1] = {["标记"] = _____4FDD_62A4_6807_8BB0, ["原文"] = ((_____5B8C_6574_5339_914D_6587_672C .. "（") .. _____52A8_6001_6570_503C) .. "）"}
                        _____66FF_6362_503C = _____4FDD_62A4_6807_8BB0
                    end
                    result = (__TS__StringSubstring(result, 0, _____5339_914D_5F00_59CB) .. _____66FF_6362_503C) .. __TS__StringSubstring(result, _____5339_914D_5F00_59CB + #_____5B8C_6574_5339_914D_6587_672C)
                    _____66FF_6362_6B21_6570 = _____66FF_6362_6B21_6570 + 1
                    if _____66FF_6362_6B21_6570 >= _____5355_5C5E_6027_6700_5927_66FF_6362_6B21_6570 then
                        debugLog(nil, MODULE_NAME, "单属性替换达到上限，提前中止", _____5C5E_6027_5339_914D_9879["文本名"])
                        break
                    end
                    _____641C_7D22_8D77_70B9 = _____5339_914D_5F00_59CB + #_____66FF_6362_503C
                    _____5339_914D_7ED3_679C = _____63D0_53D6_516C_5F0F_5339_914D(result, _____5C5E_6027_5339_914D_9879["文本名"], _____641C_7D22_8D77_70B9)
                end
                ::__continue129::
            end
            i = i + 1
        end
    end
    result = _____6062_590D_4FDD_62A4_7247_6BB5(result, _____4FDD_62A4_7247_6BB5_8868)
    result = _____5408_5E76_52A8_6001_6570_503C_52A0_6CD5(result)
    result = _____6D88_9664_9020_6210_81EA_8EAB_6570_503C_524D_7F00(result)
    if options == nil or options.appendAltHint ~= false then
        result = _____8FFD_52A0Alt_63D0_793A_5C3E_6CE8(result)
    end
    return result
end
____exports["渲染动态文本"] = function(unit, tip, options)
    if unit == nil or unit == 0 or tip == "" then
        return tip
    end
    return _____66FF_6362_516C_5F0F(unit, tip, options)
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
    return true
end
local function _____89E3_6790_914D_7F6E_6280_80FD_5217_8868(hero)
    local config = heroConfigTool["获取单位玩家英雄配置"](hero)
    if config == nil then
        return {}
    end
    local result = {}
    local seen = {}
    local fields = {config.heroAbilList, config.abilList}
    do
        local i = 0
        while i < #fields do
            do
                local rawList = fields[i + 1]
                if type(rawList) ~= "string" then
                    goto __continue151
                end
                local parts = __TS__StringSplit(rawList, ",")
                do
                    local j = 0
                    while j < #parts do
                        do
                            local abilityId = stringToFourCCSafe(parts[j + 1])
                            if abilityId == 0 or seen[abilityId] == true then
                                goto __continue154
                            end
                            seen[abilityId] = true
                            result[#result + 1] = abilityId
                        end
                        ::__continue154::
                        j = j + 1
                    end
                end
            end
            ::__continue151::
            i = i + 1
        end
    end
    return result
end
--- 检查本地主控单位的命令卡技能
____exports["检查英雄技能"] = function(hero)
    if not isValidHandle(hero) then
        return
    end
    dynamicSkillData["刷新单位技能数据"](hero)
    local abilityIds = _____83B7_53D6_5FEB_7167_6280_80FD_5217_8868(hero)
    _____5DF2_5904_7406_6280_80FD_7F13_5B58[_____751F_6210_82F1_96C4_7F13_5B58_952E(hero)] = abilityIds
    do
        local i = 0
        while i < #abilityIds do
            __TS__Delete(
                _____539F_59CB_63D0_793A_7F13_5B58,
                _____751F_6210_63D0_793A_7F13_5B58_952E(hero, abilityIds[i + 1])
            )
            i = i + 1
        end
    end
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
    local cacheKey = _____751F_6210_82F1_96C4_7F13_5B58_952E(hero)
    local cachedAbilityIds = _____5DF2_5904_7406_6280_80FD_7F13_5B58[cacheKey]
    local abilityIds = cachedAbilityIds or _____83B7_53D6_5FEB_7167_6280_80FD_5217_8868(hero)
    do
        local i = 0
        while i < #abilityIds do
            _____6062_590D_5355_4E2A_6280_80FD_539F_59CB_6587_672C(hero, abilityIds[i + 1])
            i = i + 1
        end
    end
    __TS__Delete(_____5DF2_5904_7406_6280_80FD_7F13_5B58, cacheKey)
end
____exports["恢复单个英雄技能原始文本"] = function(hero, abilityId)
    if not isValidHandle(hero) or abilityId == 0 then
        return
    end
    _____6062_590D_5355_4E2A_6280_80FD_539F_59CB_6587_672C(hero, abilityId)
end
____exports["刷新单个英雄技能动态文本"] = function(hero, abilityId)
    if not isValidHandle(hero) or abilityId == 0 then
        return
    end
    if GetUnitAbilityLevel(hero, abilityId) <= 0 then
        return
    end
    _____5904_7406_6280_80FD_63D0_793A(hero, abilityId)
end
local function _____672C_5730_5237_65B0_6307_5B9A_82F1_96C4_52A8_6001_6587_672C(hero)
    local _____5FEB_7167 = selectionSnapshotSystem["获取本地选中技能快照"]()
    if _____5FEB_7167.hero ~= hero then
        return
    end
    ____exports["检查英雄技能"](hero)
end
--- 装备属性变化后的同步技能界面刷新。调用者必须处于全端对称事件。
____exports["同步刷新英雄技能界面"] = function(hero)
    if not isValidHandle(hero) then
        return
    end
    _____672C_5730_5237_65B0_6307_5B9A_82F1_96C4_52A8_6001_6587_672C(hero)
    local abilityIds = _____89E3_6790_914D_7F6E_6280_80FD_5217_8868(hero)
    do
        local i = 0
        while i < #abilityIds do
            DzSetUnitAbilityUpdate(hero, abilityIds[i + 1])
            i = i + 1
        end
    end
end
____exports["同步刷新英雄技能原始界面"] = function(hero)
    if not isValidHandle(hero) then
        return
    end
    local _____5FEB_7167 = selectionSnapshotSystem["获取本地选中技能快照"]()
    if _____5FEB_7167.hero == hero then
        ____exports["恢复英雄技能原始文本"](hero)
    end
    local abilityIds = _____89E3_6790_914D_7F6E_6280_80FD_5217_8868(hero)
    do
        local i = 0
        while i < #abilityIds do
            DzSetUnitAbilityUpdate(hero, abilityIds[i + 1])
            i = i + 1
        end
    end
end
return ____exports
