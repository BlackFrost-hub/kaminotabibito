--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["开始祖地双灵卫常规施法"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____8DDD_79BBXY = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离XY"]
local _____9650_5236_6570_503C = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["限制数值"]
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local _____77E9_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.矩形区域")
local _____83B7_53D6_6761_5F62_533A_57DF_5355_4F4D = _____77E9_5F62_533A_57DF["获取条形区域单位"]
local ____03_FF0E_7279_6548 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____03_FF0E_7279_6548["创建点特效"]
local _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C = ____03_FF0E_7279_6548["设置特效XYZ轴旋转"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51B2_950B = ____require_result_1["开始冲锋"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local getServerTime = ____require_result_2.getServerTime
local jass = require("jass.common")
local japi = require("jass.japi")
local DzSetEffectVertexAlpha = japi.DzSetEffectVertexAlpha
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH
local function _____6E05_9664_5F53_524D_8A93_76FE(context)
    local shield = context["誓盾"]
    if (shield and shield["特效"]) ~= nil and shield["特效"] ~= 0 then
        DestroyEffect(shield["特效"])
        shield["特效"] = nil
    end
    context["誓盾"] = nil
end
local function _____8BA1_7B97_573A_5185_63A8_8FDB_8DDD_79BB(context, x, y, facing)
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P1["誓锋壁进"]
    local fieldLimit = (context["场地半宽"] >= context["场地半高"] and context["场地半宽"] * 2 or context["场地半高"] * 2) * cfg["最大推进场地比例"]
    local distance = cfg["最大推进距离"] < fieldLimit and cfg["最大推进距离"] or fieldLimit
    local targetX = _____6781_5750_6807X(x, facing, distance)
    local targetY = _____6781_5750_6807Y(y, facing, distance)
    local clampedX = _____9650_5236_6570_503C(targetX, context["场地中心X"] - context["场地半宽"] + 64, context["场地中心X"] + context["场地半宽"] - 64)
    local clampedY = _____9650_5236_6570_503C(targetY, context["场地中心Y"] - context["场地半高"] + 64, context["场地中心Y"] + context["场地半高"] - 64)
    distance = _____8DDD_79BBXY(x, y, clampedX, clampedY)
    return distance
end
local function _____7ED3_7B97_58C1_8FDB_8DEF_5F84(context, boss, startX, startY, endX, endY)
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P1["誓锋壁进"]
    local targets = _____83B7_53D6_6761_5F62_533A_57DF_5355_4F4D({
        ["起点X"] = startX,
        ["起点Y"] = startY,
        ["终点X"] = endX,
        ["终点Y"] = endY,
        ["宽度"] = cfg["路径宽度"]
    })
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____5355_4F4D_6709_6548(target) or target == boss or IsUnitEnemy(
                    target,
                    GetOwningPlayer(boss)
                ) ~= true then
                    goto __continue7
                end
                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = target,
                    ["伤害公式"] = {["来源攻击力比例"] = cfg["伤害攻击力比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"]},
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_METAL_HEAVY_BASH,
                    ["标签"] = "祖地双灵卫·誓锋壁进"
                })
            end
            ::__continue7::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_7EC8_70B9_8A93_76FE(context, boss, facing)
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P1["誓锋壁进"]
    _____6E05_9664_5F53_524D_8A93_76FE(context)
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local effect = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["誓锋壁进"]["定向誓盾特效路径"], x, y)
    if effect ~= nil and effect ~= 0 then
        _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C(effect, {["Z轴角度"] = facing})
    end
    local shield = {
        X = x,
        Y = y,
        ["朝向"] = facing,
        ["到期Ms"] = getServerTime() + cfg["誓盾持续秒"] * 1000,
        ["特效"] = effect
    }
    context["誓盾"] = shield
    addDelayedCallback(
        500,
        function()
            if shield["特效"] ~= nil and shield["特效"] ~= 0 then
                DzSetEffectVertexAlpha(shield["特效"], 0)
            end
        end
    )
    local ____self_5 = context["清理"]
    ____self_5["登记清理"](
        ____self_5,
        "祖地双灵卫-誓盾特效",
        function()
            if shield["特效"] ~= nil and shield["特效"] ~= 0 then
                DestroyEffect(shield["特效"])
                shield["特效"] = nil
            end
        end
    )
    local expireId = addDelayedCallback(
        cfg["誓盾持续秒"] * 1000,
        function()
            if context["誓盾"] ~= shield then
                return
            end
            _____6E05_9664_5F53_524D_8A93_76FE(context)
        end
    )
    local ____self_6 = context["清理"]
    ____self_6["登记延迟回调"](____self_6, "祖地双灵卫-誓盾到期", expireId)
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["举盾动画编号"], ["持续秒"] = cfg["誓盾持续秒"], ["恢复动画编号"] = cfg["恢复动画编号"]})
end
____exports["释放誓锋壁进"] = function(context, target)
    local boss = context["苍影灵卫单位"]
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["赤誓盾锋"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["战斗已结束"] then
        return false
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P1["誓锋壁进"]
    local startX = GetUnitX(boss)
    local startY = GetUnitY(boss)
    local facing = _____4E24_70B9_89D2_5EA6(
        startX,
        startY,
        GetUnitX(target),
        GetUnitY(target)
    )
    local distance = _____8BA1_7B97_573A_5185_63A8_8FDB_8DDD_79BB(context, startX, startY, facing)
    if distance <= 32 then
        return false
    end
    context["大型机制忙碌到Ms"] = getServerTime() + (cfg["前摇秒"] + cfg["推进秒"] + cfg["誓盾持续秒"]) * 1000
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(boss, facing)
    _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5(boss, cfg["前摇秒"], "誓锋壁进", "苍影灵卫将沿锁定方向冲锋并展开誓盾")
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = startX,
        Y = startY,
        ["宽度"] = cfg["路径宽度"],
        ["长度"] = distance,
        ["朝向"] = facing,
        ["持续时间"] = cfg["前摇秒"],
        ["来源单位"] = boss
    })
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = cfg["前摇秒"] + cfg["推进秒"], ["恢复动画编号"] = cfg["举盾动画编号"]})
    local startId = addDelayedCallback(
        cfg["前摇秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                return
            end
            local moveId = _____5F00_59CB_51B2_950B(
                boss,
                {
                    ["角度"] = facing,
                    ["距离"] = distance,
                    ["持续时间"] = cfg["推进秒"],
                    ["检查地形"] = true,
                    ["朝向跟随位移"] = true,
                    ["暂停单位"] = true,
                    ["禁用碰撞"] = true,
                    ["位移特效"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["誓锋壁进"]["推进拖尾特效路径"],
                    ["结束回调"] = function()
                        if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                            return
                        end
                        local endX = GetUnitX(boss)
                        local endY = GetUnitY(boss)
                        _____7ED3_7B97_58C1_8FDB_8DEF_5F84(
                            context,
                            boss,
                            startX,
                            startY,
                            endX,
                            endY
                        )
                        _____521B_5EFA_70B9_7279_6548({
                            ["模型路径"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["誓锋壁进"]["冲锋命中特效路径"],
                            X = endX,
                            Y = endY,
                            ["缩放"] = 5,
                            ["动画索引"] = 0,
                            ["持续秒"] = 0.8
                        })
                        _____521B_5EFA_7EC8_70B9_8A93_76FE(context, boss, facing)
                    end
                }
            )
            if moveId <= 0 then
                _____521B_5EFA_7EC8_70B9_8A93_76FE(context, boss, facing)
            end
        end
    )
    local ____self_7 = context["清理"]
    ____self_7["登记延迟回调"](____self_7, "祖地双灵卫-誓锋壁进前摇", startId)
    return true
end
____exports["誓锋壁进技能状态"] = {
    ["所属守卫"] = "苍影灵卫",
    ["所属形态"] = "正常",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["需要独立技能实例ID"] = false,
    ["包含战斗自身位移"] = true,
    ["实现要求"] = "短冲锋走公共冲锋；路径只结算一次，并把终点定向誓盾写入共享上下文。"
}
return ____exports
