local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.01．牵引系统.00．共享")
local IsUnitPaused = ____00_FF0E_5171_4EAB.IsUnitPaused
local SetUnitPathing = ____00_FF0E_5171_4EAB.SetUnitPathing
local PauseUnit = ____00_FF0E_5171_4EAB.PauseUnit
local GetUnitX = ____00_FF0E_5171_4EAB.GetUnitX
local GetUnitY = ____00_FF0E_5171_4EAB.GetUnitY
local SetUnitX = ____00_FF0E_5171_4EAB.SetUnitX
local SetUnitY = ____00_FF0E_5171_4EAB.SetUnitY
local SetUnitFacing = ____00_FF0E_5171_4EAB.SetUnitFacing
local AddLightning = ____00_FF0E_5171_4EAB.AddLightning
local MoveLightning = ____00_FF0E_5171_4EAB.MoveLightning
local MoveLightningEx = ____00_FF0E_5171_4EAB.MoveLightningEx
local DestroyLightning = ____00_FF0E_5171_4EAB.DestroyLightning
local MAX_SUB_STEP = ____00_FF0E_5171_4EAB.MAX_SUB_STEP
local bj_DEGTORAD = ____00_FF0E_5171_4EAB.bj_DEGTORAD
local Cos = ____00_FF0E_5171_4EAB.Cos
local Sin = ____00_FF0E_5171_4EAB.Sin
local _____7275_5F15_6620_5C04 = ____00_FF0E_5171_4EAB["牵引映射"]
local _____5355_4F4D_5F53_524D_7275_5F15 = ____00_FF0E_5171_4EAB["单位当前牵引"]
local _____6D3B_52A8_7275_5F15_5217_8868 = ____00_FF0E_5171_4EAB["活动牵引列表"]
local _____5355_4F4D_5B58_6D3B = ____00_FF0E_5171_4EAB["单位存活"]
local _____5728_53EF_73A9_533A_57DF_5185 = ____00_FF0E_5171_4EAB["在可玩区域内"]
local _____8BA1_7B97_5750_6807_8DDD_79BB = ____00_FF0E_5171_4EAB["计算坐标距离"]
local _____8BA1_7B97_671D_5411_89D2_5EA6 = ____00_FF0E_5171_4EAB["计算朝向角度"]
local X_IsTerrainWalkable = ____00_FF0E_5171_4EAB.X_IsTerrainWalkable
local X_IsUnitTerrainWalkable = ____00_FF0E_5171_4EAB.X_IsUnitTerrainWalkable
local X_GetAbleX = ____00_FF0E_5171_4EAB.X_GetAbleX
local X_GetAbleY = ____00_FF0E_5171_4EAB.X_GetAbleY
____exports["销毁闪电"] = function(_____5B9E_4F8B)
    local _____95EA_7535 = _____5B9E_4F8B["闪电句柄"]
    if _____95EA_7535 ~= nil and _____95EA_7535 ~= 0 and type(DestroyLightning) == "function" then
        DestroyLightning(_____95EA_7535)
    end
    _____5B9E_4F8B["闪电句柄"] = nil
end
local function _____5C1D_8BD5_89E6_53D1_5230_8FBE_56DE_8C03(_____5B9E_4F8B, _____8DDD_79BB_4E2D_5FC3)
    if _____5B9E_4F8B["已触发到达回调"] or _____5B9E_4F8B["到达距离"] <= 0 then
        return false
    end
    if _____8DDD_79BB_4E2D_5FC3 > _____5B9E_4F8B["到达距离"] then
        return false
    end
    _____5B9E_4F8B["已触发到达回调"] = true
    if type(_____5B9E_4F8B["到达回调"]) == "function" then
        _____5B9E_4F8B["到达回调"](_____5B9E_4F8B["单位"], _____5B9E_4F8B.id)
    end
    return _____5B9E_4F8B["到达后结束"] == true
end
local function _____5185_90E8_79FB_9664_7275_5F15(_____5B9E_4F8B)
    __TS__Delete(_____7275_5F15_6620_5C04, _____5B9E_4F8B.id)
    if _____5355_4F4D_5F53_524D_7275_5F15[_____5B9E_4F8B["单位ID"]] == _____5B9E_4F8B.id then
        __TS__Delete(_____5355_4F4D_5F53_524D_7275_5F15, _____5B9E_4F8B["单位ID"])
    end
    ____exports["销毁闪电"](_____5B9E_4F8B)
    local idx = _____5B9E_4F8B.listIndex
    local lastIdx = #_____6D3B_52A8_7275_5F15_5217_8868 - 1
    if idx ~= lastIdx then
        local last = _____6D3B_52A8_7275_5F15_5217_8868[lastIdx + 1]
        _____6D3B_52A8_7275_5F15_5217_8868[idx + 1] = last
        last.listIndex = idx
    end
    table.remove(_____6D3B_52A8_7275_5F15_5217_8868)
end
____exports["更新闪电"] = function(_____5B9E_4F8B)
    if not _____5B9E_4F8B["启用闪电效果"] or type(AddLightning) ~= "function" then
        return
    end
    local _____5355_4F4DX = GetUnitX(_____5B9E_4F8B["单位"])
    local _____5355_4F4DY = GetUnitY(_____5B9E_4F8B["单位"])
    local _____4E2D_5FC3X = _____5B9E_4F8B["中心X"]
    local _____4E2D_5FC3Y = _____5B9E_4F8B["中心Y"]
    if _____5B9E_4F8B["闪电句柄"] == nil or _____5B9E_4F8B["闪电句柄"] == 0 then
        _____5B9E_4F8B["闪电句柄"] = AddLightning(
            _____5B9E_4F8B["闪电效果代码"],
            false,
            _____5355_4F4DX,
            _____5355_4F4DY,
            _____4E2D_5FC3X,
            _____4E2D_5FC3Y
        )
        return
    end
    if type(MoveLightningEx) == "function" then
        MoveLightningEx(
            _____5B9E_4F8B["闪电句柄"],
            false,
            _____5355_4F4DX,
            _____5355_4F4DY,
            _____5B9E_4F8B["闪电高度"],
            _____4E2D_5FC3X,
            _____4E2D_5FC3Y,
            _____5B9E_4F8B["闪电高度"]
        )
    elseif type(MoveLightning) == "function" then
        MoveLightning(
            _____5B9E_4F8B["闪电句柄"],
            false,
            _____5355_4F4DX,
            _____5355_4F4DY,
            _____4E2D_5FC3X,
            _____4E2D_5FC3Y
        )
    end
end
local function _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____4F4D_79FB_8DDD_79BB)
    local _____5F53_524DX = GetUnitX(_____5B9E_4F8B["单位"])
    local _____5F53_524DY = GetUnitY(_____5B9E_4F8B["单位"])
    local _____8DDD_79BB_4E2D_5FC3 = _____8BA1_7B97_5750_6807_8DDD_79BB(_____5F53_524DX, _____5F53_524DY, _____5B9E_4F8B["中心X"], _____5B9E_4F8B["中心Y"])
    if _____5B9E_4F8B["最大牵引距离"] > 0 and _____8DDD_79BB_4E2D_5FC3 > _____5B9E_4F8B["最大牵引距离"] then
        return {["停止"] = true, ["原因"] = "超距断开"}
    end
    if _____5C1D_8BD5_89E6_53D1_5230_8FBE_56DE_8C03(_____5B9E_4F8B, _____8DDD_79BB_4E2D_5FC3) then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    if _____8DDD_79BB_4E2D_5FC3 <= _____5B9E_4F8B["最小距离"] then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    local _____5B9E_9645_4F4D_79FB = _____4F4D_79FB_8DDD_79BB >= _____8DDD_79BB_4E2D_5FC3 - _____5B9E_4F8B["最小距离"] and _____8DDD_79BB_4E2D_5FC3 - _____5B9E_4F8B["最小距离"] or _____4F4D_79FB_8DDD_79BB
    if _____5B9E_9645_4F4D_79FB <= 0 then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    local _____89D2_5EA6 = _____8BA1_7B97_671D_5411_89D2_5EA6(_____5F53_524DX, _____5F53_524DY, _____5B9E_4F8B["中心X"], _____5B9E_4F8B["中心Y"])
    local _____5F27_5EA6 = _____89D2_5EA6 * bj_DEGTORAD
    local _____65B0X = _____5F53_524DX + _____5B9E_9645_4F4D_79FB * Cos(_____5F27_5EA6)
    local _____65B0Y = _____5F53_524DY + _____5B9E_9645_4F4D_79FB * Sin(_____5F27_5EA6)
    if not _____5728_53EF_73A9_533A_57DF_5185(_____65B0X, _____65B0Y) then
        return {["停止"] = true, ["原因"] = "阻挡"}
    end
    if _____5B9E_4F8B["检查地形"] and not X_IsTerrainWalkable(nil, _____65B0X, _____65B0Y) then
        local ableDist = _____8BA1_7B97_5750_6807_8DDD_79BB(
            _____65B0X,
            _____65B0Y,
            X_GetAbleX(nil),
            X_GetAbleY(nil)
        )
        if ableDist > 8 then
            return {["停止"] = true, ["原因"] = "阻挡"}
        end
    end
    if _____5B9E_4F8B["检查地形"] and not X_IsUnitTerrainWalkable(_____5B9E_4F8B["单位"], _____65B0X, _____65B0Y) then
        return {["停止"] = true, ["原因"] = "阻挡"}
    end
    SetUnitX(_____5B9E_4F8B["单位"], _____65B0X)
    SetUnitY(_____5B9E_4F8B["单位"], _____65B0Y)
    if _____5B9E_4F8B["朝向跟随牵引"] then
        SetUnitFacing(_____5B9E_4F8B["单位"], _____89D2_5EA6)
    end
    local _____65B0_8DDD_79BB_4E2D_5FC3 = _____8BA1_7B97_5750_6807_8DDD_79BB(_____65B0X, _____65B0Y, _____5B9E_4F8B["中心X"], _____5B9E_4F8B["中心Y"])
    if _____5C1D_8BD5_89E6_53D1_5230_8FBE_56DE_8C03(_____5B9E_4F8B, _____65B0_8DDD_79BB_4E2D_5FC3) then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    return {["停止"] = false}
end
____exports["结束牵引实例"] = function(_____5B9E_4F8B, _____539F_56E0)
    if _____7275_5F15_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
        return
    end
    if _____5B9E_4F8B["禁用碰撞"] then
        SetUnitPathing(_____5B9E_4F8B["单位"], true)
    end
    if _____5B9E_4F8B["暂停单位"] then
        PauseUnit(_____5B9E_4F8B["单位"], false)
    end
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____7275_5F15ID = _____5B9E_4F8B.id
    local _____7ED3_675F_56DE_8C03 = _____5B9E_4F8B["结束回调"]
    _____5185_90E8_79FB_9664_7275_5F15(_____5B9E_4F8B)
    if type(_____7ED3_675F_56DE_8C03) == "function" then
        _____7ED3_675F_56DE_8C03(_____5355_4F4D, _____539F_56E0, _____7275_5F15ID)
    end
end
____exports["推进牵引实例"] = function(_____5B9E_4F8B)
    if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
        ____exports["结束牵引实例"](_____5B9E_4F8B, "死亡")
        return
    end
    if _____5B9E_4F8B["主单位死亡时中断"] and _____5B9E_4F8B["主单位"] ~= nil and _____5B9E_4F8B["主单位"] ~= 0 and not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["主单位"]) then
        ____exports["结束牵引实例"](_____5B9E_4F8B, "主单位死亡")
        return
    end
    if _____5B9E_4F8B["中心单位"] ~= nil and _____5B9E_4F8B["中心单位"] ~= 0 then
        if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["中心单位"]) then
            ____exports["结束牵引实例"](_____5B9E_4F8B, "中心失效")
            return
        end
        _____5B9E_4F8B["中心X"] = GetUnitX(_____5B9E_4F8B["中心单位"])
        _____5B9E_4F8B["中心Y"] = GetUnitY(_____5B9E_4F8B["中心单位"])
    end
    if _____5B9E_4F8B["外部暂停时中断"] and not _____5B9E_4F8B["暂停单位"] and IsUnitPaused(_____5B9E_4F8B["单位"]) == true then
        ____exports["结束牵引实例"](_____5B9E_4F8B, "中断")
        return
    end
    _____5B9E_4F8B["已运行Tick数"] = _____5B9E_4F8B["已运行Tick数"] + 1
    if _____5B9E_4F8B["已运行Tick数"] > _____5B9E_4F8B["持续Tick数"] then
        ____exports["结束牵引实例"](_____5B9E_4F8B, "完成")
        return
    end
    local _____5269_4F59_4F4D_79FB = _____5B9E_4F8B["每Tick位移"]
    while _____5269_4F59_4F4D_79FB > 0 do
        local _____5B50_6B65_957F = _____5269_4F59_4F4D_79FB > MAX_SUB_STEP and MAX_SUB_STEP or _____5269_4F59_4F4D_79FB
        local _____7ED3_679C = _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____5B50_6B65_957F)
        if _____7ED3_679C["停止"] then
            ____exports["结束牵引实例"](_____5B9E_4F8B, _____7ED3_679C["原因"] or "完成")
            return
        end
        _____5269_4F59_4F4D_79FB = _____5269_4F59_4F4D_79FB - _____5B50_6B65_957F
    end
    ____exports["更新闪电"](_____5B9E_4F8B)
end
return ____exports
