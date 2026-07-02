--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____Boss_6218_8FD0_884C_5468_671F_56DE_8C03ID
local ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.addPeriodicCallback
local getServerTime = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.getServerTime
local removePeriodicCallback = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.removePeriodicCallback
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.00．常量定义")
local ____Boss_6218_6218_6597_97F3_4E50_5B57_6BB5 = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战战斗音乐字段"]
local ____Boss_6218_80DC_5229_97F3_4E50_5B57_6BB5 = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战胜利音乐字段"]
local ____Boss_6218_8FD0_884CTick_6BEB_79D2 = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战运行Tick毫秒"]
local ____Boss_6218_8FD0_884C_6A21_5757_540D = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战运行模块名"]
local ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.01．Boss战运行上下文")
local _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["创建Boss战运行上下文"]
local _____5F53_524D_662F_5426_5B58_5728Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["当前是否存在Boss战运行上下文"]
local _____83B7_53D6_5168_90E8Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["获取全部Boss战运行上下文"]
local _____83B7_53D6_5168_90E8_77E9_5F62_5F53_524DBoss_6218_4E0A_4E0B_6587 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["获取全部矩形当前Boss战上下文"]
local _____6E05_7406Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["清理Boss战运行上下文"]
local _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["读取Boss战运行上下文"]
local _____8BB0_5F55Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["记录Boss战运行上下文"]
local ____02_FF0EBoss_6218_533A_57DF_97F3_9891 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.02．Boss战区域音频")
local _____5C1D_8BD5_79FB_9664_8FC7_671F_80DC_5229_97F3_9891 = ____02_FF0EBoss_6218_533A_57DF_97F3_9891["尝试移除过期胜利音频"]
local _____7ED3_675FBoss_6218_533A_57DF_97F3_9891 = ____02_FF0EBoss_6218_533A_57DF_97F3_9891["结束Boss战区域音频"]
local ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.04．Boss战运行工具")
local _____5355_4F4D_662F_5426_6B7B_4EA1 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["单位是否死亡"]
local _____8BFB_53D6Boss_6218_77E9_5F62 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["读取Boss战矩形"]
local _____8BFB_53D6Boss_6218_97F3_9891 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["读取Boss战音频"]
local _____8BFB_53D6Boss_6218_5355_4F4D_5E03_5C14 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["读取Boss战单位布尔"]
local _____6267_884CBoss_6218_8F6C_573A_52A8_753B = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["执行Boss战转场动画"]
local _____5B8C_6210Boss_6218_542F_52A8 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["完成Boss战启动"]
local _____5B8C_6210Boss_6218_8F6C_573A_642C_8FD0 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["完成Boss战转场搬运"]
local _____5C1D_8BD5_515C_5E95_641C_654C_5E76_4E0B_4EE4 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["尝试兜底搜敌并下令"]
local _____5F53_524D_662F_5426_5B58_5728_5F85_6E05_7406BossYD_4EFB_52A1 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["当前是否存在待清理BossYD任务"]
local _____83B7_53D6Boss_6218_80DC_5229_63D0_793A_6587_672C = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["获取Boss战胜利提示文本"]
local _____83B7_53D6Boss_6218_8F6C_573A_540E_63D0_793A_6587_672C = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["获取Boss战转场后提示文本"]
local _____83B7_53D6Quest_6D88_606F_5B8C_6210 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["获取Quest消息完成"]
local _____83B7_53D6Quest_6D88_606F_79D8_5BC6 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["获取Quest消息秘密"]
local _____5904_7406_5F85_6E05_7406Boss_5355_4F4DYD_6570_636E = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["处理待清理Boss单位YD数据"]
local _____6E05_7406Boss_6218_5355_4F4D_5B57_6BB5 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["清理Boss战单位字段"]
local _____6E05_7406Boss_7BAD_5934_7279_6548 = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["清理Boss箭头特效"]
local _____767B_8BB0Boss_6B7B_4EA1_5EF6_8FDF_6E05_7406YD_6570_636E = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["登记Boss死亡延迟清理YD数据"]
local _____7EA0_504FBoss_4F4D_7F6E = ____04_FF0EBoss_6218_8FD0_884C_5DE5_5177["纠偏Boss位置"]
local ____05_FF0EBoss_6218_5730_5F62_7EA0_504F = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.05．Boss战地形纠偏")
local _____7EA0_504F_73A9_5BB6_82F1_96C4_4F4D_7F6E_5230Boss = ____05_FF0EBoss_6218_5730_5F62_7EA0_504F["纠偏玩家英雄位置到Boss"]
local ____06_FF0EBoss_6218_62A4_536B = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.06．Boss战护卫")
local _____5904_7406Boss_6218_62A4_536B_542F_52A8 = ____06_FF0EBoss_6218_62A4_536B["处理Boss战护卫启动"]
local _____5904_7406Boss_6218_62A4_536BTick = ____06_FF0EBoss_6218_62A4_536B["处理Boss战护卫Tick"]
local _____5904_7406Boss_6218_62A4_536B_7ED3_675F = ____06_FF0EBoss_6218_62A4_536B["处理Boss战护卫结束"]
local ____index = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.index")
local _____542F_52A8Boss_8840_6761_5F31_70B9_97E7_6027 = ____index["启动Boss血条弱点韧性"]
local _____7ED3_675FBoss_8840_6761_5F31_70B9_97E7_6027 = ____index["结束Boss血条弱点韧性"]
____exports["停止Boss战运行驱动"] = function()
    if ____Boss_6218_8FD0_884C_5468_671F_56DE_8C03ID == 0 then
        return
    end
    removePeriodicCallback(____Boss_6218_8FD0_884C_5468_671F_56DE_8C03ID)
    ____Boss_6218_8FD0_884C_5468_671F_56DE_8C03ID = 0
end
local ____require_result_0 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_0.QuestMessageBJ
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_1.GetPlayersAll
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.05．异界Boss.02．赫萝.index")
local _____542F_52A8_8D6B_841D_663C_591C_88AB_52A8 = ____require_result_4["启动赫萝昼夜被动"]
local _____505C_6B62_8D6B_841D_663C_591C_88AB_52A8 = ____require_result_4["停止赫萝昼夜被动"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.00．配置")
local _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_5["瑟兰迪尔单位技能配置"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.03．运行时上下文")
local _____83B7_53D6_745F_5170_8FEA_5C14_4E0A_4E0B_6587 = ____require_result_6["获取瑟兰迪尔上下文"]
local _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587 = ____require_result_6["获取或创建瑟兰迪尔上下文"]
local _____6E05_7406_745F_5170_8FEA_5C14_4E0A_4E0B_6587 = ____require_result_6["清理瑟兰迪尔上下文"]
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____require_result_6["播放瑟兰迪尔台词"]
local GetUnitTypeId = jass.GetUnitTypeId
____Boss_6218_8FD0_884C_5468_671F_56DE_8C03ID = 0
local _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local function _____662F_745F_5170_8FEA_5C14Boss(bossUnit)
    return bossUnit ~= nil and bossUnit ~= 0 and GetUnitTypeId(bossUnit) == _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID
end
local function _____542F_52A8_745F_5170_8FEA_5C14Boss_8FD0_884C_65F6(bossUnit)
    if not _____662F_745F_5170_8FEA_5C14Boss(bossUnit) then
        return
    end
    local existed = _____83B7_53D6_745F_5170_8FEA_5C14_4E0A_4E0B_6587(bossUnit)
    local context = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587(bossUnit)
    if context ~= nil and existed == nil then
        _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(bossUnit, "开战")
    end
end
local function _____505C_6B62_745F_5170_8FEA_5C14Boss_8FD0_884C_65F6(bossUnit)
    if not _____662F_745F_5170_8FEA_5C14Boss(bossUnit) then
        return
    end
    _____6E05_7406_745F_5170_8FEA_5C14_4E0A_4E0B_6587(bossUnit)
end
local function _____5199_5165_5F53_524DBoss_5168_5C40(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    jglobals.udg_Boss = bossUnit
end
local function _____6E05_7406_5F53_524DBoss_5168_5C40(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    if jglobals.udg_Boss == bossUnit then
        jglobals.udg_Boss = nil
    end
end
local function _____7ED3_675FBoss_6218_8FD0_884C_4E0A_4E0B_6587(context, nowMs)
    if context["是否已结束"] then
        return
    end
    context["是否已结束"] = true
    _____7ED3_675FBoss_8840_6761_5F31_70B9_97E7_6027(context)
    _____5904_7406Boss_6218_62A4_536B_7ED3_675F(context)
    _____505C_6B62_8D6B_841D_663C_591C_88AB_52A8(context["Boss单位"])
    _____505C_6B62_745F_5170_8FEA_5C14Boss_8FD0_884C_65F6(context["Boss单位"])
    _____6E05_7406_5F53_524DBoss_5168_5C40(context["Boss单位"])
    _____6E05_7406Boss_6218_8FD0_884C_4E0A_4E0B_6587(context["Boss单位"])
    _____6E05_7406Boss_6218_5355_4F4D_5B57_6BB5(context["Boss单位"])
    _____6E05_7406Boss_7BAD_5934_7279_6548(context["Boss单位"])
    _____767B_8BB0Boss_6B7B_4EA1_5EF6_8FDF_6E05_7406YD_6570_636E(context, nowMs)
    _____7ED3_675FBoss_6218_533A_57DF_97F3_9891(context, nowMs)
    local ____require_result_7 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.07．异界Boss死亡奖励")
    local _____53D1_653E_5F02_754CBoss_6B7B_4EA1_5956_52B1 = ____require_result_7["发放异界Boss死亡奖励"]
    _____53D1_653E_5F02_754CBoss_6B7B_4EA1_5956_52B1(context["Boss单位"])
    local ____require_result_8 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.06．Boss死亡剧情索引")
    local _____5C1D_8BD5_64AD_653EBoss_6B7B_4EA1_4E3B_7EBF_5267_60C5 = ____require_result_8["尝试播放Boss死亡主线剧情"]
    _____5C1D_8BD5_64AD_653EBoss_6B7B_4EA1_4E3B_7EBF_5267_60C5(context["Boss单位"])
    QuestMessageBJ(
        GetPlayersAll(),
        _____83B7_53D6Quest_6D88_606F_5B8C_6210(),
        _____83B7_53D6Boss_6218_80DC_5229_63D0_793A_6587_672C()
    )
    debugLogForce(
        ____Boss_6218_8FD0_884C_6A21_5757_540D,
        "Boss战结束",
        "boss=",
        context["Boss句柄ID"],
        "generation=",
        context["运行代次"]
    )
end
local function _____63A8_8FDBBoss_6218_542F_52A8_72B6_6001(context, nowMs)
    local _____6FC0_6D3B_524D_72B6_6001 = context["是否已激活"]
    if context["转场提示时间"] > 0 and nowMs >= context["转场提示时间"] then
        QuestMessageBJ(
            GetPlayersAll(),
            _____83B7_53D6Quest_6D88_606F_79D8_5BC6(),
            _____83B7_53D6Boss_6218_8F6C_573A_540E_63D0_793A_6587_672C()
        )
        context["转场提示时间"] = 0
    end
    if context["是否已激活"] then
        return
    end
    if context["等待激活截止时间"] > 0 and nowMs < context["等待激活截止时间"] then
        return
    end
    if context["等待激活截止时间"] > 0 then
        _____5B8C_6210Boss_6218_8F6C_573A_642C_8FD0(context)
        context["等待激活截止时间"] = 0
    end
    _____5B8C_6210Boss_6218_542F_52A8(context)
    if not _____6FC0_6D3B_524D_72B6_6001 and context["是否已激活"] then
        _____542F_52A8Boss_8840_6761_5F31_70B9_97E7_6027(context)
        _____542F_52A8_8D6B_841D_663C_591C_88AB_52A8(context["Boss单位"])
        _____542F_52A8_745F_5170_8FEA_5C14Boss_8FD0_884C_65F6(context["Boss单位"])
        _____5904_7406Boss_6218_62A4_536B_542F_52A8(context)
    end
end
local function _____5F53_524D_662F_5426_4ECD_9700_9A71_52A8Boss_6218_8FD0_884C()
    if _____5F53_524D_662F_5426_5B58_5728Boss_6218_8FD0_884C_4E0A_4E0B_6587() then
        return true
    end
    if _____5F53_524D_662F_5426_5B58_5728_5F85_6E05_7406BossYD_4EFB_52A1() then
        return true
    end
    local rectContexts = _____83B7_53D6_5168_90E8_77E9_5F62_5F53_524DBoss_6218_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #rectContexts do
            local context = rectContexts[i + 1]
            if not context["是否已结束"] then
                return true
            end
            if context["胜利音乐移除时间"] > 0 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function ____onBoss_6218_8FD0_884CTick()
    local nowMs = getServerTime()
    local activeContexts = _____83B7_53D6_5168_90E8Boss_6218_8FD0_884C_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #activeContexts do
            do
                local context = activeContexts[i + 1]
                if context == nil or context["是否已结束"] then
                    goto __continue30
                end
                _____63A8_8FDBBoss_6218_542F_52A8_72B6_6001(context, nowMs)
                if not context["是否已激活"] then
                    goto __continue30
                end
                if _____5355_4F4D_662F_5426_6B7B_4EA1(context["Boss单位"]) then
                    _____7ED3_675FBoss_6218_8FD0_884C_4E0A_4E0B_6587(context, nowMs)
                    goto __continue30
                end
                _____7EA0_504FBoss_4F4D_7F6E(context)
                _____7EA0_504F_73A9_5BB6_82F1_96C4_4F4D_7F6E_5230Boss(context)
                _____5904_7406Boss_6218_62A4_536BTick(context, nowMs)
                _____5C1D_8BD5_515C_5E95_641C_654C_5E76_4E0B_4EE4(context, nowMs)
            end
            ::__continue30::
            i = i + 1
        end
    end
    local rectContexts = _____83B7_53D6_5168_90E8_77E9_5F62_5F53_524DBoss_6218_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #rectContexts do
            local context = rectContexts[i + 1]
            if context ~= nil then
                _____5C1D_8BD5_79FB_9664_8FC7_671F_80DC_5229_97F3_9891(context, nowMs)
            end
            i = i + 1
        end
    end
    _____5904_7406_5F85_6E05_7406Boss_5355_4F4DYD_6570_636E(nowMs)
    if not _____5F53_524D_662F_5426_4ECD_9700_9A71_52A8Boss_6218_8FD0_884C() then
        ____exports["停止Boss战运行驱动"]()
    end
end
local function _____786E_4FDDBoss_6218_8FD0_884C_9A71_52A8()
    if ____Boss_6218_8FD0_884C_5468_671F_56DE_8C03ID ~= 0 then
        return
    end
    ____Boss_6218_8FD0_884C_5468_671F_56DE_8C03ID = addPeriodicCallback(____Boss_6218_8FD0_884CTick_6BEB_79D2, ____onBoss_6218_8FD0_884CTick)
end
____exports["启动Boss战运行"] = function(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    _____5199_5165_5F53_524DBoss_5168_5C40(bossUnit)
    local oldContext = _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(bossUnit)
    if oldContext ~= nil and not oldContext["是否已结束"] then
        return
    end
    local rectHandle = _____8BFB_53D6Boss_6218_77E9_5F62()
    local battleSound = _____8BFB_53D6Boss_6218_97F3_9891(____Boss_6218_6218_6597_97F3_4E50_5B57_6BB5)
    local victorySound = _____8BFB_53D6Boss_6218_97F3_9891(____Boss_6218_80DC_5229_97F3_4E50_5B57_6BB5)
    local context = _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587(bossUnit, rectHandle, battleSound, victorySound)
    if context == nil then
        return
    end
    _____8BB0_5F55Boss_6218_8FD0_884C_4E0A_4E0B_6587(context)
    _____786E_4FDDBoss_6218_8FD0_884C_9A71_52A8()
    if _____8BFB_53D6Boss_6218_5355_4F4D_5E03_5C14(bossUnit, "转换场景") then
        local nowMs = getServerTime()
        context["等待激活截止时间"] = nowMs + 2000
        context["转场提示时间"] = nowMs + 3000
        _____6267_884CBoss_6218_8F6C_573A_52A8_753B()
    else
        _____5B8C_6210Boss_6218_542F_52A8(context)
        if context["是否已激活"] then
            _____542F_52A8Boss_8840_6761_5F31_70B9_97E7_6027(context)
            _____542F_52A8_745F_5170_8FEA_5C14Boss_8FD0_884C_65F6(context["Boss单位"])
        end
    end
    debugLogForce(
        ____Boss_6218_8FD0_884C_6A21_5757_540D,
        "启动Boss战运行",
        "boss=",
        context["Boss句柄ID"],
        "rect=",
        context["地点句柄ID"]
    )
end
return ____exports
