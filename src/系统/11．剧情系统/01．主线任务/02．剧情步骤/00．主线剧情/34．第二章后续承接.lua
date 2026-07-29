local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["清理剧情运行时单位"]
local ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.33A．王宫密室场景单位")
local _____5B9A_4F4D_5E76_767B_8BB0_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["定位并登记王宫密室剧情单位"]
local _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868 = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["王宫密室场景站位表"]
local _____64AD_653E_738B_5BAB_5BC6_5BA4_6F14_51FA_7279_6548 = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["播放王宫密室演出特效"]
do
    local ____34_FF0E_7B2C_4E8C_7AE0_540E_7EED_627F_63A5 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.34．第二章后续承接")
    ____exports["章节末最终收束剧情片段"] = ____34_FF0E_7B2C_4E8C_7AE0_540E_7EED_627F_63A5["章节末最终收束剧情片段"]
end
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataClearSafe = ____require_result_0.YDUserDataClearSafe
local RemoveUnit = jass.RemoveUnit
____exports["执行章节末最终收束"] = function(_____53C2_6570)
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or __TS__Number(_____53C2_6570["目标进度"]) or 35)
end
____exports["执行布置王宫密室受伤现场"] = function()
    _____5B9A_4F4D_5E76_767B_8BB0_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("ZX.克林姆德王", "主线NPC.克林姆德王", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["克林姆德王受伤"])
    _____5B9A_4F4D_5E76_767B_8BB0_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("ZX.赫克提尔", "主线NPC.赫克提尔", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["赫克提尔受伤"])
end
____exports["执行里科特战后撤离"] = function()
    _____64AD_653E_738B_5BAB_5BC6_5BA4_6F14_51FA_7279_6548("里科特战后撤离", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特密室"])
    local _____91CC_79D1_7279 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("Boss.里科特")
    if _____91CC_79D1_7279 ~= nil and _____91CC_79D1_7279 ~= 0 then
        RemoveUnit(_____91CC_79D1_7279)
    end
    YDUserDataClearSafe("string", "Boss", "里科特", "unit")
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("Boss.里科特")
end
____exports["第二章后续承接剧情动作注册表"] = {["SW01死亡事件_章节末最终收束"] = ____exports["执行章节末最终收束"], ["JLC精灵城_布置王宫密室受伤现场"] = ____exports["执行布置王宫密室受伤现场"], ["JLC精灵城_里科特战后撤离"] = ____exports["执行里科特战后撤离"]}
return ____exports
