--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建菲尼克斯尔上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔音效配置"]
local ____17_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.17．台词播放")
local _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD = ____17_FF0E_53F0_8BCD_64AD_653E["播放菲尼克斯尔台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["延迟播放Boss坐标音效"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.19．公共工具")
local stringToFourCC = ____19_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_516C_5171_5DE5_5177["单位存活"]
local _____53D6_76EE_6807_6216_968F_673A_73A9_5BB6 = ____19_FF0E_516C_5171_5DE5_5177["取目标或随机玩家"]
local _____9762_5411_5355_4F4D = ____19_FF0E_516C_5171_5DE5_5177["面向单位"]
local _____8BBE_7F6E_5355_4F4D_52A8_753B = ____19_FF0E_516C_5171_5DE5_5177["设置单位动画"]
local _____663E_793A_5E38_89C4_8BFB_6761 = ____19_FF0E_516C_5171_5DE5_5177["显示常规读条"]
local _____5F00_59CB_65BD_6CD5_786C_76F4 = ____19_FF0E_516C_5171_5DE5_5177["开始施法硬直"]
local _____5EF6_8FDF = ____19_FF0E_516C_5171_5DE5_5177["延迟"]
local _____5468_671F = ____19_FF0E_516C_5171_5DE5_5177["周期"]
local _____505C_6B62_5468_671F = ____19_FF0E_516C_5171_5DE5_5177["停止周期"]
local _____521B_5EFA_9884_8B66_6247_5F62 = ____19_FF0E_516C_5171_5DE5_5177["创建预警扇形"]
local _____5355_4F4D_5728_6247_5F62_5185 = ____19_FF0E_516C_5171_5DE5_5177["单位在扇形内"]
local _____8303_56F4_654C_4EBA = ____19_FF0E_516C_5171_5DE5_5177["范围敌人"]
local _____53D6_83F2_5C3C_514B_65AF_5C14_6280_80FD_5F3A_5EA6_500D_7387 = ____19_FF0E_516C_5171_5DE5_5177["取菲尼克斯尔技能强度倍率"]
local _____6DFB_52A0_5143_7D20_5C42_6570 = ____19_FF0E_516C_5171_5DE5_5177["添加元素层数"]
local _____65BD_52A0_51CF_901F = ____19_FF0E_516C_5171_5DE5_5177["施加减速"]
local _____53D6_5355_4F4DX = ____19_FF0E_516C_5171_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____19_FF0E_516C_5171_5DE5_5177["取单位Y"]
local _____6781_5750_6807X = ____19_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetHandleId = jass.GetHandleId
local GetUnitFacing = jass.GetUnitFacing
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_0["创建点特效"]
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____7194_5CA9_5410_606F_6280_80FDID = stringToFourCC(_____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["熔岩吐息"])
local _____7194_5CA9_5410_606F_5DF2_6CE8_518C = false
local function _____64AD_653E_83F2_5C3C_514B_65AF_5C14_7194_5CA9_5410_606F_7279_6548(boss)
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["熔岩吐息"]
    local facing = GetUnitFacing(boss)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["吐息"],
        X = _____6781_5750_6807X(
            _____53D6_5355_4F4DX(boss),
            config["吐息特效前移"],
            facing
        ),
        Y = _____6781_5750_6807Y(
            _____53D6_5355_4F4DY(boss),
            config["吐息特效前移"],
            facing
        ),
        Z = GetUnitFlyHeight(boss) + config["吐息特效高度偏移"],
        ["缩放"] = config["吐息特效缩放"],
        ["Z轴角度"] = facing + config["吐息特效朝向修正角度"],
        ["持续秒"] = config["吐息特效持续秒"]
    })
end
____exports["释放菲尼克斯尔熔岩吐息"] = function(context, target, _____6280_80FD_5B9E_4F8BID)
    if context["当前形态"] ~= "第一形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
        return
    end
    local boss = context.Boss
    local realTarget = _____53D6_76EE_6807_6216_968F_673A_73A9_5BB6(boss, target)
    if not _____5355_4F4D_5B58_6D3B(realTarget) then
        return
    end
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["熔岩吐息"]
    local _____4F24_5BB3_4E0A_4E0B_6587 = {["技能ID"] = _____7194_5CA9_5410_606F_6280_80FDID, ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID, ["标签"] = "菲尼克斯尔熔岩吐息"}
    local hitCount = {}
    local _____547D_4E2D_7D2F_8BA1_79D2 = {}
    _____9762_5411_5355_4F4D(boss, realTarget)
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(boss, "熔岩吐息")
    _____5F00_59CB_65BD_6CD5_786C_76F4(boss, config["预警秒"] + config["持续秒"])
    _____8BBE_7F6E_5355_4F4D_52A8_753B(boss, _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第一形态"]["施法弯身"]["编号"], _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第一形态"]["施法弯身"]["倍速"])
    _____663E_793A_5E38_89C4_8BFB_6761(config["预警秒"], config["吟唱条颜色ID"], config["吟唱条标题文本"], config["吟唱条提示文本"])
    _____521B_5EFA_9884_8B66_6247_5F62(boss, config["半径"], config["预警秒"], config["角度"])
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["熔岩吐息"]["张口蓄力"],
        _____53D6_5355_4F4DX(boss),
        _____53D6_5355_4F4DY(boss),
        _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548(
        _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["熔岩吐息"]["持续喷吐"],
        _____53D6_5355_4F4DX(boss),
        _____53D6_5355_4F4DY(boss),
        _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["熔岩吐息"]["持续喷吐延迟Ms"],
        _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5EF6_8FDF(
        config["预警秒"] * 1000,
        function()
            local _____7ECF_8FC7_79D2 = 0
            local function _____6267_884C_83F2_5C3C_514B_65AF_5C14_7194_5CA9_5410_606FTick()
                if not _____5355_4F4D_5B58_6D3B(boss) or _____7ECF_8FC7_79D2 >= config["持续秒"] then
                    return false
                end
                local _____5269_4F59_79D2 = config["持续秒"] - _____7ECF_8FC7_79D2
                local _____672C_6B21_8986_76D6_79D2 = _____5269_4F59_79D2 < config["Tick秒"] and _____5269_4F59_79D2 or config["Tick秒"]
                _____7ECF_8FC7_79D2 = _____7ECF_8FC7_79D2 + _____672C_6B21_8986_76D6_79D2
                if _____5355_4F4D_5B58_6D3B(realTarget) then
                    _____9762_5411_5355_4F4D(boss, realTarget)
                end
                _____64AD_653E_83F2_5C3C_514B_65AF_5C14_7194_5CA9_5410_606F_7279_6548(boss)
                local _____4F24_5BB3_500D_7387 = _____672C_6B21_8986_76D6_79D2 / config["伤害基准Tick秒"]
                local enemies = _____8303_56F4_654C_4EBA(
                    boss,
                    _____53D6_5355_4F4DX(boss),
                    _____53D6_5355_4F4DY(boss),
                    config["半径"]
                )
                do
                    local i = 0
                    while i < #enemies do
                        do
                            local enemy = enemies[i + 1]
                            if not _____5355_4F4D_5728_6247_5F62_5185(boss, enemy, config["半径"], config["角度"]) then
                                goto __continue11
                            end
                            if _____5355_4F4D_5B58_6D3B(enemy) then
                                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                                    ["技能ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能ID"],
                                    ["技能实例ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能实例ID"],
                                    ["标签"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["标签"],
                                    ["来源"] = boss,
                                    ["目标"] = enemy,
                                    ["伤害公式"] = {
                                        ["来源攻击力比例"] = config["伤害Boss攻击力比例"],
                                        ["目标最大生命比例"] = config["伤害目标最大生命比例"],
                                        ["总倍率"] = _____53D6_83F2_5C3C_514B_65AF_5C14_6280_80FD_5F3A_5EA6_500D_7387(boss) * _____4F24_5BB3_500D_7387
                                    },
                                    ranged = true,
                                    attackType = ATTACK_TYPE_NORMAL,
                                    ["伤害类型"] = DAMAGE_TYPE_FIRE,
                                    weaponType = WEAPON_TYPE_WHOKNOWS
                                })
                            end
                            local id = GetHandleId(enemy) or 0
                            local _____7D2F_8BA1_79D2 = (_____547D_4E2D_7D2F_8BA1_79D2[id] or 0) + _____672C_6B21_8986_76D6_79D2
                            while _____7D2F_8BA1_79D2 + 0.0001 >= config["伤害基准Tick秒"] do
                                _____7D2F_8BA1_79D2 = _____7D2F_8BA1_79D2 - config["伤害基准Tick秒"]
                                _____6DFB_52A0_5143_7D20_5C42_6570(enemy, "火", config["火印层数"])
                                hitCount[id] = (hitCount[id] or 0) + 1
                                if hitCount[id] >= config["减速命中次数"] then
                                    _____65BD_52A0_51CF_901F(boss, enemy, config["减速比例"], config["减速持续秒"])
                                end
                            end
                            _____547D_4E2D_7D2F_8BA1_79D2[id] = _____7D2F_8BA1_79D2
                        end
                        ::__continue11::
                        i = i + 1
                    end
                end
                return _____7ECF_8FC7_79D2 + 0.0001 < config["持续秒"]
            end
            if not _____6267_884C_83F2_5C3C_514B_65AF_5C14_7194_5CA9_5410_606FTick() then
                return
            end
            local tick
            tick = _____5468_671F(
                config["Tick秒"] * 1000,
                function()
                    if not _____6267_884C_83F2_5C3C_514B_65AF_5C14_7194_5CA9_5410_606FTick() then
                        _____505C_6B62_5468_671F(tick)
                    end
                end
            )
            local ____self_7 = context["清理"]
            ____self_7["登记周期回调"](____self_7, "菲尼克斯尔熔岩吐息Tick", tick)
        end
    )
end
local function ____on_83F2_5C3C_514B_65AF_5C14_7194_5CA9_5410_606F_751F_6548(castingUnit, spellAbilityId, _____6280_80FD_5B9E_4F8BID)
    if spellAbilityId ~= _____7194_5CA9_5410_606F_6280_80FDID then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(castingUnit)
    if context ~= nil then
        ____exports["释放菲尼克斯尔熔岩吐息"](context, nil, _____6280_80FD_5B9E_4F8BID)
    end
end
____exports["注册菲尼克斯尔熔岩吐息"] = function()
    if _____7194_5CA9_5410_606F_5DF2_6CE8_518C then
        return
    end
    _____7194_5CA9_5410_606F_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "菲尼克斯尔熔岩吐息",
        ["单位类型ID"] = _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7194_5CA9_5410_606F_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss, _____6280_80FD_5B9E_4F8BID)
            ____on_83F2_5C3C_514B_65AF_5C14_7194_5CA9_5410_606F_751F_6548(boss, _____7194_5CA9_5410_606F_6280_80FDID, _____6280_80FD_5B9E_4F8BID)
        end
    })
end
return ____exports
