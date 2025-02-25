local component = require("component")
local event = require("event")

local modem = component.modem
local ownAddress = "own_computer_address"
local wakeMessage = "meSp!De9RUM?rif@"

modem.open(123)  -- Open port 123 for receiving messages

event.listen("modem_message", function(_, _, from, port, _, message)
    if port == 123 and from ~= ownAddress and message == wakeMessage then
        -- Send a wake message back to the other computer
        modem.send(from, 123, wakeMessage)
    end
end)

-- Send a wake message to other computers
for address in pairs(component.list("modem")) do
    if address ~= ownAddress then
        modem.send(address, 123, wakeMessage)
    end
end