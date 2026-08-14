local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.00．配置")
local _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派学者单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.01．运行时上下文")
local _____83B7_53D6_5168_90E8_6559_6D3E_5B66_8005_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部教派学者上下文"]
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建教派学者上下文"]
local _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["教派学者单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.02．数值与表现配置")
local _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派学者技能配置"]
local _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派学者音效配置"]
local ____09_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.09．台词播放")
local _____64AD_653E_6559_6D3E_5B66_8005_53F0_8BCD = ____09_FF0E_53F0_8BCD_64AD_653E["播放教派学者台词"]
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
local ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.03．召唤物组状态管理")
local _____521B_5EFA_53EC_5524_7269_7EC4_72B6_6001 = ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406["创建召唤物组状态"]
local ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664 = ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664["执行非伤害生命移除"]
local ____04_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____04_FF0E_5BF9_5916_63A5_53E3["创建召唤物"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位最大生命"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss单体技能伤害"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____23_FF0EBoss_65BD_6CD5_65F6_95F4_7EBF = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.23．Boss施法时间线")
local _____6267_884CBoss_65BD_6CD5_65F6_95F4_7EBF = ____23_FF0EBoss_65BD_6CD5_65F6_95F4_7EBF["执行Boss施法时间线"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_2["取当前有效玩家人数"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_3["开始硬直"]
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local getBuffRuntime = ____require_result_4.getBuffRuntime
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_4["移除单位指定Buff"]
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_5.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_5.YDUserDataSetSafe
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_6.EC_CreateEffect
local ____require_result_7 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_7.Sound3DII_CooPlayReuse
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
local jass = require("jass.common")
local globals = require("jass.globals")
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetRandomInt = jass.GetRandomInt
local GetRandomReal = jass.GetRandomReal
local GetUnitState = jass.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitState = jass.SetUnitState
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____51A5_795E_9B54_95E8_6280_80FDID = stringToFourCCSafe(_____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["冥神魔门"])
local _____90AA_5C38_9B3C_5355_4F4D_7C7B_578BID = stringToFourCCSafe("u00G")
local _____5730_72F1_72AC_5355_4F4D_7C7B_578BID = stringToFourCCSafe("n05O")
local _____51A5_795E_9B54_95E8_5DF2_6CE8_518C = false
local function _____8BFB_53D6_5F53_524D_96BE_5EA6N()
    local value = __TS__Number(globals.udg_N)
    return value == value and value > 0 and value or 0
end
local function _____8BFB_53D6_5355_4F4D_5B9E_6570_5C5E_6027(unit, attr)
    if unit == nil or unit == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe("unit", unit, attr, "real")) or 0
end
local function _____8BBE_7F6E_5355_4F4D_5B9E_6570_5C5E_6027(unit, attr, value)
    if unit == nil or unit == 0 then
        return
    end
    YDUserDataSetSafe(
        "unit",
        unit,
        attr,
        "real",
        value
    )
end
local function _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027(unit, attr, delta)
    _____8BBE_7F6E_5355_4F4D_5B9E_6570_5C5E_6027(
        unit,
        attr,
        _____8BFB_53D6_5355_4F4D_5B9E_6570_5C5E_6027(unit, attr) + delta
    )
end
local function _____5F00_59CB_51A5_795E_9B54_95E8_65BD_6CD5_8868_73B0(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587["Boss单位"]
    local _____516C_5171 = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥神魔门"]
    _____6267_884CBoss_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "教派学者-冥神魔门",
        ["单位"] = boss,
        ["清理"] = _____4E0A_4E0B_6587["清理"],
        ["施法秒"] = _____516C_5171["通魔施法秒"],
        ["动作名"] = _____516C_5171["动作名"],
        ["吟唱条"] = {
            ["类型"] = "常规",
            ["通道"] = _____914D_7F6E["读条通道"],
            ["颜色ID"] = _____516C_5171["读条颜色ID"],
            ["标题文本"] = _____914D_7F6E["读条标题"],
            ["提示文本"] = _____914D_7F6E["读条提示"]
        },
        ["延迟登记名"] = "教派学者-冥神魔门读条关闭"
    })
end
local function _____7ED3_675F_9B54_95E8_53CD_566C(_____4E0A_4E0B_6587, _____539F_56E0)
    if not _____4E0A_4E0B_6587["魔门反噬生效"] then
        return
    end
    _____4E0A_4E0B_6587["魔门反噬生效"] = false
    if _____4E0A_4E0B_6587["Boss单位"] ~= nil and _____4E0A_4E0B_6587["Boss单位"] ~= 0 then
        _____8BBE_7F6E_5355_4F4D_5B9E_6570_5C5E_6027(_____4E0A_4E0B_6587["Boss单位"], "魔抗", _____4E0A_4E0B_6587["魔门反噬原魔抗"])
    end
    _____4E0A_4E0B_6587["魔门反噬结束回调ID"] = 0
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____4E0A_4E0B_6587["Boss单位"], _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["冥神魔门反噬"])
end
local function ____on_9B54_95E8_53CD_566C_5230_671F(variable)
    local _____4E0A_4E0B_6587 = variable
    if _____4E0A_4E0B_6587 ~= nil then
        _____7ED3_675F_9B54_95E8_53CD_566C(_____4E0A_4E0B_6587, "持续时间结束")
    end
end
local function _____89E6_53D1_9B54_95E8_53CD_566C(_____72B6_6001)
    local _____4E0A_4E0B_6587 = _____72B6_6001["上下文"]
    local boss = _____4E0A_4E0B_6587["Boss单位"]
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(boss) or _____4E0A_4E0B_6587["魔门反噬生效"] then
        return
    end
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥神魔门"]
    _____4E0A_4E0B_6587["魔门反噬生效"] = true
    _____4E0A_4E0B_6587["魔门反噬原魔抗"] = _____8BFB_53D6_5355_4F4D_5B9E_6570_5C5E_6027(boss, "魔抗")
    _____8BBE_7F6E_5355_4F4D_5B9E_6570_5C5E_6027(boss, "魔抗", 0)
    _____5F00_59CB_786C_76F4(boss, _____914D_7F6E["反噬硬直秒"])
    registerManualBuff(
        boss,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["冥神魔门反噬"],
        _____914D_7F6E["反噬硬直秒"],
        _____4E0A_4E0B_6587["魔门反噬原魔抗"],
        {sourceUnit = boss, effectSourceName = "冥神魔门反噬", effectSourceType = "技能"}
    )
    _____4E0A_4E0B_6587["魔门反噬结束回调ID"] = addDelayedCallback(_____914D_7F6E["反噬硬直秒"] * 1000, ____on_9B54_95E8_53CD_566C_5230_671F, _____4E0A_4E0B_6587)
    local ____self_9 = _____4E0A_4E0B_6587["清理"]
    ____self_9["登记延迟回调"](____self_9, "教派学者-魔门反噬恢复", _____4E0A_4E0B_6587["魔门反噬结束回调ID"])
end
local function _____6062_590D_9B54_95E8_6CBB_7597_538B_5236(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已恢复"] then
        return
    end
    local buffID = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["魔门邪尸鬼治疗压制"]
    local _____5F53_524DBuff_8FD0_884C_65F6 = getBuffRuntime(_____72B6_6001["目标单位"], buffID)
    _____72B6_6001["已恢复"] = true
    _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027(_____72B6_6001["目标单位"], "受到的治疗率", _____72B6_6001["降低比例"])
    if _____72B6_6001["Buff运行时"] ~= nil and _____5F53_524DBuff_8FD0_884C_65F6 == _____72B6_6001["Buff运行时"] then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["目标单位"], buffID)
    end
    _____72B6_6001["Buff运行时"] = nil
end
local function _____65BD_52A0_9B54_95E8_6CBB_7597_538B_5236(_____72B6_6001, target)
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥神魔门"]
    _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027(target, "受到的治疗率", -_____914D_7F6E["邪尸鬼治疗降低比例"])
    local buffID = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["魔门邪尸鬼治疗压制"]
    registerManualBuff(
        target,
        buffID,
        _____914D_7F6E["邪尸鬼治疗降低秒"],
        -_____914D_7F6E["邪尸鬼治疗降低比例"],
        {sourceUnit = _____72B6_6001["上下文"]["Boss单位"], effectSourceName = "冥神魔门邪尸鬼", effectSourceType = "技能"}
    )
    local _____538B_5236_72B6_6001 = {
        ["已恢复"] = false,
        ["上下文"] = _____72B6_6001["上下文"],
        ["目标单位"] = target,
        ["降低比例"] = _____914D_7F6E["邪尸鬼治疗降低比例"],
        ["Buff运行时"] = getBuffRuntime(target, buffID)
    }
    local ____self_10 = _____72B6_6001["上下文"]["清理"]
    ____self_10["登记清理"](____self_10, "教派学者-魔门治疗压制恢复", _____6062_590D_9B54_95E8_6CBB_7597_538B_5236, _____538B_5236_72B6_6001)
    local _____56DE_8C03ID = addDelayedCallback(_____914D_7F6E["邪尸鬼治疗降低秒"] * 1000, _____6062_590D_9B54_95E8_6CBB_7597_538B_5236, _____538B_5236_72B6_6001)
    local ____self_11 = _____72B6_6001["上下文"]["清理"]
    ____self_11["登记延迟回调"](____self_11, "教派学者-魔门治疗压制到期", _____56DE_8C03ID)
end
local function _____7ED3_675F_51A5_795E_9B54_95E8(_____72B6_6001, _____539F_56E0)
    if _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["已结束"] = true
    if _____72B6_6001["召唤周期ID"] ~= 0 then
        removePeriodicCallback(_____72B6_6001["召唤周期ID"])
        _____72B6_6001["召唤周期ID"] = 0
    end
    if not _____72B6_6001["批次已结束"] then
        _____72B6_6001["批次已结束"] = true
        local ____self_12 = _____72B6_6001["召唤组"]
        ____self_12["结束批次"](____self_12)
    end
    local ____self_13 = _____72B6_6001["召唤组"]
    ____self_13["清空"](____self_13, true)
    local _____95E8_5B9E_4F8B = _____72B6_6001["门实例"]
    _____72B6_6001["门实例"] = nil
    _____72B6_6001["门单位"] = nil
    if _____95E8_5B9E_4F8B ~= nil then
        _____95E8_5B9E_4F8B["销毁"](_____95E8_5B9E_4F8B, "主动销毁")
    end
    if _____72B6_6001["上下文"]["冥神魔门状态"] == _____72B6_6001 then
        _____72B6_6001["上下文"]["冥神魔门状态"] = nil
    end
end
local function ____on_51A5_795E_9B54_95E8_6E05_7406(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil then
        return
    end
    _____7ED3_675F_51A5_795E_9B54_95E8(_____72B6_6001, "上下文清理")
    _____7ED3_675F_9B54_95E8_53CD_566C(_____72B6_6001["上下文"], "上下文清理")
end
local function ____on_9B54_95E8_673A_5236_7ED3_675F(_unit, reason, killer, variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["门实例"] = nil
    _____72B6_6001["门单位"] = nil
    if reason == "被击杀" and killer ~= nil and killer ~= 0 then
        Sound3DII_CooPlayReuse(
            _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E["冥神魔门"]["魔门被摧毁"],
            _____72B6_6001["门X"],
            _____72B6_6001["门Y"],
            0,
            _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["音效裁断距离"]
        )
        _____89E6_53D1_9B54_95E8_53CD_566C(_____72B6_6001)
    end
    _____7ED3_675F_51A5_795E_9B54_95E8(_____72B6_6001, reason == "被击杀" and "次元之门被摧毁" or reason)
end
local function _____521B_5EFA_9B54_95E8_53EC_5524_7269(_____72B6_6001)
    if _____72B6_6001["已结束"] or not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____72B6_6001["上下文"]["Boss单位"]) or _____72B6_6001["门单位"] == nil or _____72B6_6001["门单位"] == 0 then
        return
    end
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥神魔门"]
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local index = GetRandomInt(0, #_____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["魔门召唤单位ID"] - 1)
    local _____5355_4F4D_7C7B_578B = _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["魔门召唤单位ID"][index + 1]
    local _____89D2_5EA6 = GetRandomReal(0, 360)
    local summon = _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = _____5355_4F4D_7C7B_578B,
        ["单位名称"] = "冥神魔门召唤物",
        X = _____6781_5750_6807X(_____72B6_6001["门X"], _____89D2_5EA6, _____914D_7F6E["召唤散开距离"]),
        Y = _____6781_5750_6807Y(_____72B6_6001["门Y"], _____89D2_5EA6, _____914D_7F6E["召唤散开距离"]),
        ["朝向"] = _____89D2_5EA6,
        ["持续时间"] = _____914D_7F6E["召唤物持续秒"],
        ["索敌范围"] = _____914D_7F6E["召唤物索敌范围"]
    })
    if summon == nil or summon == 0 then
        return
    end
    Sound3DII_CooPlayReuse(
        _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E["冥神魔门"]["召唤物出现"],
        GetUnitX(summon),
        GetUnitY(summon),
        0,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["音效裁断距离"]
    )
    local ____self_14 = _____72B6_6001["召唤组"]
    ____self_14["登记"](____self_14, summon)
    _____72B6_6001["已召唤次数"] = _____72B6_6001["已召唤次数"] + 1
end
local function ____on_9B54_95E8_53EC_5524_5468_671F(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    _____521B_5EFA_9B54_95E8_53EC_5524_7269(_____72B6_6001)
    if _____72B6_6001["已召唤次数"] >= _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥神魔门"]["召唤次数"] then
        if _____72B6_6001["召唤周期ID"] ~= 0 then
            removePeriodicCallback(_____72B6_6001["召唤周期ID"])
            _____72B6_6001["召唤周期ID"] = 0
        end
        if not _____72B6_6001["批次已结束"] then
            _____72B6_6001["批次已结束"] = true
            local ____self_15 = _____72B6_6001["召唤组"]
            ____self_15["结束批次"](____self_15)
        end
    end
end
local function _____67E5_627E_9B54_95E8_5355_4F4D_5F52_5C5E(unit)
    if unit == nil or unit == 0 then
        return nil
    end
    local unitHid = GetHandleId(unit)
    local _____4E0A_4E0B_6587_5217_8868 = _____83B7_53D6_5168_90E8_6559_6D3E_5B66_8005_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #_____4E0A_4E0B_6587_5217_8868 do
            do
                local _____72B6_6001 = _____4E0A_4E0B_6587_5217_8868[i + 1]["冥神魔门状态"]
                if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
                    goto __continue42
                end
                if _____72B6_6001["门单位"] ~= nil and _____72B6_6001["门单位"] ~= 0 and GetHandleId(_____72B6_6001["门单位"]) == unitHid then
                    return {["状态"] = _____72B6_6001, ["类型"] = "门"}
                end
                local ____self_16 = _____72B6_6001["召唤组"]
                local _____53EC_5524_7269_5217_8868 = ____self_16["取单位列表"](____self_16)
                do
                    local j = 0
                    while j < #_____53EC_5524_7269_5217_8868 do
                        if GetHandleId(_____53EC_5524_7269_5217_8868[j + 1]) == unitHid then
                            return {["状态"] = _____72B6_6001, ["类型"] = "召唤物"}
                        end
                        j = j + 1
                    end
                end
            end
            ::__continue42::
            i = i + 1
        end
    end
    return nil
end
local function ____on_9B54_95E8_53EC_5524_666E_653B_6D3E_751F(variable)
    local _____5FEB_7167 = variable
    if _____5FEB_7167 == nil or _____5FEB_7167["状态"]["已结束"] or not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____5FEB_7167["状态"]["上下文"]["Boss单位"]) or not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____5FEB_7167["目标单位"]) then
        return
    end
    local boss = _____5FEB_7167["状态"]["上下文"]["Boss单位"]
    local target = _____5FEB_7167["目标单位"]
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥神魔门"]
    local _____7ED3_679C = _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["技能ID"] = _____51A5_795E_9B54_95E8_6280_80FDID,
        ["伤害公式"] = {["固定值"] = _____5FEB_7167["固定伤害"]},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = _____914D_7F6E["召唤普攻标签"],
        ["来源类型"] = "召唤物技能"
    })
    if _____7ED3_679C["是否造成伤害"] then
        EC_CreateEffect(
            _____914D_7F6E["召唤普攻命中特效路径"],
            GetUnitX(target),
            GetUnitY(target),
            0,
            0,
            _____914D_7F6E["召唤普攻命中特效缩放"],
            1,
            1
        )
        if _____5FEB_7167["召唤物类型ID"] == _____5730_72F1_72AC_5355_4F4D_7C7B_578BID then
            local _____6263_9B54 = _____914D_7F6E["地狱犬扣魔基础值"] + _____914D_7F6E["地狱犬每难度扣魔值"] * _____8BFB_53D6_5F53_524D_96BE_5EA6N()
            SetUnitState(
                target,
                UNIT_STATE_MANA,
                GetUnitState(target, UNIT_STATE_MANA) - _____6263_9B54
            )
        elseif _____5FEB_7167["召唤物类型ID"] == _____90AA_5C38_9B3C_5355_4F4D_7C7B_578BID then
            _____65BD_52A0_9B54_95E8_6CBB_7597_538B_5236(_____5FEB_7167["状态"], target)
        end
    end
end
local function _____9B54_95E8_53EC_5524_7269_666E_653B_66FF_6362_4FEE_6B63(context)
    if context == nil or not (context.currentDamage > 0) or context.isNormalAttack ~= true or context.isSkillAttack == true or context.isSkillDamage == true then
        local ____opt_result_19
        if context ~= nil then
            ____opt_result_19 = context.currentDamage
        end
        local ____opt_result_19_20 = ____opt_result_19
        if ____opt_result_19_20 == nil then
            ____opt_result_19_20 = 0
        end
        return ____opt_result_19_20
    end
    local _____5F52_5C5E = _____67E5_627E_9B54_95E8_5355_4F4D_5F52_5C5E(context.attacker)
    if _____5F52_5C5E == nil or _____5F52_5C5E["类型"] ~= "召唤物" then
        return context.currentDamage
    end
    local _____5FEB_7167 = {
        ["状态"] = _____5F52_5C5E["状态"],
        ["召唤物"] = context.attacker,
        ["目标单位"] = context.target,
        ["固定伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context.attacker),
        ["召唤物类型ID"] = GetUnitTypeId(context.attacker)
    }
    local _____56DE_8C03ID = addDelayedCallback(0, ____on_9B54_95E8_53EC_5524_666E_653B_6D3E_751F, _____5FEB_7167)
    local ____self_21 = _____5F52_5C5E["状态"]["上下文"]["清理"]
    ____self_21["登记延迟回调"](____self_21, "教派学者-魔门召唤普攻派生", _____56DE_8C03ID)
    return 0
end
local function _____9B54_95E8_96F7_5149_514B_5236_627F_4F24_4FEE_6B63(context)
    if context == nil or context.target == nil or context.target == 0 or context.isThunderDamage ~= true and context.isLightDamage ~= true then
        local ____opt_result_24
        if context ~= nil then
            ____opt_result_24 = context.currentDamage
        end
        local ____opt_result_24_25 = ____opt_result_24
        if ____opt_result_24_25 == nil then
            ____opt_result_24_25 = 0
        end
        return ____opt_result_24_25
    end
    local _____5F52_5C5E = _____67E5_627E_9B54_95E8_5355_4F4D_5F52_5C5E(context.target)
    if _____5F52_5C5E == nil then
        return context.currentDamage
    end
    local after = context.currentDamage * _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥神魔门"]["雷光承伤倍率"]
    return after
end
local function _____542F_52A8_51A5_795E_9B54_95E8_673A_5236(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(boss) or _____4E0A_4E0B_6587["冥神魔门状态"] ~= nil or _____4E0A_4E0B_6587["魔门反噬生效"] then
        return false
    end
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥神魔门"]
    local _____65B9_5411 = GetRandomReal(0, 360)
    local _____8DDD_79BB = GetRandomReal(_____914D_7F6E["生成最小距离"], _____914D_7F6E["生成最大距离"])
    local _____95E8X = _____6781_5750_6807X(
        GetUnitX(boss),
        _____65B9_5411,
        _____8DDD_79BB
    )
    local _____95E8Y = _____6781_5750_6807Y(
        GetUnitY(boss),
        _____65B9_5411,
        _____8DDD_79BB
    )
    local _____73A9_5BB6_6570 = _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570()
    local _____96BE_5EA6 = _____8BFB_53D6_5F53_524D_96BE_5EA6N()
    local _____751F_547D_6BD4_4F8B = _____73A9_5BB6_6570 <= 1 and _____914D_7F6E["单人生命比例"] or _____914D_7F6E["多人生命基础比例"] + _____914D_7F6E["每难度生命比例"] * _____96BE_5EA6
    local _____53EC_5524_7EC4 = _____521B_5EFA_53EC_5524_7269_7EC4_72B6_6001({["清理"] = _____4E0A_4E0B_6587["清理"], ["名称"] = "教派学者-冥神魔门召唤组"})
    local _____72B6_6001 = {
        ["已结束"] = false,
        ["上下文"] = _____4E0A_4E0B_6587,
        ["门X"] = _____95E8X,
        ["门Y"] = _____95E8Y,
        ["召唤组"] = _____53EC_5524_7EC4,
        ["已召唤次数"] = 0,
        ["批次已结束"] = false,
        ["召唤周期ID"] = 0
    }
    _____4E0A_4E0B_6587["冥神魔门状态"] = _____72B6_6001
    local ____self_28 = _____4E0A_4E0B_6587["清理"]
    ____self_28["登记清理"](____self_28, "教派学者-冥神魔门清理", ____on_51A5_795E_9B54_95E8_6E05_7406, _____72B6_6001)
    local _____79FB_9664_91CF = _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664({
        ["目标"] = boss,
        ["数值"] = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(boss) * _____914D_7F6E["自损最大生命比例"],
        ["不致死"] = false,
        ["显示文字"] = false,
        ["显示特效"] = false
    })
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(boss) then
        _____7ED3_675F_51A5_795E_9B54_95E8(_____72B6_6001, "自损后死亡")
        return false
    end
    _____72B6_6001["门实例"] = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = _____4E0A_4E0B_6587["清理"],
        ["名称"] = "教派学者-冥神魔门",
        ["单位名称"] = "次元之门",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["模型路径"] = _____914D_7F6E["模型路径"],
        X = _____95E8X,
        Y = _____95E8Y,
        ["最大生命"] = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(boss) * _____751F_547D_6BD4_4F8B,
        ["护甲"] = _____914D_7F6E["护甲"],
        ["固定站桩"] = true,
        ["禁止普攻"] = true,
        ["飞行高度"] = _____914D_7F6E["飞行高度"],
        ["缩放"] = _____914D_7F6E["缩放"],
        ["红"] = _____914D_7F6E["红"],
        ["绿"] = _____914D_7F6E["绿"],
        ["蓝"] = _____914D_7F6E["蓝"],
        ["持续时间"] = _____914D_7F6E["持续秒"],
        ["变量"] = _____72B6_6001,
        ["on结束"] = ____on_9B54_95E8_673A_5236_7ED3_675F
    })
    if _____72B6_6001["门实例"] == nil then
        _____7ED3_675F_51A5_795E_9B54_95E8(_____72B6_6001, "次元之门创建失败")
        return false
    end
    _____72B6_6001["门单位"] = _____72B6_6001["门实例"]["单位"]
    _____8BBE_7F6E_5355_4F4D_5B9E_6570_5C5E_6027(_____72B6_6001["门单位"], "魔抗", _____914D_7F6E["魔抗"])
    _____64AD_653E_6559_6D3E_5B66_8005_53F0_8BCD(_____72B6_6001["门单位"], "冥神魔门")
    Sound3DII_CooPlayReuse(
        _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E["冥神魔门"]["魔门开启"],
        _____72B6_6001["门X"],
        _____72B6_6001["门Y"],
        0,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["音效裁断距离"]
    )
    local ____self_29 = _____72B6_6001["召唤组"]
    ____self_29["开始批次"](____self_29, _____914D_7F6E["召唤次数"])
    _____72B6_6001["召唤周期ID"] = addPeriodicCallback(_____914D_7F6E["召唤间隔秒"] * 1000, ____on_9B54_95E8_53EC_5524_5468_671F, _____72B6_6001)
    local ____self_30 = _____4E0A_4E0B_6587["清理"]
    ____self_30["登记周期回调"](____self_30, "教派学者-冥神魔门召唤周期", _____72B6_6001["召唤周期ID"])
    return true
end
local function ____on_51A5_795E_9B54_95E8_5EF6_8FDF_542F_52A8(variable)
    local _____8BF7_6C42 = variable
    if _____8BF7_6C42 ~= nil then
        _____542F_52A8_51A5_795E_9B54_95E8_673A_5236(_____8BF7_6C42["上下文"])
    end
end
____exports["释放教派学者冥神魔门"] = function(_____4E0A_4E0B_6587)
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]) or _____4E0A_4E0B_6587["冥神魔门状态"] ~= nil or _____4E0A_4E0B_6587["魔门反噬生效"] then
        return false
    end
    _____5F00_59CB_51A5_795E_9B54_95E8_65BD_6CD5_8868_73B0(_____4E0A_4E0B_6587)
    local _____56DE_8C03ID = addDelayedCallback(_____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["通魔施法秒"] * 1000, ____on_51A5_795E_9B54_95E8_5EF6_8FDF_542F_52A8, {["上下文"] = _____4E0A_4E0B_6587})
    local ____self_33 = _____4E0A_4E0B_6587["清理"]
    ____self_33["登记延迟回调"](____self_33, "教派学者-冥神魔门显式释放", _____56DE_8C03ID)
    return true
end
____exports["注册教派学者冥神魔门"] = function()
    if _____51A5_795E_9B54_95E8_5DF2_6CE8_518C then
        return
    end
    _____51A5_795E_9B54_95E8_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "教派学者-冥神魔门",
        ["单位类型ID"] = _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["单位ID"],
        ["技能ID"] = _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["冥神魔门"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587,
        ["释放技能"] = function(_____4E0A_4E0B_6587)
            ____exports["释放教派学者冥神魔门"](_____4E0A_4E0B_6587)
        end
    })
    registerDamageModifier(_____9B54_95E8_53EC_5524_7269_666E_653B_66FF_6362_4FEE_6B63, _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥神魔门"]["普攻替换修正优先级"])
    registerDamageModifier(_____9B54_95E8_96F7_5149_514B_5236_627F_4F24_4FEE_6B63, _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥神魔门"]["克制承伤修正优先级"])
end
return ____exports
