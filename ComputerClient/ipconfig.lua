local os = os or require("os")
local component = require("component")
local event = require("event")
local thread = require("thread")
local m = component.modem

local args={...}
m.open(1)

--== LOCAL FUCNTIONS ==--

local function printTable()
	if IP == nil then
		print("This computer has not been configured.") -- cannot give ipconfig if PC has not been assigned an IP.
		return
	end
	print("\nIP	.	.	.	.	" .. IP)
	print("MAC	.	.	.	.	" .. MAC .. "\n")
end

local function isIpTaken(ip) --broadcasts a message asking if anyone is named with that ip
	iweb.broadcast(1, "find", ip)
	return false
end

--== BEGIN CODE ==--

if #args == 0 then
	printTable()
elseif args[1] == 'assign' then -- configure PC to use OpenInterweb
	if IP ~= nil then
		os.exit() -- cannot assign IP to already assigned computer.
	end
	local obtainedIP = false

	while obtainedIP == false do
		local attemptedIP = nil

		if args[2] == nil then -- if no name is given, generate one.
			attemptedIP = tostring(math.random(1, 65536)) -- 16 bit integer limit.	
		else -- use the given name
			attemptedIP = tostring(args[2])
		end

		if isIpTaken(attemptedIP) == false then
			obtainedIP = true
			IP = attemptedIP
		end
	end
	printTable()

	ARP = ARP or {{IP, MAC}} --initialize ARP table.
end
