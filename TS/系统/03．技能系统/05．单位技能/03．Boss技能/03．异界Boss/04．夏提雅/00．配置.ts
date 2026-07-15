/** @noSelfInFile */

export const 夏提雅单位技能配置 = {
  BossKey: 'ShalltearBloodfallen',
  单位名称: '夏提雅·布拉德弗伦',
  正式单位ID: 'U009',
  模型路径: 'Boss\\ShalltearBloodfallen\\Shalltear.mdx',
  女武神形态: {
    单位ID: 'U00A',
    模型路径: 'Boss\\ShalltearBloodfallen\\ShalltearValkyrie.mdx',
  },
  阶段阈值: {
    P2生命比例: 0.7,
    P3生命比例: 0.35,
  },
  广播台词: {
    血之复生: '|cffff6688就凭这样，也想让我倒下吗？|r',
    复生失败: '|cffffb3c1……这一次，是你们赢了。|r',
    再次战败: '|cffffb3c1胜负已分。我会记住这场决斗。|r',
  },
  当前状态: {
    目录结构已建立: true,
    单位数据已确认: true,
    普攻核心已实现: true,
    技能已实现: true,
    战斗已注册: true,
  },
} as const;
