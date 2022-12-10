local Inventory = exports.ox_inventory

RegisterNetEvent('ac_gifts:wrapGift', function(slot)
    local playerId = source
    local item = Inventory:GetSlot(playerId, slot)

    local removed = Inventory:RemoveItem(playerId, item.name, 1, item.metadata, slot)
    if removed then
        local metadata = item.metadata
        metadata.id = item.metadata.container
        item.metadata.container = nil
        Inventory:AddItem(playerId, 'gift', 1, metadata, slot)
    end
end)
