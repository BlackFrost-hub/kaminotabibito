/** @noSelfInFile */

import type { Boss测试场地定义 } from "./00．Boss测试类型";
import {
  测试坐标平移映射,
  测试二维点,
  测试矩形配置,
  创建测试中心平移映射,
  按测试映射平移坐标,
  按测试映射平移矩形,
} from "../00．测试系统辅助函数";

export interface Boss测试场地上下文 {
  场地: Boss测试场地定义;
  映射: 测试坐标平移映射;
  平移坐标: (this: void, 点: 测试二维点) => 测试二维点;
  平移矩形: (this: void, 矩形: 测试矩形配置) => 测试矩形配置;
}

export function 创建Boss测试场地上下文(this: void, 场地: Boss测试场地定义): Boss测试场地上下文 {
  const 映射 = 创建测试中心平移映射(
    场地.正式中心.x,
    场地.正式中心.y,
    场地.测试空地中心.x,
    场地.测试空地中心.y,
  );
  return {
    场地,
    映射,
    平移坐标: function Boss测试场地上下文平移坐标(this: void, 点: 测试二维点): 测试二维点 {
      return 按测试映射平移坐标(点, 映射);
    },
    平移矩形: function Boss测试场地上下文平移矩形(this: void, 矩形: 测试矩形配置): 测试矩形配置 {
      return 按测试映射平移矩形(矩形, 映射);
    },
  };
}
