--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 系统启用开关，true启用，false禁用
____exports.CAST_BAR_ENABLED = true
--- 吟唱条更新间隔（秒）
____exports.UPDATE_INTERVAL = 0.02
--- 吟唱条X坐标（屏幕比例 0-1）
____exports.BAR_POS_X = 0.549
--- 吟唱条Y坐标（屏幕比例 0-1）
____exports.BAR_POS_Y = 0.2
--- 文本偏移X
____exports.TEXT_OFFSET_X = -0.148
--- 文本偏移Y
____exports.TEXT_OFFSET_Y = 0.02
--- 进度文本偏移X
____exports.PROGRESS_OFFSET_X = -0.162
--- 进度文本偏移Y
____exports.PROGRESS_OFFSET_Y = 0.005
--- 中间符号偏移X
____exports.SYMBOL_OFFSET_X = -0.15
--- 倒计时偏移X
____exports.COUNTDOWN_OFFSET_X = -0.138
--- 提示文本偏移X
____exports.TIP_OFFSET_X = -0.12
--- 颜色ID枚举
____exports.COLOR_ID = {
    GREEN = 1,
    BLUE = 2,
    ORANGE = 3,
    RED = 4,
    PURPLE = 5,
    GOLD = 6,
    BROWN = 7
}
--- 默认颜色ID
____exports.DEFAULT_COLOR_ID = ____exports.COLOR_ID.GREEN
--- 前景模型路径映射
____exports.FOREGROUND_MODELS = {
    [____exports.COLOR_ID.GREEN] = "war3mapImported\\UI_shengmingzhi_gb2.mdx",
    [____exports.COLOR_ID.BLUE] = "war3mapImported\\UI_shengmingzhi_t1.mdx",
    [____exports.COLOR_ID.ORANGE] = "war3mapImported\\UI_shengmingzhi_o2.mdx",
    [____exports.COLOR_ID.RED] = "war3mapImported\\UI_shengmingzhi_r2.mdx",
    [____exports.COLOR_ID.PURPLE] = "war3mapImported\\UI_shengmingzhi_p2.mdx",
    [____exports.COLOR_ID.GOLD] = "war3mapImported\\UI_shengmingzhi_g2.mdx",
    [____exports.COLOR_ID.BROWN] = "war3mapImported\\UI_shengmingzhi_b2.mdx"
}
--- 背景模型路径映射
____exports.BACKGROUND_MODELS = {
    [____exports.COLOR_ID.GREEN] = "war3mapImported\\UI_shengmingzhi-beijing_gb2.mdx",
    [____exports.COLOR_ID.BLUE] = "war3mapImported\\UI_shengmingzhi-beijing_t1.mdx",
    [____exports.COLOR_ID.ORANGE] = "war3mapImported\\UI_shengmingzhi-beijing_o2.mdx",
    [____exports.COLOR_ID.RED] = "war3mapImported\\UI_shengmingzhi-beijing_r2.mdx",
    [____exports.COLOR_ID.PURPLE] = "war3mapImported\\UI_shengmingzhi-beijing_p2.mdx",
    [____exports.COLOR_ID.GOLD] = "war3mapImported\\UI_shengmingzhi-beijing_g2.mdx",
    [____exports.COLOR_ID.BROWN] = "war3mapImported\\UI_shengmingzhi-beijing_b2.mdx"
}
--- 默认吟唱文本
____exports.DEFAULT_CAST_TEXT = "吟唱中"
--- 默认提示文本
____exports.DEFAULT_TIP_TEXT = "场地技能："
--- 注册吟唱条事件名
____exports.EVENT_NAME_CAST_BAR = "注册吟唱条"
--- YDLocal变量名常量
____exports.YDLOCAL_KEYS = {
    COLOR_ID = "颜色ID",
    TOTAL_TIME = "sj",
    ELAPSED_TIME = "s",
    PROGRESS = "ss",
    CUSTOM_STRING = "string",
    FRAME_FOREGROUND = "前景",
    FRAME_BACKGROUND = "背景",
    FRAME_TEXT = "显示文本",
    FRAME_PROGRESS = "进度",
    FRAME_SYMBOL = "中间符号",
    FRAME_COUNTDOWN = "倒计时",
    FRAME_TIP = "文本提示"
}
return ____exports
