local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayUnshift = ____lualib.__TS__ArrayUnshift
local ____exports = {}
local _____53D6_53E5_67C4ID, _____8BA1_7B97_8DDD_79BB, _____76EE_6807_5DF2_547D_4E2D, _____6807_8BB0_76EE_6807_547D_4E2D, _____7ED3_675F_5F39_9053_8DF3_94FE, _____9009_62E9_4E0B_4E00_8DF3_76EE_6807, _____5F53_524D_7B5B_9009_76EE_6807, _____7EE7_7EED_590D_7528_5F39_5E55_5230_76EE_6807, _____6DFB_52A0_5F39_9053_8DF3_94FE_5EF6_8FDF_53D1_5C04_4EFB_52A1, _____5B89_6392_53D1_5C04_5230_76EE_6807, _____5B89_6392_590D_7528_5F39_5E55_5230_76EE_6807, _____6267_884C_5F39_9053_8DF3_94FE_5EF6_8FDF_53D1_5C04_4EFB_52A1, ____on_5F39_9053_8DF3_94FE_5EF6_8FDF_53D1_5C04_626B_63CF, _____53D1_5C04_5230_76EE_6807, getUnitsInRange, isUnitEnemy, isSameUnit, GetHandleId, GetUnitX, GetUnitY, SquareRoot, addPeriodicCallback, removePeriodicCallback, getServerTime, _____5EF6_8FDF_53D1_5C04_4EFB_52A1_5217_8868, _____5EF6_8FDF_53D1_5C04_626B_63CF_56DE_8C03ID
local ____03_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____03_FF0E_5BF9_5916_63A5_53E3["创建原生弹幕"]
local _____9500_6BC1_539F_751F_5F39_5E55 = ____03_FF0E_5BF9_5916_63A5_53E3["销毁原生弹幕"]
local _____83B7_53D6_539F_751F_5F39_5E55 = ____03_FF0E_5BF9_5916_63A5_53E3["获取原生弹幕"]
function _____53D6_53E5_67C4ID(h)
    return h ~= nil and h ~= 0 and (GetHandleId(h) or 0) or 0
end
function _____8BA1_7B97_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return SquareRoot(dx * dx + dy * dy)
end
function _____76EE_6807_5DF2_547D_4E2D(_____72B6_6001, _____5355_4F4D)
    if _____72B6_6001["参数"]["每单位只命中一次"] ~= true then
        return false
    end
    return _____72B6_6001["已命中单位"][_____53D6_53E5_67C4ID(_____5355_4F4D)] == true
end
function _____6807_8BB0_76EE_6807_547D_4E2D(_____72B6_6001, _____5355_4F4D)
    _____72B6_6001["已命中单位"][_____53D6_53E5_67C4ID(_____5355_4F4D)] = true
end
function _____7ED3_675F_5F39_9053_8DF3_94FE(_____72B6_6001)
    if _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["已结束"] = true
    if _____72B6_6001["参数"]["on结束"] ~= nil then
        _____72B6_6001["参数"]["on结束"]()
    end
end
function _____9009_62E9_4E0B_4E00_8DF3_76EE_6807(_____72B6_6001, _____5F53_524D_76EE_6807)
    local x = GetUnitX(_____5F53_524D_76EE_6807)
    local y = GetUnitY(_____5F53_524D_76EE_6807)
    local _____5019_9009 = getUnitsInRange(x, y, _____72B6_6001["参数"]["搜索半径"])
    local _____6700_4F73_76EE_6807 = nil
    local _____6700_4F73_8DDD_79BB = 0
    do
        local i = 0
        while i < #_____5019_9009 do
            do
                local _____5355_4F4D = _____5019_9009[i + 1]
                if isSameUnit(_____5355_4F4D, _____5F53_524D_76EE_6807) then
                    goto __continue12
                end
                if not isUnitEnemy(_____5355_4F4D, _____72B6_6001["参数"]["施法者"]) then
                    goto __continue12
                end
                if _____76EE_6807_5DF2_547D_4E2D(_____72B6_6001, _____5355_4F4D) then
                    goto __continue12
                end
                local d = _____8BA1_7B97_8DDD_79BB(
                    x,
                    y,
                    GetUnitX(_____5355_4F4D),
                    GetUnitY(_____5355_4F4D)
                )
                if _____6700_4F73_76EE_6807 == nil or d < _____6700_4F73_8DDD_79BB then
                    _____6700_4F73_76EE_6807 = _____5355_4F4D
                    _____6700_4F73_8DDD_79BB = d
                end
            end
            ::__continue12::
            i = i + 1
        end
    end
    return _____6700_4F73_76EE_6807
end
function _____5F53_524D_7B5B_9009_76EE_6807(_____72B6_6001, _____5355_4F4D)
    return isSameUnit(_____5355_4F4D, _____72B6_6001["当前目标"])
end
function _____7EE7_7EED_590D_7528_5F39_5E55_5230_76EE_6807(_____72B6_6001, _____5F39_5E55ID, _____76EE_6807_5355_4F4D)
    if _____72B6_6001["已结束"] then
        return
    end
    local _____5B9E_4F8B = _____83B7_53D6_539F_751F_5F39_5E55(_____5F39_5E55ID)
    if _____5B9E_4F8B == nil or _____5B9E_4F8B["已结束"] then
        return
    end
    _____72B6_6001["当前目标"] = _____76EE_6807_5355_4F4D
    _____5B9E_4F8B["参数"]["指定目标"] = _____76EE_6807_5355_4F4D
    _____5B9E_4F8B["参数"]["目标筛选"] = function(_____5355_4F4D)
        return _____5F53_524D_7B5B_9009_76EE_6807(_____72B6_6001, _____5355_4F4D)
    end
    _____5B9E_4F8B["当前速度"] = _____72B6_6001["参数"]["弹幕速度"]
end
function _____6DFB_52A0_5F39_9053_8DF3_94FE_5EF6_8FDF_53D1_5C04_4EFB_52A1(_____4E0A_4E0B_6587)
    _____5EF6_8FDF_53D1_5C04_4EFB_52A1_5217_8868[#_____5EF6_8FDF_53D1_5C04_4EFB_52A1_5217_8868 + 1] = _____4E0A_4E0B_6587
    if _____5EF6_8FDF_53D1_5C04_626B_63CF_56DE_8C03ID == 0 then
        _____5EF6_8FDF_53D1_5C04_626B_63CF_56DE_8C03ID = addPeriodicCallback(10, ____on_5F39_9053_8DF3_94FE_5EF6_8FDF_53D1_5C04_626B_63CF)
    end
end
function _____5B89_6392_53D1_5C04_5230_76EE_6807(_____72B6_6001, _____8D77_70B9_5355_4F4D, _____76EE_6807_5355_4F4D)
    if _____72B6_6001["已结束"] then
        return
    end
    local _____5EF6_8FDF = _____72B6_6001["参数"]["每跳延迟"] or 0
    if _____5EF6_8FDF <= 0 then
        _____53D1_5C04_5230_76EE_6807(_____72B6_6001, _____8D77_70B9_5355_4F4D, _____76EE_6807_5355_4F4D)
        return
    end
    _____6DFB_52A0_5F39_9053_8DF3_94FE_5EF6_8FDF_53D1_5C04_4EFB_52A1({
        ["到期时间毫秒"] = getServerTime() + _____5EF6_8FDF * 1000,
        ["状态"] = _____72B6_6001,
        ["起点单位"] = _____8D77_70B9_5355_4F4D,
        ["目标单位"] = _____76EE_6807_5355_4F4D
    })
end
function _____5B89_6392_590D_7528_5F39_5E55_5230_76EE_6807(_____72B6_6001, _____5F39_5E55ID, _____76EE_6807_5355_4F4D)
    if _____72B6_6001["已结束"] then
        return
    end
    local _____5EF6_8FDF = _____72B6_6001["参数"]["每跳延迟"] or 0
    if _____5EF6_8FDF <= 0 then
        _____7EE7_7EED_590D_7528_5F39_5E55_5230_76EE_6807(_____72B6_6001, _____5F39_5E55ID, _____76EE_6807_5355_4F4D)
        return
    end
    local _____5B9E_4F8B = _____83B7_53D6_539F_751F_5F39_5E55(_____5F39_5E55ID)
    if _____5B9E_4F8B ~= nil and not _____5B9E_4F8B["已结束"] then
        _____5B9E_4F8B["当前速度"] = 0
        _____72B6_6001["当前目标"] = nil
    end
    _____6DFB_52A0_5F39_9053_8DF3_94FE_5EF6_8FDF_53D1_5C04_4EFB_52A1({
        ["到期时间毫秒"] = getServerTime() + _____5EF6_8FDF * 1000,
        ["状态"] = _____72B6_6001,
        ["起点单位"] = nil,
        ["目标单位"] = _____76EE_6807_5355_4F4D,
        ["弹幕ID"] = _____5F39_5E55ID
    })
end
function _____6267_884C_5F39_9053_8DF3_94FE_5EF6_8FDF_53D1_5C04_4EFB_52A1(_____4E0A_4E0B_6587)
    if _____4E0A_4E0B_6587["状态"]["已结束"] then
        return
    end
    if _____4E0A_4E0B_6587["弹幕ID"] ~= nil then
        _____7EE7_7EED_590D_7528_5F39_5E55_5230_76EE_6807(_____4E0A_4E0B_6587["状态"], _____4E0A_4E0B_6587["弹幕ID"], _____4E0A_4E0B_6587["目标单位"])
        return
    end
    _____53D1_5C04_5230_76EE_6807(_____4E0A_4E0B_6587["状态"], _____4E0A_4E0B_6587["起点单位"], _____4E0A_4E0B_6587["目标单位"])
end
function ____on_5F39_9053_8DF3_94FE_5EF6_8FDF_53D1_5C04_626B_63CF()
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____5230_671F_4EFB_52A1 = {}
    do
        local i = #_____5EF6_8FDF_53D1_5C04_4EFB_52A1_5217_8868 - 1
        while i >= 0 do
            do
                local _____4E0A_4E0B_6587 = _____5EF6_8FDF_53D1_5C04_4EFB_52A1_5217_8868[i + 1]
                if _____5F53_524D_65F6_95F4_6BEB_79D2 < _____4E0A_4E0B_6587["到期时间毫秒"] then
                    goto __continue36
                end
                __TS__ArraySplice(_____5EF6_8FDF_53D1_5C04_4EFB_52A1_5217_8868, i, 1)
                __TS__ArrayUnshift(_____5230_671F_4EFB_52A1, _____4E0A_4E0B_6587)
            end
            ::__continue36::
            i = i - 1
        end
    end
    do
        local i = 0
        while i < #_____5230_671F_4EFB_52A1 do
            _____6267_884C_5F39_9053_8DF3_94FE_5EF6_8FDF_53D1_5C04_4EFB_52A1(_____5230_671F_4EFB_52A1[i + 1])
            i = i + 1
        end
    end
    if #_____5EF6_8FDF_53D1_5C04_4EFB_52A1_5217_8868 == 0 and _____5EF6_8FDF_53D1_5C04_626B_63CF_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____5EF6_8FDF_53D1_5C04_626B_63CF_56DE_8C03ID)
        _____5EF6_8FDF_53D1_5C04_626B_63CF_56DE_8C03ID = 0
    end
end
function _____53D1_5C04_5230_76EE_6807(_____72B6_6001, _____8D77_70B9_5355_4F4D, _____76EE_6807_5355_4F4D)
    if _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["当前目标"] = _____76EE_6807_5355_4F4D
    local _____590D_7528_5F39_5E55 = _____72B6_6001["参数"]["弹跳模式"] ~= "重建弹幕"
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = _____72B6_6001["参数"]["施法者"],
        X = GetUnitX(_____8D77_70B9_5355_4F4D),
        Y = GetUnitY(_____8D77_70B9_5355_4F4D),
        ["弹幕单位类型"] = _____72B6_6001["参数"]["弹幕单位类型"],
        ["模型"] = _____72B6_6001["参数"]["模型"],
        ["附着特效模型"] = _____72B6_6001["参数"]["附着特效模型"],
        ["速度"] = _____72B6_6001["参数"]["弹幕速度"],
        ["轨迹类型"] = "追踪",
        ["指定目标"] = _____76EE_6807_5355_4F4D,
        ["命中半径"] = _____72B6_6001["参数"]["命中半径"] or 64,
        ["伤害值"] = _____72B6_6001["当前伤害"],
        ["伤害形态"] = _____72B6_6001["参数"]["跳跃次数"] > 1 and "AOE" or "单体",
        ["碰撞消失"] = not _____590D_7528_5F39_5E55,
        ["最大距离"] = _____72B6_6001["参数"]["搜索半径"] * 2,
        ["生命周期"] = 3,
        ["目标筛选"] = function(_____5355_4F4D)
            return _____5F53_524D_7B5B_9009_76EE_6807(_____72B6_6001, _____5355_4F4D)
        end,
        ["on命中"] = function(_____547D_4E2D_5355_4F4D, _____5F39_5E55ID)
            _____6807_8BB0_76EE_6807_547D_4E2D(_____72B6_6001, _____547D_4E2D_5355_4F4D)
            _____72B6_6001["已跳次数"] = _____72B6_6001["已跳次数"] + 1
            if _____72B6_6001["已跳次数"] >= _____72B6_6001["参数"]["跳跃次数"] then
                _____7ED3_675F_5F39_9053_8DF3_94FE(_____72B6_6001)
                if _____590D_7528_5F39_5E55 then
                    _____9500_6BC1_539F_751F_5F39_5E55(_____5F39_5E55ID, "完成")
                end
                return
            end
            local _____7CFB_6570 = _____72B6_6001["参数"]["每跳伤害系数"] or 1
            _____72B6_6001["当前伤害"] = _____72B6_6001["当前伤害"] * _____7CFB_6570
            local _____4E0B_4E00_76EE_6807 = _____9009_62E9_4E0B_4E00_8DF3_76EE_6807(_____72B6_6001, _____547D_4E2D_5355_4F4D)
            if _____4E0B_4E00_76EE_6807 == nil or _____4E0B_4E00_76EE_6807 == 0 then
                _____7ED3_675F_5F39_9053_8DF3_94FE(_____72B6_6001)
                if _____590D_7528_5F39_5E55 then
                    _____9500_6BC1_539F_751F_5F39_5E55(_____5F39_5E55ID, "完成")
                end
                return
            end
            if _____590D_7528_5F39_5E55 then
                _____5B89_6392_590D_7528_5F39_5E55_5230_76EE_6807(_____72B6_6001, _____5F39_5E55ID, _____4E0B_4E00_76EE_6807)
            else
                _____5B89_6392_53D1_5C04_5230_76EE_6807(_____72B6_6001, _____547D_4E2D_5355_4F4D, _____4E0B_4E00_76EE_6807)
            end
        end,
        ["on结束"] = function()
            return
        end
    })
end
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
getUnitsInRange = ____require_result_0.getUnitsInRange
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
isUnitEnemy = ____require_result_1.isUnitEnemy
isSameUnit = ____require_result_1.isSameUnit
GetHandleId = jass.GetHandleId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
SquareRoot = jass.SquareRoot
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_2.addPeriodicCallback
removePeriodicCallback = ____require_result_2.removePeriodicCallback
getServerTime = ____require_result_2.getServerTime
_____5EF6_8FDF_53D1_5C04_4EFB_52A1_5217_8868 = {}
_____5EF6_8FDF_53D1_5C04_626B_63CF_56DE_8C03ID = 0
____exports["开始弹道跳链"] = function(_____53C2_6570)
    if _____53C2_6570["施法者"] == nil or _____53C2_6570["施法者"] == 0 then
        return
    end
    if _____53C2_6570["初始目标"] == nil or _____53C2_6570["初始目标"] == 0 then
        return
    end
    if _____53C2_6570["跳跃次数"] <= 0 then
        return
    end
    local _____72B6_6001 = {
        ["参数"] = _____53C2_6570,
        ["已跳次数"] = 0,
        ["当前伤害"] = _____53C2_6570["伤害值"] or 0,
        ["当前目标"] = _____53C2_6570["初始目标"],
        ["已命中单位"] = {},
        ["已结束"] = false
    }
    _____53D1_5C04_5230_76EE_6807(_____72B6_6001, _____53C2_6570["施法者"], _____53C2_6570["初始目标"])
end
return ____exports
