local jass = require 'jass.common'

jass.DisplayTextToPlayer(jass.Player(0),0,0,"init X")

local g = require 'jass.globals'
local jpai = require 'jass.japi'
local message = require 'jass.message'
local log = require "jass.log"
local log_error = log.error
local index = {}
local hook = message.hook

jass.DisplayTextToPlayer(jass.Player(0),0,0,"init X")
for k, v in pairs(jass) do
	local i = index[k] +1
	hook[k] = function(...)
		index[k] = i
		if i % 1000 == 0 then
			log.error(v..i..os.date())
		end
		return v(...)
	end
end
jass.DisplayTextToPlayer(jass.Player(0),0,0,"init X")

