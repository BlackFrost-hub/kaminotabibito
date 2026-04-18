--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 最小伤害阈值（低于此值不显示）
____exports.MIN_DAMAGE_THRESHOLD = 1.1
--- 数字图片路径模板（0-9）
____exports.DIGIT_IMAGE_PATH_TEMPLATE = "war3mapImported\\z{digit}-6.blp"
--- 数字图片基础大小
____exports.DIGIT_BASE_SIZE = 75
--- 数字间距
____exports.DIGIT_SPACING = 25
--- 初始偏移量基数
____exports.INITIAL_OFFSET_BASE = 27.5
--- 显示持续时间（tick数，每tick=0.04秒）
____exports.DISPLAY_DURATION_TICKS = 30
--- 更新间隔（秒）
____exports.UPDATE_INTERVAL = 0.04
--- 上升速度（每tick上升的高度）
____exports.RISE_SPEED = 20
--- 基础高度
____exports.BASE_HEIGHT = 300
--- 伤害类型颜色配置
____exports.DAMAGE_TYPE_COLORS = {
    MIND = {red = 255, green = 255, blue = 255},
    NORMAL = {red = 160, green = 82, blue = 45},
    ENHANCED = {red = 255, green = 140, blue = 0},
    FIRE = {red = 255, green = 0, blue = 0},
    COLD = {red = 0, green = 191, blue = 255},
    POISON = {red = 255, green = 215, blue = 0},
    PLANT = {red = 124, green = 252, blue = 0},
    SHADOW = {red = 128, green = 0, blue = 128},
    MAGIC = {red = 0, green = 0, blue = 255},
    LIGHTNING = {red = 220, green = 255, blue = 255},
    DIVINE = {red = 255, green = 215, blue = 0},
    DEMOLITION = {red = 210, green = 105, blue = 30}
}
--- 默认颜色（白色）
____exports.DEFAULT_COLOR = {red = 255, green = 255, blue = 255}
return ____exports
