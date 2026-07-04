--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7 = ____20_FF0E_7269_54C1_8F85_52A9["主动物品调试日志"]
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____4F7F_8005_7CBE_795E_9B54_6756_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["使者精神魔杖物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____4F7F_8005_7CBE_795E_9B54_6756_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["使者精神魔杖配置"]
local ____16_FF0E_5355_4F4D_65F6_9650_6570_503C = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.16．单位时限数值")
local _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C = ____16_FF0E_5355_4F4D_65F6_9650_6570_503C["创建单位时限数值"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_1["创建单位并登记排泄安全"]
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitFacing = jass.GetUnitFacing
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitRace = jass.IsUnitRace
local IsHeroUnitId = jass.IsHeroUnitId
local KillUnit = jass.KillUnit
local UnitApplyTimedLife = jass.UnitApplyTimedLife
local RACE_DEMON = jass.RACE_DEMON
local _____9650_65F6_751F_547DBuffID = stringToFourCCSafe("BHwe")
local _____4F7F_8005_7CBE_795E_9B54_6756_5B58_50A8 = _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C("使者精神魔杖存储")
local function _____662F_5426_4E3A_4F7F_8005_7CBE_795E_9B54_6756(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____4F7F_8005_7CBE_795E_9B54_6756_7269_54C1ID
end
local function _____76EE_6807_53EF_5B58_50A8(_____76EE_6807_5355_4F4D)
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return false
    end
    if IsUnitRace(_____76EE_6807_5355_4F4D, RACE_DEMON) then
        return false
    end
    return not IsHeroUnitId(GetUnitTypeId(_____76EE_6807_5355_4F4D))
end
____exports["处理使者精神魔杖使用"] = function(_____4E0A_4E0B_6587)
    _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7("21．使者精神魔杖", "进入", "处理使者精神魔杖使用")
    if not _____662F_5426_4E3A_4F7F_8005_7CBE_795E_9B54_6756(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local _____5DF2_5B58_50A8 = _____4F7F_8005_7CBE_795E_9B54_6756_5B58_50A8["存在"](_____65BD_6CD5_5355_4F4D)
    local _____76EE_6807_5355_4F4D = _____4E0A_4E0B_6587["目标单位"]
    if not _____5DF2_5B58_50A8 then
        if not _____76EE_6807_53EF_5B58_50A8(_____76EE_6807_5355_4F4D) then
            return
        end
        KillUnit(_____76EE_6807_5355_4F4D)
        _____4F7F_8005_7CBE_795E_9B54_6756_5B58_50A8["写入"](
            _____65BD_6CD5_5355_4F4D,
            GetUnitTypeId(_____76EE_6807_5355_4F4D),
            _____4F7F_8005_7CBE_795E_9B54_6756_914D_7F6E["存储持续时间"]
        )
        return
    end
    local _____5B58_50A8_5355_4F4D_7C7B_578B = _____4F7F_8005_7CBE_795E_9B54_6756_5B58_50A8["消耗"](_____65BD_6CD5_5355_4F4D)
    if _____5B58_50A8_5355_4F4D_7C7B_578B == nil or _____5B58_50A8_5355_4F4D_7C7B_578B == 0 then
        return
    end
    local x = (_____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0) and _____4E0A_4E0B_6587["目标X"] or GetUnitX(_____76EE_6807_5355_4F4D)
    local y = (_____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0) and _____4E0A_4E0B_6587["目标Y"] or GetUnitY(_____76EE_6807_5355_4F4D)
    local _____53EC_5524_5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        GetOwningPlayer(_____65BD_6CD5_5355_4F4D),
        _____5B58_50A8_5355_4F4D_7C7B_578B,
        x,
        y,
        GetUnitFacing(_____65BD_6CD5_5355_4F4D)
    )
    if _____53EC_5524_5355_4F4D ~= nil and _____53EC_5524_5355_4F4D ~= 0 then
        UnitApplyTimedLife(_____53EC_5524_5355_4F4D, _____9650_65F6_751F_547DBuffID, _____4F7F_8005_7CBE_795E_9B54_6756_914D_7F6E["召唤持续时间"])
    end
end
return ____exports
