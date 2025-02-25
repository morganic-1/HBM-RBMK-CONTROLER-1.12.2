-- Script info
local scriptVer = "0.0.1"
local authorsAndSupporters = {"Morganic_2", "Codeium AI Assistant", "ChatGPT 3.5"}

-- Required library's
local component = require("component")
local term = require("term")
local computer = require("computer")
local os = require("os")
local event = require("event")

-- Required object's
local rbmk = component.rbmk_console
local gpu = component.gpu

-- Script-wide variables
local running = true

-- RBMK variables
local allColumns = {}
local controlRodColumns = {}
local fuelRodColumns = {}
local boilerColumns = {}

local allColumnTemp = 0

-- Functions
local function findColumns()
    for x = 0, 15 do
        for y = 0, 15 do
            local data = rbmk.getColumnData(x, y)
            if type(data) == "table" then
                table.insert(allColumns, {x, y})
            end
        end
    end
print("Found " .. #allColumns .. " columns")
end

local function sortColumnsByType()
    for entry in pairs(allColumns) do
        local x = allColumns[entry][1]
        local y = allColumns[entry][2]
        local data = rbmk.getColumnData(x, y)
        if data.type == "CONTROL" then
            table.insert(controlRodColumns, {x, y})
        elseif data.type == "FUEL" then
            table.insert(fuelRodColumns, {x, y})
        elseif data.type == "BOILER" then
            table.insert(boilerColumns, {x, y})
        end
    end
print("Found " .. #controlRodColumns .. " controlRod columns")
print("Found " .. #fuelRodColumns .. " fuelRod columns")
print("Found " .. #boilerColumns .. " boiler columns")
end

local function findHeatByTable(Table)
    local temp = 0
    for i = 1, #Table do
        local x = Table[i][1]
        local y = Table[i][2]
        local data = rbmk.getColumnData(x, y)
        if data and data.hullTemp then
            temp = temp + data.hullTemp
        else
            print("Error: hullTemp is nil for column at (" .. x .. ", " .. y .. ")")
        end
    end
    temp = temp / #Table
    return temp
end

-- Startup sequence
term.clear()
computer.beep()
findColumns()
sortColumnsByType()
print("Script version :", scriptVer )
term.write("Written by : ")
for i, author in ipairs(authorsAndSupporters) do
    term.write(author)
    if i < #authorsAndSupporters then
        term.write(", ")
    end
end
print()
os.sleep(3)


-- Main loop
while running == true do
    print(findHeatByTable(allColumns))
    os.sleep(0.1)
    term.clear()
end