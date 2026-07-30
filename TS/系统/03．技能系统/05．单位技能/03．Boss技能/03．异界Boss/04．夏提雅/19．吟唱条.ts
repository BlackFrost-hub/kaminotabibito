/** @noSelfInFile */

const { 显示常规技能吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
};

export function 显示夏提雅常规吟唱条(this: void, 总时长: number, 颜色ID: number, 标题文本: string, 提示文本: string): void {
  显示常规技能吟唱条({ 总时长, 颜色ID, 标题文本, 提示文本 });
}
