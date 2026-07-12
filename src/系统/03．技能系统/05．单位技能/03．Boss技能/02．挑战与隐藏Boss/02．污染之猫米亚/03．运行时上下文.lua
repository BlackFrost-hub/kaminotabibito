--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5C42_6570_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.01．层数状态.index")
local _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001 = ____01_FF0E_5C42_6570_72B6_6001["创建可配置层数状态"]
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置")
local _____521B_5EFA_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4 = ____01_FF0E_573A_5730_914D_7F6E["创建米亚安全域矩形组"]
local _____6E05_7406_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4 = ____01_FF0E_573A_5730_914D_7F6E["清理米亚安全域矩形组"]
local _____53D6_7C73_4E9A_5355_4F4D_6240_5728_5B89_5168_57DF = ____01_FF0E_573A_5730_914D_7F6E["取米亚单位所在安全域"]
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心X"]
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心Y"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚腐化感染配置"]
local _____7C73_4E9A_9636_6BB5_9608_503C = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚阶段阈值"]
local _____7C73_4E9A_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚音效配置"]
local ____07_FF0E_7075_732B_5206_8EAB = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.07．灵猫分身")
local _____5C1D_8BD5_89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB = ____07_FF0E_7075_732B_5206_8EAB["尝试触发米亚灵猫分身"]
local ____08_FF0E_6C61_67D3_6807_8BB0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.08．污染标记")
local _____5237_65B0_7C73_4E9A_6C61_67D3_6807_8BB0 = ____08_FF0E_6C61_67D3_6807_8BB0["刷新米亚污染标记"]
local ____09_FF0E_6C61_67D3_8109_51B2 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.09．污染脉冲")
local _____5C1D_8BD5_89E6_53D1_7C73_4E9A_6C61_67D3_8109_51B2 = ____09_FF0E_6C61_67D3_8109_51B2["尝试触发米亚污染脉冲"]
local ____10_FF0E_6C61_6C34_67F1_7206_53D1 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.10．污水柱爆发")
local _____5C1D_8BD5_89E6_53D1_7C73_4E9A_6C61_6C34_67F1_7206_53D1 = ____10_FF0E_6C61_6C34_67F1_7206_53D1["尝试触发米亚污水柱爆发"]
local ____11_FF0E_8150_5316_8F6C_79FB = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.11．腐化转移")
local _____5C1D_8BD5_89E6_53D1_7C73_4E9A_8150_5316_8F6C_79FB = ____11_FF0E_8150_5316_8F6C_79FB["尝试触发米亚腐化转移"]
local ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.12．平台超载惩罚")
local _____5237_65B0_7C73_4E9A_5E73_53F0_8D85_8F7D_60E9_7F5A = ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A["刷新米亚平台超载惩罚"]
local ____13_FF0E_8150_5316_9ECF_6DB2_6D82_5C42 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.13．腐化黏液涂层")
local _____5237_65B0_7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42 = ____13_FF0E_8150_5316_9ECF_6DB2_6D82_5C42["刷新米亚腐化黏液涂层"]
local ____14_FF0E_7EC8_6781_6C61_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.14．终极污染")
local _____5C1D_8BD5_89E6_53D1_7C73_4E9A_7EC8_6781_6C61_67D3 = ____14_FF0E_7EC8_6781_6C61_67D3["尝试触发米亚终极污染"]
local _____6E05_7406_7C73_4E9A_7EC8_6781_6C61_67D3 = ____14_FF0E_7EC8_6781_6C61_67D3["清理米亚终极污染"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["延迟播放Boss坐标音效"]
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local IsUnitType = jass.IsUnitType
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____7C73_4E9A_8FD0_884C_65F6_5DF2_6CE8_518C = false
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____521B_5EFA_7C73_4E9A_8150_5316_5C42_6570_63A7_5236_5668(context)
    return _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001({
        ["状态ID"] = "mia-corruption",
        ["最大层数"] = _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E["最大层数"],
        ["衰减"] = {
            ["等待秒"] = _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E["普通衰减等待秒"],
            ["间隔秒"] = _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E["普通衰减间隔秒"],
            ["每次减少层数"] = 1,
            ["加速条件"] = function(_____5355_4F4D)
                local _____533A_57DF = _____53D6_7C73_4E9A_5355_4F4D_6240_5728_5B89_5168_57DF(_____5355_4F4D, context["安全域区域组"])
                if _____533A_57DF == nil then
                    return false
                end
                local id = _____533A_57DF["配置"].ID or _____533A_57DF["配置"]["名称"] or ""
                if id ~= "" and context["腐化转移污染平台ID"] == id then
                    return false
                end
                if id ~= "" and context["超载平台ID表"][id] == true then
                    return false
                end
                return true
            end,
            ["加速等待秒"] = _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E["安全平台衰减等待秒"],
            ["加速间隔秒"] = _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E["安全平台衰减间隔秒"]
        },
        ["表现档位"] = {{["键"] = "低层", ["最小层数"] = 1, ["最大层数"] = 6}, {["键"] = "中层", ["最小层数"] = 7, ["最大层数"] = 11}, {["键"] = "高层", ["最小层数"] = 12, ["最大层数"] = 15}}
    })
end
local function _____521B_5EFA_7C73_4E9A_4E0A_4E0B_6587(boss, _____6E05_7406)
    local context = {
        ["Boss单位"] = boss,
        ["阶段"] = 1,
        ["开战时间Ms"] = getServerTime(),
        ["清理"] = _____6E05_7406,
        ["安全域区域组"] = _____521B_5EFA_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4(),
        ["腐化层数控制器"] = nil,
        ["已触发分身80"] = false,
        ["已触发分身50"] = false,
        ["污染标记目标"] = nil,
        ["上次污染标记低频台词Ms"] = 0,
        ["已触发终极污染30"] = false,
        ["已触发终极污染15"] = false,
        ["上次腐化爪击Ms"] = 0,
        ["上次污水喷吐Ms"] = 0,
        ["上次污染标记Ms"] = 0,
        ["上次污染脉冲Ms"] = 0,
        ["上次污水柱爆发Ms"] = 0,
        ["上次腐化转移Ms"] = 0,
        ["上次平台超载检测Ms"] = 0,
        ["上次全场甩黏液Ms"] = 0,
        ["腐化转移污染平台ID"] = "",
        ["腐化转移污染结束Ms"] = 0,
        ["腐化转移下次叠层Ms"] = 0,
        ["超载平台ID表"] = {},
        ["超载平台下次叠层Ms表"] = {},
        ["上次平台超载台词Ms"] = 0,
        ["终极污染引导中"] = false,
        ["终极污染开始Ms"] = 0,
        ["终极污染结束Ms"] = 0,
        ["终极污染核心列表"] = {},
        ["终极污染本次叠层表"] = {}
    }
    context["腐化层数控制器"] = _____521B_5EFA_7C73_4E9A_8150_5316_5C42_6570_63A7_5236_5668(context)
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "开场", 0)
    return context
end
local function _____6E05_7406_7C73_4E9A_4E0A_4E0B_6587_673A_5236(context)
    _____6E05_7406_7C73_4E9A_7EC8_6781_6C61_67D3(context)
    local ____self_1 = context["腐化层数控制器"]
    ____self_1["销毁"](____self_1)
    _____6E05_7406_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4(context["安全域区域组"])
end
local _____7C73_4E9A_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "米亚", ["主动技能提示"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"], ["创建上下文"] = _____521B_5EFA_7C73_4E9A_4E0A_4E0B_6587, ["on清理"] = _____6E05_7406_7C73_4E9A_4E0A_4E0B_6587_673A_5236})
____exports["获取米亚上下文"] = function(boss)
    return _____7C73_4E9A_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建米亚上下文"] = function(boss)
    return _____7C73_4E9A_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["清理米亚上下文"] = function(boss)
    _____7C73_4E9A_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
local function _____5237_65B0_7C73_4E9A_9636_6BB5(context)
    local boss = context["Boss单位"]
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return
    end
    local ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife
    if context["阶段"] == 1 and ratio <= _____7C73_4E9A_9636_6BB5_9608_503C["第二阶段生命比例"] then
        context["阶段"] = 2
        _____64AD_653EBoss_5750_6807_97F3_6548(
            _____7C73_4E9A_97F3_6548_914D_7F6E["转阶段2"]["跳入水池"],
            GetUnitX(boss),
            GetUnitY(boss),
            _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"]
        )
        _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548(
            _____7C73_4E9A_97F3_6548_914D_7F6E["转阶段2"]["毒水喷涌"],
            _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X(),
            _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y(),
            _____7C73_4E9A_97F3_6548_914D_7F6E["转阶段2"]["毒水喷涌延迟Ms"],
            _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"]
        )
        _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "转阶段2", 0)
    end
    if context["阶段"] == 2 and ratio <= _____7C73_4E9A_9636_6BB5_9608_503C["第三阶段生命比例"] then
        context["阶段"] = 3
        _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "转阶段3", 0)
    end
end
local function _____63A8_8FDB_7C73_4E9A_8FD0_884C_65F6()
    local nowMs = getServerTime()
    local contexts = _____7C73_4E9A_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                if context == nil then
                    goto __continue19
                end
                if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
                    ____exports["清理米亚上下文"](context["Boss单位"])
                    goto __continue19
                end
                _____5237_65B0_7C73_4E9A_9636_6BB5(context)
                _____5C1D_8BD5_89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB(context)
                _____5237_65B0_7C73_4E9A_6C61_67D3_6807_8BB0(context, nowMs)
                _____5C1D_8BD5_89E6_53D1_7C73_4E9A_6C61_67D3_8109_51B2(context, nowMs)
                _____5C1D_8BD5_89E6_53D1_7C73_4E9A_6C61_6C34_67F1_7206_53D1(context, nowMs)
                _____5C1D_8BD5_89E6_53D1_7C73_4E9A_8150_5316_8F6C_79FB(context, nowMs)
                _____5237_65B0_7C73_4E9A_5E73_53F0_8D85_8F7D_60E9_7F5A(context, nowMs)
                _____5237_65B0_7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42(context, nowMs)
                _____5C1D_8BD5_89E6_53D1_7C73_4E9A_7EC8_6781_6C61_67D3(context)
            end
            ::__continue19::
            i = i + 1
        end
    end
end
____exports["注册米亚运行时"] = function()
    if _____7C73_4E9A_8FD0_884C_65F6_5DF2_6CE8_518C then
        return
    end
    _____7C73_4E9A_8FD0_884C_65F6_5DF2_6CE8_518C = true
    addPeriodicCallback(250, _____63A8_8FDB_7C73_4E9A_8FD0_884C_65F6)
end
____exports["给单位添加米亚腐化层数"] = function(context, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    local ____self_2 = context["腐化层数控制器"]
    return ____self_2["增加"](____self_2, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
end
return ____exports
