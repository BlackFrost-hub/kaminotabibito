local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____04_FF0E_6301_6709_6218_6597_5468_671F_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.04．持有战斗周期模板")
local _____6CE8_518C_6301_6709_6218_6597_5468_671F_6A21_677F = ____04_FF0E_6301_6709_6218_6597_5468_671F_6A21_677F["注册持有战斗周期模板"]
local ____28_FF0E_5355_4F4D_9A7B_7559_8FDB_5EA6 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.28．单位驻留进度")
local _____521B_5EFA_5355_4F4D_9A7B_7559_8FDB_5EA6 = ____28_FF0E_5355_4F4D_9A7B_7559_8FDB_5EA6["创建单位驻留进度"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["施加临时属性效果"]
local ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.23．装备属性定义")
local _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879 = ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49["创建装备玩家属性项"]
local _____88C5_5907_5C5E_6027_952E = ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49["装备属性键"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____00_FF0EBuff_7CFB_7EDF.getBuffRuntime
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____00_FF0EBuff_7CFB_7EDF["移除单位指定Buff"]
local _____8BBE_7F6E_5355_4F4DBuff_5C42_6570 = ____00_FF0EBuff_7CFB_7EDF["设置单位Buff层数"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_7269_54C1ID = ____07_FF0E_88C5_5907_8F85_52A9["取装备物品ID"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____9A7B_7559_8FDB_5EA6 = _____521B_5EFA_5355_4F4D_9A7B_7559_8FDB_5EA6("最后阵地重铠", 160)
local _____5B88_9635_6700_5927_5C42_6570 = 3
local _____5B88_9635_7269_7406_6297_6027 = 0.12
local _____5B88_9635_6548_679C_5B9E_4F8B_8868 = {}
local _____5B88_9635Buff_5237_65B0_4E2D = {}
local _____5B88_9635_6548_679C_6279_91CF_6E05_9664_4E2D = {}
local function _____53D6_5B88_9635_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____79FB_9664_5B88_9635_6548_679C_5B9E_4F8B_8BB0_5F55(unit, instance)
    local id = _____53D6_5B88_9635_5355_4F4DID(unit)
    local _____5B9E_4F8B_5217_8868 = _____5B88_9635_6548_679C_5B9E_4F8B_8868[id]
    if id == 0 or _____5B9E_4F8B_5217_8868 == nil then
        return
    end
    do
        local i = #_____5B9E_4F8B_5217_8868 - 1
        while i >= 0 do
            if _____5B9E_4F8B_5217_8868[i + 1] == instance then
                __TS__ArraySplice(_____5B9E_4F8B_5217_8868, i, 1)
            end
            i = i - 1
        end
    end
    if #_____5B9E_4F8B_5217_8868 == 0 then
        __TS__Delete(_____5B88_9635_6548_679C_5B9E_4F8B_8868, id)
    end
end
local function _____6E05_9664_5168_90E8_5B88_9635_6548_679C(unit, _buffID, _row)
    local id = _____53D6_5B88_9635_5355_4F4DID(unit)
    if id == 0 or _____5B88_9635Buff_5237_65B0_4E2D[id] == true then
        return
    end
    local _____5B9E_4F8B_5217_8868 = _____5B88_9635_6548_679C_5B9E_4F8B_8868[id]
    if _____5B9E_4F8B_5217_8868 == nil then
        return
    end
    __TS__Delete(_____5B88_9635_6548_679C_5B9E_4F8B_8868, id)
    _____5B88_9635_6548_679C_6279_91CF_6E05_9664_4E2D[id] = true
    do
        local i = #_____5B9E_4F8B_5217_8868 - 1
        while i >= 0 do
            _____5B9E_4F8B_5217_8868[i + 1]["清除"]()
            i = i - 1
        end
    end
    __TS__Delete(_____5B88_9635_6548_679C_6279_91CF_6E05_9664_4E2D, id)
end
local function _____53D6_4E0B_4E00_5C42_5B88_9635_5C42_6570(unit)
    local ____opt_0 = getBuffRuntime(unit, _____5E38_89C4BuffID["最后阵地重铠_守阵"])
    local _____5F53_524D_5C42_6570 = ____opt_0 and ____opt_0.stack or 0
    return _____5F53_524D_5C42_6570 < _____5B88_9635_6700_5927_5C42_6570 and _____5F53_524D_5C42_6570 + 1 or _____5B88_9635_6700_5927_5C42_6570
end
local function _____51CF_5C11_5B88_9635_5C42_6570(unit)
    local _____5F53_524DBuff = getBuffRuntime(unit, _____5E38_89C4BuffID["最后阵地重铠_守阵"])
    if _____5F53_524DBuff == nil then
        return
    end
    local _____5269_4F59_5C42_6570 = _____5F53_524DBuff.stack - 1
    if _____5269_4F59_5C42_6570 <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____5E38_89C4BuffID["最后阵地重铠_守阵"])
    else
        _____8BBE_7F6E_5355_4F4DBuff_5C42_6570(unit, _____5E38_89C4BuffID["最后阵地重铠_守阵"], _____5269_4F59_5C42_6570)
    end
end
local function _____65BD_52A0_5B88_9635_6548_679C(unit)
    local _____5C42_6570 = _____53D6_4E0B_4E00_5C42_5B88_9635_5C42_6570(unit)
    local id = _____53D6_5B88_9635_5355_4F4DID(unit)
    if id ~= 0 then
        _____5B88_9635Buff_5237_65B0_4E2D[id] = true
    end
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["最后阵地重铠_守阵"],
        2.2,
        18,
        {
            sourceUnit = unit,
            effectSourceName = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["最后阵地重铠"],
            effectSourceType = "装备",
            effectValue2 = _____5B88_9635_7269_7406_6297_6027,
            stack = _____5C42_6570,
            onRemove = _____6E05_9664_5168_90E8_5B88_9635_6548_679C
        }
    )
    if id ~= 0 then
        __TS__Delete(_____5B88_9635Buff_5237_65B0_4E2D, id)
    end
    local _____5F53_524D_5B9E_4F8B = nil
    _____5F53_524D_5B9E_4F8B = _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(
        unit,
        2200,
        {
            {["类型"] = "护甲", ["数值"] = 18},
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["物理抗性"], _____5B88_9635_7269_7406_6297_6027),
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["控制抗性"], 0.2)
        },
        {["on清除"] = function(u)
            if _____5F53_524D_5B9E_4F8B ~= nil then
                _____79FB_9664_5B88_9635_6548_679C_5B9E_4F8B_8BB0_5F55(u, _____5F53_524D_5B9E_4F8B)
            end
            if id == 0 or _____5B88_9635_6548_679C_6279_91CF_6E05_9664_4E2D[id] ~= true then
                _____51CF_5C11_5B88_9635_5C42_6570(u)
            end
        end}
    )
    if id ~= 0 and _____5F53_524D_5B9E_4F8B["是否激活"]() then
        local _____5B9E_4F8B_5217_8868 = _____5B88_9635_6548_679C_5B9E_4F8B_8868[id] or ({})
        _____5B9E_4F8B_5217_8868[#_____5B9E_4F8B_5217_8868 + 1] = _____5F53_524D_5B9E_4F8B
        _____5B88_9635_6548_679C_5B9E_4F8B_8868[id] = _____5B9E_4F8B_5217_8868
    end
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["安魂范围"],
        unit,
        "origin",
        2.2,
        0.35
    )
end
_____6CE8_518C_6301_6709_6218_6597_5468_671F_6A21_677F({
    ["名称"] = "最后阵地重铠",
    ["物品类型ID"] = _____53D6_88C5_5907_7269_54C1ID(_____56DBBoss_6218_5229_54C1_88C5_5907_540D["最后阵地重铠"]),
    ["周期秒"] = 1,
    ["on丢弃"] = function(event)
        _____9A7B_7559_8FDB_5EA6["清空"](event["单位"])
    end,
    ["on周期"] = function(event)
        local u = event["单位"]
        if _____9A7B_7559_8FDB_5EA6["采样"](u) >= 3 then
            _____65BD_52A0_5B88_9635_6548_679C(u)
        end
    end
})
return ____exports
