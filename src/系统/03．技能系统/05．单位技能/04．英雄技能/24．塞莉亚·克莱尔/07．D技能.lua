--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____6DFB_52A0_5355_4F4D_6682_505C_6536_5C3E, _____79FB_9664_5355_4F4D_6682_505C
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.00．配置")
local _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔技能配置"]
local _____585E_8389_4E9A_514B_83B1_5C14D_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔D配置"]
local _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔表现子配置"]
local ____02_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.02．被动效果")
local _____67E5_8BE2_585E_8389_4E9A_8282_70B9 = ____02_FF0E_88AB_52A8_6548_679C["查询塞莉亚节点"]
local _____8F6C_5199_585E_8389_4E9A_8282_70B9_4E8B_52A1 = ____02_FF0E_88AB_52A8_6548_679C["转写塞莉亚节点事务"]
local _____521B_5EFA_585E_8389_4E9A_8282_70B9 = ____02_FF0E_88AB_52A8_6548_679C["创建塞莉亚节点"]
local _____767B_8BB0_585E_8389_4E9A_6280_80FD_6E05_7406 = ____02_FF0E_88AB_52A8_6548_679C["登记塞莉亚技能清理"]
function _____6DFB_52A0_5355_4F4D_6682_505C_6536_5C3E(_____65BD_6CD5_8005, _____6765_6E90)
    _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_8005, _____6765_6E90)
end
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_1["注册单位技能壳监听"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_2["单位存活"]
local _____8DDD_79BB_5E73_65B9XY = ____require_result_2["距离平方XY"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_3["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_3["移除单位暂停"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E["单位类型ID"]
local ____D_786C_76F4_6765_6E90 = "塞莉亚-D硬直"
--- 确定性选择：距目标点最近的合法节点；同距取序号小者。
local function _____9009_62E9_6700_8FD1_5408_6CD5_8282_70B9(_____5217_8868, _____76EE_6807X, _____76EE_6807Y)
    local _____6700_4F73 = nil
    local _____6700_4F73_5E73_65B9 = 2 ^ 53 - 1
    do
        local i = 0
        while i < #_____5217_8868 do
            local _____8282_70B9 = _____5217_8868[i + 1]
            local _____5E73_65B9 = _____8DDD_79BB_5E73_65B9XY(_____76EE_6807X, _____76EE_6807Y, _____8282_70B9.X, _____8282_70B9.Y)
            if _____5E73_65B9 < _____6700_4F73_5E73_65B9 or _____5E73_65B9 == _____6700_4F73_5E73_65B9 and _____6700_4F73 ~= nil and _____8282_70B9["序号"] < _____6700_4F73["序号"] then
                _____6700_4F73_5E73_65B9 = _____5E73_65B9
                _____6700_4F73 = _____8282_70B9
            end
            i = i + 1
        end
    end
    return _____6700_4F73
end
local function _____91CA_653ED_672F_5F0F_8F6C_5199(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____786C_76F4_6765_6E90 = ____D_786C_76F4_6765_6E90
    addDelayedCallback(
        _____585E_8389_4E9A_514B_83B1_5C14D_914D_7F6E["硬直秒"] * 1000,
        function()
            if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                return
            end
            _____6DFB_52A0_5355_4F4D_6682_505C_6536_5C3E(_____65BD_6CD5_8005, _____786C_76F4_6765_6E90)
            local _____5217_8868 = _____67E5_8BE2_585E_8389_4E9A_8282_70B9(_____65BD_6CD5_8005)
            if #_____5217_8868 <= 0 then
                _____521B_5EFA_585E_8389_4E9A_8282_70B9(
                    _____65BD_6CD5_8005,
                    "棱晶",
                    GetUnitX(_____65BD_6CD5_8005),
                    GetUnitY(_____65BD_6CD5_8005),
                    _____6280_80FD_5B9E_4F8BID,
                    _____585E_8389_4E9A_514B_83B1_5C14D_914D_7F6E["临时节点存续毫秒"]
                )
                return
            end
            local _____76EE_6807_8282_70B9 = _____9009_62E9_6700_8FD1_5408_6CD5_8282_70B9(_____5217_8868, _____76EE_6807X, _____76EE_6807Y)
            if _____76EE_6807_8282_70B9 == nil then
                return
            end
            local _____6210_529F = _____8F6C_5199_585E_8389_4E9A_8282_70B9_4E8B_52A1(_____65BD_6CD5_8005, _____76EE_6807_8282_70B9["序号"], _____76EE_6807X, _____76EE_6807Y)
            if not _____6210_529F then
                return
            end
            local _____843D_70B9_95EA_73B0 = _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["D重连落点闪现"]["模型路径"],
                X = _____76EE_6807X,
                Y = _____76EE_6807Y,
                Z = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["D重连落点闪现"]["高度"],
                ["缩放"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["D重连落点闪现"]["缩放"],
                ["持续秒"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["D重连落点闪现"]["持续秒"]
            })
            local ____ = _____843D_70B9_95EA_73B0
        end
    )
    _____6DFB_52A0_5355_4F4D_6682_505C(_____65BD_6CD5_8005, _____786C_76F4_6765_6E90)
    local _____6CE8_9500_5B88_536B = _____767B_8BB0_585E_8389_4E9A_6280_80FD_6E05_7406(
        _____65BD_6CD5_8005,
        "D硬直-" .. tostring(_____6280_80FD_5B9E_4F8BID or 0),
        function()
            _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_8005, _____786C_76F4_6765_6E90)
        end
    )
    local ____ = _____6CE8_9500_5B88_536B
end
local _____5DF2_6CE8_518C = false
____exports["注册塞莉亚D"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "塞莉亚·克莱尔-术式转写（D）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.D["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653ED_672F_5F0F_8F6C_5199,
        ["创建独立技能实例"] = false
    })
end
return ____exports
