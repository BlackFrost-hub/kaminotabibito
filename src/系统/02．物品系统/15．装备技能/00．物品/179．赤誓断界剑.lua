local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____04_FF0E_5F3A_5316_666E_653B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.04．强化普攻")
local _____6DFB_52A0_5F3A_5316_666E_653B = ____04_FF0E_5F3A_5316_666E_653B["添加强化普攻"]
local _____6E05_9664_5F3A_5316_666E_653B = ____04_FF0E_5F3A_5316_666E_653B["清除强化普攻"]
local _____6247_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D = _____6247_5F62_533A_57DF["获取扇形区域单位"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6CE8_518C_6218_6597_81EA_8EAB_4F4D_79FB_5B8C_6210_76D1_542C = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["注册战斗自身位移完成监听"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_5C31_7EEA = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却就绪"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却并显示"]
local _____662F_654C_5BF9_5355_4F4D = ____07_FF0E_88C5_5907_8F85_52A9["是敌对单位"]
local _____53D6_653B_51FB_529B = ____07_FF0E_88C5_5907_8F85_52A9["取攻击力"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____5F00_59CB_901A_7528_62A4_76FE = ____07_FF0E_88C5_5907_8F85_52A9["开始通用护盾"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["造成装备伤害"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____07_FF0E_88C5_5907_8F85_52A9["装备伤害类型"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____00_FF0EBuff_7CFB_7EDF["移除单位指定Buff"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____8A93_950B_58C1_8FDB_72B6_6001_540D = "誓锋壁进"
local _____8D64_8A93Buff_79FB_9664_4E2D = {}
local _____8D64_8A93_5F3A_5316_7ED3_675F_4E2D = {}
local function _____53D6_8D64_8A93_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function ____on_8A93_950BBuff_79FB_9664(unit, _buffID, _row)
    local id = _____53D6_8D64_8A93_5355_4F4DID(unit)
    if id ~= 0 and _____8D64_8A93_5F3A_5316_7ED3_675F_4E2D[id] == true then
        return
    end
    if id ~= 0 then
        _____8D64_8A93Buff_79FB_9664_4E2D[id] = true
    end
    _____6E05_9664_5F3A_5316_666E_653B(unit, _____8A93_950B_58C1_8FDB_72B6_6001_540D)
    if id ~= 0 then
        __TS__Delete(_____8D64_8A93Buff_79FB_9664_4E2D, id)
    end
end
local function ____on_8A93_950B_5F3A_5316_7ED3_675F(context)
    local id = _____53D6_8D64_8A93_5355_4F4DID(context["单位"])
    if id ~= 0 and _____8D64_8A93Buff_79FB_9664_4E2D[id] == true then
        return
    end
    if id ~= 0 then
        _____8D64_8A93_5F3A_5316_7ED3_675F_4E2D[id] = true
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["单位"], _____5E38_89C4BuffID["赤誓断界剑_誓锋壁进"])
    if id ~= 0 then
        __TS__Delete(_____8D64_8A93_5F3A_5316_7ED3_675F_4E2D, id)
    end
end
local function ____on_8A93_950B_547D_4E2D(c)
    local sx = jass.GetUnitX(c["单位"])
    local sy = jass.GetUnitY(c["单位"])
    local tx = jass.GetUnitX(c["目标"])
    local ty = jass.GetUnitY(c["目标"])
    local angle = jass.Atan2(ty - sy, tx - sx) * 57.2957795
    local units = _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = sx,
        Y = sy,
        ["半径"] = 360,
        ["方向角"] = angle,
        ["扇形角度"] = 100
    })
    do
        local i = 0
        while i < #units do
            do
                if units[i + 1] == c["目标"] or not _____662F_654C_5BF9_5355_4F4D(c["单位"], units[i + 1]) then
                    goto __continue14
                end
                _____9020_6210_88C5_5907_4F24_5BB3(
                    c["单位"],
                    units[i + 1],
                    _____53D6_653B_51FB_529B(c["单位"]) * 0.7,
                    _____88C5_5907_4F24_5BB3_7C7B_578B["物理"],
                    false,
                    nil,
                    {["装备技能类型"] = "普攻强化", ["标签"] = "誓锋壁进", ["伤害形态"] = "AOE"}
                )
            end
            ::__continue14::
            i = i + 1
        end
    end
    _____5F00_59CB_901A_7528_62A4_76FE(
        c["单位"],
        c["单位"],
        _____53D6_6700_5927_751F_547D(c["单位"]) * 0.08,
        4,
        "誓锋壁进"
    )
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["誓盾"],
        c["单位"],
        "origin",
        1,
        0.35
    )
end
local function ____on_8D64_8A93_4F4D_79FB(unit)
    if not _____5355_4F4D_6301_6709_88C5_5907(unit, _____56DBBoss_6218_5229_54C1_88C5_5907_540D["赤誓断界剑"]) then
        return
    end
    local key = _____53D6_88C5_5907_51B7_5374_952E(unit, "誓锋壁进")
    if not _____88C5_5907_51B7_5374_5C31_7EEA(key) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(key, 10, unit, _____56DBBoss_6218_5229_54C1_88C5_5907_540D["赤誓断界剑"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____5E38_89C4BuffID["赤誓断界剑_誓锋壁进"])
    local added = _____6DFB_52A0_5F3A_5316_666E_653B({
        ["单位"] = unit,
        ["名称"] = _____8A93_950B_58C1_8FDB_72B6_6001_540D,
        ["持续时间"] = 8,
        ["次数"] = 1,
        ["伤害倍率"] = 1.3,
        ["on命中"] = ____on_8A93_950B_547D_4E2D,
        ["on结束"] = ____on_8A93_950B_5F3A_5316_7ED3_675F
    })
    if not added then
        return
    end
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["赤誓断界剑_誓锋壁进"],
        8,
        0.3,
        {sourceUnit = unit, effectSourceName = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["赤誓断界剑"], effectSourceType = "装备", onRemove = ____on_8A93_950BBuff_79FB_9664}
    )
end
_____6CE8_518C_6218_6597_81EA_8EAB_4F4D_79FB_5B8C_6210_76D1_542C(____on_8D64_8A93_4F4D_79FB)
return ____exports
