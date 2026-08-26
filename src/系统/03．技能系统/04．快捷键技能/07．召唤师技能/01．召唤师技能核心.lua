--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_53EC_5524_5E08_6280_80FD_914D_7F6E = require("系统.03．技能系统.04．快捷键技能.07．召唤师技能.00．召唤师技能配置")
local _____53EC_5524_5E08_6280_80FD_914D_7F6E = ____00_FF0E_53EC_5524_5E08_6280_80FD_914D_7F6E["召唤师技能配置"]
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_2["解析配置内部ID"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____require_result_4["两点角度"]
local _____6781_5750_6807X = ____require_result_4["极坐标X"]
local _____6781_5750_6807Y = ____require_result_4["极坐标Y"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F4D_79FB_5230_5750_6807 = ____require_result_5["执行战斗自身位移到坐标"]
local SetUnitStateJapi = japi.SetUnitState
local GetUnitStateJapi = japi.GetUnitState
local ConvertUnitState = jass.ConvertUnitState
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetWidgetLife = jass.GetWidgetLife
local SetUnitFacing = jass.SetUnitFacing
local IsTerrainPathable = jass.IsTerrainPathable
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local UNIT_STATE_ARMOR = ConvertUnitState(32)
local PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY
local _____5632_8BBD_6280_80FD_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____53EC_5524_5E08_6280_80FD_914D_7F6E["嘲讽技能ID"])
local _____6781_9650_590D_82CF_6280_80FD_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____53EC_5524_5E08_6280_80FD_914D_7F6E["极限复苏技能ID"])
local _____95EA_70C1_6280_80FD_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____53EC_5524_5E08_6280_80FD_914D_7F6E["闪烁技能ID"])
local _____5DF2_521D_59CB_5316_53EC_5524_5E08_6280_80FD = false
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and GetWidgetLife(_____5355_4F4D) > 0.405
end
local function _____8C03_6574_73A9_5BB6_5C5E_6027(_____73A9_5BB6, _____5C5E_6027_540D, _____589E_91CF)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 or _____589E_91CF == 0 then
        return
    end
    local _____65E7_503C_539F_59CB = YDUserDataGetSafe("player", _____73A9_5BB6, _____5C5E_6027_540D, "real")
    local _____65E7_503C = type(_____65E7_503C_539F_59CB) == "number" and _____65E7_503C_539F_59CB or 0
    YDUserDataSetSafe(
        "player",
        _____73A9_5BB6,
        _____5C5E_6027_540D,
        "real",
        _____65E7_503C + _____589E_91CF
    )
end
local function _____8C03_6574_5355_4F4D_62A4_7532(_____5355_4F4D, _____589E_91CF)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____589E_91CF == 0 then
        return
    end
    local _____5F53_524D_62A4_7532 = GetUnitStateJapi(_____5355_4F4D, UNIT_STATE_ARMOR) or 0
    SetUnitStateJapi(_____5355_4F4D, UNIT_STATE_ARMOR, _____5F53_524D_62A4_7532 + _____589E_91CF)
end
local function ____on_5632_8BBD_7ED3_675F(_____72B6_6001)
    if _____72B6_6001 == nil then
        return
    end
    _____8C03_6574_5355_4F4D_62A4_7532(_____72B6_6001["单位"], -_____53EC_5524_5E08_6280_80FD_914D_7F6E["嘲讽护甲提升"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____72B6_6001["玩家"], "魔抗", -_____53EC_5524_5E08_6280_80FD_914D_7F6E["嘲讽魔抗提升"])
end
local function ____on_6781_9650_590D_82CF_7ED3_675F(_____72B6_6001)
    if _____72B6_6001 == nil then
        return
    end
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____72B6_6001["玩家"], "生命恢复效率", -_____53EC_5524_5E08_6280_80FD_914D_7F6E["极限复苏生命恢复效率提升"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____72B6_6001["玩家"], "受到的治疗率", -_____53EC_5524_5E08_6280_80FD_914D_7F6E["极限复苏受到的治疗率提升"])
end
local function _____5904_7406_5632_8BBD(_____65BD_6CD5_5355_4F4D)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    _____8C03_6574_5355_4F4D_62A4_7532(_____65BD_6CD5_5355_4F4D, _____53EC_5524_5E08_6280_80FD_914D_7F6E["嘲讽护甲提升"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____73A9_5BB6, "魔抗", _____53EC_5524_5E08_6280_80FD_914D_7F6E["嘲讽魔抗提升"])
    addDelayedCallback(_____53EC_5524_5E08_6280_80FD_914D_7F6E["临时效果持续毫秒"], ____on_5632_8BBD_7ED3_675F, {["单位"] = _____65BD_6CD5_5355_4F4D, ["玩家"] = _____73A9_5BB6})
end
local function _____5904_7406_6781_9650_590D_82CF(_____65BD_6CD5_5355_4F4D)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____73A9_5BB6, "生命恢复效率", _____53EC_5524_5E08_6280_80FD_914D_7F6E["极限复苏生命恢复效率提升"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____73A9_5BB6, "受到的治疗率", _____53EC_5524_5E08_6280_80FD_914D_7F6E["极限复苏受到的治疗率提升"])
    local _____7279_6548 = AddSpecialEffectTarget(_____53EC_5524_5E08_6280_80FD_914D_7F6E["极限复苏特效路径"], _____65BD_6CD5_5355_4F4D, _____53EC_5524_5E08_6280_80FD_914D_7F6E["极限复苏特效挂点"])
    YDWETimerDestroyEffectSafe(_____53EC_5524_5E08_6280_80FD_914D_7F6E["极限复苏特效持续秒"], _____7279_6548)
    addDelayedCallback(_____53EC_5524_5E08_6280_80FD_914D_7F6E["临时效果持续毫秒"], ____on_6781_9650_590D_82CF_7ED3_675F, {["玩家"] = _____73A9_5BB6})
end
local function _____7ED3_675F_95EA_70C1(_____72B6_6001)
    if _____72B6_6001 == nil or not (_____72B6_6001["周期回调ID"] > 0) then
        return
    end
    removePeriodicCallback(_____72B6_6001["周期回调ID"])
    _____72B6_6001["周期回调ID"] = 0
end
local function ____on_95EA_70C1_79FB_52A8(_____72B6_6001)
    if _____72B6_6001 == nil or not _____5355_4F4D_6709_6548(_____72B6_6001["单位"]) then
        _____7ED3_675F_95EA_70C1(_____72B6_6001)
        return
    end
    if _____72B6_6001["当前步数"] >= _____53EC_5524_5E08_6280_80FD_914D_7F6E["闪烁最大步数"] then
        _____7ED3_675F_95EA_70C1(_____72B6_6001)
        return
    end
    _____72B6_6001["当前步数"] = _____72B6_6001["当前步数"] + 1
    local _____79FB_52A8_8DDD_79BB = _____53EC_5524_5E08_6280_80FD_914D_7F6E["闪烁每步距离"] * _____72B6_6001["当前步数"]
    local _____79FB_52A8X = _____6781_5750_6807X(_____72B6_6001["起点X"], _____72B6_6001["方向角度"], _____79FB_52A8_8DDD_79BB)
    local _____79FB_52A8Y = _____6781_5750_6807Y(_____72B6_6001["起点Y"], _____72B6_6001["方向角度"], _____79FB_52A8_8DDD_79BB)
    if IsTerrainPathable(_____79FB_52A8X, _____79FB_52A8Y, PATHING_TYPE_WALKABILITY) then
        local _____73A9_5BB6 = GetOwningPlayer(_____72B6_6001["单位"])
        DisplayTimedTextToPlayer(
            _____73A9_5BB6,
            0,
            0,
            _____53EC_5524_5E08_6280_80FD_914D_7F6E["闪烁阻挡提示持续秒"],
            _____53EC_5524_5E08_6280_80FD_914D_7F6E["闪烁阻挡提示"]
        )
        _____7ED3_675F_95EA_70C1(_____72B6_6001)
        return
    end
    if not _____6267_884C_6218_6597_81EA_8EAB_4F4D_79FB_5230_5750_6807(_____72B6_6001["单位"], _____79FB_52A8X, _____79FB_52A8Y) then
        _____7ED3_675F_95EA_70C1(_____72B6_6001)
        return
    end
    SetUnitFacing(_____72B6_6001["单位"], _____72B6_6001["方向角度"])
    if _____72B6_6001["当前步数"] >= _____53EC_5524_5E08_6280_80FD_914D_7F6E["闪烁最大步数"] then
        _____7ED3_675F_95EA_70C1(_____72B6_6001)
    end
end
local function _____5904_7406_95EA_70C1(_____65BD_6CD5_5355_4F4D)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local _____8D77_70B9X = GetUnitX(_____65BD_6CD5_5355_4F4D)
    local _____8D77_70B9Y = GetUnitY(_____65BD_6CD5_5355_4F4D)
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____72B6_6001 = {
        ["单位"] = _____65BD_6CD5_5355_4F4D,
        ["起点X"] = _____8D77_70B9X,
        ["起点Y"] = _____8D77_70B9Y,
        ["方向角度"] = _____4E24_70B9_89D2_5EA6(_____8D77_70B9X, _____8D77_70B9Y, _____76EE_6807X, _____76EE_6807Y),
        ["当前步数"] = 0,
        ["周期回调ID"] = 0
    }
    _____72B6_6001["周期回调ID"] = addPeriodicCallback(_____53EC_5524_5E08_6280_80FD_914D_7F6E["闪烁移动间隔毫秒"], ____on_95EA_70C1_79FB_52A8, _____72B6_6001)
    if not (_____72B6_6001["周期回调ID"] > 0) then
        return
    end
end
local function ____on_53EC_5524_5E08_6280_80FD_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if _____6280_80FDID == _____5632_8BBD_6280_80FD_7C7B_578BID then
        _____5904_7406_5632_8BBD(_____65BD_6CD5_5355_4F4D)
    elseif _____6280_80FDID == _____6781_9650_590D_82CF_6280_80FD_7C7B_578BID then
        _____5904_7406_6781_9650_590D_82CF(_____65BD_6CD5_5355_4F4D)
    elseif _____6280_80FDID == _____95EA_70C1_6280_80FD_7C7B_578BID then
        _____5904_7406_95EA_70C1(_____65BD_6CD5_5355_4F4D)
    end
end
____exports["init召唤师技能"] = function()
    if _____5DF2_521D_59CB_5316_53EC_5524_5E08_6280_80FD then
        return
    end
    _____5DF2_521D_59CB_5316_53EC_5524_5E08_6280_80FD = true
    registerSpellEffectListener(____on_53EC_5524_5E08_6280_80FD_751F_6548)
end
return ____exports
