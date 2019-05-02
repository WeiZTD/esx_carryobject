local iscarry = false
Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end
    end
)

function loadAnimDict(lib)
    while (not HasAnimDictLoaded(lib)) do
        RequestAnimDict(lib)
        Citizen.Wait(5)
    end
end

RegisterCommand(
    "carry",
    function()
        local playerPed = GetPlayerPed(-1)
        local coords = GetEntityCoords(playerPed)
        local object, distance = ESX.Game.GetClosestObject()
        local boneIndex = GetPedBoneIndex(playerPed, 28422)
        local playerId = ESX.GetPlayerData()

        if distance <= 3.0 and iscarry == false then
            local lib, anim = "anim@move_m@trash", "pickup"
            loadAnimDict(lib)
            TaskPlayAnim(playerPed, lib, anim, 8.0, 1.0, -1, 2, 0, true, true, true)
            Citizen.Wait(2000)
            ClearPedTasksImmediately(playerPed)
            local lib, anim = "anim@heists@box_carry@", "idle"
            loadAnimDict(lib)
            TaskPlayAnim(playerPed, lib, anim, 5.0, -1, -1, 50, 0, false, false, false)
            AttachEntityToEntity(
                object,
                playerPed,
                boneIndex,
                0.0,
                0.0,
                -0.02,
                0.0,
                0.0,
                0.0,
                true,
                true,
                false,
                true,
                1,
                true
            )
            ESX.ShowNotification("撿起物件")
            iscarry = true
        elseif iscarry == true then
            local lib, anim = "anim@heists@load_box", "lift_box"
            ClearPedTasksImmediately(playerPed)
            loadAnimDict(lib)
            TaskPlayAnim(playerPed, lib, anim, 8.0, 1.0, -1, 2, 0, true, true, true)
            Citizen.Wait(2500)
            ClearPedTasksImmediately(playerPed)
            DetachEntity(object, false, false)
            ESX.ShowNotification("丟下物件")
            iscarry = false
        else
            ESX.ShowNotification("附近沒有物件")
        end
    end
)
