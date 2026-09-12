--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668 = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["创建单位临时属性效果托管器"]
local ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.23．装备属性定义")
local _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879 = ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49["创建装备玩家属性项"]
local _____88C5_5907_5C5E_6027_952E = ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49["装备属性键"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____5355_4F4D_5B58_6D3B = ____07_FF0E_88C5_5907_8F85_52A9["单位存活"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____88C5_5907_5C0F_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["装备小特效"]
local _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["祖地秘境战利品装备名"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = ____require_result_1["获取玩家英雄单位组"]
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.02．通用物品技能槽位配置")
local _____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E_8868 = ____require_result_2["通用物品技能槽位配置表"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local ____require_result_5 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____require_result_5["常规BuffID"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local _____7948_798F_534A_5F84 = 600
local _____7948_798F_6301_7EED_79D2 = 2
local _____7948_798F_53CC_6297 = 0.05
local _____7948_798F_5C5E_6027_6548_679C = _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668()
local _____5F53_524D_7948_798F_65BD_6CD5_8005 = nil
local _____7269_54C1_58F3_6280_80FDID_96C6_5408 = {}
for ____, _____914D_7F6E in ipairs(_____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E_8868) do
    _____7269_54C1_58F3_6280_80FDID_96C6_5408[stringToFourCCSafe(_____914D_7F6E["技能ID"])] = true
end
local function _____6E05_9664_7948_798F_5C5E_6027(unit, _buffID, _row)
    _____7948_798F_5C5E_6027_6548_679C["清除"](unit)
end
local function _____5BF9_7EC4_5185_82F1_96C4_65BD_52A0_7948_798F()
    local caster = _____5F53_524D_7948_798F_65BD_6CD5_8005
    if caster == nil or caster == 0 then
        return
    end
    local ally = GetEnumUnit()
    if not _____5355_4F4D_5B58_6D3B(ally) then
        return
    end
    local dx = GetUnitX(ally) - GetUnitX(caster)
    local dy = GetUnitY(ally) - GetUnitY(caster)
    if dx * dx + dy * dy > _____7948_798F_534A_5F84 * _____7948_798F_534A_5F84 then
        return
    end
    registerManualBuff(
        ally,
        _____5E38_89C4BuffID["潮印祈福徽_祈福"],
        _____7948_798F_6301_7EED_79D2,
        _____7948_798F_53CC_6297,
        {
            sourceUnit = caster,
            effectSourceName = _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["潮印祈福徽"],
            effectSourceType = "装备",
            effectValue2 = _____7948_798F_53CC_6297,
            onRemove = _____6E05_9664_7948_798F_5C5E_6027
        }
    )
    _____7948_798F_5C5E_6027_6548_679C["施加"](
        ally,
        0,
        {
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["物理抗性"], _____7948_798F_53CC_6297),
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["魔法抗性"], _____7948_798F_53CC_6297)
        }
    )
    _____64AD_653E_5355_4F4D_7279_6548(
        _____88C5_5907_5C0F_7279_6548["护盾闪光"],
        ally,
        "origin",
        1,
        0.5
    )
end
local function ____on_7948_798F_65BD_6CD5(caster, spellAbilityId)
    if _____7269_54C1_58F3_6280_80FDID_96C6_5408[spellAbilityId] == true then
        return
    end
    if not _____5355_4F4D_6301_6709_88C5_5907(caster, _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["潮印祈福徽"]) then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    local _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    if _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 == nil or _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 == 0 then
        return
    end
    _____5F53_524D_7948_798F_65BD_6CD5_8005 = caster
    ForGroup(_____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4, _____5BF9_7EC4_5185_82F1_96C4_65BD_52A0_7948_798F)
    _____5F53_524D_7948_798F_65BD_6CD5_8005 = nil
end
registerSpellEffectListener(____on_7948_798F_65BD_6CD5)
return ____exports
