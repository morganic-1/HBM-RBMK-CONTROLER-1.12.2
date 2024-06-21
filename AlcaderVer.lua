-- Script info
local scriptVer = "0.0.1"
local authors = {"Morganic_2"}

-- Required library's
local component = require("component")
local term = require("term")
local computer = require("computer")

-- Required objects
local gpu = component.gpu
local rbmk = component.rbmk_console

-- Script-wide variables
local computerUptime = computer.uptime()
local minecraftTime = os.date()
local controlRodColumns = {}
local fuelRodColumns = {}
local boilerColumns = {}
local allColumns = {}
-- Functions
local function sortColumnsByType()
    for x = 0, 15 do
        for y = 0, 15 do
            local data = rbmk.getColumnData(x, y)
            if data.type == table then
                table.insert(allColumns)
                if data.type == "CONTROL" then
                    table.insert(controlRodColumns, { x = x, y = y })
                elseif data.type == "FUEL" then
                    table.insert(fuelRodColumns, { x = x, y = y })
                elseif data.type == "BOILER" then
                    table.insert(boilerColumns, { x = x, y = y })
                else
                    -- handler to ignore other cases
                end
            else
                -- Handler to ignore if nil or other
            end
        end
    end
end

-- Startup sequence
computer.beep()
term.clear()
print("Script version :", scriptVer )
print("Written by :", authors)
os.sleep(3)
term.clear()

-- Begin script
do 
    sortColumnsByType()


    -- Main loop
    while true do
        
    end
end