ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(100)
	end
	while YveltConfig == nil do
		Wait(100)
	end
	local itemName = YveltConfig.StaffItemName or 'staff_pistol'
	if ESX and ESX.RegisterUsableItem then
		ESX.RegisterUsableItem(itemName, function(source)
			TriggerClientEvent('YveltAdmin:ToggleStaffPistol', source)
		end)
		print('^0[^2!^0] ^2esx-server.lua ^0=> Item utilisable enregistré: '..itemName)
	else
		print('^0[^1!^0] ^1esx-server.lua ^0=> Impossible d\'enregistrer l\'item utilisable, ESX non disponible')
	end
end)