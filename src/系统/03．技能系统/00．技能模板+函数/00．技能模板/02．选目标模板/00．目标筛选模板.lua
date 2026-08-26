local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
local _____5355_4F4D_6EE1_8DB3_6280_80FD_7B5B_9009_6761_4EF6, isValidUnit, isUnitEnemy, isUnitAlly, _____83B7_53D6_77E9_5F62_533A_57DF_5355_4F4D
function _____5355_4F4D_6EE1_8DB3_6280_80FD_7B5B_9009_6761_4EF6(_____5355_4F4D, _____53C2_6570)
    if not isValidUnit(_____5355_4F4D) then
        return false
    end
    if _____53C2_6570["排除单位"] ~= nil and _____53C2_6570["排除单位"] ~= 0 and _____5355_4F4D == _____53C2_6570["排除单位"] then
        return false
    end
    local _____5F71_54CD_76EE_6807 = _____53C2_6570["影响目标"] or "全部"
    if _____5F71_54CD_76EE_6807 == "敌方" then
        if _____53C2_6570["来源单位"] == nil or _____53C2_6570["来源单位"] == 0 then
            return false
        end
        if not isUnitEnemy(_____5355_4F4D, _____53C2_6570["来源单位"]) then
            return false
        end
    elseif _____5F71_54CD_76EE_6807 == "友方" then
        if _____53C2_6570["来源单位"] == nil or _____53C2_6570["来源单位"] == 0 then
            return false
        end
        if not isUnitAlly(_____5355_4F4D, _____53C2_6570["来源单位"]) then
            return false
        end
    end
    local _____81EA_5B9A_4E49_6761_4EF6 = _____53C2_6570["自定义条件"]
    if _____81EA_5B9A_4E49_6761_4EF6 ~= nil and not _____81EA_5B9A_4E49_6761_4EF6(_____5355_4F4D) then
        return false
    end
    return true
end
____exports["获取矩形区域内单位组"] = function(_____53C2_6570)
    return _____83B7_53D6_77E9_5F62_533A_57DF_5355_4F4D({
        X = _____53C2_6570.X,
        Y = _____53C2_6570.Y,
        ["长度"] = _____53C2_6570["长度"],
        ["宽度"] = _____53C2_6570["宽度"],
        ["方向角"] = _____53C2_6570["方向角"],
        ["英雄技能距离修正"] = _____53C2_6570["英雄技能距离修正"],
        ["包含边界"] = _____53C2_6570["包含边界"],
        ["单位筛选"] = function(_____5355_4F4D)
            return _____5355_4F4D_6EE1_8DB3_6280_80FD_7B5B_9009_6761_4EF6(_____5355_4F4D, _____53C2_6570)
        end
    })
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index")
local _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB = ____require_result_0["按英雄技能距离修正上下文修正距离"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_1.getUnitsInRange
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
isValidUnit = ____require_result_2.isValidUnit
isUnitEnemy = ____require_result_2.isUnitEnemy
isUnitAlly = ____require_result_2.isUnitAlly
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D = ____require_result_3["获取扇形区域单位"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.矩形区域")
_____83B7_53D6_77E9_5F62_533A_57DF_5355_4F4D = ____require_result_4["获取矩形区域单位"]
local function _____8BA1_7B97_5E73_65B9_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end
local function _____83B7_53D6_7B5B_9009_540E_5355_4F4D_5217_8868(_____53C2_6570)
    if _____53C2_6570["半径"] <= 0 then
        return {}
    end
    local _____534A_5F84 = _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB(_____53C2_6570["半径"], _____53C2_6570["英雄技能距离修正"], "效果半径")
    local _____5355_4F4D_5217_8868 = getUnitsInRange(_____53C2_6570.X, _____53C2_6570.Y, _____534A_5F84)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        if _____5355_4F4D_6EE1_8DB3_6280_80FD_7B5B_9009_6761_4EF6(_____5355_4F4D, _____53C2_6570) then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____5355_4F4D
        end
    end
    return _____7ED3_679C
end
____exports["获取范围内单位组"] = function(_____53C2_6570)
    return _____83B7_53D6_7B5B_9009_540E_5355_4F4D_5217_8868(_____53C2_6570)
end
____exports["选择范围内最近目标"] = function(_____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____83B7_53D6_7B5B_9009_540E_5355_4F4D_5217_8868(_____53C2_6570)
    local _____6700_4F73_76EE_6807 = nil
    local _____6700_4F73_8DDD_79BB_5E73_65B9 = 0
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____8DDD_79BB_5E73_65B9 = _____8BA1_7B97_5E73_65B9_8DDD_79BB(
            _____53C2_6570.X,
            _____53C2_6570.Y,
            GetUnitX(_____5355_4F4D),
            GetUnitY(_____5355_4F4D)
        )
        if _____6700_4F73_76EE_6807 == nil or _____8DDD_79BB_5E73_65B9 < _____6700_4F73_8DDD_79BB_5E73_65B9 then
            _____6700_4F73_76EE_6807 = _____5355_4F4D
            _____6700_4F73_8DDD_79BB_5E73_65B9 = _____8DDD_79BB_5E73_65B9
        end
    end
    return _____6700_4F73_76EE_6807
end
____exports["选择范围内最远目标"] = function(_____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____83B7_53D6_7B5B_9009_540E_5355_4F4D_5217_8868(_____53C2_6570)
    local _____6700_4F73_76EE_6807 = nil
    local _____6700_4F73_8DDD_79BB_5E73_65B9 = 0
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____8DDD_79BB_5E73_65B9 = _____8BA1_7B97_5E73_65B9_8DDD_79BB(
            _____53C2_6570.X,
            _____53C2_6570.Y,
            GetUnitX(_____5355_4F4D),
            GetUnitY(_____5355_4F4D)
        )
        if _____6700_4F73_76EE_6807 == nil or _____8DDD_79BB_5E73_65B9 > _____6700_4F73_8DDD_79BB_5E73_65B9 then
            _____6700_4F73_76EE_6807 = _____5355_4F4D
            _____6700_4F73_8DDD_79BB_5E73_65B9 = _____8DDD_79BB_5E73_65B9
        end
    end
    return _____6700_4F73_76EE_6807
end
____exports["选择范围内血量最低目标"] = function(_____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____83B7_53D6_7B5B_9009_540E_5355_4F4D_5217_8868(_____53C2_6570)
    local _____6700_4F73_76EE_6807 = nil
    local _____6700_4F4E_8840_91CF = 0
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____5F53_524D_8840_91CF = GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE)
        if _____6700_4F73_76EE_6807 == nil or _____5F53_524D_8840_91CF < _____6700_4F4E_8840_91CF then
            _____6700_4F73_76EE_6807 = _____5355_4F4D
            _____6700_4F4E_8840_91CF = _____5F53_524D_8840_91CF
        end
    end
    return _____6700_4F73_76EE_6807
end
____exports["选择范围内血量最高目标"] = function(_____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____83B7_53D6_7B5B_9009_540E_5355_4F4D_5217_8868(_____53C2_6570)
    local _____6700_4F73_76EE_6807 = nil
    local _____6700_9AD8_8840_91CF = 0
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____5F53_524D_8840_91CF = GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE)
        if _____6700_4F73_76EE_6807 == nil or _____5F53_524D_8840_91CF > _____6700_9AD8_8840_91CF then
            _____6700_4F73_76EE_6807 = _____5355_4F4D
            _____6700_9AD8_8840_91CF = _____5F53_524D_8840_91CF
        end
    end
    return _____6700_4F73_76EE_6807
end
____exports["选择主目标和副目标"] = function(_____53C2_6570)
    local _____7ED3_679C = {["主目标"] = _____53C2_6570["主目标"], ["副目标列表"] = {}}
    if _____53C2_6570["主目标"] == nil or _____53C2_6570["主目标"] == 0 then
        return _____7ED3_679C
    end
    if _____53C2_6570["副目标数量"] <= 0 then
        return _____7ED3_679C
    end
    local _____526F_76EE_6807_7B5B_9009_53C2_6570 = {
        X = _____53C2_6570.X,
        Y = _____53C2_6570.Y,
        ["半径"] = _____53C2_6570["半径"],
        ["英雄技能距离修正"] = _____53C2_6570["英雄技能距离修正"],
        ["来源单位"] = _____53C2_6570["来源单位"],
        ["影响目标"] = _____53C2_6570["影响目标"],
        ["排除单位"] = _____53C2_6570["主目标"],
        ["自定义条件"] = _____53C2_6570["自定义条件"]
    }
    local _____5019_9009_5355_4F4D = _____83B7_53D6_7B5B_9009_540E_5355_4F4D_5217_8868(_____526F_76EE_6807_7B5B_9009_53C2_6570)
    __TS__ArraySort(
        _____5019_9009_5355_4F4D,
        function(____, a, b)
            return _____8BA1_7B97_5E73_65B9_8DDD_79BB(
                _____53C2_6570.X,
                _____53C2_6570.Y,
                GetUnitX(a),
                GetUnitY(a)
            ) - _____8BA1_7B97_5E73_65B9_8DDD_79BB(
                _____53C2_6570.X,
                _____53C2_6570.Y,
                GetUnitX(b),
                GetUnitY(b)
            )
        end
    )
    local _____5DF2_6DFB_52A0_6570_91CF = 0
    for ____, _____5355_4F4D in ipairs(_____5019_9009_5355_4F4D) do
        local ____7ED3_679C__526F_76EE_6807_5217_8868_5 = _____7ED3_679C["副目标列表"]
        ____7ED3_679C__526F_76EE_6807_5217_8868_5[#____7ED3_679C__526F_76EE_6807_5217_8868_5 + 1] = _____5355_4F4D
        _____5DF2_6DFB_52A0_6570_91CF = _____5DF2_6DFB_52A0_6570_91CF + 1
        if _____5DF2_6DFB_52A0_6570_91CF >= _____53C2_6570["副目标数量"] then
            break
        end
    end
    return _____7ED3_679C
end
____exports["选择扇形区域内最近目标"] = function(_____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = _____53C2_6570.X,
        Y = _____53C2_6570.Y,
        ["半径"] = _____53C2_6570["半径"],
        ["方向角"] = _____53C2_6570["方向角"],
        ["扇形角度"] = _____53C2_6570["扇形角度"],
        ["英雄技能距离修正"] = _____53C2_6570["英雄技能距离修正"],
        ["包含边界"] = _____53C2_6570["包含边界"],
        ["单位筛选"] = function(_____5355_4F4D)
            return _____5355_4F4D_6EE1_8DB3_6280_80FD_7B5B_9009_6761_4EF6(_____5355_4F4D, _____53C2_6570)
        end
    })
    local _____6700_4F73_76EE_6807 = nil
    local _____6700_4F73_8DDD_79BB_5E73_65B9 = 0
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____8DDD_79BB_5E73_65B9 = _____8BA1_7B97_5E73_65B9_8DDD_79BB(
            _____53C2_6570.X,
            _____53C2_6570.Y,
            GetUnitX(_____5355_4F4D),
            GetUnitY(_____5355_4F4D)
        )
        if _____6700_4F73_76EE_6807 == nil or _____8DDD_79BB_5E73_65B9 < _____6700_4F73_8DDD_79BB_5E73_65B9 then
            _____6700_4F73_76EE_6807 = _____5355_4F4D
            _____6700_4F73_8DDD_79BB_5E73_65B9 = _____8DDD_79BB_5E73_65B9
        end
    end
    return _____6700_4F73_76EE_6807
end
____exports["选择矩形区域内最近目标"] = function(_____53C2_6570)
    local _____5355_4F4D_5217_8868 = ____exports["获取矩形区域内单位组"](_____53C2_6570)
    local _____6700_4F73_76EE_6807 = nil
    local _____6700_4F73_8DDD_79BB_5E73_65B9 = 0
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____8DDD_79BB_5E73_65B9 = _____8BA1_7B97_5E73_65B9_8DDD_79BB(
            _____53C2_6570.X,
            _____53C2_6570.Y,
            GetUnitX(_____5355_4F4D),
            GetUnitY(_____5355_4F4D)
        )
        if _____6700_4F73_76EE_6807 == nil or _____8DDD_79BB_5E73_65B9 < _____6700_4F73_8DDD_79BB_5E73_65B9 then
            _____6700_4F73_76EE_6807 = _____5355_4F4D
            _____6700_4F73_8DDD_79BB_5E73_65B9 = _____8DDD_79BB_5E73_65B9
        end
    end
    return _____6700_4F73_76EE_6807
end
____exports["技能筛选范围单位"] = ____exports["获取范围内单位组"]
____exports["技能筛选最近目标"] = ____exports["选择范围内最近目标"]
____exports["技能筛选最远目标"] = ____exports["选择范围内最远目标"]
____exports["技能筛选最低血量目标"] = ____exports["选择范围内血量最低目标"]
____exports["技能筛选最高血量目标"] = ____exports["选择范围内血量最高目标"]
____exports["技能筛选主目标和副目标"] = ____exports["选择主目标和副目标"]
____exports["技能筛选扇形区域最近目标"] = ____exports["选择扇形区域内最近目标"]
____exports["技能筛选矩形区域最近目标"] = ____exports["选择矩形区域内最近目标"]
____exports["技能筛选矩形区域单位组"] = ____exports["获取矩形区域内单位组"]
return ____exports
