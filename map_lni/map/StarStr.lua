local a = {}

local CJ = require 'jass.common'
local g = require 'jass.globals'


function a.concat()

    local s1 = CJ.LoadStr(g.StarBaseHT,1000,0)
    local s2 = CJ.LoadStr(g.StarBaseHT,1000,1)
    local s3 = CJ.LoadStr(g.StarBaseHT,1000,2)

    --CJ.DisplayTextToPlayer(CJ.Player(0),0,0,s1)
    local s = s1..s2..s3
    --CJ.DisplayTextToPlayer(CJ.Player(0),0,0,s)
    CJ.SaveStr(g.StarBaseHT,1000,4,s)

end

function a.concat2()
    local index = CJ.LoadInteger(g.StarBaseHT,999,0)--在999的0位置存储需要连接的字符串数量
    --CJ.DisplayTextToPlayer(CJ.Player(0),0,0,CJ.I2S(index))
    --从1000索引 0开始读取至index
    local s = ""
    local i  = 0
    --CJ.DisplayTextToPlayer(CJ.Player(0),0,0,CJ.I2S(i))
    for i = 0, index do
        --CJ.DisplayTextToPlayer(CJ.Player(0),0,0,CJ.I2S(i))
        local str = CJ.LoadStr(g.StarBaseHT,1000,i)
        s = s..str
        if i==index-1 then
            CJ.SaveStr(g.StarBaseHT,999,1,s)
        end
    end

    return s
end
function a.concat3()
    local index = g.SSL_StringBufferIndex-1
    local s = ""
    local i  = 0
    --CJ.DisplayTextToPlayer(CJ.Player(0),0,0,index)
    for i = 0, index do
        s = s..g.SSL_StringBuffer[i]
    end
    g.SSL_StringBufferIndex = 0
    --CJ.DisplayTextToPlayer(CJ.Player(0),0,0,s)
    return s
end

return a
