--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.03．召唤物组状态管理")
local _____521B_5EFA_53EC_5524_7269_7EC4_72B6_6001 = ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406["创建召唤物组状态"]
local ____15_FF0EBoss_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．Boss运行时上下文工厂")
local _____521B_5EFABoss_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0EBoss_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建Boss运行时上下文工厂"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.00．配置")
local _____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["树魔首领单位技能配置"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local function _____521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587(boss, _____6E05_7406)
    return {
        ["Boss单位"] = boss,
        ["阶段"] = 1,
        ["开战时间Ms"] = getServerTime(),
        ["清理"] = _____6E05_7406,
        ["随从组"] = _____521B_5EFA_53EC_5524_7269_7EC4_72B6_6001({["清理"] = _____6E05_7406, ["名称"] = "树魔首领随从组", ["全灭延迟秒"] = 0, ["全灭后保留死亡记录"] = false}),
        ["随从特性已初始化"] = false,
        ["当前随从数量"] = 0,
        ["当前兽群层数"] = 0,
        ["无从暴怒中"] = false,
        ["暴怒攻速增量"] = 0,
        ["暴怒移速增量"] = 0,
        ["下一次召唤Ms"] = 0,
        ["已初始化"] = false
    }
end
local _____6811_9B54_9996_9886_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFABoss_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "树魔首领", ["主动技能提示"] = _____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"], ["创建上下文"] = _____521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587})
____exports["获取树魔首领上下文"] = function(boss)
    return _____6811_9B54_9996_9886_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建树魔首领上下文"] = function(boss)
    return _____6811_9B54_9996_9886_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["清理树魔首领上下文"] = function(boss)
    _____6811_9B54_9996_9886_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["获取全部树魔首领上下文"] = function()
    return _____6811_9B54_9996_9886_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
end
____exports["注册树魔首领运行时"] = function()
end
return ____exports
