local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____64AD_653ER_97F3_6548, _____76EE_6807_5408_6CD5, _____6E05_7406R_58F3, _____6E05_7406R_72B6_6001, _____8BB0_5F55R_76EE_6807, ____R_6E05_7406_8868_73B0_5355_4F4D, ____R_64AD_653E_521D_6BB5_76EE_6807_8868_73B0, ____R_4E8C_6BB5_7A97_53E3_8D85_65F6, ____R_4E8C_6BB5_8FDE_51FB_6536_5C3E_8D85_65F6, ____R_7ED3_7B97_4E00_5200, ____R_7B2C_4E8C_5200, ____R_7B2C_4E00_5200, ____R_4E09_6BB5_4E0B_964DTick, ____R_4E09_6BB5_4E0B_964DTick_5305_88C5, ____R_4E09_6BB5_51B2_51FB_5F00_59CB, ____R_4E09_6BB5_76EE_6807_6062_590D, ____R_4E09_6BB5_76EE_6807_5012_5730_51BB_7ED3, ____R_4E09_6BB5_76EE_6807_6B7B_4EA1_52A8_4F5C, ____R_4E09_6BB5_4F24_5BB3_7ED3_7B97, addDelayedCallback, addPeriodicCallback, removePeriodicCallback, _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3, _____505C_6B62_4F4D_79FB, _____65BD_52A0_7729_6655, _____83B7_53D6_8303_56F4_654C_519B, _____521B_5EFA_70B9_7279_6548, _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548, _____79FB_9664_5355_4F4D_6682_505C, _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6, _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0, debugLogForce, _____6A21_5757_540D, jglobals, PlaySoundOnUnitBJ, _____83B7_53D6_53E5_67C4ID, _____83B7_53D6_5355_4F4DX, _____83B7_53D6_5355_4F4DY, _____83B7_53D6_5355_4F4D_62E5_6709_8005, _____8BBE_7F6E_6280_80FD_53EF_7528, _____8BBE_7F6E_52A8_4F5C, _____8BBE_7F6E_52A8_4F5C_540D, _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6, _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6, _____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6, _____8BBE_7F6E_5355_4F4D_79FB_52A8_901F_5EA6, _____83B7_53D6_5355_4F4D_9ED8_8BA4_79FB_52A8_901F_5EA6, _____8BBE_7F6E_65F6_95F4_6D41_901F, _____6DFB_52A0_6280_80FD, _____79FB_9664_6280_80FD, _____5224_65AD_654C_4EBA, _____5224_65AD_7C7B_578B, _____53E4_6811_7C7B_578B, _____673A_68B0_7C7B_578B, _____653B_51FB_7C7B_578B, _____7269_7406_4F24_5BB3_7C7B_578B, _____9B54_6CD5_4F24_5BB3_7C7B_578B, _____914D_7F6E, _____521D_6BB5_6280_80FDID, _____4E8C_6BB5_6280_80FDID, _____4E09_6BB5_6280_80FDID, _____6682_505C_6765_6E90, _____72B6_6001_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.01．克劳德.00．配置")
local _____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["克劳德单位技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
function _____64AD_653ER_97F3_6548(caster, key)
    local sound = jglobals[key]
    if sound ~= nil then
        PlaySoundOnUnitBJ(sound, 100, caster)
    end
end
function _____76EE_6807_5408_6CD5(caster, target)
    return target ~= nil and target ~= 0 and target ~= caster and _____5355_4F4D_5B58_6D3B(target) and _____5224_65AD_654C_4EBA(
        target,
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster)
    ) and not _____5224_65AD_7C7B_578B(target, _____53E4_6811_7C7B_578B) and not _____5224_65AD_7C7B_578B(target, _____673A_68B0_7C7B_578B)
end
function _____6E05_7406R_58F3(caster)
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____521D_6BB5_6280_80FDID,
        true
    )
    _____79FB_9664_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
    _____79FB_9664_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
end
function _____6E05_7406R_72B6_6001(state, _____6062_590D_76EE_6807)
    if _____6062_590D_76EE_6807 == nil then
        _____6062_590D_76EE_6807 = true
    end
    local caster = state["施法者"]
    debugLogForce(
        _____6A21_5757_540D,
        "清理R状态",
        "施法者",
        (caster == nil or caster == 0) and "nil" or _____83B7_53D6_53E5_67C4ID(caster),
        "阶段",
        state["阶段"],
        "位移ID",
        state["位移ID"],
        "连击次数",
        state["连击次数"]
    )
    if state["位移ID"] ~= 0 then
        _____505C_6B62_4F4D_79FB(state["位移ID"], "中断")
        state["位移ID"] = 0
    end
    if caster ~= nil and caster ~= 0 then
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(caster, _____914D_7F6E["初段冲锋叠加特效键"])
    end
    if state["三段下降回调ID"] ~= 0 then
        removePeriodicCallback(state["三段下降回调ID"])
        state["三段下降回调ID"] = 0
    end
    if caster ~= nil and caster ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(caster, _____6682_505C_6765_6E90)
        _____6E05_7406R_58F3(caster)
        _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, 1)
        local _____5F53_524D_98DE_884C_9AD8_5EA6 = _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(caster)
        local _____9ED8_8BA4_98DE_884C_9AD8_5EA6 = _____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6(caster)
        _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(caster)
        _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(caster, _____9ED8_8BA4_98DE_884C_9AD8_5EA6, 0)
        debugLogForce(
            _____6A21_5757_540D,
            "清理R状态 恢复施法者飞行高度",
            "施法者",
            _____83B7_53D6_53E5_67C4ID(caster),
            "原高度",
            _____5F53_524D_98DE_884C_9AD8_5EA6,
            "默认高度",
            _____9ED8_8BA4_98DE_884C_9AD8_5EA6
        )
    end
    if _____6062_590D_76EE_6807 then
        for ____, target in ipairs(state["连击目标"]) do
            if _____76EE_6807_5408_6CD5(caster, target) then
                _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
                    target,
                    _____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6(target),
                    0
                )
                _____8BBE_7F6E_65F6_95F4_6D41_901F(target, 1)
                _____8BBE_7F6E_52A8_4F5C(target, 0)
            end
        end
    end
    state["进行中"] = false
    state["等待输入"] = false
    state["阶段"] = 0
    state["连击次数"] = 0
    state["连击目标"] = {}
    state["三段下降Tick"] = 0
    state["技能实例ID"] = nil
    if caster ~= nil and caster ~= 0 then
        local id = _____83B7_53D6_53E5_67C4ID(caster)
        if _____72B6_6001_8868[id] == state then
            __TS__Delete(_____72B6_6001_8868, id)
        end
    end
end
function _____8BB0_5F55R_76EE_6807(state, target)
    local id = _____83B7_53D6_53E5_67C4ID(target)
    for ____, oldTarget in ipairs(state["连击目标"]) do
        if _____83B7_53D6_53E5_67C4ID(oldTarget) == id then
            return
        end
    end
    local ____state__8FDE_51FB_76EE_6807_15 = state["连击目标"]
    ____state__8FDE_51FB_76EE_6807_15[#____state__8FDE_51FB_76EE_6807_15 + 1] = target
end
function ____R_6E05_7406_8868_73B0_5355_4F4D(variable)
    local visual = variable
    if visual ~= nil and visual ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(visual)
    end
end
function ____R_64AD_653E_521D_6BB5_76EE_6807_8868_73B0(state, target)
    local caster = state["施法者"]
    local x = _____83B7_53D6_5355_4F4DX(target)
    local y = _____83B7_53D6_5355_4F4DY(target)
    local z = _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(target)
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(target)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["初段斩杀模型"],
        X = x,
        Y = y,
        Z = z + 100,
        ["缩放"] = _____914D_7F6E["初段斩杀缩放"],
        ["持续秒"] = 2
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["初段雷霆模型"],
        X = x,
        Y = y,
        Z = z,
        ["缩放"] = _____914D_7F6E["初段雷霆缩放"],
        ["持续秒"] = 1
    })
    _____8BBE_7F6E_52A8_4F5C_540D(target, "Death")
    _____65BD_52A0_7729_6655(
        caster,
        target,
        _____914D_7F6E["初段控制秒"],
        "克劳德-R-初段硬直",
        "技能"
    )
end
function ____R_4E8C_6BB5_7A97_53E3_8D85_65F6(state)
    debugLogForce(
        _____6A21_5757_540D,
        "R二段窗口超时",
        "进行中",
        state and state["进行中"],
        "等待输入",
        state and state["等待输入"],
        "阶段",
        state and state["阶段"],
        "连击次数",
        state and state["连击次数"]
    )
    if state == nil or not state["进行中"] or state["阶段"] ~= 1 then
        return
    end
    if state["连击次数"] <= 0 then
        _____6E05_7406R_72B6_6001(state)
        return
    end
    addDelayedCallback(_____914D_7F6E["二段连击收尾超时秒"] * 1000, ____R_4E8C_6BB5_8FDE_51FB_6536_5C3E_8D85_65F6, state)
end
function ____R_4E8C_6BB5_8FDE_51FB_6536_5C3E_8D85_65F6(state)
    debugLogForce(
        _____6A21_5757_540D,
        "R二段连击收尾超时",
        "进行中",
        state and state["进行中"],
        "阶段",
        state and state["阶段"],
        "连击次数",
        state and state["连击次数"]
    )
    if state ~= nil and state["进行中"] and state["阶段"] == 1 and state["连击次数"] < _____914D_7F6E["二段最大次数"] then
        _____6E05_7406R_72B6_6001(state)
    end
end
function ____R_7ED3_7B97_4E00_5200(state)
    local caster = state["施法者"]
    local targets = _____83B7_53D6_8303_56F4_654C_519B(
        caster,
        _____83B7_53D6_5355_4F4DX(caster),
        _____83B7_53D6_5355_4F4DY(caster),
        _____914D_7F6E["初段范围"]
    )
    local validTargets = {}
    for ____, target in ipairs(targets) do
        do
            if not _____76EE_6807_5408_6CD5(caster, target) then
                goto __continue42
            end
            validTargets[#validTargets + 1] = target
            _____8BB0_5F55R_76EE_6807(state, target)
            ____R_64AD_653E_521D_6BB5_76EE_6807_8868_73B0(state, target)
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = _____914D_7F6E["斩刀光模型"],
                X = _____83B7_53D6_5355_4F4DX(target),
                Y = _____83B7_53D6_5355_4F4DY(target),
                Z = _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(target),
                ["面向角度"] = state["方向角"],
                ["缩放"] = 2,
                ["持续秒"] = 0.8
            })
        end
        ::__continue42::
    end
    debugLogForce(_____6A21_5757_540D, "R结算一刀 范围结算", "范围敌军", #validTargets)
    if #validTargets == 0 then
        return
    end
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = validTargets,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E["初段伤害倍率"],
        ["伤害类型"] = _____7269_7406_4F24_5BB3_7C7B_578B,
        attack = true,
        ranged = false,
        attackType = _____653B_51FB_7C7B_578B,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____521D_6BB5_6280_80FDID,
        ["技能实例ID"] = state["技能实例ID"],
        ["标签"] = "克劳德-R-初段范围斩击"
    })
end
function ____R_7B2C_4E8C_5200(variable)
    local state = variable
    if state == nil or not state["进行中"] or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        local ____debugLogForce_45 = debugLogForce
        local ____temp_43 = state ~= nil
        local ____temp_44 = state and state["进行中"]
        local ____temp_42
        if (state and state["施法者"]) == nil then
            ____temp_42 = false
        else
            ____temp_42 = _____5355_4F4D_5B58_6D3B(state["施法者"])
        end
        ____debugLogForce_45(
            _____6A21_5757_540D,
            "R第二刀 前置不满足",
            "状态存在",
            ____temp_43,
            "进行中",
            ____temp_44,
            "施法者存活",
            ____temp_42
        )
        if state ~= nil then
            _____6E05_7406R_72B6_6001(state)
        end
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "R第二刀 结算",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(state["施法者"])
    )
    ____R_7ED3_7B97_4E00_5200(state)
    _____64AD_653ER_97F3_6548(state["施法者"], _____914D_7F6E["初段第二刀音效键"])
    _____8BBE_7F6E_52A8_4F5C(state["施法者"], _____914D_7F6E["初段第二刀动作索引"])
    state["阶段"] = 1
    state["等待输入"] = true
    _____79FB_9664_5355_4F4D_6682_505C(state["施法者"], _____6682_505C_6765_6E90)
    _____8BBE_7F6E_65F6_95F4_6D41_901F(state["施法者"], 1)
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(state["施法者"]),
        _____521D_6BB5_6280_80FDID,
        false
    )
    _____6DFB_52A0_6280_80FD(state["施法者"], _____4E8C_6BB5_6280_80FDID)
    debugLogForce(_____6A21_5757_540D, "R第二刀 完成 等待二段输入")
    addDelayedCallback(_____914D_7F6E["二段窗口秒"] * 1000, ____R_4E8C_6BB5_7A97_53E3_8D85_65F6, state)
end
function ____R_7B2C_4E00_5200(variable)
    local state = variable
    if state == nil or not state["进行中"] or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        local ____debugLogForce_53 = debugLogForce
        local ____temp_51 = state ~= nil
        local ____temp_52 = state and state["进行中"]
        local ____temp_50
        if (state and state["施法者"]) == nil then
            ____temp_50 = false
        else
            ____temp_50 = _____5355_4F4D_5B58_6D3B(state["施法者"])
        end
        ____debugLogForce_53(
            _____6A21_5757_540D,
            "R第一刀 前置不满足",
            "状态存在",
            ____temp_51,
            "进行中",
            ____temp_52,
            "施法者存活",
            ____temp_50
        )
        if state ~= nil then
            _____6E05_7406R_72B6_6001(state)
        end
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "R第一刀 结算",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(state["施法者"])
    )
    _____8BBE_7F6E_52A8_4F5C(state["施法者"], _____914D_7F6E["初段动作索引"])
    _____8BBE_7F6E_65F6_95F4_6D41_901F(state["施法者"], _____914D_7F6E["动作时间流速"])
    ____R_7ED3_7B97_4E00_5200(state)
    _____64AD_653ER_97F3_6548(state["施法者"], _____914D_7F6E["初段第一刀音效键"])
    addDelayedCallback(_____914D_7F6E["第二刀延迟秒"] * 1000, ____R_7B2C_4E8C_5200, state)
end
function ____R_4E09_6BB5_4E0B_964DTick(state)
    if not state["进行中"] or state["阶段"] ~= 2 or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        if state["三段下降回调ID"] ~= 0 then
            removePeriodicCallback(state["三段下降回调ID"])
        end
        state["三段下降回调ID"] = 0
        if state["进行中"] then
            _____6E05_7406R_72B6_6001(state)
        end
        return
    end
    state["三段下降Tick"] = state["三段下降Tick"] + 1
    for ____, target in ipairs(state["连击目标"]) do
        if _____76EE_6807_5408_6CD5(state["施法者"], target) then
            _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
                target,
                _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(target) - _____914D_7F6E["三段每Tick下降高度"],
                0
            )
        end
    end
    if state["三段下降Tick"] < _____914D_7F6E["三段下降Tick数"] then
        return
    end
    removePeriodicCallback(state["三段下降回调ID"])
    state["三段下降回调ID"] = 0
    ____R_4E09_6BB5_4F24_5BB3_7ED3_7B97(state)
end
function ____R_4E09_6BB5_4E0B_964DTick_5305_88C5()
    for key in pairs(_____72B6_6001_8868) do
        local state = _____72B6_6001_8868[__TS__Number(key)]
        if state ~= nil and state["三段下降回调ID"] ~= 0 then
            ____R_4E09_6BB5_4E0B_964DTick(state)
        end
    end
end
function ____R_4E09_6BB5_51B2_51FB_5F00_59CB(variable)
    local state = variable
    if state == nil or not state["进行中"] or state["阶段"] ~= 2 or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        if state ~= nil then
            _____6E05_7406R_72B6_6001(state)
        end
        return
    end
    local caster = state["施法者"]
    _____79FB_9664_5355_4F4D_6682_505C(caster, _____6682_505C_6765_6E90)
    _____8BBE_7F6E_5355_4F4D_79FB_52A8_901F_5EA6(
        caster,
        _____83B7_53D6_5355_4F4D_9ED8_8BA4_79FB_52A8_901F_5EA6(caster)
    )
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____521D_6BB5_6280_80FDID,
        true
    )
    _____79FB_9664_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
    _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
        caster,
        _____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6(caster),
        0
    )
    local target = state["终结目标"]
    local targetX = target ~= nil and target ~= 0 and _____83B7_53D6_5355_4F4DX(target) or state["终结目标X"]
    local targetY = target ~= nil and target ~= 0 and _____83B7_53D6_5355_4F4DY(target) or state["终结目标Y"]
    local casterHeight = _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(caster)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["三段冲击模型"],
        X = targetX,
        Y = targetY,
        Z = casterHeight - 350,
        ["缩放"] = _____914D_7F6E["三段冲击缩放"],
        ["持续秒"] = 2
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["三段践踏模型"],
        X = targetX,
        Y = targetY,
        Z = casterHeight,
        ["缩放"] = _____914D_7F6E["三段践踏缩放"],
        ["持续秒"] = 1
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["三段爆炸模型"],
        X = targetX,
        Y = targetY,
        Z = casterHeight,
        ["持续秒"] = 1
    })
    state["三段下降Tick"] = 0
    state["三段下降回调ID"] = addPeriodicCallback(_____914D_7F6E["三段下降间隔秒"] * 1000, ____R_4E09_6BB5_4E0B_964DTick_5305_88C5)
end
function ____R_4E09_6BB5_76EE_6807_6062_590D(variable)
    local target = variable
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
        target,
        _____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6(target),
        0
    )
    _____8BBE_7F6E_65F6_95F4_6D41_901F(target, 1)
    _____8BBE_7F6E_52A8_4F5C(target, 0)
end
function ____R_4E09_6BB5_76EE_6807_5012_5730_51BB_7ED3(variable)
    local target = variable
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____8BBE_7F6E_65F6_95F4_6D41_901F(target, 0)
    addDelayedCallback(_____914D_7F6E["三段倒地恢复秒"] * 1000, ____R_4E09_6BB5_76EE_6807_6062_590D, target)
end
function ____R_4E09_6BB5_76EE_6807_6B7B_4EA1_52A8_4F5C(variable)
    local target = variable
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____8BBE_7F6E_65F6_95F4_6D41_901F(target, _____914D_7F6E["三段目标动作速度"])
    _____8BBE_7F6E_52A8_4F5C_540D(target, "Death")
    addDelayedCallback(450, ____R_4E09_6BB5_76EE_6807_5012_5730_51BB_7ED3, target)
end
function ____R_4E09_6BB5_4F24_5BB3_7ED3_7B97(state)
    local caster = state["施法者"]
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____521D_6BB5_6280_80FDID,
        true
    )
    _____79FB_9664_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
    _____79FB_9664_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
    local validTargets = {}
    for ____, target in ipairs(state["连击目标"]) do
        do
            if not _____76EE_6807_5408_6CD5(caster, target) then
                goto __continue99
            end
            validTargets[#validTargets + 1] = target
            _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
                target,
                _____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6(target),
                0
            )
            _____65BD_52A0_7729_6655(
                caster,
                target,
                _____914D_7F6E["三段目标控制秒"],
                "克劳德-R-终结控制",
                "技能"
            )
            addDelayedCallback(_____914D_7F6E["三段死亡动作延迟秒"] * 1000, ____R_4E09_6BB5_76EE_6807_6B7B_4EA1_52A8_4F5C, target)
        end
        ::__continue99::
    end
    if #validTargets > 0 then
        _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标列表"] = validTargets,
            ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E["三段伤害倍率"],
            ["伤害类型"] = _____9B54_6CD5_4F24_5BB3_7C7B_578B,
            attack = true,
            ranged = false,
            attackType = _____653B_51FB_7C7B_578B,
            ["来源类型"] = "单位技能",
            ["技能ID"] = _____521D_6BB5_6280_80FDID,
            ["技能实例ID"] = state["技能实例ID"],
            ["标签"] = "克劳德-R-终结下劈"
        })
    end
    _____6E05_7406R_72B6_6001(state, false)
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_1["减少魔法值"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
_____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成批量AOE技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_3["开始冲锋"]
_____505C_6B62_4F4D_79FB = ____require_result_3["停止位移"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
_____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____83B7_53D6_8303_56F4_654C_519B = ____require_result_5["获取范围敌军"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_6["创建单位坐标跟随特效"]
_____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_6["销毁单位坐标跟随特效"]
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_7["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_7["移除单位暂停"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
_____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6 = ____require_result_8["确保单位可设置飞行高度"]
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_9["创建单位并登记排泄安全"]
local ____require_result_10 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
_____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_10["立即移除单位并取消排泄登记"]
local ____require_result_11 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_11.registerDeathListener
local ____require_result_12 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_12.stringToFourCCSafe
local ____require_result_13 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_13.debugLogForce
_____6A21_5757_540D = "克劳德-R"
jglobals = require("jass.globals")
local ____require_result_14 = require("lib.扩展函数.BJ函数.14．音效函数")
PlaySoundOnUnitBJ = ____require_result_14.PlaySoundOnUnitBJ
_____83B7_53D6_53E5_67C4ID = jass.GetHandleId
local _____83B7_53D6_5355_4F4D_7C7B_578BID = jass.GetUnitTypeId
_____83B7_53D6_5355_4F4DX = jass.GetUnitX
_____83B7_53D6_5355_4F4DY = jass.GetUnitY
local _____83B7_53D6_6280_80FD_76EE_6807X = jass.GetSpellTargetX
local _____83B7_53D6_6280_80FD_76EE_6807Y = jass.GetSpellTargetY
local _____83B7_53D6_6280_80FD_76EE_6807_5355_4F4D = jass.GetSpellTargetUnit
_____83B7_53D6_5355_4F4D_62E5_6709_8005 = jass.GetOwningPlayer
local _____83B7_53D6_5355_4F4D_72B6_6001 = jass.GetUnitState
_____8BBE_7F6E_6280_80FD_53EF_7528 = jass.SetPlayerAbilityAvailable
_____8BBE_7F6E_52A8_4F5C = jass.SetUnitAnimationByIndex
_____8BBE_7F6E_52A8_4F5C_540D = jass.SetUnitAnimation
_____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6 = jass.SetUnitFlyHeight
_____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6 = jass.GetUnitFlyHeight
_____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6 = jass.GetUnitDefaultFlyHeight
_____8BBE_7F6E_5355_4F4D_79FB_52A8_901F_5EA6 = jass.SetUnitMoveSpeed
_____83B7_53D6_5355_4F4D_9ED8_8BA4_79FB_52A8_901F_5EA6 = jass.GetUnitDefaultMoveSpeed
_____8BBE_7F6E_65F6_95F4_6D41_901F = jass.SetUnitTimeScale
_____6DFB_52A0_6280_80FD = jass.UnitAddAbility
_____79FB_9664_6280_80FD = jass.UnitRemoveAbility
_____5224_65AD_654C_4EBA = jass.IsUnitEnemy
_____5224_65AD_7C7B_578B = jass.IsUnitType
local _____8BA1_7B97_53CD_6B63_5207 = jass.Atan2
local _____8BA1_7B97_5E73_65B9_6839 = jass.SquareRoot
local _____5F27_5EA6_8F6C_89D2_5EA6 = jass.bj_RADTODEG
_____53E4_6811_7C7B_578B = jass.UNIT_TYPE_ANCIENT
_____673A_68B0_7C7B_578B = jass.UNIT_TYPE_MECHANICAL
local _____6700_5927_9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MAX_MANA
local _____5F53_524D_9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MANA
_____653B_51FB_7C7B_578B = jass.ATTACK_TYPE_NORMAL
_____7269_7406_4F24_5BB3_7C7B_578B = jass.DAMAGE_TYPE_NORMAL
_____9B54_6CD5_4F24_5BB3_7C7B_578B = jass.DAMAGE_TYPE_MAGIC
_____914D_7F6E = _____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E.R
local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____521D_6BB5_6280_80FDID = stringToFourCCSafe(_____914D_7F6E["初段技能ID"])
_____4E8C_6BB5_6280_80FDID = stringToFourCCSafe(_____914D_7F6E["二段技能ID"])
_____4E09_6BB5_6280_80FDID = stringToFourCCSafe(_____914D_7F6E["三段技能ID"])
_____6682_505C_6765_6E90 = "克劳德-R-自身"
_____72B6_6001_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAR_72B6_6001(unit)
    local id = _____83B7_53D6_53E5_67C4ID(unit)
    local state = _____72B6_6001_8868[id]
    if state == nil then
        state = {
            ["施法者"] = unit,
            ["目标单位"] = nil,
            ["目标X"] = 0,
            ["目标Y"] = 0,
            ["终结目标"] = nil,
            ["终结目标X"] = 0,
            ["终结目标Y"] = 0,
            ["方向角"] = 0,
            ["进行中"] = false,
            ["阶段"] = 0,
            ["等待输入"] = false,
            ["连击次数"] = 0,
            ["位移ID"] = 0,
            ["接近距离"] = 0,
            ["连击目标"] = {},
            ["三段下降Tick"] = 0,
            ["三段下降回调ID"] = 0
        }
        _____72B6_6001_8868[id] = state
    end
    return state
end
local function _____521B_5EFAR_8868_73B0_5355_4F4D(caster, unitTypeText, x, y, z, lifeSec, deathAnimation)
    if deathAnimation == nil then
        deathAnimation = false
    end
    local unitTypeId = stringToFourCCSafe(unitTypeText)
    local visual = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        unitTypeId,
        x,
        y,
        0
    )
    if visual == nil or visual == 0 then
        return
    end
    _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(visual, z, 0)
    if deathAnimation then
        _____8BBE_7F6E_52A8_4F5C_540D(visual, "Death")
    end
    addDelayedCallback(lifeSec * 1000, ____R_6E05_7406_8868_73B0_5355_4F4D, visual)
end
local function ____R_4E09_6BB5_7A97_53E3_8D85_65F6(state)
    debugLogForce(
        _____6A21_5757_540D,
        "R三段窗口超时",
        "进行中",
        state and state["进行中"],
        "等待输入",
        state and state["等待输入"],
        "阶段",
        state and state["阶段"]
    )
    if state ~= nil and state["进行中"] and state["等待输入"] and state["阶段"] == 2 then
        _____6E05_7406R_72B6_6001(state)
    end
end
local function ____R_63A5_8FD1_7ED3_675F(caster, _reason, _moveId)
    local state = _____72B6_6001_8868[_____83B7_53D6_53E5_67C4ID(caster)]
    debugLogForce(
        _____6A21_5757_540D,
        "R接近结束",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "原因",
        _reason,
        "状态存在",
        state ~= nil,
        "进行中",
        state and state["进行中"]
    )
    if state == nil or not state["进行中"] then
        return
    end
    state["位移ID"] = 0
    _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(caster, _____914D_7F6E["初段冲锋叠加特效键"])
    addDelayedCallback(_____914D_7F6E["第一刀延迟秒"] * 1000, ____R_7B2C_4E00_5200, state)
end
local function ____R_63A5_8FD1_542F_52A8(state)
    if not state["进行中"] or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        debugLogForce(
            _____6A21_5757_540D,
            "R接近启动 前置不满足 清理",
            "进行中",
            state["进行中"],
            "施法者存活",
            _____5355_4F4D_5B58_6D3B(state["施法者"])
        )
        _____6E05_7406R_72B6_6001(state)
        return
    end
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(state["施法者"])
    _____8BBE_7F6E_52A8_4F5C(state["施法者"], _____914D_7F6E["初段动作索引"])
    _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        state["施法者"],
        _____914D_7F6E["初段冲锋叠加特效模型"],
        _____914D_7F6E["初段冲锋叠加特效键"],
        _____914D_7F6E["初段冲锋叠加特效缩放"],
        _____914D_7F6E["初段冲锋叠加特效高度"],
        nil,
        nil,
        state["方向角"]
    )
    state["位移ID"] = _____5F00_59CB_51B2_950B(state["施法者"], {
        ["角度"] = state["方向角"],
        ["距离"] = state["接近距离"],
        ["持续时间"] = _____914D_7F6E["接近持续秒"],
        ["检查地形"] = true,
        ["朝向跟随位移"] = true,
        ["暂停单位"] = false,
        ["禁用碰撞"] = true,
        ["动画序号"] = 0,
        ["结束回调"] = ____R_63A5_8FD1_7ED3_675F
    })
    debugLogForce(
        _____6A21_5757_540D,
        "R接近启动 冲锋创建",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(state["施法者"]),
        "位移ID",
        state["位移ID"],
        "方向角",
        state["方向角"],
        "接近距离",
        state["接近距离"]
    )
    if state["位移ID"] == 0 then
        ____R_63A5_8FD1_7ED3_675F(state["施法者"], "中断", 0)
    end
end
local function _____6D88_8017R_9B54_6CD5(caster, fixedCost, ratio)
    local maxMana = _____83B7_53D6_5355_4F4D_72B6_6001(caster, _____6700_5927_9B54_6CD5_72B6_6001) or 0
    local cost = fixedCost + maxMana * ratio
    local currentMana = _____83B7_53D6_5355_4F4D_72B6_6001(caster, _____5F53_524D_9B54_6CD5_72B6_6001) or 0
    debugLogForce(
        _____6A21_5757_540D,
        "R魔耗判断",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "固定",
        fixedCost,
        "比例",
        ratio,
        "总需求",
        cost,
        "当前蓝",
        currentMana
    )
    if cost <= 0 or currentMana < cost then
        debugLogForce(
            _____6A21_5757_540D,
            "R魔耗不足 返回false",
            "总需求",
            cost,
            "当前蓝",
            currentMana
        )
        return false
    end
    _____51CF_5C11_9B54_6CD5_503C(caster, cost, false, false)
    return true
end
local function ____R_4E8C_6BB5_547D_4E2D(variable)
    local context = variable
    if context == nil then
        return
    end
    local state = context["状态"]
    if not state["进行中"] or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        return
    end
    local caster = state["施法者"]
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(caster)
    _____8BBE_7F6E_52A8_4F5C(caster, _____914D_7F6E["二段命中动作索引"])
    _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
        caster,
        _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(caster) + 65,
        0
    )
    local validTargets = {}
    for ____, target in ipairs(context["目标列表"]) do
        do
            if not _____76EE_6807_5408_6CD5(caster, target) then
                goto __continue57
            end
            validTargets[#validTargets + 1] = target
            _____8BB0_5F55R_76EE_6807(state, target)
            ____R_64AD_653E_521D_6BB5_76EE_6807_8868_73B0(state, target)
            _____8BBE_7F6E_65F6_95F4_6D41_901F(target, 10)
            _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
                target,
                _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(target) + 65,
                0
            )
        end
        ::__continue57::
    end
    debugLogForce(
        _____6A21_5757_540D,
        "R二段命中",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "连击次数",
        context["连击次数"],
        "目标数",
        #validTargets
    )
    if #validTargets == 0 then
        return
    end
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = validTargets,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E["二段伤害倍率"],
        ["伤害类型"] = _____7269_7406_4F24_5BB3_7C7B_578B,
        attack = true,
        ranged = false,
        attackType = _____653B_51FB_7C7B_578B,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____521D_6BB5_6280_80FDID,
        ["技能实例ID"] = state["技能实例ID"],
        ["标签"] = "克劳德-R-旋风斩"
    })
end
local function _____91CA_653ER_521D_6BB5(state, caster, skillInstanceId)
    debugLogForce(
        _____6A21_5757_540D,
        "释放R初段 进入",
        "施法者",
        caster == nil and "nil" or _____83B7_53D6_53E5_67C4ID(caster),
        "已在进行",
        state["进行中"],
        "技能实例ID",
        skillInstanceId
    )
    if state["进行中"] then
        return
    end
    state["施法者"] = caster
    state["进行中"] = true
    state["阶段"] = 0
    state["等待输入"] = false
    state["连击次数"] = 0
    state["连击目标"] = {}
    state["三段下降Tick"] = 0
    state["三段下降回调ID"] = 0
    state["技能实例ID"] = skillInstanceId
    state["目标单位"] = _____83B7_53D6_6280_80FD_76EE_6807_5355_4F4D()
    state["目标X"] = _____83B7_53D6_6280_80FD_76EE_6807X()
    state["目标Y"] = _____83B7_53D6_6280_80FD_76EE_6807Y()
    local dx = state["目标X"] - _____83B7_53D6_5355_4F4DX(caster)
    local dy = state["目标Y"] - _____83B7_53D6_5355_4F4DY(caster)
    state["方向角"] = _____8BA1_7B97_53CD_6B63_5207(dy, dx) * _____5F27_5EA6_8F6C_89D2_5EA6
    local distance = _____8BA1_7B97_5E73_65B9_6839(dx * dx + dy * dy)
    state["接近距离"] = distance > _____914D_7F6E["接近距离"] and _____914D_7F6E["接近距离"] or distance
    if _____76EE_6807_5408_6CD5(caster, state["目标单位"]) then
        state["目标X"] = _____83B7_53D6_5355_4F4DX(state["目标单位"])
        state["目标Y"] = _____83B7_53D6_5355_4F4DY(state["目标单位"])
    else
        state["目标单位"] = nil
    end
    debugLogForce(
        _____6A21_5757_540D,
        "释放R初段 正常路径",
        "目标单位",
        state["目标单位"] == nil and "nil" or _____83B7_53D6_53E5_67C4ID(state["目标单位"]),
        "目标X",
        state["目标X"],
        "目标Y",
        state["目标Y"],
        "方向角",
        state["方向角"],
        "接近距离",
        state["接近距离"]
    )
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____6682_505C_6765_6E90)
    _____8BBE_7F6E_52A8_4F5C(caster, _____914D_7F6E["初段动作索引"])
    _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, _____914D_7F6E["动作时间流速"])
    addDelayedCallback(10, ____R_63A5_8FD1_542F_52A8, state)
end
local function _____91CA_653ER_4E8C_6BB5(state, caster)
    debugLogForce(
        _____6A21_5757_540D,
        "释放R二段 进入",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "进行中",
        state["进行中"],
        "等待输入",
        state["等待输入"],
        "阶段",
        state["阶段"],
        "连击次数",
        state["连击次数"]
    )
    if not state["进行中"] or not state["等待输入"] or state["阶段"] ~= 1 then
        return
    end
    if not _____6D88_8017R_9B54_6CD5(caster, _____914D_7F6E["二段代码追加固定魔耗"], _____914D_7F6E["二段最大魔法消耗比例"]) then
        return
    end
    state["连击次数"] = state["连击次数"] + 1
    if state["连击次数"] == 1 then
        _____64AD_653ER_97F3_6548(caster, _____914D_7F6E["二段音效键"])
    end
    local x = _____83B7_53D6_5355_4F4DX(caster)
    local y = _____83B7_53D6_5355_4F4DY(caster)
    local targets = _____83B7_53D6_8303_56F4_654C_519B(caster, x, y, _____914D_7F6E["二段范围"])
    local validTargets = {}
    for ____, target in ipairs(targets) do
        if _____76EE_6807_5408_6CD5(caster, target) then
            validTargets[#validTargets + 1] = target
        end
    end
    if state["连击次数"] > 3 then
        _____521B_5EFAR_8868_73B0_5355_4F4D(
            caster,
            _____914D_7F6E["二段旋风单位ID"],
            x,
            y,
            _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(caster) + _____914D_7F6E["二段特效高度"],
            _____914D_7F6E["二段旋风持续秒"]
        )
    end
    _____521B_5EFAR_8868_73B0_5355_4F4D(
        caster,
        _____914D_7F6E["二段能量单位ID"],
        x,
        y,
        _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(caster) + _____914D_7F6E["二段特效高度"],
        _____914D_7F6E["二段能量持续秒"],
        true
    )
    _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, _____914D_7F6E["二段动作时间流速"])
    addDelayedCallback(250, ____R_4E8C_6BB5_547D_4E2D, {["状态"] = state, ["连击次数"] = state["连击次数"], ["目标列表"] = validTargets})
    if state["连击次数"] >= _____914D_7F6E["二段最大次数"] then
        state["阶段"] = 2
        _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, 1)
        _____8BBE_7F6E_5355_4F4D_79FB_52A8_901F_5EA6(
            caster,
            _____83B7_53D6_5355_4F4D_9ED8_8BA4_79FB_52A8_901F_5EA6(caster)
        )
        _____79FB_9664_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
        _____6DFB_52A0_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
        _____8BBE_7F6E_6280_80FD_53EF_7528(
            _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
            _____4E09_6BB5_6280_80FDID,
            true
        )
        state["等待输入"] = true
        debugLogForce(_____6A21_5757_540D, "释放R二段 达到最大次数 进入阶段2", "连击次数", state["连击次数"])
        addDelayedCallback(_____914D_7F6E["三段窗口秒"] * 1000, ____R_4E09_6BB5_7A97_53E3_8D85_65F6, state)
        return
    end
    state["等待输入"] = true
end
local function ____R_4E09_6BB5_8868_73B0_5F00_59CB(variable)
    local state = variable
    if state == nil or not state["进行中"] or state["阶段"] ~= 2 or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        if state ~= nil then
            _____6E05_7406R_72B6_6001(state)
        end
        return
    end
    local caster = state["施法者"]
    _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, 1)
    _____8BBE_7F6E_52A8_4F5C(caster, _____914D_7F6E["终结动作索引"])
    _____64AD_653ER_97F3_6548(caster, _____914D_7F6E["三段音效键"])
    addDelayedCallback(_____914D_7F6E["三段特效延迟秒"] * 1000, ____R_4E09_6BB5_51B2_51FB_5F00_59CB, state)
end
local function _____91CA_653ER_4E09_6BB5(state, caster)
    debugLogForce(
        _____6A21_5757_540D,
        "释放R三段 进入",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "进行中",
        state["进行中"],
        "等待输入",
        state["等待输入"],
        "阶段",
        state["阶段"]
    )
    if not state["进行中"] or not state["等待输入"] or state["阶段"] ~= 2 then
        return
    end
    local target = _____83B7_53D6_6280_80FD_76EE_6807_5355_4F4D()
    debugLogForce(
        _____6A21_5757_540D,
        "释放R三段 目标",
        "目标",
        target == nil and "nil" or _____83B7_53D6_53E5_67C4ID(target),
        "目标合法",
        _____76EE_6807_5408_6CD5(caster, target)
    )
    if not _____76EE_6807_5408_6CD5(caster, target) then
        _____6E05_7406R_72B6_6001(state)
        return
    end
    if not _____6D88_8017R_9B54_6CD5(caster, _____914D_7F6E["三段代码追加固定魔耗"], _____914D_7F6E["三段最大魔法消耗比例"]) then
        return
    end
    state["等待输入"] = false
    state["终结目标"] = target
    state["终结目标X"] = _____83B7_53D6_5355_4F4DX(target)
    state["终结目标Y"] = _____83B7_53D6_5355_4F4DY(target)
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____6682_505C_6765_6E90)
    addDelayedCallback(10, ____R_4E09_6BB5_8868_73B0_5F00_59CB, state)
end
local function ____R_521D_6BB5_53EF_91CA_653E(state, _caster)
    return not state["进行中"]
end
local function ____R_4E8C_6BB5_53EF_91CA_653E(state, _caster)
    return state["进行中"] and state["等待输入"] and state["阶段"] == 1
end
local function ____R_4E09_6BB5_53EF_91CA_653E(state, _caster)
    return state["进行中"] and state["等待输入"] and state["阶段"] == 2
end
local function _____514B_52B3_5FB7R_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 or _____83B7_53D6_5355_4F4D_7C7B_578BID(dyingUnit) ~= _____5355_4F4D_7C7B_578BID then
        return
    end
    local state = _____72B6_6001_8868[_____83B7_53D6_53E5_67C4ID(dyingUnit)]
    debugLogForce(
        _____6A21_5757_540D,
        "克劳德R死亡清理",
        "死亡单位",
        _____83B7_53D6_53E5_67C4ID(dyingUnit),
        "状态存在",
        state ~= nil
    )
    if state ~= nil then
        _____6E05_7406R_72B6_6001(state)
    end
end
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "克劳德-画龙点睛一段",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = _____521D_6BB5_6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAR_72B6_6001,
    ["可释放"] = ____R_521D_6BB5_53EF_91CA_653E,
    ["释放技能"] = _____91CA_653ER_521D_6BB5,
    ["创建独立技能实例"] = true,
    ["独立技能来源类型"] = "单位技能",
    ["技能实例持续时间秒"] = 10
})
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "克劳德-画龙点睛二段",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = _____4E8C_6BB5_6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAR_72B6_6001,
    ["可释放"] = ____R_4E8C_6BB5_53EF_91CA_653E,
    ["释放技能"] = _____91CA_653ER_4E8C_6BB5,
    ["创建独立技能实例"] = false
})
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "克劳德-画龙点睛三段",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = _____4E09_6BB5_6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAR_72B6_6001,
    ["可释放"] = ____R_4E09_6BB5_53EF_91CA_653E,
    ["释放技能"] = _____91CA_653ER_4E09_6BB5,
    ["创建独立技能实例"] = false
})
registerDeathListener(_____514B_52B3_5FB7R_6B7B_4EA1_6E05_7406)
return ____exports
