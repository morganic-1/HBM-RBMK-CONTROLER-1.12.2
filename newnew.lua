local scriptPhase = ""
scriptPhase = "Startup"
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
local runningThreads = {}
local outlineColor = 0x00FF00

    -- Values

    local logBoxX = 5
    local logBoxY = 10
    local logBoxWidth = 40
    local logBoxHeight = 5
    
    -- Tables

    local logMessages = {}

    -- RBMK data

    local foundRods = {} -- data should look like this {{x,y,type},{x,y,type}}
    local globalHeat = {} -- data should look like this {{heat},{heat}}
    local globalAvHeat = 0


-- Functions


local function updateLogBox(message, textColor)
    local lines = {}
    for i=1, #message, logBoxWidth do
        table.insert(lines, message:sub(i, i+logBoxWidth-1))
    end
    for _, line in ipairs(lines) do
        table.insert(logMessages, line)
        if #logMessages > logBoxHeight then
            table.remove(logMessages, 1)  -- Remove the oldest message
        end
    end
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

local function averageTable(tableIN)
    local sum = 0
    for i, v in ipairs(tableIN) do
        sum = sum + v
    end
    return sum / #tableIN
end

local function averageDouble(tableIN)
    local sum = 0
    for i, v in ipairs(tableIN) do
        sum = sum + v
    end
    return (sum / #tableIN) * 100
end

-- Error handlers

local function fatalError(err)
    updateLogBox("FATAL ERROR: " .. err .. "DURING:" .. scriptPhase, #FF0000)
    updateLogBox("CHECK LOG FOR MORE DETAIL")
    return nil
end

local function warnErr(err)
    updateLogBox("WARN: " .. err, #FFFF00)
end


-----------------------------------------------------------------------------------------------------------------

-- Switch mode to startup
scriptPhase = "startup"


-- find rbmk rods

for x=0,15 do
    for y=0,15 do
        local data = rbmk.getColumnData(x,y)
        if type(data) == "table" then
            -- This means there's a rod at (x, y)
            -- Now you can access the properties of the rod
            table.insert(foundRods, {x, y, data.type})
        end
    end
end

gpu.fill(5, 10, 40, 5, " ")

-----------------------------------------------------------------------------------------------------------------
-- Main loop
while true do
    
end