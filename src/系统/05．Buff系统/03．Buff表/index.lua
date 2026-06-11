local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_901A_7528 = require("系统.05．Buff系统.03．Buff表.01．通用")
local _____901A_7528Buff_8868 = ____01_FF0E_901A_7528["通用Buff表"]
local ____02_FF0EDOT = require("系统.05．Buff系统.03．Buff表.02．DOT")
local ____DOTBuff_8868 = ____02_FF0EDOT["DOTBuff表"]
local ____03_FF0E_63A7_5236 = require("系统.05．Buff系统.03．Buff表.03．控制")
local _____63A7_5236Buff_8868 = ____03_FF0E_63A7_5236["控制Buff表"]
local ____04_FF0E_5C5E_6027 = require("系统.05．Buff系统.03．Buff表.04．属性")
local _____5C5E_6027Buff_8868 = ____04_FF0E_5C5E_6027["属性Buff表"]
local ____05_FF0E_5149_73AF = require("系统.05．Buff系统.03．Buff表.05．光环")
local _____5149_73AFBuff_8868 = ____05_FF0E_5149_73AF["光环Buff表"]
local ____01_FF0EBoss = require("系统.05．Buff系统.03．Buff表.01．Boss.index")
local ____BossBuff_8868 = ____01_FF0EBoss["BossBuff表"]
local ____02_FF0E_82F1_96C4 = require("系统.05．Buff系统.03．Buff表.02．英雄.index")
local _____82F1_96C4Buff_8868 = ____02_FF0E_82F1_96C4["英雄Buff表"]
____exports["分类Buff表"] = __TS__ObjectAssign(
    {},
    _____901A_7528Buff_8868,
    ____DOTBuff_8868,
    _____63A7_5236Buff_8868,
    _____5C5E_6027Buff_8868,
    _____5149_73AFBuff_8868,
    ____BossBuff_8868,
    _____82F1_96C4Buff_8868
)
____exports.default = ____exports["分类Buff表"]
return ____exports
