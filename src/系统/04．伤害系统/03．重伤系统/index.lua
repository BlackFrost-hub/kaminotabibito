--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 重伤系统 - 初始化入口
-- 
-- 技能侧如需功能，请直接依赖 `01．核心功能`，不要通过这里的总 index 走导出聚合。
local _____91CD_4F24_7CFB_7EDF_5DF2_521D_59CB_5316 = false
function ____exports.init()
    if _____91CD_4F24_7CFB_7EDF_5DF2_521D_59CB_5316 then
        return
    end
    _____91CD_4F24_7CFB_7EDF_5DF2_521D_59CB_5316 = true
    local ____require_result_0 = require("系统.04．伤害系统.03．重伤系统.01．核心功能")
    local initWoundSystem = ____require_result_0.initWoundSystem
    initWoundSystem()
end
return ____exports
