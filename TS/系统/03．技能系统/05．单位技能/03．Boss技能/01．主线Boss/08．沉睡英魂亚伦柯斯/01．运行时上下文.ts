/** @noSelfInFile */

export type 亚伦柯斯阶段 = '未启动' | 'P1守墓者苏醒' | 'P2旧誓回响' | 'P3最后的誓约' | '战败归静' | '已结束';

/**
 * 亚伦柯斯的运行时占位结构。
 * 当前没有上下文工厂、死亡监听或周期推进注册，导入本模块不会启动 Boss 逻辑。
 */
export interface 亚伦柯斯运行时上下文 {
  Boss单位: any;
  阶段: 亚伦柯斯阶段;
  已安魂墓碑数量: number;
  未安魂墓碑数量: number;
  当前大型技能占用: boolean;
  已触发最终强化: boolean;
  已初始化: boolean;
}

export function 创建亚伦柯斯运行时上下文(this: void, boss: any): 亚伦柯斯运行时上下文 {
  return {
    Boss单位: boss,
    阶段: '未启动',
    已安魂墓碑数量: 0,
    未安魂墓碑数量: 0,
    当前大型技能占用: false,
    已触发最终强化: false,
    已初始化: false,
  };
}
