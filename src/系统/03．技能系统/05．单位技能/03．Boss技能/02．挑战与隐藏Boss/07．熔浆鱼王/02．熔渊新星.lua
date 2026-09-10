--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.07．熔浆鱼王.00．配置")
local _____7194_6D46_9C7C_738B_5355_4F4D_7C7B_578BID = ____00_FF0E_914D_7F6E["熔浆鱼王单位类型ID"]
local _____7194_6E0A_65B0_661F_6280_80FDID = ____00_FF0E_914D_7F6E["熔渊新星技能ID"]
local _____7194_6E0A_65B0_661F_6280_80FD_7C7B_578BID = ____00_FF0E_914D_7F6E["熔渊新星技能类型ID"]
local _____7194_6E0A_65B0_661F_914D_7F6E = ____00_FF0E_914D_7F6E["熔渊新星配置"]
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_0["注册单位技能壳监听"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_1.getEnemyUnitsInRange
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_2["创建点特效"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_3["造成单体技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_5.addDelayedCallback
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_6["创建技能提示圈"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____7194_6D46_9C7C_738B_65B0_661F_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({
    ["名称"] = "熔浆鱼王新星技能",
    ["主动技能提示"] = {{["技能ID"] = _____7194_6E0A_65B0_661F_6280_80FDID, ["提示"] = "熔渊新星", ["扩展提示"] = "以自身为中心炸开熔岩，对周围敌人造成伤害。"}},
    ["创建上下文"] = function(_unit, _____6E05_7406) return {["清理"] = _____6E05_7406} end
})
local function _____91CA_653E_7194_6E0A_65B0_661F(______4E0A_4E0B_6587, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    local _____4E2D_5FC3X = GetUnitX(_____65BD_6CD5_8005)
    local _____4E2D_5FC3Y = GetUnitY(_____65BD_6CD5_8005)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "渐变圆形",
        X = _____4E2D_5FC3X,
        Y = _____4E2D_5FC3Y,
        ["半径"] = _____7194_6E0A_65B0_661F_914D_7F6E["范围"],
        ["持续时间"] = _____7194_6E0A_65B0_661F_914D_7F6E["预警秒"]
    })
    addDelayedCallback(
        _____7194_6E0A_65B0_661F_914D_7F6E["预警秒"] * 1000,
        function()
            _____521B_5EFA_70B9_7279_6548({["路径"] = _____7194_6E0A_65B0_661F_914D_7F6E["爆炸特效"], X = _____4E2D_5FC3X, Y = _____4E2D_5FC3Y, ["持续秒"] = _____7194_6E0A_65B0_661F_914D_7F6E["爆炸特效持续秒"]})
            local _____4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____7194_6E0A_65B0_661F_914D_7F6E["攻击倍率"]
            local _____654C_4EBA_5217_8868 = getEnemyUnitsInRange(_____65BD_6CD5_8005, _____4E2D_5FC3X, _____4E2D_5FC3Y, _____7194_6E0A_65B0_661F_914D_7F6E["范围"])
            do
                local i = 0
                while i < #_____654C_4EBA_5217_8868 do
                    do
                        local _____76EE_6807 = _____654C_4EBA_5217_8868[i + 1]
                        if _____76EE_6807 == nil or _____76EE_6807 == 0 then
                            goto __continue6
                        end
                        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                            ["来源"] = _____65BD_6CD5_8005,
                            ["目标"] = _____76EE_6807,
                            ["伤害"] = _____4F24_5BB3,
                            ["技能ID"] = _____7194_6E0A_65B0_661F_6280_80FD_7C7B_578BID,
                            ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
                        })
                    end
                    ::__continue6::
                    i = i + 1
                end
            end
        end
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册熔浆鱼王熔渊新星"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "熔浆鱼王-熔渊新星",
        ["单位类型ID"] = _____7194_6D46_9C7C_738B_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7194_6E0A_65B0_661F_6280_80FD_7C7B_578BID,
        ["获取或创建上下文"] = _____7194_6D46_9C7C_738B_65B0_661F_5DE5_5382["获取或创建"],
        ["释放技能"] = _____91CA_653E_7194_6E0A_65B0_661F,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "Boss技能",
        ["技能实例持续时间秒"] = 6
    })
end
____exports["注册熔浆鱼王熔渊新星"]()
return ____exports
