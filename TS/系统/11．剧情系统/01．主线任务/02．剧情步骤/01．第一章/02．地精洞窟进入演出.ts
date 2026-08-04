import type { 剧情片段配置, 紧凑剧情片段配置 } from "../00．剧情步骤类型";
import { 编译紧凑剧情片段 } from "../../00．剧情系统核心工具/05．紧凑剧情片段编译";

export const 地精洞窟演出紧凑剧情片段: 紧凑剧情片段配置 = {
  片段ID: "jlc_goblin_cave_intro",
  名称: "地精洞窟演出",
  触发条件: "剧情进度 == 1 且玩家进入地精洞窟区域",
  可Esc整段跳过: true,
  默认倍速: 1,
  默认对白持续时间: 3,
  对白列表: [
    { 序号: 1, 说话者: "系统", 文本: "地精洞窟深处幽暗无光，祭坛周围弥散着令人不安的魔力。", 持续时间: 5, 使用原生电影系统: true },
    { 序号: 2, 说话者: "地精祭祀", 说话者引用: "Boss.地精巫师", 文本: "精灵的鲜血……果然能让祭火燃烧得更加旺盛。", 持续时间: 4.0, 使用原生电影系统: true },
    { 序号: 3, 说话者: "地精祭祀", 说话者引用: "Boss.地精巫师", 文本: "有了这份力量，森林里再没有谁能把地精踩在脚下！", 持续时间: 4.4, 使用原生电影系统: true },
    { 序号: 4, 说话者: "地精祭祀", 说话者引用: "Boss.地精巫师", 文本: "伟大的赐予者啊……我族必会献上您想要的一切。", 持续时间: 4.2, 使用原生电影系统: true },
  ],
  动作时间线: [
    {
      序号: 1, 挂点: "beforeDialog", 对白序号: 1,
      跳过也执行: true,
      动作ID: "JLC精灵村_地精洞窟演出前置", 名称: "进入洞窟后切入地精洞窟演出",
      参数: {
        触发区域: "gg_rct______________020",
        Boss键: "Boss.地精巫师",
        开启电影模式: true,
        玩家英雄组暂停: true,
        玩家英雄组无敌: true,
        时间设为午夜: true,
        黑场滤镜持续时间: 2,
        旧JASS功能清单: "YDLocal1Set(Boss.地精巫师) / SetTimeOfDay / ForGroupBJ / YDUserDataSet(剧情进度=2) / CinematicModeBJ / CinematicFilterGenericBJ",
      },
    },
    {
      序号: 2, 挂点: "beforeDialog", 对白序号: 1,
      跳过也执行: true,
      动作ID: "主线.写入进度", 名称: "进入地精洞窟调查节点",
      参数: { 节点进度: 2 },
    },
    {
      序号: 3, 挂点: "afterDialog", 对白序号: 1,
      跳过也执行: false,
      动作ID: "JLC精灵村_地精洞窟祭坛演出开始", 名称: "关闭黑幕并切入祭坛镜头",
      参数: {
        关闭电影滤镜: true,
        开启区域音乐: "gg_snd_JQBGM01 @ gg_rct______________102",
        视角镜头: "gg_cam___________________005",
        旧JASS功能清单: "DisplayCineFilter(false) / SetStackedSoundBJ(true, gg_snd_JQBGM01, gg_rct______________102) / CreateUnit(演员1-6) / CameraSetupApplyForceDuration",
      },
    },
    {
      序号: 4, 挂点: "afterDialog", 对白序号: 2,
      跳过也执行: false,
      动作ID: "JLC精灵村_地精洞窟演员动作", 名称: "祭祀抬手并献祭前两名精灵",
      参数: { 阶段: 1, 旧JASS功能清单: "SetUnitAnimationByIndex(Boss, 4) / CreateUnit(e00U) / KillUnit(演员5-6)" },
    },
    {
      序号: 5, 挂点: "afterDialog", 对白序号: 3,
      跳过也执行: false,
      动作ID: "JLC精灵村_地精洞窟演员动作", 名称: "两名地精走向祭坛",
      参数: { 阶段: 2, 旧JASS功能清单: "IssuePointOrder(演员1-2, move)" },
    },
    {
      序号: 6, 挂点: "afterDialog", 对白序号: 4,
      跳过也执行: false,
      动作ID: "JLC精灵村_地精洞窟演员动作", 名称: "替换祭坛守卫并播放仪式音效",
      参数: { 阶段: 3, 旧JASS功能清单: "RemoveUnit(演员1-2) / CreateUnit(演员7-8) / DarkRitualTarget / PlaySoundBJ(gg_snd_GWSY0101)" },
    },
    {
      序号: 7, 挂点: "afterDialog", 对白序号: 4,
      跳过也执行: false,
      动作ID: "wait", 名称: "等待祭坛仪式第一段动作完成",
      参数: { 等待秒数: 3 },
    },
    {
      序号: 8, 挂点: "afterDialog", 对白序号: 4,
      跳过也执行: false,
      动作ID: "JLC精灵村_地精洞窟演员动作", 名称: "祭坛四名地精开始吟唱",
      参数: { 阶段: 4, 旧JASS功能清单: "SetUnitAnimationByIndex(演员3/4/7/8, 1) / SetUnitFacing(Boss, 90) / SetUnitAnimationByIndex(Boss, 4)" },
    },
    {
      序号: 9, 挂点: "afterDialog", 对白序号: 4,
      跳过也执行: false,
      动作ID: "wait", 名称: "等待祭坛吟唱第二段",
      参数: { 等待秒数: 3 },
    },
    {
      序号: 10, 挂点: "afterDialog", 对白序号: 4,
      跳过也执行: false,
      动作ID: "JLC精灵村_地精洞窟演员动作", 名称: "再次播放仪式音效并保持吟唱动作",
      参数: { 阶段: 5, 旧JASS功能清单: "PlaySoundBJ(gg_snd_GWSY0101) / SetUnitAnimationByIndex(演员3/4/7/8, 1)" },
    },
    {
      序号: 11, 挂点: "afterDialog", 对白序号: 4,
      跳过也执行: false,
      动作ID: "wait", 名称: "等待源 JASS 的收尾对白",
      参数: { 等待秒数: 3.5 },
    },
    {
      序号: 12, 挂点: "afterDialog", 对白序号: 4,
      跳过也执行: false,
      动作ID: "JLC精灵村_地精洞窟演员动作", 名称: "切入收尾黑幕",
      参数: { 阶段: 6, 旧JASS功能清单: "CinematicFilterGenericBJ(2s)" },
    },
    {
      序号: 13, 挂点: "afterDialog", 对白序号: 4,
      跳过也执行: false,
      动作ID: "wait", 名称: "等待黑幕过渡完成",
      参数: { 等待秒数: 1.5 },
    },
    {
      序号: 14, 挂点: "afterDialog", 对白序号: 4,
      跳过也执行: true,
      动作ID: "主线.发布节点目标", 名称: "发布深入洞窟调查目标",
      参数: { 节点进度: 2 },
    },
    {
      序号: 15, 挂点: "afterDialog", 对白序号: 4,
      跳过也执行: true,
      动作ID: "JLC精灵村_地精洞窟演出收尾", 名称: "洞窟演出结束恢复玩家控制与镜头",
      参数: {
        玩家英雄组恢复控制: true,
        玩家英雄组取消无敌: true,
        镜头恢复方式: "恢复进入电影模式前每个玩家的镜头目标距离与高度偏移",
        旧JASS功能清单: "CinematicModeBJ(false) / ResetToGameCameraForPlayer / PanCameraToTimedLocForPlayer / PauseUnit(false) / SetUnitInvulnerable(false)",
      },
    },
  ],
};



export const 地精洞窟演出剧情片段: 剧情片段配置 = 编译紧凑剧情片段(地精洞窟演出紧凑剧情片段);
