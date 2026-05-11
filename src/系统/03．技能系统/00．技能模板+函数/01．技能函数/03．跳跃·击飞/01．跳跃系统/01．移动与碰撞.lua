--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
local X_IsTerrainWalkable = ____00_FF0E_5171_4EAB.X_IsTerrainWalkable
local X_GetAbleX = ____00_FF0E_5171_4EAB.X_GetAbleX
local X_GetAbleY = ____00_FF0E_5171_4EAB.X_GetAbleY
local BJ_DEGTORAD = ____00_FF0E_5171_4EAB.BJ_DEGTORAD
local MAX_SUB_STEP = ____00_FF0E_5171_4EAB.MAX_SUB_STEP
local WALKABLE_TOLERANCE = ____00_FF0E_5171_4EAB.WALKABLE_TOLERANCE
local _____8DF3_8DC3_6620_5C04 = ____00_FF0E_5171_4EAB["跳跃映射"]
local _____5728_53EF_73A9_533A_57DF_5185 = ____00_FF0E_5171_4EAB["在可玩区域内"]
local _____8BA1_7B97_5750_6807_8DDD_79BB = ____00_FF0E_5171_4EAB["计算坐标距离"]
local _____8BA1_7B97_629B_7269_7EBF_9AD8_5EA6 = ____00_FF0E_5171_4EAB["计算抛物线高度"]
local _____64AD_653E_8DF3_8DC3_7279_6548 = ____00_FF0E_5171_4EAB["播放跳跃特效"]
local GetUnitX = ____00_FF0E_5171_4EAB.GetUnitX
local GetUnitY = ____00_FF0E_5171_4EAB.GetUnitY
local GetUnitFlyHeight = ____00_FF0E_5171_4EAB.GetUnitFlyHeight
local SetUnitFlyHeight = ____00_FF0E_5171_4EAB.SetUnitFlyHeight
local SetUnitFacing = ____00_FF0E_5171_4EAB.SetUnitFacing
local SetUnitX = ____00_FF0E_5171_4EAB.SetUnitX
local SetUnitY = ____00_FF0E_5171_4EAB.SetUnitY
local Cos = ____00_FF0E_5171_4EAB.Cos
local Sin = ____00_FF0E_5171_4EAB.Sin
local function _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____4F4D_79FB_8DDD_79BB)
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____5F53_524DX = GetUnitX(_____5355_4F4D)
    local _____5F53_524DY = GetUnitY(_____5355_4F4D)
    local _____5F27_5EA6 = _____5B9E_4F8B["角度"] * BJ_DEGTORAD
    local _____65B0X = _____5F53_524DX + _____4F4D_79FB_8DDD_79BB * Cos(_____5F27_5EA6)
    local _____65B0Y = _____5F53_524DY + _____4F4D_79FB_8DDD_79BB * Sin(_____5F27_5EA6)
    if not _____5728_53EF_73A9_533A_57DF_5185(_____65B0X, _____65B0Y) then
        return {["停止"] = true, ["原因"] = "阻挡"}
    end
    if not X_IsTerrainWalkable(nil, _____65B0X, _____65B0Y) then
        local _____53EF_901A_884CX = X_GetAbleX(nil)
        local _____53EF_901A_884CY = X_GetAbleY(nil)
        local ableDist = _____8BA1_7B97_5750_6807_8DDD_79BB(_____65B0X, _____65B0Y, _____53EF_901A_884CX, _____53EF_901A_884CY)
        if ableDist > WALKABLE_TOLERANCE then
            return {["停止"] = true, ["原因"] = "阻挡"}
        end
    end
    local _____843D_70B9_8FC7_6EE4 = _____5B9E_4F8B["落点过滤"]
    if type(_____843D_70B9_8FC7_6EE4) == "function" and not _____843D_70B9_8FC7_6EE4(_____65B0X, _____65B0Y, _____5355_4F4D, _____5B9E_4F8B.id) then
        return {["停止"] = true, ["原因"] = "阻挡"}
    end
    if _____5B9E_4F8B["朝向跟随跳跃"] then
        SetUnitFacing(_____5355_4F4D, _____5B9E_4F8B["角度"])
    end
    SetUnitX(_____5355_4F4D, _____65B0X)
    SetUnitY(_____5355_4F4D, _____65B0Y)
    _____5B9E_4F8B["已移动"] = _____5B9E_4F8B["已移动"] + _____4F4D_79FB_8DDD_79BB
    local _____8FDB_5EA6 = _____5B9E_4F8B["总距离"] > 0 and _____5B9E_4F8B["已移动"] / _____5B9E_4F8B["总距离"] or 1
    local _____65B0_9644_52A0_9AD8_5EA6 = _____8BA1_7B97_629B_7269_7EBF_9AD8_5EA6(_____8FDB_5EA6, _____5B9E_4F8B["跳跃高度"])
    local _____5F53_524D_9AD8_5EA6 = GetUnitFlyHeight(_____5355_4F4D)
    SetUnitFlyHeight(_____5355_4F4D, _____5F53_524D_9AD8_5EA6 - _____5B9E_4F8B["上次附加高度"] + _____65B0_9644_52A0_9AD8_5EA6, 0)
    _____5B9E_4F8B["上次附加高度"] = _____65B0_9644_52A0_9AD8_5EA6
    if _____5B9E_4F8B["已移动"] >= _____5B9E_4F8B["总距离"] then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    return {["停止"] = false}
end
____exports["推进一步"] = function(_____5B9E_4F8B)
    local _____8D77_59CB_5DF2_79FB_52A8 = _____5B9E_4F8B["已移动"]
    local _____5269_4F59_8DDD_79BB = _____5B9E_4F8B["总距离"] - _____5B9E_4F8B["已移动"]
    if _____5269_4F59_8DDD_79BB <= 0 then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    local _____672Ctick_4F4D_79FB = _____5B9E_4F8B["每tick位移"]
    if _____672Ctick_4F4D_79FB > _____5269_4F59_8DDD_79BB then
        _____672Ctick_4F4D_79FB = _____5269_4F59_8DDD_79BB
    end
    if _____672Ctick_4F4D_79FB <= 0 then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    local _____5269_4F59_6B65_957F = _____672Ctick_4F4D_79FB
    while _____5269_4F59_6B65_957F > 0 do
        local _____5B50_6B65_957F = _____5269_4F59_6B65_957F > MAX_SUB_STEP and MAX_SUB_STEP or _____5269_4F59_6B65_957F
        local _____7ED3_679C = _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____5B50_6B65_957F)
        if _____7ED3_679C["停止"] then
            if _____5B9E_4F8B["已移动"] > _____8D77_59CB_5DF2_79FB_52A8 then
                _____64AD_653E_8DF3_8DC3_7279_6548(_____5B9E_4F8B)
            end
            return _____7ED3_679C
        end
        if _____8DF3_8DC3_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
            return {["停止"] = true, ["原因"] = "中断"}
        end
        _____5269_4F59_6B65_957F = _____5269_4F59_6B65_957F - _____5B50_6B65_957F
    end
    if _____5B9E_4F8B["已移动"] > _____8D77_59CB_5DF2_79FB_52A8 then
        _____64AD_653E_8DF3_8DC3_7279_6548(_____5B9E_4F8B)
    end
    return {["停止"] = false}
end
return ____exports
