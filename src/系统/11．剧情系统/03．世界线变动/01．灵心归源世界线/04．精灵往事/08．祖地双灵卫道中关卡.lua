local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.01．祖地双灵卫副本配置")
local _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["祖地双灵卫副本配置"]
local ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.02．祖地双灵卫副本状态")
local _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001["祖地双灵卫副本状态"]
local ____03_FF0E_7956_5730_53CC_7075_536B_8BD5_70BC = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.03．祖地双灵卫试炼")
local ____register_7956_5730_53CC_7075_536B_8BD5_70BC_5168_90E8_5B8C_6210Listener = ____03_FF0E_7956_5730_53CC_7075_536B_8BD5_70BC["register祖地双灵卫试炼全部完成Listener"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_1["创建单位并登记排泄安全"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("lib.扩展函数.BJ函数.07．杂项")
local ModifyGateBJ = ____require_result_3.ModifyGateBJ
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_4["广播单位提示"]
local GetHandleId = jass.GetHandleId
local Player = jass.Player
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____9053_4E2D_5E7F_64AD_524D_7F00 = "|cffffff00『祖地秘境』：|r"
local _____9053_4E2D_901A_5173_5E7F_64AD_6301_7EED_6BEB_79D2 = 5000
local _____9053_4E2D_6A21_5757_5DF2_521D_59CB_5316 = false
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____6253_5F00_5173_5361_95F8_95E8(_____95F8_95E8_53D8_91CF_540D)
    local gate = jglobals[_____95F8_95E8_53D8_91CF_540D]
    if not _____53E5_67C4_6709_6548(gate) then
        return
    end
    ModifyGateBJ(jglobals.bj_GATEOPERATION_OPEN, gate)
end
local function _____521B_5EFA_9053_4E2D_5173_5361_5355_4F4D(_____9884_7F6E)
    local unitTypeId = stringToFourCCSafe(_____9884_7F6E["单位ID"])
    if unitTypeId == 0 then
        return false
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        unitTypeId,
        _____9884_7F6E.X,
        _____9884_7F6E.Y,
        _____9884_7F6E["朝向"]
    )
    if not _____53E5_67C4_6709_6548(unit) then
        return false
    end
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["道中"]["存活单位句柄表"][GetHandleId(unit)] = true
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["道中"]["存活单位数"] = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["道中"]["存活单位数"] + 1
    return true
end
local function _____5F00_542F_9053_4E2D_5173_5361(_____5173_5361_5E8F_53F7)
    local _____5173_5361 = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["道中关卡列表"][_____5173_5361_5E8F_53F7]
    if _____5173_5361 == nil then
        return
    end
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["道中"]["当前关卡序号"] = _____5173_5361_5E8F_53F7
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["道中"]["存活单位句柄表"] = {}
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["道中"]["存活单位数"] = 0
    do
        local i = 0
        while i < #_____5173_5361["编制"] do
            _____521B_5EFA_9053_4E2D_5173_5361_5355_4F4D(_____5173_5361["编制"][i + 1])
            i = i + 1
        end
    end
end
local function _____8FDB_5165_4E0B_4E00_5173()
    local _____72B6_6001 = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["道中"]
    local _____5173_5361_5E8F_53F7 = _____72B6_6001["当前关卡序号"]
    local _____5173_5361 = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["道中关卡列表"][_____5173_5361_5E8F_53F7]
    if _____5173_5361 == nil then
        return
    end
    _____6253_5F00_5173_5361_95F8_95E8(_____5173_5361["闸门变量名"])
    _____5E7F_64AD_5355_4F4D_63D0_793A(nil, _____9053_4E2D_5E7F_64AD_524D_7F00 .. _____5173_5361["通关广播"], _____9053_4E2D_901A_5173_5E7F_64AD_6301_7EED_6BEB_79D2)
    if _____5173_5361_5E8F_53F7 >= #_____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["道中关卡列表"] then
        _____72B6_6001["全部通关"] = true
        return
    end
    _____5F00_542F_9053_4E2D_5173_5361(_____5173_5361_5E8F_53F7 + 1)
end
local function ____on_9053_4E2D_5355_4F4D_6B7B_4EA1(dyingUnit)
    local _____72B6_6001 = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["道中"]
    if not _____72B6_6001["已开启"] or _____72B6_6001["全部通关"] then
        return
    end
    local handleId = GetHandleId(dyingUnit)
    if handleId == 0 then
        return
    end
    if _____72B6_6001["存活单位句柄表"][handleId] ~= true then
        return
    end
    __TS__Delete(_____72B6_6001["存活单位句柄表"], handleId)
    _____72B6_6001["存活单位数"] = _____72B6_6001["存活单位数"] - 1
    if _____72B6_6001["存活单位数"] > 0 then
        return
    end
    _____8FDB_5165_4E0B_4E00_5173()
end
local function ____on_7956_5730_53CC_7075_536B_8BD5_70BC_5168_90E8_5B8C_6210_5F00_542F_9053_4E2D()
    local _____72B6_6001 = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["道中"]
    if _____72B6_6001["已开启"] then
        return
    end
    _____72B6_6001["已开启"] = true
    _____5F00_542F_9053_4E2D_5173_5361(1)
end
____exports["init祖地双灵卫道中关卡"] = function()
    if _____9053_4E2D_6A21_5757_5DF2_521D_59CB_5316 then
        return
    end
    _____9053_4E2D_6A21_5757_5DF2_521D_59CB_5316 = true
    ____register_7956_5730_53CC_7075_536B_8BD5_70BC_5168_90E8_5B8C_6210Listener(____on_7956_5730_53CC_7075_536B_8BD5_70BC_5168_90E8_5B8C_6210_5F00_542F_9053_4E2D)
    registerDeathListener(____on_9053_4E2D_5355_4F4D_6B7B_4EA1)
end
return ____exports
