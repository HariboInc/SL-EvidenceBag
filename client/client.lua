----For support and more scripts----
----[ https://discord.gg/j2Qhm7dzK3 ]----

local bagEquipped, bagObj
local ox_inventory = exports.ox_inventory
local ped = cache.ped
local justConnect = true



local function PutOnBag()
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped,0.0,3.0,0.5))
    AttachEntityToEntity(bagObj, ped, GetPedBoneIndex(ped, 24818), 0.07, -0.11, -0.05, 0.0, 90.0, 175.0, true, true, false, true, 1, true)
    bagEquipped = true
end

local function RemoveBag()
    if DoesEntityExist(bagObj) then
        DeleteObject(bagObj)
    end
    bagObj = nil
    bagEquipped = nil
end

AddEventHandler('ox_inventory:updateInventory', function(changes)
    if justConnect then
        Wait(4500)
        justConnect = nil
    end
    for k, v in pairs(changes) do
        if type(v) == 'table' then
            local count = ox_inventory:Search('count', Config.EvidenceBagItem)
	        if count > 0 and (not bagEquipped or not bagObj) then
                PutOnBag()
            elseif count < 1 and bagEquipped then
                RemoveBag()
            end
        end
        if type(v) == 'boolean' then
            local count = ox_inventory:Search('count', Config.EvidenceBagItem)
            if count < 1 and bagEquipped then
                RemoveBag()
            end
        end
    end
end)

lib.onCache('ped', function(value)
    ped = value
end)

--[[lib.onCache('vehicle', function(value)
    if value then
        RemoveBag()
    else
        local count = ox_inventory:Search('count', Config.EvidenceBagItem)
        if count and count >= 1 then
            PutOnBag()
        end
    end
end)]]-- Needs work for player load error?

exports('openEvidenceBag', function(data, slot)
    if not slot?.metadata?.identifier then
        local identifier = lib.callback.await('SL-EvidenceBag:getNewIdentifier', 100, data.slot)
        ox_inventory:openInventory('stash', 'bag_'..identifier)
    else
        TriggerServerEvent('SL-EvidenceBag:openEvidenceBag', slot.metadata.identifier)
        ox_inventory:openInventory('stash', 'bag_'..slot.metadata.identifier)
    end
end)

