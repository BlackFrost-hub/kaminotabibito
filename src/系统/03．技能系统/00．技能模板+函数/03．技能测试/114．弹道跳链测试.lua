--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.02．弹道跳链.index")
local _____5F00_59CB_5F39_9053_8DF3_94FE = ____index["开始弹道跳链"]
--- 弹道跳链测试
-- 
-- 输入 "1014"：
-- - 搜索 gg_unit_Hamg_0002 周围敌人作为起始目标。
-- - 每一跳都创建真实飞行弹幕，命中后再找下一跳。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_2.getUnitsInRange
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_3.isUnitEnemy
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
local GetHandleId = jass.GetHandleId
local SquareRoot = jass.SquareRoot
local _____6A21_5757_540D = "弹道跳链测试"
local _____6D4B_8BD5_547D_4EE4 = "1014"
local _____641C_7D22_534A_5F84 = 900
local function _____67E5_627E_6700_8FD1_654C_4EBA(_____6765_6E90_5355_4F4D)
    local x = GetUnitX(_____6765_6E90_5355_4F4D)
    local y = GetUnitY(_____6765_6E90_5355_4F4D)
    local _____5019_9009 = getUnitsInRange(x, y, _____641C_7D22_534A_5F84)
    local _____6700_4F73_76EE_6807 = nil
    local _____6700_4F73_8DDD_79BB = 0
    do
        local i = 0
        while i < #_____5019_9009 do
            do
                local _____5355_4F4D = _____5019_9009[i + 1]
                if not isUnitEnemy(_____5355_4F4D, _____6765_6E90_5355_4F4D) then
                    goto __continue4
                end
                local dx = GetUnitX(_____5355_4F4D) - x
                local dy = GetUnitY(_____5355_4F4D) - y
                local _____8DDD_79BB = SquareRoot(dx * dx + dy * dy)
                if _____6700_4F73_76EE_6807 == nil or _____8DDD_79BB < _____6700_4F73_8DDD_79BB then
                    _____6700_4F73_76EE_6807 = _____5355_4F4D
                    _____6700_4F73_8DDD_79BB = _____8DDD_79BB
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
    return _____6700_4F73_76EE_6807
end
local function _____5F39_9053_8DF3_94FE__7ED3_675F()
    debugLogForce(_____6A21_5757_540D, "弹道跳链结束")
end
local function ____on_804A_59291014_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local _____521D_59CB_76EE_6807 = _____67E5_627E_6700_8FD1_654C_4EBA(_____5927_6CD5_5E08)
    if _____521D_59CB_76EE_6807 == nil or _____521D_59CB_76EE_6807 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：附近未找到敌人")
        return
    end
    _____5F00_59CB_5F39_9053_8DF3_94FE({
        ["施法者"] = _____5927_6CD5_5E08,
        ["初始目标"] = _____521D_59CB_76EE_6807,
        ["跳跃次数"] = 4,
        ["搜索半径"] = _____641C_7D22_534A_5F84,
        ["弹幕速度"] = 320,
        ["每跳延迟"] = 0.2,
        ["命中半径"] = 90,
        ["伤害值"] = 45,
        ["每跳伤害系数"] = 0.75,
        ["每单位只命中一次"] = true,
        ["模型"] = "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
        ["on结束"] = _____5F39_9053_8DF3_94FE__7ED3_675F
    })
    debugLogForce(
        _____6A21_5757_540D,
        "已启动弹道跳链",
        "起始目标=",
        GetUnitName(_____521D_59CB_76EE_6807),
        "#",
        GetHandleId(_____521D_59CB_76EE_6807)
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291014_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "启动弹道跳链")
return ____exports
