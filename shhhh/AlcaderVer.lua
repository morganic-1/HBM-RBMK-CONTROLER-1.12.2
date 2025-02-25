w-- Script info
local scriptVer = "0.0.1"
local authors = {"Morganic_2"}

-- Required library's
local component = require("component")
local term = require("term")
local computer = require("computer")

-- Required objects
local rbmk = component.rbmk_console

-- Script-wide variables
local controlRodColumns = {}
local fuelRodColumns = {}
local boilerColumns = {}
local allColumns = {}

-- RBMK variables
--#region
local averageGlobalHullTemp = 0

local 

--#endregion
--
local function sortColumnsByType()
    for x = 0, 15 do
        for y = 0, 15 do
            local data = rbmk.getColumnData(x, y)
            if type(data) == "table" then
                print("found rod at: ", x , y)
                table.insert(allColumns, {x, y})
                if data.type == "CONTROL" then
                    table.insert(controlRodColumns, {x, y})
                end
                if data.type == "FUEL" then
                    table.insert(fuelRodColumns, {x, y})
                end
                if data.type == "BOILER" then
                    table.insert(boilerColumns, {x, y})
                end
            end
        end
    end
end

local function findHeatByTable(table)
    local AverageTemp = 0
    local count = 0
    for i = 1, #table do
        for j = 1, #table do
            local x = table[i][1]
            local y = table[i][2]
            local data = rbmk.getColumnData(x, y)
            if data and data.hullTemp then
                AverageTemp = AverageTemp + data.hullTemp
                count = count + 1
            else
                print("Error: hullTemp is nil for column at (" .. x .. ", " .. y .. ")")
            end
        end
    end
    if count > 0 then
        return AverageTemp / count
    else
        return 0  -- Avoid division by zero if no valid hullTemp values are found
    end
end

-- Startup sequence
computer.beep()
term.clear()
print("Script version :", scriptVer )
print("Written by :", authors)
os.sleep(3)
term.clear()
computer.beep()
-- Begin script
do 
    sortColumnsByType()
    os.sleep(3)
    term.clear()
    print("found " .. #allColumns .. " total columns")
    print("found " .. #controlRodColumns .. " control rod columns")
    print("found " .. #fuelRodColumns .. " fuel rod columns")
    print("found " .. #boilerColumns .. " boiler columns")
    os.sleep(3)

    -- Main loop
    while true do
        os.sleep(1)
        term.clear()

        averageGlobalHullTemp = findHeatByTable(allColumns)

        print("Global Hull Temp: ", averageGlobalHullTemp)
    end
end