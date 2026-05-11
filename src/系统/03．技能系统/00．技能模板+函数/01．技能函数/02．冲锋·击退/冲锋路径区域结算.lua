local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- 冲锋路径区域结算模板
-- 
-- 用于“先冲锋到终点，再沿起点 -> 终点的路径区域统一结算一次伤害”的技能。
-- 不修改击退系统底层，只通过开始/结束回调做组合。
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51B2_950B = ____require_result_0["开始冲锋"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_1.isUnitEnemy
local isUnitAlly = ____require_result_1.isUnitAlly
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.矩形区域")
local _____83B7_53D6_6761_5F62_533A_57DF_5355_4F4D = ____require_result_2["获取条形区域单位"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.胶囊区域")
local _____83B7_53D6_80F6_56CA_533A_57DF_5355_4F4D = ____require_result_3["获取胶囊区域单位"]
local _____8DEF_5F84_7ED3_7B97_4E0A_4E0B_6587_8868 = {}
local function _____91CA_653E_8DEF_5F84_7ED3_7B97_4E0A_4E0B_6587(_____4F4D_79FBID)
    local _____4E0A_4E0B_6587 = _____8DEF_5F84_7ED3_7B97_4E0A_4E0B_6587_8868[_____4F4D_79FBID]
    __TS__Delete(_____8DEF_5F84_7ED3_7B97_4E0A_4E0B_6587_8868, _____4F4D_79FBID)
    return _____4E0A_4E0B_6587
end
local function _____6267_884C_4F4D_79FB_539F_7ED3_675F_56DE_8C03(_____56DE_8C03, _____5355_4F4D, _____539F_56E0, _____4F4D_79FBID, _____547D_4E2D_76EE_6807)
    _____56DE_8C03(_____5355_4F4D, _____539F_56E0, _____4F4D_79FBID, _____547D_4E2D_76EE_6807)
end
local function _____662F_5426_901A_8FC7_8DEF_5F84_533A_57DF_76EE_6807_7B5B_9009(_____4E0A_4E0B_6587, _____76EE_6807_5355_4F4D, _____4F4D_79FBID, _____539F_56E0)
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return false
    end
    local _____7ED3_7B97_53C2_6570 = _____4E0A_4E0B_6587["结算参数"]
    local _____79FB_52A8_5355_4F4D = _____4E0A_4E0B_6587["单位"]
    if not _____7ED3_7B97_53C2_6570["允许命中自己"] and _____76EE_6807_5355_4F4D == _____79FB_52A8_5355_4F4D then
        return false
    end
    local _____5F71_54CD_76EE_6807 = _____7ED3_7B97_53C2_6570["影响目标"] or "敌方"
    if _____5F71_54CD_76EE_6807 == "敌方" and not isUnitEnemy(_____76EE_6807_5355_4F4D, _____79FB_52A8_5355_4F4D) then
        return false
    end
    if _____5F71_54CD_76EE_6807 == "友方" and not isUnitAlly(_____76EE_6807_5355_4F4D, _____79FB_52A8_5355_4F4D) then
        return false
    end
    local _____5355_4F4D_7B5B_9009 = _____7ED3_7B97_53C2_6570["单位筛选"]
    if _____5355_4F4D_7B5B_9009 ~= nil and not _____5355_4F4D_7B5B_9009(_____79FB_52A8_5355_4F4D, _____76EE_6807_5355_4F4D, _____4F4D_79FBID, _____539F_56E0) then
        return false
    end
    return true
end
local function _____7ED3_7B97_8DEF_5F84_533A_57DF_4F24_5BB3(_____4E0A_4E0B_6587, _____4F4D_79FBID, _____539F_56E0)
    local _____7ED3_7B97_53C2_6570 = _____4E0A_4E0B_6587["结算参数"]
    if _____7ED3_7B97_53C2_6570["宽度"] <= 0 or _____7ED3_7B97_53C2_6570["伤害值"] <= 0 then
        return
    end
    local ____7ED3_7B97_53C2_6570__4EC5_5B8C_6210_65F6_7ED3_7B97_4 = _____7ED3_7B97_53C2_6570["仅完成时结算"]
    if ____7ED3_7B97_53C2_6570__4EC5_5B8C_6210_65F6_7ED3_7B97_4 == nil then
        ____7ED3_7B97_53C2_6570__4EC5_5B8C_6210_65F6_7ED3_7B97_4 = true
    end
    if ____7ED3_7B97_53C2_6570__4EC5_5B8C_6210_65F6_7ED3_7B97_4 and _____539F_56E0 ~= "完成" then
        return
    end
    local _____7EC8_70B9X = GetUnitX(_____4E0A_4E0B_6587["单位"])
    local _____7EC8_70B9Y = GetUnitY(_____4E0A_4E0B_6587["单位"])
    local _____533A_57DF_5F62_72B6 = _____7ED3_7B97_53C2_6570["区域形状"] or "条形"
    local ____temp_19
    if _____533A_57DF_5F62_72B6 == "胶囊" then
        local ____83B7_53D6_80F6_56CA_533A_57DF_5355_4F4D_11 = _____83B7_53D6_80F6_56CA_533A_57DF_5355_4F4D
        local ____4E0A_4E0B_6587__8D77_70B9X_6 = _____4E0A_4E0B_6587["起点X"]
        local ____4E0A_4E0B_6587__8D77_70B9Y_7 = _____4E0A_4E0B_6587["起点Y"]
        local ____7EC8_70B9X_8 = _____7EC8_70B9X
        local ____7EC8_70B9Y_9 = _____7EC8_70B9Y
        local ____7ED3_7B97_53C2_6570__5BBD_5EA6_10 = _____7ED3_7B97_53C2_6570["宽度"]
        local ____7ED3_7B97_53C2_6570__5305_542B_8FB9_754C_5 = _____7ED3_7B97_53C2_6570["包含边界"]
        if ____7ED3_7B97_53C2_6570__5305_542B_8FB9_754C_5 == nil then
            ____7ED3_7B97_53C2_6570__5305_542B_8FB9_754C_5 = true
        end
        ____temp_19 = ____83B7_53D6_80F6_56CA_533A_57DF_5355_4F4D_11({
            ["起点X"] = ____4E0A_4E0B_6587__8D77_70B9X_6,
            ["起点Y"] = ____4E0A_4E0B_6587__8D77_70B9Y_7,
            ["终点X"] = ____7EC8_70B9X_8,
            ["终点Y"] = ____7EC8_70B9Y_9,
            ["宽度"] = ____7ED3_7B97_53C2_6570__5BBD_5EA6_10,
            ["包含边界"] = ____7ED3_7B97_53C2_6570__5305_542B_8FB9_754C_5
        })
    else
        local ____83B7_53D6_6761_5F62_533A_57DF_5355_4F4D_18 = _____83B7_53D6_6761_5F62_533A_57DF_5355_4F4D
        local ____4E0A_4E0B_6587__8D77_70B9X_13 = _____4E0A_4E0B_6587["起点X"]
        local ____4E0A_4E0B_6587__8D77_70B9Y_14 = _____4E0A_4E0B_6587["起点Y"]
        local ____7EC8_70B9X_15 = _____7EC8_70B9X
        local ____7EC8_70B9Y_16 = _____7EC8_70B9Y
        local ____7ED3_7B97_53C2_6570__5BBD_5EA6_17 = _____7ED3_7B97_53C2_6570["宽度"]
        local ____7ED3_7B97_53C2_6570__5305_542B_8FB9_754C_12 = _____7ED3_7B97_53C2_6570["包含边界"]
        if ____7ED3_7B97_53C2_6570__5305_542B_8FB9_754C_12 == nil then
            ____7ED3_7B97_53C2_6570__5305_542B_8FB9_754C_12 = true
        end
        ____temp_19 = ____83B7_53D6_6761_5F62_533A_57DF_5355_4F4D_18({
            ["起点X"] = ____4E0A_4E0B_6587__8D77_70B9X_13,
            ["起点Y"] = ____4E0A_4E0B_6587__8D77_70B9Y_14,
            ["终点X"] = ____7EC8_70B9X_15,
            ["终点Y"] = ____7EC8_70B9Y_16,
            ["宽度"] = ____7ED3_7B97_53C2_6570__5BBD_5EA6_17,
            ["包含边界"] = ____7ED3_7B97_53C2_6570__5305_542B_8FB9_754C_12
        })
    end
    local _____5355_4F4D_5217_8868 = ____temp_19
    local ____7ED3_7B97_53C2_6570__4F24_5BB3_6765_6E90_20 = _____7ED3_7B97_53C2_6570["伤害来源"]
    if ____7ED3_7B97_53C2_6570__4F24_5BB3_6765_6E90_20 == nil then
        ____7ED3_7B97_53C2_6570__4F24_5BB3_6765_6E90_20 = _____4E0A_4E0B_6587["单位"]
    end
    local _____4F24_5BB3_6765_6E90 = ____7ED3_7B97_53C2_6570__4F24_5BB3_6765_6E90_20
    local ____7ED3_7B97_53C2_6570__653B_51FB_7C7B_578B_21 = _____7ED3_7B97_53C2_6570["攻击类型"]
    if ____7ED3_7B97_53C2_6570__653B_51FB_7C7B_578B_21 == nil then
        ____7ED3_7B97_53C2_6570__653B_51FB_7C7B_578B_21 = ATTACK_TYPE_NORMAL
    end
    local _____653B_51FB_7C7B_578B = ____7ED3_7B97_53C2_6570__653B_51FB_7C7B_578B_21
    local ____7ED3_7B97_53C2_6570__4F24_5BB3_7C7B_578B_22 = _____7ED3_7B97_53C2_6570["伤害类型"]
    if ____7ED3_7B97_53C2_6570__4F24_5BB3_7C7B_578B_22 == nil then
        ____7ED3_7B97_53C2_6570__4F24_5BB3_7C7B_578B_22 = DAMAGE_TYPE_NORMAL
    end
    local _____4F24_5BB3_7C7B_578B = ____7ED3_7B97_53C2_6570__4F24_5BB3_7C7B_578B_22
    local ____7ED3_7B97_53C2_6570__6B66_5668_7C7B_578B_23 = _____7ED3_7B97_53C2_6570["武器类型"]
    if ____7ED3_7B97_53C2_6570__6B66_5668_7C7B_578B_23 == nil then
        ____7ED3_7B97_53C2_6570__6B66_5668_7C7B_578B_23 = WEAPON_TYPE_WHOKNOWS
    end
    local _____6B66_5668_7C7B_578B = ____7ED3_7B97_53C2_6570__6B66_5668_7C7B_578B_23
    for ____, _____76EE_6807_5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        do
            if not _____662F_5426_901A_8FC7_8DEF_5F84_533A_57DF_76EE_6807_7B5B_9009(_____4E0A_4E0B_6587, _____76EE_6807_5355_4F4D, _____4F4D_79FBID, _____539F_56E0) then
                goto __continue13
            end
            UnitDamageTarget(
                _____4F24_5BB3_6765_6E90,
                _____76EE_6807_5355_4F4D,
                _____7ED3_7B97_53C2_6570["伤害值"],
                false,
                false,
                _____653B_51FB_7C7B_578B,
                _____4F24_5BB3_7C7B_578B,
                _____6B66_5668_7C7B_578B
            )
            local ____opt_24 = _____7ED3_7B97_53C2_6570["命中回调"]
            if ____opt_24 ~= nil then
                ____opt_24(_____4E0A_4E0B_6587["单位"], _____76EE_6807_5355_4F4D, _____4F4D_79FBID, _____539F_56E0)
            end
        end
        ::__continue13::
    end
end
local function _____51B2_950B_8DEF_5F84_533A_57DF_7ED3_675F_56DE_8C03(_____5355_4F4D, _____539F_56E0, _____4F4D_79FBID, _____547D_4E2D_76EE_6807)
    local _____4E0A_4E0B_6587 = _____91CA_653E_8DEF_5F84_7ED3_7B97_4E0A_4E0B_6587(_____4F4D_79FBID)
    if not _____4E0A_4E0B_6587 then
        return
    end
    _____7ED3_7B97_8DEF_5F84_533A_57DF_4F24_5BB3(_____4E0A_4E0B_6587, _____4F4D_79FBID, _____539F_56E0)
    local _____539F_7ED3_675F_56DE_8C03 = _____4E0A_4E0B_6587["位移参数原结束回调"]
    if _____539F_7ED3_675F_56DE_8C03 ~= nil then
        _____6267_884C_4F4D_79FB_539F_7ED3_675F_56DE_8C03(
            _____539F_7ED3_675F_56DE_8C03,
            _____5355_4F4D,
            _____539F_56E0,
            _____4F4D_79FBID,
            _____547D_4E2D_76EE_6807
        )
    end
end
____exports["开始冲锋并在结束时结算路径区域"] = function(_____5355_4F4D, _____4F4D_79FB_53C2_6570, _____7ED3_7B97_53C2_6570)
    local _____8D77_70B9X = GetUnitX(_____5355_4F4D)
    local _____8D77_70B9Y = GetUnitY(_____5355_4F4D)
    local _____5408_5E76_53C2_6570 = __TS__ObjectAssign({}, _____4F4D_79FB_53C2_6570, {["结束回调"] = _____51B2_950B_8DEF_5F84_533A_57DF_7ED3_675F_56DE_8C03})
    local _____4F4D_79FBID = _____5F00_59CB_51B2_950B(_____5355_4F4D, _____5408_5E76_53C2_6570)
    if _____4F4D_79FBID <= 0 then
        return 0
    end
    _____8DEF_5F84_7ED3_7B97_4E0A_4E0B_6587_8868[_____4F4D_79FBID] = {
        ["单位"] = _____5355_4F4D,
        ["起点X"] = _____8D77_70B9X,
        ["起点Y"] = _____8D77_70B9Y,
        ["位移参数原结束回调"] = _____4F4D_79FB_53C2_6570["结束回调"],
        ["结算参数"] = _____7ED3_7B97_53C2_6570
    }
    return _____4F4D_79FBID
end
return ____exports
