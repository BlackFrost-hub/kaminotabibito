const japi = require("jass.japi");
/**
 * 初始化原生UI - 隐藏顶部菜单按钮图标
 *
 * 原理：
 * 1. 创建一个极小的透明背景框（BACKDROP）作为锚点
 * 2. 获取顶部按钮栏的第一个按钮（"任务(J)"）
 * 3. 将按钮的大小设置为极小（1/2400 x 1/1800，几乎看不见）
 * 4. 把按钮的位置锚定到透明背景框上
 * 5. 给透明背景框设置透明图片，从而实现隐藏效果
 *
 * 注意：按钮文字已经在地图编辑器的【高级-游戏界面】中改成空格了
 */
export function initNativeUI() {
    const backdrop = japi.DzCreateFrameByTagName("BACKDROP", "name", japi.DzGetGameUI(), "template", 0);
    japi.DzFrameSetSize(backdrop, 1.00 / 2400.00, 1.00 / 1800.00);
    japi.DzFrameSetPoint(backdrop, 0, japi.DzGetGameUI(), 0, 205.50 / 2400.00, -19.30 / 1800.00);
    const button = japi.DzFrameGetUpperButtonBarButton(0);
    japi.DzFrameClearAllPoints(button);
    japi.DzFrameSetSize(button, 1.00 / 2400.00, 1.00 / 1800.00);
    japi.DzFrameSetPoint(button, 4, backdrop, 4, 0.00, 0.00);
    japi.DzFrameSetTexture(backdrop, "UI\\toumingtietu.tga", 0);
}
