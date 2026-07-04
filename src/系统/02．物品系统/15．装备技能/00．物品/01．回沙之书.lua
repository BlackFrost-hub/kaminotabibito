--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____53D6_88C5_5907_51B7_5374_952E = ____20_FF0E_7269_54C1_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____20_FF0E_7269_54C1_8F85_52A9["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____20_FF0E_7269_54C1_8F85_52A9["进入装备冷却并显示"]
local _____5EF6_8FDF_6267_884C_5355_4F4D_52A8_4F5C = ____20_FF0E_7269_54C1_8F85_52A9["延迟执行单位动作"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_0.YDWETimerDestroyEffectSafe
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧")
local _____5F00_59CB_65E0_654C_5E27 = ____require_result_1["开始无敌帧"]
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_2.resolveItemIdByName
local ____require_result_3 = require("lib.扩展函数.物品相关函数.物品累伤次数函数")
local _____5355_4F4D_7269_54C1_7D2F_4F24_6B21_6570 = ____require_result_3["单位物品累伤次数"]
local _____83B7_53D6_5355_4F4D_6307_5B9A_88C5_5907 = ____require_result_3["获取单位指定装备"]
local ____require_result_4 = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表")
local _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E = ____require_result_4["回沙之书累计配置"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
local ____require_result_6 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_6.doHeal
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local _____56DE_6C99_4E4B_4E66ID = stringToFourCCSafe(resolveItemIdByName(_____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["物品名"]))
local function _____6267_884C_56DE_6C99_4E4B_4E66_65E0_654C_5E27(target)
    _____5F00_59CB_65E0_654C_5E27(target, 1.25)
end
____exports["处理回沙之书累计"] = function(target, _attacker, applied)
    if target == nil or target == 0 or not (applied > 0) then
        return
    end
    local item = _____83B7_53D6_5355_4F4D_6307_5B9A_88C5_5907(target, _____56DE_6C99_4E4B_4E66ID)
    if item == nil then
        return
    end
    local _____51B7_5374_952E = _____53D6_88C5_5907_51B7_5374_952E(target, "回沙之书", "累计伤害装备")
    local _____8FBE_5230_9608_503C = _____5355_4F4D_7269_54C1_7D2F_4F24_6B21_6570(
        target,
        _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["物品名"],
        applied,
        1,
        _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["累计阈值"],
        {
            ["是否在CD中"] = _____88C5_5907_51B7_5374_4E2D(_____51B7_5374_952E),
            ["达到阈值后重置"] = true
        }
    )
    local gain = applied * _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["法力恢复倍率"]
    if gain > 0 then
        doHeal({
            HealSource = target,
            HealTarget = target,
            HealAmount = 0,
            HealManaAmount = gain,
            ItemHeal = true,
            HealEffect = false,
            ManaEffect = true,
            ManaShowText = true
        })
    end
    if _____8FBE_5230_9608_503C then
        if _____88C5_5907_51B7_5374_4E2D(_____51B7_5374_952E) then
            return
        end
        local eff = AddSpecialEffectTarget(_____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["特效路径"], target, "overhead")
        if eff ~= nil then
            YDWETimerDestroyEffectSafe(_____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["特效持续时间"], eff)
        end
        _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(_____51B7_5374_952E, _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["冷却时间"], target, _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["物品名"])
        _____5EF6_8FDF_6267_884C_5355_4F4D_52A8_4F5C(target, 500, _____6267_884C_56DE_6C99_4E4B_4E66_65E0_654C_5E27)
    end
end
return ____exports
