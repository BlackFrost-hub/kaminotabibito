--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local _____7C73_4E9A_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚音效配置"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["执行战斗自身传送到坐标"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_0["获取Boss技能敌对英雄列表"]
local ____require_result_1 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_1["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_1["关闭吟唱条"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_2["开始硬直"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local _____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____require_result_4["创建循环点特效"]
local jass = require("jass.common")
local GetRandomInt = jass.GetRandomInt
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitFacing = jass.SetUnitFacing
local SetUnitTimeScale = jass.SetUnitTimeScale
local Atan2 = jass.Atan2
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local BJ_RADTODEG = 57.29577951308232
local function _____53D6_5E73_53F0ID(_____533A_57DF)
    return _____533A_57DF["配置"].ID or _____533A_57DF["配置"]["名称"] or ""
end
local function _____53D6_5E73_53F0_63D0_793A_534A_5F84(_____533A_57DF)
    local _____5BBD = _____533A_57DF["配置"]["右"] - _____533A_57DF["配置"]["左"]
    local _____9AD8 = _____533A_57DF["配置"]["上"] - _____533A_57DF["配置"]["下"]
    return (_____5BBD > _____9AD8 and _____5BBD or _____9AD8) * 0.72
end
local function _____9762_5411_5E73_53F0(boss, _____533A_57DF)
    local angle = Atan2(
        _____533A_57DF["中心Y"] - GetUnitY(boss),
        _____533A_57DF["中心X"] - GetUnitX(boss)
    ) * BJ_RADTODEG
    SetUnitFacing(boss, angle)
end
local function _____9009_62E9_6C61_67D3_5E73_53F0(context)
    local _____533A_57DF_7EC4 = context["安全域区域组"]
    if _____533A_57DF_7EC4 == nil or #_____533A_57DF_7EC4["区域列表"] <= 0 then
        return nil
    end
    local _____5019_9009 = {}
    do
        local i = 0
        while i < #_____533A_57DF_7EC4["区域列表"] do
            local _____533A_57DF = _____533A_57DF_7EC4["区域列表"][i + 1]
            if _____53D6_5E73_53F0ID(_____533A_57DF) ~= context["腐化转移污染平台ID"] then
                _____5019_9009[#_____5019_9009 + 1] = _____533A_57DF
            end
            i = i + 1
        end
    end
    if #_____5019_9009 <= 0 then
        return _____533A_57DF_7EC4["区域列表"][1]
    end
    return _____5019_9009[GetRandomInt(0, #_____5019_9009 - 1) + 1]
end
local function _____64AD_653E_5165_51FA_6C34_8868_73B0(x, y)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["入出水水花"],
        X = x,
        Y = y,
        Z = 0,
        ["缩放"] = 1.2,
        ["动画速度"] = 2,
        ["持续秒"] = 1.4
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["入出水毒雾1"],
        X = x,
        Y = y,
        Z = 0,
        ["缩放"] = 1.1,
        ["持续秒"] = 1.4
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["入出水毒雾2"],
        X = x,
        Y = y,
        Z = 0,
        ["缩放"] = 1.1,
        ["动画速度"] = 0,
        ["持续秒"] = 1.4
    })
end
local function _____64AD_653E_5E73_53F0_9884_8B66(_____533A_57DF)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化转移"]
    local _____534A_5F84 = _____53D6_5E73_53F0_63D0_793A_534A_5F84(_____533A_57DF)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "敌方圆形",
        X = _____533A_57DF["中心X"],
        Y = _____533A_57DF["中心Y"],
        ["半径"] = _____534A_5F84,
        ["持续时间"] = config["预警秒"],
        ["动画速度"] = 1 / config["预警秒"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["平台预警底圈"],
        X = _____533A_57DF["中心X"],
        Y = _____533A_57DF["中心Y"],
        Z = 18,
        ["缩放"] = 1.15,
        ["红"] = 80,
        ["绿"] = 255,
        ["蓝"] = 80,
        ["透明度"] = 230,
        ["持续秒"] = config["预警秒"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["腐化残留云"],
        X = _____533A_57DF["中心X"],
        Y = _____533A_57DF["中心Y"],
        Z = 20,
        ["缩放"] = 0.55,
        ["持续秒"] = config["预警秒"]
    })
end
local function _____5F00_59CB_6C61_67D3_5E73_53F0(context, _____533A_57DF, nowMs)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化转移"]
    local id = _____53D6_5E73_53F0ID(_____533A_57DF)
    if id == "" then
        return
    end
    context["腐化转移污染平台ID"] = id
    context["腐化转移污染结束Ms"] = nowMs + config["平台污染持续秒"] * 1000
    context["腐化转移下次叠层Ms"] = nowMs + 1000
    _____64AD_653EBoss_5750_6807_97F3_6548(_____7C73_4E9A_97F3_6548_914D_7F6E["腐化转移"]["平台污染"], _____533A_57DF["中心X"], _____533A_57DF["中心Y"], _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"])
    _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["腐化残留云"],
        X = _____533A_57DF["中心X"],
        Y = _____533A_57DF["中心Y"],
        Z = 0,
        ["缩放"] = 0.5,
        ["总持续秒"] = config["平台污染持续秒"],
        ["重建间隔秒"] = 3,
        ["单次持续秒"] = 2.8,
        ["存活条件"] = function()
            return context["腐化转移污染平台ID"] == id and _____5355_4F4D_6709_6548(context["Boss单位"])
        end
    })
    _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "腐化转移", 1)
end
____exports["刷新米亚腐化转移污染平台"] = function(context, nowMs)
    local id = context["腐化转移污染平台ID"] or ""
    if id == "" then
        return
    end
    if nowMs >= context["腐化转移污染结束Ms"] then
        context["腐化转移污染平台ID"] = ""
        context["腐化转移污染结束Ms"] = 0
        context["腐化转移下次叠层Ms"] = 0
        return
    end
    if nowMs < context["腐化转移下次叠层Ms"] then
        return
    end
    context["腐化转移下次叠层Ms"] = nowMs + 1000
    local _____533A_57DF = nil
    local _____533A_57DF_5217_8868 = context["安全域区域组"]["区域列表"]
    do
        local i = 0
        while i < #_____533A_57DF_5217_8868 do
            if _____53D6_5E73_53F0ID(_____533A_57DF_5217_8868[i + 1]) == id then
                _____533A_57DF = _____533A_57DF_5217_8868[i + 1]
                break
            end
            i = i + 1
        end
    end
    if _____533A_57DF == nil then
        return
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue25
                end
                local x = GetUnitX(hero)
                local y = GetUnitY(hero)
                if x < _____533A_57DF["配置"]["左"] or x > _____533A_57DF["配置"]["右"] or y < _____533A_57DF["配置"]["下"] or y > _____533A_57DF["配置"]["上"] then
                    goto __continue25
                end
                _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, hero, _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化转移"]["每秒腐化层数"], "腐化转移污染平台")
            end
            ::__continue25::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_8150_5316_8F6C_79FB_65F6_95F4_8F74_4E8B_4EF6(context, nowMs, _____533A_57DF)
    local boss = context["Boss单位"]
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化转移"]
    local _____9884_8B66_6BEB_79D2 = config["预警秒"] * 1000
    return {
        {
            ["时点毫秒"] = 0,
            ["名称"] = "腐化转移开始",
            ["执行"] = function()
                if not _____5355_4F4D_6709_6548(boss) then
                    return
                end
                _____9762_5411_5E73_53F0(boss, _____533A_57DF)
                _____5F00_59CB_786C_76F4(boss, config["预警秒"])
                SetUnitTimeScale(boss, config["预警动画速度"])
                SetUnitAnimationByIndex(boss, config["预警动画编号"])
                _____64AD_653E_5E73_53F0_9884_8B66(_____533A_57DF)
                _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "腐化转移", 0)
                _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({["总时长"] = config["预警秒"], ["颜色ID"] = 3, ["标题文本"] = "腐化转移", ["提示文本"] = "米亚正在污染安全区！离开目标平台！"})
            end
        },
        {
            ["时点毫秒"] = config["弓背冻结延迟Ms"],
            ["名称"] = "腐化转移弓背冻结",
            ["执行"] = function()
                if _____5355_4F4D_6709_6548(context["Boss单位"]) then
                    SetUnitTimeScale(context["Boss单位"], config["弓背冻结动画速度"])
                end
            end
        },
        {
            ["时点毫秒"] = _____9884_8B66_6BEB_79D2,
            ["名称"] = "腐化转移落点生效",
            ["执行"] = function()
                local currentBoss = context["Boss单位"]
                _____5173_95ED_541F_5531_6761("常规技能")
                if not _____5355_4F4D_6709_6548(currentBoss) or context["阶段"] < 2 then
                    return
                end
                local _____539FX = GetUnitX(currentBoss)
                local _____539FY = GetUnitY(currentBoss)
                if not _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(currentBoss, _____533A_57DF["中心X"], _____533A_57DF["中心Y"]) then
                    SetUnitTimeScale(currentBoss, config["恢复动画速度"])
                    SetUnitAnimationByIndex(currentBoss, config["恢复动画编号"])
                    return
                end
                _____64AD_653E_5165_51FA_6C34_8868_73B0(_____539FX, _____539FY)
                SetUnitTimeScale(currentBoss, config["出水动画速度"])
                SetUnitAnimationByIndex(currentBoss, config["出水动画编号"])
                _____64AD_653E_5165_51FA_6C34_8868_73B0(_____533A_57DF["中心X"], _____533A_57DF["中心Y"])
                _____5F00_59CB_6C61_67D3_5E73_53F0(context, _____533A_57DF, nowMs + _____9884_8B66_6BEB_79D2)
            end
        },
        {
            ["时点毫秒"] = _____9884_8B66_6BEB_79D2 + config["恢复动作延迟Ms"],
            ["名称"] = "腐化转移恢复动作",
            ["执行"] = function()
                if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
                    return
                end
                SetUnitTimeScale(context["Boss单位"], config["恢复动画速度"])
                SetUnitAnimationByIndex(context["Boss单位"], config["恢复动画编号"])
            end
        }
    }
end
local function _____542F_52A8_8150_5316_8F6C_79FB(context, nowMs, _____533A_57DF)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化转移"]
    if context["腐化转移组合执行器"] == nil then
        context["腐化转移组合执行器"] = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "米亚-腐化转移", ["清理"] = context["清理"], ["互斥组"] = "米亚普通技能"})
    end
    local ____self_5 = context["腐化转移组合执行器"]
    local _____6267_884CID = ____self_5["开始"](
        ____self_5,
        {
            key = "腐化转移",
            ["单位"] = context["Boss单位"],
            ["上下文"] = context,
            ["最大持续毫秒"] = config["预警秒"] * 1000 + config["恢复动作延迟Ms"] + 500,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868(_____521B_5EFA_8150_5316_8F6C_79FB_65F6_95F4_8F74_4E8B_4EF6(context, nowMs, _____533A_57DF)),
            ["结束回调"] = function(event)
                if event["原因"] == "完成" then
                    return
                end
                _____5173_95ED_541F_5531_6761("常规技能")
                if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
                    return
                end
                SetUnitTimeScale(context["Boss单位"], config["恢复动画速度"])
                SetUnitAnimationByIndex(context["Boss单位"], config["恢复动画编号"])
            end
        }
    )
    return _____6267_884CID ~= 0
end
____exports["释放米亚腐化转移"] = function(context, nowMs)
    if context["阶段"] < 2 or (context["腐化转移污染平台ID"] or "") ~= "" or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return false
    end
    local _____533A_57DF = _____9009_62E9_6C61_67D3_5E73_53F0(context)
    if _____533A_57DF == nil then
        return false
    end
    return _____542F_52A8_8150_5316_8F6C_79FB(context, nowMs, _____533A_57DF)
end
return ____exports
