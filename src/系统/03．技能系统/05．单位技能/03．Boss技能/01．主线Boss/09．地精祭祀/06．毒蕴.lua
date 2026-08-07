local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.00．配置")
local _____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["地精祭祀单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5730_7CBE_796D_7940_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建地精祭祀上下文"]
local _____83B7_53D6_5730_7CBE_796D_7940_8303_56F4_76EE_6807 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取地精祭祀范围目标"]
local _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["地精祭祀单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.02．数值与表现配置")
local _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["地精祭祀技能配置"]
local ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382["创建技能提示圈"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local _____63D0_4EA4_9884_8BA1_7B97BossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["提交预计算BossAOE技能伤害"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_1["开始硬直"]
local ____require_result_2 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_2["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_2["关闭吟唱条"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_4.EC_CreateEffect
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
local jass = require("jass.common")
local globals = require("jass.globals")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_6 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_6.CosBJ
local SinBJ = ____require_result_6.SinBJ
local GetRandomReal = jass.GetRandomReal
local SetUnitAnimation = jass.SetUnitAnimation
local StartSound = jass.StartSound
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local DAMAGE_TYPE_ACID = jass.DAMAGE_TYPE_ACID
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5730_7CBE_796D_7940_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6BD2_8574_6280_80FDID = stringToFourCCSafe(_____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["毒蕴"])
local _____5730_7CBE_796D_7940_6BD2_8574_5DF2_6CE8_518C = false
local function _____64AD_653E_6BD2_8574_70B9_7279_6548(_____7279_6548, x, y)
    EC_CreateEffect(
        _____7279_6548["路径"],
        x,
        y,
        _____7279_6548.Z,
        _____7279_6548["朝向"],
        _____7279_6548["缩放"],
        _____7279_6548["动画速度"],
        _____7279_6548["持续秒"]
    )
end
local function _____8BFB_53D6_5F53_524D_96BE_5EA6N()
    local _____96BE_5EA6 = __TS__Number(globals.udg_N)
    return _____96BE_5EA6 == _____96BE_5EA6 and _____96BE_5EA6 > 0 and _____96BE_5EA6 or 0
end
local function ____on_6BD2_8574_8BFB_6761_7ED3_675F()
    _____5173_95ED_541F_5531_6761(_____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["毒蕴"]["读条通道"])
end
local function ____on_6BD2_8574_843D_70B9_7ED3_7B97(variable)
    local _____5FEB_7167 = variable
    if _____5FEB_7167 == nil or not _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B(_____5FEB_7167["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____5FEB_7167["上下文"]["Boss单位"]
    local _____914D_7F6E = _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["毒蕴"]
    _____64AD_653E_6BD2_8574_70B9_7279_6548(_____914D_7F6E["爆炸特效"], _____5FEB_7167.X, _____5FEB_7167.Y)
    local _____76EE_6807_5217_8868 = _____83B7_53D6_5730_7CBE_796D_7940_8303_56F4_76EE_6807(
        boss,
        _____5FEB_7167.X,
        _____5FEB_7167.Y,
        _____914D_7F6E["作用半径"],
        _____914D_7F6E["最大飞行高度"]
    )
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            local _____76EE_6807 = _____76EE_6807_5217_8868[i + 1]
            if _____5FEB_7167["伤害分支"] == "暗伤" then
                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = _____76EE_6807,
                    ["技能ID"] = _____6BD2_8574_6280_80FDID,
                    ["伤害公式"] = {["来源攻击力比例"] = _____914D_7F6E["Boss攻击力比例"]},
                    attack = true,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["标签"] = "地精祭祀·毒蕴·暗伤"
                })
            else
                _____63D0_4EA4_9884_8BA1_7B97BossAOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = _____76EE_6807,
                    ["技能ID"] = _____6BD2_8574_6280_80FDID,
                    ["伤害"] = _____914D_7F6E["酸性基础伤害"] + _____914D_7F6E["酸性每难度N伤害"] * _____8BFB_53D6_5F53_524D_96BE_5EA6N(),
                    attack = true,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_ACID,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["标签"] = "地精祭祀·毒蕴·酸伤"
                })
            end
            i = i + 1
        end
    end
end
local function _____8BA1_7B97_6BD2_8574_70B9_8DDD_79BB_5E73_65B9(ax, ay, bx, by)
    local dx = ax - bx
    local dy = ay - by
    return dx * dx + dy * dy
end
local function _____8BA1_7B97_6BD2_8574_5019_9009_70B9_6700_5C0F_8DDD_79BB_5E73_65B9(_____5DF2_6709_843D_70B9, x, y)
    if #_____5DF2_6709_843D_70B9 <= 0 then
        return 999999999
    end
    local _____6700_5C0F_8DDD_79BB_5E73_65B9 = 999999999
    do
        local i = 0
        while i < #_____5DF2_6709_843D_70B9 do
            local _____843D_70B9 = _____5DF2_6709_843D_70B9[i + 1]
            local _____8DDD_79BB_5E73_65B9 = _____8BA1_7B97_6BD2_8574_70B9_8DDD_79BB_5E73_65B9(x, y, _____843D_70B9.X, _____843D_70B9.Y)
            if _____8DDD_79BB_5E73_65B9 < _____6700_5C0F_8DDD_79BB_5E73_65B9 then
                _____6700_5C0F_8DDD_79BB_5E73_65B9 = _____8DDD_79BB_5E73_65B9
            end
            i = i + 1
        end
    end
    return _____6700_5C0F_8DDD_79BB_5E73_65B9
end
local function _____751F_6210_6BD2_8574_5706_5185_5019_9009_70B9(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____534A_5F84)
    local _____534A_5F84_5E73_65B9 = _____534A_5F84 * _____534A_5F84
    do
        local i = 0
        while i < 64 do
            local _____504F_79FBX = GetRandomReal(-_____534A_5F84, _____534A_5F84)
            local _____504F_79FBY = GetRandomReal(-_____534A_5F84, _____534A_5F84)
            if _____504F_79FBX * _____504F_79FBX + _____504F_79FBY * _____504F_79FBY <= _____534A_5F84_5E73_65B9 then
                return {X = _____4E2D_5FC3X + _____504F_79FBX, Y = _____4E2D_5FC3Y + _____504F_79FBY}
            end
            i = i + 1
        end
    end
    local _____5907_7528_89D2_5EA6 = GetRandomReal(0, 360)
    return {
        X = _____4E2D_5FC3X + CosBJ(_____5907_7528_89D2_5EA6) * _____534A_5F84,
        Y = _____4E2D_5FC3Y + SinBJ(_____5907_7528_89D2_5EA6) * _____534A_5F84
    }
end
local function _____751F_6210_6BD2_8574_4E0D_91CD_590D_843D_70B9(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____5DF2_6709_843D_70B9)
    local _____914D_7F6E = _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["毒蕴"]
    local _____6700_5C0F_8DDD_79BB = _____914D_7F6E["最小落点间距"]
    local _____6700_5C0F_8DDD_79BB_5E73_65B9 = _____6700_5C0F_8DDD_79BB * _____6700_5C0F_8DDD_79BB
    local _____6700_5927_5C1D_8BD5_6B21_6570 = _____914D_7F6E["随机取点最大尝试次数"]
    local _____6700_4F73_843D_70B9 = _____751F_6210_6BD2_8574_5706_5185_5019_9009_70B9(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____914D_7F6E["随机落点半径"])
    local _____6700_4F73_8DDD_79BB_5E73_65B9 = _____8BA1_7B97_6BD2_8574_5019_9009_70B9_6700_5C0F_8DDD_79BB_5E73_65B9(_____5DF2_6709_843D_70B9, _____6700_4F73_843D_70B9.X, _____6700_4F73_843D_70B9.Y)
    do
        local i = 1
        while i < _____6700_5927_5C1D_8BD5_6B21_6570 do
            local _____5019_9009_843D_70B9 = _____751F_6210_6BD2_8574_5706_5185_5019_9009_70B9(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____914D_7F6E["随机落点半径"])
            local _____5019_9009_8DDD_79BB_5E73_65B9 = _____8BA1_7B97_6BD2_8574_5019_9009_70B9_6700_5C0F_8DDD_79BB_5E73_65B9(_____5DF2_6709_843D_70B9, _____5019_9009_843D_70B9.X, _____5019_9009_843D_70B9.Y)
            if _____5019_9009_8DDD_79BB_5E73_65B9 >= _____6700_5C0F_8DDD_79BB_5E73_65B9 then
                return _____5019_9009_843D_70B9
            end
            if _____5019_9009_8DDD_79BB_5E73_65B9 > _____6700_4F73_8DDD_79BB_5E73_65B9 then
                _____6700_4F73_843D_70B9 = _____5019_9009_843D_70B9
                _____6700_4F73_8DDD_79BB_5E73_65B9 = _____5019_9009_8DDD_79BB_5E73_65B9
            end
            i = i + 1
        end
    end
    return _____6700_4F73_843D_70B9
end
local function _____521B_5EFA_6BD2_8574_968F_673A_843D_70B9(_____4E0A_4E0B_6587, _____4E2D_5FC3X, _____4E2D_5FC3Y)
    local _____914D_7F6E = _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["毒蕴"]
    local _____5DF2_6709_843D_70B9 = {}
    local _____603B_843D_70B9_6570 = _____914D_7F6E["暗伤落点数"] + _____914D_7F6E["酸伤落点数"]
    do
        local i = 1
        while i <= _____603B_843D_70B9_6570 do
            local _____843D_70B9 = _____751F_6210_6BD2_8574_4E0D_91CD_590D_843D_70B9(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____5DF2_6709_843D_70B9)
            _____5DF2_6709_843D_70B9[#_____5DF2_6709_843D_70B9 + 1] = _____843D_70B9
            local _____4F24_5BB3_5206_652F = i <= _____914D_7F6E["暗伤落点数"] and "暗伤" or "酸伤"
            local _____5FEB_7167 = {
                ["上下文"] = _____4E0A_4E0B_6587,
                X = _____843D_70B9.X,
                Y = _____843D_70B9.Y,
                ["序号"] = i,
                ["伤害分支"] = _____4F24_5BB3_5206_652F
            }
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "敌方圆形",
                X = _____843D_70B9.X,
                Y = _____843D_70B9.Y,
                ["半径"] = _____914D_7F6E["作用半径"],
                ["持续时间"] = _____914D_7F6E["预警秒"],
                ["来源单位"] = _____4E0A_4E0B_6587["Boss单位"]
            })
            _____64AD_653E_6BD2_8574_70B9_7279_6548(_____914D_7F6E["预警特效"], _____843D_70B9.X, _____843D_70B9.Y)
            local _____56DE_8C03ID = addDelayedCallback(_____914D_7F6E["预警秒"] * 1000, ____on_6BD2_8574_843D_70B9_7ED3_7B97, _____5FEB_7167)
            local ____self_7 = _____4E0A_4E0B_6587["清理"]
            ____self_7["登记延迟回调"](____self_7, "地精祭祀-毒蕴落点结算", _____56DE_8C03ID)
            i = i + 1
        end
    end
end
____exports["释放地精祭祀毒蕴"] = function(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B(boss) then
        return false
    end
    local _____914D_7F6E = _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["毒蕴"]
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    _____5F00_59CB_786C_76F4(boss, _____914D_7F6E["施法硬直秒"])
    SetUnitAnimation(boss, _____914D_7F6E["动作名称"])
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____914D_7F6E["施法硬直秒"],
        ["颜色ID"] = _____914D_7F6E["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
    local _____97F3_6548 = globals[_____914D_7F6E["音效全局变量名"]]
    if _____97F3_6548 ~= nil and _____97F3_6548 ~= 0 then
        StartSound(_____97F3_6548)
    end
    _____521B_5EFA_6BD2_8574_968F_673A_843D_70B9(_____4E0A_4E0B_6587, bossX, bossY)
    local _____8BFB_6761_56DE_8C03ID = addDelayedCallback(_____914D_7F6E["施法硬直秒"] * 1000, ____on_6BD2_8574_8BFB_6761_7ED3_675F)
    local ____self_10 = _____4E0A_4E0B_6587["清理"]
    ____self_10["登记延迟回调"](____self_10, "地精祭祀-毒蕴读条结束", _____8BFB_6761_56DE_8C03ID)
    return true
end
local function ____on_5730_7CBE_796D_7940_6BD2_8574_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6BD2_8574_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____5730_7CBE_796D_7940_5355_4F4D_7C7B_578BID then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_5730_7CBE_796D_7940_4E0A_4E0B_6587(castingUnit)
    if _____4E0A_4E0B_6587 ~= nil then
        ____exports["释放地精祭祀毒蕴"](_____4E0A_4E0B_6587)
    end
end
____exports["注册地精祭祀毒蕴"] = function()
    if _____5730_7CBE_796D_7940_6BD2_8574_5DF2_6CE8_518C then
        return
    end
    _____5730_7CBE_796D_7940_6BD2_8574_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_5730_7CBE_796D_7940_6BD2_8574_751F_6548)
end
return ____exports
