--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品工具")
local _____662F_53EF_6E05_7406_5403_4E66_6B8B_7559 = ____require_result_0["是可清理吃书残留"]
local _____5220_9664_7269_54C1 = ____require_result_0["删除物品"]
____exports["处理通用物品吃书清理"] = function(______5355_4F4D, _____7269_54C1)
    if not _____662F_53EF_6E05_7406_5403_4E66_6B8B_7559(_____7269_54C1) then
        return
    end
    _____5220_9664_7269_54C1(_____7269_54C1)
end
return ____exports
