-- Libraries 
local component = require("component")
local event = require("event")
local term = require("term")
local os = require("os")

-- Objects
local gpu = component.gpu
local rbmk = component.rbmk_console
local rs = {} -- reserved for later
local modem = {} -- reserved for later

-- Script-wide variables

local scriptVer = "0.0.1 - A"
local scriptPhase = ""
local runningThreads = {}
local outlineColor = 0x00FF00

    -- Values

    local logBoxX = 5
    local logBoxY = 10
    local logBoxWidth = 40
    local logBoxHeight = 5
    
    -- Tables

    local logMessages = {}

-- Functions

-- Function to update the log box with a status message
local function updateLogBox(message, textColor)
    -- Add the message to the logMessages array
    table.insert(logMessages, message)  
    if #logMessages > logBoxHeight then
        table.remove(logMessages, 1)  -- Remove the oldest message
    end
    gpu.setForeground(outlineColor)
    gpu.set(logBoxX, logBoxY, string.rep("─", logBoxWidth))  -- Top border
    gpu.set(logBoxX, logBoxY + logBoxHeight - 1, string.rep("─", logBoxWidth))  -- Bottom border
    for i = logBoxY + 1, logBoxY + logBoxHeight - 2 do
        gpu.set(logBoxX, i, "│")
        gpu.set(logBoxX + logBoxWidth - 1, i, "│")
    end
    gpu.setForeground(textColor)
    for i, msg in ipairs(logMessages) do
        gpu.set(logBoxX + 1, logBoxY + i, msg)
    end
    gpu.setForeground(0xFFFFFF)  -- Reset to default text color
end

-- Error handlers

local function fatalError(err)
    print(debug.traceback("FATAL ERROR: " .. err .. "DURING:" .. scriptPhase))
    print(debug.traceback("CHECK LOG FOR MORE DETAIL"))
    return nil
end

local function warnErr(err)
    updateLogBox("WARN: " .. err, #FFFF00)
end

gpu.fill(5, 10, 40, 5, " ")

-- Main loop
while true do
    
end