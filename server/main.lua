local Inventory = exports.ox_inventory

local function getSize(type)
	return ac.sizes[type] or ac.sizes[ac.defaultSize] or {3, 5000}
end

local function sizesMatches(size1, size2)
	return size1[1] == size2[1] and size1[2] == size2[2]
end


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

-- check for neweset version
if ac.versionCheck and GetResourceState('ox_lib') == 'started' then
	exports.ox_lib:versionCheck('acscripts/ac_gifts')
end
