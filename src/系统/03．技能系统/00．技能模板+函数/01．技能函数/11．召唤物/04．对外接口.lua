local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____02_FF0E_53EC_5524_7269_6838_5FC3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.02．召唤物核心")
local _____521B_5EFA_53EC_5524_7269_6838_5FC3 = ____02_FF0E_53EC_5524_7269_6838_5FC3["创建召唤物核心"]
--- 召唤物系统 - 对外入口
local jass = require("jass.common")
local GetLocationX = jass.GetLocationX
local GetLocationY = jass.GetLocationY
local RemoveLocation = jass.RemoveLocation
local ____jass_bj_UNIT_FACING_0 = jass.bj_UNIT_FACING
if ____jass_bj_UNIT_FACING_0 == nil then
    ____jass_bj_UNIT_FACING_0 = 270
end
local bj_UNIT_FACING = ____jass_bj_UNIT_FACING_0
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_1.stringToFourCC
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local fourCCToString = ____require_result_2.fourCCToString
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local _____6A21_5757_540D = "召唤物入口"
local _____9ED8_8BA4_53EC_5524_7269_5355_4F4D_7C7B_578B = stringToFourCC("e08P")
local function _____7EDD_5BF9_503C(value)
    return value >= 0 and value or -value
end
local function _____662F_5426_6709_6548_5355_4F4D_56DB_5B57_7801(rawcode)
    if not (rawcode > 0) then
        return false
    end
    local ____opt_4 = _G.slk
    if ____opt_4 ~= nil then
        ____opt_4 = ____opt_4.unit
    end
    local ____opt_4_6 = ____opt_4
    if ____opt_4_6 == nil then
        ____opt_4_6 = nil
    end
    local slkTable = ____opt_4_6
    if slkTable == nil then
        return false
    end
    local id = fourCCToString(rawcode)
    return slkTable[id] ~= nil
end
local function _____5C1D_8BD5_7EA0_6B63_5355_4F4D_56DB_5B57_7801(rawcode)
    if not (rawcode > 0) then
        return rawcode
    end
    if _____662F_5426_6709_6548_5355_4F4D_56DB_5B57_7801(rawcode) then
        return rawcode
    end
    local best = 0
    local bestDelta = 999999
    local delta = -127
    while delta <= 127 do
        local candidate = rawcode + delta
        if candidate > 0 and _____662F_5426_6709_6548_5355_4F4D_56DB_5B57_7801(candidate) then
            local absDelta = _____7EDD_5BF9_503C(delta)
            if absDelta < bestDelta then
                best = candidate
                bestDelta = absDelta
                if absDelta == 0 then
                    break
                end
            end
        end
        delta = delta + 1
    end
    if best ~= 0 and best ~= rawcode then
        debugLogForce(
            _____6A21_5757_540D,
            "纠正损坏 unitType",
            "raw=",
            rawcode,
            "rawStr=",
            fourCCToString(rawcode),
            "fixed=",
            best,
            "fixedStr=",
            fourCCToString(best)
        )
        return best
    end
    return rawcode
end
local function _____5F52_4E00_5316_5355_4F4D_7C7B_578B(_____5355_4F4D_7C7B_578B)
    if type(_____5355_4F4D_7C7B_578B) == "number" and _____5355_4F4D_7C7B_578B ~= 0 then
        return _____5C1D_8BD5_7EA0_6B63_5355_4F4D_56DB_5B57_7801(_____5355_4F4D_7C7B_578B)
    end
    if type(_____5355_4F4D_7C7B_578B) == "string" and #_____5355_4F4D_7C7B_578B == 4 then
        return stringToFourCC(_____5355_4F4D_7C7B_578B)
    end
    return nil
end
local function _____89E3_6790_4F4D_7F6EX(_____53C2_6570)
    if _____53C2_6570.X ~= nil then
        return _____53C2_6570.X
    end
    if _____53C2_6570.x ~= nil then
        return _____53C2_6570.x
    end
    local ____53C2_6570__4F4D_7F6E_7 = _____53C2_6570["位置"]
    if ____53C2_6570__4F4D_7F6E_7 == nil then
        ____53C2_6570__4F4D_7F6E_7 = _____53C2_6570.loc
    end
    local loc = ____53C2_6570__4F4D_7F6E_7
    if loc ~= nil and loc ~= 0 then
        return GetLocationX(loc)
    end
    return 0
end
local function _____89E3_6790_4F4D_7F6EY(_____53C2_6570)
    if _____53C2_6570.Y ~= nil then
        return _____53C2_6570.Y
    end
    if _____53C2_6570.y ~= nil then
        return _____53C2_6570.y
    end
    local ____53C2_6570__4F4D_7F6E_8 = _____53C2_6570["位置"]
    if ____53C2_6570__4F4D_7F6E_8 == nil then
        ____53C2_6570__4F4D_7F6E_8 = _____53C2_6570.loc
    end
    local loc = ____53C2_6570__4F4D_7F6E_8
    if loc ~= nil and loc ~= 0 then
        return GetLocationY(loc)
    end
    return 0
end
local function _____89E3_6790_671D_5411(_____53C2_6570)
    if _____53C2_6570["朝向"] ~= nil then
        return _____53C2_6570["朝向"]
    end
    if _____53C2_6570["面向"] ~= nil then
        return _____53C2_6570["面向"]
    end
    if _____53C2_6570.facing ~= nil then
        return _____53C2_6570.facing
    end
    if _____53C2_6570.fac ~= nil then
        return _____53C2_6570.fac
    end
    return nil
end
local function _____89E3_6790_98DE_884C_9AD8_5EA6(_____53C2_6570)
    if _____53C2_6570["飞行高度"] ~= nil then
        return _____53C2_6570["飞行高度"]
    end
    if _____53C2_6570.z ~= nil then
        return _____53C2_6570.z
    end
    if _____53C2_6570.moveHeight ~= nil then
        return _____53C2_6570.moveHeight
    end
    if _____53C2_6570.MoveHeight ~= nil then
        return _____53C2_6570.MoveHeight
    end
    return nil
end
local function _____89E3_6790_6A21_578B_6587_4EF6(_____53C2_6570)
    if _____53C2_6570["模型文件"] ~= nil and _____53C2_6570["模型文件"] ~= "" then
        return _____53C2_6570["模型文件"]
    end
    if _____53C2_6570["模型路径"] ~= nil and _____53C2_6570["模型路径"] ~= "" then
        return _____53C2_6570["模型路径"]
    end
    if _____53C2_6570.ModelFileID ~= nil and _____53C2_6570.ModelFileID ~= "" then
        return _____53C2_6570.ModelFileID
    end
    return nil
end
local function _____89E3_6790_6DFB_52A0_6280_80FD_5217_8868(_____53C2_6570)
    local _____539F_59CB_6280_80FD_5217_8868 = _____53C2_6570["添加技能"]
    if _____539F_59CB_6280_80FD_5217_8868 == nil or #_____539F_59CB_6280_80FD_5217_8868 == 0 then
        return nil
    end
    local _____6280_80FD_5217_8868 = {}
    do
        local i = 0
        while i < #_____539F_59CB_6280_80FD_5217_8868 do
            local _____539F_59CB_6280_80FD = _____539F_59CB_6280_80FD_5217_8868[i + 1]
            local _____6280_80FDID = type(_____539F_59CB_6280_80FD) == "number" and _____539F_59CB_6280_80FD or (#_____539F_59CB_6280_80FD == 4 and stringToFourCC(_____539F_59CB_6280_80FD) or 0)
            if _____6280_80FDID > 0 then
                _____6280_80FD_5217_8868[#_____6280_80FD_5217_8868 + 1] = _____6280_80FDID
            end
            i = i + 1
        end
    end
    return #_____6280_80FD_5217_8868 > 0 and _____6280_80FD_5217_8868 or nil
end
local function _____89C4_8303_5316_53EC_5524_7269_53C2_6570_8F93_5165(_____53C2_6570)
    local ____53C2_6570__4E3B_4EBA_5355_4F4D_9 = _____53C2_6570["主人单位"]
    if ____53C2_6570__4E3B_4EBA_5355_4F4D_9 == nil then
        ____53C2_6570__4E3B_4EBA_5355_4F4D_9 = _____53C2_6570.Master
    end
    local ____53C2_6570__6240_5C5E_73A9_5BB6_10 = _____53C2_6570["所属玩家"]
    if ____53C2_6570__6240_5C5E_73A9_5BB6_10 == nil then
        ____53C2_6570__6240_5C5E_73A9_5BB6_10 = _____53C2_6570.player
    end
    local ____temp_18 = _____5F52_4E00_5316_5355_4F4D_7C7B_578B(_____53C2_6570["单位类型"] or _____53C2_6570.unitType or _____53C2_6570.uid) or _____9ED8_8BA4_53EC_5524_7269_5355_4F4D_7C7B_578B
    local ____53C2_6570__53EC_5524_7269_5355_4F4D_11 = _____53C2_6570["召唤物单位"]
    if ____53C2_6570__53EC_5524_7269_5355_4F4D_11 == nil then
        ____53C2_6570__53EC_5524_7269_5355_4F4D_11 = _____53C2_6570.Summon
    end
    local ____temp_19 = _____53C2_6570["单位名称"] or _____53C2_6570["名称"] or _____53C2_6570["名字"] or _____53C2_6570.name or _____53C2_6570.unitName
    local ____89E3_6790_4F4D_7F6EX_result_20 = _____89E3_6790_4F4D_7F6EX(_____53C2_6570)
    local ____89E3_6790_4F4D_7F6EY_result_21 = _____89E3_6790_4F4D_7F6EY(_____53C2_6570)
    local ____53C2_6570__4F4D_7F6E_12 = _____53C2_6570["位置"]
    if ____53C2_6570__4F4D_7F6E_12 == nil then
        ____53C2_6570__4F4D_7F6E_12 = _____53C2_6570.loc
    end
    local ____89E3_6790_671D_5411_result_22 = _____89E3_6790_671D_5411(_____53C2_6570)
    local ____temp_23 = _____53C2_6570["持续时间"] or _____53C2_6570.time
    local ____89E3_6790_98DE_884C_9AD8_5EA6_result_24 = _____89E3_6790_98DE_884C_9AD8_5EA6(_____53C2_6570)
    local ____89E3_6790_6A21_578B_6587_4EF6_result_25 = _____89E3_6790_6A21_578B_6587_4EF6(_____53C2_6570)
    local ____temp_26 = _____53C2_6570["生命值"] or _____53C2_6570.HP
    local ____53C2_6570__751F_547D_503C_53D7_5C0F_602A_500D_7387_13 = _____53C2_6570["生命值受小怪倍率"]
    if ____53C2_6570__751F_547D_503C_53D7_5C0F_602A_500D_7387_13 == nil then
        ____53C2_6570__751F_547D_503C_53D7_5C0F_602A_500D_7387_13 = _____53C2_6570.hpScaleWithCreep
    end
    local ____temp_27 = _____53C2_6570["生命恢复"] or _____53C2_6570.regenHP
    local ____temp_28 = _____53C2_6570["攻击力"] or _____53C2_6570.AttackPower
    local ____temp_29 = _____53C2_6570["攻击间隔"] or _____53C2_6570.atkCd
    local ____temp_30 = _____53C2_6570["攻击范围"] or _____53C2_6570["射程"] or _____53C2_6570.range or _____53C2_6570.Rng
    local ____53C2_6570__56FA_5B9A_7AD9_6869_31 = _____53C2_6570["固定站桩"]
    local ____53C2_6570__7981_6B62_666E_653B_32 = _____53C2_6570["禁止普攻"]
    local ____89E3_6790_6DFB_52A0_6280_80FD_5217_8868_result_33 = _____89E3_6790_6DFB_52A0_6280_80FD_5217_8868(_____53C2_6570)
    local ____53C2_6570__7981_7528_8DEF_5F84_34 = _____53C2_6570["禁用路径"]
    local ____temp_35 = _____53C2_6570["普攻弹道模型"] or _____53C2_6570["弹道模型"] or _____53C2_6570.missileModel
    local ____temp_36 = _____53C2_6570["普攻弹道弧度"] or _____53C2_6570["弹道弧度"] or _____53C2_6570.missileArc
    local ____temp_37 = _____53C2_6570["普攻弹道速度"] or _____53C2_6570["弹道速度"] or _____53C2_6570.missileSpeed
    local ____53C2_6570__666E_653B_5F39_9053_81EA_5BFC_14 = _____53C2_6570["普攻弹道自导"]
    if ____53C2_6570__666E_653B_5F39_9053_81EA_5BFC_14 == nil then
        ____53C2_6570__666E_653B_5F39_9053_81EA_5BFC_14 = _____53C2_6570["弹道自导"]
    end
    local ____53C2_6570__666E_653B_5F39_9053_81EA_5BFC_14_15 = ____53C2_6570__666E_653B_5F39_9053_81EA_5BFC_14
    if ____53C2_6570__666E_653B_5F39_9053_81EA_5BFC_14_15 == nil then
        ____53C2_6570__666E_653B_5F39_9053_81EA_5BFC_14_15 = _____53C2_6570.missileHoming
    end
    local ____temp_38 = _____53C2_6570["索敌范围"] or _____53C2_6570["主动攻击范围"] or _____53C2_6570.acquireRange or _____53C2_6570.acquire
    local ____temp_39 = _____53C2_6570["护甲"] or _____53C2_6570.def
    local ____temp_40 = _____53C2_6570["缩放"] or _____53C2_6570.size
    local ____temp_41 = _____53C2_6570["透明度"] or _____53C2_6570.alpha
    local ____temp_42 = _____53C2_6570["红"] or _____53C2_6570.red
    local ____temp_43 = _____53C2_6570["绿"] or _____53C2_6570.green
    local ____temp_44 = _____53C2_6570["蓝"] or _____53C2_6570.blue
    local ____53C2_6570__662F_5426_79FB_9664_5730_70B9_16 = _____53C2_6570["是否移除地点"]
    if ____53C2_6570__662F_5426_79FB_9664_5730_70B9_16 == nil then
        ____53C2_6570__662F_5426_79FB_9664_5730_70B9_16 = _____53C2_6570.removeLoc
    end
    local ____53C2_6570__662F_5426_79FB_9664_5730_70B9_16_17 = ____53C2_6570__662F_5426_79FB_9664_5730_70B9_16
    if ____53C2_6570__662F_5426_79FB_9664_5730_70B9_16_17 == nil then
        ____53C2_6570__662F_5426_79FB_9664_5730_70B9_16_17 = _____53C2_6570.b
    end
    return {
        ["主人单位"] = ____53C2_6570__4E3B_4EBA_5355_4F4D_9,
        ["所属玩家"] = ____53C2_6570__6240_5C5E_73A9_5BB6_10,
        ["单位类型"] = ____temp_18,
        ["召唤物单位"] = ____53C2_6570__53EC_5524_7269_5355_4F4D_11,
        ["单位名称"] = ____temp_19,
        X = ____89E3_6790_4F4D_7F6EX_result_20,
        Y = ____89E3_6790_4F4D_7F6EY_result_21,
        ["位置"] = ____53C2_6570__4F4D_7F6E_12,
        ["朝向"] = ____89E3_6790_671D_5411_result_22,
        ["持续时间"] = ____temp_23,
        ["飞行高度"] = ____89E3_6790_98DE_884C_9AD8_5EA6_result_24,
        ["模型文件"] = ____89E3_6790_6A21_578B_6587_4EF6_result_25,
        ["生命值"] = ____temp_26,
        ["生命值受小怪倍率"] = ____53C2_6570__751F_547D_503C_53D7_5C0F_602A_500D_7387_13,
        ["生命恢复"] = ____temp_27,
        ["攻击力"] = ____temp_28,
        ["攻击间隔"] = ____temp_29,
        ["攻击范围"] = ____temp_30,
        ["固定站桩"] = ____53C2_6570__56FA_5B9A_7AD9_6869_31,
        ["禁止普攻"] = ____53C2_6570__7981_6B62_666E_653B_32,
        ["添加技能"] = ____89E3_6790_6DFB_52A0_6280_80FD_5217_8868_result_33,
        ["禁用路径"] = ____53C2_6570__7981_7528_8DEF_5F84_34,
        ["普攻弹道模型"] = ____temp_35,
        ["普攻弹道弧度"] = ____temp_36,
        ["普攻弹道速度"] = ____temp_37,
        ["普攻弹道自导"] = ____53C2_6570__666E_653B_5F39_9053_81EA_5BFC_14_15,
        ["索敌范围"] = ____temp_38,
        ["护甲"] = ____temp_39,
        ["缩放"] = ____temp_40,
        ["透明度"] = ____temp_41,
        ["红"] = ____temp_42,
        ["绿"] = ____temp_43,
        ["蓝"] = ____temp_44,
        ["是否移除地点"] = ____53C2_6570__662F_5426_79FB_9664_5730_70B9_16_17
    }
end
____exports["创建召唤物"] = function(_____53C2_6570)
    local _____89C4_8303_5316_53C2_6570 = _____89C4_8303_5316_53EC_5524_7269_53C2_6570_8F93_5165(_____53C2_6570)
    if _____89C4_8303_5316_53C2_6570["朝向"] == nil then
        _____89C4_8303_5316_53C2_6570["朝向"] = bj_UNIT_FACING
    end
    local _____53EC_5524_7269 = _____521B_5EFA_53EC_5524_7269_6838_5FC3(_____89C4_8303_5316_53C2_6570)
    if _____89C4_8303_5316_53C2_6570["是否移除地点"] and _____89C4_8303_5316_53C2_6570["位置"] ~= nil and _____89C4_8303_5316_53C2_6570["位置"] ~= 0 then
        RemoveLocation(_____89C4_8303_5316_53C2_6570["位置"])
    end
    return _____53EC_5524_7269
end
____exports["快捷创建召唤物"] = function(_____4E3B_4EBA_5355_4F4D, _____5355_4F4D_7C7B_578B, X, Y, _____6301_7EED_65F6_95F4, _____989D_5916_53C2_6570)
    return ____exports["创建召唤物"](__TS__ObjectAssign({
        ["主人单位"] = _____4E3B_4EBA_5355_4F4D,
        ["单位类型"] = _____5355_4F4D_7C7B_578B,
        X = X,
        Y = Y,
        ["持续时间"] = _____6301_7EED_65F6_95F4
    }, _____989D_5916_53C2_6570))
end
function ____exports.SUO_CreateUnit_Loc(_____6240_5C5E_73A9_5BB6, uid, loc, z, fac, alpha, red, green, blue, time, b)
    return ____exports["创建召唤物"]({
        ["所属玩家"] = _____6240_5C5E_73A9_5BB6,
        uid = uid,
        loc = loc,
        z = z,
        fac = fac,
        alpha = alpha,
        red = red,
        green = green,
        blue = blue,
        time = time,
        b = b
    })
end
____exports["创建召唤物并套用JASS模板"] = function(_____53C2_6570)
    return ____exports["创建召唤物"](_____53C2_6570)
end
return ____exports
