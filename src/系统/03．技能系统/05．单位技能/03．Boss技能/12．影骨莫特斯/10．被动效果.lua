--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.01．运行时上下文")
local _____83B7_53D6_5168_90E8_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部影骨莫特斯上下文"]
local _____6E05_7406_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清理影骨莫特斯上下文"]
local _____5237_65B0_5F71_9AA8_83AB_7279_65AF_9636_6BB5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新影骨莫特斯阶段"]
local _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_8FD0_884C_65F6 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册影骨莫特斯运行时"]
local ____05_FF0E_6697_5F71_7981_9522 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.05．暗影禁锢")
local _____5C1D_8BD5_89E6_53D1_5F71_9AA8_6697_5F71_7981_9522 = ____05_FF0E_6697_5F71_7981_9522["尝试触发影骨暗影禁锢"]
local ____09_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.09．技能入口")
local _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_6280_80FD_7ED3_6784 = ____09_FF0E_6280_80FD_5165_53E3["注册影骨莫特斯技能结构"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668 = ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668["创建周期机制调度器"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local _____5F71_9AA8_83AB_7279_65AF_88AB_52A8_5DF2_6CE8_518C = false
local _____5F71_9AA8_83AB_7279_65AF_8FD0_884C_65F6_63A8_8FDB_5DF2_6CE8_518C = false
local function _____63A8_8FDB_5355_4E2A_5F71_9AA8_83AB_7279_65AF_8FD0_884C_65F6(context, nowMs)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        _____6E05_7406_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(context["Boss单位"])
        return
    end
    _____5237_65B0_5F71_9AA8_83AB_7279_65AF_9636_6BB5(context)
    _____5C1D_8BD5_89E6_53D1_5F71_9AA8_6697_5F71_7981_9522(context, nowMs)
end
local function _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_8FD0_884C_65F6_63A8_8FDB()
    if _____5F71_9AA8_83AB_7279_65AF_8FD0_884C_65F6_63A8_8FDB_5DF2_6CE8_518C then
        return
    end
    _____5F71_9AA8_83AB_7279_65AF_8FD0_884C_65F6_63A8_8FDB_5DF2_6CE8_518C = true
    _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({
        ["名称"] = "影骨莫特斯-运行时推进",
        ["间隔毫秒"] = 250,
        ["取当前时间"] = getServerTime,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587,
        ["执行"] = _____63A8_8FDB_5355_4E2A_5F71_9AA8_83AB_7279_65AF_8FD0_884C_65F6
    })
end
____exports["注册影骨莫特斯被动效果"] = function()
    if _____5F71_9AA8_83AB_7279_65AF_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____5F71_9AA8_83AB_7279_65AF_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_8FD0_884C_65F6()
    _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_8FD0_884C_65F6_63A8_8FDB()
    _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_6280_80FD_7ED3_6784()
end
____exports["注册影骨莫特斯被动效果"]()
return ____exports
