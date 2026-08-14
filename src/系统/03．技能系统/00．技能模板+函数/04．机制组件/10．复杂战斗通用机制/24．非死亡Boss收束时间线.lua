--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_1["暂停并设置无敌安全"]
local _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_1["解除暂停并取消无敌安全"]
local function _____91CA_653E_975E_6B7B_4EA1Boss_6536_675F_6210_5458(_____72B6_6001)
    if _____72B6_6001["已释放"] then
        return
    end
    _____72B6_6001["已释放"] = true
    local _____6210_5458 = _____72B6_6001["参数"]["成员"]
    do
        local i = 0
        while i < #_____6210_5458 do
            local _____5F53_524D_6210_5458 = _____6210_5458[i + 1]
            if _____5F53_524D_6210_5458["单位"] ~= nil and _____5F53_524D_6210_5458["单位"] ~= 0 then
                _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(_____5F53_524D_6210_5458["单位"], _____5F53_524D_6210_5458["暂停来源"])
            end
            i = i + 1
        end
    end
end
local function ____on_975E_6B7B_4EA1Boss_6536_675F_6E05_7406(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 ~= nil then
        _____91CA_653E_975E_6B7B_4EA1Boss_6536_675F_6210_5458(_____72B6_6001)
    end
end
local function ____on_975E_6B7B_4EA1Boss_6536_675F_7ED3_7B97(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结算"] then
        return
    end
    _____72B6_6001["已结算"] = true
    _____72B6_6001["参数"]["结算回调"](_____72B6_6001["参数"]["变量"])
    _____91CA_653E_975E_6B7B_4EA1Boss_6536_675F_6210_5458(_____72B6_6001)
end
--- 统一非死亡 Boss 的冻结、离场动画、延迟结算与来源安全释放。
-- 奖励、隐藏单位和结束 Boss 战等业务顺序由结算回调保留在各 Boss 文件。
____exports["启动非死亡Boss收束时间线"] = function(_____53C2_6570)
    local ____temp_3 = not (_____53C2_6570["离场延迟秒"] >= 0) or #_____53C2_6570["成员"] <= 0
    if not ____temp_3 then
        local ____self_2 = _____53C2_6570["清理"]
        ____temp_3 = ____self_2["已清理"](____self_2)
    end
    if ____temp_3 then
        return false
    end
    local _____72B6_6001 = {["参数"] = _____53C2_6570, ["已结算"] = false, ["已释放"] = false}
    local _____6210_5458 = _____53C2_6570["成员"]
    do
        local i = 0
        while i < #_____6210_5458 do
            do
                local _____5F53_524D_6210_5458 = _____6210_5458[i + 1]
                if _____5F53_524D_6210_5458["单位"] == nil or _____5F53_524D_6210_5458["单位"] == 0 then
                    goto __continue14
                end
                _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(_____5F53_524D_6210_5458["单位"], _____5F53_524D_6210_5458["暂停来源"])
                if _____5F53_524D_6210_5458["离场动画编号"] ~= nil then
                    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = _____5F53_524D_6210_5458["单位"], ["动画编号"] = _____5F53_524D_6210_5458["离场动画编号"], ["持续秒"] = _____53C2_6570["离场延迟秒"], ["恢复动画编号"] = _____5F53_524D_6210_5458["恢复动画编号"] or 0})
                end
            end
            ::__continue14::
            i = i + 1
        end
    end
    local ____self_4 = _____53C2_6570["清理"]
    ____self_4["登记清理"](____self_4, _____53C2_6570["名称"] .. "-释放冻结", ____on_975E_6B7B_4EA1Boss_6536_675F_6E05_7406, _____72B6_6001)
    if _____53C2_6570["开始回调"] ~= nil then
        _____53C2_6570["开始回调"](_____53C2_6570["变量"])
    end
    local _____56DE_8C03ID = addDelayedCallback(_____53C2_6570["离场延迟秒"] * 1000, ____on_975E_6B7B_4EA1Boss_6536_675F_7ED3_7B97, _____72B6_6001)
    local ____self_5 = _____53C2_6570["清理"]
    ____self_5["登记延迟回调"](____self_5, _____53C2_6570["延迟登记名"] or _____53C2_6570["名称"] .. "-延迟结算", _____56DE_8C03ID)
    return true
end
return ____exports
