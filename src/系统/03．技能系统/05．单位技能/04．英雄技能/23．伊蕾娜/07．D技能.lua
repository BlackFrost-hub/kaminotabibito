local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.00．配置")
local _____4F0A_857E_5A1C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜技能配置"]
local _____4F0A_857E_5A1C_53D8_5F0F_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜变式配置"]
local _____4F0A_857E_5A1C_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜表现配置"]
local _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜模型动作配置"]
local ____01A_FF0E_52A8_4F5C_8868_73B0 = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.01A．动作表现")
local _____64AD_653E_4F0A_857E_5A1C_9636_6BB5_52A8_4F5C = ____01A_FF0E_52A8_4F5C_8868_73B0["播放伊蕾娜阶段动作"]
local ____02_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.02．被动效果")
local _____8BBE_7F6E_4F0A_857E_5A1C_53D8_5F0F = ____02_FF0E_88AB_52A8_6548_679C["设置伊蕾娜变式"]
local _____83B7_53D6_4F0A_857E_5A1C_53D8_5F0F = ____02_FF0E_88AB_52A8_6548_679C["获取伊蕾娜变式"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_0["注册单位技能壳监听"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_1["单位存活"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_2["创建点特效"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____4F0A_857E_5A1C_6280_80FD_914D_7F6E["单位类型ID"]
local function _____8BA1_7B97_4E0B_4E00_4E2A_53D8_5F0F(_____5F53_524D)
    local _____5217_8868 = _____4F0A_857E_5A1C_53D8_5F0F_914D_7F6E["变式列表"]
    if _____5F53_524D == nil or __TS__ArrayIndexOf(_____5217_8868, _____5F53_524D) < 0 then
        return _____5217_8868[1]
    end
    local _____4E0B_4E00_7D22_5F15 = (__TS__ArrayIndexOf(_____5217_8868, _____5F53_524D) + 1) % #_____5217_8868
    return _____5217_8868[_____4E0B_4E00_7D22_5F15 + 1]
end
local function _____91CA_653ED_65C5_9014_9B54_6CD5_53D8_5F0F(_context, _____65BD_6CD5_8005, ______6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    local _____5F53_524D = _____83B7_53D6_4F0A_857E_5A1C_53D8_5F0F(_____65BD_6CD5_8005)
    local _____4E0B_4E00_4E2A = _____8BA1_7B97_4E0B_4E00_4E2A_53D8_5F0F(_____5F53_524D)
    if not _____8BBE_7F6E_4F0A_857E_5A1C_53D8_5F0F(_____65BD_6CD5_8005, _____4E0B_4E00_4E2A) then
        return
    end
    _____64AD_653E_4F0A_857E_5A1C_9636_6BB5_52A8_4F5C(_____65BD_6CD5_8005, _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E["技能动作"]["D切换"])
    local _____63D0_793A = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["D变式提示"]["模型路径"],
        X = GetUnitX(_____65BD_6CD5_8005),
        Y = GetUnitY(_____65BD_6CD5_8005),
        Z = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["D变式提示"]["高度"],
        ["缩放"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["D变式提示"]["缩放"],
        ["持续秒"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["D变式提示"]["持续秒"]
    })
    local ____ = _____63D0_793A
end
local _____5DF2_6CE8_518C = false
____exports["注册伊蕾娜D"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "伊蕾娜-旅途魔法变式（D）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____4F0A_857E_5A1C_6280_80FD_914D_7F6E.D["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653ED_65C5_9014_9B54_6CD5_53D8_5F0F,
        ["创建独立技能实例"] = false
    })
end
return ____exports
