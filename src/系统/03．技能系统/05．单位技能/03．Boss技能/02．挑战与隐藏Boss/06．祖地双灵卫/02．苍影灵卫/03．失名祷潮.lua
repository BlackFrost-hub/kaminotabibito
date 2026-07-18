--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["点到线段距离平方"]
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local _____77E9_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.矩形区域")
local _____5355_4F4D_662F_5426_5728_6761_5F62_533A_57DF = _____77E9_5F62_533A_57DF["单位是否在条形区域"]
local ____03_FF0E_7279_6548 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____03_FF0E_7279_6548.createTimedEffect
local _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C = ____03_FF0E_7279_6548["设置特效XYZ轴旋转"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.12．台词播放")
local _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放苍影灵卫台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.01．牵引系统.03．对外接口")
local _____5F00_59CB_7275_5F15 = ____require_result_2["开始牵引"]
local _____505C_6B62_7275_5F15 = ____require_result_2["停止牵引"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成AOE技能伤害"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local getServerTime = ____require_result_4.getServerTime
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local DestroyEffect = jass.DestroyEffect
local ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local function _____53D6_7977_6F6E_76EE_6807_5217_8868(boss, target)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return heroes
    end
    local result = {target}
    do
        local i = 0
        while i < #heroes do
            if heroes[i + 1] ~= target then
                result[#result + 1] = heroes[i + 1]
            end
            i = i + 1
        end
    end
    return result
end
local function _____6D88_8017_9547_9B42_5370_5E76_538B_5236(context, boss)
    local seal = context["镇魂印"]
    if (seal and seal["特效"]) ~= nil and seal["特效"] ~= 0 then
        DestroyEffect(seal["特效"])
        seal["特效"] = nil
    end
    context["镇魂印"] = nil
    _____5F00_59CB_786C_76F4(boss, _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["失名祷潮"]["压制硬直秒"])
    createTimedEffect(
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["失名祷潮"]["断线与挡潮特效路径"],
        seal and seal.X or GetUnitX(boss),
        seal and seal.Y or GetUnitY(boss),
        0,
        1
    )
end
local function _____51C0_5316_6821_51C6_8282_70B9(context, node)
    if node["阶段"] ~= "校准" then
        return
    end
    node["阶段"] = "已净化"
    node["校准截止Ms"] = 0
    context["已净化节点数量"] = context["已净化节点数量"] + 1
    context["当前净化节点序号"] = node["序号"]
    if context["P3共鸣层数"] > 0 then
        context["P3共鸣层数"] = context["P3共鸣层数"] - 1
    end
    local stun = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化成功硬直秒"]
    if _____5355_4F4D_6709_6548(context["赤誓灵卫单位"]) then
        _____5F00_59CB_786C_76F4(context["赤誓灵卫单位"], stun)
    end
    if _____5355_4F4D_6709_6548(context["苍影灵卫单位"]) then
        _____5F00_59CB_786C_76F4(context["苍影灵卫单位"], stun)
    end
    createTimedEffect(
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["双钥净化"]["节点净化完成特效路径"],
        node.X,
        node.Y,
        0,
        1.4
    )
end
local function _____68C0_67E5_7977_6F6E_7A7F_8FC7_6821_51C6_8282_70B9(context, startX, startY, endX, endY)
    local radius = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["节点判定半径"] + _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["失名祷潮"]["宽度"] * 0.5
    do
        local i = 0
        while i < #context["净化节点列表"] do
            do
                local node = context["净化节点列表"][i + 1]
                if node["序号"] ~= context["当前净化节点序号"] or node["阶段"] ~= "校准" then
                    goto __continue16
                end
                if _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                    node.X,
                    node.Y,
                    startX,
                    startY,
                    endX,
                    endY
                ) <= radius * radius then
                    _____51C0_5316_6821_51C6_8282_70B9(context, node)
                end
                return
            end
            ::__continue16::
            i = i + 1
        end
    end
end
____exports["释放失名祷潮"] = function(context, target)
    local boss = context["苍影灵卫单位"]
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["苍影镇魂印"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
        return false
    end
    local targets = _____53D6_7977_6F6E_76EE_6807_5217_8868(boss, target)
    if #targets == 0 then
        return false
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["失名祷潮"]
    local nodeIndex = context["当前净化节点序号"] - 1
    local isCalibratingNode = context["阶段"] == "P3双蚀共鸣" and nodeIndex >= 0 and nodeIndex < #context["净化节点列表"] and context["净化节点列表"][nodeIndex + 1]["阶段"] == "校准"
    _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD(boss, isCalibratingNode and "双钥净化校准" or "失名祷潮")
    local primary = targets[1]
    local startX = GetUnitX(boss)
    local startY = GetUnitY(boss)
    local facing = _____4E24_70B9_89D2_5EA6(
        startX,
        startY,
        GetUnitX(primary),
        GetUnitY(primary)
    )
    local endX = _____6781_5750_6807X(startX, facing, cfg["长度"])
    local endY = _____6781_5750_6807Y(startY, facing, cfg["长度"])
    context["大型机制忙碌到Ms"] = getServerTime() + (cfg["预警秒"] + 0.5) * 1000
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(boss, facing)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = startX,
        Y = startY,
        ["宽度"] = cfg["宽度"],
        ["长度"] = cfg["长度"],
        ["朝向"] = facing,
        ["持续时间"] = cfg["预警秒"],
        ["来源单位"] = boss
    })
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = cfg["预警秒"] + 0.35, ["恢复动画编号"] = cfg["恢复动画编号"]})
    createTimedEffect(
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["失名祷潮"]["祷潮蓄势特效路径"],
        startX,
        startY,
        0,
        cfg["预警秒"]
    )
    local pullIds = {}
    do
        local i = 0
        while i < #targets do
            do
                if not _____5355_4F4D_6709_6548(targets[i + 1]) then
                    goto __continue23
                end
                local pullId = _____5F00_59CB_7275_5F15(targets[i + 1], {
                    ["中心单位"] = boss,
                    ["主单位"] = boss,
                    ["持续时间"] = cfg["预警秒"],
                    ["每秒速度"] = cfg["宽度"] * 0.3,
                    ["最小距离"] = cfg["宽度"],
                    ["到达后结束"] = false,
                    ["暂停单位"] = false,
                    ["禁用碰撞"] = false,
                    ["朝向跟随牵引"] = false,
                    ["闪电效果代码"] = "SPLK",
                    ["闪电高度"] = 70
                })
                if pullId > 0 then
                    pullIds[#pullIds + 1] = pullId
                end
            end
            ::__continue23::
            i = i + 1
        end
    end
    local ____self_11 = context["清理"]
    ____self_11["登记清理"](
        ____self_11,
        "祖地双灵卫-失名祷潮牵引",
        function()
            do
                local i = 0
                while i < #pullIds do
                    _____505C_6B62_7275_5F15(pullIds[i + 1])
                    i = i + 1
                end
            end
        end
    )
    local resolveId = addDelayedCallback(
        cfg["预警秒"] * 1000,
        function()
            do
                local i = 0
                while i < #pullIds do
                    _____505C_6B62_7275_5F15(pullIds[i + 1])
                    i = i + 1
                end
            end
            if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                return
            end
            local absorbed = false
            local seal = context["镇魂印"]
            if seal ~= nil and seal["到期Ms"] > getServerTime() then
                local hitRadius = seal["半径"] + cfg["宽度"] * 0.5
                absorbed = _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                    seal.X,
                    seal.Y,
                    startX,
                    startY,
                    endX,
                    endY
                ) <= hitRadius * hitRadius
            end
            local effect = createTimedEffect(
                _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["失名祷潮"]["定向灵魂潮特效路径"],
                startX,
                startY,
                0,
                1
            )
            _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C(effect, {["Z轴角度"] = facing})
            if absorbed then
                _____6D88_8017_9547_9B42_5370_5E76_538B_5236(context, boss)
                return
            end
            _____68C0_67E5_7977_6F6E_7A7F_8FC7_6821_51C6_8282_70B9(
                context,
                startX,
                startY,
                endX,
                endY
            )
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            do
                local i = 0
                while i < #heroes do
                    do
                        local hit = heroes[i + 1]
                        if not _____5355_4F4D_662F_5426_5728_6761_5F62_533A_57DF(
                            hit,
                            startX,
                            startY,
                            endX,
                            endY,
                            cfg["宽度"]
                        ) then
                            goto __continue36
                        end
                        local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, hit, {["来源攻击力比例"] = cfg["伤害攻击力比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"]})
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["来源"] = boss,
                            ["目标"] = hit,
                            ["伤害"] = damage,
                            attack = false,
                            ranged = true,
                            attackType = ATTACK_TYPE_MAGIC,
                            ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                            weaponType = WEAPON_TYPE_WHOKNOWS,
                            ["来源类型"] = "Boss技能",
                            ["标签"] = "祖地双灵卫·失名祷潮"
                        })
                    end
                    ::__continue36::
                    i = i + 1
                end
            end
        end
    )
    local ____self_12 = context["清理"]
    ____self_12["登记延迟回调"](____self_12, "祖地双灵卫-失名祷潮结算", resolveId)
    return true
end
____exports["失名祷潮技能状态"] = {
    ["所属形态"] = "无面祷影",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = {"单体", "AOE"},
    ["需要独立技能实例ID"] = false,
    ["包含战斗自身位移"] = false,
    ["实现要求"] = "牵魂目标复用公共牵引；祷潮命中镇魂印时压制自身，穿过当前校准节点时完成净化。"
}
return ____exports
