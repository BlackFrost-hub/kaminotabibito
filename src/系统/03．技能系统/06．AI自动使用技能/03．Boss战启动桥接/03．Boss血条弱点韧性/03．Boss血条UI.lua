--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.01．常量定义")
local ____Boss_8840_6761UI_5E38_91CF = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss血条UI常量"]
local ____Boss_62A4_536B_8840_6761UI_5E38_91CF = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss护卫血条UI常量"]
local ____Boss_5F31_70B9UI_5E38_91CF = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点UI常量"]
local ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.05．Boss弱点运行状态")
local _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["获取全部Boss血条弱点韧性运行状态"]
local japi = require("jass.japi")
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local GetUnitLifePercentBJ = ____require_result_1.GetUnitLifePercentBJ
local IsUnitAliveBJ = ____require_result_1.IsUnitAliveBJ
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local getObjectPropertySafe = ____require_result_2.getObjectPropertySafe
local ____require_result_3 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local ObjectType = ____require_result_3.ObjectType
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_4.debugLogForce
local ____Boss_8840_6761_5934_50CF_8C03_8BD5_6A21_5757_540D = "Boss血条头像"
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzGetGameUI = japi.DzGetGameUI
local DzFrameSetModel = japi.DzFrameSetModel
local DzFrameSetAnimate = japi.DzFrameSetAnimate
local DzFrameSetAnimateOffset = japi.DzFrameSetAnimateOffset
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetScale = japi.DzFrameSetScale
local DzFrameSetModelScale = japi.DzFrameSetModelScale
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetAlpha = japi.DzFrameSetAlpha
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameClearAllPoints = japi.DzFrameClearAllPoints
local DzFrameShow = japi.DzFrameShow
local DzDestroyFrame = japi.DzDestroyFrame
local GetUnitTypeId = jass.GetUnitTypeId
local R2I = jass.R2I
local _____8840_6761_5237_65B0_56DE_8C03ID = 0
local function _____9650_5236_6BD4_4F8B(value)
    if value < 0 then
        return 0
    end
    if value > 1 then
        return 1
    end
    return value
end
local function _____53D6Boss_5355_4F4D_9ED8_8BA4_5934_50CF_8DEF_5F84(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        debugLogForce(____Boss_8840_6761_5934_50CF_8C03_8BD5_6A21_5757_540D, "默认头像读取失败", "原因=单位为空")
        return ""
    end
    local unitTypeId = GetUnitTypeId(bossUnit)
    if unitTypeId == 0 then
        debugLogForce(____Boss_8840_6761_5934_50CF_8C03_8BD5_6A21_5757_540D, "默认头像读取失败", "原因=单位类型ID为0")
        return ""
    end
    local artPath = getObjectPropertySafe(ObjectType.UNIT, unitTypeId, "Art") or ""
    debugLogForce(
        ____Boss_8840_6761_5934_50CF_8C03_8BD5_6A21_5757_540D,
        "读取物编头像",
        "unitTypeId=",
        unitTypeId,
        "Art=",
        artPath == "" and "<空>" or artPath
    )
    return artPath
end
local function _____8BA1_7B97Boss_8840_6761_69FD_4F4DY_504F_79FB(state)
    local slotIndex = state["血条槽位索引"] > 0 and state["血条槽位索引"] or 0
    local ____temp_5
    if state["显示类型"] == "护卫" then
        ____temp_5 = slotIndex > 1
    else
        ____temp_5 = slotIndex >= 1
    end
    local _____662F_5426_5E94_7528_540E_7EED_69FD_4F4D_8865_507F = ____temp_5
    return -____Boss_8840_6761UI_5E38_91CF["槽位垂直间距"] * slotIndex + (_____662F_5426_5E94_7528_540E_7EED_69FD_4F4D_8865_507F and ____Boss_8840_6761UI_5E38_91CF["第二槽及后续Y补偿"] or 0) + (state["显示类型"] == "护卫" and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["整组Y补偿"] or 0)
end
local function _____8BA1_7B97_62A4_536B_69FD_4F4D_4E2D_5FC3_504F_79FBX(state)
    if state["显示类型"] ~= "护卫" then
        return 0
    end
    return state["护卫槽位索引"] == 1 and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["右槽中心偏移X"] or ____Boss_62A4_536B_8840_6761UI_5E38_91CF["左槽中心偏移X"]
end
local function _____8BA1_7B97Boss_8840_6761X(state)
    return ____Boss_8840_6761UI_5E38_91CF["血条X"] + _____8BA1_7B97_62A4_536B_69FD_4F4D_4E2D_5FC3_504F_79FBX(state) + (state["显示类型"] == "护卫" and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["红色血条模型X补偿"] or 0)
end
local function _____8BA1_7B97Boss_635F_5931_8840_6761X(state)
    return ____Boss_8840_6761UI_5E38_91CF["血条X"] + _____8BA1_7B97_62A4_536B_69FD_4F4D_4E2D_5FC3_504F_79FBX(state)
end
local function _____8BA1_7B97Boss_7EA2_8272_8840_6761Y(state, yOffset)
    return ____Boss_8840_6761UI_5E38_91CF["血条Y"] + yOffset + (state["显示类型"] == "护卫" and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["红色血条模型Y补偿"] or 0)
end
local function _____8BA1_7B97Boss_62A4_76FE_586B_5145Y(state, yOffset)
    return ____Boss_8840_6761UI_5E38_91CF["护盾填充Y"] + yOffset + (state["显示类型"] == "护卫" and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护盾填充Y补偿"] or 0)
end
local function _____8BA1_7B97Boss_673A_5236_56FE_6807Y(state, baseY, yOffset)
    return baseY + yOffset + (state["显示类型"] == "护卫" and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["弱点图标Y补偿"] or 0)
end
local function _____8BA1_7B97Boss_62A4_76FE_6846X(state)
    return ____Boss_8840_6761UI_5E38_91CF["护盾框X"] + _____8BA1_7B97_62A4_536B_69FD_4F4D_4E2D_5FC3_504F_79FBX(state)
end
local function _____8BA1_7B97Boss_62A4_76FE_586B_5145_57FA_7840X(state)
    return ____Boss_8840_6761UI_5E38_91CF["护盾填充基础X"] + _____8BA1_7B97_62A4_536B_69FD_4F4D_4E2D_5FC3_504F_79FBX(state) + (state["显示类型"] == "护卫" and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护盾填充X补偿"] or 0)
end
____exports["计算Boss弱点X坐标"] = function(state, weakIndex)
    if state["显示类型"] ~= "护卫" then
        return ____Boss_5F31_70B9UI_5E38_91CF["弱点起始X"] + ____Boss_5F31_70B9UI_5E38_91CF["弱点间距"] * (weakIndex + 1)
    end
    local startX = state["护卫槽位索引"] == 1 and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["右槽弱点起始X"] or ____Boss_62A4_536B_8840_6761UI_5E38_91CF["左槽弱点起始X"]
    return startX + ____Boss_62A4_536B_8840_6761UI_5E38_91CF["弱点间距"] * weakIndex
end
____exports["计算Boss护盾图标X"] = function(state)
    if state["显示类型"] ~= "护卫" then
        return ____Boss_5F31_70B9UI_5E38_91CF["护盾图标X"]
    end
    return state["护卫槽位索引"] == 1 and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["右槽弱点起始X"] or ____Boss_62A4_536B_8840_6761UI_5E38_91CF["左槽弱点起始X"]
end
____exports["获取Boss机制图标缩放"] = function(state)
    return state["显示类型"] == "护卫" and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["机制图标缩放"] or 1
end
local function _____91CD_8BBE_7EDD_5BF9_70B9(frame, point, x, y)
    if frame == 0 then
        return
    end
    DzFrameClearAllPoints(frame)
    DzFrameSetAbsolutePoint(frame, point, x, y)
end
local function _____91CD_8BBE_76F8_5BF9_70B9(frame, point, relativeFrame, relativePoint, x, y)
    if frame == 0 then
        return
    end
    DzFrameClearAllPoints(frame)
    DzFrameSetPoint(
        frame,
        point,
        relativeFrame,
        relativePoint,
        x,
        y
    )
end
____exports["刷新Boss血条槽位布局"] = function(state)
    if not state["是否血条已注册"] or state["是否已结束"] then
        return
    end
    local gameUI = DzGetGameUI()
    local yOffset = _____8BA1_7B97Boss_8840_6761_69FD_4F4DY_504F_79FB(state)
    _____91CD_8BBE_76F8_5BF9_70B9(
        state["血条Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        gameUI,
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        _____8BA1_7B97Boss_8840_6761X(state),
        _____8BA1_7B97Boss_7EA2_8272_8840_6761Y(state, yOffset)
    )
    _____91CD_8BBE_76F8_5BF9_70B9(
        state["损失血条Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        gameUI,
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        _____8BA1_7B97Boss_635F_5931_8840_6761X(state),
        ____Boss_8840_6761UI_5E38_91CF["血条Y"] + yOffset
    )
    _____91CD_8BBE_7EDD_5BF9_70B9(
        state["血量文本Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        state["显示类型"] == "护卫" and _____8BA1_7B97Boss_62A4_76FE_6846X(state) or ____Boss_8840_6761UI_5E38_91CF["血量文本X"],
        ____Boss_8840_6761UI_5E38_91CF["血量文本Y"] + yOffset
    )
    _____91CD_8BBE_7EDD_5BF9_70B9(
        state["护盾框Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        _____8BA1_7B97Boss_62A4_76FE_6846X(state),
        ____Boss_8840_6761UI_5E38_91CF["护盾框Y"] + yOffset
    )
    local shieldRatio = state["最大护盾值"] > 0 and _____9650_5236_6BD4_4F8B(state["当前护盾值"] / state["最大护盾值"]) or 1
    _____91CD_8BBE_7EDD_5BF9_70B9(
        state["护盾填充Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        _____8BA1_7B97Boss_62A4_76FE_586B_5145_57FA_7840X(state) - (state["显示类型"] == "护卫" and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护盾填充偏移系数"] or ____Boss_8840_6761UI_5E38_91CF["护盾填充偏移系数"]) * (1 - shieldRatio),
        _____8BA1_7B97Boss_62A4_76FE_586B_5145Y(state, yOffset)
    )
    do
        local i = 0
        while i < #state["弱点X轴列表"] do
            local x = ____exports["计算Boss弱点X坐标"](state, i)
            state["弱点X轴列表"][i + 1] = x
            _____91CD_8BBE_7EDD_5BF9_70B9(
                state["弱点问号Frame列表"][i + 1] or 0,
                ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
                x,
                _____8BA1_7B97Boss_673A_5236_56FE_6807Y(state, ____Boss_5F31_70B9UI_5E38_91CF["弱点Y"], yOffset)
            )
            _____91CD_8BBE_7EDD_5BF9_70B9(
                state["弱点图标Frame列表"][i + 1] or 0,
                ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
                x,
                _____8BA1_7B97Boss_673A_5236_56FE_6807Y(state, ____Boss_5F31_70B9UI_5E38_91CF["弱点Y"], yOffset)
            )
            i = i + 1
        end
    end
    _____91CD_8BBE_7EDD_5BF9_70B9(
        state["护盾图标Frame"],
        ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
        ____exports["计算Boss护盾图标X"](state),
        _____8BA1_7B97Boss_673A_5236_56FE_6807Y(state, ____Boss_5F31_70B9UI_5E38_91CF["护盾图标Y"], yOffset)
    )
    _____91CD_8BBE_7EDD_5BF9_70B9(
        state["护盾说明按钮Frame"],
        ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
        ____exports["计算Boss护盾图标X"](state),
        _____8BA1_7B97Boss_673A_5236_56FE_6807Y(state, ____Boss_5F31_70B9UI_5E38_91CF["护盾图标Y"], yOffset)
    )
    _____91CD_8BBE_7EDD_5BF9_70B9(
        state["破碎护盾Frame"],
        ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
        ____exports["计算Boss护盾图标X"](state),
        _____8BA1_7B97Boss_673A_5236_56FE_6807Y(state, ____Boss_5F31_70B9UI_5E38_91CF["护盾状态图标Y"], yOffset)
    )
    _____91CD_8BBE_7EDD_5BF9_70B9(
        state["灰色护盾Frame"],
        ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
        ____exports["计算Boss护盾图标X"](state),
        _____8BA1_7B97Boss_673A_5236_56FE_6807Y(state, ____Boss_5F31_70B9UI_5E38_91CF["护盾状态图标Y"], yOffset)
    )
end
____exports["重新排列Boss血条槽位"] = function()
    local allStates = _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001()
    local activeBossStates = {}
    local activeIndependentGuardStates = {}
    local activeSharedGuardStates = {}
    do
        local i = 0
        while i < #allStates do
            do
                local state = allStates[i + 1]
                if not state["是否血条已注册"] or state["是否已结束"] then
                    goto __continue33
                end
                if state["显示类型"] ~= "护卫" then
                    activeBossStates[#activeBossStates + 1] = state
                elseif state["护卫血条归属类型"] == "共享" then
                    activeSharedGuardStates[#activeSharedGuardStates + 1] = state
                else
                    activeIndependentGuardStates[#activeIndependentGuardStates + 1] = state
                end
            end
            ::__continue33::
            i = i + 1
        end
    end
    local rowIndex = 0
    local arrangedIndependentGuardStates = {}
    do
        local i = 0
        while i < #activeBossStates do
            local bossState = activeBossStates[i + 1]
            bossState["血条槽位索引"] = rowIndex
            bossState["护卫槽位索引"] = -1
            ____exports["刷新Boss血条槽位布局"](bossState)
            rowIndex = rowIndex + 1
            local guardSlotIndex = 0
            do
                local guardIndex = 0
                while guardIndex < #activeIndependentGuardStates do
                    do
                        local guardState = activeIndependentGuardStates[guardIndex + 1]
                        if guardState["所属主Boss句柄ID"] ~= bossState["所属主Boss句柄ID"] then
                            goto __continue41
                        end
                        guardState["血条槽位索引"] = rowIndex
                        guardState["护卫槽位索引"] = guardSlotIndex
                        ____exports["刷新Boss血条槽位布局"](guardState)
                        arrangedIndependentGuardStates[#arrangedIndependentGuardStates + 1] = guardState
                        guardSlotIndex = guardSlotIndex + 1
                    end
                    ::__continue41::
                    guardIndex = guardIndex + 1
                end
            end
            if guardSlotIndex > 0 then
                rowIndex = rowIndex + ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护卫行占用槽位"]
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #activeIndependentGuardStates do
            do
                local firstGuardState = activeIndependentGuardStates[i + 1]
                local alreadyArranged = false
                do
                    local arrangedIndex = 0
                    while arrangedIndex < #arrangedIndependentGuardStates do
                        if arrangedIndependentGuardStates[arrangedIndex + 1] == firstGuardState then
                            alreadyArranged = true
                        end
                        arrangedIndex = arrangedIndex + 1
                    end
                end
                if alreadyArranged then
                    goto __continue45
                end
                local guardSlotIndex = 0
                do
                    local guardIndex = i
                    while guardIndex < #activeIndependentGuardStates do
                        do
                            local guardState = activeIndependentGuardStates[guardIndex + 1]
                            if guardState["所属主Boss句柄ID"] ~= firstGuardState["所属主Boss句柄ID"] then
                                goto __continue51
                            end
                            guardState["血条槽位索引"] = rowIndex
                            guardState["护卫槽位索引"] = guardSlotIndex
                            ____exports["刷新Boss血条槽位布局"](guardState)
                            arrangedIndependentGuardStates[#arrangedIndependentGuardStates + 1] = guardState
                            guardSlotIndex = guardSlotIndex + 1
                        end
                        ::__continue51::
                        guardIndex = guardIndex + 1
                    end
                end
                if guardSlotIndex > 0 then
                    rowIndex = rowIndex + ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护卫行占用槽位"]
                end
            end
            ::__continue45::
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #activeSharedGuardStates do
            local state = activeSharedGuardStates[i + 1]
            state["血条槽位索引"] = rowIndex
            state["护卫槽位索引"] = i
            ____exports["刷新Boss血条槽位布局"](state)
            i = i + 1
        end
    end
end
local function _____53D6Boss_5934_50CF_8DEF_5F84(state)
    if state["头像覆盖贴图路径"] ~= "" then
        return state["头像覆盖贴图路径"]
    end
    return _____53D6Boss_5355_4F4D_9ED8_8BA4_5934_50CF_8DEF_5F84(state["Boss单位"])
end
local function _____663E_793A_8840_6761_5E27_7EC4(state, visible)
    if state["血条Frame"] ~= 0 then
        DzFrameShow(state["血条Frame"], visible)
    end
    if state["损失血条Frame"] ~= 0 then
        DzFrameShow(state["损失血条Frame"], visible)
    end
    if state["头像Frame"] ~= 0 then
        DzFrameShow(state["头像Frame"], visible)
    end
    if state["血量文本Frame"] ~= 0 then
        DzFrameShow(state["血量文本Frame"], visible)
    end
    if state["护盾框Frame"] ~= 0 then
        DzFrameShow(state["护盾框Frame"], visible)
    end
    if state["护盾填充Frame"] ~= 0 then
        DzFrameShow(state["护盾填充Frame"], visible)
    end
end
local function _____9500_6BC1_5E27(frame)
    if frame == 0 then
        return
    end
    DzFrameShow(frame, false)
    DzDestroyFrame(frame)
end
local function _____5237_65B0Boss_8840_6761UI(state)
    if state["是否已结束"] or not state["是否血条已注册"] then
        return
    end
    if state["Boss单位"] == nil or state["Boss单位"] == 0 or not IsUnitAliveBJ(state["Boss单位"]) then
        _____663E_793A_8840_6761_5E27_7EC4(state, false)
        return
    end
    local hpPercent = GetUnitLifePercentBJ(state["Boss单位"])
    local hpRatio = _____9650_5236_6BD4_4F8B(hpPercent / 100)
    local shieldValue = state["当前护盾值"]
    local shieldMax = state["最大护盾值"]
    if state["血量文本Frame"] ~= 0 then
        DzFrameSetText(
            state["血量文本Frame"],
            (" [HP] ：" .. tostring(R2I(hpPercent))) .. "%"
        )
    end
    if state["损失血条Frame"] ~= 0 then
        DzFrameSetAnimateOffset(state["损失血条Frame"], hpPercent >= 100 and 0.9999 or hpRatio)
    end
    if shieldValue <= 0 or shieldMax <= 0 then
        if state["护盾填充Frame"] ~= 0 then
            DzFrameShow(state["护盾填充Frame"], false)
        end
        return
    end
    local shieldRatio = _____9650_5236_6BD4_4F8B(shieldValue / shieldMax)
    local yOffset = _____8BA1_7B97Boss_8840_6761_69FD_4F4DY_504F_79FB(state)
    if state["护盾填充Frame"] ~= 0 then
        DzFrameSetSize(state["护盾填充Frame"], (state["显示类型"] == "护卫" and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护盾填充基础宽"] or ____Boss_8840_6761UI_5E38_91CF["护盾填充基础宽"]) * shieldRatio, state["显示类型"] == "护卫" and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护盾填充高"] or ____Boss_8840_6761UI_5E38_91CF["护盾填充高"])
        _____91CD_8BBE_7EDD_5BF9_70B9(
            state["护盾填充Frame"],
            ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
            _____8BA1_7B97Boss_62A4_76FE_586B_5145_57FA_7840X(state) - (state["显示类型"] == "护卫" and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护盾填充偏移系数"] or ____Boss_8840_6761UI_5E38_91CF["护盾填充偏移系数"]) * (1 - shieldRatio),
            _____8BA1_7B97Boss_62A4_76FE_586B_5145Y(state, yOffset)
        )
        DzFrameShow(state["护盾填充Frame"], true)
    end
end
local function ____onBoss_8840_6761_5237_65B0Tick()
    local states = _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001()
    do
        local i = 0
        while i < #states do
            _____5237_65B0Boss_8840_6761UI(states[i + 1])
            i = i + 1
        end
    end
end
local function _____786E_4FDDBoss_8840_6761_5237_65B0()
    if _____8840_6761_5237_65B0_56DE_8C03ID ~= 0 then
        return
    end
    _____8840_6761_5237_65B0_56DE_8C03ID = addPeriodicCallback(____Boss_8840_6761UI_5E38_91CF["刷新间隔毫秒"], ____onBoss_8840_6761_5237_65B0Tick)
end
local function _____505C_6B62Boss_8840_6761_5237_65B0_5982_679C_7A7A_95F2()
    if _____8840_6761_5237_65B0_56DE_8C03ID == 0 then
        return
    end
    local states = _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001()
    do
        local i = 0
        while i < #states do
            if states[i + 1]["是否血条已注册"] and not states[i + 1]["是否已结束"] then
                return
            end
            i = i + 1
        end
    end
    removePeriodicCallback(_____8840_6761_5237_65B0_56DE_8C03ID)
    _____8840_6761_5237_65B0_56DE_8C03ID = 0
end
local function _____521B_5EFABoss_8840_6761_5E27_7EC4(state)
    local gameUI = DzGetGameUI()
    local isGuard = state["显示类型"] == "护卫"
    local barScale = isGuard and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["血条缩放"] or 1
    state["血条Frame"] = DzCreateFrameByTagName(
        "SPRITE",
        "BossHealthBar",
        gameUI,
        "template",
        0
    )
    DzFrameSetModel(state["血条Frame"], ____Boss_8840_6761UI_5E38_91CF["血条模型"], 0, 0)
    DzFrameSetAnimate(state["血条Frame"], 0, true)
    DzFrameSetScale(state["血条Frame"], barScale)
    if isGuard then
        DzFrameSetModelScale(state["血条Frame"], ____Boss_62A4_536B_8840_6761UI_5E38_91CF["红色血条模型横向缩放"], ____Boss_62A4_536B_8840_6761UI_5E38_91CF["红色血条模型高度缩放"], 1)
    end
    DzFrameSetPoint(
        state["血条Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        gameUI,
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        _____8BA1_7B97Boss_8840_6761X(state),
        _____8BA1_7B97Boss_7EA2_8272_8840_6761Y(state, 0)
    )
    state["损失血条Frame"] = DzCreateFrameByTagName(
        "SPRITE",
        "BossLostHealthBar",
        state["血条Frame"],
        "template",
        0
    )
    DzFrameSetModel(state["损失血条Frame"], ____Boss_8840_6761UI_5E38_91CF["损失血条模型"], 0, 0)
    DzFrameSetAnimate(state["损失血条Frame"], 0, false)
    DzFrameSetScale(state["损失血条Frame"], barScale)
    DzFrameSetPoint(
        state["损失血条Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        gameUI,
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        _____8BA1_7B97Boss_635F_5931_8840_6761X(state),
        ____Boss_8840_6761UI_5E38_91CF["血条Y"]
    )
    DzFrameSetPriority(state["损失血条Frame"], 2)
    state["头像Frame"] = DzCreateFrameByTagName(
        "BACKDROP",
        "BossHealthPortrait",
        state["血条Frame"],
        "UI_BACKDROP_5",
        0
    )
    local portraitPath = _____53D6Boss_5934_50CF_8DEF_5F84(state)
    DzFrameSetTexture(state["头像Frame"], portraitPath, 0)
    debugLogForce(
        ____Boss_8840_6761_5934_50CF_8C03_8BD5_6A21_5757_540D,
        "创建头像Frame",
        "boss=",
        state["Boss句柄ID"],
        "frame=",
        state["头像Frame"],
        "override=",
        state["头像覆盖贴图路径"] == "" and "<无>" or state["头像覆盖贴图路径"],
        "finalPath=",
        portraitPath == "" and "<空>" or portraitPath
    )
    DzFrameSetPoint(
        state["头像Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点右下"],
        state["血条Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点左下"],
        isGuard and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["头像偏移X"] or ____Boss_8840_6761UI_5E38_91CF["头像偏移X"],
        isGuard and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["头像偏移Y"] or ____Boss_8840_6761UI_5E38_91CF["头像偏移Y"]
    )
    DzFrameSetSize(state["头像Frame"], isGuard and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["头像宽"] or ____Boss_8840_6761UI_5E38_91CF["头像宽"], isGuard and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["头像高"] or ____Boss_8840_6761UI_5E38_91CF["头像高"])
    state["血量文本Frame"] = DzCreateFrameByTagName(
        "TEXT",
        "BossHealthText",
        gameUI,
        "UI_TEXT_10",
        0
    )
    DzFrameSetAbsolutePoint(
        state["血量文本Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        isGuard and _____8BA1_7B97Boss_62A4_76FE_6846X(state) or ____Boss_8840_6761UI_5E38_91CF["血量文本X"],
        ____Boss_8840_6761UI_5E38_91CF["血量文本Y"]
    )
    if isGuard then
        DzFrameSetScale(state["血量文本Frame"], ____Boss_62A4_536B_8840_6761UI_5E38_91CF["血量文本缩放"])
    end
    if state["是否启用机制UI"] then
        state["护盾框Frame"] = DzCreateFrameByTagName(
            "BACKDROP",
            "BossShieldBarBg",
            state["血条Frame"],
            "template",
            0
        )
        DzFrameSetAlpha(state["护盾框Frame"], ____Boss_8840_6761UI_5E38_91CF["护盾框透明度"])
        DzFrameSetTexture(state["护盾框Frame"], ____Boss_8840_6761UI_5E38_91CF["护盾底图"], 0)
        DzFrameSetAbsolutePoint(
            state["护盾框Frame"],
            ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
            _____8BA1_7B97Boss_62A4_76FE_6846X(state),
            ____Boss_8840_6761UI_5E38_91CF["护盾框Y"]
        )
        DzFrameSetSize(state["护盾框Frame"], isGuard and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护盾框宽"] or ____Boss_8840_6761UI_5E38_91CF["护盾框宽"], isGuard and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护盾框高"] or ____Boss_8840_6761UI_5E38_91CF["护盾框高"])
        state["护盾填充Frame"] = DzCreateFrameByTagName(
            "BACKDROP",
            "BossShieldBarFill",
            state["护盾框Frame"],
            "template",
            0
        )
        DzFrameSetTexture(state["护盾填充Frame"], ____Boss_8840_6761UI_5E38_91CF["护盾填充图"], 0)
        DzFrameSetAbsolutePoint(
            state["护盾填充Frame"],
            ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
            _____8BA1_7B97Boss_62A4_76FE_586B_5145_57FA_7840X(state),
            _____8BA1_7B97Boss_62A4_76FE_586B_5145Y(state, 0)
        )
        DzFrameSetSize(state["护盾填充Frame"], isGuard and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护盾填充显示宽"] or ____Boss_8840_6761UI_5E38_91CF["护盾填充显示宽"], isGuard and ____Boss_62A4_536B_8840_6761UI_5E38_91CF["护盾填充高"] or ____Boss_8840_6761UI_5E38_91CF["护盾填充高"])
    end
    _____663E_793A_8840_6761_5E27_7EC4(state, true)
end
____exports["注册Boss血条UI"] = function(state)
    if state["是否已结束"] or state["是否血条已注册"] then
        return
    end
    _____521B_5EFABoss_8840_6761_5E27_7EC4(state)
    state["是否血条已注册"] = true
    ____exports["重新排列Boss血条槽位"]()
    _____5237_65B0Boss_8840_6761UI(state)
    _____786E_4FDDBoss_8840_6761_5237_65B0()
end
____exports["更新Boss血条头像贴图"] = function(state, _____5934_50CF_8D34_56FE_8DEF_5F84)
    if state["是否已结束"] then
        return false
    end
    state["头像覆盖贴图路径"] = _____5934_50CF_8D34_56FE_8DEF_5F84
    if state["头像Frame"] ~= 0 then
        local portraitPath = _____53D6Boss_5934_50CF_8DEF_5F84(state)
        DzFrameSetTexture(state["头像Frame"], portraitPath, 0)
        debugLogForce(
            ____Boss_8840_6761_5934_50CF_8C03_8BD5_6A21_5757_540D,
            "更新头像贴图",
            "boss=",
            state["Boss句柄ID"],
            "frame=",
            state["头像Frame"],
            "finalPath=",
            portraitPath == "" and "<空>" or portraitPath
        )
    end
    return true
end
____exports["注销Boss血条UI"] = function(state)
    if not state["是否血条已注册"] then
        return
    end
    _____9500_6BC1_5E27(state["护盾填充Frame"])
    _____9500_6BC1_5E27(state["护盾框Frame"])
    _____9500_6BC1_5E27(state["血量文本Frame"])
    _____9500_6BC1_5E27(state["头像Frame"])
    _____9500_6BC1_5E27(state["损失血条Frame"])
    _____9500_6BC1_5E27(state["血条Frame"])
    state["护盾填充Frame"] = 0
    state["护盾框Frame"] = 0
    state["血量文本Frame"] = 0
    state["头像Frame"] = 0
    state["损失血条Frame"] = 0
    state["血条Frame"] = 0
    state["是否血条已注册"] = false
    state["血条槽位索引"] = -1
    ____exports["重新排列Boss血条槽位"]()
    _____505C_6B62Boss_8840_6761_5237_65B0_5982_679C_7A7A_95F2()
end
return ____exports
