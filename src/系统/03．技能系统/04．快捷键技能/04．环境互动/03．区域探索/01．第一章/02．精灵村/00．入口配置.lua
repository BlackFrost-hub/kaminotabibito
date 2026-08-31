local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_2["广播单位提示"]
local _____4E66_67B6_63D0_793A_6587_672C = "在书架处阅读了《远古精灵奥术》，魔法伤害+1%，魔法恢复+1/秒。"
local function _____5904_7406_5965_672F_4E66_67B6_8C03_67E5(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local ____ = _____8C03_67E5_70B9
    local _____5F53_524D_6062_590D = __TS__Number(YDUserDataGetSafe("unit", _____65BD_6CD5_5355_4F4D, "魔法恢复", "real")) or 0
    YDUserDataSetSafe(
        "unit",
        _____65BD_6CD5_5355_4F4D,
        "魔法恢复",
        "real",
        _____5F53_524D_6062_590D + 1
    )
    local _____73A9_5BB6 = jass.GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    local _____5F53_524D_9B54_6CD5_4F24_5BB3 = __TS__Number(YDUserDataGetSafe("player", _____73A9_5BB6, "魔法伤害", "real")) or 0
    YDUserDataSetSafe(
        "player",
        _____73A9_5BB6,
        "魔法伤害",
        "real",
        _____5F53_524D_9B54_6CD5_4F24_5BB3 + 0.01
    )
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____4E66_67B6_63D0_793A_6587_672C, 3000)
    return true
end
--- 注册精灵村的常驻环境互动探索点。
____exports["注册精灵村探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "精灵村.远古精灵奥术书架",
        X = 27751.7,
        Y = -27979.2,
        ["触发范围"] = 350,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_5965_672F_4E66_67B6_8C03_67E5
    })
end
return ____exports
