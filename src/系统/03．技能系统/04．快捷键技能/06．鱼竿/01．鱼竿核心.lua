--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_9C7C_7AFF_914D_7F6E = require("系统.03．技能系统.04．快捷键技能.06．鱼竿.00．鱼竿配置")
local _____9C7C_7AFF_914D_7F6E = ____00_FF0E_9C7C_7AFF_914D_7F6E["鱼竿配置"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jassGlobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_1["解析配置内部ID"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_2["创建单位并登记排泄安全"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_4.createTimedEffect
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____require_result_5["两点角度"]
local GetHeroLevel = jass.GetHeroLevel
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local IsTerrainPathable = jass.IsTerrainPathable
local UnitAddItemById = jass.UnitAddItemById
local GetRandomInt = jass.GetRandomInt
local SetUnitPosition = jass.SetUnitPosition
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local Player = jass.Player
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY
local PATHING_TYPE_FLOATABILITY = jass.PATHING_TYPE_FLOATABILITY
local _____9C7C_7AFF_6280_80FD_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____9C7C_7AFF_914D_7F6E["技能ID"])
local _____672C_5730_91CD_590D_5237_65B0_6807_8BB0 = {}
local _____5DF2_521D_59CB_5316_9C7C_7AFF = false
local function _____533A_95F4_547D_4E2D(_____968F_673A_503C, _____6700_5C0F_503C, _____6700_5927_503C)
    return _____968F_673A_503C >= _____6700_5C0F_503C and _____968F_673A_503C <= _____6700_5927_503C
end
local function _____662F_9C7C_7AFF_76EE_6807_6C34_57DF(x, y)
    local _____884C_8D70_4E0D_53EF_901A_884C = IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
    local _____6F02_6D6E_53EF_901A_884C = not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
    return _____884C_8D70_4E0D_53EF_901A_884C == _____9C7C_7AFF_914D_7F6E["行走不可通行"] and _____6F02_6D6E_53EF_901A_884C == _____9C7C_7AFF_914D_7F6E["漂浮可通行"]
end
local function _____8BFB_53D6_91CD_590D_5237_65B0_6807_8BB0(_____7D22_5F15)
    local _____5916_90E8_6807_8BB0_8868 = jassGlobals.udg_WYDW
    if _____5916_90E8_6807_8BB0_8868 ~= nil then
        local _____5916_90E8_6807_8BB0 = _____5916_90E8_6807_8BB0_8868[_____7D22_5F15]
        if _____5916_90E8_6807_8BB0 ~= nil then
            return _____5916_90E8_6807_8BB0 > 0
        end
    end
    return _____672C_5730_91CD_590D_5237_65B0_6807_8BB0[_____7D22_5F15] == true
end
local function _____5199_5165_91CD_590D_5237_65B0_6807_8BB0(_____7D22_5F15)
    _____672C_5730_91CD_590D_5237_65B0_6807_8BB0[_____7D22_5F15] = true
    local _____5916_90E8_6807_8BB0_8868 = jassGlobals.udg_WYDW
    if _____5916_90E8_6807_8BB0_8868 ~= nil then
        _____5916_90E8_6807_8BB0_8868[_____7D22_5F15] = 1
    end
end
local function _____8BFB_53D6_5355_4F4D_7ED3_679C_6240_6709_8005(_____6240_6709_8005)
    if _____6240_6709_8005 == "中立敌对" then
        return Player(PLAYER_NEUTRAL_AGGRESSIVE)
    end
    if _____6240_6709_8005 == "中立被动" then
        return Player(PLAYER_NEUTRAL_PASSIVE)
    end
    return Player(6)
end
local function _____82F1_96C4_7B49_7EA7_6EE1_8DB3(_____914D_7F6E, _____82F1_96C4_7B49_7EA7)
    if _____914D_7F6E["最高英雄等级"] ~= nil and _____82F1_96C4_7B49_7EA7 > _____914D_7F6E["最高英雄等级"] then
        return false
    end
    if _____914D_7F6E["最低英雄等级"] ~= nil and _____82F1_96C4_7B49_7EA7 <= _____914D_7F6E["最低英雄等级"] then
        return false
    end
    return true
end
local function _____521B_5EFA_9C7C_7AFF_5355_4F4D_7ED3_679C(_____65BD_6CD5_5355_4F4D, _____76EE_6807X, _____76EE_6807Y, _____914D_7F6E)
    if _____914D_7F6E["重复刷新标记索引"] ~= nil and _____8BFB_53D6_91CD_590D_5237_65B0_6807_8BB0(_____914D_7F6E["重复刷新标记索引"]) then
        return nil
    end
    local _____4F7F_7528_76EE_6807_70B9 = _____914D_7F6E["使用目标点"] == true
    local _____521B_5EFAX = _____4F7F_7528_76EE_6807_70B9 and _____76EE_6807X or _____914D_7F6E["创建X"]
    local _____521B_5EFAY = _____4F7F_7528_76EE_6807_70B9 and _____76EE_6807Y or _____914D_7F6E["创建Y"]
    local _____9762_5411_89D2_5EA6 = _____4F7F_7528_76EE_6807_70B9 and _____4E24_70B9_89D2_5EA6(
        _____76EE_6807X,
        _____76EE_6807Y,
        GetUnitX(_____65BD_6CD5_5355_4F4D),
        GetUnitY(_____65BD_6CD5_5355_4F4D)
    ) or _____914D_7F6E["创建面向角度"]
    local _____5355_4F4D_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____914D_7F6E["单位ID"])
    if _____5355_4F4D_7C7B_578BID == 0 then
        return nil
    end
    local _____5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        _____8BFB_53D6_5355_4F4D_7ED3_679C_6240_6709_8005(_____914D_7F6E["所有者"]),
        _____5355_4F4D_7C7B_578BID,
        _____521B_5EFAX,
        _____521B_5EFAY,
        _____9762_5411_89D2_5EA6
    )
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if _____914D_7F6E["魔抗"] ~= nil then
        YDUserDataSetSafe(
            "unit",
            _____5355_4F4D,
            "魔抗",
            "real",
            _____914D_7F6E["魔抗"]
        )
    end
    if _____914D_7F6E["重复刷新标记索引"] ~= nil then
        _____5199_5165_91CD_590D_5237_65B0_6807_8BB0(_____914D_7F6E["重复刷新标记索引"])
    end
    if _____914D_7F6E["是否把施法者移动到创建点"] == true and _____914D_7F6E["施法者移动X"] ~= nil and _____914D_7F6E["施法者移动Y"] ~= nil then
        SetUnitPosition(_____65BD_6CD5_5355_4F4D, _____914D_7F6E["施法者移动X"], _____914D_7F6E["施法者移动Y"])
    end
    return _____5355_4F4D
end
local function _____663E_793A_9C7C_7AFF_5931_8D25(_____65BD_6CD5_5355_4F4D)
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    DisplayTimedTextToPlayer(
        _____73A9_5BB6,
        0,
        0,
        5,
        "|cFFFFFF00『系统提示』：|r" .. _____9C7C_7AFF_914D_7F6E["失败提示"]
    )
end
local function _____5904_7406_9C7C_7AFF_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or _____6280_80FDID ~= _____9C7C_7AFF_6280_80FD_7C7B_578BID then
        return
    end
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    if not _____662F_9C7C_7AFF_76EE_6807_6C34_57DF(_____76EE_6807X, _____76EE_6807Y) then
        return
    end
    local _____968F_673A_503C = GetRandomInt(_____9C7C_7AFF_914D_7F6E["随机最小值"], _____9C7C_7AFF_914D_7F6E["随机最大值"])
    if _____968F_673A_503C <= 5 then
        _____663E_793A_9C7C_7AFF_5931_8D25(_____65BD_6CD5_5355_4F4D)
        return
    end
    createTimedEffect(
        _____9C7C_7AFF_914D_7F6E["成功特效路径"],
        _____76EE_6807X,
        _____76EE_6807Y,
        0,
        _____9C7C_7AFF_914D_7F6E["成功特效持续秒"]
    )
    do
        local i = 0
        while i < #_____9C7C_7AFF_914D_7F6E["物品结果列表"] do
            do
                local _____7ED3_679C = _____9C7C_7AFF_914D_7F6E["物品结果列表"][i + 1]
                if not _____533A_95F4_547D_4E2D(_____968F_673A_503C, _____7ED3_679C["随机最小值"], _____7ED3_679C["随机最大值"]) then
                    goto __continue29
                end
                local _____7269_54C1_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____7ED3_679C["物品ID"])
                if _____7269_54C1_7C7B_578BID ~= 0 then
                    UnitAddItemById(_____65BD_6CD5_5355_4F4D, _____7269_54C1_7C7B_578BID)
                end
                break
            end
            ::__continue29::
            i = i + 1
        end
    end
    local _____82F1_96C4_7B49_7EA7 = GetHeroLevel(_____65BD_6CD5_5355_4F4D)
    do
        local i = 0
        while i < #_____9C7C_7AFF_914D_7F6E["单位结果列表"] do
            do
                local _____7ED3_679C = _____9C7C_7AFF_914D_7F6E["单位结果列表"][i + 1]
                if not _____533A_95F4_547D_4E2D(_____968F_673A_503C, _____7ED3_679C["随机最小值"], _____7ED3_679C["随机最大值"]) then
                    goto __continue33
                end
                if not _____82F1_96C4_7B49_7EA7_6EE1_8DB3(_____7ED3_679C, _____82F1_96C4_7B49_7EA7) then
                    goto __continue33
                end
                _____521B_5EFA_9C7C_7AFF_5355_4F4D_7ED3_679C(_____65BD_6CD5_5355_4F4D, _____76EE_6807X, _____76EE_6807Y, _____7ED3_679C)
            end
            ::__continue33::
            i = i + 1
        end
    end
end
____exports["init鱼竿"] = function()
    if _____5DF2_521D_59CB_5316_9C7C_7AFF then
        return
    end
    _____5DF2_521D_59CB_5316_9C7C_7AFF = true
    registerSpellEffectListener(_____5904_7406_9C7C_7AFF_751F_6548)
end
return ____exports
