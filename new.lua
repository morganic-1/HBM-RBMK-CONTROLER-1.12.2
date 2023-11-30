local component = require("component")  
local event = require("event")
local term = require("term")
local os = require("os")
local c = component
local gpu = c.gpu
local rbmk = c.rbmk_console

local scriptPhase = "Pre-ini"
local scriptVer = "0.0.1 - A"
term.clear()
print("Morganic_2's RBMK controller script version, "..scriptVer)

scriptPhase = "ini" -- start init of script vars and vals

--Reactor perams

local maxReactorTemp = 1000
local maxSafeReactorTemp = 800
local maxOperatingTemp = 700
local minOperatingTemp = 600

local averageReactorTemp = 0
local foundRods = {}

--Control rods (CONTROL)

local controlRodColumns = {}
local controlRodInserts = {}
local controlRodTemps = {}
local averageControlRodTemp = 0

--Fuel rods (FUEL)

local fuelRodColumns = {}
local fuelRodDepletion = {}
local fuelRodCoreTemp = {}
local fuelRodSkinTemp = {}
local fuelRodColumnTemp = {}
local averageFuelDepleation = 0
local averageCoreTemp = 0
local averageFuelColumnTemp = 0

--Boilers (BOILER)

local boilerColumns = {}
local boilerWater = {}
local boilerSteam = {}
local boilerTemp = {}
local averageBoilerTemp = 0
local averageBoilerWater = 0
local averageBoilerSteam = 0

-- functions

function averageTable(tableIN, averageOUT)
    local sum = 0
    for i, v in ipairs(tableIN) do
        sum = sum + v
    end
    local averageOUT = sum / #tableIN
    return averageOUT
end

function averageDouble(tableIN,averageOUT)
    local sum = 0
    for i, v in ipairs(tableIN) do
        sum = sum + v
    end
    local average = sum / #tableIN
    averageOUT = average * 100
    return averageOUT
end


--end ini

scriptPhase = "Startup"

for x=0,15 do
    for y=0,15 do
        local data = rbmk.getColumnData(x,y)
        table.insert(foundRods, {x = x, y = y})
        if data.type == "CONTROL" then
            table.insert(controlRodColumns, {x = x, y = y})
        elseif data.type == "FUEL" then
            table.insert(fuelRodColumns, {x = x, y = y})
        elseif data.type == "BOILER" then
            table.insert(boilerColumns, {x = x, y = y})
        else

        end
    end
end

scriptPhase = "main-prosssesing-loop"
while true do
    for i, column in ipairs(controlRodColumns) do
        local x = column.x
        local y = column.y
        local data = rbmk.getColumnData(x,y)
        table.insert(controlRodInserts, data.level)
        table.insert(controlRodTemps, data.hullTemp)
    end
    for i, column in ipairs(fuelRodColumns) do
        local x = column.x
        local y = column.y
        local data = rbmk.getColumnData(x,y)
        table.insert(fuelRodDepletion, data.coreTemp)
        table.insert(fuelRodCoreTemp, data.enrichment)
        table.insert(fuelRodSkinTemp, data.coreSkinTemp)
        table.insert(fuelRodColumnTemp, data.hullTemp)
    end
    for i, column in ipairs(boilerColumns) do
        local x = column.x
        local y = column.y
        local data = rbmk.getColumnData(x,y)
        table.insert(boilerWater, data.water)
        table.insert(boilerSteam, data.steam)
        table.insert(boilerTemp, data.hullTemp)
    end

    averageTable(fuelRodCoreTemp, AvfuelCoreTemp)
    averageTable(fuelColunmHeat, AvfuelColumnTemp)
    averageTable(boilersHeat)

    gpu.set(10,10, AvfuelCoreTemp) 
    gpu.set(20,20, AvfuelColumnTemp)
    gpu.set(30,30, AvfuelCoreTemp)
    gpu.set(40,40, fuelColunmHeat)
end