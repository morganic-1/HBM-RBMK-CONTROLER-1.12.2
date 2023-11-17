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


--Boilers (BOILER)
