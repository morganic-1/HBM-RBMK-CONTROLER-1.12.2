--pre-ini
local scriptPhase = ""
local scriptVer = "0.0.1 - A"

-- Erroring functions
local function Fatal_err(err)
    print(debug.traceback("FATAL ERROR: " .. err .. "DURING:" .. scriptPhase))
    return nil
end

---@param err string
---@return nil
local function Warn_err(err)
    gpu.setForeground(0xFFFF00)
    print("WARN: " .. err)
    gpu.setForeground(0xFFFFFF)
    return nil
end

scriptPhase = "pre-ini"

local component = require("component")
local event = require("event")
local term = require("term")
local os = require("os")
local c = component
local gpu = c.gpu
local rbmk = c.rbmk_console

--ini
scriptPhase = "ini"

term.clear()

print("Morganic_2's RBMK controller script version, "..scriptVer)

local maxTemp = 1000
local maxSafeTemp = 700
local MinTemp = 600
local waterThreshold = 7000

local controlRods = {}
local controlRodsInsert = {}
local fuelRods = {}
local fuelCoreHeat = {}
local fuelColunmHeat = {}
local boilers = {}
local boilersHeat = {}
local boilersWater = {}
local boilersSteam = {}

local AvfuelColumnTemp = 0
local AvfuelCoreTemp = 0
local AvBoilerColunmTemp = 0
local AvBoilerWaterAmount = 0
local AvControlRodIns = 0

function averageTable(tableIN)
    local sum = 0
    for i, v in ipairs(tableIN) do
        sum = sum + v
    end
    local average = sum / #tableIN
    return average
end

--startup
scriptPhase = "startup"
print("starting...")

for x=0,15 do
    for y=0,15 do
        local data = rbmk.getColumnData(x,y)
        if data.type == "CONTROL" then
            table.insert(controlRods, {x = x, y = y})
        elseif data.type == "FUEL" then
            table.insert(fuelRods, {x = x, y = y})
        elseif data.type = "BOILER" then
            table.insert(boilers, {x = x, y = y})
        else

        end
    end
end


--main prosesing loop
scriptPhase = "main-prosssesing-loop"
while true do
    for i, column in ipairs(controlRods) do
        local x = column.x
        local y = column.y
        local data = rbmk.getColumnData(x,y)
        table.insert(controlRodsInsert, data.level)
    end
    for i, column in ipairs(fuelRods) do
        local x = column.x
        local y = column.y
        local data = rbmk.getColumnData(x,y)
        table.insert(fuelCoreHeat, data.coreTemp)
        table.insert(fuelCoreHeat, data.hullTemp)
    end
    for i, column in ipairs(boilers) do
        local x = column.x
        local y = column.y
        local data = rbmk.getColumnData(x,y)
        table.insert(boilersHeat, data.hullTemp)
        table.insert(boilersWater, data.water)
        table.insert(boilersSteam, data.steam)
    end

    AvfuelCoreTemp = averageTable(fuelCoreHeat)
    AvfuelColumnTemp = averageTable(fuelColunmHeat)
    AvfuelColumnTemp = averageTable(fuelColunmHeat)
    AvBoilerColunmTemp = averageTable(boilersHeat)

   gpu.set(10,10, AvfuelCoreTemp) 
   gpu.set(20,20, AvfuelColumnTemp)
   gpu.set(30,30, AvfuelCoreTemp)
   gpu.set(40,40, fuelColunmHeat)
end