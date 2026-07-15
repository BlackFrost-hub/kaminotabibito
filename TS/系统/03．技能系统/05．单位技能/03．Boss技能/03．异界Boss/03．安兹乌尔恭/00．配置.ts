/** @noSelfInFile */

export const 安兹乌尔恭单位技能配置 = {
  BossKey: 'AinzOoalGown',
  单位名称: '安兹·乌尔·恭',
  正式单位ID: 'U007',
  旧候选单位ID: 'E005',
  模型路径: 'Boss\\AinzOoalGown\\AinzOoalGown.mdx',
  普通攻击: {
    射程: 1200,
    弹道速度: 1400,
    弹道模型: 'Boss\\AinzOoalGown\\Projectile\\AinzMagicMissile.mdx',
  },
  技能壳: {
    现实断裂: 'AT08',
    心脏掌握: 'BT08',
    高阶魔法箭: 'CT08',
    光辉翠绿体: 'AN00',
  },
  主动技能提示: [
    { 技能ID: 'AT08', 提示: '现实断裂', 扩展提示: '预警一条狭长空间切面，短暂延迟后沿固定方向爆发。' },
    { 技能ID: 'BT08', 提示: '心脏掌握', 扩展提示: '点名一名玩家并施加暗红心脏倒计时。' },
    { 技能ID: 'CT08', 提示: '高阶魔法箭', 扩展提示: '向当前目标连续发射高阶亡灵魔法箭。' },
    { 技能ID: 'AN00', 提示: '光辉翠绿体', 扩展提示: '短暂覆盖翠绿色防御层，抵消一次直接物理攻击。' },
  ] as Array<{ 技能ID: string; 提示: string; 扩展提示: string }>,
  护卫: {
    BossKey: 'AlbedoGuardian',
    单位名称: '雅儿贝德',
    正式单位ID: 'U008',
    模型路径: 'Boss\\AinzOoalGown\\Albedo.mdx',
  },
  阶段阈值: {
    P2生命比例: 0.7,
    P3生命比例: 0.35,
  },
  挑战模式: ['至尊的试炼', '守护者介入'] as const,
  当前状态: {
    目录结构已建立: true,
    单位数据已确认: true,
    技能已实现: true,
    现实断裂已实现: true,
    心脏掌握已实现: true,
    高阶魔法箭已实现: true,
    光辉翠绿体已实现: true,
    天空坠落已实现: true,
    P2阶段调度已实现: true,
    时间停止已实现: true,
    高阶亡灵召唤已实现: true,
    一切生命的终点已实现: true,
    守护者模式已实现: true,
    基础运行时已实现: true,
    战斗启动上下文已注册: true,
  },
} as const;
