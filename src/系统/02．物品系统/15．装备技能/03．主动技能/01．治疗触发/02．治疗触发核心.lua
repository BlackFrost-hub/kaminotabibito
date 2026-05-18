--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_9ED1_7267_6756 = require("系统.02．物品系统.15．装备技能.00．物品.03．黑牧杖")
local _____5904_7406_9ED1_7267_6756_6CBB_7597 = ____03_FF0E_9ED1_7267_6756["处理黑牧杖治疗"]
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local registerHealCallback = ____require_result_0.registerHealCallback
local _____5DF2_521D_59CB_5316_6CBB_7597_89E6_53D1_4E3B_52A8_6280_80FD_6838_5FC3 = false
local function _____5904_7406_6CBB_7597_89E6_53D1_4E3B_52A8_6280_80FD(_____6765_6E90, _____76EE_6807, _____6CBB_7597_91CF, _____662F_5426_7269_54C1_6CBB_7597)
    return _____5904_7406_9ED1_7267_6756_6CBB_7597(_____6765_6E90, _____76EE_6807, _____6CBB_7597_91CF, _____662F_5426_7269_54C1_6CBB_7597)
end
____exports["初始化治疗触发主动技能核心"] = function()
    if _____5DF2_521D_59CB_5316_6CBB_7597_89E6_53D1_4E3B_52A8_6280_80FD_6838_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_6CBB_7597_89E6_53D1_4E3B_52A8_6280_80FD_6838_5FC3 = true
    registerHealCallback(_____5904_7406_6CBB_7597_89E6_53D1_4E3B_52A8_6280_80FD)
end
return ____exports
