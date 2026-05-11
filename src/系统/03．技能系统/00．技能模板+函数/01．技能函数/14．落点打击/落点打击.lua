local ____lualib = require("lualib_bundle")
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 落点打击模板
-- 
-- 说明：
-- 1. 用于“延迟后在指定点生效”的技能模板，例如落雷、陨石、延迟爆点。
-- 2. 支持多段落点、随机散布、提示半径与伤害半径分离。
-- 3. 当前版本不做取消接口，主打快速复用。
local jass = require("jass.common")
local AddSpecialEffect = jass.AddSpecialEffect
local CreateTimer = jass.CreateTimer
local DestroyEffect = jass.DestroyEffect
local GetExpiredTimer = jass.GetExpiredTimer
local GetHandleId = jass.GetHandleId
local GetRandomReal = jass.GetRandomReal
local UnitDamageTarget = jass.UnitDamageTarget
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_1.CosBJ
local SinBJ = ____require_result_1.SinBJ
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_2.getUnitsInRange
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_3.isUnitEnemy
local isUnitAlly = ____require_result_3.isUnitAlly
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
local _____521B_5EFA_6E10_53D8_5706_5F62_63D0_793A_5708 = ____require_result_4["创建渐变圆形提示圈"]
local _____9ED8_8BA4_843D_96F7_7279_6548 = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl"
local _____9ED8_8BA4_653B_51FB_7C7B_578B = jass.ATTACK_TYPE_NORMAL
local _____9ED8_8BA4_4F24_5BB3_7C7B_578B = jass.DAMAGE_TYPE_NORMAL
local _____9ED8_8BA4_6B66_5668_7C7B_578B = jass.WEAPON_TYPE_WHOKNOWS
local _____843D_70B9_6253_51FB_5B9E_4F8B_8868 = {}
local _____843D_70B9_6253_51FB_5B9A_65F6_5668_4E0A_4E0B_6587_8868 = {}
local _____4E0B_4E00_4E2A_843D_70B9_6253_51FBID = 0
local function _____53D6_53E5_67C4ID(h)
    if h == nil or h == 0 then
        return 0
    end
    return GetHandleId(h) or 0
end
local function _____5355_4F4D_662F_5426_53D7_5F71_54CD(_____76EE_6807_5355_4F4D, _____53C2_6570)
    local _____5F71_54CD_76EE_6807 = _____53C2_6570["影响目标"] or "敌方"
    local _____6240_6709_8005 = _____53C2_6570["所有者"]
    if _____5F71_54CD_76EE_6807 == "全部" then
        return true
    end
    if _____6240_6709_8005 == nil or _____6240_6709_8005 == 0 then
        return true
    end
    if _____5F71_54CD_76EE_6807 == "敌方" then
        return isUnitEnemy(_____76EE_6807_5355_4F4D, _____6240_6709_8005)
    end
    return isUnitAlly(_____76EE_6807_5355_4F4D, _____6240_6709_8005)
end
local function _____5355_4F4D_662F_5426_8FD8_80FD_547D_4E2D(_____5B9E_4F8B, _____5355_4F4D)
    local _____6700_5927_547D_4E2D_6B21_6570 = _____5B9E_4F8B["参数"]["每单位最大命中次数"]
    if _____6700_5927_547D_4E2D_6B21_6570 == nil or _____6700_5927_547D_4E2D_6B21_6570 <= 0 then
        return true
    end
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID <= 0 then
        return true
    end
    return (_____5B9E_4F8B["单位命中次数"][_____5355_4F4DID] or 0) < _____6700_5927_547D_4E2D_6B21_6570
end
local function _____8BB0_5F55_5355_4F4D_547D_4E2D_6B21_6570(_____5B9E_4F8B, _____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID <= 0 then
        return
    end
    _____5B9E_4F8B["单位命中次数"][_____5355_4F4DID] = (_____5B9E_4F8B["单位命中次数"][_____5355_4F4DID] or 0) + 1
end
local function _____8BA1_7B97_4E24_70B9_8DDD_79BB_5E73_65B9(ax, ay, bx, by)
    local dx = ax - bx
    local dy = ay - by
    return dx * dx + dy * dy
end
local function _____8BA1_7B97_843D_70B9_6700_5C0F_95F4_8DDD(_____53C2_6570)
    if _____53C2_6570["最小落点间距"] ~= nil and _____53C2_6570["最小落点间距"] > 0 then
        return _____53C2_6570["最小落点间距"]
    end
    if (_____53C2_6570["落点数量"] or 1) <= 1 then
        return 0
    end
    if _____53C2_6570["伤害半径"] <= 0 then
        return 0
    end
    return _____53C2_6570["伤害半径"] * 0.45
end
local function _____8BA1_7B97_5019_9009_70B9_5230_5DF2_6709_843D_70B9_7684_6700_5C0F_8DDD_79BB_5E73_65B9(_____5DF2_6709_843D_70B9, _____5019_9009X, _____5019_9009Y)
    if #_____5DF2_6709_843D_70B9 <= 0 then
        return 999999999
    end
    local _____6700_5C0F_8DDD_79BB_5E73_65B9 = 999999999
    for ____, _____5DF2_6709_843D_70B9_4FE1_606F in ipairs(_____5DF2_6709_843D_70B9) do
        local _____8DDD_79BB_5E73_65B9 = _____8BA1_7B97_4E24_70B9_8DDD_79BB_5E73_65B9(_____5019_9009X, _____5019_9009Y, _____5DF2_6709_843D_70B9_4FE1_606F.X, _____5DF2_6709_843D_70B9_4FE1_606F.Y)
        if _____8DDD_79BB_5E73_65B9 < _____6700_5C0F_8DDD_79BB_5E73_65B9 then
            _____6700_5C0F_8DDD_79BB_5E73_65B9 = _____8DDD_79BB_5E73_65B9
        end
    end
    return _____6700_5C0F_8DDD_79BB_5E73_65B9
end
local function _____751F_6210_968F_673A_5019_9009_843D_70B9(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____6563_5E03_534A_5F84, _____89E6_53D1_5EF6_8FDF)
    if _____6563_5E03_534A_5F84 <= 0 then
        return {X = _____4E2D_5FC3X, Y = _____4E2D_5FC3Y, ["触发延迟"] = _____89E6_53D1_5EF6_8FDF}
    end
    while true do
        do
            local _____504F_79FBX = GetRandomReal(-_____6563_5E03_534A_5F84, _____6563_5E03_534A_5F84)
            local _____504F_79FBY = GetRandomReal(-_____6563_5E03_534A_5F84, _____6563_5E03_534A_5F84)
            if _____504F_79FBX * _____504F_79FBX + _____504F_79FBY * _____504F_79FBY > _____6563_5E03_534A_5F84 * _____6563_5E03_534A_5F84 then
                goto __continue25
            end
            return {X = _____4E2D_5FC3X + _____504F_79FBX, Y = _____4E2D_5FC3Y + _____504F_79FBY, ["触发延迟"] = _____89E6_53D1_5EF6_8FDF}
        end
        ::__continue25::
    end
end
local function _____751F_6210_968F_673A_77E9_5F62_5019_9009_843D_70B9(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____957F_5EA6, _____5BBD_5EA6, _____65B9_5411_89D2, _____89E6_53D1_5EF6_8FDF)
    if _____957F_5EA6 <= 0 or _____5BBD_5EA6 <= 0 then
        return {X = _____4E2D_5FC3X, Y = _____4E2D_5FC3Y, ["触发延迟"] = _____89E6_53D1_5EF6_8FDF}
    end
    local _____524D_540E_504F_79FB = GetRandomReal(-_____957F_5EA6 * 0.5, _____957F_5EA6 * 0.5)
    local _____5DE6_53F3_504F_79FB = GetRandomReal(-_____5BBD_5EA6 * 0.5, _____5BBD_5EA6 * 0.5)
    local _____524D_5411X = CosBJ(_____65B9_5411_89D2)
    local _____524D_5411Y = SinBJ(_____65B9_5411_89D2)
    local _____53F3_5411X = CosBJ(_____65B9_5411_89D2 - 90)
    local _____53F3_5411Y = SinBJ(_____65B9_5411_89D2 - 90)
    return {X = _____4E2D_5FC3X + _____524D_5411X * _____524D_540E_504F_79FB + _____53F3_5411X * _____5DE6_53F3_504F_79FB, Y = _____4E2D_5FC3Y + _____524D_5411Y * _____524D_540E_504F_79FB + _____53F3_5411Y * _____5DE6_53F3_504F_79FB, ["触发延迟"] = _____89E6_53D1_5EF6_8FDF}
end
local function _____751F_6210_5355_4E2A_843D_70B9(_____53C2_6570, _____5DF2_6709_843D_70B9, _____89E6_53D1_5EF6_8FDF)
    local _____968F_673A_533A_57DF_5F62_72B6 = _____53C2_6570["随机区域形状"] or "圆形"
    local _____6563_5E03_534A_5F84 = _____53C2_6570["随机散布半径"] ~= nil and _____53C2_6570["随机散布半径"] > 0 and _____53C2_6570["随机散布半径"] or 0
    local _____77E9_5F62_957F_5EA6 = _____53C2_6570["随机矩形长度"] ~= nil and _____53C2_6570["随机矩形长度"] > 0 and _____53C2_6570["随机矩形长度"] or 0
    local _____77E9_5F62_5BBD_5EA6 = _____53C2_6570["随机矩形宽度"] ~= nil and _____53C2_6570["随机矩形宽度"] > 0 and _____53C2_6570["随机矩形宽度"] or 0
    local _____65B9_5411_89D2 = _____53C2_6570["随机区域方向角"] or 0
    if _____968F_673A_533A_57DF_5F62_72B6 == "矩形" then
        if _____77E9_5F62_957F_5EA6 <= 0 or _____77E9_5F62_5BBD_5EA6 <= 0 then
            return {X = _____53C2_6570.X, Y = _____53C2_6570.Y, ["触发延迟"] = _____89E6_53D1_5EF6_8FDF}
        end
    elseif _____6563_5E03_534A_5F84 <= 0 then
        return {X = _____53C2_6570.X, Y = _____53C2_6570.Y, ["触发延迟"] = _____89E6_53D1_5EF6_8FDF}
    end
    local _____6700_5C0F_843D_70B9_95F4_8DDD = _____8BA1_7B97_843D_70B9_6700_5C0F_95F4_8DDD(_____53C2_6570)
    local _____6700_5C0F_843D_70B9_95F4_8DDD_5E73_65B9 = _____6700_5C0F_843D_70B9_95F4_8DDD * _____6700_5C0F_843D_70B9_95F4_8DDD
    local _____6700_5927_5C1D_8BD5_6B21_6570 = _____53C2_6570["随机取点最大尝试次数"] ~= nil and _____53C2_6570["随机取点最大尝试次数"] > 0 and _____53C2_6570["随机取点最大尝试次数"] or 32
    local _____6700_4F73_5019_9009 = _____968F_673A_533A_57DF_5F62_72B6 == "矩形" and _____751F_6210_968F_673A_77E9_5F62_5019_9009_843D_70B9(
        _____53C2_6570.X,
        _____53C2_6570.Y,
        _____77E9_5F62_957F_5EA6,
        _____77E9_5F62_5BBD_5EA6,
        _____65B9_5411_89D2,
        _____89E6_53D1_5EF6_8FDF
    ) or _____751F_6210_968F_673A_5019_9009_843D_70B9(_____53C2_6570.X, _____53C2_6570.Y, _____6563_5E03_534A_5F84, _____89E6_53D1_5EF6_8FDF)
    local _____6700_4F73_5019_9009_6700_5C0F_8DDD_79BB_5E73_65B9 = _____8BA1_7B97_5019_9009_70B9_5230_5DF2_6709_843D_70B9_7684_6700_5C0F_8DDD_79BB_5E73_65B9(_____5DF2_6709_843D_70B9, _____6700_4F73_5019_9009.X, _____6700_4F73_5019_9009.Y)
    local i = 1
    while i < _____6700_5927_5C1D_8BD5_6B21_6570 do
        local _____5019_9009 = _____968F_673A_533A_57DF_5F62_72B6 == "矩形" and _____751F_6210_968F_673A_77E9_5F62_5019_9009_843D_70B9(
            _____53C2_6570.X,
            _____53C2_6570.Y,
            _____77E9_5F62_957F_5EA6,
            _____77E9_5F62_5BBD_5EA6,
            _____65B9_5411_89D2,
            _____89E6_53D1_5EF6_8FDF
        ) or _____751F_6210_968F_673A_5019_9009_843D_70B9(_____53C2_6570.X, _____53C2_6570.Y, _____6563_5E03_534A_5F84, _____89E6_53D1_5EF6_8FDF)
        local _____5019_9009_6700_5C0F_8DDD_79BB_5E73_65B9 = _____8BA1_7B97_5019_9009_70B9_5230_5DF2_6709_843D_70B9_7684_6700_5C0F_8DDD_79BB_5E73_65B9(_____5DF2_6709_843D_70B9, _____5019_9009.X, _____5019_9009.Y)
        if _____5019_9009_6700_5C0F_8DDD_79BB_5E73_65B9 >= _____6700_5C0F_843D_70B9_95F4_8DDD_5E73_65B9 then
            return _____5019_9009
        end
        if _____5019_9009_6700_5C0F_8DDD_79BB_5E73_65B9 > _____6700_4F73_5019_9009_6700_5C0F_8DDD_79BB_5E73_65B9 then
            _____6700_4F73_5019_9009 = _____5019_9009
            _____6700_4F73_5019_9009_6700_5C0F_8DDD_79BB_5E73_65B9 = _____5019_9009_6700_5C0F_8DDD_79BB_5E73_65B9
        end
        i = i + 1
    end
    return _____6700_4F73_5019_9009
end
local function _____53D6_843D_70B9_4E0E_5176_4ED6_70B9_7684_6700_5C0F_8DDD_79BB_5E73_65B9(_____843D_70B9_5217_8868, _____5E8F_53F7)
    local _____5F53_524D_843D_70B9 = _____843D_70B9_5217_8868[_____5E8F_53F7 + 1]
    if _____5F53_524D_843D_70B9 == nil then
        return 0
    end
    local _____6700_5C0F_8DDD_79BB_5E73_65B9 = 999999999
    local i = 0
    while i < #_____843D_70B9_5217_8868 do
        if i ~= _____5E8F_53F7 then
            local _____5176_4ED6_843D_70B9 = _____843D_70B9_5217_8868[i + 1]
            if _____5176_4ED6_843D_70B9 ~= nil then
                local _____8DDD_79BB_5E73_65B9 = _____8BA1_7B97_4E24_70B9_8DDD_79BB_5E73_65B9(_____5F53_524D_843D_70B9.X, _____5F53_524D_843D_70B9.Y, _____5176_4ED6_843D_70B9.X, _____5176_4ED6_843D_70B9.Y)
                if _____8DDD_79BB_5E73_65B9 < _____6700_5C0F_8DDD_79BB_5E73_65B9 then
                    _____6700_5C0F_8DDD_79BB_5E73_65B9 = _____8DDD_79BB_5E73_65B9
                end
            end
        end
        i = i + 1
    end
    return _____6700_5C0F_8DDD_79BB_5E73_65B9
end
local function _____8F7B_5EA6_6253_6563_843D_70B9_5217_8868(_____53C2_6570, _____843D_70B9_5217_8868)
    if #_____843D_70B9_5217_8868 <= 2 then
        return
    end
    local _____6700_5C0F_843D_70B9_95F4_8DDD = _____8BA1_7B97_843D_70B9_6700_5C0F_95F4_8DDD(_____53C2_6570)
    if _____6700_5C0F_843D_70B9_95F4_8DDD <= 0 then
        return
    end
    local _____76EE_6807_8DDD_79BB_5E73_65B9 = _____6700_5C0F_843D_70B9_95F4_8DDD * _____6700_5C0F_843D_70B9_95F4_8DDD
    local _____603B_8F6E_6570 = 2
    local _____5355_70B9_91CD_62BD_6B21_6570 = 8
    local _____8F6E_6B21 = 0
    while _____8F6E_6B21 < _____603B_8F6E_6570 do
        local _____6700_6324_5E8F_53F7 = -1
        local _____6700_6324_8DDD_79BB_5E73_65B9 = 999999999
        local i = 0
        while i < #_____843D_70B9_5217_8868 do
            local _____5F53_524D_6700_5C0F_8DDD_79BB_5E73_65B9 = _____53D6_843D_70B9_4E0E_5176_4ED6_70B9_7684_6700_5C0F_8DDD_79BB_5E73_65B9(_____843D_70B9_5217_8868, i)
            if _____5F53_524D_6700_5C0F_8DDD_79BB_5E73_65B9 < _____6700_6324_8DDD_79BB_5E73_65B9 then
                _____6700_6324_8DDD_79BB_5E73_65B9 = _____5F53_524D_6700_5C0F_8DDD_79BB_5E73_65B9
                _____6700_6324_5E8F_53F7 = i
            end
            i = i + 1
        end
        if _____6700_6324_5E8F_53F7 < 0 or _____6700_6324_8DDD_79BB_5E73_65B9 >= _____76EE_6807_8DDD_79BB_5E73_65B9 then
            return
        end
        local _____5F53_524D_843D_70B9 = _____843D_70B9_5217_8868[_____6700_6324_5E8F_53F7 + 1]
        if _____5F53_524D_843D_70B9 == nil then
            return
        end
        local _____5176_4ED6_843D_70B9 = __TS__ArrayFilter(
            _____843D_70B9_5217_8868,
            function(____, _, _____7D22_5F15) return _____7D22_5F15 ~= _____6700_6324_5E8F_53F7 end
        )
        local _____6700_4F73_5019_9009 = _____5F53_524D_843D_70B9
        local _____6700_4F73_5019_9009_8DDD_79BB_5E73_65B9 = _____6700_6324_8DDD_79BB_5E73_65B9
        local j = 0
        while j < _____5355_70B9_91CD_62BD_6B21_6570 do
            local _____5019_9009 = _____751F_6210_5355_4E2A_843D_70B9(_____53C2_6570, _____5176_4ED6_843D_70B9, _____5F53_524D_843D_70B9["触发延迟"])
            local _____5019_9009_8DDD_79BB_5E73_65B9 = _____8BA1_7B97_5019_9009_70B9_5230_5DF2_6709_843D_70B9_7684_6700_5C0F_8DDD_79BB_5E73_65B9(_____5176_4ED6_843D_70B9, _____5019_9009.X, _____5019_9009.Y)
            if _____5019_9009_8DDD_79BB_5E73_65B9 > _____6700_4F73_5019_9009_8DDD_79BB_5E73_65B9 then
                _____6700_4F73_5019_9009 = _____5019_9009
                _____6700_4F73_5019_9009_8DDD_79BB_5E73_65B9 = _____5019_9009_8DDD_79BB_5E73_65B9
                if _____5019_9009_8DDD_79BB_5E73_65B9 >= _____76EE_6807_8DDD_79BB_5E73_65B9 then
                    break
                end
            end
            j = j + 1
        end
        _____843D_70B9_5217_8868[_____6700_6324_5E8F_53F7 + 1] = _____6700_4F73_5019_9009
        _____8F6E_6B21 = _____8F6E_6B21 + 1
    end
end
local function _____521B_5EFA_843D_70B9_5217_8868(_____53C2_6570)
    local _____843D_70B9_6570_91CF = _____53C2_6570["落点数量"] ~= nil and _____53C2_6570["落点数量"] > 0 and _____53C2_6570["落点数量"] or 1
    local _____843D_70B9_95F4_9694 = _____53C2_6570["落点间隔"] ~= nil and _____53C2_6570["落点间隔"] > 0 and _____53C2_6570["落点间隔"] or 0
    local _____7ED3_679C = {}
    local i = 0
    while i < _____843D_70B9_6570_91CF do
        _____7ED3_679C[#_____7ED3_679C + 1] = _____751F_6210_5355_4E2A_843D_70B9(_____53C2_6570, _____7ED3_679C, _____53C2_6570["延迟时间"] + i * _____843D_70B9_95F4_9694)
        i = i + 1
    end
    _____8F7B_5EA6_6253_6563_843D_70B9_5217_8868(_____53C2_6570, _____7ED3_679C)
    return _____7ED3_679C
end
local function _____521B_5EFA_843D_70B9_63D0_793A_7279_6548(_____53C2_6570, _____843D_70B9)
    if _____53C2_6570["提示特效启用"] == false then
        return
    end
    local _____63D0_793A_534A_5F84 = _____53C2_6570["提示半径"] or _____53C2_6570["伤害半径"]
    if _____63D0_793A_534A_5F84 <= 0 or _____843D_70B9["触发延迟"] <= 0 then
        return
    end
    _____521B_5EFA_6E10_53D8_5706_5F62_63D0_793A_5708(
        _____843D_70B9.X,
        _____843D_70B9.Y,
        _____63D0_793A_534A_5F84,
        _____843D_70B9["触发延迟"],
        _____53C2_6570["提示特效动画速度"]
    )
end
local function _____521B_5EFA_843D_70B9_547D_4E2D_7279_6548(_____53C2_6570, X, Y)
    local _____6A21_578B_8DEF_5F84 = _____53C2_6570["落点特效模型"] or _____9ED8_8BA4_843D_96F7_7279_6548
    local _____7279_6548 = AddSpecialEffect(_____6A21_578B_8DEF_5F84, X, Y)
    if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
        DestroyEffect(_____7279_6548)
    end
end
local function _____7ED3_7B97_5355_6B21_843D_70B9_4F24_5BB3(_____5B9E_4F8B, _____843D_70B9_5E8F_53F7)
    local _____843D_70B9 = _____5B9E_4F8B["落点列表"][_____843D_70B9_5E8F_53F7 + 1]
    if _____843D_70B9 == nil then
        return
    end
    _____521B_5EFA_843D_70B9_547D_4E2D_7279_6548(_____5B9E_4F8B["参数"], _____843D_70B9.X, _____843D_70B9.Y)
    local ____opt_5 = _____5B9E_4F8B["参数"]["on单次生效"]
    if ____opt_5 ~= nil then
        ____opt_5(_____843D_70B9.X, _____843D_70B9.Y, _____843D_70B9_5E8F_53F7 + 1, _____5B9E_4F8B.id)
    end
    local _____4F24_5BB3_503C = _____5B9E_4F8B["参数"]["伤害值"] or 0
    if _____4F24_5BB3_503C > 0 and _____5B9E_4F8B["参数"]["伤害半径"] > 0 then
        local _____5355_4F4D_5217_8868 = getUnitsInRange(_____843D_70B9.X, _____843D_70B9.Y, _____5B9E_4F8B["参数"]["伤害半径"])
        for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
            do
                if not _____5355_4F4D_662F_5426_53D7_5F71_54CD(_____5355_4F4D, _____5B9E_4F8B["参数"]) then
                    goto __continue64
                end
                if not _____5355_4F4D_662F_5426_8FD8_80FD_547D_4E2D(_____5B9E_4F8B, _____5355_4F4D) then
                    goto __continue64
                end
                local ____5B9E_4F8B__53C2_6570__6240_6709_8005_7 = _____5B9E_4F8B["参数"]["所有者"]
                if ____5B9E_4F8B__53C2_6570__6240_6709_8005_7 == nil then
                    ____5B9E_4F8B__53C2_6570__6240_6709_8005_7 = _____5355_4F4D
                end
                local ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_8 = _____5B9E_4F8B["参数"]["攻击类型"]
                if ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_8 == nil then
                    ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_8 = _____9ED8_8BA4_653B_51FB_7C7B_578B
                end
                local ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_9 = _____5B9E_4F8B["参数"]["伤害类型"]
                if ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_9 == nil then
                    ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_9 = _____9ED8_8BA4_4F24_5BB3_7C7B_578B
                end
                local ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_10 = _____5B9E_4F8B["参数"]["武器类型"]
                if ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_10 == nil then
                    ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_10 = _____9ED8_8BA4_6B66_5668_7C7B_578B
                end
                UnitDamageTarget(
                    ____5B9E_4F8B__53C2_6570__6240_6709_8005_7,
                    _____5355_4F4D,
                    _____4F24_5BB3_503C,
                    false,
                    false,
                    ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_8,
                    ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_9,
                    ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_10
                )
                _____8BB0_5F55_5355_4F4D_547D_4E2D_6B21_6570(_____5B9E_4F8B, _____5355_4F4D)
                local ____opt_11 = _____5B9E_4F8B["参数"]["on单次命中"]
                if ____opt_11 ~= nil then
                    ____opt_11(_____5355_4F4D, _____843D_70B9_5E8F_53F7 + 1, _____5B9E_4F8B.id)
                end
            end
            ::__continue64::
        end
    end
end
local function _____7ED3_675F_843D_70B9_6253_51FB_5B9E_4F8B(_____5B9E_4F8BID)
    local _____5B9E_4F8B = _____843D_70B9_6253_51FB_5B9E_4F8B_8868[_____5B9E_4F8BID]
    if _____5B9E_4F8B == nil then
        return
    end
    __TS__Delete(_____843D_70B9_6253_51FB_5B9E_4F8B_8868, _____5B9E_4F8BID)
    local ____opt_13 = _____5B9E_4F8B["参数"]["on全部完成"]
    if ____opt_13 ~= nil then
        ____opt_13(_____5B9E_4F8BID)
    end
end
local function ____on_843D_70B9_6253_51FB_5B9A_65F6_5668_5230_65F6()
    local t = GetExpiredTimer()
    if not t then
        return
    end
    local _____5B9A_65F6_5668ID = _____53D6_53E5_67C4ID(t)
    local _____4E0A_4E0B_6587 = _____843D_70B9_6253_51FB_5B9A_65F6_5668_4E0A_4E0B_6587_8868[_____5B9A_65F6_5668ID]
    __TS__Delete(_____843D_70B9_6253_51FB_5B9A_65F6_5668_4E0A_4E0B_6587_8868, _____5B9A_65F6_5668ID)
    safeDestroyTimer(t)
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    local _____5B9E_4F8B = _____843D_70B9_6253_51FB_5B9E_4F8B_8868[_____4E0A_4E0B_6587["实例ID"]]
    if _____5B9E_4F8B == nil then
        return
    end
    _____7ED3_7B97_5355_6B21_843D_70B9_4F24_5BB3(_____5B9E_4F8B, _____4E0A_4E0B_6587["落点序号"])
    _____5B9E_4F8B["剩余落点数"] = _____5B9E_4F8B["剩余落点数"] - 1
    if _____5B9E_4F8B["剩余落点数"] <= 0 then
        _____7ED3_675F_843D_70B9_6253_51FB_5B9E_4F8B(_____5B9E_4F8B.id)
    end
end
local function _____542F_52A8_5355_4E2A_843D_70B9_8BA1_65F6_5668(_____5B9E_4F8BID, _____843D_70B9_5E8F_53F7, _____5EF6_8FDF)
    local t = CreateTimer()
    if not t then
        return
    end
    _____843D_70B9_6253_51FB_5B9A_65F6_5668_4E0A_4E0B_6587_8868[_____53D6_53E5_67C4ID(t)] = {["实例ID"] = _____5B9E_4F8BID, ["落点序号"] = _____843D_70B9_5E8F_53F7}
    safeTimerStart(t, _____5EF6_8FDF, false, ____on_843D_70B9_6253_51FB_5B9A_65F6_5668_5230_65F6)
end
____exports["创建落点打击"] = function(_____53C2_6570)
    if _____53C2_6570["伤害半径"] <= 0 then
        return 0
    end
    local _____843D_70B9_5217_8868 = _____521B_5EFA_843D_70B9_5217_8868(_____53C2_6570)
    if #_____843D_70B9_5217_8868 <= 0 then
        return 0
    end
    local _____5B9E_4F8BID = _____4E0B_4E00_4E2A_843D_70B9_6253_51FBID + 1
    _____4E0B_4E00_4E2A_843D_70B9_6253_51FBID = _____5B9E_4F8BID
    local _____5B9E_4F8B = {
        id = _____5B9E_4F8BID,
        ["参数"] = _____53C2_6570,
        ["落点列表"] = _____843D_70B9_5217_8868,
        ["剩余落点数"] = #_____843D_70B9_5217_8868,
        ["单位命中次数"] = {}
    }
    _____843D_70B9_6253_51FB_5B9E_4F8B_8868[_____5B9E_4F8BID] = _____5B9E_4F8B
    local i = 0
    while i < #_____843D_70B9_5217_8868 do
        local _____843D_70B9 = _____843D_70B9_5217_8868[i + 1]
        _____521B_5EFA_843D_70B9_63D0_793A_7279_6548(_____53C2_6570, _____843D_70B9)
        _____542F_52A8_5355_4E2A_843D_70B9_8BA1_65F6_5668(_____5B9E_4F8BID, i, _____843D_70B9["触发延迟"] > 0 and _____843D_70B9["触发延迟"] or 0)
        i = i + 1
    end
    return _____5B9E_4F8BID
end
return ____exports
