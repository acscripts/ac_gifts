local Inventory = exports.ox_inventory

-- convert gift type to size
Inventory:registerHook('createItem', function(payload)
	local metadata = payload.metadata

	if not metadata.size or not sizesMatches(metadata.size, getSize(metadata.type)) then
		metadata.size = getSize(metadata.type)
		metadata.type = nil
	end

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
