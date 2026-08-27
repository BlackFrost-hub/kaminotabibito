--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7 = ____20_FF0E_7269_54C1_8F85_52A9["主动物品调试日志"]
local ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.24．句柄上下文托管")
local _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668 = ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1["创建句柄上下文托管器"]
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____7834_8840_4E4B_6212_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["破血之戒物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____7834_8840_4E4B_6212_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["破血之戒配置"]
local ____01_FF0E_7269_54C1_4F7F_7528_89E6_53D1_5E38_91CF = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.01．物品使用触发常量")
local _____7834_8840_4E4B_6212_7279_6548_952E = ____01_FF0E_7269_54C1_4F7F_7528_89E6_53D1_5E38_91CF["破血之戒特效键"]
local _____7834_8840_4E4B_6212_7ED1_5B9A_9644_7740_70B9 = ____01_FF0E_7269_54C1_4F7F_7528_89E6_53D1_5E38_91CF["破血之戒绑定附着点"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____9020_6210_88C5_5907_4F24_5BB3 = ____require_result_0["造成装备伤害"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_1.createTimedEffect
local _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_1["创建Dz绑定单位特效"]
local _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_1["销毁Dz绑定单位特效"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_2["开始充能"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电")
local _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_3["创建单位绑定闪电"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_4["获取坐标范围敌人"]
local GetUnitState = jass.GetUnitState
local ConvertUnitState = jass.ConvertUnitState
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local ____require_result_5 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_751F_547D_503C = ____require_result_5["减少生命值"]
local _____7834_8840_4E4B_6212_4E0A_4E0B_6587_6258_7BA1_5668 = _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668("破血之戒上下文")
local function _____662F_5426_4E3A_7834_8840_4E4B_6212(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return jass:GetItemTypeId(_____7269_54C1) == _____7834_8840_4E4B_6212_7269_54C1ID
end
local function _____6E05_7406_7834_8840_4E4B_6212_4E0A_4E0B_6587(_____5355_4F4D)
    _____7834_8840_4E4B_6212_4E0A_4E0B_6587_6258_7BA1_5668["清空"](_____5355_4F4D)
end
local function _____7ED3_7B97_7834_8840_4E4B_6212(_____65BD_6CD5_5355_4F4D)
    local _____4E0A_4E0B_6587 = _____7834_8840_4E4B_6212_4E0A_4E0B_6587_6258_7BA1_5668["读取"](_____65BD_6CD5_5355_4F4D)
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    local _____4F24_5BB3_503C = _____7834_8840_4E4B_6212_914D_7F6E["基础伤害"] + GetUnitStateJapi(
        _____65BD_6CD5_5355_4F4D,
        ConvertUnitState(21)
    ) * 3
    local _____654C_4EBA_5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(_____65BD_6CD5_5355_4F4D, _____4E0A_4E0B_6587["目标X"], _____4E0A_4E0B_6587["目标Y"], _____7834_8840_4E4B_6212_914D_7F6E["作用范围"])
    createTimedEffect(
        _____7834_8840_4E4B_6212_914D_7F6E["选取特效路径"],
        _____4E0A_4E0B_6587["目标X"],
        _____4E0A_4E0B_6587["目标Y"],
        0,
        1
    )
    do
        local i = 0
        while i < #_____654C_4EBA_5217_8868 do
            do
                local _____654C_4EBA = _____654C_4EBA_5217_8868[i + 1]
                if _____654C_4EBA == nil or _____654C_4EBA == 0 then
                    goto __continue8
                end
                _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535({
                    ["效果代码"] = "AFOD",
                    ["起点单位"] = _____65BD_6CD5_5355_4F4D,
                    ["终点单位"] = _____654C_4EBA,
                    ["持续时间"] = 0.8,
                    ["起点高度偏移"] = 80,
                    ["终点高度偏移"] = 80,
                    ["任一死亡时销毁"] = true
                })
                _____9020_6210_88C5_5907_4F24_5BB3(
                    _____65BD_6CD5_5355_4F4D,
                    _____654C_4EBA,
                    _____4F24_5BB3_503C,
                    DAMAGE_TYPE_ENHANCED,
                    true,
                    nil,
                    {["伤害形态"] = "AOE"}
                )
            end
            ::__continue8::
            i = i + 1
        end
    end
end
local function _____5F00_59CB_7834_8840_4E4B_6212_5145_80FD(_____65BD_6CD5_5355_4F4D)
    _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548(_____65BD_6CD5_5355_4F4D, _____7834_8840_4E4B_6212_7ED1_5B9A_9644_7740_70B9, _____7834_8840_4E4B_6212_914D_7F6E["施法特效路径"], _____7834_8840_4E4B_6212_7279_6548_952E)
    _____5F00_59CB_5145_80FD(
        _____65BD_6CD5_5355_4F4D,
        {
            ["持续时间"] = _____7834_8840_4E4B_6212_914D_7F6E["充能时间"],
            ["主单位"] = _____65BD_6CD5_5355_4F4D,
            ["主单位死亡时中断"] = true,
            ["指令中断"] = true,
            ["显示进度条特效"] = true,
            ["进度条特效高度偏移"] = 233,
            ["充能完成回调"] = function(_____5355_4F4D, ______5145_80FDID)
                _____7ED3_7B97_7834_8840_4E4B_6212(_____5355_4F4D)
            end,
            ["结束回调"] = function(_____5355_4F4D, ______539F_56E0, ______5145_80FDID)
                _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548(_____5355_4F4D, _____7834_8840_4E4B_6212_7279_6548_952E)
                _____6E05_7406_7834_8840_4E4B_6212_4E0A_4E0B_6587(_____5355_4F4D)
            end
        }
    )
end
____exports["处理破血之戒使用"] = function(_____4E0A_4E0B_6587)
    _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7("05．破血之戒", "进入", "处理破血之戒使用")
    if not _____662F_5426_4E3A_7834_8840_4E4B_6212(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    if _____4E0A_4E0B_6587["目标单位"] == nil or _____4E0A_4E0B_6587["目标单位"] == 0 then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    _____7834_8840_4E4B_6212_4E0A_4E0B_6587_6258_7BA1_5668["写入"](_____65BD_6CD5_5355_4F4D, {["施法单位"] = _____65BD_6CD5_5355_4F4D, ["目标X"] = _____4E0A_4E0B_6587["目标X"], ["目标Y"] = _____4E0A_4E0B_6587["目标Y"], ["目标单位"] = _____4E0A_4E0B_6587["目标单位"]})
    _____51CF_5C11_751F_547D_503C(
        _____65BD_6CD5_5355_4F4D,
        1000,
        true,
        false,
        nil,
        1
    )
    _____5F00_59CB_7834_8840_4E4B_6212_5145_80FD(_____65BD_6CD5_5355_4F4D)
end
return ____exports
