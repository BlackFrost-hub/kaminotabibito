--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.00．配置")
local _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派学者单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建教派学者上下文"]
local _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["教派学者单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.02．数值与表现配置")
local _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派学者技能配置"]
local ____09_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.09．台词播放")
local _____64AD_653E_6559_6D3E_5B66_8005_53F0_8BCD = ____09_FF0E_53F0_8BCD_64AD_653E["播放教派学者台词"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____8DDD_79BB_5E73_65B9XY = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离平方XY"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6309_6BD4_4F8B_79FB_9664_6700_5927_751F_547D = ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664["按比例移除最大生命"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_1["开始硬直"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_3["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_5.EC_CreateEffect
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetRandomInt = jass.GetRandomInt
local GetRandomReal = jass.GetRandomReal
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitAnimation = jass.SetUnitAnimation
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____51A5_4E4B_5FF5_6B32_6280_80FDID = stringToFourCCSafe(_____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["冥之念欲"])
local _____51A5_4E4B_5FF5_6B32_5DF2_6CE8_518C = false
local function _____53D6_5F97_51A5_4E4B_5FF5BuffID(_____7C7B_578B)
    if _____7C7B_578B == "念引" then
        return _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["冥之念引"]
    end
    if _____7C7B_578B == "念退" then
        return _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["冥之念退"]
    end
    return _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["冥之念赶"]
end
local function ____on_51A5_4E4B_5FF5_8BFB_6761_5173_95ED(variable)
    local _____8BF7_6C42 = variable
    if _____8BF7_6C42 == nil then
        return
    end
    _____5173_95ED_541F_5531_6761(_____8BF7_6C42["通道"])
end
local function _____5F00_59CB_51A5_4E4B_5FF5_6B32_65BD_6CD5_8868_73B0(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587["Boss单位"]
    local _____516C_5171 = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥之念欲"]
    _____5F00_59CB_786C_76F4(boss, _____516C_5171["通魔施法秒"])
    SetUnitAnimation(boss, _____516C_5171["动作名"])
    _____64AD_653E_6559_6D3E_5B66_8005_53F0_8BCD(boss, "冥之念欲")
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____516C_5171["通魔施法秒"],
        ["颜色ID"] = _____516C_5171["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
    local _____56DE_8C03ID = addDelayedCallback(_____516C_5171["通魔施法秒"] * 1000, ____on_51A5_4E4B_5FF5_8BFB_6761_5173_95ED, {["通道"] = _____914D_7F6E["读条通道"], ["Boss单位"] = boss})
    local ____self_7 = _____4E0A_4E0B_6587["清理"]
    ____self_7["登记延迟回调"](____self_7, "教派学者-冥之念欲读条关闭", _____56DE_8C03ID)
end
local function _____7ED3_675F_51A5_4E4B_5FF5_6B32(_____72B6_6001, _____539F_56E0)
    if _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["已结束"] = true
    local buffID = _____53D6_5F97_51A5_4E4B_5FF5BuffID(_____72B6_6001["类型"])
    do
        local i = 0
        while i < #_____72B6_6001["Buff目标列表"] do
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["Buff目标列表"][i + 1], buffID)
            i = i + 1
        end
    end
    if _____72B6_6001["上下文"]["冥之念欲状态"] == _____72B6_6001 then
        _____72B6_6001["上下文"]["冥之念欲状态"] = nil
    end
end
local function ____on_51A5_4E4B_5FF5_6B32_6E05_7406(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 ~= nil then
        _____7ED3_675F_51A5_4E4B_5FF5_6B32(_____72B6_6001, "上下文清理")
    end
end
local function _____76EE_6807_8FDD_53CD_51A5_5FF5_89C4_5219(_____72B6_6001, target)
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥之念欲"]
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    if _____72B6_6001["类型"] == "念引" then
        return _____8DDD_79BB_5E73_65B9XY(targetX, targetY, _____72B6_6001["Boss快照X"], _____72B6_6001["Boss快照Y"]) > _____914D_7F6E["念引安全半径"] * _____914D_7F6E["念引安全半径"]
    end
    if _____72B6_6001["类型"] == "念退" then
        return _____8DDD_79BB_5E73_65B9XY(targetX, targetY, _____72B6_6001["Boss快照X"], _____72B6_6001["Boss快照Y"]) < _____914D_7F6E["念退安全距离"] * _____914D_7F6E["念退安全距离"]
    end
    do
        local i = 0
        while i < #_____72B6_6001["安全点列表"] do
            local point = _____72B6_6001["安全点列表"][i + 1]
            if _____8DDD_79BB_5E73_65B9XY(targetX, targetY, point.X, point.Y) <= _____914D_7F6E["念赶安全区半径"] * _____914D_7F6E["念赶安全区半径"] then
                return false
            end
            i = i + 1
        end
    end
    return true
end
local function _____7ED3_7B97_51A5_4E4B_5FF5_4F24_5BB3(_____72B6_6001, target)
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥之念欲"]
    local _____76EE_6807_6700_5927_751F_547D_6BD4_4F8B = _____914D_7F6E["念引目标最大生命比例"]
    local ____Boss_653B_51FB_529B_6BD4_4F8B = _____914D_7F6E["念引Boss攻击力比例"]
    if _____72B6_6001["类型"] == "念退" then
        _____76EE_6807_6700_5927_751F_547D_6BD4_4F8B = _____914D_7F6E["念退目标最大生命比例"]
        ____Boss_653B_51FB_529B_6BD4_4F8B = _____914D_7F6E["念退Boss攻击力比例"]
    elseif _____72B6_6001["类型"] == "念赶" then
        _____76EE_6807_6700_5927_751F_547D_6BD4_4F8B = _____914D_7F6E["念赶目标最大生命比例"]
        ____Boss_653B_51FB_529B_6BD4_4F8B = _____914D_7F6E["念赶Boss攻击力比例"]
    end
    local _____7ED3_679C = _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
        ["来源"] = _____72B6_6001["上下文"]["Boss单位"],
        ["目标"] = target,
        ["技能ID"] = _____51A5_4E4B_5FF5_6B32_6280_80FDID,
        ["伤害公式"] = {["目标最大生命比例"] = _____76EE_6807_6700_5927_751F_547D_6BD4_4F8B, ["来源攻击力比例"] = ____Boss_653B_51FB_529B_6BD4_4F8B},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = _____914D_7F6E["伤害标签"]
    })
    return _____7ED3_679C["是否造成伤害"]
end
local function ____on_51A5_4E4B_5FF5_6B32_7ED3_7B97(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(boss) then
        _____7ED3_675F_51A5_4E4B_5FF5_6B32(_____72B6_6001, "Boss失效")
        return
    end
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥之念欲"]
    EC_CreateEffect(
        _____914D_7F6E["结算特效路径"],
        _____72B6_6001["Boss快照X"],
        _____72B6_6001["Boss快照Y"],
        0,
        0,
        _____914D_7F6E["结算特效缩放"],
        1,
        1
    )
    local _____76EE_6807_5217_8868 = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local _____8FDD_89C4_6570 = 0
    local _____547D_4E2D_6570 = 0
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            do
                local target = _____76EE_6807_5217_8868[i + 1]
                if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(target) or not _____76EE_6807_8FDD_53CD_51A5_5FF5_89C4_5219(_____72B6_6001, target) then
                    goto __continue28
                end
                _____8FDD_89C4_6570 = _____8FDD_89C4_6570 + 1
                if _____7ED3_7B97_51A5_4E4B_5FF5_4F24_5BB3(_____72B6_6001, target) then
                    _____547D_4E2D_6570 = _____547D_4E2D_6570 + 1
                end
            end
            ::__continue28::
            i = i + 1
        end
    end
    _____7ED3_675F_51A5_4E4B_5FF5_6B32(_____72B6_6001, "规则结算完成")
end
local function _____521B_5EFA_51A5_4E4B_5FF5_9884_8B66(_____72B6_6001)
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥之念欲"]
    if _____72B6_6001["类型"] == "念引" then
        EC_CreateEffect(
            _____914D_7F6E["主提示圈路径"],
            _____72B6_6001["Boss快照X"],
            _____72B6_6001["Boss快照Y"],
            0,
            _____914D_7F6E["提示圈朝向"],
            _____914D_7F6E["念引主提示圈缩放"],
            _____914D_7F6E["念引主提示圈速度"],
            _____914D_7F6E["念引提示持续秒"]
        )
        EC_CreateEffect(
            _____914D_7F6E["次提示圈路径"],
            _____72B6_6001["Boss快照X"],
            _____72B6_6001["Boss快照Y"],
            0,
            _____914D_7F6E["提示圈朝向"],
            _____914D_7F6E["念引次提示圈缩放"],
            1,
            _____914D_7F6E["念引提示持续秒"]
        )
        EC_CreateEffect(
            _____914D_7F6E["核心特效路径"],
            _____72B6_6001["Boss快照X"],
            _____72B6_6001["Boss快照Y"],
            0,
            _____914D_7F6E["提示圈朝向"],
            _____914D_7F6E["念引核心特效缩放"],
            1,
            _____914D_7F6E["念引提示持续秒"]
        )
        return
    end
    if _____72B6_6001["类型"] == "念退" then
        EC_CreateEffect(
            _____914D_7F6E["主提示圈路径"],
            _____72B6_6001["Boss快照X"],
            _____72B6_6001["Boss快照Y"],
            0,
            _____914D_7F6E["提示圈朝向"],
            _____914D_7F6E["念退主提示圈缩放"],
            _____914D_7F6E["念退主提示圈速度"],
            _____914D_7F6E["念退提示持续秒"]
        )
        EC_CreateEffect(
            _____914D_7F6E["次提示圈路径"],
            _____72B6_6001["Boss快照X"],
            _____72B6_6001["Boss快照Y"],
            0,
            _____914D_7F6E["提示圈朝向"],
            _____914D_7F6E["念退次提示圈缩放"],
            1,
            _____914D_7F6E["念退提示持续秒"]
        )
        return
    end
    EC_CreateEffect(
        _____914D_7F6E["主提示圈路径"],
        _____72B6_6001["Boss快照X"],
        _____72B6_6001["Boss快照Y"],
        0,
        _____914D_7F6E["提示圈朝向"],
        _____914D_7F6E["念赶主提示圈缩放"],
        _____914D_7F6E["念赶主提示圈速度"],
        _____914D_7F6E["念赶主提示持续秒"]
    )
    do
        local i = 0
        while i < #_____72B6_6001["安全点列表"] do
            local point = _____72B6_6001["安全点列表"][i + 1]
            local _____6838_5FC3_6301_7EED_79D2 = i == 0 and _____914D_7F6E["念赶第一安全点核心持续秒"] or _____914D_7F6E["念赶第二安全点核心持续秒"]
            EC_CreateEffect(
                _____914D_7F6E["次提示圈路径"],
                point.X,
                point.Y,
                0,
                _____914D_7F6E["提示圈朝向"],
                _____914D_7F6E["念赶安全点提示圈缩放"],
                1,
                _____914D_7F6E["念赶安全点提示持续秒"]
            )
            EC_CreateEffect(
                _____914D_7F6E["核心特效路径"],
                point.X,
                point.Y,
                0,
                _____914D_7F6E["提示圈朝向"],
                _____914D_7F6E["念赶安全点核心特效缩放"],
                1,
                _____6838_5FC3_6301_7EED_79D2
            )
            i = i + 1
        end
    end
end
local function _____6DFB_52A0_51A5_4E4B_5FF5_8D76_5B89_5168_70B9(_____72B6_6001, _____6700_5C0F_89D2_5EA6, _____6700_5927_89D2_5EA6)
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥之念欲"]
    local _____89D2_5EA6 = GetRandomReal(_____6700_5C0F_89D2_5EA6, _____6700_5927_89D2_5EA6)
    local _____8DDD_79BB = GetRandomReal(_____914D_7F6E["念赶安全区最小距离"], _____914D_7F6E["念赶安全区最大距离"])
    local ____72B6_6001__5B89_5168_70B9_5217_8868_8 = _____72B6_6001["安全点列表"]
    ____72B6_6001__5B89_5168_70B9_5217_8868_8[#____72B6_6001__5B89_5168_70B9_5217_8868_8 + 1] = {
        X = _____6781_5750_6807X(_____72B6_6001["Boss快照X"], _____89D2_5EA6, _____8DDD_79BB),
        Y = _____6781_5750_6807Y(_____72B6_6001["Boss快照Y"], _____89D2_5EA6, _____8DDD_79BB)
    }
end
local function _____542F_52A8_51A5_4E4B_5FF5_6B32_673A_5236(_____4E0A_4E0B_6587, _____6307_5B9A_7C7B_578B)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(boss) or _____4E0A_4E0B_6587["冥之念欲状态"] ~= nil then
        return false
    end
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["冥之念欲"]
    local roll = GetRandomInt(1, 3)
    local _____7C7B_578B = _____6307_5B9A_7C7B_578B or (roll == 1 and "念引" or (roll == 2 and "念退" or "念赶"))
    local _____72B6_6001 = {
        ["已结束"] = false,
        ["上下文"] = _____4E0A_4E0B_6587,
        ["类型"] = _____7C7B_578B,
        ["Boss快照X"] = GetUnitX(boss),
        ["Boss快照Y"] = GetUnitY(boss),
        ["安全点列表"] = {},
        ["Buff目标列表"] = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    }
    if _____7C7B_578B == "念赶" then
        _____6DFB_52A0_51A5_4E4B_5FF5_8D76_5B89_5168_70B9(_____72B6_6001, _____914D_7F6E["念赶第一安全区角度最小"], _____914D_7F6E["念赶第一安全区角度最大"])
        _____6DFB_52A0_51A5_4E4B_5FF5_8D76_5B89_5168_70B9(_____72B6_6001, _____914D_7F6E["念赶第二安全区角度最小"], _____914D_7F6E["念赶第二安全区角度最大"])
    end
    _____4E0A_4E0B_6587["冥之念欲状态"] = _____72B6_6001
    local ____self_11 = _____4E0A_4E0B_6587["清理"]
    ____self_11["登记清理"](____self_11, "教派学者-冥之念欲清理", ____on_51A5_4E4B_5FF5_6B32_6E05_7406, _____72B6_6001)
    local _____79FB_9664_91CF = _____6309_6BD4_4F8B_79FB_9664_6700_5927_751F_547D(boss, _____914D_7F6E["自损最大生命比例"], true)
    EC_CreateEffect(
        _____914D_7F6E["自损特效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        0,
        _____914D_7F6E["自损特效缩放"],
        1,
        1
    )
    local buffID = _____53D6_5F97_51A5_4E4B_5FF5BuffID(_____7C7B_578B)
    do
        local i = 0
        while i < #_____72B6_6001["Buff目标列表"] do
            do
                local target = _____72B6_6001["Buff目标列表"][i + 1]
                if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(target) then
                    goto __continue41
                end
                registerManualBuff(
                    target,
                    buffID,
                    _____914D_7F6E["等待秒"],
                    0,
                    {sourceUnit = boss, effectSourceName = "冥之念" .. _____7C7B_578B, effectSourceType = "技能"}
                )
            end
            ::__continue41::
            i = i + 1
        end
    end
    _____521B_5EFA_51A5_4E4B_5FF5_9884_8B66(_____72B6_6001)
    local _____56DE_8C03ID = addDelayedCallback(_____914D_7F6E["等待秒"] * 1000, ____on_51A5_4E4B_5FF5_6B32_7ED3_7B97, _____72B6_6001)
    local ____self_12 = _____4E0A_4E0B_6587["清理"]
    ____self_12["登记延迟回调"](____self_12, "教派学者-冥之念欲结算", _____56DE_8C03ID)
    return true
end
local function ____on_51A5_4E4B_5FF5_6B32_5EF6_8FDF_542F_52A8(variable)
    local _____8BF7_6C42 = variable
    if _____8BF7_6C42 ~= nil then
        _____542F_52A8_51A5_4E4B_5FF5_6B32_673A_5236(_____8BF7_6C42["上下文"], _____8BF7_6C42["指定类型"])
    end
end
____exports["释放教派学者冥之念欲"] = function(_____4E0A_4E0B_6587, _____6307_5B9A_7C7B_578B)
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]) or _____4E0A_4E0B_6587["冥之念欲状态"] ~= nil then
        return false
    end
    _____5F00_59CB_51A5_4E4B_5FF5_6B32_65BD_6CD5_8868_73B0(_____4E0A_4E0B_6587)
    local _____56DE_8C03ID = addDelayedCallback(_____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["通魔施法秒"] * 1000, ____on_51A5_4E4B_5FF5_6B32_5EF6_8FDF_542F_52A8, {["上下文"] = _____4E0A_4E0B_6587, ["指定类型"] = _____6307_5B9A_7C7B_578B})
    local ____self_15 = _____4E0A_4E0B_6587["清理"]
    ____self_15["登记延迟回调"](____self_15, "教派学者-冥之念欲显式释放", _____56DE_8C03ID)
    return true
end
____exports["注册教派学者冥之念欲"] = function()
    if _____51A5_4E4B_5FF5_6B32_5DF2_6CE8_518C then
        return
    end
    _____51A5_4E4B_5FF5_6B32_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "教派学者-冥之念欲",
        ["单位类型ID"] = _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["单位ID"],
        ["技能ID"] = _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["冥之念欲"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587,
        ["释放技能"] = function(_____4E0A_4E0B_6587)
            ____exports["释放教派学者冥之念欲"](_____4E0A_4E0B_6587)
        end
    })
end
return ____exports
