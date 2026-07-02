/** @noSelfInFile */

export interface 测试二维点 {
  x: number;
  y: number;
}

export interface 测试XY点 {
  X: number;
  Y: number;
}

export interface 测试矩形配置 {
  ID?: string;
  名称?: string;
  左: number;
  右: number;
  下: number;
  上: number;
}

export interface 测试坐标平移映射 {
  偏移X: number;
  偏移Y: number;
}

export function 创建测试中心平移映射(
  this: void,
  正式中心X: number,
  正式中心Y: number,
  测试中心X: number,
  测试中心Y: number,
): 测试坐标平移映射 {
  return {
    偏移X: 测试中心X - 正式中心X,
    偏移Y: 测试中心Y - 正式中心Y,
  };
}

export function 按测试映射平移坐标(this: void, 点: 测试二维点, 映射: 测试坐标平移映射): 测试二维点 {
  return {
    x: 点.x + 映射.偏移X,
    y: 点.y + 映射.偏移Y,
  };
}

export function 按测试映射平移XY坐标(this: void, 点: 测试XY点, 映射: 测试坐标平移映射): 测试XY点 {
  return {
    X: 点.X + 映射.偏移X,
    Y: 点.Y + 映射.偏移Y,
  };
}

export function 按测试映射平移矩形(this: void, 矩形: 测试矩形配置, 映射: 测试坐标平移映射): 测试矩形配置 {
  return {
    ID: 矩形.ID,
    名称: 矩形.名称,
    左: 矩形.左 + 映射.偏移X,
    右: 矩形.右 + 映射.偏移X,
    下: 矩形.下 + 映射.偏移Y,
    上: 矩形.上 + 映射.偏移Y,
  };
}

export function 根据测试中心平移坐标(
  this: void,
  点: 测试二维点,
  正式中心: 测试二维点,
  测试中心: 测试二维点,
): 测试二维点 {
  return 按测试映射平移坐标(点, 创建测试中心平移映射(正式中心.x, 正式中心.y, 测试中心.x, 测试中心.y));
}

export function 根据测试中心平移XY坐标(
  this: void,
  点: 测试XY点,
  正式中心: 测试二维点,
  测试中心: 测试二维点,
): 测试XY点 {
  return 按测试映射平移XY坐标(点, 创建测试中心平移映射(正式中心.x, 正式中心.y, 测试中心.x, 测试中心.y));
}

export function 根据测试中心平移矩形(
  this: void,
  矩形: 测试矩形配置,
  正式中心: 测试二维点,
  测试中心: 测试二维点,
): 测试矩形配置 {
  return 按测试映射平移矩形(矩形, 创建测试中心平移映射(正式中心.x, 正式中心.y, 测试中心.x, 测试中心.y));
}

export function 复制平移测试坐标数组(this: void, 点位: 测试二维点[], 映射: 测试坐标平移映射): 测试二维点[] {
  const result: 测试二维点[] = [];
  for (let i = 0; i < 点位.length; i++) {
    result.push(按测试映射平移坐标(点位[i], 映射));
  }
  return result;
}

export function 复制平移测试矩形数组(this: void, 矩形列表: 测试矩形配置[], 映射: 测试坐标平移映射): 测试矩形配置[] {
  const result: 测试矩形配置[] = [];
  for (let i = 0; i < 矩形列表.length; i++) {
    result.push(按测试映射平移矩形(矩形列表[i], 映射));
  }
  return result;
}
