--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 原生弹幕追踪测试
-- 
-- 输入 "1014"
-- - 让 gg_unit_Hamg_0002 对 gg_unit_ogru_0019 发射原生追踪弹幕
-- - 只验证原生弹幕创建、追踪、命中、到达目标点回调是否正常
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_2["创建原生弹幕"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index")
local _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9 = ____require_result_3["创建追踪插值轨迹"]
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isSameUnit = ____require_result_4.isSameUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitName = jass.GetUnitName
local GetHandleId = jass.GetHandleId
local _____6A21_5757_540D = "原生弹幕追踪测试"
local _____6D4B_8BD5_547D_4EE4 = "1041"
local _____5F39_5E55_6A21_578B = "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl"
local function _____8FFD_8E2A_6D4B_8BD5_547D_4E2D_5355_4F4D(_____76EE_6807_5355_4F4D, _____5F39_5E55ID)
    debugLogForce(
        _____6A21_5757_540D,
        "命中单位",
        "弹幕ID=",
        _____5F39_5E55ID,
        "目标=",
        GetUnitName(_____76EE_6807_5355_4F4D),
        "#",
        GetHandleId(_____76EE_6807_5355_4F4D)
    )
end
local function _____8FFD_8E2A_6D4B_8BD5_547D_4E2D(_____76EE_6807_5355_4F4D, _____5F39_5E55ID)
    debugLogForce(
        _____6A21_5757_540D,
        "on命中",
        "弹幕ID=",
        _____5F39_5E55ID,
        "目标=",
        GetUnitName(_____76EE_6807_5355_4F4D),
        "#",
        GetHandleId(_____76EE_6807_5355_4F4D)
    )
end
local function _____8FFD_8E2A_6D4B_8BD5_5230_8FBE_76EE_6807_70B9(_____5F39_5E55ID, _____539F_56E0)
    debugLogForce(
        _____6A21_5757_540D,
        "到达目标点",
        "弹幕ID=",
        _____5F39_5E55ID,
        "原因=",
        _____539F_56E0
    )
end
local function _____8FFD_8E2A_6D4B_8BD5_7ED3_675F(_____539F_56E0, _____5F39_5E55ID)
    debugLogForce(
        _____6A21_5757_540D,
        "结束",
        "弹幕ID=",
        _____5F39_5E55ID,
        "原因=",
        _____539F_56E0
    )
end
local function _____8FFD_8E2A_6D4B_8BD5_76EE_6807_7B5B_9009(_____76EE_6807_5355_4F4D)
    local _____56FA_5B9A_76EE_6807 = g.gg_unit_ogru_0019
    if _____56FA_5B9A_76EE_6807 == nil or _____56FA_5B9A_76EE_6807 == 0 then
        return false
    end
    return isSameUnit(_____76EE_6807_5355_4F4D, _____56FA_5B9A_76EE_6807)
end
local function _____6267_884C1014_539F_751F_8FFD_8E2A_6D4B_8BD5()
    local _____65BD_6CD5_8005 = g.gg_unit_Hamg_0002
    local _____76EE_6807_5355_4F4D = g.gg_unit_ogru_0019
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_ogru_0019")
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "准备发射",
        "source=",
        GetUnitName(_____65BD_6CD5_8005),
        "#",
        GetHandleId(_____65BD_6CD5_8005),
        "target=",
        GetUnitName(_____76EE_6807_5355_4F4D),
        "#",
        GetHandleId(_____76EE_6807_5355_4F4D),
        "sourcePos=(",
        GetUnitX(_____65BD_6CD5_8005),
        ",",
        GetUnitY(_____65BD_6CD5_8005),
        ")",
        "targetPos=(",
        GetUnitX(_____76EE_6807_5355_4F4D),
        ",",
        GetUnitY(_____76EE_6807_5355_4F4D),
        ")"
    )
    local _____5B9E_4F8B = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = _____65BD_6CD5_8005,
        X = GetUnitX(_____65BD_6CD5_8005),
        Y = GetUnitY(_____65BD_6CD5_8005),
        ["方向角"] = GetUnitFacing(_____65BD_6CD5_8005),
        ["指定目标"] = _____76EE_6807_5355_4F4D,
        ["速度"] = 1000,
        ["轨迹采样器"] = _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9(_____76EE_6807_5355_4F4D, 100),
        ["命中半径"] = 100,
        ["生命周期"] = 6,
        ["碰撞消失"] = true,
        ["最大距离"] = 5000,
        ["模型"] = _____5F39_5E55_6A21_578B,
        ["附着特效模型"] = _____5F39_5E55_6A21_578B,
        ["影响目标"] = "全部",
        ["目标筛选"] = _____8FFD_8E2A_6D4B_8BD5_76EE_6807_7B5B_9009,
        ["最大总命中次数"] = 1,
        ["每单位最大命中次数"] = 1,
        ["on命中"] = _____8FFD_8E2A_6D4B_8BD5_547D_4E2D,
        ["on命中单位"] = _____8FFD_8E2A_6D4B_8BD5_547D_4E2D_5355_4F4D,
        ["on到达目标点"] = _____8FFD_8E2A_6D4B_8BD5_5230_8FBE_76EE_6807_70B9,
        ["on结束"] = _____8FFD_8E2A_6D4B_8BD5_7ED3_675F
    })
    debugLogForce(_____6A21_5757_540D, "已发射追踪弹幕", "弹幕ID=", _____5B9E_4F8B["弹幕ID"])
end
local function ____on_804A_59291014()
    _____6267_884C1014_539F_751F_8FFD_8E2A_6D4B_8BD5()
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291014)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "让大法师对食人魔勇士发射追踪弹幕")
return ____exports
