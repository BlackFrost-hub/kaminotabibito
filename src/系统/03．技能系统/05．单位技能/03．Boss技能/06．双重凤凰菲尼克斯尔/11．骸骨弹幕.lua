--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔音效配置"]
local ____17_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.17．台词播放")
local _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD = ____17_FF0E_53F0_8BCD_64AD_653E["播放菲尼克斯尔台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["延迟播放Boss坐标音效"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.19．公共工具")
local _____5468_671F = ____19_FF0E_516C_5171_5DE5_5177["周期"]
local _____5EF6_8FDF = ____19_FF0E_516C_5171_5DE5_5177["延迟"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_516C_5171_5DE5_5177["单位存活"]
local _____53D6_5355_4F4DX = ____19_FF0E_516C_5171_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____19_FF0E_516C_5171_5DE5_5177["取单位Y"]
local _____53D6_968F_673A_73A9_5BB6_82F1_96C4 = ____19_FF0E_516C_5171_5DE5_5177["取随机玩家英雄"]
local _____64AD_653E_70B9_7279_6548 = ____19_FF0E_516C_5171_5DE5_5177["播放点特效"]
local _____521B_5EFA_9884_8B66_5706 = ____19_FF0E_516C_5171_5DE5_5177["创建预警圆"]
local _____8303_56F4_654C_4EBA = ____19_FF0E_516C_5171_5DE5_5177["范围敌人"]
local _____8BA1_7B97_653B_51FB_6700_5927_751F_547D_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["计算攻击最大生命伤害"]
local _____9020_6210_6697_706B_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["造成暗火伤害"]
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587 = ____19_FF0E_516C_5171_5DE5_5177["创建菲尼克斯尔独立伤害上下文"]
local _____6DFB_52A0_5143_7D20_5C42_6570 = ____19_FF0E_516C_5171_5DE5_5177["添加元素层数"]
local _____8BBE_7F6E_5355_4F4D_52A8_753B = ____19_FF0E_516C_5171_5DE5_5177["设置单位动画"]
local _____663E_793A_5E38_89C4_8BFB_6761 = ____19_FF0E_516C_5171_5DE5_5177["显示常规读条"]
local _____5F00_59CB_65BD_6CD5_786C_76F4 = ____19_FF0E_516C_5171_5DE5_5177["开始施法硬直"]
____exports["释放菲尼克斯尔骸骨弹幕"] = function(context)
    if context["当前形态"] ~= "第二形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
        return
    end
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨弹幕"]
    local _____4F24_5BB3_4E0A_4E0B_6587 = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587("菲尼克斯尔骸骨弹幕", config["读条秒"] + config["波次数"] * config["波次间隔秒"] + 2)
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(context.Boss, "骸骨弹幕")
    _____5F00_59CB_65BD_6CD5_786C_76F4(context.Boss, config["读条秒"])
    _____8BBE_7F6E_5355_4F4D_52A8_753B(context.Boss, _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["弹幕解体"]["编号"], _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["弹幕解体"]["倍速"])
    _____663E_793A_5E38_89C4_8BFB_6761(config["读条秒"], config["吟唱条颜色ID"], config["吟唱条标题文本"], config["吟唱条提示文本"])
    _____5EF6_8FDF(
        config["读条秒"] * 1000,
        function()
            _____64AD_653EBoss_5750_6807_97F3_6548(
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["骸骨弹幕"]["起手层"],
                _____53D6_5355_4F4DX(context.Boss),
                _____53D6_5355_4F4DY(context.Boss),
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
            )
            _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548(
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["骸骨弹幕"]["飞射层"],
                _____53D6_5355_4F4DX(context.Boss),
                _____53D6_5355_4F4DY(context.Boss),
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["骸骨弹幕"]["飞射层延迟Ms"],
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
            )
            do
                local wave = 0
                while wave < config["波次数"] do
                    _____5EF6_8FDF(
                        wave * config["波次间隔秒"] * 1000,
                        function()
                            local target = _____53D6_968F_673A_73A9_5BB6_82F1_96C4()
                            if not _____5355_4F4D_5B58_6D3B(target) then
                                return
                            end
                            local x = _____53D6_5355_4F4DX(target)
                            local y = _____53D6_5355_4F4DY(target)
                            _____521B_5EFA_9884_8B66_5706(x, y, config["半径"] * 0.18, 0.35)
                            _____64AD_653E_70B9_7279_6548(_____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["骨羽"], x, y, 1000)
                            local enemies = _____8303_56F4_654C_4EBA(context.Boss, x, y, config["半径"] * 0.18)
                            do
                                local i = 0
                                while i < #enemies do
                                    local u = enemies[i + 1]
                                    _____9020_6210_6697_706B_4F24_5BB3(
                                        context.Boss,
                                        u,
                                        _____8BA1_7B97_653B_51FB_6700_5927_751F_547D_4F24_5BB3(context.Boss, u, config["伤害Boss攻击力比例"], config["伤害目标最大生命比例"]),
                                        "AOE",
                                        _____4F24_5BB3_4E0A_4E0B_6587
                                    )
                                    _____6DFB_52A0_5143_7D20_5C42_6570(u, "暗", config["怨火层数"])
                                    i = i + 1
                                end
                            end
                        end
                    )
                    wave = wave + 1
                end
            end
        end
    )
end
____exports["初始化菲尼克斯尔骸骨弹幕节点"] = function(context)
    local timerId = _____5468_671F(
        14000,
        function()
            ____exports["释放菲尼克斯尔骸骨弹幕"](context)
        end
    )
    local ____self_0 = context["清理"]
    ____self_0["登记周期回调"](____self_0, "菲尼克斯尔-骸骨弹幕", timerId)
end
____exports["注册菲尼克斯尔骸骨弹幕"] = function()
end
return ____exports
