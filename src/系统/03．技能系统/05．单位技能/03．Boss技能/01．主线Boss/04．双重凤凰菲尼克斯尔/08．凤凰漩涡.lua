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
local _____521B_5EFA_9884_8B66_5706 = ____19_FF0E_516C_5171_5DE5_5177["创建预警圆"]
local _____64AD_653E_70B9_7279_6548 = ____19_FF0E_516C_5171_5DE5_5177["播放点特效"]
local _____8303_56F4_654C_4EBA = ____19_FF0E_516C_5171_5DE5_5177["范围敌人"]
local _____8BA1_7B97_653B_51FB_5DF2_635F_5931_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["计算攻击已损失伤害"]
local _____9020_6210_706B_7130_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["造成火焰伤害"]
local _____6DFB_52A0_5143_7D20_5C42_6570 = ____19_FF0E_516C_5171_5DE5_5177["添加元素层数"]
local _____53D6_5355_4F4DX = ____19_FF0E_516C_5171_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____19_FF0E_516C_5171_5DE5_5177["取单位Y"]
local _____4E24_70B9_8DDD_79BB = ____19_FF0E_516C_5171_5DE5_5177["两点距离"]
local _____6781_5750_6807X = ____19_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____79FB_52A8_5355_4F4D_5230 = ____19_FF0E_516C_5171_5DE5_5177["移动单位到"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local Atan2 = jass.Atan2
local RAD_TO_DEG = 57.29577951308232
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____51E4_51F0_6F29_6DA1_6280_80FDID = stringToFourCC(_____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["凤凰漩涡"])
local _____51E4_51F0_6F29_6DA1_5DF2_6CE8_518C = false
____exports["释放菲尼克斯尔凤凰漩涡"] = function(context, target, _____6280_80FD_5B9E_4F8BID)
    if context["当前形态"] ~= "第一形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
        return
    end
    local boss = context.Boss
    local realTarget = _____53D6_76EE_6807_6216_968F_673A_73A9_5BB6(boss, target)
    if not _____5355_4F4D_5B58_6D3B(realTarget) then
        return
    end
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["凤凰漩涡"]
    local _____4F24_5BB3_4E0A_4E0B_6587 = {["技能ID"] = _____51E4_51F0_6F29_6DA1_6280_80FDID, ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID, ["标签"] = "菲尼克斯尔凤凰漩涡"}
    local x = _____53D6_5355_4F4DX(realTarget)
    local y = _____53D6_5355_4F4DY(realTarget)
    _____9762_5411_5355_4F4D(boss, realTarget)
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(boss, "凤凰漩涡")
    _____5F00_59CB_65BD_6CD5_786C_76F4(boss, config["预警秒"])
    _____8BBE_7F6E_5355_4F4D_52A8_753B(boss, _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第一形态"]["漩涡施法"]["编号"], _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第一形态"]["漩涡施法"]["倍速"])
    _____663E_793A_5E38_89C4_8BFB_6761(config["预警秒"], config["吟唱条颜色ID"], config["吟唱条标题文本"], config["吟唱条提示文本"])
    _____521B_5EFA_9884_8B66_5706(x, y, config["半径"], config["预警秒"])
    _____5EF6_8FDF(
        config["预警秒"] * 1000,
        function()
            _____64AD_653E_70B9_7279_6548(_____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["漩涡"], x, y, config["持续秒"] * 1000)
            _____64AD_653EBoss_5750_6807_97F3_6548(_____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["凤凰漩涡"]["形成牵引"], x, y, _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"])
            local elapsed = 0
            local tick
            tick = _____5468_671F(
                config["Tick秒"] * 1000,
                function()
                    elapsed = elapsed + config["Tick秒"]
                    local enemies = _____8303_56F4_654C_4EBA(boss, x, y, config["半径"])
                    do
                        local i = 0
                        while i < #enemies do
                            local u = enemies[i + 1]
                            _____9020_6210_706B_7130_4F24_5BB3(
                                boss,
                                u,
                                _____8BA1_7B97_653B_51FB_5DF2_635F_5931_4F24_5BB3(boss, u, config["伤害Boss攻击力比例"], config["伤害目标已损失生命比例"]),
                                "AOE",
                                _____4F24_5BB3_4E0A_4E0B_6587
                            )
                            _____6DFB_52A0_5143_7D20_5C42_6570(u, "火", config["火印层数"])
                            local d = _____4E24_70B9_8DDD_79BB(
                                _____53D6_5355_4F4DX(u),
                                _____53D6_5355_4F4DY(u),
                                x,
                                y
                            )
                            if d > config["中心半径"] then
                                local angle = Atan2(
                                    y - _____53D6_5355_4F4DY(u),
                                    x - _____53D6_5355_4F4DX(u)
                                ) * RAD_TO_DEG
                                _____79FB_52A8_5355_4F4D_5230(
                                    u,
                                    _____6781_5750_6807X(
                                        _____53D6_5355_4F4DX(u),
                                        config["牵引距离"],
                                        angle
                                    ),
                                    _____6781_5750_6807Y(
                                        _____53D6_5355_4F4DY(u),
                                        config["牵引距离"],
                                        angle
                                    )
                                )
                            end
                            i = i + 1
                        end
                    end
                    if elapsed >= config["持续秒"] then
                        _____505C_6B62_5468_671F(tick)
                    end
                end
            )
            local ____self_0 = context["清理"]
            ____self_0["登记周期回调"](____self_0, "菲尼克斯尔凤凰漩涡Tick", tick)
        end
    )
end
local function ____on_83F2_5C3C_514B_65AF_5C14_51E4_51F0_6F29_6DA1_751F_6548(castingUnit, spellAbilityId, _____6280_80FD_5B9E_4F8BID)
    if spellAbilityId ~= _____51E4_51F0_6F29_6DA1_6280_80FDID then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(castingUnit)
    if context ~= nil then
        ____exports["释放菲尼克斯尔凤凰漩涡"](context, nil, _____6280_80FD_5B9E_4F8BID)
    end
end
____exports["注册菲尼克斯尔凤凰漩涡"] = function()
    if _____51E4_51F0_6F29_6DA1_5DF2_6CE8_518C then
        return
    end
    _____51E4_51F0_6F29_6DA1_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "菲尼克斯尔凤凰漩涡",
        ["单位类型ID"] = _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____51E4_51F0_6F29_6DA1_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss, _____6280_80FD_5B9E_4F8BID)
            ____on_83F2_5C3C_514B_65AF_5C14_51E4_51F0_6F29_6DA1_751F_6548(boss, _____51E4_51F0_6F29_6DA1_6280_80FDID, _____6280_80FD_5B9E_4F8BID)
        end
    })
end
return ____exports
