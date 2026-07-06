--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____5B88_62A4_4E4B_76FE_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["守护之盾配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____521B_5EFA_5355_4F4D_52A8_6001_52A0_6210_540C_6B65_5668 = ____20_FF0E_7269_54C1_8F85_52A9["创建单位动态加成同步器"]
local ____20_FF0E_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.20．友军范围承伤转移")
local _____521B_5EFA_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB = ____20_FF0E_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB["创建友军范围承伤转移"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
local _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF = ____require_result_1["获取单位当前持有指定物品数量"]
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____53D8_66F4_8D44_6E90_503C = ____require_result_2["变更资源值"]
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_3["临时调整攻击"]
local _____5355_4F4D_5B58_6D3B = ____require_result_3["单位存活"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ConvertUnitState = jass.ConvertUnitState
local GetUnitStateJapi = japi.GetUnitState
local _____5DF2_6CE8_518C_5B88_62A4_4E4B_76FE_4F24_5BB3_4FEE_6B63 = false
local _____5B88_62A4_4E4B_76FE_6301_6709_63A7_5236_5668 = nil
local _____5B88_62A4_4E4B_76FE_653B_51FB_52A0_6210 = _____521B_5EFA_5355_4F4D_52A8_6001_52A0_6210_540C_6B65_5668(function(unit, _key, delta)
    _____4E34_65F6_8C03_6574_653B_51FB(unit, delta)
end)
local function _____53D6_5355_4F4D_62A4_7532(unit)
    return GetUnitStateJapi(
        unit,
        ConvertUnitState(32)
    )
end
local function _____6E05_7406_5B88_62A4_4E4B_76FE_653B_51FB_52A0_6210(unit)
    _____5B88_62A4_4E4B_76FE_653B_51FB_52A0_6210["清理"](unit)
end
local function ____on_5B88_62A4_4E4B_76FE_653B_51FB_540C_6B65(unit, currentCount)
    if not _____5355_4F4D_5B58_6D3B(unit) or currentCount <= 0 then
        _____6E05_7406_5B88_62A4_4E4B_76FE_653B_51FB_52A0_6210(unit)
        return
    end
    local nextBonus = _____53D6_5355_4F4D_62A4_7532(unit) * _____5B88_62A4_4E4B_76FE_914D_7F6E["防转攻比例"] * currentCount
    _____5B88_62A4_4E4B_76FE_653B_51FB_52A0_6210["同步"](unit, "攻击", nextBonus)
end
local function ____on_5B88_62A4_4E4B_76FE_4E22_5F03(unit)
    _____6E05_7406_5B88_62A4_4E4B_76FE_653B_51FB_52A0_6210(unit)
end
local function _____5B88_62A4_4E4B_76FE_53D7_51FB_8FC7_6EE4(event)
    return _____5355_4F4D_5B58_6D3B(event["受击者"])
end
local function _____5B88_62A4_4E4B_76FE_53EF_627F_53D7_8005(event)
    local holder = event["候选单位"]
    return _____5355_4F4D_5B58_6D3B(holder) and _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF(holder, _____83B7_5F97_7269_54C1_88C5_5907ID["守护之盾"]) > 0
end
local function ____on_5B88_62A4_4E4B_76FE_8F6C_79FB(event)
    _____53D8_66F4_8D44_6E90_503C(
        event["承受者"],
        -event["转移伤害"],
        "life",
        true,
        false,
        nil,
        0
    )
end
local function _____521D_59CB_5316_5B88_62A4_4E4B_76FE()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["守护之盾"] == 0 then
        return
    end
    _____5B88_62A4_4E4B_76FE_6301_6709_63A7_5236_5668 = _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({["物品类型ID"] = _____83B7_5F97_7269_54C1_88C5_5907ID["守护之盾"], ["间隔毫秒"] = _____5B88_62A4_4E4B_76FE_914D_7F6E["攻击同步间隔毫秒"], ["周期回调"] = ____on_5B88_62A4_4E4B_76FE_653B_51FB_540C_6B65, ["丢弃回调"] = ____on_5B88_62A4_4E4B_76FE_4E22_5F03})
    if not _____5DF2_6CE8_518C_5B88_62A4_4E4B_76FE_4F24_5BB3_4FEE_6B63 then
        _____5DF2_6CE8_518C_5B88_62A4_4E4B_76FE_4F24_5BB3_4FEE_6B63 = true
        _____521B_5EFA_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB({
            ["名称"] = "守护之盾承伤转移",
            ["转移比例"] = _____5B88_62A4_4E4B_76FE_914D_7F6E["转移比例"],
            ["转移半径"] = _____5B88_62A4_4E4B_76FE_914D_7F6E["转移半径"],
            ["优先级"] = 35,
            ["获取候选单位列表"] = function()
                return _____5B88_62A4_4E4B_76FE_6301_6709_63A7_5236_5668 and _____5B88_62A4_4E4B_76FE_6301_6709_63A7_5236_5668["获取单位列表"]() or ({})
            end,
            ["过滤伤害"] = _____5B88_62A4_4E4B_76FE_53D7_51FB_8FC7_6EE4,
            ["可承受者"] = _____5B88_62A4_4E4B_76FE_53EF_627F_53D7_8005,
            ["on转移"] = ____on_5B88_62A4_4E4B_76FE_8F6C_79FB
        })
    end
end
_____521D_59CB_5316_5B88_62A4_4E4B_76FE()
return ____exports
