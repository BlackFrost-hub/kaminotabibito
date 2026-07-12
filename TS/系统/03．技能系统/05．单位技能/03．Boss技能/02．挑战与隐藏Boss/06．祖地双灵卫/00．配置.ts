/** @noSelfInFile */

export type 祖地双灵卫名称 = '赤誓灵卫' | '苍影灵卫';

export const 祖地双灵卫单位技能配置 = {
  BossKey: 'AncestralTwinSpiritGuards',
  战斗名称: '祖地双灵卫',
  单位: {
    赤誓灵卫: {
      BossKey: 'AncestralRedOathGuard',
      正常名称: '赤誓灵卫',
      变异名称: '裂誓战躯',
      单位ID: '',
      正常模型路径: '',
      变异模型路径: '',
    },
    苍影灵卫: {
      BossKey: 'AncestralAzureShadeGuard',
      正常名称: '苍影灵卫',
      变异名称: '无面祷影',
      单位ID: '',
      正常模型路径: '',
      变异模型路径: '',
    },
  },
  阶段阈值: {
    首次变异生命比例: 0.65,
    混合阶段第二守卫最低生命比例: 0.55,
    灵魂崩解生命比例: 0.05,
    默认同步崩解窗口秒: 14,
    完成净化后同步崩解窗口秒: 18,
  },
  正式场地: {
    中心X: 0,
    中心Y: 0,
    可用半宽: 0,
    可用半高: 0,
    净化节点: [] as Array<{ X: number; Y: number }>,
  },
  当前状态: {
    设计已确认: true,
    目录结构已建立: true,
    单位数据已填写: false,
    表现资源已填写: false,
    技能已实现: false,
    战斗已注册: false,
  },
} as const;
