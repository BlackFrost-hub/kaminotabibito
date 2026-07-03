local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local AddSpecialEffect = jass.AddSpecialEffect
local _____53EF_653B_51FB_63A7_5236_6CD5_9635_6B7B_4EA1_4E0A_4E0B_6587_8868 = {}
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
    local _____4E0A_4E0B_6587 = _____53EF_653B_51FB_63A7_5236_6CD5_9635_6B7B_4EA1_4E0A_4E0B_6587_8868[id]
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    __TS__Delete(_____53EF_653B_51FB_63A7_5236_6CD5_9635_6B7B_4EA1_4E0A_4E0B_6587_8868, id)
    local _____53C2_6570 = _____4E0A_4E0B_6587["参数"]
    local _____53D7_5F71_54CD_76EE_6807 = _____4E0A_4E0B_6587["受影响目标"]
    if _____53C2_6570["摧毁特效路径"] ~= nil and _____53C2_6570["摧毁特效路径"] ~= "" then
        AddSpecialEffect(_____53C2_6570["摧毁特效路径"], _____53C2_6570.X, _____53C2_6570.Y)
    end
    do
        local i = 0
        while i < #_____53D7_5F71_54CD_76EE_6807 do
            do
                local _____76EE_6807 = _____53D7_5F71_54CD_76EE_6807[i + 1]
                if _____53C2_6570["目标有效"] ~= nil and not _____53C2_6570["目标有效"](_____76EE_6807, _____53C2_6570["变量"]) then
                    goto __continue18
                end
                _____53C2_6570["施加控制"](_____76EE_6807, _____53C2_6570["摧毁后剩余秒"], _____53C2_6570["变量"])
            end
            ::__continue18::
            i = i + 1
        end
    end
    if _____53C2_6570["on摧毁"] ~= nil then
        _____53C2_6570["on摧毁"](_____53D7_5F71_54CD_76EE_6807, _____53C2_6570["变量"])
    end
end
local function _____53EF_653B_51FB_63A7_5236_6CD5_9635_9500_6BC1(_____5355_4F4D)
    local id = _____53D6_6CD5_9635_5355_4F4DID(_____5355_4F4D)
    if id ~= 0 then
        __TS__Delete(_____53EF_653B_51FB_63A7_5236_6CD5_9635_6B7B_4EA1_4E0A_4E0B_6587_8868, id)
    end
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
    if _____53C2_6570["创建特效路径"] ~= nil and _____53C2_6570["创建特效路径"] ~= "" then
        AddSpecialEffect(_____53C2_6570["创建特效路径"], _____53C2_6570.X, _____53C2_6570.Y)
    end
    if _____53C2_6570["on创建"] ~= nil then
        _____53C2_6570["on创建"](_____5B9E_4F8B, _____53D7_5F71_54CD_76EE_6807, _____53C2_6570["变量"])
    end
    return _____5B9E_4F8B
end
return ____exports
