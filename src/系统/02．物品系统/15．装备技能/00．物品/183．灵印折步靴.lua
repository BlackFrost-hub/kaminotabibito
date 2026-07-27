--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_6301_6709_6218_6597_5468_671F_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.04．持有战斗周期模板")
local _____6CE8_518C_6301_6709_6218_6597_5468_671F_6A21_677F = ____04_FF0E_6301_6709_6218_6597_5468_671F_6A21_677F["注册持有战斗周期模板"]
local ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.24．句柄上下文托管")
local _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668 = ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1["创建句柄上下文托管器"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6CE8_518C_6218_6597_81EA_8EAB_4F4D_79FB_5B8C_6210_76D1_542C = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["注册战斗自身位移完成监听"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668 = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["创建单位临时属性效果托管器"]
local ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.23．装备属性定义")
local _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879 = ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49["创建装备玩家属性项"]
local _____88C5_5907_5C5E_6027_952E = ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49["装备属性键"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____53D6_88C5_5907_7269_54C1ID = ____07_FF0E_88C5_5907_8F85_52A9["取装备物品ID"]
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_5C31_7EEA = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却就绪"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却并显示"]
local _____64AD_653E_70B9_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放点特效"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local R2I = jass.R2I
local SetTextTagText = jass.SetTextTagText
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
local CreateFloatTextAtPoint = ____require_result_1.CreateFloatTextAtPoint
local DestroyFloatText = ____require_result_1.DestroyFloatText
local _____5370_8BB0 = _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668("灵印折步靴")
local _____6298_6B65_56DE_8EAB_5C5E_6027_6548_679C = _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668()
local _____6298_6B65_5370_8BB0_6301_7EED_6BEB_79D2 = 8000
local _____6298_6B65_6587_5B57_9AD8_5EA6 = 0.0207
local function _____6E05_9664_6298_6B65_56DE_8EAB_5C5E_6027(unit, _buffID, _row)
    _____6298_6B65_56DE_8EAB_5C5E_6027_6548_679C["清除"](unit)
end
local function _____521B_5EFA_6298_6B65_8D77_70B9_6587_5B57(x, y)
    return CreateFloatTextAtPoint(x, y, "折步起点 8.0", {
        size = 9,
        red = 160,
        green = 220,
        blue = 255,
        alpha = 0,
        duration = 0,
        permanent = true,
        speedX = 0,
        speedY = 0,
        height = 45
    })
end
local function _____6E05_9664_6298_6B65_5370_8BB0(unit)
    local s = _____5370_8BB0["取出"](unit)
    if s == nil then
        return
    end
    if s["倒计时回调ID"] > 0 then
        removePeriodicCallback(s["倒计时回调ID"])
    end
    DestroyFloatText(s["文字"])
end
local function _____66F4_65B0_6298_6B65_5012_8BA1_65F6(unit)
    if unit == nil then
        return
    end
    local s = _____5370_8BB0["读取"](unit)
    if s == nil then
        return
    end
    local _____5269_4F59_6BEB_79D2 = s["到期"] - getServerTime()
    if _____5269_4F59_6BEB_79D2 <= 0 then
        _____6E05_9664_6298_6B65_5370_8BB0(unit)
        return
    end
    local _____5341_5206_4E4B_4E00_79D2 = R2I((_____5269_4F59_6BEB_79D2 + 99) / 100)
    local _____6574_79D2 = R2I(_____5341_5206_4E4B_4E00_79D2 / 10)
    local _____5C0F_6570 = _____5341_5206_4E4B_4E00_79D2 - _____6574_79D2 * 10
    SetTextTagText(
        s["文字"],
        (("折步起点 " .. tostring(_____6574_79D2)) .. ".") .. tostring(_____5C0F_6570),
        _____6298_6B65_6587_5B57_9AD8_5EA6
    )
end
local function ____on_6298_6B65_88C5_5907_4E22_5F03(e)
    _____6E05_9664_6298_6B65_5370_8BB0(e["单位"])
end
local function ____on_6298_6B65_4F4D_79FB(unit, startX, startY)
    if not _____5355_4F4D_6301_6709_88C5_5907(unit, _____56DBBoss_6218_5229_54C1_88C5_5907_540D["灵印折步靴"]) then
        return
    end
    local key = _____53D6_88C5_5907_51B7_5374_952E(unit, "折步留印")
    if not _____88C5_5907_51B7_5374_5C31_7EEA(key) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(key, 12, unit, _____56DBBoss_6218_5229_54C1_88C5_5907_540D["灵印折步靴"])
    _____6E05_9664_6298_6B65_5370_8BB0(unit)
    local s = {
        X = startX,
        Y = startY,
        ["到期"] = getServerTime() + _____6298_6B65_5370_8BB0_6301_7EED_6BEB_79D2,
        ["已离开"] = false,
        ["文字"] = _____521B_5EFA_6298_6B65_8D77_70B9_6587_5B57(startX, startY),
        ["倒计时回调ID"] = 0
    }
    _____5370_8BB0["写入"](unit, s)
    s["倒计时回调ID"] = addPeriodicCallback(100, _____66F4_65B0_6298_6B65_5012_8BA1_65F6, unit)
    _____64AD_653E_70B9_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["镇魂印"],
        startX,
        startY,
        8,
        0.7
    )
end
local function ____on_6298_6B65_8FD4_56DE_68C0_6D4B(e)
    local s = _____5370_8BB0["读取"](e["单位"])
    if s == nil then
        return
    end
    if getServerTime() >= s["到期"] then
        _____6E05_9664_6298_6B65_5370_8BB0(e["单位"])
        return
    end
    local dx = GetUnitX(e["单位"]) - s.X
    local dy = GetUnitY(e["单位"]) - s.Y
    local d2 = dx * dx + dy * dy
    if d2 > 220 * 220 then
        s["已离开"] = true
        return
    end
    if not s["已离开"] or d2 > 150 * 150 then
        return
    end
    _____6E05_9664_6298_6B65_5370_8BB0(e["单位"])
    registerManualBuff(
        e["单位"],
        _____5E38_89C4BuffID["灵印折步靴_折步回身"],
        4,
        0.18,
        {
            sourceUnit = e["单位"],
            effectSourceName = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["灵印折步靴"],
            effectSourceType = "装备",
            effectValue2 = 0.18,
            onRemove = _____6E05_9664_6298_6B65_56DE_8EAB_5C5E_6027
        }
    )
    _____6298_6B65_56DE_8EAB_5C5E_6027_6548_679C["施加"](
        e["单位"],
        0,
        {
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["物理抗性"], 0.18),
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["魔法抗性"], 0.18),
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["控制抗性"], 0.3)
        }
    )
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["魂力回灌"],
        e["单位"],
        "origin",
        1,
        0.3
    )
end
_____6CE8_518C_6218_6597_81EA_8EAB_4F4D_79FB_5B8C_6210_76D1_542C(____on_6298_6B65_4F4D_79FB)
_____6CE8_518C_6301_6709_6218_6597_5468_671F_6A21_677F({
    ["名称"] = "灵印折步靴-返回检测",
    ["物品类型ID"] = _____53D6_88C5_5907_7269_54C1ID(_____56DBBoss_6218_5229_54C1_88C5_5907_540D["灵印折步靴"]),
    ["周期秒"] = 0.25,
    ["on丢弃"] = ____on_6298_6B65_88C5_5907_4E22_5F03,
    ["on周期"] = ____on_6298_6B65_8FD4_56DE_68C0_6D4B
})
return ____exports
