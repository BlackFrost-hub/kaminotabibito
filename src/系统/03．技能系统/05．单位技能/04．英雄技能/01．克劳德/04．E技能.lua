local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local ____exports = {}
local _____64AD_653EE_97F3_6548, _____76EE_6807_5408_6CD5, _____76EE_6807_672A_8BB0_5F55, _____6E05_7406E_58F3, _____6E05_7406E_72B6_6001, ____E_7A97_53E3_7ED3_7B97, _____6E05_7406E_5F3A_5316_51FB_98DE_8868_73B0, _____521B_5EFAE_5F3A_5316_51FB_98DE_8868_73B0, ____E_7ED3_7B97_5F53_524D_65A9_51FB, ____E_6267_884C_65A9_51FB, ____E_5F3A_5316_7ED3_675F, ____E_5F3A_5316_8FFD_51FBTick, ____E_5F3A_5316_8FFD_51FB_5EF6_8FDF_542F_52A8, _____542F_52A8E_5F3A_5316_8FFD_51FB, ____E_5F3A_5316_4F24_5BB3_7ED3_7B97, ____E_5F3A_5316_7ED3_7B97, addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback, _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3, _____505C_6B62_4F4D_79FB, _____65BD_52A0_7729_6655, _____521B_5EFA_70B9_7279_6548, _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168, _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0, CreateFloatTextAtPoint, _____6DFB_52A0_5355_4F4D_6682_505C, _____79FB_9664_5355_4F4D_6682_505C, _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6, _____83B7_53D6_8303_56F4_654C_519B, stringToFourCCSafe, debugLogForce, _____6A21_5757_540D, jglobals, PlaySoundOnUnitBJ, GetRandomDirectionDeg, _____83B7_53D6_53E5_67C4ID, _____83B7_53D6_5355_4F4DX, _____83B7_53D6_5355_4F4DY, _____8BBE_7F6E_5355_4F4DX, _____8BBE_7F6E_5355_4F4DY, _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6, _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6, _____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6, _____5224_65AD_5730_5F62_53EF_884C_8D70, _____53EF_884C_8D70_8DEF_5F84_7C7B_578B, _____83B7_53D6_5355_4F4D_62E5_6709_8005, _____8BBE_7F6E_6280_80FD_53EF_7528, _____8BBE_7F6E_52A8_4F5C, _____8BBE_7F6E_52A8_4F5C_540D, _____8BBE_7F6E_65F6_95F4_6D41_901F, _____6DFB_52A0_6280_80FD, _____79FB_9664_6280_80FD, _____5224_65AD_654C_4EBA, _____5224_65AD_7C7B_578B, _____8BA1_7B97_4F59_5F26, _____8BA1_7B97_6B63_5F26, _____89D2_5EA6_8F6C_5F27_5EA6, _____53E4_6811_7C7B_578B, _____673A_68B0_7C7B_578B, _____653B_51FB_7C7B_578B, _____7269_7406_4F24_5BB3_7C7B_578B, _____9B54_6CD5_4F24_5BB3_7C7B_578B, _____914D_7F6E, _____6280_80FDID, _____4E8C_6BB5_6280_80FDID, _____4E09_6BB5_6280_80FDID, _____6682_505C_6765_6E90, _____72B6_6001_8868, _____5F3A_5316_51FB_9000_8868, _____4E0B_4E00_4E2A_5F3A_5316_51FB_9000ID, _____5F3A_5316_51FB_9000_9A71_52A8ID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.01．克劳德.00．配置")
local _____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["克劳德单位技能配置"]
local ____00A_FF0E_8054_52A8_72B6_6001 = require("系统.03．技能系统.05．单位技能.04．英雄技能.01．克劳德.00A．联动状态")
local _____6807_8BB0_51F6_65A9_547D_4E2D = ____00A_FF0E_8054_52A8_72B6_6001["标记凶斩命中"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
function _____64AD_653EE_97F3_6548(caster, key)
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
function _____76EE_6807_672A_8BB0_5F55(state, target)
    local id = _____83B7_53D6_53E5_67C4ID(target)
    for ____, old in ipairs(state["命中目标"]) do
        if _____83B7_53D6_53E5_67C4ID(old) == id then
            return false
        end
    end
    return true
end
function _____6E05_7406E_58F3(caster)
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____6280_80FDID,
        true
    )
    _____79FB_9664_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
    _____79FB_9664_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
end
function _____6E05_7406E_72B6_6001(state)
    local caster = state["施法者"]
    debugLogForce(
        _____6A21_5757_540D,
        "清理E状态",
        "施法者",
        (caster == nil or caster == 0) and "nil" or _____83B7_53D6_53E5_67C4ID(caster),
        "阶段",
        state["阶段"],
        "位移ID",
        state["位移ID"],
        "斩击回调ID",
        state["斩击回调ID"],
        "窗口回调ID",
        state["窗口回调ID"],
        "斩击次数",
        state["斩击次数"]
    )
    if state["位移ID"] ~= 0 then
        _____505C_6B62_4F4D_79FB(state["位移ID"], "中断")
        state["位移ID"] = 0
    end
    if state["斩击回调ID"] ~= 0 then
        removeDelayedCallback(state["斩击回调ID"])
        state["斩击回调ID"] = 0
    end
    if state["窗口回调ID"] ~= 0 then
        removeDelayedCallback(state["窗口回调ID"])
        state["窗口回调ID"] = 0
    end
    if caster ~= nil and caster ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(caster, _____6682_505C_6765_6E90)
        _____6E05_7406E_58F3(caster)
        _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, 1)
    end
    state["进行中"] = false
    state["等待输入"] = false
    state["阶段"] = 0
    state["斩击次数"] = 0
    state["命中目标"] = {}
    if caster ~= nil and caster ~= 0 then
        local id = _____83B7_53D6_53E5_67C4ID(caster)
        if _____72B6_6001_8868[id] == state then
            __TS__Delete(_____72B6_6001_8868, id)
        end
    end
end
function ____E_7A97_53E3_7ED3_7B97(state)
    local ____debugLogForce_26 = debugLogForce
    local ____temp_24 = state and state["进行中"]
    local ____temp_25 = state and state["阶段"]
    local ____temp_23
    if (state and state["施法者"]) == nil then
        ____temp_23 = false
    else
        ____temp_23 = _____5355_4F4D_5B58_6D3B(state["施法者"])
    end
    ____debugLogForce_26(
        _____6A21_5757_540D,
        "E窗口结算 进入",
        "进行中",
        ____temp_24,
        "阶段",
        ____temp_25,
        "施法者存活",
        ____temp_23
    )
    if state == nil or not state["进行中"] then
        return
    end
    state["窗口回调ID"] = 0
    if not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        _____6E05_7406E_72B6_6001(state)
        return
    end
    if state["阶段"] ~= 2 then
        debugLogForce(_____6A21_5757_540D, "E窗口结算 非强化阶段 清理", "阶段", state["阶段"])
        _____6E05_7406E_72B6_6001(state)
        return
    end
    _____6DFB_52A0_5355_4F4D_6682_505C(state["施法者"], _____6682_505C_6765_6E90)
    _____8BBE_7F6E_52A8_4F5C(state["施法者"], _____914D_7F6E["强化动作序号"])
    _____8BBE_7F6E_65F6_95F4_6D41_901F(state["施法者"], _____914D_7F6E["动作时间流速"])
    state["斩击回调ID"] = addDelayedCallback(_____914D_7F6E["强化延迟秒"] * 1000, ____E_5F3A_5316_7ED3_7B97, state)
end
function _____6E05_7406E_5F3A_5316_51FB_98DE_8868_73B0(variable)
    local visual = variable
    if visual ~= nil and visual ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(visual)
    end
end
function _____521B_5EFAE_5F3A_5316_51FB_98DE_8868_73B0(caster, direction)
    local visual = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        stringToFourCCSafe(_____914D_7F6E["强化击飞单位ID"]),
        _____83B7_53D6_5355_4F4DX(caster),
        _____83B7_53D6_5355_4F4DY(caster),
        direction + 180
    )
    if visual ~= nil and visual ~= 0 then
        addDelayedCallback(_____914D_7F6E["强化特效持续秒"] * 1000, _____6E05_7406E_5F3A_5316_51FB_98DE_8868_73B0, visual)
    end
end
function ____E_7ED3_7B97_5F53_524D_65A9_51FB(state)
    local caster = state["施法者"]
    local _____5F53_524D_65B9_5411_89D2 = state["方向角"]
    local centerX = _____83B7_53D6_5355_4F4DX(caster) + _____8BA1_7B97_4F59_5F26(_____5F53_524D_65B9_5411_89D2 * _____89D2_5EA6_8F6C_5F27_5EA6) * _____914D_7F6E["斩击中心偏移"]
    local centerY = _____83B7_53D6_5355_4F4DY(caster) + _____8BA1_7B97_6B63_5F26(_____5F53_524D_65B9_5411_89D2 * _____89D2_5EA6_8F6C_5F27_5EA6) * _____914D_7F6E["斩击中心偏移"]
    local targets = _____83B7_53D6_8303_56F4_654C_519B(caster, centerX, centerY, _____914D_7F6E["斩击范围"])
    local validTargets = {}
    for ____, target in ipairs(targets) do
        do
            if not _____76EE_6807_5408_6CD5(caster, target) then
                goto __continue38
            end
            validTargets[#validTargets + 1] = target
            if _____76EE_6807_672A_8BB0_5F55(state, target) then
                local ____state__547D_4E2D_76EE_6807_29 = state["命中目标"]
                ____state__547D_4E2D_76EE_6807_29[#____state__547D_4E2D_76EE_6807_29 + 1] = target
            end
            _____65BD_52A0_7729_6655(
                caster,
                target,
                _____914D_7F6E["斩击控制秒"],
                "克劳德-E-劈砍硬直",
                "技能"
            )
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = _____914D_7F6E["命中刀光模型"],
                X = _____83B7_53D6_5355_4F4DX(target),
                Y = _____83B7_53D6_5355_4F4DY(target),
                Z = 50,
                ["面向角度"] = GetRandomDirectionDeg(),
                ["缩放"] = _____914D_7F6E["命中刀光缩放"],
                ["持续秒"] = _____914D_7F6E["命中刀光持续秒"],
                ["红"] = 255,
                ["绿"] = 80,
                ["蓝"] = 0,
                ["透明度"] = 255
            })
        end
        ::__continue38::
    end
    if #validTargets > 0 then
        _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标列表"] = validTargets,
            ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E["斩击伤害倍率"][state["斩击次数"]],
            ["伤害类型"] = _____7269_7406_4F24_5BB3_7C7B_578B,
            attack = true,
            ranged = false,
            attackType = _____653B_51FB_7C7B_578B,
            ["来源类型"] = "单位技能",
            ["技能ID"] = _____6280_80FDID,
            ["技能实例ID"] = state["技能实例ID"],
            ["标签"] = ("克劳德-E-" .. tostring(state["斩击次数"])) .. "斩"
        })
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["普通刀光模型"],
        X = centerX,
        Y = centerY,
        Z = 50,
        ["面向角度"] = _____5F53_524D_65B9_5411_89D2,
        ["缩放"] = _____914D_7F6E["普通刀光缩放"],
        ["持续秒"] = _____914D_7F6E["普通刀光持续秒"]
    })
    local textX = _____83B7_53D6_5355_4F4DX(caster) + _____8BA1_7B97_4F59_5F26(_____5F53_524D_65B9_5411_89D2 * _____89D2_5EA6_8F6C_5F27_5EA6) * _____914D_7F6E["斩击文字偏移"]
    local textY = _____83B7_53D6_5355_4F4DY(caster) + _____8BA1_7B97_6B63_5F26(_____5F53_524D_65B9_5411_89D2 * _____89D2_5EA6_8F6C_5F27_5EA6) * _____914D_7F6E["斩击文字偏移"]
    CreateFloatTextAtPoint(textX, textY, _____914D_7F6E["斩击文字"][state["斩击次数"]], {
        height = _____914D_7F6E["斩击文字Z高度"],
        size = _____914D_7F6E["斩击文字字号"][state["斩击次数"]],
        red = 255,
        green = 214,
        blue = 0,
        alpha = 255,
        duration = _____914D_7F6E["斩击文字持续秒"],
        speedX = 0,
        speedY = 0
    })
end
function ____E_6267_884C_65A9_51FB(variable)
    local state = variable
    if state == nil or not state["进行中"] or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        local ____debugLogForce_37 = debugLogForce
        local ____temp_35 = state ~= nil
        local ____temp_36 = state and state["进行中"]
        local ____temp_34
        if (state and state["施法者"]) == nil then
            ____temp_34 = false
        else
            ____temp_34 = _____5355_4F4D_5B58_6D3B(state["施法者"])
        end
        ____debugLogForce_37(
            _____6A21_5757_540D,
            "E执行斩击 前置不满足",
            "状态存在",
            ____temp_35,
            "进行中",
            ____temp_36,
            "施法者存活",
            ____temp_34
        )
        if state ~= nil then
            _____6E05_7406E_72B6_6001(state)
        end
        return
    end
    state["斩击回调ID"] = 0
    state["斩击次数"] = state["斩击次数"] + 1
    debugLogForce(
        _____6A21_5757_540D,
        "E执行斩击",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(state["施法者"]),
        "第",
        state["斩击次数"],
        "斩"
    )
    _____8BBE_7F6E_52A8_4F5C(state["施法者"], _____914D_7F6E["斩击动作序号"][state["斩击次数"]])
    _____8BBE_7F6E_65F6_95F4_6D41_901F(state["施法者"], 2)
    ____E_7ED3_7B97_5F53_524D_65A9_51FB(state)
    if state["斩击次数"] < 3 then
        state["斩击回调ID"] = addDelayedCallback(_____914D_7F6E["斩击间隔秒"] * 1000, ____E_6267_884C_65A9_51FB, state)
        return
    end
    state["等待输入"] = true
    _____79FB_9664_5355_4F4D_6682_505C(state["施法者"], _____6682_505C_6765_6E90)
    _____8BBE_7F6E_65F6_95F4_6D41_901F(state["施法者"], 1)
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(state["施法者"]),
        _____6280_80FDID,
        false
    )
    _____6DFB_52A0_6280_80FD(state["施法者"], _____4E8C_6BB5_6280_80FDID)
    debugLogForce(_____6A21_5757_540D, "E三斩完成 等待二段输入")
    state["窗口回调ID"] = addDelayedCallback(_____914D_7F6E["二段窗口秒"] * 1000, ____E_7A97_53E3_7ED3_7B97, state)
end
function ____E_5F3A_5316_7ED3_675F(target, reason, moveId)
    local record = _____5F3A_5316_51FB_9000_8868[moveId]
    __TS__Delete(_____5F3A_5316_51FB_9000_8868, moveId)
    if record == nil or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____79FB_9664_5355_4F4D_6682_505C(
        target,
        "克劳德-E-强化追击-" .. tostring(moveId)
    )
    _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
        target,
        _____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6(target),
        0
    )
    if reason == "撞墙" then
        _____65BD_52A0_7729_6655(
            record["施法者"],
            target,
            _____914D_7F6E["撞墙眩晕秒"],
            "克劳德-E-撞墙眩晕",
            "技能"
        )
    end
end
function ____E_5F3A_5316_8FFD_51FBTick()
    for key in pairs(_____5F3A_5316_51FB_9000_8868) do
        do
            local moveId = __TS__Number(key)
            local record = _____5F3A_5316_51FB_9000_8868[moveId]
            if record == nil then
                goto __continue51
            end
            if not _____5355_4F4D_5B58_6D3B(record["目标"]) or not _____5355_4F4D_5B58_6D3B(record["施法者"]) then
                ____E_5F3A_5316_7ED3_675F(record["目标"], "中断", moveId)
                goto __continue51
            end
            _____8BBE_7F6E_52A8_4F5C_540D(record["目标"], "Death")
            local x = _____83B7_53D6_5355_4F4DX(record["目标"]) + _____8BA1_7B97_4F59_5F26(record["方向角"] * _____89D2_5EA6_8F6C_5F27_5EA6) * _____914D_7F6E["强化追击每Tick距离"]
            local y = _____83B7_53D6_5355_4F4DY(record["目标"]) + _____8BA1_7B97_6B63_5F26(record["方向角"] * _____89D2_5EA6_8F6C_5F27_5EA6) * _____914D_7F6E["强化追击每Tick距离"]
            if _____5224_65AD_5730_5F62_53EF_884C_8D70(x, y, _____53EF_884C_8D70_8DEF_5F84_7C7B_578B) then
                ____E_5F3A_5316_7ED3_675F(record["目标"], "撞墙", moveId)
                goto __continue51
            end
            _____8BBE_7F6E_5355_4F4DX(record["目标"], x)
            _____8BBE_7F6E_5355_4F4DY(record["目标"], y)
            _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
                record["目标"],
                _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(record["目标"]) + _____914D_7F6E["强化追击每Tick高度"],
                0
            )
            record.Tick = record.Tick + 1
            if record.Tick >= _____914D_7F6E["强化追击Tick数"] then
                ____E_5F3A_5316_7ED3_675F(record["目标"], "完成", moveId)
            end
        end
        ::__continue51::
    end
    if #__TS__ObjectKeys(_____5F3A_5316_51FB_9000_8868) == 0 and _____5F3A_5316_51FB_9000_9A71_52A8ID > 0 then
        removePeriodicCallback(_____5F3A_5316_51FB_9000_9A71_52A8ID)
        _____5F3A_5316_51FB_9000_9A71_52A8ID = 0
    end
end
function ____E_5F3A_5316_8FFD_51FB_5EF6_8FDF_542F_52A8(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or not _____5355_4F4D_5B58_6D3B(_____53C2_6570["施法者"]) or not _____5355_4F4D_5B58_6D3B(_____53C2_6570["目标"]) then
        return
    end
    _____542F_52A8E_5F3A_5316_8FFD_51FB(_____53C2_6570["施法者"], _____53C2_6570["目标"], _____53C2_6570["方向角"])
end
function _____542F_52A8E_5F3A_5316_8FFD_51FB(caster, target, direction)
    _____4E0B_4E00_4E2A_5F3A_5316_51FB_9000ID = _____4E0B_4E00_4E2A_5F3A_5316_51FB_9000ID + 1
    local moveId = _____4E0B_4E00_4E2A_5F3A_5316_51FB_9000ID
    _____5F3A_5316_51FB_9000_8868[moveId] = {["施法者"] = caster, ["目标"] = target, ["方向角"] = direction, Tick = 0}
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(target)
    _____6DFB_52A0_5355_4F4D_6682_505C(
        target,
        "克劳德-E-强化追击-" .. tostring(moveId)
    )
    if _____5F3A_5316_51FB_9000_9A71_52A8ID == 0 then
        _____5F3A_5316_51FB_9000_9A71_52A8ID = addPeriodicCallback(_____914D_7F6E["强化追击间隔秒"] * 1000, ____E_5F3A_5316_8FFD_51FBTick)
    end
end
function ____E_5F3A_5316_4F24_5BB3_7ED3_7B97(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or not _____5355_4F4D_5B58_6D3B(_____53C2_6570["施法者"]) then
        return
    end
    local validTargets = {}
    for ____, target in ipairs(_____53C2_6570["目标列表"]) do
        do
            if not _____76EE_6807_5408_6CD5(_____53C2_6570["施法者"], target) then
                goto __continue64
            end
            validTargets[#validTargets + 1] = target
            _____6807_8BB0_51F6_65A9_547D_4E2D(_____53C2_6570["施法者"], target, _____914D_7F6E["凶斩联动标记持续秒"])
        end
        ::__continue64::
    end
    if #validTargets == 0 then
        return
    end
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = _____53C2_6570["施法者"],
        ["目标列表"] = validTargets,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____53C2_6570["施法者"]) * _____914D_7F6E["强化伤害倍率"],
        ["伤害类型"] = _____9B54_6CD5_4F24_5BB3_7C7B_578B,
        attack = true,
        ranged = false,
        attackType = _____653B_51FB_7C7B_578B,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____6280_80FDID,
        ["技能实例ID"] = _____53C2_6570["技能实例ID"],
        ["标签"] = "克劳德-E-强化击飞"
    })
end
function ____E_5F3A_5316_7ED3_7B97(state)
    debugLogForce(
        _____6A21_5757_540D,
        "E强化结算 进入",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(state["施法者"]),
        "进行中",
        state["进行中"],
        "阶段",
        state["阶段"],
        "命中目标数",
        #state["命中目标"]
    )
    if not state["进行中"] or state["阶段"] ~= 2 then
        return
    end
    state["斩击回调ID"] = 0
    local caster = state["施法者"]
    _____64AD_653EE_97F3_6548(caster, _____914D_7F6E["强化音效键"])
    _____521B_5EFAE_5F3A_5316_51FB_98DE_8868_73B0(caster, state["方向角"])
    local validTargets = {}
    for ____, target in ipairs(state["命中目标"]) do
        do
            if not _____76EE_6807_5408_6CD5(caster, target) then
                goto __continue70
            end
            validTargets[#validTargets + 1] = target
            addDelayedCallback(80, ____E_5F3A_5316_8FFD_51FB_5EF6_8FDF_542F_52A8, {["施法者"] = caster, ["目标"] = target, ["方向角"] = state["方向角"]})
        end
        ::__continue70::
    end
    debugLogForce(
        _____6A21_5757_540D,
        "E强化结算 结算",
        "合法目标",
        #validTargets,
        "强化伤害",
        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E["强化伤害倍率"]
    )
    if #validTargets > 0 then
        addDelayedCallback(_____914D_7F6E["强化伤害延迟秒"] * 1000, ____E_5F3A_5316_4F24_5BB3_7ED3_7B97, {["施法者"] = caster, ["目标列表"] = validTargets, ["技能实例ID"] = state["技能实例ID"]})
    end
    _____6E05_7406E_72B6_6001(state)
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
removeDelayedCallback = ____require_result_0.removeDelayedCallback
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_1["减少魔法值"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成批量AOE技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_3["开始冲锋"]
local _____5F00_59CB_51FB_9000 = ____require_result_3["开始击退"]
_____505C_6B62_4F4D_79FB = ____require_result_3["停止位移"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
_____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
_____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_6["创建单位并登记排泄安全"]
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
_____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_7["立即移除单位并取消排泄登记"]
local ____require_result_8 = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字")
CreateFloatTextAtPoint = ____require_result_8.CreateFloatTextAtPoint
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
_____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_9["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_9["移除单位暂停"]
local ____require_result_10 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
_____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6 = ____require_result_10["确保单位可设置飞行高度"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____83B7_53D6_8303_56F4_654C_519B = ____require_result_11["获取范围敌军"]
local ____require_result_12 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_12.registerDeathListener
local ____require_result_13 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
stringToFourCCSafe = ____require_result_13.stringToFourCCSafe
local ____require_result_14 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_14.debugLogForce
_____6A21_5757_540D = "克劳德-E"
jglobals = require("jass.globals")
local ____require_result_15 = require("lib.扩展函数.BJ函数.14．音效函数")
PlaySoundOnUnitBJ = ____require_result_15.PlaySoundOnUnitBJ
local ____require_result_16 = require("lib.扩展函数.BJ函数.07．杂项")
GetRandomDirectionDeg = ____require_result_16.GetRandomDirectionDeg
_____83B7_53D6_53E5_67C4ID = jass.GetHandleId
local _____83B7_53D6_5355_4F4D_7C7B_578BID = jass.GetUnitTypeId
_____83B7_53D6_5355_4F4DX = jass.GetUnitX
_____83B7_53D6_5355_4F4DY = jass.GetUnitY
local _____83B7_53D6_5355_4F4D_9762_5411 = jass.GetUnitFacing
_____8BBE_7F6E_5355_4F4DX = jass.SetUnitX
_____8BBE_7F6E_5355_4F4DY = jass.SetUnitY
_____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6 = jass.GetUnitFlyHeight
_____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6 = jass.SetUnitFlyHeight
_____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6 = jass.GetUnitDefaultFlyHeight
_____5224_65AD_5730_5F62_53EF_884C_8D70 = jass.IsTerrainPathable
_____53EF_884C_8D70_8DEF_5F84_7C7B_578B = jass.PATHING_TYPE_WALKABILITY
local _____83B7_53D6_6280_80FD_76EE_6807X = jass.GetSpellTargetX
local _____83B7_53D6_6280_80FD_76EE_6807Y = jass.GetSpellTargetY
_____83B7_53D6_5355_4F4D_62E5_6709_8005 = jass.GetOwningPlayer
local _____83B7_53D6_5355_4F4D_72B6_6001 = jass.GetUnitState
_____8BBE_7F6E_6280_80FD_53EF_7528 = jass.SetPlayerAbilityAvailable
_____8BBE_7F6E_52A8_4F5C = jass.SetUnitAnimationByIndex
_____8BBE_7F6E_52A8_4F5C_540D = jass.SetUnitAnimation
_____8BBE_7F6E_65F6_95F4_6D41_901F = jass.SetUnitTimeScale
_____6DFB_52A0_6280_80FD = jass.UnitAddAbility
_____79FB_9664_6280_80FD = jass.UnitRemoveAbility
_____5224_65AD_654C_4EBA = jass.IsUnitEnemy
_____5224_65AD_7C7B_578B = jass.IsUnitType
local _____8BA1_7B97_53CD_6B63_5207 = jass.Atan2
_____8BA1_7B97_4F59_5F26 = jass.Cos
_____8BA1_7B97_6B63_5F26 = jass.Sin
local _____5F27_5EA6_8F6C_89D2_5EA6 = jass.bj_RADTODEG
_____89D2_5EA6_8F6C_5F27_5EA6 = jass.bj_DEGTORAD
_____53E4_6811_7C7B_578B = jass.UNIT_TYPE_ANCIENT
_____673A_68B0_7C7B_578B = jass.UNIT_TYPE_MECHANICAL
local _____6700_5927_9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MAX_MANA
local _____5F53_524D_9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MANA
_____653B_51FB_7C7B_578B = jass.ATTACK_TYPE_NORMAL
_____7269_7406_4F24_5BB3_7C7B_578B = jass.DAMAGE_TYPE_NORMAL
_____9B54_6CD5_4F24_5BB3_7C7B_578B = jass.DAMAGE_TYPE_MAGIC
_____914D_7F6E = _____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E.E
local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____6280_80FDID = stringToFourCCSafe(_____914D_7F6E["技能ID"])
_____4E8C_6BB5_6280_80FDID = stringToFourCCSafe(_____914D_7F6E["二段技能ID"])
_____4E09_6BB5_6280_80FDID = stringToFourCCSafe(_____914D_7F6E["三段技能ID"])
_____6682_505C_6765_6E90 = "克劳德-E-自身"
_____72B6_6001_8868 = {}
_____5F3A_5316_51FB_9000_8868 = {}
_____4E0B_4E00_4E2A_5F3A_5316_51FB_9000ID = 0
_____5F3A_5316_51FB_9000_9A71_52A8ID = 0
local function _____83B7_53D6_6216_521B_5EFAE_72B6_6001(unit)
    local id = _____83B7_53D6_53E5_67C4ID(unit)
    local state = _____72B6_6001_8868[id]
    if state == nil then
        state = {
            ["施法者"] = unit,
            ["进行中"] = false,
            ["阶段"] = 0,
            ["等待输入"] = false,
            ["方向角"] = 0,
            ["目标X"] = 0,
            ["目标Y"] = 0,
            ["位移ID"] = 0,
            ["斩击回调ID"] = 0,
            ["窗口回调ID"] = 0,
            ["斩击次数"] = 0,
            ["命中目标"] = {}
        }
        _____72B6_6001_8868[id] = state
    end
    return state
end
local function ____E_51B2_950B_8FC7_6EE4(caster, target)
    if not _____76EE_6807_5408_6CD5(caster, target) then
        return false
    end
    local _____5DEE_503C = _____83B7_53D6_5355_4F4D_9762_5411(caster) - _____8BA1_7B97_53CD_6B63_5207(
        _____83B7_53D6_5355_4F4DY(target) - _____83B7_53D6_5355_4F4DY(caster),
        _____83B7_53D6_5355_4F4DX(target) - _____83B7_53D6_5355_4F4DX(caster)
    ) * _____5F27_5EA6_8F6C_89D2_5EA6
    while _____5DEE_503C > 180 do
        _____5DEE_503C = _____5DEE_503C - 360
    end
    while _____5DEE_503C < -180 do
        _____5DEE_503C = _____5DEE_503C + 360
    end
    return _____5DEE_503C <= _____914D_7F6E["冲锋前方角度"] and _____5DEE_503C >= -_____914D_7F6E["冲锋前方角度"]
end
local function ____E_51B2_950B_547D_4E2D_8FC7_6EE4(movingUnit, target, _moveId)
    return ____E_51B2_950B_8FC7_6EE4(movingUnit, target)
end
local function ____E_51B2_950B_7ED3_675F(caster, _reason, _moveId)
    local state = _____72B6_6001_8868[_____83B7_53D6_53E5_67C4ID(caster)]
    debugLogForce(
        _____6A21_5757_540D,
        "E冲锋结束",
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
    _____64AD_653EE_97F3_6548(caster, _____914D_7F6E["普通音效键"])
    state["斩击回调ID"] = addDelayedCallback(10, ____E_6267_884C_65A9_51FB, state)
end
local function ____E_51B2_950B_542F_52A8(state)
    if not state["进行中"] or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        debugLogForce(
            _____6A21_5757_540D,
            "E冲锋启动 前置不满足 清理",
            "进行中",
            state["进行中"],
            "施法者存活",
            _____5355_4F4D_5B58_6D3B(state["施法者"])
        )
        _____6E05_7406E_72B6_6001(state)
        return
    end
    local dx = state["目标X"] - _____83B7_53D6_5355_4F4DX(state["施法者"])
    local dy = state["目标Y"] - _____83B7_53D6_5355_4F4DY(state["施法者"])
    local _____76EE_6807_8DDD_79BB = jass.SquareRoot(dx * dx + dy * dy)
    local _____51B2_950B_8DDD_79BB = _____76EE_6807_8DDD_79BB > 0 and _____76EE_6807_8DDD_79BB < _____914D_7F6E["冲锋距离"] and _____76EE_6807_8DDD_79BB or _____914D_7F6E["冲锋距离"]
    state["位移ID"] = _____5F00_59CB_51B2_950B(state["施法者"], {
        ["角度"] = state["方向角"],
        ["距离"] = _____51B2_950B_8DDD_79BB,
        ["持续时间"] = _____914D_7F6E["冲锋持续秒"],
        ["检查地形"] = true,
        ["朝向跟随位移"] = true,
        ["暂停单位"] = true,
        ["禁用碰撞"] = true,
        ["命中半径"] = _____914D_7F6E["冲锋命中半径"],
        ["只命中敌人"] = true,
        ["命中后结束"] = true,
        ["命中过滤"] = ____E_51B2_950B_547D_4E2D_8FC7_6EE4,
        ["结束回调"] = ____E_51B2_950B_7ED3_675F,
        ["位移特效"] = _____914D_7F6E["普通刀光模型"],
        ["动画序号"] = 0
    })
    debugLogForce(
        _____6A21_5757_540D,
        "E冲锋启动 冲锋创建",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(state["施法者"]),
        "位移ID",
        state["位移ID"],
        "方向角",
        state["方向角"],
        "距离",
        _____51B2_950B_8DDD_79BB,
        "目标距离",
        _____76EE_6807_8DDD_79BB
    )
    if state["位移ID"] == 0 then
        ____E_51B2_950B_7ED3_675F(state["施法者"], "中断", 0)
    end
end
local function _____6D88_8017E_5F3A_5316_9B54_6CD5(caster)
    local maxMana = _____83B7_53D6_5355_4F4D_72B6_6001(caster, _____6700_5927_9B54_6CD5_72B6_6001) or 0
    local cost = maxMana * _____914D_7F6E["强化追加魔耗比例"]
    local currentMana = _____83B7_53D6_5355_4F4D_72B6_6001(caster, _____5F53_524D_9B54_6CD5_72B6_6001) or 0
    debugLogForce(
        _____6A21_5757_540D,
        "E强化魔耗判断",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "总需求",
        cost,
        "当前蓝",
        currentMana
    )
    if cost <= 0 or currentMana < cost then
        debugLogForce(
            _____6A21_5757_540D,
            "E强化魔耗不足 返回false",
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
local function _____91CA_653EE_521D_6BB5(state, caster, skillInstanceId)
    debugLogForce(
        _____6A21_5757_540D,
        "释放E初段 进入",
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
    state["技能实例ID"] = skillInstanceId
    state["斩击次数"] = 0
    state["命中目标"] = {}
    state["目标X"] = _____83B7_53D6_6280_80FD_76EE_6807X()
    state["目标Y"] = _____83B7_53D6_6280_80FD_76EE_6807Y()
    state["方向角"] = _____8BA1_7B97_53CD_6B63_5207(
        _____83B7_53D6_6280_80FD_76EE_6807Y() - _____83B7_53D6_5355_4F4DY(caster),
        _____83B7_53D6_6280_80FD_76EE_6807X() - _____83B7_53D6_5355_4F4DX(caster)
    ) * _____5F27_5EA6_8F6C_89D2_5EA6
    debugLogForce(_____6A21_5757_540D, "释放E初段 正常路径", "方向角", state["方向角"])
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____6682_505C_6765_6E90)
    _____8BBE_7F6E_52A8_4F5C(caster, _____914D_7F6E["斩击动作序号"][1])
    _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, _____914D_7F6E["动作时间流速"])
    addDelayedCallback(20, ____E_51B2_950B_542F_52A8, state)
end
local function _____91CA_653EE_4E8C_6BB5(state, caster)
    debugLogForce(
        _____6A21_5757_540D,
        "释放E二段 进入",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "进行中",
        state["进行中"],
        "等待输入",
        state["等待输入"],
        "阶段",
        state["阶段"]
    )
    if not state["进行中"] or not state["等待输入"] or state["阶段"] ~= 0 or not _____6D88_8017E_5F3A_5316_9B54_6CD5(caster) then
        return
    end
    state["阶段"] = 2
    state["等待输入"] = false
    debugLogForce(_____6A21_5757_540D, "释放E二段 成功进入强化阶段 等待窗口结算")
    _____79FB_9664_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
    _____79FB_9664_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
end
local function ____E_521D_6BB5_53EF_91CA_653E(state, _caster)
    return not state["进行中"]
end
local function ____E_4E8C_6BB5_53EF_91CA_653E(state, _caster)
    return state["进行中"] and state["等待输入"] and state["阶段"] == 0
end
local function _____514B_52B3_5FB7E_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 or _____83B7_53D6_5355_4F4D_7C7B_578BID(dyingUnit) ~= _____5355_4F4D_7C7B_578BID then
        return
    end
    local state = _____72B6_6001_8868[_____83B7_53D6_53E5_67C4ID(dyingUnit)]
    debugLogForce(
        _____6A21_5757_540D,
        "克劳德E死亡清理",
        "死亡单位",
        _____83B7_53D6_53E5_67C4ID(dyingUnit),
        "状态存在",
        state ~= nil
    )
    if state ~= nil then
        _____6E05_7406E_72B6_6001(state)
    end
end
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "克劳德-凶斩",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = _____6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAE_72B6_6001,
    ["可释放"] = ____E_521D_6BB5_53EF_91CA_653E,
    ["释放技能"] = _____91CA_653EE_521D_6BB5,
    ["创建独立技能实例"] = true,
    ["独立技能来源类型"] = "单位技能",
    ["技能实例持续时间秒"] = 5
})
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "克劳德-凶斩二段",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = _____4E8C_6BB5_6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAE_72B6_6001,
    ["可释放"] = ____E_4E8C_6BB5_53EF_91CA_653E,
    ["释放技能"] = _____91CA_653EE_4E8C_6BB5,
    ["创建独立技能实例"] = false
})
registerDeathListener(_____514B_52B3_5FB7E_6B7B_4EA1_6E05_7406)
return ____exports
