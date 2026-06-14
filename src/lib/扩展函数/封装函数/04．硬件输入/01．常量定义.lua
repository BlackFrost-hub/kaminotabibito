--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 按键状态（DzTriggerRegisterKeyEventTrg：1=按下，0=抬起）
____exports.KEY_STATE = {DOWN = 1, UP = 0}
--- 鼠标按键（BzAPI：1=左，2=右，3=中）
____exports.MOUSE_BUTTON = {LEFT = 1, RIGHT = 2, MIDDLE = 3}
--- 鼠标按键状态（DzTriggerRegisterMouseEventTrg：1=按下，0=抬起）
____exports.MOUSE_STATE = {DOWN = 1, UP = 0}
--- A-Z
____exports.KEY = {
    A = 65,
    B = 66,
    C = 67,
    D = 68,
    E = 69,
    F = 70,
    G = 71,
    H = 72,
    I = 73,
    J = 74,
    K = 75,
    L = 76,
    M = 77,
    N = 78,
    O = 79,
    P = 80,
    Q = 81,
    R = 82,
    S = 83,
    T = 84,
    U = 85,
    V = 86,
    W = 87,
    X = 88,
    Y = 89,
    Z = 90
}
--- F1-F12
____exports.KEY_F = {
    F1 = 112,
    F2 = 113,
    F3 = 114,
    F4 = 115,
    F5 = 116,
    F6 = 117,
    F7 = 118,
    F8 = 119,
    F9 = 120,
    F10 = 121,
    F11 = 122,
    F12 = 123
}
--- 字母键（兼容旧代码，推荐使用 KEY）
____exports.KEY_LETTER = ____exports.KEY
--- 0-9
____exports.KEY_NUM = {
    K0 = 48,
    K1 = 49,
    K2 = 50,
    K3 = 51,
    K4 = 52,
    K5 = 53,
    K6 = 54,
    K7 = 55,
    K8 = 56,
    K9 = 57
}
return ____exports
