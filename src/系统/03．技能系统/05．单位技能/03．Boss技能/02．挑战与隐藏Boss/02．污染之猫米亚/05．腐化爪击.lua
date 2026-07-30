--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____64AD_653E_722A_51FB_8868_73B0, _____64AD_653E_722A_51FB_52A8_4F5C, _____521B_5EFA_8150_5316_722A_51FB_6B8B_7559_533A, _____7ED3_7B97_7C73_4E9A_8150_5316_722A_51FB, _____7ED3_7B97_7C73_4E9A_8150_5316_722A_51FB_8DF3_8DC3, _____5F00_59CB_7C73_4E9A_8150_5316_722A_51FB_8DF3_8DC3, ____on_7C73_4E9A_8150_5316_722A_51FB_751F_6548, _____521B_5EFA_70B9_7279_6548, _____521B_5EFA_6301_7EED_5371_9669_533A_57DF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, addDelayedCallback, jass, GetUnitTypeId, GetSpellTargetUnit, GetUnitX, GetUnitY, SetUnitFacing, SetUnitAnimationByIndex, SetUnitTimeScale, Atan2, SquareRoot, GetRandomReal, BJ_RADTODEG, _____7C73_4E9A_5355_4F4D_7C7B_578BID, _____8150_5316_722A_51FB_6280_80FDID, _____7C73_4E9A_8150_5316_722A_51FB_8DF3_8DC3_6570_636E_8868
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建米亚上下文"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local _____7C73_4E9A_8FD0_884C_65F6_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚运行时配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____19_FF0E_65BD_6CD5_63D0_793A = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.19．施法提示")
local _____5F00_59CB_7C73_4E9A_5E38_89C4_65BD_6CD5 = ____19_FF0E_65BD_6CD5_63D0_793A["开始米亚常规施法"]
local ____08_FF0E_6C61_67D3_6807_8BB0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.08．污染标记")
local _____53D6_7C73_4E9A_6C61_67D3_6807_8BB0_4F24_5BB3_500D_7387 = ____08_FF0E_6C61_67D3_6807_8BB0["取米亚污染标记伤害倍率"]
local ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.12．平台超载惩罚")
local _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387 = ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A["取米亚平台超载伤害倍率"]
local ____03_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口")
local _____5F00_59CB_8DF3_8DC3 = ____03_FF0E_5BF9_5916_63A5_53E3["开始跳跃"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____64AD_653E_722A_51FB_8868_73B0(boss, x, y)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化爪击"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = config["命中特效路径"],
        X = x,
        Y = y,
        ["缩放"] = config["命中特效缩放"],
        ["持续秒"] = config["命中特效持续秒"]
    })
    _____64AD_653E_722A_51FB_52A8_4F5C(boss)
end
function _____64AD_653E_722A_51FB_52A8_4F5C(boss)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化爪击"]
    SetUnitTimeScale(boss, config["动画速度"])
    SetUnitAnimationByIndex(boss, config["动画编号"])
end
function _____521B_5EFA_8150_5316_722A_51FB_6B8B_7559_533A(context, x, y)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化爪击"]
    _____521B_5EFA_6301_7EED_5371_9669_533A_57DF({
        X = x,
        Y = y,
        ["半径"] = config["残留半径"],
        ["持续时间"] = config["残留持续秒"],
        ["检测间隔"] = 1,
        ["影响目标"] = "敌方",
        ["所有者"] = context["Boss单位"],
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["腐化残留云"],
        ["特效高度"] = 0,
        ["提示圈"] = {["类型"] = "敌方圆形"},
        ["on周期"] = function(_____533A_57DF_5185_5355_4F4D)
            do
                local i = 0
                while i < #_____533A_57DF_5185_5355_4F4D do
                    _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, _____533A_57DF_5185_5355_4F4D[i + 1], config["残留每秒腐化层数"], "腐化爪击残留")
                    i = i + 1
                end
            end
        end
    })
end
function _____7ED3_7B97_7C73_4E9A_8150_5316_722A_51FB(variable)
    local data = variable
    if data == nil then
        return
    end
    local context = data.context
    local boss = context["Boss单位"]
    local actualTarget = data.target
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化爪击"]
    SetUnitFacing(boss, data["朝向"])
    local landingX = GetUnitX(boss)
    local landingY = GetUnitY(boss)
    _____64AD_653E_722A_51FB_8868_73B0(boss, landingX, landingY)
    if _____5355_4F4D_6709_6548(actualTarget) then
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["技能ID"] = _____8150_5316_722A_51FB_6280_80FDID,
            ["来源"] = boss,
            ["目标"] = actualTarget,
            ["伤害"] = (_____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) or _____7C73_4E9A_8FD0_884C_65F6_914D_7F6E["Boss攻击力兜底"]) * config["攻击力倍率"] * _____53D6_7C73_4E9A_6C61_67D3_6807_8BB0_4F24_5BB3_500D_7387(context, actualTarget) * _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387(actualTarget),
            attackType = jass.ATTACK_TYPE_NORMAL,
            ["伤害类型"] = jass.DAMAGE_TYPE_POISON,
            weaponType = jass.WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "Boss技能"
        })
        _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, actualTarget, config["残留每秒腐化层数"], "腐化爪击")
    end
    _____521B_5EFA_8150_5316_722A_51FB_6B8B_7559_533A(context, landingX, landingY)
end
function _____7ED3_7B97_7C73_4E9A_8150_5316_722A_51FB_8DF3_8DC3(_unit, reason, jumpId)
    local data = _____7C73_4E9A_8150_5316_722A_51FB_8DF3_8DC3_6570_636E_8868[jumpId]
    _____7C73_4E9A_8150_5316_722A_51FB_8DF3_8DC3_6570_636E_8868[jumpId] = nil
    if data == nil or reason ~= "完成" then
        return
    end
    _____7ED3_7B97_7C73_4E9A_8150_5316_722A_51FB(data)
end
function _____5F00_59CB_7C73_4E9A_8150_5316_722A_51FB_8DF3_8DC3(variable)
    local data = variable
    if data == nil then
        return
    end
    local boss = data.context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    _____64AD_653E_722A_51FB_52A8_4F5C(boss)
    local jumpId = _____5F00_59CB_8DF3_8DC3(boss, {
        ["目标X"] = data["落点X"],
        ["目标Y"] = data["落点Y"],
        ["距离"] = data["距离"],
        ["持续时间"] = data["跳跃持续秒"],
        ["跳跃高度"] = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化爪击"]["跳跃高度"],
        ["暂停单位"] = true,
        ["朝向跟随跳跃"] = true,
        ["跳跃特效"] = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化爪击"]["跳跃特效路径"],
        ["主单位"] = boss,
        ["主单位死亡时中断"] = true,
        ["结束回调"] = _____7ED3_7B97_7C73_4E9A_8150_5316_722A_51FB_8DF3_8DC3
    })
    if jumpId > 0 then
        _____7C73_4E9A_8150_5316_722A_51FB_8DF3_8DC3_6570_636E_8868[jumpId] = data
    end
end
____exports["释放米亚腐化爪击"] = function(context, target)
    local boss = context["Boss单位"]
    local actualTarget = target
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(actualTarget) then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化爪击"]
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "腐化爪击")
    local startX = GetUnitX(boss)
    local startY = GetUnitY(boss)
    local targetX = GetUnitX(actualTarget)
    local targetY = GetUnitY(actualTarget)
    local dx = targetX - startX
    local dy = targetY - startY
    local rawDistance = SquareRoot(dx * dx + dy * dy)
    if not (rawDistance > 1) then
        return
    end
    local distance = rawDistance > config["跳跃最大距离"] and config["跳跃最大距离"] or rawDistance
    local ratio = distance / rawDistance
    local landingX = startX + dx * ratio
    local landingY = startY + dy * ratio
    local facing = Atan2(dy, dx) * BJ_RADTODEG
    local jumpDuration = GetRandomReal(config["跳跃最短秒"], config["跳跃最长秒"])
    SetUnitFacing(boss, facing)
    _____5F00_59CB_7C73_4E9A_5E38_89C4_65BD_6CD5(boss, config["前摇秒"], "腐化爪击", "米亚锁定目标准备扑击")
    SetUnitTimeScale(boss, 1)
    SetUnitAnimationByIndex(boss, config["前摇动画编号"])
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = startX,
        Y = startY,
        ["宽度"] = config["扑击路径宽度"],
        ["长度"] = distance,
        ["朝向"] = facing,
        ["持续时间"] = config["前摇秒"],
        ["来源单位"] = boss
    })
    local delayedId = addDelayedCallback(config["前摇秒"] * 1000, _____5F00_59CB_7C73_4E9A_8150_5316_722A_51FB_8DF3_8DC3, {
        context = context,
        target = actualTarget,
        ["落点X"] = landingX,
        ["落点Y"] = landingY,
        ["朝向"] = facing,
        ["距离"] = distance,
        ["跳跃持续秒"] = jumpDuration
    })
    local ____self_6 = context["清理"]
    ____self_6["登记延迟回调"](____self_6, "米亚-腐化爪击结算", delayedId)
end
function ____on_7C73_4E9A_8150_5316_722A_51FB_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____8150_5316_722A_51FB_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____7C73_4E9A_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放米亚腐化爪击"](
        context,
        GetSpellTargetUnit()
    )
end
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_0["创建点特效"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域")
_____521B_5EFA_6301_7EED_5371_9669_533A_57DF = ____require_result_1["创建持续危险区域"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_3["造成单体技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_5.addDelayedCallback
jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
SetUnitFacing = jass.SetUnitFacing
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitTimeScale = jass.SetUnitTimeScale
Atan2 = jass.Atan2
SquareRoot = jass.SquareRoot
GetRandomReal = jass.GetRandomReal
BJ_RADTODEG = 57.29577951308232
_____7C73_4E9A_5355_4F4D_7C7B_578BID = stringToFourCC(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["Boss单位ID"])
_____8150_5316_722A_51FB_6280_80FDID = stringToFourCC(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["腐化爪击技能"])
local _____7C73_4E9A_8150_5316_722A_51FB_5DF2_6CE8_518C = false
_____7C73_4E9A_8150_5316_722A_51FB_8DF3_8DC3_6570_636E_8868 = {}
____exports["注册米亚腐化爪击"] = function()
    if _____7C73_4E9A_8150_5316_722A_51FB_5DF2_6CE8_518C then
        return
    end
    _____7C73_4E9A_8150_5316_722A_51FB_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "米亚-腐化爪击",
        ["单位类型ID"] = _____7C73_4E9A_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8150_5316_722A_51FB_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_7C73_4E9A_8150_5316_722A_51FB_751F_6548(boss, _____8150_5316_722A_51FB_6280_80FDID)
        end
    })
end
return ____exports
