local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.00．配置")
local _____4F0A_857E_5A1C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜技能配置"]
local _____4F0A_857E_5A1C_89C1_95FB_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜见闻配置"]
local _____4F0A_857E_5A1C_53D8_5F0F_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜变式配置"]
local _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜普攻联动配置"]
local _____4F0A_857E_5A1C_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜表现配置"]
local _____4F0A_857E_5A1CE_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜E配置"]
local ____23_FF0E_4F0A_857E_5A1C = require("系统.05．Buff系统.03．Buff表.02．英雄.23．伊蕾娜")
local _____4F0A_857E_5A1CBuffID = ____23_FF0E_4F0A_857E_5A1C["伊蕾娜BuffID"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local fourCCToStringSafe = ____require_result_0.fourCCToStringSafe
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_2.getGameTime
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____53D6_5355_4F4DID = ____require_result_3["取单位ID"]
local _____5355_4F4D_5B58_6D3B = ____require_result_3["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_3["两点角度"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_4["移除单位指定Buff"]
local ____require_result_5 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_5.registerAppliedFinalDamageListener
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂")
local _____53D1_5C04_5F39_9053 = ____require_result_6["发射弹道"]
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setSlow = ____require_result_7.SFB_setSlow
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统")
local _____5145_80FD_5355_4F4D_6807_7B7E_62A4_76FE = ____require_result_8["充能单位标签护盾"]
local ____require_result_9 = require("系统.09．表现系统.15．世界坐标进度UI.01．世界坐标进度UI")
local _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_9["销毁世界坐标进度UI"]
local platformAbilityApi = require("平台扩展API取值")
local platformAbilityAction = require("平台扩展API动作")
local ____require_result_10 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_10.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____4F0A_857E_5A1C_6280_80FD_914D_7F6E["单位类型ID"])
local ____Q_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____4F0A_857E_5A1C_6280_80FD_914D_7F6E.Q["技能ID"])
local ____W_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____4F0A_857E_5A1C_6280_80FD_914D_7F6E.W["技能ID"])
local ____E_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____4F0A_857E_5A1C_6280_80FD_914D_7F6E.E["技能ID"])
local _____4F0A_857E_5A1C_72B6_6001_8868 = {}
local _____4E0B_4E00_5168_5C40_89C1_95FB_5E8F_53F7 = 1
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____53D6_53E5_67C4(_____82F1_96C4)
    return _____53D6_5355_4F4DID(_____82F1_96C4)
end
local function _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    local id = _____53D6_53E5_67C4(_____82F1_96C4)
    local _____72B6_6001 = _____4F0A_857E_5A1C_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {
            ["见闻列表"] = {},
            ["当前变式"] = nil,
            ["变式到期时间"] = 0,
            ["R锁定变式"] = nil,
            ["E路线"] = nil,
            ["W结界"] = nil,
            ["技能清理表"] = {},
            ["进度UI列表"] = {},
            ["回馈下次可用时间"] = 0,
            ["已清理"] = false
        }
        _____4F0A_857E_5A1C_72B6_6001_8868[id] = _____72B6_6001
    end
    return _____72B6_6001
end
local function _____67E5_627E_72B6_6001(_____82F1_96C4)
    return _____4F0A_857E_5A1C_72B6_6001_8868[_____53D6_53E5_67C4(_____82F1_96C4)]
end
--- 判断单位是否为伊蕾娜
____exports["是伊蕾娜"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return GetUnitTypeId(unit) == _____82F1_96C4_5355_4F4D_7C7B_578BID
end
local function _____53D6_6700_77ED_5269_4F59_79D2(_____5217_8868)
    local now = getGameTime()
    local _____6700_77ED = 0
    do
        local i = 0
        while i < #_____5217_8868 do
            local _____5269_4F59 = _____5217_8868[i + 1]["到期时间"] - now
            if i == 0 or _____5269_4F59 < _____6700_77ED then
                _____6700_77ED = _____5269_4F59
            end
            i = i + 1
        end
    end
    return _____6700_77ED > 0 and _____6700_77ED / 1000 or 0.1
end
--- 依据见闻列表刷新“旅途见闻”与“魔法弹强化”两层 Buff（层内数量=层数）。
local function _____5237_65B0_89C1_95FBBuff(_____82F1_96C4, _____72B6_6001)
    local _____6570_91CF = #_____72B6_6001["见闻列表"]
    if _____6570_91CF <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4F0A_857E_5A1CBuffID["旅途见闻"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4F0A_857E_5A1CBuffID["魔法弹强化"])
        return
    end
    local _____65F6_957F_79D2 = _____53D6_6700_77ED_5269_4F59_79D2(_____72B6_6001["见闻列表"])
    registerManualBuff(
        _____82F1_96C4,
        _____4F0A_857E_5A1CBuffID["旅途见闻"],
        _____65F6_957F_79D2,
        _____6570_91CF,
        {stack = _____6570_91CF}
    )
    registerManualBuff(
        _____82F1_96C4,
        _____4F0A_857E_5A1CBuffID["魔法弹强化"],
        _____65F6_957F_79D2,
        _____6570_91CF,
        {stack = _____6570_91CF}
    )
end
--- 就地剔除过期见闻（惰性过期；返回是否发生变化）。
local function _____60F0_6027_5254_9664_8FC7_671F_89C1_95FB(_____72B6_6001)
    local now = getGameTime()
    local _____6709_53D8_5316 = false
    local i = 0
    while i < #_____72B6_6001["见闻列表"] do
        if _____72B6_6001["见闻列表"][i + 1]["到期时间"] <= now then
            __TS__ArraySplice(_____72B6_6001["见闻列表"], i, 1)
            _____6709_53D8_5316 = true
        else
            i = i + 1
        end
    end
    return _____6709_53D8_5316
end
--- 记录一条见闻（Q/W/E 成功释放后调用）。
-- 同类型刷新持续时间；超过上限淘汰最旧。返回本次生效的记录。
____exports["记录伊蕾娜见闻"] = function(_____82F1_96C4, _____7C7B_578B, _____6765_6E90_5B9E_4F8BID)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or not _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        return nil
    end
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4) or _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["已清理"] then
        return nil
    end
    local now = getGameTime()
    do
        local i = #_____72B6_6001["见闻列表"] - 1
        while i >= 0 do
            if _____72B6_6001["见闻列表"][i + 1]["类型"] == _____7C7B_578B then
                local _____8BB0_5F55 = __TS__ArraySplice(_____72B6_6001["见闻列表"], i, 1)[1]
                _____8BB0_5F55["到期时间"] = now + _____4F0A_857E_5A1C_89C1_95FB_914D_7F6E["持续毫秒"]
                _____8BB0_5F55["来源实例ID"] = _____6765_6E90_5B9E_4F8BID
                local ____72B6_6001__89C1_95FB_5217_8868_11 = _____72B6_6001["见闻列表"]
                ____72B6_6001__89C1_95FB_5217_8868_11[#____72B6_6001__89C1_95FB_5217_8868_11 + 1] = _____8BB0_5F55
                _____5237_65B0_89C1_95FBBuff(_____82F1_96C4, _____72B6_6001)
                return _____8BB0_5F55
            end
            i = i - 1
        end
    end
    local ____4E0B_4E00_5168_5C40_89C1_95FB_5E8F_53F7_12 = _____4E0B_4E00_5168_5C40_89C1_95FB_5E8F_53F7
    _____4E0B_4E00_5168_5C40_89C1_95FB_5E8F_53F7 = ____4E0B_4E00_5168_5C40_89C1_95FB_5E8F_53F7_12 + 1
    local _____8BB0_5F55 = {["序号"] = ____4E0B_4E00_5168_5C40_89C1_95FB_5E8F_53F7_12, ["类型"] = _____7C7B_578B, ["到期时间"] = now + _____4F0A_857E_5A1C_89C1_95FB_914D_7F6E["持续毫秒"], ["来源实例ID"] = _____6765_6E90_5B9E_4F8BID}
    local ____72B6_6001__89C1_95FB_5217_8868_13 = _____72B6_6001["见闻列表"]
    ____72B6_6001__89C1_95FB_5217_8868_13[#____72B6_6001__89C1_95FB_5217_8868_13 + 1] = _____8BB0_5F55
    while #_____72B6_6001["见闻列表"] > _____4F0A_857E_5A1C_89C1_95FB_914D_7F6E["上限"] do
        table.remove(_____72B6_6001["见闻列表"], 1)
    end
    _____5237_65B0_89C1_95FBBuff(_____82F1_96C4, _____72B6_6001)
    return _____8BB0_5F55
end
--- 查询当前有效见闻（创建顺序副本；惰性剔除过期项并同步 Buff）。
____exports["查询伊蕾娜见闻"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return {}
    end
    if _____60F0_6027_5254_9664_8FC7_671F_89C1_95FB(_____72B6_6001) then
        _____5237_65B0_89C1_95FBBuff(_____82F1_96C4, _____72B6_6001)
    end
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____72B6_6001["见闻列表"] do
            _____7ED3_679C[#_____7ED3_679C + 1] = _____72B6_6001["见闻列表"][i + 1]
            i = i + 1
        end
    end
    return _____7ED3_679C
end
local function _____53D6_6D88_8D39_6E90_7D22_5F15(_____72B6_6001)
    if #_____72B6_6001["见闻列表"] <= 0 then
        return -1
    end
    local _____987A_5E8F = _____4F0A_857E_5A1C_89C1_95FB_914D_7F6E["消费顺序"]
    if _____987A_5E8F == "最新优先" then
        return #_____72B6_6001["见闻列表"] - 1
    end
    return 0
end
--- 预览下一次将消费的见闻（不移除；用于先按类型分支再确认消费）。
____exports["预览伊蕾娜消费见闻"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return nil
    end
    if _____60F0_6027_5254_9664_8FC7_671F_89C1_95FB(_____72B6_6001) then
        _____5237_65B0_89C1_95FBBuff(_____82F1_96C4, _____72B6_6001)
    end
    local _____7D22_5F15 = _____53D6_6D88_8D39_6E90_7D22_5F15(_____72B6_6001)
    if _____7D22_5F15 < 0 then
        return nil
    end
    return _____72B6_6001["见闻列表"][_____7D22_5F15 + 1]
end
--- 确认消费指定序号的见闻（仅在分支真正进入后调用；校验失败不得白扣）。
-- 成功返回被消费记录；序号已失效返回 null 且不做任何修改。
____exports["消费伊蕾娜见闻按序号"] = function(_____82F1_96C4, _____5E8F_53F7)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return nil
    end
    do
        local i = 0
        while i < #_____72B6_6001["见闻列表"] do
            do
                if _____72B6_6001["见闻列表"][i + 1]["序号"] ~= _____5E8F_53F7 then
                    goto __continue40
                end
                local _____8BB0_5F55 = __TS__ArraySplice(_____72B6_6001["见闻列表"], i, 1)[1]
                _____5237_65B0_89C1_95FBBuff(_____82F1_96C4, _____72B6_6001)
                return _____8BB0_5F55
            end
            ::__continue40::
            i = i + 1
        end
    end
    return nil
end
local function _____540C_6B65_53D8_5F0FBuff(_____82F1_96C4, _____72B6_6001)
    if _____72B6_6001["当前变式"] == nil then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4F0A_857E_5A1CBuffID["魔法变式"])
        return
    end
    local _____5269_4F59_79D2 = (_____72B6_6001["变式到期时间"] - getGameTime()) / 1000
    registerManualBuff(_____82F1_96C4, _____4F0A_857E_5A1CBuffID["魔法变式"], _____5269_4F59_79D2 > 0 and _____5269_4F59_79D2 or 0.1, 0)
end
--- 设置当前变式（D 切换调用；覆盖旧变式，不叠加多套）。
____exports["设置伊蕾娜变式"] = function(_____82F1_96C4, _____53D8_5F0F)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4) or _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["已清理"] then
        return false
    end
    if _____72B6_6001["R锁定变式"] ~= nil then
        return false
    end
    _____72B6_6001["当前变式"] = _____53D8_5F0F
    _____72B6_6001["变式到期时间"] = getGameTime() + _____4F0A_857E_5A1C_53D8_5F0F_914D_7F6E["保持秒"] * 1000
    _____540C_6B65_53D8_5F0FBuff(_____82F1_96C4, _____72B6_6001)
    return true
end
--- 读取当前变式（惰性校验保持期；R 锁定期间对普通技能不可见，R 用 获取伊蕾娜R锁定变式 读取）。
____exports["获取伊蕾娜变式"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return nil
    end
    if _____72B6_6001["R锁定变式"] ~= nil then
        return nil
    end
    if _____72B6_6001["当前变式"] == nil then
        return nil
    end
    if getGameTime() >= _____72B6_6001["变式到期时间"] then
        _____72B6_6001["当前变式"] = nil
        _____72B6_6001["变式到期时间"] = 0
        _____540C_6B65_53D8_5F0FBuff(_____82F1_96C4, _____72B6_6001)
        return nil
    end
    return _____72B6_6001["当前变式"]
end
--- 仅 R 技能使用：读取蓄力开始时锁定的变式快照。
____exports["获取伊蕾娜R锁定变式"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return nil
    end
    return _____72B6_6001["R锁定变式"]
end
--- R 开始蓄力时锁定当前变式快照（后续 D 切换被拒；中断时解除锁定还原）。
____exports["锁定伊蕾娜R变式"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4) or _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["R锁定变式"] ~= nil then
        return _____72B6_6001["R锁定变式"]
    end
    local _____5F53_524D = ____exports["获取伊蕾娜变式"](_____82F1_96C4)
    if _____5F53_524D == nil then
        return nil
    end
    _____72B6_6001["R锁定变式"] = _____5F53_524D
    _____72B6_6001["当前变式"] = nil
    _____72B6_6001["变式到期时间"] = 0
    _____540C_6B65_53D8_5F0FBuff(_____82F1_96C4, _____72B6_6001)
    return _____72B6_6001["R锁定变式"]
end
--- 解除 R 锁定并把变式还原为锁定值（R 中断/失败时调用，不得白扣）。
____exports["还原伊蕾娜R锁定变式"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil or _____72B6_6001["R锁定变式"] == nil then
        return
    end
    _____72B6_6001["当前变式"] = _____72B6_6001["R锁定变式"]
    _____72B6_6001["变式到期时间"] = getGameTime() + _____4F0A_857E_5A1C_53D8_5F0F_914D_7F6E["保持秒"] * 1000
    _____72B6_6001["R锁定变式"] = nil
    _____540C_6B65_53D8_5F0FBuff(_____82F1_96C4, _____72B6_6001)
end
--- 消费变式（分支真正进入成功后调用）。返回被消费的变式；无变式返回 null。
____exports["消费伊蕾娜变式"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return nil
    end
    if _____72B6_6001["R锁定变式"] ~= nil then
        return nil
    end
    local _____5F53_524D = ____exports["获取伊蕾娜变式"](_____82F1_96C4)
    if _____5F53_524D == nil then
        return nil
    end
    _____72B6_6001["当前变式"] = nil
    _____72B6_6001["变式到期时间"] = 0
    _____540C_6B65_53D8_5F0FBuff(_____82F1_96C4, _____72B6_6001)
    return _____5F53_524D
end
--- 按受益矩阵消费变式：迅行→Q/E；镜界→W；灰烬→Q/E/R。
-- 不受益时不消耗（保留给后续技能）；分支未真正进入不得调用本函数。
-- R 蓄力期间变式处于锁定快照，其他技能一律读不到、也不可消耗。
____exports["消费伊蕾娜变式用于"] = function(_____82F1_96C4, _____6280_80FD_952E)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil or _____72B6_6001["R锁定变式"] ~= nil then
        return nil
    end
    local _____5F53_524D = _____72B6_6001["当前变式"]
    if _____5F53_524D == nil then
        return nil
    end
    local _____53D7_76CA = false
    if _____5F53_524D == "迅行" then
        _____53D7_76CA = _____6280_80FD_952E == "Q" or _____6280_80FD_952E == "E"
    elseif _____5F53_524D == "镜界" then
        _____53D7_76CA = _____6280_80FD_952E == "W"
    else
        _____53D7_76CA = true
    end
    if not _____53D7_76CA then
        return nil
    end
    return ____exports["消费伊蕾娜变式"](_____82F1_96C4)
end
--- 仅 R 使用：消费锁定的变式快照（R 充能完成且变式分支真正进入后调用）。
____exports["消费伊蕾娜R锁定变式"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil or _____72B6_6001["R锁定变式"] == nil then
        return nil
    end
    local _____9501_5B9A = _____72B6_6001["R锁定变式"]
    _____72B6_6001["R锁定变式"] = nil
    return _____9501_5B9A
end
--- 记录 E 的扫帚路线（到达终点时调用；短寿命，超时自动失效）。
____exports["记录伊蕾娜扫帚路线"] = function(_____82F1_96C4, _____8D77_70B9X, _____8D77_70B9Y, _____7EC8_70B9X, _____7EC8_70B9Y, _____65B9_5411_89D2)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4) or _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["已清理"] then
        return nil
    end
    local _____8DEF_7EBF = {
        ["起点X"] = _____8D77_70B9X,
        ["起点Y"] = _____8D77_70B9Y,
        ["终点X"] = _____7EC8_70B9X,
        ["终点Y"] = _____7EC8_70B9Y,
        ["方向角"] = _____65B9_5411_89D2,
        ["到期时间"] = getGameTime() + _____4F0A_857E_5A1CE_914D_7F6E["路线寿命秒"] * 1000
    }
    _____72B6_6001["E路线"] = _____8DEF_7EBF
    return _____8DEF_7EBF
end
--- 读取当前存活的扫帚路线（惰性过期）。
____exports["读取伊蕾娜扫帚路线"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil or _____72B6_6001["E路线"] == nil then
        return nil
    end
    if getGameTime() >= _____72B6_6001["E路线"]["到期时间"] then
        _____72B6_6001["E路线"] = nil
        return nil
    end
    return _____72B6_6001["E路线"]
end
--- 清除扫帚路线（场景清理/显式失效）。
____exports["清除伊蕾娜扫帚路线"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001["E路线"] = nil
end
--- 存入当前 W 结界运行数据（重复施放时由 W 自行先关旧再存新）。
____exports["存伊蕾娜W结界"] = function(_____82F1_96C4, _____6570_636E)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4) or _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["已清理"] then
        return
    end
    _____72B6_6001["W结界"] = _____6570_636E
end
____exports["取伊蕾娜W结界"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return nil
    end
    return _____72B6_6001["W结界"]
end
--- 登记技能清理回调，返回注销函数（幂等）。
____exports["登记伊蕾娜技能清理"] = function(_____82F1_96C4, _____6807_7B7E, _____6E05_7406)
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    _____72B6_6001["技能清理表"][_____6807_7B7E] = _____6E05_7406
    return function()
        local _____5F53_524D = _____4F0A_857E_5A1C_72B6_6001_8868[_____53D6_53E5_67C4(_____82F1_96C4)]
        if _____5F53_524D ~= nil and _____5F53_524D["技能清理表"][_____6807_7B7E] == _____6E05_7406 then
            __TS__Delete(_____5F53_524D["技能清理表"], _____6807_7B7E)
        end
    end
end
local function _____6267_884C_5168_90E8_6280_80FD_6E05_7406(_____72B6_6001)
    for _____6807_7B7E in pairs(_____72B6_6001["技能清理表"]) do
        local _____6E05_7406 = _____72B6_6001["技能清理表"][_____6807_7B7E]
        if _____6E05_7406 ~= nil then
            _____6E05_7406()
        end
    end
    for _____6807_7B7E in pairs(_____72B6_6001["技能清理表"]) do
        __TS__Delete(_____72B6_6001["技能清理表"], _____6807_7B7E)
    end
end
--- 登记世界坐标进度 UI 句柄（随英雄状态统一销毁；重复登记去重）。
____exports["登记伊蕾娜进度UI"] = function(_____82F1_96C4, ui)
    if ui == nil or ui == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    do
        local i = 0
        while i < #_____72B6_6001["进度UI列表"] do
            if _____72B6_6001["进度UI列表"][i + 1] == ui then
                return
            end
            i = i + 1
        end
    end
    local ____72B6_6001__8FDB_5EA6UI_5217_8868_14 = _____72B6_6001["进度UI列表"]
    ____72B6_6001__8FDB_5EA6UI_5217_8868_14[#____72B6_6001__8FDB_5EA6UI_5217_8868_14 + 1] = ui
end
--- 立即销毁指定进度 UI 并摘除登记。
____exports["销毁伊蕾娜进度UI"] = function(_____82F1_96C4, ui)
    if ui == nil or ui == 0 then
        return
    end
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(ui)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return
    end
    do
        local i = 0
        while i < #_____72B6_6001["进度UI列表"] do
            if _____72B6_6001["进度UI列表"][i + 1] == ui then
                __TS__ArraySplice(_____72B6_6001["进度UI列表"], i, 1)
                return
            end
            i = i + 1
        end
    end
end
local function _____6E05_7406_5168_90E8_8FDB_5EA6UI(_____72B6_6001)
    while #_____72B6_6001["进度UI列表"] > 0 do
        local ui = _____72B6_6001["进度UI列表"][1]
        __TS__ArraySplice(_____72B6_6001["进度UI列表"], 0, 1)
        _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(ui)
    end
end
--- 统一回收入口：死亡 / 打断 / 地图清理 / 主动清理 共用。
-- 清理顺序：技能清理表（各技能自清弹道/护盾/特效）→ 见闻与变式 Buff →
-- 路线/W 结界指针 → 进度 UI → 摘除状态表项。
____exports["清理伊蕾娜状态"] = function(_____82F1_96C4, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "主动清理"
    end
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local id = _____53D6_53E5_67C4(_____82F1_96C4)
    local _____72B6_6001 = _____4F0A_857E_5A1C_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return false
    end
    if _____72B6_6001["已清理"] then
        return true
    end
    _____72B6_6001["已清理"] = true
    debugLogForce(
        "伊蕾娜-被动",
        "清理",
        "原因",
        _____539F_56E0,
        "单位",
        GetUnitName(_____82F1_96C4),
        "handle",
        _____82F1_96C4
    )
    local ____ = _____539F_56E0
    _____6267_884C_5168_90E8_6280_80FD_6E05_7406(_____72B6_6001)
    _____72B6_6001["见闻列表"] = {}
    _____72B6_6001["当前变式"] = nil
    _____72B6_6001["变式到期时间"] = 0
    _____72B6_6001["R锁定变式"] = nil
    _____72B6_6001["E路线"] = nil
    _____72B6_6001["W结界"] = nil
    _____6E05_7406_5168_90E8_8FDB_5EA6UI(_____72B6_6001)
    if _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4F0A_857E_5A1CBuffID["旅途见闻"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4F0A_857E_5A1CBuffID["魔法弹强化"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4F0A_857E_5A1CBuffID["魔法变式"])
    end
    __TS__Delete(_____4F0A_857E_5A1C_72B6_6001_8868, id)
    return true
end
--- 地图 / 场景清理：清理所有伊蕾娜状态（句柄反查不可用，直接遍历表）。返回清理数量。
____exports["清理全部伊蕾娜状态"] = function(_____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "地图清理"
    end
    local _____6570_91CF = 0
    local ids = {}
    for id in pairs(_____4F0A_857E_5A1C_72B6_6001_8868) do
        ids[#ids + 1] = __TS__Number(id)
    end
    do
        local i = 0
        while i < #ids do
            do
                local _____72B6_6001 = _____4F0A_857E_5A1C_72B6_6001_8868[ids[i + 1]]
                if _____72B6_6001 == nil or _____72B6_6001["已清理"] then
                    goto __continue114
                end
                _____72B6_6001["已清理"] = true
                local ____ = _____539F_56E0
                _____6267_884C_5168_90E8_6280_80FD_6E05_7406(_____72B6_6001)
                _____72B6_6001["见闻列表"] = {}
                _____72B6_6001["当前变式"] = nil
                _____72B6_6001["变式到期时间"] = 0
                _____72B6_6001["R锁定变式"] = nil
                _____72B6_6001["E路线"] = nil
                _____72B6_6001["W结界"] = nil
                _____6E05_7406_5168_90E8_8FDB_5EA6UI(_____72B6_6001)
                __TS__Delete(_____4F0A_857E_5A1C_72B6_6001_8868, ids[i + 1])
                _____6570_91CF = _____6570_91CF + 1
            end
            ::__continue114::
            i = i + 1
        end
    end
    return _____6570_91CF
end
--- 仅供测试/调试：登记中的伊蕾娜数量与见闻总数。
____exports["获取伊蕾娜状态统计"] = function()
    local _____82F1_96C4_6570 = 0
    local _____89C1_95FB_603B_6570 = 0
    for id in pairs(_____4F0A_857E_5A1C_72B6_6001_8868) do
        local _____72B6_6001 = _____4F0A_857E_5A1C_72B6_6001_8868[id]
        if _____72B6_6001 ~= nil then
            _____82F1_96C4_6570 = _____82F1_96C4_6570 + 1
            _____89C1_95FB_603B_6570 = _____89C1_95FB_603B_6570 + #_____72B6_6001["见闻列表"]
        end
    end
    return {["英雄数"] = _____82F1_96C4_6570, ["见闻总数"] = _____89C1_95FB_603B_6570}
end
--- 强制披挂强度上限保护：负数防御归零
local function _____4E0D_5C0F_4E8E_96F6(v)
    return v > 0 and v or 0
end
local function _____53D1_5C04_98CE_884C_7A7F_900F_5F39(_____82F1_96C4, _____76EE_6807X, _____76EE_6807Y)
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(_____82F1_96C4),
        GetUnitY(_____82F1_96C4),
        _____76EE_6807X,
        _____76EE_6807Y
    )
    _____53D1_5C04_5F39_9053({
        ["名称"] = "伊蕾娜-风行魔弹",
        ["所有者"] = _____82F1_96C4,
        ["发射X"] = GetUnitX(_____82F1_96C4),
        ["发射Y"] = GetUnitY(_____82F1_96C4),
        ["发射方向角"] = _____65B9_5411_89D2,
        ["速度"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["弹道速度"],
        ["轨迹"] = {["类型"] = "直线", ["距离"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["风行穿透距离"]},
        ["命中半径"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = false,
        ["每单位最大命中次数"] = 1,
        ["最大总命中次数"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["风行最大命中数"],
        ["伤害值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____82F1_96C4) * _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["伤害攻击力倍率"],
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能标签"] = "伊蕾娜-魔法弹强化",
        ["伤害形态"] = "AOE",
        ["参与技能伤害加成"] = false,
        ["模型"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["模型路径"],
        RGB = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"].RGB,
        ["缩放"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["缩放"],
        ["飞行高度"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["高度"],
        ["生命周期"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["风行穿透距离"] / _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["弹道速度"] + 0.5
    })
end
local function _____53D1_5C04_8FDC_884C_9B54_5F39(_____82F1_96C4, _____76EE_6807)
    local _____8DEF_7EBF = ____exports["读取伊蕾娜扫帚路线"](_____82F1_96C4)
    local _____53D1_5C04_53C2_6570 = {
        ["名称"] = "伊蕾娜-远行魔弹",
        ["所有者"] = _____82F1_96C4,
        ["发射X"] = GetUnitX(_____82F1_96C4),
        ["发射Y"] = GetUnitY(_____82F1_96C4),
        ["速度"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["弹道速度"],
        ["命中半径"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = true,
        ["每单位最大命中次数"] = 1,
        ["伤害值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____82F1_96C4) * _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["伤害攻击力倍率"],
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能标签"] = "伊蕾娜-魔法弹强化",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false,
        ["模型"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["模型路径"],
        RGB = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"].RGB,
        ["缩放"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["缩放"],
        ["飞行高度"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["高度"],
        ["生命周期"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["远行最大距离"] / _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["弹道速度"] + 0.5
    }
    if _____8DEF_7EBF ~= nil then
        _____53D1_5C04_53C2_6570["发射方向角"] = _____8DEF_7EBF["方向角"]
        _____53D1_5C04_53C2_6570["轨迹"] = {["类型"] = "直线", ["距离"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["远行最大距离"]}
    else
        _____53D1_5C04_53C2_6570["发射方向角"] = _____4E24_70B9_89D2_5EA6(
            GetUnitX(_____82F1_96C4),
            GetUnitY(_____82F1_96C4),
            GetUnitX(_____76EE_6807),
            GetUnitY(_____76EE_6807)
        )
        _____53D1_5C04_53C2_6570["轨迹"] = {["类型"] = "追踪", ["目标"] = _____76EE_6807, ["追踪转向速度"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["远行追踪转向速度"], ["追踪保持秒"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["远行追踪保持秒"]}
    end
    _____53D1_5C04_5F39_9053(_____53D1_5C04_53C2_6570)
end
local function _____65BD_52A0_955C_754C_56DE_5E94(_____82F1_96C4, _____76EE_6807)
    SFB_setSlow(
        _____82F1_96C4,
        _____76EE_6807,
        0,
        _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["镜界减速比例"],
        _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["镜界减速秒"],
        "伊蕾娜-魔法弹强化",
        "技能"
    )
    local _____62A4_76FE_6570_503C = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____82F1_96C4) * _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["回响护盾攻击力倍率"]
    _____5145_80FD_5355_4F4D_6807_7B7E_62A4_76FE(
        _____82F1_96C4,
        "伊蕾娜-保护回响",
        _____62A4_76FE_6570_503C,
        _____62A4_76FE_6570_503C,
        {["类型"] = 0, ["持续时间"] = _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["回响护盾秒"], ["来源单位"] = _____82F1_96C4, ["显示护盾条"] = false}
    )
end
--- 强化命中回馈：减少 Q/W/E 剩余冷却（带内部冷却）。
local function _____56DE_9988QWE_51B7_5374(_____82F1_96C4, _____72B6_6001)
    local now = getGameTime()
    if now < _____72B6_6001["回馈下次可用时间"] then
        return
    end
    _____72B6_6001["回馈下次可用时间"] = now + _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["冷却回馈内部冷却毫秒"]
    local _____6280_80FD_8868 = {
        {
            id = ____Q_6280_80FD_7C7B_578BID,
            ["当前"] = platformAbilityApi["技能_获取技能当前冷却时间"](_____82F1_96C4, ____Q_6280_80FD_7C7B_578BID)
        },
        {
            id = ____W_6280_80FD_7C7B_578BID,
            ["当前"] = platformAbilityApi["技能_获取技能当前冷却时间"](_____82F1_96C4, ____W_6280_80FD_7C7B_578BID)
        },
        {
            id = ____E_6280_80FD_7C7B_578BID,
            ["当前"] = platformAbilityApi["技能_获取技能当前冷却时间"](_____82F1_96C4, ____E_6280_80FD_7C7B_578BID)
        }
    }
    do
        local i = 0
        while i < #_____6280_80FD_8868 do
            do
                if _____6280_80FD_8868[i + 1]["当前"] <= 0 then
                    goto __continue129
                end
                local _____5269_4F59 = _____4E0D_5C0F_4E8E_96F6(_____6280_80FD_8868[i + 1]["当前"] - _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["冷却缩减秒"])
                local _____6700_5927_51B7_5374 = platformAbilityApi["技能_获取技能最大冷却时间"](_____82F1_96C4, _____6280_80FD_8868[i + 1].id)
                platformAbilityAction["技能_设置技能冷却时间"](_____82F1_96C4, _____6280_80FD_8868[i + 1].id, _____5269_4F59, _____6700_5927_51B7_5374)
            end
            ::__continue129::
            i = i + 1
        end
    end
end
local function _____5904_7406_4F0A_857E_5A1C_5F3A_5316_666E_653B(target, attacker, _applied, snapshot)
    if target == nil or target == 0 then
        return
    end
    if attacker == nil or attacker == 0 or not ____exports["是伊蕾娜"](attacker) then
        return
    end
    local ____opt_result_17
    if snapshot ~= nil then
        ____opt_result_17 = snapshot.isNormalAttack
    end
    if ____opt_result_17 ~= true then
        return
    end
    local ____opt_result_20
    if snapshot ~= nil then
        ____opt_result_20 = snapshot.isWrappedSkillDamage
    end
    if ____opt_result_20 == true then
        return
    end
    local ____opt_result_23
    if snapshot ~= nil then
        ____opt_result_23 = snapshot.originalAttacker
    end
    if ____opt_result_23 ~= nil and snapshot.originalAttacker ~= attacker then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(target) then
        debugLogForce(
            "伊蕾娜-被动",
            "命中失败",
            "玩家",
            GetPlayerId(GetOwningPlayer(attacker)) + 1,
            "原因",
            "目标无效",
            "目标",
            GetUnitName(target),
            "handle",
            target
        )
        return
    end
    local _____72B6_6001 = _____67E5_627E_72B6_6001(attacker)
    if _____72B6_6001 == nil or _____72B6_6001["已清理"] then
        debugLogForce(
            "伊蕾娜-被动",
            "异常",
            "玩家",
            GetPlayerId(GetOwningPlayer(attacker)) + 1,
            "原因",
            "状态为空或已清理"
        )
        return
    end
    if _____60F0_6027_5254_9664_8FC7_671F_89C1_95FB(_____72B6_6001) then
        _____5237_65B0_89C1_95FBBuff(attacker, _____72B6_6001)
    end
    local _____4E0B_4E00_6761 = ____exports["预览伊蕾娜消费见闻"](attacker)
    if _____4E0B_4E00_6761 == nil then
        return
    end
    debugLogForce(
        "伊蕾娜-被动",
        "命中",
        "玩家",
        GetPlayerId(GetOwningPlayer(attacker)) + 1,
        "四码",
        fourCCToStringSafe(_____82F1_96C4_5355_4F4D_7C7B_578BID),
        "目标",
        GetUnitName(target),
        "handle",
        target,
        "X",
        math.floor(GetUnitX(target)),
        "Y",
        math.floor(GetUnitY(target)),
        "伤害",
        math.floor(_____8BFB_53D6_5355_4F4D_653B_51FB_529B(attacker) * _____4F0A_857E_5A1C_666E_653B_8054_52A8_914D_7F6E["伤害攻击力倍率"]),
        "类型",
        _____4E0B_4E00_6761["类型"]
    )
    if _____4E0B_4E00_6761["类型"] == "风行" then
        _____53D1_5C04_98CE_884C_7A7F_900F_5F39(
            attacker,
            GetUnitX(target),
            GetUnitY(target)
        )
    elseif _____4E0B_4E00_6761["类型"] == "镜界" then
        _____65BD_52A0_955C_754C_56DE_5E94(attacker, target)
    else
        _____53D1_5C04_8FDC_884C_9B54_5F39(attacker, target)
    end
    local _____5DF2_6D88_8D39 = ____exports["消费伊蕾娜见闻按序号"](attacker, _____4E0B_4E00_6761["序号"])
    local ____ = _____5DF2_6D88_8D39
    _____56DE_9988QWE_51B7_5374(attacker, _____72B6_6001)
end
local function _____786E_4FDD_6B7B_4EA1_76D1_542C()
    if _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(function(dyingUnit, _killingUnit)
        debugLogForce(
            "伊蕾娜-被动",
            "清理",
            "类型",
            "死亡",
            "单位",
            GetUnitName(dyingUnit),
            "handle",
            dyingUnit
        )
        if dyingUnit == nil or dyingUnit == 0 then
            return
        end
        if _____4F0A_857E_5A1C_72B6_6001_8868[_____53D6_5355_4F4DID(dyingUnit)] == nil then
            return
        end
        ____exports["清理伊蕾娜状态"](dyingUnit, "英雄死亡")
    end)
end
local _____666E_653B_8054_52A8_5DF2_6CE8_518C = false
--- 注册被动入口（幂等）：死亡清理监听 + 强化普攻伤害监听。
____exports["注册伊蕾娜被动效果"] = function()
    debugLogForce("伊蕾娜-被动", "注册", "名称", "注册伊蕾娜被动效果")
    _____786E_4FDD_6B7B_4EA1_76D1_542C()
    if _____666E_653B_8054_52A8_5DF2_6CE8_518C then
        return
    end
    _____666E_653B_8054_52A8_5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(_____5904_7406_4F0A_857E_5A1C_5F3A_5316_666E_653B)
end
return ____exports
