local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
require('settings')


commandArray = {}

-- Simple thermostat control for the maintenance heating mode





return commandArray