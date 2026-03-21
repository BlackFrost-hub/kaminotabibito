local japi = require 'jass.japi'
local jass = require 'jass.common'
local runtime = require 'jass.runtime'
local g = require 'jass.globals'


function output(msg)
    jass.DisplayTextToPlayer(jass.Player(0),0,0,msg);
end


function runtime.error_handle(msg)
    local traceback = debug.traceback();
    output("---------------------------------------");
    output("游戏出错: ");
    output(msg);
    output("\n堆栈信息: ");
    output(traceback);
    output("---------------------------------------");
end
