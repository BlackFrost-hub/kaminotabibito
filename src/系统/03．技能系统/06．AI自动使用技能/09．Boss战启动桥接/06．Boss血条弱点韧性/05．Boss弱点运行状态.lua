local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____Boss_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001_8868 = {}
local ____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868 = {}
local function _____6570_5B57_5347_5E8F_6BD4_8F83(a, b)
    return a - b
end
local function _____8BB0_5F55Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4(bossHandleId)
    if bossHandleId == 0 then
        return
    end
    do
        local i = 0
        while i < #____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868 do
            if ____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868[i + 1] == bossHandleId then
                return
            end
            i = i + 1
        end
    end
    ____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868[#____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868 + 1] = bossHandleId
    __TS__ArraySort(____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868, _____6570_5B57_5347_5E8F_6BD4_8F83)
end
local function _____79FB_9664Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4(bossHandleId)
    if bossHandleId == 0 then
        return
    end
    do
        local i = #____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868 - 1
        while i >= 0 do
            if ____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868[i + 1] == bossHandleId then
                __TS__ArraySplice(____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868, i, 1)
            end
            i = i - 1
        end
    end
end
____exports["创建Boss血条弱点韧性运行状态"] = function(context, config)
    local _____521D_59CB_62A4_76FE_503C = (config and config["初始护盾值"]) ~= nil and config["初始护盾值"] > 0 and config["初始护盾值"] or 0
    local state = {
        ["Boss句柄ID"] = context["Boss句柄ID"],
        ["Boss单位"] = context["Boss单位"],
        ["运行上下文"] = context,
        ["配置"] = config,
        ["是否血条已注册"] = false,
        ["是否弱点已注册"] = false,
        ["是否伤害结算已注册"] = false,
        ["是否已结束"] = false,
        ["血条Frame"] = 0,
        ["损失血条Frame"] = 0,
        ["头像Frame"] = 0,
        ["血量文本Frame"] = 0,
        ["护盾框Frame"] = 0,
        ["护盾填充Frame"] = 0,
        ["弱点UIFrame列表"] = {},
        ["弱点问号Frame列表"] = {},
        ["弱点图标Frame列表"] = {},
        ["弱点X轴列表"] = {},
        ["弱点已暴露列表"] = {},
        ["弱点保护列表"] = {},
        ["弱点保护截止毫秒列表"] = {},
        ["弱点命中表现截止毫秒列表"] = {},
        ["武器弱点伤害累计"] = 0,
        ["待处理弱点命中索引"] = -1,
        ["当前护盾值"] = _____521D_59CB_62A4_76FE_503C,
        ["最大护盾值"] = _____521D_59CB_62A4_76FE_503C,
        ["是否护盾破碎中"] = false,
        ["护盾破碎切灰截止毫秒"] = 0,
        ["护盾恢复截止毫秒"] = 0,
        ["护盾图标Frame"] = 0,
        ["灰色护盾Frame"] = 0,
        ["破碎护盾Frame"] = 0,
        ["护盾文本Frame"] = 0,
        ["护盾说明按钮Frame"] = 0,
        ["护盾提示文本框Frame"] = 0,
        ["护盾提示文本Frame"] = 0
    }
    ____Boss_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001_8868[context["Boss句柄ID"]] = state
    _____8BB0_5F55Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4(context["Boss句柄ID"])
    return state
end
____exports["读取Boss血条弱点韧性运行状态"] = function(bossHandleId)
    if bossHandleId == 0 then
        return nil
    end
    return ____Boss_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001_8868[bossHandleId]
end
____exports["清理Boss血条弱点韧性运行状态"] = function(bossHandleId)
    if bossHandleId == 0 then
        return
    end
    ____Boss_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001_8868[bossHandleId] = nil
    _____79FB_9664Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4(bossHandleId)
end
____exports["获取全部Boss血条弱点韧性运行状态"] = function()
    local result = {}
    do
        local i = 0
        while i < #____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868 do
            local state = ____Boss_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001_8868[____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868[i + 1]]
            if state ~= nil then
                result[#result + 1] = state
            end
            i = i + 1
        end
    end
    return result
end
return ____exports
