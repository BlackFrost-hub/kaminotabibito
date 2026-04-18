local ____lualib = require("lualib_bundle")
local __TS__StringReplace = ____lualib.__TS__StringReplace
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__StringAccess = ____lualib.__TS__StringAccess
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ensureRegisteredToCenterTimer, jass, DISPLAY_DURATION_TICKS, RISE_SPEED, activeDigits, _registeredToCenterTimer, _tickCounter, CENTER_TIMER_TICKS
--- 更新所有伤害数字（由中心计时器调用）
function ____exports.updateAllDamageDigits()
    do
        local i = #activeDigits - 1
        while i >= 0 do
            do
                local data = activeDigits[i + 1]
                data.tick = data.tick + 1
                if data.tick >= DISPLAY_DURATION_TICKS then
                    local ____opt_23 = jass.DestroyImage
                    if ____opt_23 ~= nil then
                        ____opt_23(jass, data.image)
                    end
                    __TS__ArraySplice(activeDigits, i, 1)
                    goto __continue40
                end
                local newHeight = RISE_SPEED * data.tick
                local ____opt_25 = jass.SetImagePosition
                if ____opt_25 ~= nil then
                    ____opt_25(
                        jass,
                        data.image,
                        data.x,
                        data.y,
                        newHeight
                    )
                end
            end
            ::__continue40::
            i = i - 1
        end
    end
end
--- 检查是否有活跃的伤害数字
function ____exports.hasActiveDigits()
    return #activeDigits > 0
end
function ensureRegisteredToCenterTimer()
    if _registeredToCenterTimer then
        return
    end
    _registeredToCenterTimer = true
    local ____require_result_27 = require("系统.00．核心系统.05．中心计时器")
    local onTick10ms = ____require_result_27.onTick10ms
    onTick10ms(
        nil,
        function()
            if not ____exports.hasActiveDigits() then
                return
            end
            _tickCounter = _tickCounter + 1
            if _tickCounter >= CENTER_TIMER_TICKS then
                _tickCounter = 0
                ____exports.updateAllDamageDigits()
            end
        end
    )
end
jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.04．伤害显示.00．常量定义")
local MIN_DAMAGE_THRESHOLD = ____require_result_0.MIN_DAMAGE_THRESHOLD
local DIGIT_IMAGE_PATH_TEMPLATE = ____require_result_0.DIGIT_IMAGE_PATH_TEMPLATE
local DIGIT_BASE_SIZE = ____require_result_0.DIGIT_BASE_SIZE
local DIGIT_SPACING = ____require_result_0.DIGIT_SPACING
local INITIAL_OFFSET_BASE = ____require_result_0.INITIAL_OFFSET_BASE
DISPLAY_DURATION_TICKS = ____require_result_0.DISPLAY_DURATION_TICKS
local UPDATE_INTERVAL = ____require_result_0.UPDATE_INTERVAL
RISE_SPEED = ____require_result_0.RISE_SPEED
local BASE_HEIGHT = ____require_result_0.BASE_HEIGHT
local DAMAGE_TYPE_COLORS = ____require_result_0.DAMAGE_TYPE_COLORS
local DEFAULT_COLOR = ____require_result_0.DEFAULT_COLOR
local ____require_result_1 = require("lib.扩展函数.YDWE函数.index")
local getObjectProperty = ____require_result_1.getObjectProperty
local _____4F24_5BB3_51FD_6570 = require("lib.扩展函数.封装函数.06．伤害函数.index")
activeDigits = {}
--- 数字图片路径缓存（0-9）
local digitImagePaths = {}
--- 初始化数字图片路径
local function initDigitImagePaths()
    if #digitImagePaths > 0 then
        return
    end
    do
        local i = 0
        while i <= 9 do
            digitImagePaths[i + 1] = __TS__StringReplace(
                DIGIT_IMAGE_PATH_TEMPLATE,
                "{digit}",
                tostring(i)
            )
            i = i + 1
        end
    end
end
--- 获取数字图片路径
local function getDigitImagePath(digit)
    initDigitImagePaths()
    return digitImagePaths[digit + 1] or digitImagePaths[1]
end
--- 获取单位模型缩放
local function getUnitModelScale(unit)
    if not unit then
        return 1
    end
    local ____opt_2 = jass.GetUnitTypeId
    if ____opt_2 ~= nil then
        ____opt_2 = ____opt_2(jass, unit)
    end
    local unitType = ____opt_2
    if not unitType then
        return 1
    end
    local scaleStr = getObjectProperty(nil, 2, unitType, "modelScale")
    local scale = __TS__ParseFloat(scaleStr)
    return __TS__NumberIsNaN(__TS__Number(scale)) and 1 or scale
end
--- 计算数字位数
local function getDigitCount(value)
    if value < 10 then
        return 1
    end
    if value < 100 then
        return 2
    end
    if value < 1000 then
        return 3
    end
    if value < 10000 then
        return 4
    end
    if value < 100000 then
        return 5
    end
    if value < 1000000 then
        return 6
    end
    if value < 10000000 then
        return 7
    end
    if value < 100000000 then
        return 8
    end
    if value < 1000000000 then
        return 9
    end
    return 10
end
--- 获取伤害类型对应的颜色
local function getDamageTypeColor()
    if _____4F24_5BB3_51FD_6570.isFireDamage() then
        return DAMAGE_TYPE_COLORS.FIRE
    end
    if _____4F24_5BB3_51FD_6570.isWaterDamage() then
        return DAMAGE_TYPE_COLORS.COLD
    end
    if _____4F24_5BB3_51FD_6570.isThunderDamage() then
        return DAMAGE_TYPE_COLORS.LIGHTNING
    end
    if _____4F24_5BB3_51FD_6570.isMetalDamage() then
        return DAMAGE_TYPE_COLORS.POISON
    end
    if _____4F24_5BB3_51FD_6570.isLightDamage() then
        return DAMAGE_TYPE_COLORS.DIVINE
    end
    if _____4F24_5BB3_51FD_6570.isDarkDamage() then
        return DAMAGE_TYPE_COLORS.SHADOW
    end
    if _____4F24_5BB3_51FD_6570.isWoodDamage() then
        return DAMAGE_TYPE_COLORS.PLANT
    end
    if _____4F24_5BB3_51FD_6570.isPhysicalDamage() then
        return DAMAGE_TYPE_COLORS.NORMAL
    end
    if _____4F24_5BB3_51FD_6570.isMagicDamage() then
        return DAMAGE_TYPE_COLORS.MAGIC
    end
    if _____4F24_5BB3_51FD_6570.isEnhancedDamage() then
        return DAMAGE_TYPE_COLORS.ENHANCED
    end
    return DEFAULT_COLOR
end
--- 创建单个数字图片
local function createDigitImage(digit, x, y, modelScale, color, unitFlyHeight)
    local imagePath = getDigitImagePath(digit)
    local size = DIGIT_BASE_SIZE * modelScale
    local ____opt_4 = jass.CreateImage
    if ____opt_4 ~= nil then
        ____opt_4 = ____opt_4(
            jass,
            imagePath,
            size,
            size,
            size,
            x,
            y,
            5,
            0,
            0,
            0,
            2
        )
    end
    local image = ____opt_4
    if not image then
        return nil
    end
    local ____opt_6 = jass.SetImageColor
    if ____opt_6 ~= nil then
        ____opt_6(
            jass,
            image,
            color.red,
            color.green,
            color.blue,
            255
        )
    end
    local height = (BASE_HEIGHT + unitFlyHeight) * modelScale
    local ____opt_8 = jass.SetImageConstantHeight
    if ____opt_8 ~= nil then
        ____opt_8(jass, image, true, height)
    end
    local ____opt_10 = jass.SetImageRenderAlways
    if ____opt_10 ~= nil then
        ____opt_10(jass, image, true)
    end
    local ____opt_12 = jass.SetImageType
    if ____opt_12 ~= nil then
        ____opt_12(jass, image, 5)
    end
    return image
end
--- 显示伤害数字
-- 
-- @param target 目标单位
-- @param damage 伤害值
function ____exports.showDamageNumber(target, damage)
    if not target or damage < MIN_DAMAGE_THRESHOLD then
        return
    end
    local damageInt = math.floor(damage)
    local damageStr = tostring(damageInt)
    local digitCount = getDigitCount(damageInt)
    local ____opt_14 = jass.GetUnitX
    if ____opt_14 ~= nil then
        ____opt_14 = ____opt_14(jass, target)
    end
    local ____opt_14_16 = ____opt_14
    if ____opt_14_16 == nil then
        ____opt_14_16 = 0
    end
    local x = ____opt_14_16
    local ____opt_17 = jass.GetUnitY
    if ____opt_17 ~= nil then
        ____opt_17 = ____opt_17(jass, target)
    end
    local ____opt_17_19 = ____opt_17
    if ____opt_17_19 == nil then
        ____opt_17_19 = 0
    end
    local y = ____opt_17_19
    local ____opt_20 = jass.GetUnitFlyHeight
    if ____opt_20 ~= nil then
        ____opt_20 = ____opt_20(jass, target)
    end
    local ____opt_20_22 = ____opt_20
    if ____opt_20_22 == nil then
        ____opt_20_22 = 0
    end
    local flyHeight = ____opt_20_22
    local modelScale = getUnitModelScale(target)
    local color = getDamageTypeColor()
    local offsetX = -INITIAL_OFFSET_BASE * digitCount
    do
        local i = 0
        while i < digitCount do
            local digit = __TS__ParseInt(
                __TS__StringAccess(damageStr, i),
                10
            )
            offsetX = offsetX + DIGIT_SPACING
            local image = createDigitImage(
                digit,
                x + offsetX,
                y,
                modelScale,
                color,
                flyHeight
            )
            if image then
                activeDigits[#activeDigits + 1] = {image = image, x = x + offsetX, y = y, tick = 0}
            end
            i = i + 1
        end
    end
    ensureRegisteredToCenterTimer()
end
_registeredToCenterTimer = false
_tickCounter = 0
CENTER_TIMER_TICKS = math.ceil(UPDATE_INTERVAL / 0.01)
return ____exports
