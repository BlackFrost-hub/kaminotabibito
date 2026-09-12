local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____04_FF0E_5F3A_5316_666E_653B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.04．强化普攻")
local _____6DFB_52A0_5F3A_5316_666E_653B = ____04_FF0E_5F3A_5316_666E_653B["添加强化普攻"]
local _____6E05_9664_5F3A_5316_666E_653B = ____04_FF0E_5F3A_5316_666E_653B["清除强化普攻"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6CE8_518C_6218_6597_81EA_8EAB_4F4D_79FB_5B8C_6210_76D1_542C = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["注册战斗自身位移完成监听"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668 = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["创建单位临时属性效果托管器"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["祖地秘境战利品装备名"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____00_FF0EBuff_7CFB_7EDF["移除单位指定Buff"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____88C2_6CE2_72B6_6001_540D = "裂波"
local _____88C2_6CE2_6301_7EED_79D2 = 5
local _____88C2_6CE2Buff_79FB_9664_4E2D = {}
local _____88C2_6CE2_5F3A_5316_7ED3_675F_4E2D = {}
local _____88C2_6CE2_5C5E_6027_6548_679C = _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668()
local _____88C2_6CE2_7279_6548 = "Common\\Effect\\Element\\Water\\WetShockMark.mdx"
local function _____53D6_88C2_6CE2_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____6E05_9664_88C2_6CE2_5C5E_6027(unit)
    _____88C2_6CE2_5C5E_6027_6548_679C["清除"](unit)
end
local function ____on_88C2_6CE2Buff_79FB_9664(unit, _buffID, _row)
    local id = _____53D6_88C2_6CE2_5355_4F4DID(unit)
    if id ~= 0 and _____88C2_6CE2_5F3A_5316_7ED3_675F_4E2D[id] == true then
        return
    end
    if id ~= 0 then
        _____88C2_6CE2Buff_79FB_9664_4E2D[id] = true
    end
    _____6E05_9664_5F3A_5316_666E_653B(unit, _____88C2_6CE2_72B6_6001_540D)
    _____6E05_9664_88C2_6CE2_5C5E_6027(unit)
    if id ~= 0 then
        __TS__Delete(_____88C2_6CE2Buff_79FB_9664_4E2D, id)
    end
end
local function ____on_88C2_6CE2_5F3A_5316_7ED3_675F(context)
    local id = _____53D6_88C2_6CE2_5355_4F4DID(context["单位"])
    if id ~= 0 and _____88C2_6CE2Buff_79FB_9664_4E2D[id] == true then
        return
    end
    if id ~= 0 then
        _____88C2_6CE2_5F3A_5316_7ED3_675F_4E2D[id] = true
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["单位"], _____5E38_89C4BuffID["鳞影裂波刃_裂波"])
    _____6E05_9664_88C2_6CE2_5C5E_6027(context["单位"])
    if id ~= 0 then
        __TS__Delete(_____88C2_6CE2_5F3A_5316_7ED3_675F_4E2D, id)
    end
end
local function ____on_88C2_6CE2_4F4D_79FB(unit)
    if not _____5355_4F4D_6301_6709_88C5_5907(unit, _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["鳞影裂波刃"]) then
        return
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____5E38_89C4BuffID["鳞影裂波刃_裂波"])
    local added = _____6DFB_52A0_5F3A_5316_666E_653B({
        ["单位"] = unit,
        ["名称"] = _____88C2_6CE2_72B6_6001_540D,
        ["持续时间"] = _____88C2_6CE2_6301_7EED_79D2,
        ["次数"] = 1,
        ["伤害倍率"] = 1,
        ["on结束"] = ____on_88C2_6CE2_5F3A_5316_7ED3_675F
    })
    if not added then
        return
    end
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["鳞影裂波刃_裂波"],
        _____88C2_6CE2_6301_7EED_79D2,
        1,
        {sourceUnit = unit, effectSourceName = _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["鳞影裂波刃"], effectSourceType = "装备", onRemove = ____on_88C2_6CE2Buff_79FB_9664}
    )
    _____88C2_6CE2_5C5E_6027_6548_679C["施加"](unit, 0, {{["类型"] = "玩家属性", ["属性名"] = "必定暴击", ["数值"] = 1}})
    _____64AD_653E_5355_4F4D_7279_6548(
        _____88C2_6CE2_7279_6548,
        unit,
        "origin",
        1,
        0.6
    )
end
_____6CE8_518C_6218_6597_81EA_8EAB_4F4D_79FB_5B8C_6210_76D1_542C(____on_88C2_6CE2_4F4D_79FB)
return ____exports
