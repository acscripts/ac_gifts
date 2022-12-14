local Inventory = exports.ox_inventory

-- convert gift type to size
Inventory:registerHook('createItem', function(payload)
	local metadata = payload.metadata

	if not metadata.size or not sizesMatches(metadata.size, getSize(metadata.type)) then
		metadata.size = getSize(metadata.type)
	end
	metadata.type = nil

	return metadata
end, {
	itemFilter = { [ac.items.emptyGift] = true }
})

-- wrap gift box
RegisterNetEvent('ac_gifts:wrapGift', function(slot)
	local playerId = source
	local item = Inventory:GetSlot(playerId, slot)

	local removed = Inventory:RemoveItem(playerId, ac.items.emptyGift, 1, item.metadata, slot)
	if removed then
		-- change 'container' to 'id' to prevent the item from being opened as a container
		local metadata = item.metadata
		metadata.id = metadata.container
		metadata.container = nil

		Inventory:AddItem(playerId, ac.items.gift, 1, metadata, slot)
	end
end)

-- unwrap gift
exports('unwrapGift', function(event, _, inventory, slot)
	if event == 'usingItem' then
		local item = Inventory:GetSlot(inventory.id, slot)

		local removed = Inventory:RemoveItem(inventory.id, ac.items.gift, 1, item.metadata, slot)
		if removed then
			local metadata = item.metadata
			metadata.container = metadata.id
			metadata.id = nil

			Inventory:AddItem(inventory.id, ac.items.openedGift, 1, metadata, slot)
		end
	end
end)

-- get packed gift
local function addGift(playerId, content)
	-- get content from predefined gift name
	if type(content) == 'string' and Gifts[content] then
		content = Gifts[content]
	end

	if type(content.size) ~= 'string' then
		print('Gift size is not a string - using default size.')
		content.size = ac.defaultSize
	end

	-- give empty gift box to a player
	local success, response = Inventory:AddItem(playerId, ac.items.emptyGift, 1, content.size)

	if not success then
		print(('Failed to add gift to %s: %s'):format(playerId, response))
		return false, response
	end

	local metadata = response[1].metadata
	for i=1, #content.items do
		local item = content.items[i]
		Inventory:AddItem(metadata.container, item.name, item.count, item.metadata, i)
	end
end

RegisterCommand('gift', function(source, args)
	addGift(source, args[1] or 'example')

	local item = Inventory:GetSlot(source, 1)
	print('final', json.encode(item.metadata))
end)
