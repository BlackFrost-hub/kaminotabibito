--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.index")
local _____5F00_59CB_7EAF_8DF3_94FE = ____index["开始纯跳链"]
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
local SquareRoot = jass.SquareRoot
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_2.getUnitsInRange
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_3.isUnitEnemy
local _____6A21_5757_540D = "跳链测试"
local _____6D4B_8BD5_547D_4EE4 = "1010"
local _____641C_7D22_534A_5F84 = 900
local _____6700_5927_8DF3_6570 = 5
local _____6BCF_8DF3_6700_5927_8DDD_79BB = 500
local _____521D_59CB_4F24_5BB3 = 60
local _____8870_51CF_7CFB_6570 = 0.8
local _____8DF3_8DC3_95F4_9694 = 0.15
local function _____67E5_627E_6700_8FD1_654C_4EBA(_____6765_6E90_5355_4F4D, x, y)
    local _____5019_9009_5355_4F4D = getUnitsInRange(x, y, _____641C_7D22_534A_5F84)
    local _____6700_4F73_76EE_6807 = nil
    local _____6700_4F73_8DDD_79BB = 0
    for ____, _____5355_4F4D in ipairs(_____5019_9009_5355_4F4D) do
        do
            if _____5355_4F4D == _____6765_6E90_5355_4F4D then
                goto __continue3
            end
            if not isUnitEnemy(_____5355_4F4D, _____6765_6E90_5355_4F4D) then
                goto __continue3
            end
            local _____8DDD_79BB = SquareRoot((GetUnitX(_____5355_4F4D) - x) * (GetUnitX(_____5355_4F4D) - x) + (GetUnitY(_____5355_4F4D) - y) * (GetUnitY(_____5355_4F4D) - y))
            if _____6700_4F73_76EE_6807 == nil or _____8DDD_79BB < _____6700_4F73_8DDD_79BB then
                _____6700_4F73_76EE_6807 = _____5355_4F4D
                _____6700_4F73_8DDD_79BB = _____8DDD_79BB
            end
        end
        ::__continue3::
    end
    return _____6700_4F73_76EE_6807
end
local function _____8DF3_94FE_6D4B_8BD5__6BCF_8DF3_56DE_8C03(_____5355_4F4D, _____6570_503C, _____5F53_524D_8DF3_6570, _____8DF3_94FEID)
    debugLogForce(
        _____6A21_5757_540D,
        "每跳命中",
        "ID=",
        _____8DF3_94FEID,
        " 跳数=",
        _____5F53_524D_8DF3_6570,
        " 数值=",
        _____6570_503C,
        " 单位=",
        GetUnitName(_____5355_4F4D),
        "#",
        GetHandleId(_____5355_4F4D)
    )
end
local function _____8DF3_94FE_6D4B_8BD5__7ED3_675F_56DE_8C03(_____539F_56E0, _____5DF2_5B8C_6210_8DF3_6570, _____8DF3_94FEID)
    debugLogForce(
        _____6A21_5757_540D,
        "跳链结束",
        "ID=",
        _____8DF3_94FEID,
        " 原因=",
        _____539F_56E0,
        " 已完成跳数=",
        _____5DF2_5B8C_6210_8DF3_6570
    )
end
local function ____on_804A_59291010_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到 gg_unit_Hamg_0002")
        return
    end
    local x = GetUnitX(_____5927_6CD5_5E08)
    local y = GetUnitY(_____5927_6CD5_5E08)
    local _____521D_59CB_76EE_6807 = _____67E5_627E_6700_8FD1_654C_4EBA(_____5927_6CD5_5E08, x, y)
    if _____521D_59CB_76EE_6807 == nil or _____521D_59CB_76EE_6807 == 0 then
        debugLogForce(_____6A21_5757_540D, "搜索半径内未找到敌方起始目标")
        return
    end
    local _____5B9E_4F8B = _____5F00_59CB_7EAF_8DF3_94FE({
        ["起始目标"] = _____521D_59CB_76EE_6807,
        ["来源单位"] = _____5927_6CD5_5E08,
        ["模式"] = "伤害",
        ["影响目标"] = "敌方",
        ["最大跳数"] = _____6700_5927_8DF3_6570,
        ["每跳最大距离"] = _____6BCF_8DF3_6700_5927_8DDD_79BB,
        ["初始数值"] = _____521D_59CB_4F24_5BB3,
        ["每跳衰减系数"] = _____8870_51CF_7CFB_6570,
        ["跳跃间隔"] = _____8DF3_8DC3_95F4_9694,
        ["闪电效果代码"] = "CLPB",
        ["闪电持续时间"] = 0.3,
        ["每跳回调"] = _____8DF3_94FE_6D4B_8BD5__6BCF_8DF3_56DE_8C03,
        ["结束回调"] = _____8DF3_94FE_6D4B_8BD5__7ED3_675F_56DE_8C03
    })
    if _____5B9E_4F8B == nil then
        debugLogForce(_____6A21_5757_540D, "跳链启动失败")
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "已启动跳链测试",
        " 命令=",
        _____6D4B_8BD5_547D_4EE4,
        " 跳链ID=",
        _____5B9E_4F8B["跳链ID"],
        " 最大跳数=",
        _____6700_5927_8DF3_6570,
        " 每跳距离=",
        _____6BCF_8DF3_6700_5927_8DDD_79BB,
        " 初始伤害=",
        _____521D_59CB_4F24_5BB3
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291010_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "启动纯跳链测试")
return ____exports
