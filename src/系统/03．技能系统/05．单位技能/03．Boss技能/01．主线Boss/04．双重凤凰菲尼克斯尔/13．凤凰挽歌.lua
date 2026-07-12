--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
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
local _____53D6_83F2_5C3C_514B_65AF_5C14_73A9_5BB6_82F1_96C4_5217_8868 = ____19_FF0E_516C_5171_5DE5_5177["取菲尼克斯尔玩家英雄列表"]
local _____4E24_70B9_8DDD_79BB = ____19_FF0E_516C_5171_5DE5_5177["两点距离"]
local _____53D6_5355_4F4DX = ____19_FF0E_516C_5171_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____19_FF0E_516C_5171_5DE5_5177["取单位Y"]
local _____521B_5EFA_5B89_5168_5706 = ____19_FF0E_516C_5171_5DE5_5177["创建安全圆"]
local _____64AD_653E_70B9_7279_6548 = ____19_FF0E_516C_5171_5DE5_5177["播放点特效"]
local _____663E_793A_5927_62DB_8BFB_6761 = ____19_FF0E_516C_5171_5DE5_5177["显示大招读条"]
local _____8BBE_7F6E_5355_4F4D_52A8_753B = ____19_FF0E_516C_5171_5DE5_5177["设置单位动画"]
local _____5F00_59CB_65BD_6CD5_786C_76F4 = ____19_FF0E_516C_5171_5DE5_5177["开始施法硬直"]
local _____6DFB_52A0_5143_7D20_5C42_6570 = ____19_FF0E_516C_5171_5DE5_5177["添加元素层数"]
local _____9020_6210_6697_706B_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["造成暗火伤害"]
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587 = ____19_FF0E_516C_5171_5DE5_5177["创建菲尼克斯尔独立伤害上下文"]
local _____53D6_5F53_524D_751F_547D = ____19_FF0E_516C_5171_5DE5_5177["取当前生命"]
local ____15_FF0E_6028_706B_6838_5FC3_66B4_9732 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.15．怨火核心暴露")
local _____89E6_53D1_83F2_5C3C_514B_65AF_5C14_6028_706B_6838_5FC3_66B4_9732 = ____15_FF0E_6028_706B_6838_5FC3_66B4_9732["触发菲尼克斯尔怨火核心暴露"]
local function _____73A9_5BB6_5728_5B89_5168_533A(unit)
    local points = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["挽歌安全区点位"]
    local radius = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["凤凰挽歌"]["安全区半径"]
    do
        local i = 0
        while i < #points do
            local p = points[i + 1]
            if _____4E24_70B9_8DDD_79BB(
                _____53D6_5355_4F4DX(unit),
                _____53D6_5355_4F4DY(unit),
                p.x,
                p.y
            ) <= radius then
                return true
            end
            i = i + 1
        end
    end
    return false
end
____exports["释放菲尼克斯尔凤凰挽歌"] = function(context)
    if context["当前形态"] ~= "第二形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
        return
    end
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["凤凰挽歌"]
    local _____4F24_5BB3_4E0A_4E0B_6587 = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587("菲尼克斯尔凤凰挽歌", config["引导秒"] + 2)
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(context.Boss, "凤凰挽歌")
    _____5F00_59CB_65BD_6CD5_786C_76F4(context.Boss, config["引导秒"])
    _____8BBE_7F6E_5355_4F4D_52A8_753B(context.Boss, _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["哀鸣引导"]["编号"], _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["哀鸣引导"]["倍速"])
    _____663E_793A_5927_62DB_8BFB_6761(config["引导秒"], config["吟唱条颜色ID"], config["吟唱条标题文本"], config["吟唱条提示文本"])
    _____64AD_653E_70B9_7279_6548(
        _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["凤凰挽歌主体"],
        _____53D6_5355_4F4DX(context.Boss),
        _____53D6_5355_4F4DY(context.Boss),
        config["引导秒"] * 1000
    )
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["凤凰挽歌"]["引导开始"],
        _____53D6_5355_4F4DX(context.Boss),
        _____53D6_5355_4F4DY(context.Boss),
        _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    local points = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["挽歌安全区点位"]
    do
        local i = 0
        while i < #points do
            _____521B_5EFA_5B89_5168_5706(points[i + 1].x, points[i + 1].y, config["安全区半径"], config["引导秒"])
            _____64AD_653E_70B9_7279_6548(_____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["凤凰挽歌安全区"], points[i + 1].x, points[i + 1].y, config["引导秒"] * 1000)
            i = i + 1
        end
    end
    local tick = _____5468_671F(
        config["Tick秒"] * 1000,
        function()
            local heroes = _____53D6_83F2_5C3C_514B_65AF_5C14_73A9_5BB6_82F1_96C4_5217_8868()
            do
                local i = 0
                while i < #heroes do
                    do
                        local hero = heroes[i + 1]
                        if _____73A9_5BB6_5728_5B89_5168_533A(hero) then
                            goto __continue12
                        end
                        _____9020_6210_6697_706B_4F24_5BB3(
                            context.Boss,
                            hero,
                            _____53D6_5F53_524D_751F_547D(hero) * config["当前生命损失比例"],
                            "AOE",
                            _____4F24_5BB3_4E0A_4E0B_6587
                        )
                        _____6DFB_52A0_5143_7D20_5C42_6570(hero, "暗", config["规避叠层"])
                        _____64AD_653E_70B9_7279_6548(
                            _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["凤凰挽歌叠加"],
                            _____53D6_5355_4F4DX(hero),
                            _____53D6_5355_4F4DY(hero),
                            1200
                        )
                    end
                    ::__continue12::
                    i = i + 1
                end
            end
        end
    )
    local ____self_0 = context["清理"]
    ____self_0["登记周期回调"](____self_0, "菲尼克斯尔凤凰挽歌Tick", tick)
    _____5EF6_8FDF(
        config["引导秒"] * 1000,
        function()
            _____505C_6B62_5468_671F(tick)
            _____89E6_53D1_83F2_5C3C_514B_65AF_5C14_6028_706B_6838_5FC3_66B4_9732(context)
        end
    )
end
____exports["初始化菲尼克斯尔凤凰挽歌节点"] = function(context)
    local timerId = _____5468_671F(
        36000,
        function()
            ____exports["释放菲尼克斯尔凤凰挽歌"](context)
        end
    )
    local ____self_1 = context["清理"]
    ____self_1["登记周期回调"](____self_1, "菲尼克斯尔-凤凰挽歌", timerId)
end
____exports["注册菲尼克斯尔凤凰挽歌"] = function()
end
return ____exports
