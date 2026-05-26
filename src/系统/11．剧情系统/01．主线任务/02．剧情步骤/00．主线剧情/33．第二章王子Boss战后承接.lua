local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
do
    local ____33_FF0E_7B2C_4E8C_7AE0_738B_5B50Boss_6218_540E_627F_63A5 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.33．第二章王子Boss战后承接")
    ____exports["章节末战后承接剧情片段"] = ____33_FF0E_7B2C_4E8C_7AE0_738B_5B50Boss_6218_540E_627F_63A5["章节末战后承接剧情片段"]
end
____exports["执行章节末长对白承接"] = function(_____53C2_6570)
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or __TS__Number(_____53C2_6570["目标进度"]) or 33)
end
____exports["第二章王子Boss战后承接剧情动作注册表"] = {["SW01死亡事件_章节末长对白承接"] = ____exports["执行章节末长对白承接"]}
return ____exports
