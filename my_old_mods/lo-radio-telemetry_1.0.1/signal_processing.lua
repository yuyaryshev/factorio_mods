local function debugPrint(string)
    local p
    if game and game.players[1] then
        p = game.players[1].print
    else
        p = print
    end
    p(string)
end

function merge_signals(state, signals)
    for _,signal in ipairs(signals) do
        local key = signal.signal.type .. ":" .. signal.signal.name
        local previous = state[key]
        if not previous then
            state[key] = { signal = signal.signal, count = signal.count }
        else
            state[key] = { signal = signal.signal, count = signal.count + previous.count }
        end
    end
end

function table_to_string(t)
	local r =  nil
	if t == nil then
		return "nil"
	end
	
    for k,v in pairs(t) do
		if r ~= nil then
			r =  r .. ", "
		else
			r = ""
		end
		
		if type(v) == "table" then
			r = r .. k .. " = ".. table_to_string(v)
		else
			r = r .. k .. " = ".. v
		end
	end
	
	if r ~= nil then
		return "{" .. r .. "}"
	else
		return "{}"
	end
end

function print_signals(state, x)
    debugPrint("print_signals "..x.." " .. table_to_string(state))
end

function merge_state(state, a)
--	debugPrint("INSIDE merge_state")
    for key, signal in pairs(a) do
        local previous = state[key]
        if not previous then
            state[key] = signal
        else
            state[key] = { signal = signal.signal, count = signal.count + previous.count }
        end
    end
end

function format_signals(state)
--    debugPrint("Formatting Signals")
    local signals = {}
    local index = 1
    for _,signal in pairs(state) do
        signal.index = index
        index = index + 1
--        debugPrint("Formatting: " .. signal.signal.name)
        table.insert(signals, signal)
    end
    return signals
end
