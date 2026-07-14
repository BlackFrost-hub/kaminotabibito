--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.index")
local _____5F00_59CB_51FB_9000 = ____index["开始击退"]
--- 冲锋/击退系统测试
-- 
-- 开局 2 秒后，直接击退 `gg_unit_Hamg_0002` 一次。
-- 这是临时测试文件，后续不用时可直接移除并从 `index.ts` 取消导出。
local jass = require("jass.common")
local GetUnitFacing = jass.GetUnitFacing
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local createDelayedCall = ____require_result_0.createDelayedCall
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local _____5F53_524D_6D4B_8BD5_5355_4F4D
local _____6D4B_8BD5_6682_505C_6765_6E90 = "冲锋击退测试:短暂停"
local function _____6062_590D_6D4B_8BD5_5355_4F4D_6682_505C()
    local _____6D4B_8BD5_5355_4F4D = _____5F53_524D_6D4B_8BD5_5355_4F4D
    if _____6D4B_8BD5_5355_4F4D ~= nil and _____6D4B_8BD5_5355_4F4D ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(_____6D4B_8BD5_5355_4F4D, _____6D4B_8BD5_6682_505C_6765_6E90)
    end
end
local function _____6682_505C_6D4B_8BD5_5355_4F4D()
    local _____6D4B_8BD5_5355_4F4D = _____5F53_524D_6D4B_8BD5_5355_4F4D
    if _____6D4B_8BD5_5355_4F4D ~= nil and _____6D4B_8BD5_5355_4F4D ~= 0 then
        _____6DFB_52A0_5355_4F4D_6682_505C(_____6D4B_8BD5_5355_4F4D, _____6D4B_8BD5_6682_505C_6765_6E90)
        createDelayedCall(0.03, _____6062_590D_6D4B_8BD5_5355_4F4D_6682_505C)
    end
end
local function _____6267_884C_51B2_950B_51FB_9000_6D4B_8BD5()
    local _____6D4B_8BD5_5355_4F4D = g.gg_unit_Hamg_0002
    if _____6D4B_8BD5_5355_4F4D == nil or _____6D4B_8BD5_5355_4F4D == 0 then
        return
    end
    _____5F53_524D_6D4B_8BD5_5355_4F4D = _____6D4B_8BD5_5355_4F4D
    local _____51FB_9000_89D2_5EA6 = GetUnitFacing(_____6D4B_8BD5_5355_4F4D) + 180
    _____5F00_59CB_51FB_9000(_____6D4B_8BD5_5355_4F4D, {
        ["角度"] = _____51FB_9000_89D2_5EA6,
        ["距离"] = 1000,
        ["持续时间"] = 3,
        ["检查地形"] = true,
        ["朝向跟随位移"] = false,
        ["禁用碰撞"] = true
    })
    createDelayedCall(1.8, _____6682_505C_6D4B_8BD5_5355_4F4D)
end
local _____542F_7528_6D4B_8BD5 = false
if _____542F_7528_6D4B_8BD5 then
    createDelayedCall(2, _____6267_884C_51B2_950B_51FB_9000_6D4B_8BD5)
end
return ____exports
