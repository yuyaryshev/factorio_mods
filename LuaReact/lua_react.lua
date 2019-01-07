
local function sample_component(props, state) 
return
    {
    type="frame", 
    name="lo_radio_network_frame", 
    caption={"lo-radio-device-settings"}, 
    direction="vertical"
    children={
        {type="label", name="lbChannel", caption={"lo-radio-device-channel"}},
		{type="textfield", name="tbChannel", text=device.network_name},
		{type="label", name="lbChannel", caption={"lo-radio-device-channel-hint"}},
		{type="button", name="btnOk", caption={"lo-radio-device-ok"}},
		{type="button", name="btnCancel", caption={"lo-radio-device-cancel"}}
    }}
end

-- Проверка типа значения if type(one_or_n_components) ~= "table" then

local function normalize_children(a)
	if not a then return a end
	
	local n = (a.type and {a} or a)
	local r = {}

	for i = 1, #n do
		if n[i] then
			if n[i].children then 
				n[i].children = normalize_children(n[i].children)
			end
			
			table.insert(r, n[i])
		end	
	end	
	return r
end

local function compare_value(a,b)
	return a == b or a and b and #a == 1 and #b == 1 and a[1] == b[1]
end

local function compare_update_props(new_node, old_node)
	-- TODO учесть что ВСЕ строки могут быть локализованы - они не будут равны, потребуется сравнить их содержимое внутри {}
	-- Использовать compare_value(a,b)

	local t = new_node and new_node.type or old_node and old_node.type
	
	if t == "button" then
	elseif t == "flow" then
	end
end

local function compare_node(new_node, old_node)
	local normalized_nodes = normalize_nodes(new_node)
	if new_node and old_node and new_node.type == old_node.type then
		compare_update_props(new_node, old_node)
	else
		-- TODO delete old_node here!
		compare_update_props(nil, old_node)
		compare_update_props(new_node, nil)
	end
end

local function compare_node(component_function, props, old_node)
	local rendered_nodes = normalize_children(component_function(props))
	-- Все что ниже - не уверен! Не точно!!!
	
	-- Вызывать 
	local one_or_n_components = component_function(props)
	
	for i = 1, #one_or_n_components do
		-- TODO Сравнить тип. Проверить nil с обоих сторон
		-- TODO Вызвать функцию сравнения компонент
		
	end	
end
