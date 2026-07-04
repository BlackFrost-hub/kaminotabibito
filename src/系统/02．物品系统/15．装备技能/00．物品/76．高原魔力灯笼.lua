--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____9AD8_539F_9B54_529B_706F_7B3C_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["高原魔力灯笼配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____521B_5EFA_5355_4F4D_52A8_6001_52A0_6210_540C_6B65_5668 = ____20_FF0E_7269_54C1_8F85_52A9["创建单位动态加成同步器"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.05．昼夜状态")
local _____662F_5426_767D_5929 = ____require_result_1["是否白天"]
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_2["减少魔法值"]
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____83B7_53D6_8303_56F4_53CB_519B = ____require_result_3["获取范围友军"]
local _____53D6_5355_4F4DX = ____require_result_3["取单位X"]
local _____53D6_5355_4F4DY = ____require_result_3["取单位Y"]
local _____53D6_6700_5927_751F_547D = ____require_result_3["取最大生命"]
local _____6267_884C_6CBB_7597 = ____require_result_3["执行治疗"]
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_3["调整玩家属性"]
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local _____9AD8_539F_9B54_529B_706F_7B3C_591C_665A_51CF_4F24 = _____521B_5EFA_5355_4F4D_52A8_6001_52A0_6210_540C_6B65_5668(function(unit, _key, delta)
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, "伤害减少%", delta)
end)
local function _____540C_6B65_591C_665A_51CF_4F24(unit, currentCount)
    local nextCount = _____662F_5426_767D_5929() and 0 or currentCount
    _____9AD8_539F_9B54_529B_706F_7B3C_591C_665A_51CF_4F24["同步"](unit, nextCount > 0 and "伤害减少%" or nil, _____9AD8_539F_9B54_529B_706F_7B3C_914D_7F6E["夜晚伤害减少增加"] * nextCount)
end
local function _____6E05_7406_9AD8_539F_9B54_529B_706F_7B3C_72B6_6001(unit)
    _____9AD8_539F_9B54_529B_706F_7B3C_591C_665A_51CF_4F24["清理"](unit)
end
local function ____on_9AD8_539F_9B54_529B_706F_7B3C_5468_671F(unit, currentCount)
    local manaCost = GetUnitState(unit, UNIT_STATE_MAX_MANA) * _____9AD8_539F_9B54_529B_706F_7B3C_914D_7F6E["最大魔法消耗比例"] * currentCount
    _____51CF_5C11_9B54_6CD5_503C(unit, manaCost, true, false)
    _____540C_6B65_591C_665A_51CF_4F24(unit, currentCount)
    if not _____662F_5426_767D_5929() then
        return
    end
    local allies = _____83B7_53D6_8303_56F4_53CB_519B(
        unit,
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        _____9AD8_539F_9B54_529B_706F_7B3C_914D_7F6E["白天治疗半径"]
    )
    do
        local i = 0
        while i < #allies do
            local ally = allies[i + 1]
            _____6267_884C_6CBB_7597(
                unit,
                ally,
                _____53D6_6700_5927_751F_547D(ally) * _____9AD8_539F_9B54_529B_706F_7B3C_914D_7F6E["白天治疗最大生命比例"],
                0
            )
            i = i + 1
        end
    end
end
local function ____on_9AD8_539F_9B54_529B_706F_7B3C_4E22_5F03(unit)
    _____6E05_7406_9AD8_539F_9B54_529B_706F_7B3C_72B6_6001(unit)
end
local function _____521D_59CB_5316_9AD8_539F_9B54_529B_706F_7B3C()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["高原魔力灯笼"] == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({["物品类型ID"] = _____83B7_5F97_7269_54C1_88C5_5907ID["高原魔力灯笼"], ["间隔毫秒"] = _____9AD8_539F_9B54_529B_706F_7B3C_914D_7F6E["间隔毫秒"], ["周期回调"] = ____on_9AD8_539F_9B54_529B_706F_7B3C_5468_671F, ["丢弃回调"] = ____on_9AD8_539F_9B54_529B_706F_7B3C_4E22_5F03})
end
_____521D_59CB_5316_9AD8_539F_9B54_529B_706F_7B3C()
return ____exports
