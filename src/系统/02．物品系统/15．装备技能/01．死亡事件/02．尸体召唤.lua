--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6B7B_4EA1_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.01．死亡事件.01．死亡事件配置表")
local _____83B7_53D6_6B7B_4EA1_4E8B_4EF6_914D_7F6E = ____01_FF0E_6B7B_4EA1_4E8B_4EF6_914D_7F6E_8868["获取死亡事件配置"]
local _____53D6_7269_54C1_56DB_5B57_7801 = ____01_FF0E_6B7B_4EA1_4E8B_4EF6_914D_7F6E_8868["取物品四字码"]
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local itemJudgeFns = require("lib.扩展函数.物品相关函数.index")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_0.getUnitsInRange
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_1.createTimedEffect
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_2.stringToFourCC
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_3["创建召唤物"]
local _____6700_5927_751F_547D_72B6_6001 = jass.UNIT_STATE_MAX_LIFE
local _____673A_68B0_5355_4F4D_7C7B_578B = jass.UNIT_TYPE_MECHANICAL
local _____8FDC_53E4_5355_4F4D_7C7B_578B = jass.UNIT_TYPE_ANCIENT
local _____5F53_524D_751F_547D_72B6_6001 = jass.UNIT_STATE_LIFE
local _____6B7B_4EA1_5355_4F4D_7C7B_578B = jass.UNIT_TYPE_DEAD
local IsUnitType = jass.IsUnitType
local IsUnitEnemy = jass.IsUnitEnemy
local GetUnitState = jass.GetUnitState
local function _____662F_5426_7B26_5408_6301_76FE_53EC_5524_6761_4EF6(_____5355_4F4D, _____4E0A_4E0B_6587, _____7269_54C1_56DB_5B57_7801)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    if IsUnitType(_____5355_4F4D, _____6B7B_4EA1_5355_4F4D_7C7B_578B) then
        return false
    end
    if GetUnitState(_____5355_4F4D, _____5F53_524D_751F_547D_72B6_6001) <= 0.405 then
        return false
    end
    if IsUnitType(_____5355_4F4D, _____673A_68B0_5355_4F4D_7C7B_578B) then
        return false
    end
    if IsUnitType(_____5355_4F4D, _____8FDC_53E4_5355_4F4D_7C7B_578B) then
        return false
    end
    if not IsUnitEnemy(_____5355_4F4D, _____4E0A_4E0B_6587["死亡单位所有者"]) then
        return false
    end
    return itemJudgeFns.UnitHasItemOfTypeBJ(_____5355_4F4D, _____7269_54C1_56DB_5B57_7801)
end
local function _____8BA1_7B97_53EC_5524_751F_547D_503C(_____6301_6709_8005, _____57FA_7840_503C, _____7CFB_6570)
    return _____57FA_7840_503C + GetUnitStateJapi(_____6301_6709_8005, _____6700_5927_751F_547D_72B6_6001) * _____7CFB_6570
end
local function _____8BA1_7B97_53EC_5524_653B_51FB_529B(_____6301_6709_8005, _____57FA_7840_503C, _____653B_51FB_72B6_6001, _____7CFB_6570)
    return _____57FA_7840_503C + jass.GetUnitState(
        _____6301_6709_8005,
        jass.ConvertUnitState(_____653B_51FB_72B6_6001)
    ) * _____7CFB_6570
end
local function _____521B_5EFA_5C38_4F53_53EC_5524_7269(_____6301_6709_8005, _____4E0A_4E0B_6587)
    local _____914D_7F6E = _____83B7_53D6_6B7B_4EA1_4E8B_4EF6_914D_7F6E()["尸体召唤"]
    local _____53EC_5524_751F_547D_503C = _____8BA1_7B97_53EC_5524_751F_547D_503C(_____6301_6709_8005, _____914D_7F6E["额外生命值"], _____914D_7F6E["生命值系数"])
    local _____53EC_5524_653B_51FB_529B = _____8BA1_7B97_53EC_5524_653B_51FB_529B(_____6301_6709_8005, _____914D_7F6E["额外攻击力"], _____914D_7F6E["攻击力状态"], _____914D_7F6E["攻击力系数"])
    local _____53EC_5524_7269 = _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = _____6301_6709_8005,
        ["单位类型"] = _____914D_7F6E["召唤单位类型"],
        X = _____4E0A_4E0B_6587["死亡坐标X"],
        Y = _____4E0A_4E0B_6587["死亡坐标Y"],
        ["持续时间"] = _____914D_7F6E["持续时间"],
        ["生命值"] = _____53EC_5524_751F_547D_503C,
        ["攻击力"] = _____53EC_5524_653B_51FB_529B
    })
    if _____53EC_5524_7269 == nil or _____53EC_5524_7269 == 0 then
        return
    end
    jass.UnitApplyTimedLife(
        _____53EC_5524_7269,
        stringToFourCC(_____914D_7F6E["限时生命Buff"]),
        _____914D_7F6E["持续时间"]
    )
    jass.SetUnitState(
        _____53EC_5524_7269,
        _____5F53_524D_751F_547D_72B6_6001,
        GetUnitStateJapi(_____53EC_5524_7269, _____6700_5927_751F_547D_72B6_6001)
    )
    createTimedEffect(
        nil,
        _____914D_7F6E["特效路径"],
        _____4E0A_4E0B_6587["死亡坐标X"],
        _____4E0A_4E0B_6587["死亡坐标Y"],
        0,
        _____914D_7F6E["特效持续时间"]
    )
end
____exports["处理尸体召唤"] = function(_____4E0A_4E0B_6587)
    local _____914D_7F6E = _____83B7_53D6_6B7B_4EA1_4E8B_4EF6_914D_7F6E()["尸体召唤"]
    local _____7269_54C1_56DB_5B57_7801 = _____53D6_7269_54C1_56DB_5B57_7801(_____914D_7F6E["装备ID"])
    if not (_____7269_54C1_56DB_5B57_7801 > 0) then
        return
    end
    local _____8303_56F4_5355_4F4D_7EC4 = getUnitsInRange(_____4E0A_4E0B_6587["死亡坐标X"], _____4E0A_4E0B_6587["死亡坐标Y"], _____914D_7F6E["搜索半径"])
    for ____, _____5355_4F4D in ipairs(_____8303_56F4_5355_4F4D_7EC4) do
        do
            if not _____662F_5426_7B26_5408_6301_76FE_53EC_5524_6761_4EF6(_____5355_4F4D, _____4E0A_4E0B_6587, _____7269_54C1_56DB_5B57_7801) then
                goto __continue15
            end
            _____521B_5EFA_5C38_4F53_53EC_5524_7269(_____5355_4F4D, _____4E0A_4E0B_6587)
        end
        ::__continue15::
    end
end
return ____exports
