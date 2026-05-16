local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitType = jass.IsUnitType
local IsUnitInGroup = jass.IsUnitInGroup
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.04．区域效果.区域效果")
local _____521B_5EFA_533A_57DF_6548_679C = ____require_result_0["创建区域效果"]
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_1.EC_CreateEffect
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.02．腐败层数")
local _____5E94_7528_8150_8D25_5C42_6570 = ____require_result_3["应用腐败层数"]
local ____EFFECT_ID__8150_8D25_5C42_6570 = 3
local _____9ED8_8BA4_6301_7EED_65F6_95F4 = 999
local _____9ED8_8BA4_68C0_6D4B_95F4_9694 = 1
local _____9ED8_8BA4_534A_5F84 = 300
local AVUL = 1098282348
local BVUL = 1115059564
local _____5468_671F_8303_56F4_6548_679C_5B9E_4F8B_8868 = {}
local _____4E0B_4E00_4E2A_5468_671F_8303_56F4_6548_679CID = 0
local function _____8F6C_6570_5B57(value)
    if value == nil or value == false or value == "" then
        return 0
    end
    local n = type(value) == "number" and value or __TS__Number(value)
    return n ~= n and 0 or n
end
local function _____8BFB_53D6_5355_4F4DX(_____6765_6E90_5355_4F4D, _____53C2_6570)
    local value = _____8F6C_6570_5B57(_____53C2_6570.X or _____53C2_6570.x)
    if value ~= 0 then
        return value
    end
    return _____6765_6E90_5355_4F4D ~= nil and _____6765_6E90_5355_4F4D ~= 0 and GetUnitX(_____6765_6E90_5355_4F4D) or 0
end
local function _____8BFB_53D6_5355_4F4DY(_____6765_6E90_5355_4F4D, _____53C2_6570)
    local value = _____8F6C_6570_5B57(_____53C2_6570.Y or _____53C2_6570.y)
    if value ~= 0 then
        return value
    end
    return _____6765_6E90_5355_4F4D ~= nil and _____6765_6E90_5355_4F4D ~= 0 and GetUnitY(_____6765_6E90_5355_4F4D) or 0
end
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and not IsUnitType(unit, UNIT_TYPE_DEAD)
end
local function _____5355_4F4D_65E0_654C(unit)
    return GetUnitAbilityLevel(unit, AVUL) > 0 or GetUnitAbilityLevel(unit, BVUL) > 0
end
local function _____662F_65E7_8150_8D25_76EE_6807(unit)
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return false
    end
    if IsUnitType(unit, UNIT_TYPE_ANCIENT) then
        return false
    end
    if _____5355_4F4D_65E0_654C(unit) then
        return false
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return false
    end
    return IsUnitInGroup(unit, _____73A9_5BB6_82F1_96C4_7EC4) == true
end
local function _____9500_6BC1_5468_671F_8303_56F4_6548_679C_4E0A_4E0B_6587(id)
    __TS__Delete(_____5468_671F_8303_56F4_6548_679C_5B9E_4F8B_8868, id)
end
local function ____on_5468_671F_8303_56F4_6548_679C_5468_671F(_____533A_57DF_5185_5355_4F4D, _____56DE_8C03_4E0A_4E0B_6587ID)
    local id = _____56DE_8C03_4E0A_4E0B_6587ID or 0
    local _____5B9E_4F8B = _____5468_671F_8303_56F4_6548_679C_5B9E_4F8B_8868[id]
    if _____5B9E_4F8B == nil then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["来源单位"]) then
        local ____self_4 = _____5B9E_4F8B["区域实例"]
        ____self_4["销毁"](____self_4)
        return
    end
    local x = GetUnitX(_____5B9E_4F8B["来源单位"])
    local y = GetUnitY(_____5B9E_4F8B["来源单位"])
    local ____self_5 = _____5B9E_4F8B["区域实例"]
    ____self_5["移动到"](____self_5, x, y)
    if _____5B9E_4F8B["特效模型"] ~= "" then
        EC_CreateEffect(
            _____5B9E_4F8B["特效模型"],
            x,
            y,
            0,
            270,
            1.5,
            1,
            _____5B9E_4F8B["特效持续时间"]
        )
    end
    if _____5B9E_4F8B["效果ID"] == ____EFFECT_ID__8150_8D25_5C42_6570 then
        do
            local i = 0
            while i < #_____533A_57DF_5185_5355_4F4D do
                local unit = _____533A_57DF_5185_5355_4F4D[i + 1]
                if _____662F_65E7_8150_8D25_76EE_6807(unit) then
                    _____5E94_7528_8150_8D25_5C42_6570({["目标单位"] = unit, ["层数"] = 7, ["腐败值"] = true})
                end
                i = i + 1
            end
        end
    end
end
local function ____on_5468_671F_8303_56F4_6548_679C_9500_6BC1(_____56DE_8C03_4E0A_4E0B_6587ID)
    _____9500_6BC1_5468_671F_8303_56F4_6548_679C_4E0A_4E0B_6587(_____56DE_8C03_4E0A_4E0B_6587ID or 0)
end
____exports["启动周期范围效果"] = function(_____53C2_6570)
    local ____53C2_6570__6765_6E90_5355_4F4D_6 = _____53C2_6570["来源单位"]
    if ____53C2_6570__6765_6E90_5355_4F4D_6 == nil then
        ____53C2_6570__6765_6E90_5355_4F4D_6 = _____53C2_6570.EffectSourceUnit
    end
    local _____6765_6E90_5355_4F4D = ____53C2_6570__6765_6E90_5355_4F4D_6
    local _____6301_7EED_65F6_95F4 = _____8F6C_6570_5B57(_____53C2_6570["持续时间"] or _____53C2_6570.EffectTime)
    local _____95F4_9694 = _____8F6C_6570_5B57(_____53C2_6570["间隔"] or _____53C2_6570.EffectInterval)
    local _____534A_5F84 = _____8F6C_6570_5B57(_____53C2_6570["半径"] or _____53C2_6570.r)
    _____4E0B_4E00_4E2A_5468_671F_8303_56F4_6548_679CID = _____4E0B_4E00_4E2A_5468_671F_8303_56F4_6548_679CID + 1
    local id = _____4E0B_4E00_4E2A_5468_671F_8303_56F4_6548_679CID
    local _____533A_57DF_5B9E_4F8B = _____521B_5EFA_533A_57DF_6548_679C({
        X = _____8BFB_53D6_5355_4F4DX(_____6765_6E90_5355_4F4D, _____53C2_6570),
        Y = _____8BFB_53D6_5355_4F4DY(_____6765_6E90_5355_4F4D, _____53C2_6570),
        ["半径"] = _____534A_5F84 > 0 and _____534A_5F84 or _____9ED8_8BA4_534A_5F84,
        ["持续时间"] = _____6301_7EED_65F6_95F4 > 0 and _____6301_7EED_65F6_95F4 or _____9ED8_8BA4_6301_7EED_65F6_95F4,
        ["检测间隔"] = _____95F4_9694 > 0 and _____95F4_9694 or _____9ED8_8BA4_68C0_6D4B_95F4_9694,
        ["防抖间隔"] = 0,
        ["影响目标"] = "全部",
        ["所有者"] = _____6765_6E90_5355_4F4D,
        ["显示提示圈"] = false,
        ["回调上下文ID"] = id,
        ["on周期"] = ____on_5468_671F_8303_56F4_6548_679C_5468_671F,
        ["on销毁"] = ____on_5468_671F_8303_56F4_6548_679C_9500_6BC1
    })
    _____5468_671F_8303_56F4_6548_679C_5B9E_4F8B_8868[id] = {
        ID = id,
        ["来源单位"] = _____6765_6E90_5355_4F4D,
        ["特效模型"] = _____53C2_6570["特效模型"] or _____53C2_6570.AoeEffectFileID or "",
        ["特效持续时间"] = _____95F4_9694 > 0 and _____95F4_9694 or _____9ED8_8BA4_68C0_6D4B_95F4_9694,
        ["效果ID"] = _____8F6C_6570_5B57(_____53C2_6570["效果ID"] or _____53C2_6570.EffectID),
        ["区域实例"] = _____533A_57DF_5B9E_4F8B
    }
    return id
end
return ____exports
