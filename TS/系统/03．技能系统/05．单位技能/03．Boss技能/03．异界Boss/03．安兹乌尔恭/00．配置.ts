/** @noSelfInFile */

export const 安兹乌尔恭单位技能配置 = {
  BossKey: 'AinzOoalGown',
  单位名称: '安兹·乌尔·恭',
  正式单位ID: '',
  旧候选单位ID: 'E005',
  模型路径: '',
  护卫: {
    BossKey: 'AlbedoGuardian',
    单位名称: '雅儿贝德',
    正式单位ID: '',
    模型路径: '',
  },
  阶段阈值: {
    P2生命比例: 0.7,
    P3生命比例: 0.35,
  },
  挑战模式: ['至尊的试炼', '守护者介入'] as const,
  当前状态: {
    目录结构已建立: true,
    单位数据已确认: false,
    技能已实现: false,
    守护者模式已实现: false,
    战斗已注册: false,
  },
} as const;
