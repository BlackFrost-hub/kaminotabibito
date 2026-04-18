--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 是否启用UI属性系统
____exports.UI_ATTRIBUTE_SYSTEM_ENABLED = true
--- 系统初始化延迟时间（秒），游戏开始后多久启动UI
____exports.INIT_DELAY_SECONDS = 0.5
--- UI刷新间隔（秒），越小刷新越频繁但性能消耗越大
____exports.REFRESH_INTERVAL_SECONDS = 0.5
--- 最大显示玩家数量（显示前5个玩家）
____exports.MAX_DISPLAY_PLAYERS = 5
--- 面板背景纹理路径
____exports.PANEL_TEXTURE = "UI\\wenbenkuang.blp"
--- 界面锚点类型：左下角 = 4
____exports.ABSOLUTE_POINT_BOTTOMLEFT = 4
--- 鼠标进入事件ID
____exports.FRAME_EVENT_MOUSE_ENTER = 2
--- 鼠标离开事件ID
____exports.FRAME_EVENT_MOUSE_LEAVE = 3
--- Tab键的键码
____exports.KEY_TAB = 9
--- 按键按下状态
____exports.KEY_EVENT_DOWN = 1
--- 按键抬起状态
____exports.KEY_EVENT_UP = 0
--- F2-F6功能键的键码（用于跳转到对应玩家英雄）
____exports.KEY_F = {
    113,
    114,
    115,
    116,
    117
}
--- 伤害统计的三列标题
____exports.DAMAGE_LABELS = {"对Boss伤害", "承受Boss伤害", "治疗队友"}
--- 伤害统计三列的颜色代码
____exports.DAMAGE_COLORS = {"|cffff6600", "|cffffcc99", "|cffffffcc"}
--- 伤害面板X坐标（屏幕左下角为原点，向右为X正方向）
____exports.DAMAGE_PANEL_X = 0.6775
--- 伤害面板Y坐标（屏幕左下角为原点，向上为Y正方向）
____exports.DAMAGE_PANEL_Y = 0.3311028
--- 伤害面板宽度
____exports.DAMAGE_PANEL_WIDTH = 0.2308336
--- 伤害面板高度
____exports.DAMAGE_PANEL_HEIGHT = 0.19
--- 伤害面板透明度（0-255，越大越不透明）
____exports.DAMAGE_PANEL_ALPHA = 210
--- 伤害面板标题行Y坐标
____exports.DAMAGE_TITLE_Y = 0.4091424
--- 玩家头像X坐标
____exports.DAMAGE_ICON_X = 0.574792
--- 玩家头像起始Y坐标
____exports.DAMAGE_ICON_Y = 0.382
--- 玩家头像宽度
____exports.DAMAGE_ICON_WIDTH = 0.0187504
--- 玩家头像高度
____exports.DAMAGE_ICON_HEIGHT = 0.026013
--- 每行数据之间的垂直间距
____exports.DAMAGE_ROW_STEP = 0.028275
--- 三列数值的X坐标位置
____exports.DAMAGE_VALUE_X = {0.62, 0.68, 0.74}
--- 第一个英雄头像的X坐标
____exports.HERO_ICON_START_X = 0.064
--- 英雄头像之间的水平间距
____exports.HERO_ICON_STEP_X = 0.027
--- 英雄头像Y坐标
____exports.HERO_ICON_Y = 0.560415
--- 英雄头像宽度
____exports.HERO_ICON_WIDTH = 0.023
--- 英雄头像高度
____exports.HERO_ICON_HEIGHT = 0.023
--- 快捷键提示（F2-F6）的Y坐标
____exports.HERO_KEY_Y = 0.540415
--- 英雄头像按钮的点击区域大小
____exports.HERO_BUTTON_SIZE = 0.035
--- 属性详情框X坐标
____exports.DETAIL_BOX_X = 0.15
--- 属性详情框Y坐标
____exports.DETAIL_BOX_Y = 0.34
--- 属性详情框宽度
____exports.DETAIL_BOX_WIDTH = 0.29
--- 属性详情框高度
____exports.DETAIL_BOX_HEIGHT = 0.36
--- 属性行宽度
____exports.DETAIL_LINE_WIDTH = 0.082
--- 属性行高度
____exports.DETAIL_LINE_HEIGHT = 0.0186618
--- 属性详情字体大小
____exports.DETAIL_FONT_SIZE = 0.0125
--- 分隔符字体大小（比普通文本大，要连接成线）
____exports.DETAIL_SEPARATOR_FONT_SIZE = 0.032
--- 第一行属性的起始Y坐标（相对于box的相对坐标）
____exports.DETAIL_START_Y = 0.162
--- 每行属性之间的垂直间距
____exports.DETAIL_ROW_STEP = 0.0145
--- 左列属性的X坐标（相对于box的相对坐标）
____exports.DETAIL_LEFT_X = -0.097
--- 中列属性的X坐标（相对于box的相对坐标）
____exports.DETAIL_MID_X = -0.004
--- 右列属性的X坐标（相对于box的相对坐标）
____exports.DETAIL_RIGHT_X = 0.089
--- 列间距（左列与中列之间的距离）
____exports.DETAIL_COL_SPACING = 0.093
--- 左中分隔符的X坐标（相对于box的相对坐标）
____exports.DETAIL_SEP1_X = -0.022
--- 中右分隔符的X坐标（相对于box的相对坐标）
____exports.DETAIL_SEP2_X = 0.071
--- 分隔符线的宽度
____exports.DETAIL_SEPARATOR_WIDTH = 0.0022
--- 分隔符线的高度倍数（相对于行高）
____exports.DETAIL_SEPARATOR_HEIGHT_MULT = 1.05
--- 分隔符Y坐标偏移量（用于对齐文本）
____exports.DETAIL_SEPARATOR_Y_OFFSET = 0.13
--- 分隔符X坐标偏移量（用于调整水平位置）
____exports.DETAIL_SEPARATOR_X_OFFSET = -0.036
--- 分隔符起始行（从第几行开始显示）
____exports.DETAIL_SEP_START_ROW = 3
--- 分隔符结束行（到第几行结束）
____exports.DETAIL_SEP_END_ROW = 21
--- 属性详情面板的行布局配置
-- 五列并排：
-- - 左列：基础属性
-- - 分隔符1：|
-- - 中列：输出属性
-- - 分隔符2：|
-- - 右列：生存与特殊
-- 共22行，前3行为分隔线+标题+分隔线，后19行为属性内容
-- 格式：{ x: 水平位置, y: 垂直位置 }
____exports.DETAIL_LINE_LAYOUTS = {
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 0},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 0},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 0},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 0},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 0},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 1},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 1},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 1},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 1},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 1},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 2},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 2},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 2},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 2},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 2},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 3},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 3},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 3},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 3},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 3},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 4},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 4},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 4},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 4},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 4},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 5},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 5},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 5},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 5},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 5},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 6},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 6},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 6},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 6},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 6},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 7},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 7},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 7},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 7},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 7},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 8},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 8},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 8},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 8},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 8},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 9},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 9},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 9},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 9},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 9},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 10},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 10},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 10},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 10},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 10},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 11},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 11},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 11},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 11},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 11},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 12},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 12},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 12},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 12},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 12},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 13},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 13},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 13},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 13},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 13},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 14},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 14},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 14},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 14},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 14},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 15},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 15},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 15},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 15},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 15},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 16},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 16},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 16},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 16},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 16},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 17},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 17},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 17},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 17},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 17},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 18},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 18},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 18},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 18},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 18},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 19},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 19},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 19},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 19},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 19},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 20},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 20},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 20},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 20},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 20},
    {x = ____exports.DETAIL_LEFT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 21},
    {x = ____exports.DETAIL_SEP1_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 21},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 21},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 21},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 21},
    {x = ____exports.DETAIL_MID_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 22},
    {x = ____exports.DETAIL_SEP2_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 22},
    {x = ____exports.DETAIL_RIGHT_X, y = ____exports.DETAIL_START_Y - ____exports.DETAIL_ROW_STEP * 22}
}
return ____exports
