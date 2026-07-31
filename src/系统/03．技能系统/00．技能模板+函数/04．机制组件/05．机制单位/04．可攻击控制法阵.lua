local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____9500_6BC1_6CD5_9635_9644_52A0_7279_6548, DestroyEffect, _____53EF_653B_51FB_63A7_5236_6CD5_9635_9644_52A0_7279_6548_8868
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
function _____9500_6BC1_6CD5_9635_9644_52A0_7279_6548(id)
    local _____7279_6548_5217_8868 = _____53EF_653B_51FB_63A7_5236_6CD5_9635_9644_52A0_7279_6548_8868[id]
    if _____7279_6548_5217_8868 == nil then
        return
    end
    __TS__Delete(_____53EF_653B_51FB_63A7_5236_6CD5_9635_9644_52A0_7279_6548_8868, id)
    do
        local i = 0
        while i < #_____7279_6548_5217_8868 do
            local _____7279_6548 = _____7279_6548_5217_8868[i + 1]
            if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
                DestroyEffect(_____7279_6548)
            end
            i = i + 1
        end
    end
end
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local AddSpecialEffect = jass.AddSpecialEffect
DestroyEffect = jass.DestroyEffect
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_SetUnitMovableSafe = ____require_result_1.X_SetUnitMovableSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____8BBE_7F6E_7279_6548_7F29_653E = ____require_result_2["设置特效缩放"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local _____53EF_653B_51FB_63A7_5236_6CD5_9635_6B7B_4EA1_4E0A_4E0B_6587_8868 = {}
_____53EF_653B_51FB_63A7_5236_6CD5_9635_9644_52A0_7279_6548_8868 = {}
local function _____53D6_6CD5_9635_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____53D6_6CD5_9635_76EE_6807_5217_8868(_____53C2_6570)
    if _____53C2_6570["目标列表"] ~= nil then
        return _____53C2_6570["目标列表"]
    end
    if _____53C2_6570["取目标列表"] ~= nil then
        return _____53C2_6570["取目标列表"](_____53C2_6570["变量"])
    end
    return {}
end
local function _____76EE_6807_662F_5426_5728_6CD5_9635_5185(_____53C2_6570, _____76EE_6807)
    if _____53C2_6570["目标有效"] ~= nil and not _____53C2_6570["目标有效"](_____76EE_6807, _____53C2_6570["变量"]) then
        return false
    end
    local dx = GetUnitX(_____76EE_6807) - _____53C2_6570.X
    local dy = GetUnitY(_____76EE_6807) - _____53C2_6570.Y
    return dx * dx + dy * dy <= _____53C2_6570["半径"] * _____53C2_6570["半径"]
end
local function _____6536_96C6_5E76_65BD_52A0_6CD5_9635_63A7_5236(_____53C2_6570)
    local _____76EE_6807_5217_8868 = _____53D6_6CD5_9635_76EE_6807_5217_8868(_____53C2_6570)
    local _____53D7_5F71_54CD_76EE_6807 = {}
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            do
                local _____76EE_6807 = _____76EE_6807_5217_8868[i + 1]
                if not _____76EE_6807_662F_5426_5728_6CD5_9635_5185(_____53C2_6570, _____76EE_6807) then
                    goto __continue11
                end
                _____53C2_6570["施加控制"](_____76EE_6807, _____53C2_6570["持续秒"], _____53C2_6570["变量"])
                _____53D7_5F71_54CD_76EE_6807[#_____53D7_5F71_54CD_76EE_6807 + 1] = _____76EE_6807
            end
            ::__continue11::
            i = i + 1
        end
    end
    return _____53D7_5F71_54CD_76EE_6807
end
local function _____53EF_653B_51FB_63A7_5236_6CD5_9635_6B7B_4EA1(_____5355_4F4D)
    local id = _____53D6_6CD5_9635_5355_4F4DID(_____5355_4F4D)
    if id == 0 then
        return
    end
    _____9500_6BC1_6CD5_9635_9644_52A0_7279_6548(id)
    local _____4E0A_4E0B_6587 = _____53EF_653B_51FB_63A7_5236_6CD5_9635_6B7B_4EA1_4E0A_4E0B_6587_8868[id]
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    __TS__Delete(_____53EF_653B_51FB_63A7_5236_6CD5_9635_6B7B_4EA1_4E0A_4E0B_6587_8868, id)
    local _____53C2_6570 = _____4E0A_4E0B_6587["参数"]
    local _____53D7_5F71_54CD_76EE_6807 = _____4E0A_4E0B_6587["受影响目标"]
    if _____53C2_6570["摧毁特效路径"] ~= nil and _____53C2_6570["摧毁特效路径"] ~= "" then
        local _____6467_6BC1_7279_6548 = AddSpecialEffect(_____53C2_6570["摧毁特效路径"], _____53C2_6570.X, _____53C2_6570.Y)
        if _____6467_6BC1_7279_6548 ~= nil and _____6467_6BC1_7279_6548 ~= 0 then
            YDWETimerDestroyEffectSafe(1, _____6467_6BC1_7279_6548)
        end
    end
    do
        local i = 0
        while i < #_____53D7_5F71_54CD_76EE_6807 do
            do
                local _____76EE_6807 = _____53D7_5F71_54CD_76EE_6807[i + 1]
                if _____53C2_6570["目标有效"] ~= nil and not _____53C2_6570["目标有效"](_____76EE_6807, _____53C2_6570["变量"]) then
                    goto __continue19
                end
                _____53C2_6570["施加控制"](_____76EE_6807, _____53C2_6570["摧毁后剩余秒"], _____53C2_6570["变量"])
            end
            ::__continue19::
            i = i + 1
        end
    end
    if _____53C2_6570["on摧毁"] ~= nil then
        _____53C2_6570["on摧毁"](_____53D7_5F71_54CD_76EE_6807, _____53C2_6570["变量"])
    end
end
local function _____53EF_653B_51FB_63A7_5236_6CD5_9635_9500_6BC1(_____5355_4F4D)
    local id = _____53D6_6CD5_9635_5355_4F4DID(_____5355_4F4D)
    if id == 0 then
        return
    end
    __TS__Delete(_____53EF_653B_51FB_63A7_5236_6CD5_9635_6B7B_4EA1_4E0A_4E0B_6587_8868, id)
    _____9500_6BC1_6CD5_9635_9644_52A0_7279_6548(id)
end
local function _____767B_8BB0_6CD5_9635_9644_52A0_7279_6548(id, _____7279_6548)
    if _____7279_6548 == nil or _____7279_6548 == 0 then
        return
    end
    local _____7279_6548_5217_8868 = _____53EF_653B_51FB_63A7_5236_6CD5_9635_9644_52A0_7279_6548_8868[id]
    if _____7279_6548_5217_8868 == nil then
        _____7279_6548_5217_8868 = {}
        _____53EF_653B_51FB_63A7_5236_6CD5_9635_9644_52A0_7279_6548_8868[id] = _____7279_6548_5217_8868
    end
    _____7279_6548_5217_8868[#_____7279_6548_5217_8868 + 1] = _____7279_6548
end
local function _____53EF_653B_51FB_63A7_5236_6CD5_9635_6301_7EED_65F6_95F4_5230_671F(variable)
    local data = variable
    local ____temp_5 = data == nil or data["实例"] == nil
    if not ____temp_5 then
        local ____self_4 = data["实例"]
        ____temp_5 = not ____self_4["是否存活"](____self_4)
    end
    if ____temp_5 then
        return
    end
    local ____self_6 = data["实例"]
    ____self_6["销毁"](____self_6)
end
____exports["创建可攻击控制法阵"] = function(_____53C2_6570)
    local _____53D7_5F71_54CD_76EE_6807 = _____6536_96C6_5E76_65BD_52A0_6CD5_9635_63A7_5236(_____53C2_6570)
    local _____5B9E_4F8B = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = _____53C2_6570["清理"],
        ["名称"] = _____53C2_6570["名称"],
        ["主人单位"] = _____53C2_6570["主人单位"],
        ["所属玩家"] = _____53C2_6570["所属玩家"],
        ["单位类型"] = _____53C2_6570["单位类型"],
        ["模型路径"] = _____53C2_6570["模型路径"],
        ["固定站桩"] = true,
        X = _____53C2_6570.X,
        Y = _____53C2_6570.Y,
        ["最大生命"] = _____53C2_6570["最大生命"],
        ["缩放"] = _____53C2_6570["缩放"],
        ["持续时间"] = _____53C2_6570["持续秒"],
        ["on死亡"] = _____53EF_653B_51FB_63A7_5236_6CD5_9635_6B7B_4EA1,
        ["on销毁"] = _____53EF_653B_51FB_63A7_5236_6CD5_9635_9500_6BC1
    })
    if _____5B9E_4F8B ~= nil then
        _____53EF_653B_51FB_63A7_5236_6CD5_9635_6B7B_4EA1_4E0A_4E0B_6587_8868[_____5B9E_4F8B.ID] = {["参数"] = _____53C2_6570, ["受影响目标"] = _____53D7_5F71_54CD_76EE_6807}
    end
    if _____5B9E_4F8B == nil then
        return nil
    end
    X_SetUnitMovableSafe(_____5B9E_4F8B["单位"], false)
    if _____53C2_6570["创建特效路径"] ~= nil and _____53C2_6570["创建特效路径"] ~= "" then
        _____767B_8BB0_6CD5_9635_9644_52A0_7279_6548(
            _____5B9E_4F8B.ID,
            AddSpecialEffect(_____53C2_6570["创建特效路径"], _____53C2_6570.X, _____53C2_6570.Y)
        )
    end
    if _____53C2_6570["旋涡特效路径"] ~= nil and _____53C2_6570["旋涡特效路径"] ~= "" then
        local _____65CB_6DA1 = AddSpecialEffect(_____53C2_6570["旋涡特效路径"], _____53C2_6570.X, _____53C2_6570.Y)
        if _____53C2_6570["旋涡特效缩放"] ~= nil and _____53C2_6570["旋涡特效缩放"] > 0 then
            _____8BBE_7F6E_7279_6548_7F29_653E(_____65CB_6DA1, _____53C2_6570["旋涡特效缩放"])
        end
        _____767B_8BB0_6CD5_9635_9644_52A0_7279_6548(_____5B9E_4F8B.ID, _____65CB_6DA1)
    end
    if _____53C2_6570["持续秒"] > 0 then
        local _____5230_671F_53D8_91CF = {["实例"] = _____5B9E_4F8B}
        local _____56DE_8C03ID = addDelayedCallback(_____53C2_6570["持续秒"] * 1000, _____53EF_653B_51FB_63A7_5236_6CD5_9635_6301_7EED_65F6_95F4_5230_671F, _____5230_671F_53D8_91CF)
        if _____53C2_6570["清理"] ~= nil then
            local ____self_7 = _____53C2_6570["清理"]
            ____self_7["登记延迟回调"](____self_7, _____53C2_6570["名称"] .. "-持续时间", _____56DE_8C03ID)
        end
    end
    if _____53C2_6570["on创建"] ~= nil then
        _____53C2_6570["on创建"](_____5B9E_4F8B, _____53D7_5F71_54CD_76EE_6807, _____53C2_6570["变量"])
    end
    return _____5B9E_4F8B
end
return ____exports
