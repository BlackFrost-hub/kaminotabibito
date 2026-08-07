/** @noSelfInFile */

import type { 剧情片段配置, 剧情步骤, 紧凑剧情动作行, 紧凑剧情片段配置 } from "../02．剧情步骤/00．剧情步骤类型";

export function 编译紧凑动作(this: void, 动作: 紧凑剧情动作行): 剧情步骤 {
  if (动作.动作ID === "wait") {
    const 参数 = 动作.参数 ?? {};
    return {
      type: "wait",
      id: 动作.动作ID,
      名称: 动作.名称,
      跳过也执行: 动作.跳过也执行 !== false,
      持续时间: ((参数 as any).等待秒数 as number | undefined) ?? 动作.时间秒 ?? 0,
      允许Esc跳过: true,
      使用原生电影系统: (参数 as any).使用原生电影系统 as boolean | undefined,
    } as 剧情步骤;
  }

  if (动作.动作ID === "startBossFight") {
    const 参数 = 动作.参数 ?? {};
    return {
      type: "startBossFight",
      id: 动作.动作ID,
      名称: 动作.名称,
      跳过也执行: 动作.跳过也执行 !== false,
      Boss引用: (参数 as any).Boss引用 as string | undefined,
      Boss名: (参数 as any).Boss名 as string | undefined,
    } as 剧情步骤;
  }

  return {
    type: "runAction",
    id: 动作.动作ID,
    名称: 动作.名称,
    跳过也执行: 动作.跳过也执行 !== false,
    动作ID: 动作.动作ID,
    参数: {
      挂点: 动作.挂点,
      对白序号: 动作.对白序号 ?? 0,
      时间秒: 动作.时间秒 ?? 0,
      ...(动作.参数 ?? {}),
    },
  };
}

export function 编译紧凑剧情片段(this: void, 配置: 紧凑剧情片段配置): 剧情片段配置 {
  const 步骤列表: 剧情步骤[] = [];
  const 动作时间线 = 配置.动作时间线 ?? [];

  if (配置.对白列表.length === 0) {
    for (let i = 0; i < 动作时间线.length; i++) {
      const 动作 = 动作时间线[i];
      步骤列表.push(编译紧凑动作({
        ...动作,
        挂点: "beforeDialog",
        对白序号: 0,
      }));
    }

    return {
      片段ID: 配置.片段ID,
      名称: 配置.名称,
      可Esc整段跳过: 配置.可Esc整段跳过,
      默认倍速: 配置.默认倍速,
      步骤列表,
    };
  }

  for (let i = 0; i < 配置.对白列表.length; i++) {
    const 对白 = 配置.对白列表[i];

    for (let j = 0; j < 动作时间线.length; j++) {
      const 动作 = 动作时间线[j];
      if (动作.挂点 === "beforeDialog" && 动作.对白序号 === 对白.序号) {
        步骤列表.push(编译紧凑动作(动作));
      }
    }

    const 使用广播 = 对白.广播 === true
      || (配置.广播起始序号 != null && 对白.序号 >= 配置.广播起始序号);
    const 当前对白可Esc = 对白.可Esc跳过 === true || 使用广播;
    if (使用广播) {
      步骤列表.push({
        type: "broadcast",
        id: `${配置.片段ID}_broadcast_${对白.序号}`,
        名称: `${对白.序号}. ${对白.说话者}`,
        说话者: 对白.说话者,
        文本: 对白.文本,
        持续时间: 对白.持续时间,
        广播渠道: 对白.广播渠道 ?? "ui",
        来源单位引用: 对白.说话者引用,
        可跳过: 当前对白可Esc,
      } as 剧情步骤);
    } else 步骤列表.push({
      type: "dialog",
      id: `${配置.片段ID}_dialog_${对白.序号}`,
      名称: `${对白.序号}. ${对白.说话者}`,
      说话者: 对白.说话者,
      说话者引用: 对白.说话者引用,
      文本: 对白.文本,
      持续时间: 对白.持续时间,
      使用原生电影系统: 对白.使用原生电影系统,
      原生对白自动开启电影模式: 对白.原生对白自动开启电影模式,
      原生电影阻塞: 对白.原生电影阻塞,
      可Esc跳过: 当前对白可Esc,
    });

    for (let j = 0; j < 动作时间线.length; j++) {
      const 动作 = 动作时间线[j];
      if (动作.挂点 === "afterDialog" && 动作.对白序号 === 对白.序号) {
        步骤列表.push(编译紧凑动作(动作));
      }
    }
  }

  for (let i = 0; i < 动作时间线.length; i++) {
    const 动作 = 动作时间线[i];
    if (动作.挂点 === "absoluteTime") {
      步骤列表.push(编译紧凑动作(动作));
    }
  }

  return {
    片段ID: 配置.片段ID,
    名称: 配置.名称,
    可Esc整段跳过: 配置.可Esc整段跳过,
    默认倍速: 配置.默认倍速,
    步骤列表,
  };
}

export function 合并剧情步骤列表(this: void, 片段ID: string, 名称: string, 片段列表: 剧情片段配置[]): 剧情片段配置 {
  const 步骤列表: 剧情步骤[] = [];

  for (let i = 0; i < 片段列表.length; i++) {
    const 片段 = 片段列表[i];
    for (let j = 0; j < 片段.步骤列表.length; j++) {
      步骤列表.push(片段.步骤列表[j]);
    }
  }

  return {
    片段ID,
    名称,
    可Esc整段跳过: true,
    默认倍速: 1,
    步骤列表,
  };
}
