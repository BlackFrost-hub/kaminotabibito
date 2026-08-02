--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____505C_6B62_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["停止触发单位"]
local _____8BFB_53D6_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取触发单位"]
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.10．标准剧情动作")
local _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807 = ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C["发布主线节点目标"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local ____31A_FF0E_738B_57CE_653B_57CE_6218_63A7_5236_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.31A．王城攻城战控制器")
local _____542F_52A8_738B_57CE_653B_57CE_6218 = ____31A_FF0E_738B_57CE_653B_57CE_6218_63A7_5236_5668["启动王城攻城战"]
local _____7ED3_675F_83F2_5229_65AF_653B_57CE_7B49_5F85 = ____31A_FF0E_738B_57CE_653B_57CE_6218_63A7_5236_5668["结束菲利斯攻城等待"]
local _____767B_8BB0_5B58_6D3B_653B_57CE_5355_4F4D_4E3A_83F2_5229_65AF_62A4_536B = ____31A_FF0E_738B_57CE_653B_57CE_6218_63A7_5236_5668["登记存活攻城单位为菲利斯护卫"]
local ____31B_FF0E_8036_63D0_5C14_534F_6218_63A7_5236_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.31B．耶提尔协战控制器")
local _____51C6_5907_8036_63D0_5C14_83F2_5229_65AF_534F_6218 = ____31B_FF0E_8036_63D0_5C14_534F_6218_63A7_5236_5668["准备耶提尔菲利斯协战"]
local ____require_result_0 = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐")
local _____5F00_59CB_7B2C_4E8C_7AE0_83F2_5229_65AF_653B_57CE_533A_57DF_97F3_4E50 = ____require_result_0["开始第二章菲利斯攻城区域音乐"]
local jass = require("jass.common")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_2["按名字反查总单位ID"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_3["创建单位并登记排泄安全"]
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = 15
local _____4F1A_8BAE_5E2D_4F4D_9884_7F6E_8868 = {
    {
        ["角色名"] = "克林姆德王",
        ["单位名"] = "克林姆德王",
        X = 13013.3,
        Y = -23968.5,
        ["朝向"] = 270
    },
    {
        ["角色名"] = "耶提尔",
        ["单位名"] = "防卫部长-耶提尔",
        X = 12735.6,
        Y = -24115.1,
        ["朝向"] = 0
    },
    {
        ["角色名"] = "赫克提尔",
        ["单位名"] = "术法长老-赫克提尔",
        X = 13332.9,
        Y = -24146.4,
        ["朝向"] = 180
    },
    {
        ["角色名"] = "里凡特",
        ["单位名"] = "第一王子-里凡特",
        X = 12736,
        Y = -24254.7,
        ["朝向"] = 0
    },
    {
        ["角色名"] = "丝费里德",
        ["单位名"] = "财务总长-丝费里德",
        X = 13335.9,
        Y = -24281.8,
        ["朝向"] = 180
    },
    {
        ["角色名"] = "语维",
        ["单位名"] = "内务总管-语维",
        X = 12747.2,
        Y = -24413.6,
        ["朝向"] = 0
    },
    {
        ["角色名"] = "本·思雅",
        ["单位名"] = "精灵古老-本·思雅",
        X = 13333.6,
        Y = -24398.1,
        ["朝向"] = 180
    }
}
do
    local ____31_FF0E_738B_57CE_7D27_6025_4F1A_8BAE = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.31．王城紧急会议")
    ____exports["王城紧急会议剧情片段"] = ____31_FF0E_738B_57CE_7D27_6025_4F1A_8BAE["王城紧急会议剧情片段"]
end
local function _____8BFB_53D6_6216_521B_5EFA_4F1A_8BAENPC(_____9884_7F6E)
    local _____8BED_4E49_5F15_7528 = "主线NPC." .. _____9884_7F6E["角色名"]
    local unit = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____8BED_4E49_5F15_7528)
    if unit == nil or unit == 0 then
        local unitTypeId = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____9884_7F6E["单位名"]))
        if not (unitTypeId > 0) then
            return nil
        end
        unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            Player(_____4E2D_7ACB_88AB_52A8_73A9_5BB6ID),
            unitTypeId,
            _____9884_7F6E.X,
            _____9884_7F6E.Y,
            _____9884_7F6E["朝向"]
        )
    end
    if unit == nil or unit == 0 then
        return nil
    end
    SetUnitPosition(unit, _____9884_7F6E.X, _____9884_7F6E.Y)
    SetUnitFacing(unit, _____9884_7F6E["朝向"])
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8BED_4E49_5F15_7528, unit)
    return unit
end
____exports["布置王城会议席位"] = function()
    do
        local i = 0
        while i < #_____4F1A_8BAE_5E2D_4F4D_9884_7F6E_8868 do
            _____8BFB_53D6_6216_521B_5EFA_4F1A_8BAENPC(_____4F1A_8BAE_5E2D_4F4D_9884_7F6E_8868[i + 1])
            i = i + 1
        end
    end
end
____exports["执行前往会议室任务"] = function()
    ____exports["布置王城会议席位"]()
    _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807(31)
end
____exports["执行紧急会议"] = function()
    _____505C_6B62_89E6_53D1_5355_4F4D()
    ____exports["布置王城会议席位"]()
end
____exports["执行启动王城攻城战"] = function()
    _____5F00_59CB_7B2C_4E8C_7AE0_83F2_5229_65AF_653B_57CE_533A_57DF_97F3_4E50()
    _____542F_52A8_738B_57CE_653B_57CE_6218()
    _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807(32)
end
____exports["执行准备耶提尔菲利斯协战"] = function()
    _____7ED3_675F_83F2_5229_65AF_653B_57CE_7B49_5F85()
    _____767B_8BB0_5B58_6D3B_653B_57CE_5355_4F4D_4E3A_83F2_5229_65AF_62A4_536B()
    _____51C6_5907_8036_63D0_5C14_83F2_5229_65AF_534F_6218(
        _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("Boss.菲利斯"),
        _____8BFB_53D6_89E6_53D1_5355_4F4D()
    )
end
____exports["王城紧急会议剧情动作注册表"] = {["JLC精灵城_前往会议室任务"] = ____exports["执行前往会议室任务"], ["JLC精灵城_紧急会议"] = ____exports["执行紧急会议"], ["JLC精灵城_启动王城攻城战"] = ____exports["执行启动王城攻城战"], ["JLC精灵城_准备耶提尔菲利斯协战"] = ____exports["执行准备耶提尔菲利斯协战"]}
return ____exports
