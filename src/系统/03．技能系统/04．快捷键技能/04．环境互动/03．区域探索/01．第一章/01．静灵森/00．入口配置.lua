--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_2["创建单位并登记排泄安全"]
local ____require_result_3 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_3["解析配置内部ID"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_4.createTimedEffect
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_5["广播单位提示"]
local Player = jass.Player
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local _____6C34_89E6_624B_5355_4F4DID = "水触须#n049"
local _____6C34_89E6_624B_7279_6548_8DEF_5F84 = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl"
local _____6C34_89E6_624B_63D0_793A_6587_672C = "水面下传来了一阵异样的动静。"
local _____6C34_89E6_624B_5EF6_8FDF_63D0_793A_6587_672C = "水触手从水池现身了。"
local function _____521B_5EFA_6C34_89E6_624B(_____65BD_6CD5_5355_4F4D)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local X = -28763.3
    local Y = -8994.8
    createTimedEffect(
        _____6C34_89E6_624B_7279_6548_8DEF_5F84,
        X,
        Y,
        0,
        1
    )
    _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____89E3_6790_914D_7F6E_5185_90E8ID(_____6C34_89E6_624B_5355_4F4DID),
        X,
        Y,
        0
    )
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____6C34_89E6_624B_5EF6_8FDF_63D0_793A_6587_672C, 1500)
end
local function _____5904_7406_6C34_89E6_624B_8C03_67E5(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local ____ = _____8C03_67E5_70B9
    createTimedEffect(
        _____6C34_89E6_624B_7279_6548_8DEF_5F84,
        -28763.3,
        -8994.8,
        0,
        1
    )
    addDelayedCallback(3000, _____521B_5EFA_6C34_89E6_624B, _____65BD_6CD5_5355_4F4D)
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____6C34_89E6_624B_63D0_793A_6587_672C, 1500)
    return true
end
--- 注册静灵森的常驻环境互动探索点。
____exports["注册静灵森探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "静灵森.水触手",
        X = -28763.3,
        Y = -8994.8,
        ["触发范围"] = 350,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_6C34_89E6_624B_8C03_67E5
    })
end
return ____exports
