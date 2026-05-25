export interface 区域背景音乐配置项 {
  场景定义: string;
  区域变量名: string;
  默认环境音乐变量名?: string;
  随机环境音乐变量名列表?: string[];
  随机音乐组?: string;
  战斗音乐变量名?: string;
  胜利音乐变量名?: string;
  胜利音乐持续毫秒?: number;
  同区域重开时先清旧音乐?: boolean;
  Boss单位ID?: string;
}
