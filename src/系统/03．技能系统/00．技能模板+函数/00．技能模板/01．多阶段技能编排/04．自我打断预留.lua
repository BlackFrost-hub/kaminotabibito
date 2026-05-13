local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
--- 技能自我打断预留接口
-- 
-- 说明：
-- 1. 这里只维护“可自我打断技能阶段”的登记与上报，不直接绑定命令事件
-- 2. 未来若要接“单位发布打断命令 / 按下 S”，命令系统只需要调用 `报告单位自我打断`
-- 3. 当前硬直使用 `EXPauseUnit`，暂停中的单位能否稳定发出命令还需游戏内继续验证
local jass = require("jass.common")
local japi = nil
do
    local function ____catch(_e)
        japi = nil
    end
    local ____try, ____hasReturned = pcall(function()
        japi = require("jass.japi")
    end)
    if not ____try then
        ____catch(____hasReturned)
    end
end
local ____require_result_0 = require("lib.扩展函数.KK扩展API.index")
local DzTriggerRegisterKeyEventTrg = ____require_result_0.DzTriggerRegisterKeyEventTrg
local ____require_result_1 = require("lib.扩展函数.封装函数.04．硬件输入.index")
local KEY = ____require_result_1.KEY
local KEY_STATE = ____require_result_1.KEY_STATE
local ____require_result_2 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_2.YDUserDataGet
local _____9009_4E2D_5355_4F4D_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local GetHandleId = jass.GetHandleId
local GetPlayerId = jass.GetPlayerId
local TriggerAddAction = jass.TriggerAddAction
local CreateTrigger = jass.CreateTrigger
local _____9636_6BB5_76D1_542C_8868 = {}
local _____5355_4F4D_76D1_542C_8868 = {}
local _____81EA_6211_6253_65ADS_952E_5DF2_521D_59CB_5316 = false
local _____81EA_6211_6253_65ADS_952E_89E6_53D1_5668 = nil
local function _____53D6_53E5_67C4ID(h)
    return h ~= nil and h ~= 0 and GetHandleId(h) or 0 or 0
end
____exports["注册技能自我打断监听"] = function(_____5355_4F4D, _____9636_6BB5ID, _____56DE_8C03)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 or _____9636_6BB5ID <= 0 or _____56DE_8C03 == nil then
        return
    end
    _____9636_6BB5_76D1_542C_8868[_____9636_6BB5ID] = {["单位"] = _____5355_4F4D, ["阶段ID"] = _____9636_6BB5ID, ["回调"] = _____56DE_8C03}
    local _____5217_8868 = _____5355_4F4D_76D1_542C_8868[_____5355_4F4DID] or ({})
    if __TS__ArrayIndexOf(_____5217_8868, _____9636_6BB5ID) < 0 then
        _____5217_8868[#_____5217_8868 + 1] = _____9636_6BB5ID
    end
    _____5355_4F4D_76D1_542C_8868[_____5355_4F4DID] = _____5217_8868
end
____exports["取消技能自我打断监听"] = function(_____9636_6BB5ID)
    local _____76D1_542C = _____9636_6BB5_76D1_542C_8868[_____9636_6BB5ID]
    if _____76D1_542C == nil then
        return
    end
    __TS__Delete(_____9636_6BB5_76D1_542C_8868, _____9636_6BB5ID)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____76D1_542C["单位"])
    local _____5217_8868 = _____5355_4F4D_76D1_542C_8868[_____5355_4F4DID]
    if _____5217_8868 == nil then
        return
    end
    local _____7D22_5F15 = __TS__ArrayIndexOf(_____5217_8868, _____9636_6BB5ID)
    if _____7D22_5F15 >= 0 then
        __TS__ArraySplice(_____5217_8868, _____7D22_5F15, 1)
    end
    if #_____5217_8868 == 0 then
        __TS__Delete(_____5355_4F4D_76D1_542C_8868, _____5355_4F4DID)
    end
end
____exports["单位是否存在可自我打断技能阶段"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____5217_8868 = _____5355_4F4D_76D1_542C_8868[_____5355_4F4DID]
    return _____5217_8868 ~= nil and #_____5217_8868 > 0
end
____exports["报告单位自我打断"] = function(_____5355_4F4D, _____65B9_5F0F)
    if _____65B9_5F0F == nil then
        _____65B9_5F0F = "未知"
    end
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return
    end
    local _____5217_8868 = _____5355_4F4D_76D1_542C_8868[_____5355_4F4DID]
    if _____5217_8868 == nil or #_____5217_8868 == 0 then
        return
    end
    local _____9636_6BB5ID_5217_8868 = __TS__ArraySlice(_____5217_8868)
    for ____, _____9636_6BB5ID in ipairs(_____9636_6BB5ID_5217_8868) do
        local _____76D1_542C = _____9636_6BB5_76D1_542C_8868[_____9636_6BB5ID]
        if _____76D1_542C ~= nil then
            _____76D1_542C["回调"](_____5355_4F4D, _____9636_6BB5ID, _____65B9_5F0F)
        end
    end
end
local function _____83B7_53D6_73A9_5BB6_5F53_524D_53EF_6253_65AD_5355_4F4D(_____73A9_5BB6)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return nil
    end
    local _____73A9_5BB6ID = GetPlayerId(_____73A9_5BB6)
    local getSoleSelectedUnitForPlayer = _____9009_4E2D_5355_4F4D_4E8B_4EF6_4E2D_5FC3.getSoleSelectedUnitForPlayer
    if type(getSoleSelectedUnitForPlayer) == "function" then
        local _____9009_4E2D_5355_4F4D = getSoleSelectedUnitForPlayer(_____73A9_5BB6ID)
        if _____9009_4E2D_5355_4F4D ~= nil and ____exports["单位是否存在可自我打断技能阶段"](_____9009_4E2D_5355_4F4D) then
            return _____9009_4E2D_5355_4F4D
        end
    end
    local _____82F1_96C4 = YDUserDataGet(
        nil,
        "player",
        _____73A9_5BB6,
        "英雄",
        "unit"
    )
    if _____82F1_96C4 ~= nil and _____82F1_96C4 ~= 0 and ____exports["单位是否存在可自我打断技能阶段"](_____82F1_96C4) then
        return _____82F1_96C4
    end
    return nil
end
local function ____on_6280_80FD_81EA_6211_6253_65AD_S_952E_6309_4E0B()
    if japi == nil or type(japi.DzGetTriggerKeyPlayer) ~= "function" then
        return
    end
    local _____6309_952E_73A9_5BB6 = japi:DzGetTriggerKeyPlayer()
    local _____5355_4F4D = _____83B7_53D6_73A9_5BB6_5F53_524D_53EF_6253_65AD_5355_4F4D(_____6309_952E_73A9_5BB6)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    ____exports["报告单位自我打断"](_____5355_4F4D, "按下S")
end
____exports["初始化技能自我打断_S键监听"] = function()
    if _____81EA_6211_6253_65ADS_952E_5DF2_521D_59CB_5316 then
        return
    end
    _____81EA_6211_6253_65ADS_952E_5DF2_521D_59CB_5316 = true
    _____81EA_6211_6253_65ADS_952E_89E6_53D1_5668 = CreateTrigger()
    if _____81EA_6211_6253_65ADS_952E_89E6_53D1_5668 == nil or _____81EA_6211_6253_65ADS_952E_89E6_53D1_5668 == 0 then
        return
    end
    DzTriggerRegisterKeyEventTrg(nil, _____81EA_6211_6253_65ADS_952E_89E6_53D1_5668, KEY_STATE.DOWN, KEY.S)
    TriggerAddAction(_____81EA_6211_6253_65ADS_952E_89E6_53D1_5668, ____on_6280_80FD_81EA_6211_6253_65AD_S_952E_6309_4E0B)
end
____exports["初始化技能自我打断_S键监听"]()
return ____exports
