--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.01．场地配置")
local _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E = ____01_FF0E_573A_5730_914D_7F6E["菲尼克斯尔场地配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔音效配置"]
local ____17_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.17．台词播放")
local _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD = ____17_FF0E_53F0_8BCD_64AD_653E["播放菲尼克斯尔台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.19．公共工具")
local _____5468_671F = ____19_FF0E_516C_5171_5DE5_5177["周期"]
local _____5EF6_8FDF = ____19_FF0E_516C_5171_5DE5_5177["延迟"]
local _____505C_6B62_5468_671F = ____19_FF0E_516C_5171_5DE5_5177["停止周期"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_516C_5171_5DE5_5177["单位存活"]
local _____53D6_83F2_5C3C_514B_65AF_5C14_654C_5BF9_76EE_6807_5217_8868 = ____19_FF0E_516C_5171_5DE5_5177["取菲尼克斯尔敌对目标列表"]
local _____53D6_5355_4F4DX = ____19_FF0E_516C_5171_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____19_FF0E_516C_5171_5DE5_5177["取单位Y"]
local _____4E24_70B9_8DDD_79BB = ____19_FF0E_516C_5171_5DE5_5177["两点距离"]
local _____7EBF_6BB5_5230_70B9_8DDD_79BB = ____19_FF0E_516C_5171_5DE5_5177["线段到点距离"]
local _____521B_5EFA_9884_8B66_5706 = ____19_FF0E_516C_5171_5DE5_5177["创建预警圆"]
local _____53D6_83F2_5C3C_514B_65AF_5C14_6280_80FD_5F3A_5EA6_500D_7387 = ____19_FF0E_516C_5171_5DE5_5177["取菲尼克斯尔技能强度倍率"]
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587 = ____19_FF0E_516C_5171_5DE5_5177["创建菲尼克斯尔独立伤害上下文"]
local _____6DFB_52A0_5143_7D20_5C42_6570 = ____19_FF0E_516C_5171_5DE5_5177["添加元素层数"]
local _____663E_793A_5E38_89C4_8BFB_6761 = ____19_FF0E_516C_5171_5DE5_5177["显示常规读条"]
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_673A_5236_5355_4F4D = ____19_FF0E_516C_5171_5DE5_5177["创建菲尼克斯尔机制单位"]
local _____5355_4F4D_6709_6548 = ____19_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____53D6_6700_5927_751F_547D = ____19_FF0E_516C_5171_5DE5_5177["取最大生命"]
local _____8BBE_7F6E_5355_4F4D_52A8_753B = ____19_FF0E_516C_5171_5DE5_5177["设置单位动画"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电")
local _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_0["创建单位绑定闪电"]
local jass = require("jass.common")
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码")
local _____95EA_7535_6548_679C_4EE3_7801 = ____require_result_1["闪电效果代码"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
____exports["释放菲尼克斯尔怨火链接"] = function(context)
    if context["当前形态"] ~= "第二形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
        return
    end
    local targets = _____53D6_83F2_5C3C_514B_65AF_5C14_654C_5BF9_76EE_6807_5217_8868(context.Boss)
    if #targets < 1 then
        return
    end
    local a = targets[1]
    local ____temp_3
    if #targets >= 2 then
        ____temp_3 = targets[2]
    else
        ____temp_3 = context["怨火锚点"]
    end
    local b = ____temp_3
    if not _____5355_4F4D_6709_6548(b) then
        local center = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["中心点"]
        b = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_673A_5236_5355_4F4D(
            context,
            _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["机制单位ID"]["怨火核心"],
            "怨火锚点",
            _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["模型"]["怨火核心"],
            center.x,
            center.y,
            _____53D6_6700_5927_751F_547D(context.Boss) * 0.05
        )
        context["怨火锚点"] = b
    end
    if not _____5355_4F4D_5B58_6D3B(a) or not _____5355_4F4D_5B58_6D3B(b) or a == b then
        return
    end
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["怨火链接"]
    local _____4F24_5BB3_4E0A_4E0B_6587 = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587("菲尼克斯尔怨火链接", config["预警秒"] + config["持续秒"] + 2)
    _____8BBE_7F6E_5355_4F4D_52A8_753B(context.Boss, _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["施法"]["编号"], _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["施法"]["倍速"])
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(context.Boss, "怨火链接")
    _____663E_793A_5E38_89C4_8BFB_6761(config["预警秒"], config["吟唱条颜色ID"], config["吟唱条标题文本"], config["吟唱条提示文本"])
    _____521B_5EFA_9884_8B66_5706(
        _____53D6_5355_4F4DX(a),
        _____53D6_5355_4F4DY(a),
        160,
        config["预警秒"]
    )
    _____521B_5EFA_9884_8B66_5706(
        _____53D6_5355_4F4DX(b),
        _____53D6_5355_4F4DY(b),
        160,
        config["预警秒"]
    )
    _____5EF6_8FDF(
        config["预警秒"] * 1000,
        function()
            if not _____5355_4F4D_5B58_6D3B(a) or not _____5355_4F4D_5B58_6D3B(b) then
                return
            end
            local ____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535_6 = _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535
            local ____95EA_7535_6548_679C_4EE3_7801__7EA2_8272_5149_675F_4 = _____95EA_7535_6548_679C_4EE3_7801["红色光束"]
            if ____95EA_7535_6548_679C_4EE3_7801__7EA2_8272_5149_675F_4 == nil then
                ____95EA_7535_6548_679C_4EE3_7801__7EA2_8272_5149_675F_4 = _____95EA_7535_6548_679C_4EE3_7801["生命吸取"]
            end
            local ____95EA_7535_6548_679C_4EE3_7801__7EA2_8272_5149_675F_4_5 = ____95EA_7535_6548_679C_4EE3_7801__7EA2_8272_5149_675F_4
            if ____95EA_7535_6548_679C_4EE3_7801__7EA2_8272_5149_675F_4_5 == nil then
                ____95EA_7535_6548_679C_4EE3_7801__7EA2_8272_5149_675F_4_5 = "DRAL"
            end
            local lightning = ____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535_6({
                ["效果代码"] = ____95EA_7535_6548_679C_4EE3_7801__7EA2_8272_5149_675F_4_5,
                ["起点单位"] = a,
                ["终点单位"] = b,
                ["持续时间"] = config["持续秒"],
                ["起点高度偏移"] = 80,
                ["终点高度偏移"] = 80,
                ["任一死亡时销毁"] = true
            })
            registerManualBuff(
                a,
                _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["怨火链接"],
                config["持续秒"],
                1,
                {stack = 1, sourceName = "菲尼克斯尔-怨火链接"}
            )
            registerManualBuff(
                b,
                _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["怨火链接"],
                config["持续秒"],
                1,
                {stack = 1, sourceName = "菲尼克斯尔-怨火链接"}
            )
            local ____self_7 = context["清理"]
            ____self_7["登记闪电"](____self_7, "菲尼克斯尔怨火链接", lightning)
            _____64AD_653EBoss_5750_6807_97F3_6548(
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["怨火链接"]["链接生成"],
                (_____53D6_5355_4F4DX(a) + _____53D6_5355_4F4DX(b)) * 0.5,
                (_____53D6_5355_4F4DY(a) + _____53D6_5355_4F4DY(b)) * 0.5,
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
            )
            local tick
            tick = _____5468_671F(
                config["Tick秒"] * 1000,
                function()
                    if not _____5355_4F4D_5B58_6D3B(a) or not _____5355_4F4D_5B58_6D3B(b) then
                        return
                    end
                    if _____4E24_70B9_8DDD_79BB(
                        _____53D6_5355_4F4DX(a),
                        _____53D6_5355_4F4DY(a),
                        _____53D6_5355_4F4DX(b),
                        _____53D6_5355_4F4DY(b)
                    ) > config["断链距离"] then
                        if _____5355_4F4D_5B58_6D3B(context.Boss) and _____5355_4F4D_5B58_6D3B(a) then
                            _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                                ["技能ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能ID"],
                                ["技能实例ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能实例ID"],
                                ["标签"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["标签"],
                                ["来源"] = context.Boss,
                                ["目标"] = a,
                                ["伤害公式"] = {
                                    ["来源攻击力比例"] = config["断链伤害Boss攻击力比例"],
                                    ["目标已损生命比例"] = config["断链伤害目标已损失生命比例"],
                                    ["总倍率"] = _____53D6_83F2_5C3C_514B_65AF_5C14_6280_80FD_5F3A_5EA6_500D_7387(context.Boss)
                                },
                                ranged = true,
                                attackType = ATTACK_TYPE_NORMAL,
                                ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                                weaponType = WEAPON_TYPE_WHOKNOWS
                            })
                        end
                        if _____5355_4F4D_5B58_6D3B(context.Boss) and _____5355_4F4D_5B58_6D3B(b) then
                            _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                                ["技能ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能ID"],
                                ["技能实例ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能实例ID"],
                                ["标签"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["标签"],
                                ["来源"] = context.Boss,
                                ["目标"] = b,
                                ["伤害公式"] = {
                                    ["来源攻击力比例"] = config["断链伤害Boss攻击力比例"],
                                    ["目标已损生命比例"] = config["断链伤害目标已损失生命比例"],
                                    ["总倍率"] = _____53D6_83F2_5C3C_514B_65AF_5C14_6280_80FD_5F3A_5EA6_500D_7387(context.Boss)
                                },
                                ranged = true,
                                attackType = ATTACK_TYPE_NORMAL,
                                ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                                weaponType = WEAPON_TYPE_WHOKNOWS
                            })
                        end
                        _____6DFB_52A0_5143_7D20_5C42_6570(a, "暗", config["怨火层数"])
                        _____6DFB_52A0_5143_7D20_5C42_6570(b, "暗", config["怨火层数"])
                        _____79FB_9664_5355_4F4D_6307_5B9ABuff(a, _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["怨火链接"])
                        _____79FB_9664_5355_4F4D_6307_5B9ABuff(b, _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["怨火链接"])
                        _____505C_6B62_5468_671F(tick)
                        return
                    end
                    local all = _____53D6_83F2_5C3C_514B_65AF_5C14_654C_5BF9_76EE_6807_5217_8868(context.Boss)
                    do
                        local i = 0
                        while i < #all do
                            do
                                local u = all[i + 1]
                                if u == a or u == b then
                                    goto __continue15
                                end
                                if _____7EBF_6BB5_5230_70B9_8DDD_79BB(
                                    _____53D6_5355_4F4DX(a),
                                    _____53D6_5355_4F4DY(a),
                                    _____53D6_5355_4F4DX(b),
                                    _____53D6_5355_4F4DY(b),
                                    _____53D6_5355_4F4DX(u),
                                    _____53D6_5355_4F4DY(u)
                                ) <= config["线宽"] then
                                    if _____5355_4F4D_5B58_6D3B(context.Boss) and _____5355_4F4D_5B58_6D3B(u) then
                                        _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                                            ["技能ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能ID"],
                                            ["技能实例ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能实例ID"],
                                            ["标签"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["标签"],
                                            ["来源"] = context.Boss,
                                            ["目标"] = u,
                                            ["伤害公式"] = {
                                                ["来源攻击力比例"] = config["穿线伤害Boss攻击力比例"],
                                                ["目标最大生命比例"] = config["穿线伤害目标最大生命比例"],
                                                ["总倍率"] = _____53D6_83F2_5C3C_514B_65AF_5C14_6280_80FD_5F3A_5EA6_500D_7387(context.Boss)
                                            },
                                            ranged = true,
                                            attackType = ATTACK_TYPE_NORMAL,
                                            ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                                            weaponType = WEAPON_TYPE_WHOKNOWS
                                        })
                                    end
                                    _____6DFB_52A0_5143_7D20_5C42_6570(u, "暗", config["怨火层数"])
                                end
                            end
                            ::__continue15::
                            i = i + 1
                        end
                    end
                end
            )
            local ____self_26 = context["清理"]
            ____self_26["登记周期回调"](____self_26, "菲尼克斯尔怨火链接Tick", tick)
            _____5EF6_8FDF(
                config["持续秒"] * 1000,
                function()
                    _____505C_6B62_5468_671F(tick)
                    _____79FB_9664_5355_4F4D_6307_5B9ABuff(a, _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["怨火链接"])
                    _____79FB_9664_5355_4F4D_6307_5B9ABuff(b, _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["怨火链接"])
                end
            )
        end
    )
end
____exports["初始化菲尼克斯尔怨火链接节点"] = function(context)
    local timerId = _____5468_671F(
        19000,
        function()
            ____exports["释放菲尼克斯尔怨火链接"](context)
        end
    )
    local ____self_27 = context["清理"]
    ____self_27["登记周期回调"](____self_27, "菲尼克斯尔-怨火链接", timerId)
end
____exports["注册菲尼克斯尔怨火链接"] = function()
end
return ____exports
