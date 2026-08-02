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
local ____03_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口")
local _____5F00_59CB_8DF3_8DC3 = ____03_FF0E_5BF9_5916_63A5_53E3["开始跳跃"]
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_0["获取Boss技能敌对英雄列表"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_3["创建点特效"]
local _____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____require_result_3["创建循环点特效"]
local jass = require("jass.common")
local GetRandomInt = jass.GetRandomInt
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitFacing = jass.SetUnitFacing
local SetUnitTimeScale = jass.SetUnitTimeScale
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local BJ_RADTODEG = 57.29577951308232
local _____7C73_4E9A_8150_5316_8F6C_79FB_8DF3_8DC3_6570_636E_8868 = {}
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
local function _____9009_62E9_6C61_67D3_5E73_53F0(context, _____6307_5B9A_533A_57DF)
    local _____533A_57DF_7EC4 = context["安全域区域组"]
    if _____533A_57DF_7EC4 == nil or #_____533A_57DF_7EC4["区域列表"] <= 0 then
        return nil
    end
    if _____6307_5B9A_533A_57DF ~= nil then
        local _____6307_5B9A_5E73_53F0ID = _____53D6_5E73_53F0ID(_____6307_5B9A_533A_57DF)
        do
            local i = 0
            while i < #_____533A_57DF_7EC4["区域列表"] do
                local _____533A_57DF = _____533A_57DF_7EC4["区域列表"][i + 1]
                if _____533A_57DF == _____6307_5B9A_533A_57DF or _____6307_5B9A_5E73_53F0ID ~= "" and _____53D6_5E73_53F0ID(_____533A_57DF) == _____6307_5B9A_5E73_53F0ID then
                    return _____533A_57DF
                end
                i = i + 1
            end
        end
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
    local _____9009_62E9_5217_8868 = #_____5019_9009 > 0 and _____5019_9009 or _____533A_57DF_7EC4["区域列表"]
    return _____9009_62E9_5217_8868[GetRandomInt(0, #_____9009_62E9_5217_8868 - 1) + 1]
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
local function _____7ED3_675F_7C73_4E9A_8150_5316_8F6C_79FB_8DF3_8DC3(_unit, _____539F_56E0, _____8DF3_8DC3ID)
    local data = _____7C73_4E9A_8150_5316_8F6C_79FB_8DF3_8DC3_6570_636E_8868[_____8DF3_8DC3ID]
    _____7C73_4E9A_8150_5316_8F6C_79FB_8DF3_8DC3_6570_636E_8868[_____8DF3_8DC3ID] = nil
    if data == nil or _____539F_56E0 ~= "完成" then
        return
    end
    local boss = data.context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    _____9762_5411_5E73_53F0(boss, data["区域"])
    _____64AD_653E_5165_51FA_6C34_8868_73B0(
        GetUnitX(boss),
        GetUnitY(boss)
    )
end
local function _____5F00_59CB_7C73_4E9A_8150_5316_8F6C_79FB_8DF3_8DC3(context, _____533A_57DF)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return false
    end
    local _____8D77_70B9X = GetUnitX(boss)
    local _____8D77_70B9Y = GetUnitY(boss)
    local dx = _____533A_57DF["中心X"] - _____8D77_70B9X
    local dy = _____533A_57DF["中心Y"] - _____8D77_70B9Y
    local _____8DDD_79BB = SquareRoot(dx * dx + dy * dy)
    if not (_____8DDD_79BB > 1) then
        return false
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化转移"]
    local _____8DF3_8DC3ID = _____5F00_59CB_8DF3_8DC3(boss, {
        ["目标X"] = _____533A_57DF["中心X"],
        ["目标Y"] = _____533A_57DF["中心Y"],
        ["距离"] = _____8DDD_79BB,
        ["持续时间"] = config["跳跃持续秒"],
        ["跳跃高度"] = config["跳跃高度"],
        ["暂停单位"] = true,
        ["朝向跟随跳跃"] = true,
        ["主单位"] = boss,
        ["主单位死亡时中断"] = true,
        ["结束回调"] = _____7ED3_675F_7C73_4E9A_8150_5316_8F6C_79FB_8DF3_8DC3
    })
    if _____8DF3_8DC3ID <= 0 then
        return false
    end
    _____7C73_4E9A_8150_5316_8F6C_79FB_8DF3_8DC3_6570_636E_8868[_____8DF3_8DC3ID] = {context = context, ["区域"] = _____533A_57DF}
    _____64AD_653E_5165_51FA_6C34_8868_73B0(_____8D77_70B9X, _____8D77_70B9Y)
    SetUnitTimeScale(boss, config["出水动画速度"])
    SetUnitAnimationByIndex(boss, config["出水动画编号"])
    return true
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
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"]) or ({})
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue35
                end
                local x = GetUnitX(hero)
                local y = GetUnitY(hero)
                if x < _____533A_57DF["配置"]["左"] or x > _____533A_57DF["配置"]["右"] or y < _____533A_57DF["配置"]["下"] or y > _____533A_57DF["配置"]["上"] then
                    goto __continue35
                end
                _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, hero, _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化转移"]["每秒腐化层数"], "腐化转移污染平台")
            end
            ::__continue35::
            i = i + 1
        end
    end
end
local function _____6062_590D_7C73_4E9A_8150_5316_8F6C_79FB_52A8_4F5C(boss, config)
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    SetUnitTimeScale(boss, config["恢复动画速度"])
    SetUnitAnimationByIndex(boss, config["恢复动画编号"])
end
local function _____542F_52A8_8150_5316_8F6C_79FB(context, nowMs, _____533A_57DF)
    local boss = context["Boss单位"]
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化转移"]
    context["腐化转移施法中"] = true
    local _____6D41_7A0B = _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "米亚-腐化转移",
        ["施法者"] = boss,
        ["目标X"] = _____533A_57DF["中心X"],
        ["目标Y"] = _____533A_57DF["中心Y"],
        ["硬直秒"] = config["预警秒"],
        ["生效延迟秒"] = config["预警秒"],
        ["完成延迟毫秒"] = config["恢复动作延迟Ms"],
        ["动画编号"] = config["预警动画编号"],
        ["动画速度"] = config["预警动画速度"],
        ["后续动画速度"] = config["弓背冻结动画速度"],
        ["后续动画延迟毫秒"] = config["弓背冻结延迟Ms"],
        ["完成后恢复动作"] = false,
        ["清理"] = context["清理"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["预警秒"],
            ["颜色ID"] = 3,
            ["标题文本"] = "腐化转移",
            ["提示文本"] = ((("预警" .. tostring(config["预警秒"])) .. "秒后跳向目标平台并污染") .. tostring(config["平台污染持续秒"])) .. "秒（离开红色预警平台）。"
        },
        ["播放台词"] = function()
            _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "腐化转移", 0)
        end,
        ["on生效"] = function()
            local currentBoss = context["Boss单位"]
            if not _____5355_4F4D_6709_6548(currentBoss) or context["阶段"] < 2 then
                _____6062_590D_7C73_4E9A_8150_5316_8F6C_79FB_52A8_4F5C(currentBoss, config)
                return
            end
            if not _____5F00_59CB_7C73_4E9A_8150_5316_8F6C_79FB_8DF3_8DC3(context, _____533A_57DF) then
                _____6062_590D_7C73_4E9A_8150_5316_8F6C_79FB_52A8_4F5C(currentBoss, config)
                return
            end
            _____5F00_59CB_6C61_67D3_5E73_53F0(context, _____533A_57DF, nowMs + config["预警秒"] * 1000)
        end,
        ["on结束"] = function(_____539F_56E0)
            context["腐化转移施法中"] = false
            if _____539F_56E0 == "完成" then
                _____6062_590D_7C73_4E9A_8150_5316_8F6C_79FB_52A8_4F5C(context["Boss单位"], config)
            end
        end
    })
    return _____6D41_7A0B ~= nil and not _____6D41_7A0B["是否结束"](_____6D41_7A0B)
end
____exports["释放米亚腐化转移"] = function(context, nowMs, _____6307_5B9A_533A_57DF)
    if context == nil then
        return false
    end
    local boss = context["Boss单位"]
    local _____5F53_524D_6C61_67D3_5E73_53F0ID = context["腐化转移污染平台ID"] or ""
    if context["阶段"] < 2 then
        return false
    end
    if context["腐化转移施法中"] then
        return false
    end
    if _____5F53_524D_6C61_67D3_5E73_53F0ID ~= "" then
        return false
    end
    if not _____5355_4F4D_6709_6548(boss) then
        return false
    end
    local _____533A_57DF = _____9009_62E9_6C61_67D3_5E73_53F0(context, _____6307_5B9A_533A_57DF)
    if _____533A_57DF == nil then
        return false
    end
    return _____542F_52A8_8150_5316_8F6C_79FB(context, nowMs, _____533A_57DF)
end
return ____exports
