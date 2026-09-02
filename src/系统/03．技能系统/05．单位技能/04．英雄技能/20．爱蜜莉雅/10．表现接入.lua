--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_666E_653B_8054_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.04．普攻联动")
local _____6CE8_518C_7231_871C_8389_96C5_666E_653B_8054_52A8 = ____04_FF0E_666E_653B_8054_52A8["注册爱蜜莉雅普攻联动"]
local ____05_FF0EQ_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.05．Q技能")
local _____6CE8_518C_7231_871C_8389_96C5Q = ____05_FF0EQ_6280_80FD["注册爱蜜莉雅Q"]
local ____06_FF0EW_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.06．W技能")
local _____6CE8_518C_7231_871C_8389_96C5W = ____06_FF0EW_6280_80FD["注册爱蜜莉雅W"]
local ____07_FF0EE_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.07．E技能")
local _____6CE8_518C_7231_871C_8389_96C5E = ____07_FF0EE_6280_80FD["注册爱蜜莉雅E"]
local ____08_FF0ED_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.08．D技能")
local _____6CE8_518C_7231_871C_8389_96C5D = ____08_FF0ED_6280_80FD["注册爱蜜莉雅D"]
local ____09_FF0ER_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.09．R技能")
local _____6CE8_518C_7231_871C_8389_96C5R = ____09_FF0ER_6280_80FD["注册爱蜜莉雅R"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local _____5DF2_6CE8_518C = false
____exports["注册爱蜜莉雅表现"] = function()
    debugLogForce("爱蜜莉雅-表现接入", "注册", "名称", "注册爱蜜莉雅表现")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_7231_871C_8389_96C5_666E_653B_8054_52A8()
    _____6CE8_518C_7231_871C_8389_96C5Q()
    _____6CE8_518C_7231_871C_8389_96C5W()
    _____6CE8_518C_7231_871C_8389_96C5E()
    _____6CE8_518C_7231_871C_8389_96C5D()
    _____6CE8_518C_7231_871C_8389_96C5R()
end
return ____exports
