export type 剧情步骤类型 =
  | "dialog"
  | "broadcast"
  | "wait"
  | "camera"
  | "fog"
  | "music"
  | "unitControl"
  | "animation"
  | "effect"
  | "giveItem"
  | "runAction"
  | "startBossFight";

export interface 剧情步骤基础 {
  type: 剧情步骤类型;
  id?: string;
  名称?: string;
  可跳过?: boolean;
  倍速系数?: number;
}

export interface 剧情对白步骤 extends 剧情步骤基础 {
  type: "dialog";
  说话者: string;
  文本: string;
  持续时间: number;
  使用原生电影系统?: boolean;
  原生电影阻塞?: boolean;
}

export interface 剧情广播步骤 extends 剧情步骤基础 {
  type: "broadcast";
  说话者?: string;
  文本: string;
  持续时间?: number;
}

export interface 剧情等待步骤 extends 剧情步骤基础 {
  type: "wait";
  持续时间: number;
  允许Esc跳过?: boolean;
  使用原生电影系统?: boolean;
}

export interface 剧情镜头步骤 extends 剧情步骤基础 {
  type: "camera";
  镜头名?: string;
  目标X?: number;
  目标Y?: number;
  持续时间?: number;
  镜头距离?: number;
}

export interface 剧情视野步骤 extends 剧情步骤基础 {
  type: "fog";
  区域变量名: string;
  模式?: "visible" | "masked" | "fogged";
}

export interface 剧情音乐步骤 extends 剧情步骤基础 {
  type: "music";
  场景定义?: string;
  区域变量名?: string;
  战斗音乐变量名?: string;
  胜利音乐变量名?: string;
  默认环境音乐变量名?: string;
  动作: "挂载" | "清空场景" | "清空区域" | "清空全部";
}

export interface 剧情单位控制步骤 extends 剧情步骤基础 {
  type: "unitControl";
  目标: string;
  动作:
    | "暂停"
    | "恢复"
    | "设为无敌"
    | "取消无敌"
    | "显示"
    | "隐藏"
    | "移动"
    | "朝向"
    | "下指令";
  X?: number;
  Y?: number;
  朝向?: number;
  指令?: string;
  指令目标?: string;
}

export interface 剧情动画步骤 extends 剧情步骤基础 {
  type: "animation";
  目标: string;
  动画名: string;
}

export interface 剧情特效步骤 extends 剧情步骤基础 {
  type: "effect";
  模型路径: string;
  目标?: string;
  挂点?: string;
  X?: number;
  Y?: number;
}

export interface 剧情发物品步骤 extends 剧情步骤基础 {
  type: "giveItem";
  目标: string;
  物品ID: string;
  数量?: number;
}

export interface 剧情自定义动作步骤 extends 剧情步骤基础 {
  type: "runAction";
  动作ID: string;
  参数?: Record<string, string | number | boolean>;
}

export interface 剧情Boss战步骤 extends 剧情步骤基础 {
  type: "startBossFight";
  Boss单位ID?: string;
  Boss引用?: string;
}

export type 剧情步骤 =
  | 剧情对白步骤
  | 剧情广播步骤
  | 剧情等待步骤
  | 剧情镜头步骤
  | 剧情视野步骤
  | 剧情音乐步骤
  | 剧情单位控制步骤
  | 剧情动画步骤
  | 剧情特效步骤
  | 剧情发物品步骤
  | 剧情自定义动作步骤
  | 剧情Boss战步骤;

export interface 剧情片段配置 {
  片段ID: string;
  名称?: string;
  可Esc整段跳过?: boolean;
  默认倍速?: number;
  步骤列表: 剧情步骤[];
}
