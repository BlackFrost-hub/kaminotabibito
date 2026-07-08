--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.01．场地配置")
local _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E = ____01_FF0E_573A_5730_914D_7F6E["菲尼克斯尔场地配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔音效配置"]
local ____17_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.17．台词播放")
local _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD = ____17_FF0E_53F0_8BCD_64AD_653E["播放菲尼克斯尔台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.19．公共工具")
local _____5468_671F = ____19_FF0E_516C_5171_5DE5_5177["周期"]
local _____5EF6_8FDF = ____19_FF0E_516C_5171_5DE5_5177["延迟"]
local _____505C_6B62_5468_671F = ____19_FF0E_516C_5171_5DE5_5177["停止周期"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_516C_5171_5DE5_5177["单位存活"]
local _____53D6_5F53_524D_751F_547D = ____19_FF0E_516C_5171_5DE5_5177["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____19_FF0E_516C_5171_5DE5_5177["取最大生命"]
local _____8BBE_7F6E_5F53_524D_751F_547D = ____19_FF0E_516C_5171_5DE5_5177["设置当前生命"]
local _____53D6_5355_4F4DX = ____19_FF0E_516C_5171_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____19_FF0E_516C_5171_5DE5_5177["取单位Y"]
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_673A_5236_5355_4F4D = ____19_FF0E_516C_5171_5DE5_5177["创建菲尼克斯尔机制单位"]
local _____64AD_653E_70B9_7279_6548 = ____19_FF0E_516C_5171_5DE5_5177["播放点特效"]
local _____663E_793A_81F4_547D_8BFB_6761 = ____19_FF0E_516C_5171_5DE5_5177["显示致命读条"]
local _____5F00_59CB_65BD_6CD5_786C_76F4 = ____19_FF0E_516C_5171_5DE5_5177["开始施法硬直"]
local _____8BBE_7F6E_5355_4F4D_52A8_753B = ____19_FF0E_516C_5171_5DE5_5177["设置单位动画"]
local _____53D6_83F2_5C3C_514B_65AF_5C14_73A9_5BB6_82F1_96C4_5217_8868 = ____19_FF0E_516C_5171_5DE5_5177["取菲尼克斯尔玩家英雄列表"]
local _____8BA1_7B97_653B_51FB_6700_5927_751F_547D_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["计算攻击最大生命伤害"]
local _____9020_6210_6697_706B_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["造成暗火伤害"]
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587 = ____19_FF0E_516C_5171_5DE5_5177["创建菲尼克斯尔独立伤害上下文"]
local jass = require("jass.common")
local KillUnit = jass.KillUnit
local RemoveUnit = jass.RemoveUnit
local function _____6E05_7406_83F2_5C3C_514B_65AF_5C14_51E4_51F0_86CB(context)
    do
        local i = 0
        while i < #context["凤凰蛋列表"] do
            local item = context["凤凰蛋列表"][i + 1]
            local egg = item["单位"]
            if egg ~= nil and egg ~= 0 then
                if not item["已摧毁"] then
                    _____64AD_653E_70B9_7279_6548(
                        _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["永恒轮回星屑残留"],
                        _____53D6_5355_4F4DX(egg),
                        _____53D6_5355_4F4DY(egg),
                        1200
                    )
                end
                RemoveUnit(egg)
            end
            i = i + 1
        end
    end
    context["凤凰蛋列表"] = {}
end
local function ____on_83F2_5C3C_514B_65AF_5C14_51E4_51F0_86CB_6B7B_4EA1(context, unit)
    do
        local i = 0
        while i < #context["凤凰蛋列表"] do
            do
                local item = context["凤凰蛋列表"][i + 1]
                if item["单位"] ~= unit then
                    goto __continue9
                end
                if item["已摧毁"] then
                    return
                end
                item["已摧毁"] = true
                _____64AD_653E_70B9_7279_6548(
                    _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["永恒轮回星屑残留"],
                    _____53D6_5355_4F4DX(unit),
                    _____53D6_5355_4F4DY(unit),
                    1200
                )
                _____64AD_653EBoss_5750_6807_97F3_6548(
                    _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["永恒轮回"]["凤凰蛋摧毁"],
                    _____53D6_5355_4F4DX(unit),
                    _____53D6_5355_4F4DY(unit),
                    _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
                )
                return
            end
            ::__continue9::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_51E4_51F0_86CB_6B7B_4EA1_56DE_8C03(context)
    return function(unit)
        ____on_83F2_5C3C_514B_65AF_5C14_51E4_51F0_86CB_6B7B_4EA1(context, unit)
    end
end
____exports["触发菲尼克斯尔永恒轮回"] = function(context)
    if context["永恒轮回已触发"] or context["当前形态"] ~= "第二形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
        return
    end
    context["永恒轮回已触发"] = true
    context["当前形态"] = "永恒轮回"
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]
    local _____4F24_5BB3_4E0A_4E0B_6587 = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587("菲尼克斯尔永恒轮回", config["永恒轮回引导秒"] + 2)
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(context.Boss, "永恒轮回")
    _____5F00_59CB_65BD_6CD5_786C_76F4(context.Boss, config["永恒轮回引导秒"])
    _____8BBE_7F6E_5355_4F4D_52A8_753B(context.Boss, _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["轮回死亡"]["编号"], _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["轮回死亡"]["倍速"])
    _____663E_793A_81F4_547D_8BFB_6761(config["永恒轮回引导秒"], 3, "永恒轮回倒计时", "摧毁凤凰之卵，否则菲尼克斯尔将恢复生命")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["永恒轮回"]["开始"],
        _____53D6_5355_4F4DX(context.Boss),
        _____53D6_5355_4F4DY(context.Boss),
        _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    local points = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["导管点位"]
    do
        local i = 0
        while i < #points do
            local p = points[i + 1]
            local egg = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_673A_5236_5355_4F4D(
                context,
                _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["机制单位ID"]["凤凰之卵"],
                "凤凰之卵",
                _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["模型"]["凤凰之卵"],
                p.x,
                p.y,
                _____53D6_6700_5927_751F_547D(context.Boss) * config["凤凰蛋生命Boss最大生命比例"],
                _____521B_5EFA_51E4_51F0_86CB_6B7B_4EA1_56DE_8C03(context)
            )
            local ____context__51E4_51F0_86CB_5217_8868_0 = context["凤凰蛋列表"]
            ____context__51E4_51F0_86CB_5217_8868_0[#____context__51E4_51F0_86CB_5217_8868_0 + 1] = {["单位"] = egg, ["已摧毁"] = false}
            _____64AD_653E_70B9_7279_6548(_____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["永恒轮回能量上升"], p.x, p.y, 2500)
            i = i + 1
        end
    end
    _____5EF6_8FDF(
        config["永恒轮回引导秒"] * 1000,
        function()
            local aliveEggs = 0
            do
                local i = 0
                while i < #context["凤凰蛋列表"] do
                    if _____5355_4F4D_5B58_6D3B(context["凤凰蛋列表"][i + 1]["单位"]) then
                        aliveEggs = aliveEggs + 1
                    end
                    i = i + 1
                end
            end
            if aliveEggs > 0 then
                _____64AD_653EBoss_5750_6807_97F3_6548(
                    _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["永恒轮回"]["失败结算"],
                    _____53D6_5355_4F4DX(context.Boss),
                    _____53D6_5355_4F4DY(context.Boss),
                    _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
                )
                local heal = _____53D6_6700_5927_751F_547D(context.Boss) * config["每枚存活凤凰蛋回血Boss最大生命比例"] * aliveEggs
                local nextLife = _____53D6_5F53_524D_751F_547D(context.Boss) + heal
                if nextLife > _____53D6_6700_5927_751F_547D(context.Boss) then
                    nextLife = _____53D6_6700_5927_751F_547D(context.Boss)
                end
                _____8BBE_7F6E_5F53_524D_751F_547D(context.Boss, nextLife)
                local heroes = _____53D6_83F2_5C3C_514B_65AF_5C14_73A9_5BB6_82F1_96C4_5217_8868()
                do
                    local i = 0
                    while i < #heroes do
                        _____9020_6210_6697_706B_4F24_5BB3(
                            context.Boss,
                            heroes[i + 1],
                            _____8BA1_7B97_653B_51FB_6700_5927_751F_547D_4F24_5BB3(context.Boss, heroes[i + 1], config["轮回失败全场伤害Boss攻击力比例"], config["轮回失败全场伤害目标最大生命比例"]),
                            "AOE",
                            _____4F24_5BB3_4E0A_4E0B_6587
                        )
                        i = i + 1
                    end
                end
                _____6E05_7406_83F2_5C3C_514B_65AF_5C14_51E4_51F0_86CB(context)
                context["当前形态"] = "第二形态"
                context["永恒轮回已触发"] = false
            else
                _____6E05_7406_83F2_5C3C_514B_65AF_5C14_51E4_51F0_86CB(context)
                KillUnit(context.Boss)
            end
            _____64AD_653E_70B9_7279_6548(
                _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["永恒轮回收拢"],
                _____53D6_5355_4F4DX(context.Boss),
                _____53D6_5355_4F4DY(context.Boss),
                2000
            )
        end
    )
end
____exports["初始化菲尼克斯尔永恒轮回节点"] = function(context)
    local timerId
    timerId = _____5468_671F(
        500,
        function()
            if not _____5355_4F4D_5B58_6D3B(context.Boss) then
                _____505C_6B62_5468_671F(timerId)
                return
            end
            if _____53D6_5F53_524D_751F_547D(context.Boss) <= _____53D6_6700_5927_751F_547D(context.Boss) * _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["永恒轮回触发生命比例"] then
                ____exports["触发菲尼克斯尔永恒轮回"](context)
            end
        end
    )
    local ____self_1 = context["清理"]
    ____self_1["登记周期回调"](____self_1, "菲尼克斯尔-永恒轮回检测", timerId)
end
____exports["注册菲尼克斯尔永恒轮回"] = function()
end
return ____exports
