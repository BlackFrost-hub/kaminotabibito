local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.00．配置")
local _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["莫尔特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建莫尔特斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯音效配置"]
local ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.03．腐败值与根须领域")
local _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C = ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF["应用莫尔特斯腐败值"]
local _____786E_4FDD_83AB_5C14_7279_65AF_6839_987B_5BAB_683C = ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF["确保莫尔特斯根须宫格"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____53D6_5355_4F4DID = ____16_FF0E_516C_5171_5DE5_5177["取单位ID"]
local _____64AD_653E_83AB_5C14_7279_65AF_9650_65F6_52A8_4F5C = ____16_FF0E_516C_5171_5DE5_5177["播放莫尔特斯限时动作"]
local _____5F00_59CB_83AB_5C14_7279_65AF_5927_62DB_65BD_6CD5 = ____16_FF0E_516C_5171_5DE5_5177["开始莫尔特斯大招施法"]
local stringToFourCC = ____16_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____70B9_662F_5426_5904_4E8E_65B9_5411_969C_788D_7269_540E_65B9 = ____16_FF0E_516C_5171_5DE5_5177["点是否处于方向障碍物后方"]
local _____53D6_5750_6807_89D2_5EA6 = ____16_FF0E_516C_5171_5DE5_5177["取坐标角度"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local _____9500_6BC1_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["销毁原生弹幕"]
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____8BBE_7F6E_7279_6548_7F29_653E = ____require_result_0["设置特效缩放"]
local _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_0["创建Dz绑定单位特效"]
local _____83B7_53D6Dz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_0["获取Dz绑定单位特效"]
local _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_0["销毁Dz绑定单位特效"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("平台扩展API动作")
local _____7279_6548_663E_793A__9690_85CF = ____require_result_2["特效显示_隐藏"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomInt = jass.GetRandomInt
local GetUnitStateJapi = require("jass.japi").GetUnitState
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6050_60E7 = ____require_result_3["施加恐惧"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_5["造成AOE技能伤害"]
local _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____53E4_6728_60B2_9E23_6280_80FDID = stringToFourCC(_____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local _____53E4_6728_60B2_9E23_5F39_5E55_72B6_6001_8868 = {}
local _____53E4_6728_60B2_9E23_5B89_5168_62A4_76FE_7279_6548_952E = "莫尔特斯-古木悲鸣安全区护盾"
local function _____9500_6BC1_53E4_6728_60B2_9E23_5B89_5168_62A4_76FE_8BB0_5F55(_____8BB0_5F55)
    if _____8BB0_5F55 == nil or _____8BB0_5F55["单位"] == nil or _____8BB0_5F55["单位"] == 0 then
        return
    end
    local current = _____83B7_53D6Dz_7ED1_5B9A_5355_4F4D_7279_6548(_____8BB0_5F55["单位"], _____53E4_6728_60B2_9E23_5B89_5168_62A4_76FE_7279_6548_952E)
    if current == _____8BB0_5F55["特效"] then
        _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548(_____8BB0_5F55["单位"], _____53E4_6728_60B2_9E23_5B89_5168_62A4_76FE_7279_6548_952E)
    end
end
local function _____6E05_7406_53E4_6728_60B2_9E23_5B89_5168_533A_62A4_76FE(state)
    if state == nil then
        return
    end
    do
        local i = 0
        while i < #state["安全护盾记录列表"] do
            _____9500_6BC1_53E4_6728_60B2_9E23_5B89_5168_62A4_76FE_8BB0_5F55(state["安全护盾记录列表"][i + 1])
            i = i + 1
        end
    end
    state["安全护盾记录列表"] = {}
end
local function _____5EF6_8FDF_6E05_7406_53E4_6728_60B2_9E23_5B89_5168_533A_62A4_76FE(variable)
    _____9500_6BC1_53E4_6728_60B2_9E23_5B89_5168_62A4_76FE_8BB0_5F55(variable)
end
local function _____7ED1_5B9A_53E4_6728_60B2_9E23_5B89_5168_533A_62A4_76FE(state, target)
    local targetId = _____53D6_5355_4F4DID(target)
    if targetId == 0 or state["安全护盾目标"][targetId] == true then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]
    local effect = _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548(
        target,
        "origin",
        cfg["安全区护盾特效路径"],
        _____53E4_6728_60B2_9E23_5B89_5168_62A4_76FE_7279_6548_952E,
        cfg["安全区护盾特效缩放"]
    )
    if effect == nil or effect == 0 then
        return
    end
    state["安全护盾目标"][targetId] = true
    local record = {["单位"] = target, ["特效"] = effect}
    local ____state__5B89_5168_62A4_76FE_8BB0_5F55_5217_8868_6 = state["安全护盾记录列表"]
    ____state__5B89_5168_62A4_76FE_8BB0_5F55_5217_8868_6[#____state__5B89_5168_62A4_76FE_8BB0_5F55_5217_8868_6 + 1] = record
    if not state["已登记清理"] then
        state["已登记清理"] = true
        local ____self_7 = state.context["清理"]
        ____self_7["登记清理"](____self_7, "莫尔特斯-古木悲鸣安全区护盾", _____6E05_7406_53E4_6728_60B2_9E23_5B89_5168_533A_62A4_76FE, state)
    end
    local delayedId = addDelayedCallback(cfg["安全区护盾持续秒"] * 1000, _____5EF6_8FDF_6E05_7406_53E4_6728_60B2_9E23_5B89_5168_533A_62A4_76FE, record)
    local ____self_8 = state.context["清理"]
    ____self_8["登记延迟回调"](____self_8, "莫尔特斯-古木悲鸣安全区护盾到期", delayedId)
end
local function _____6E05_7406_53E4_6728_60B2_9E23_8611_83C7_8868_73B0(state)
    if state == nil or state["已清理"] then
        return
    end
    do
        local i = 0
        while i < #state["特效列表"] do
            local effect = state["特效列表"][i + 1]
            if effect ~= nil and effect ~= 0 then
                _____7279_6548_663E_793A__9690_85CF(effect, false)
                DestroyEffect(effect)
            end
            i = i + 1
        end
    end
    state["特效列表"] = {}
    state["格子列表"] = {}
    state["已清理"] = true
end
local function _____5EF6_8FDF_6E05_7406_53E4_6728_60B2_9E23_8611_83C7_8868_73B0(variable)
    _____6E05_7406_53E4_6728_60B2_9E23_8611_83C7_8868_73B0(variable)
end
local function _____8BFB_53D6_53E4_6728_60B2_9E23_4E2D_5FC3(context)
    if context["根须领域中心X"] ~= nil and context["根须领域中心Y"] ~= nil then
        return {X = context["根须领域中心X"], Y = context["根须领域中心Y"]}
    end
    local grid = context["根须宫格"]
    local ____temp_9
    if grid ~= nil then
        ____temp_9 = grid["获取格子"](grid, 0, 0)
    else
        ____temp_9 = nil
    end
    local _____9996_683C = ____temp_9
    local ____temp_10
    if grid ~= nil then
        ____temp_10 = grid["获取格子"](grid, 2, 2)
    else
        ____temp_10 = nil
    end
    local _____672B_683C = ____temp_10
    if _____9996_683C ~= nil and _____672B_683C ~= nil then
        return {X = (_____9996_683C["左"] + _____672B_683C["右"]) / 2, Y = (_____9996_683C["下"] + _____672B_683C["上"]) / 2}
    end
    local boss = context["Boss单位"]
    return {
        X = GetUnitX(boss),
        Y = GetUnitY(boss)
    }
end
local function _____83B7_53D6_8611_83C7_8DEF_5F84_901A_9053(_____884C, _____5217)
    local result = {}
    if _____884C == 0 then
        result[#result + 1] = "下侧通道"
    end
    if _____884C == 2 then
        result[#result + 1] = "上侧通道"
    end
    if _____5217 == 0 then
        result[#result + 1] = "左侧通道"
    end
    if _____5217 == 2 then
        result[#result + 1] = "右侧通道"
    end
    return result
end
local function _____6784_9020_60B2_9E23_8611_83C7_5019_9009_683C_5B50(grid)
    local result = {}
    do
        local _____884C = 0
        while _____884C < 3 do
            do
                local _____5217 = 0
                while _____5217 < 3 do
                    do
                        if _____884C == 1 and _____5217 == 1 then
                            goto __continue32
                        end
                        local cell = grid["获取格子"](grid, _____884C, _____5217)
                        if cell == nil then
                            goto __continue32
                        end
                        result[#result + 1] = {
                            ["行"] = _____884C,
                            ["列"] = _____5217,
                            X = cell["中心X"],
                            Y = cell["中心Y"],
                            ["通道键列表"] = _____83B7_53D6_8611_83C7_8DEF_5F84_901A_9053(_____884C, _____5217)
                        }
                    end
                    ::__continue32::
                    _____5217 = _____5217 + 1
                end
            end
            _____884C = _____884C + 1
        end
    end
    return result
end
local function _____9009_62E9_60B2_9E23_8611_83C7_683C_5B50(grid)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]
    local pool = _____6784_9020_60B2_9E23_8611_83C7_5019_9009_683C_5B50(grid)
    local result = {}
    local _____901A_9053_6570_91CF = {}
    do
        local i = 0
        while i < cfg["蘑菇数量"] do
            local _____53EF_9009_683C_5B50 = {}
            do
                local j = 0
                while j < #pool do
                    local candidate = pool[j + 1]
                    local _____8D85_8FC7_901A_9053_4E0A_9650 = false
                    do
                        local k = 0
                        while k < #candidate["通道键列表"] do
                            local _____901A_9053_952E = candidate["通道键列表"][k + 1]
                            if (_____901A_9053_6570_91CF[_____901A_9053_952E] or 0) >= cfg["蘑菇同通道上限"] then
                                _____8D85_8FC7_901A_9053_4E0A_9650 = true
                                break
                            end
                            k = k + 1
                        end
                    end
                    if not _____8D85_8FC7_901A_9053_4E0A_9650 then
                        _____53EF_9009_683C_5B50[#_____53EF_9009_683C_5B50 + 1] = candidate
                    end
                    j = j + 1
                end
            end
            if #_____53EF_9009_683C_5B50 <= 0 then
                break
            end
            local selected = _____53EF_9009_683C_5B50[GetRandomInt(0, #_____53EF_9009_683C_5B50 - 1) + 1]
            result[#result + 1] = selected
            do
                local j = 0
                while j < #selected["通道键列表"] do
                    local _____901A_9053_952E = selected["通道键列表"][j + 1]
                    _____901A_9053_6570_91CF[_____901A_9053_952E] = (_____901A_9053_6570_91CF[_____901A_9053_952E] or 0) + 1
                    j = j + 1
                end
            end
            local poolIndex = __TS__ArrayIndexOf(pool, selected)
            if poolIndex >= 0 then
                __TS__ArraySplice(pool, poolIndex, 1)
            end
            i = i + 1
        end
    end
    return result
end
local function _____83B7_53D6_60B2_9E23_8611_83C7_5750_6807(context)
    local state = context.__moltesAncientMushroomState
    local result = {}
    if state == nil or state["格子列表"] == nil then
        return result
    end
    do
        local i = 0
        while i < #state["格子列表"] do
            local cell = state["格子列表"][i + 1]
            result[#result + 1] = {X = cell.X, Y = cell.Y}
            i = i + 1
        end
    end
    return result
end
local function _____53E4_6728_60B2_9E23_76EE_6807_88AB_8611_83C7_906E_6321(state, target)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    do
        local i = 0
        while i < #state["蘑菇坐标列表"] do
            local mushroom = state["蘑菇坐标列表"][i + 1]
            if _____70B9_662F_5426_5904_4E8E_65B9_5411_969C_788D_7269_540E_65B9(
                state["中心X"],
                state["中心Y"],
                state["方向角"],
                mushroom.X,
                mushroom.Y,
                targetX,
                targetY,
                cfg["蘑菇遮挡半径"]
            ) then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____53E4_6728_60B2_9E23_76EE_6807_7B5B_9009(target, projectileId)
    local state = _____53E4_6728_60B2_9E23_5F39_5E55_72B6_6001_8868[projectileId]
    if state == nil or not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local targetId = _____53D6_5355_4F4DID(target)
    if targetId == 0 or state["已命中目标"][targetId] == true then
        return false
    end
    if _____53E4_6728_60B2_9E23_76EE_6807_88AB_8611_83C7_906E_6321(state, target) then
        _____7ED1_5B9A_53E4_6728_60B2_9E23_5B89_5168_533A_62A4_76FE(state["安全区状态"], target)
        return false
    end
    state["已命中目标"][targetId] = true
    return true
end
local function _____53E4_6728_60B2_9E23_5F39_5E55_547D_4E2D(target, projectileId)
    local state = _____53E4_6728_60B2_9E23_5F39_5E55_72B6_6001_8868[projectileId]
    if state == nil or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]
    local maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return
    end
    _____9020_6210AOE_6280_80FD_4F24_5BB3({
        ["技能ID"] = _____53E4_6728_60B2_9E23_6280_80FDID,
        ["来源"] = state.context["Boss单位"],
        ["目标"] = target,
        ["伤害"] = maxLife * cfg["目标最大生命比例"],
        attack = false,
        ranged = true,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_PLANT,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能",
        ["标签"] = "莫尔特斯·古木悲鸣",
        ["伤害形态"] = "AOE"
    })
    local after = _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C(state.context, target, cfg["腐败值"])
    if after >= cfg["恐惧阈值"] then
        _____65BD_52A0_6050_60E7(state.context["Boss单位"], target, {["持续时间"] = cfg["恐惧秒"], ["模式"] = "随机乱跑", ["随机半径"] = 450, ["移动速度"] = 50})
    end
end
local function _____53E4_6728_60B2_9E23_5F39_5E55_7ED3_675F(_reason, projectileId)
    __TS__Delete(_____53E4_6728_60B2_9E23_5F39_5E55_72B6_6001_8868, projectileId)
end
local function _____6E05_7406_53E4_6728_60B2_9E23_5F39_5E55(projectileId)
    if type(projectileId) ~= "number" then
        return
    end
    __TS__Delete(_____53E4_6728_60B2_9E23_5F39_5E55_72B6_6001_8868, projectileId)
    _____9500_6BC1_539F_751F_5F39_5E55(projectileId, "手动销毁")
end
local function _____53D1_5C04_53E4_6728_60B2_9E23_5F39_5E55(context, centerX, centerY, direction, mushrooms, hitRecord, _____5B89_5168_533A_72B6_6001)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]
    local projectile = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = context["Boss单位"],
        ["载体模式"] = "单位",
        ["模型"] = cfg["悲鸣特效路径"],
        ["缩放"] = cfg["悲鸣特效缩放"],
        X = centerX,
        Y = centerY,
        ["方向角"] = direction,
        ["速度"] = cfg["弹幕速度"],
        ["生命周期"] = cfg["弹幕生命周期秒"],
        ["最大距离"] = cfg["弹幕最大距离"],
        ["命中半径"] = cfg["弹幕命中半径"],
        ["影响目标"] = "敌方",
        ["每单位最大命中次数"] = 1,
        ["碰撞消失"] = false,
        ["禁用碰撞"] = true,
        ["不可阻挡"] = true,
        ["目标筛选"] = _____53E4_6728_60B2_9E23_76EE_6807_7B5B_9009,
        ["on命中"] = _____53E4_6728_60B2_9E23_5F39_5E55_547D_4E2D,
        ["on结束"] = _____53E4_6728_60B2_9E23_5F39_5E55_7ED3_675F
    })
    local projectileId = projectile["弹幕ID"]
    _____53E4_6728_60B2_9E23_5F39_5E55_72B6_6001_8868[projectileId] = {
        context = context,
        ["中心X"] = centerX,
        ["中心Y"] = centerY,
        ["方向角"] = direction,
        ["蘑菇坐标列表"] = mushrooms,
        ["已命中目标"] = hitRecord,
        ["安全区状态"] = _____5B89_5168_533A_72B6_6001
    }
    local ____self_11 = context["清理"]
    ____self_11["登记清理"](____self_11, "莫尔特斯-古木悲鸣弹幕", _____6E05_7406_53E4_6728_60B2_9E23_5F39_5E55, projectileId)
end
local function _____7ED3_7B97_83AB_5C14_7279_65AF_53E4_6728_60B2_9E23(variable)
    local context = variable
    if context == nil then
        return
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local center = _____8BFB_53D6_53E4_6728_60B2_9E23_4E2D_5FC3(context)
    local mushrooms = _____83B7_53D6_60B2_9E23_8611_83C7_5750_6807(context)
    local hitRecord = {}
    local _____5B89_5168_533A_72B6_6001 = {context = context, ["安全护盾目标"] = {}, ["安全护盾记录列表"] = {}, ["已登记清理"] = false}
    local directions = {0, 90, 180, 270}
    do
        local i = 0
        while i < #directions do
            _____53D1_5C04_53E4_6728_60B2_9E23_5F39_5E55(
                context,
                center.X,
                center.Y,
                directions[i + 1],
                mushrooms,
                hitRecord,
                _____5B89_5168_533A_72B6_6001
            )
            i = i + 1
        end
    end
    local mushroomState = context.__moltesAncientMushroomState
    if mushroomState ~= nil and not mushroomState["已清理"] then
        local mushroomCleanupId = addDelayedCallback(_____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]["技能结束后蘑菇延迟删除秒"] * 1000, _____5EF6_8FDF_6E05_7406_53E4_6728_60B2_9E23_8611_83C7_8868_73B0, mushroomState)
        local ____self_12 = context["清理"]
        ____self_12["登记延迟回调"](____self_12, "莫尔特斯-古木悲鸣蘑菇延迟删除", mushroomCleanupId)
    end
    _____64AD_653EBoss_5750_6807_97F3_6548(_____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["古木悲鸣"]["悲鸣波"], center.X, center.Y, _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["标识"],
        ["音效路径列表"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["音效路径列表"],
        X = center.X,
        Y = center.Y,
        ["裁断距离"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"],
        ["冷却Ms"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["关键机制触发概率百分比"]
    })
end
local function _____786E_4FDD_60B2_9E23_8611_83C7_8868_73B0(context)
    local grid = context["根须宫格"]
    if grid == nil then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]
    local center = _____8BFB_53D6_53E4_6728_60B2_9E23_4E2D_5FC3(context)
    local state = context
    local previous = state.__moltesAncientMushroomState
    if previous ~= nil then
        _____6E05_7406_53E4_6728_60B2_9E23_8611_83C7_8868_73B0(previous)
    end
    local selectedCells = _____9009_62E9_60B2_9E23_8611_83C7_683C_5B50(grid)
    local mushroomState = {["特效列表"] = {}, ["格子列表"] = selectedCells, ["已清理"] = false}
    state.__moltesAncientMushroomState = mushroomState
    local ____self_13 = context["清理"]
    ____self_13["登记清理"](____self_13, "莫尔特斯-古木悲鸣蘑菇", _____6E05_7406_53E4_6728_60B2_9E23_8611_83C7_8868_73B0, mushroomState)
    do
        local i = 0
        while i < #selectedCells do
            local cell = selectedCells[i + 1]
            local effect = AddSpecialEffect(cfg["巨型蘑菇模型列表"][i + 1], cell.X, cell.Y)
            _____8BBE_7F6E_7279_6548_7F29_653E(effect, cfg["巨型蘑菇缩放"])
            local ____mushroomState__7279_6548_5217_8868_14 = mushroomState["特效列表"]
            ____mushroomState__7279_6548_5217_8868_14[#____mushroomState__7279_6548_5217_8868_14 + 1] = effect
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "白色安全圆",
                X = cell.X,
                Y = cell.Y,
                ["半径"] = cfg["蘑菇遮挡半径"],
                ["持续时间"] = cfg["动作播放秒"]
            })
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "白色扇形",
                X = cell.X,
                Y = cell.Y,
                ["半径"] = cfg["蘑菇安全扇形半径"],
                ["扇形角度"] = cfg["蘑菇遮挡角度"] * 2,
                ["朝向"] = _____53D6_5750_6807_89D2_5EA6(center.X, center.Y, cell.X, cell.Y),
                ["持续时间"] = cfg["动作播放秒"]
            })
            i = i + 1
        end
    end
end
____exports["释放莫尔特斯古木悲鸣"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]
    _____5F00_59CB_83AB_5C14_7279_65AF_5927_62DB_65BD_6CD5(boss, cfg["动作播放秒"], "古木悲鸣", "站到巨型蘑菇背向莫尔特斯的一侧，让蘑菇挡在你与Boss之间")
    _____64AD_653E_83AB_5C14_7279_65AF_9650_65F6_52A8_4F5C(boss, cfg["动画编号"], cfg["动画速度"], cfg["动作播放秒"])
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(boss, "古木悲鸣")
    _____786E_4FDD_83AB_5C14_7279_65AF_6839_987B_5BAB_683C(context)
    _____786E_4FDD_60B2_9E23_8611_83C7_8868_73B0(context)
    local delayedId = addDelayedCallback(cfg["动作播放秒"] * 1000, _____7ED3_7B97_83AB_5C14_7279_65AF_53E4_6728_60B2_9E23, context)
    local ____self_15 = context["清理"]
    ____self_15["登记延迟回调"](____self_15, "莫尔特斯-古木悲鸣结算", delayedId)
end
local function ____on_83AB_5C14_7279_65AF_53E4_6728_60B2_9E23_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____53E4_6728_60B2_9E23_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放莫尔特斯古木悲鸣"](context)
end
____exports["注册莫尔特斯古木悲鸣"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "11．古木悲鸣",
        ["单位类型ID"] = _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____53E4_6728_60B2_9E23_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_83AB_5C14_7279_65AF_53E4_6728_60B2_9E23_65BD_6CD5(boss, _____53E4_6728_60B2_9E23_6280_80FDID)
        end
    })
end
return ____exports
