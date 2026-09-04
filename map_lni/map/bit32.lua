Global = Global or {};
local bits = {};


function bits.bxor(num1,num2)
    local ret=bit32.bxor(num1,num2);--异或
    return ret;
end


function bits.bor(num1,num2)
    local ret=bit32.bor(num1,num2);--或
    return ret;
end


function bits.rshift(num,shiftbitnum)
    local ret=bit32.rshift(num,shiftbitnum);--右移
    return ret;
end

function bits.lshift(num,shiftbitnum)
    local ret=bit32.lshift(num,shiftbitnum);--左移
    return ret;
end

function bits.band(num1,num2)
    local ret=bit32.band(num1,num2);--与
    return ret;
end

function bits.bnot(num1,num2)
    local ret=bit32.bnot(num1,num2);--取反
    return ret;
end


Global.bits = bits;
return bits;