local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____02_FF0EBoss_5F31_70B9_97E7_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.02．Boss弱点韧性配置表")
local ____Boss_662F_5426_542F_7528_5F31_70B9_97E7_6027_673A_5236 = ____02_FF0EBoss_5F31_70B9_97E7_6027_914D_7F6E_8868["Boss是否启用弱点韧性机制"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local ____Boss_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001_8868 = {}
local ____Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4_5217_8868 = {}
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
____exports["创建Boss血条弱点韧性运行状态"] = function(context, config, _____663E_793A_5355_4F4D, _____663E_793A_7C7B_578B, _____6240_5C5E_4E3BBoss_53E5_67C4ID, _____8FD0_884C_72B6_6001_952E, _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B)
    if _____663E_793A_5355_4F4D == nil then
        _____663E_793A_5355_4F4D = context["Boss单位"]
    end
    if _____663E_793A_7C7B_578B == nil then
        _____663E_793A_7C7B_578B = "主Boss"
    end
    if _____6240_5C5E_4E3BBoss_53E5_67C4ID == nil then
        _____6240_5C5E_4E3BBoss_53E5_67C4ID = context["Boss句柄ID"]
    end
    if _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B == nil then
        _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B = "独立"
    end
    local _____663E_793A_5355_4F4D_53E5_67C4ID = GetHandleId(_____663E_793A_5355_4F4D) or 0
    local _____72B6_6001_952E = _____8FD0_884C_72B6_6001_952E ~= nil and _____8FD0_884C_72B6_6001_952E or _____663E_793A_5355_4F4D_53E5_67C4ID
    local _____662F_5426_542F_7528_673A_5236UI = ____Boss_662F_5426_542F_7528_5F31_70B9_97E7_6027_673A_5236(config)
    local _____521D_59CB_62A4_76FE_503C = _____662F_5426_542F_7528_673A_5236UI and (config and config["初始护盾值"]) ~= nil and config["初始护盾值"] or 0
    local state = {
        ["Boss句柄ID"] = _____72B6_6001_952E,
        ["Boss单位"] = _____663E_793A_5355_4F4D,
        ["运行上下文"] = context,
        ["配置"] = config,
        ["显示类型"] = _____663E_793A_7C7B_578B,
        ["所属主Boss句柄ID"] = _____6240_5C5E_4E3BBoss_53E5_67C4ID,
        ["护卫血条归属类型"] = _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B,
        ["是否启用机制UI"] = _____662F_5426_542F_7528_673A_5236UI,
        ["是否血条已注册"] = false,
        ["是否弱点已注册"] = false,
        ["是否伤害结算已注册"] = false,
        ["是否已结束"] = false,
        ["血条槽位索引"] = -1,
        ["护卫槽位索引"] = -1,
        ["血条Frame"] = 0,
        ["损失血条Frame"] = 0,
        ["头像Frame"] = 0,
        ["头像覆盖贴图路径"] = "",
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
    ____Boss_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001_8868[_____72B6_6001_952E] = state
    _____8BB0_5F55Boss_5F31_70B9_97E7_6027_8FD0_884C_53E5_67C4(_____72B6_6001_952E)
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
