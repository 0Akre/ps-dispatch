
local playAnim = false
local phoneProp = 0
local phoneModel = Config.PhoneModel
Config.BlipTime = 120


-- Item checks to return whether or not the client has a phone or not
local function HasPhone()
    return QBCore.Functions.HasItem("phone")
end


-- Loads the animdict so we can execute it on the ped
local function loadAnimDict(dict)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

local function DeletePhone()
	if phoneProp ~= 0 then
		DeleteObject(phoneProp)
		phoneProp = 0
	end
end

local function NewPropWhoDis()
	DeletePhone()
	RequestModel(phoneModel)
	while not HasModelLoaded(phoneModel) do
		Wait(1)
	end
	phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)

	local bone = GetPedBoneIndex(PlayerPedId(), 28422)
	if phoneModel == Config.PhoneModel then
		AttachEntityToEntity(phoneProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 15.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
	else
		AttachEntityToEntity(phoneProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
	end
end

-- Does the actual animation of the animation when calling 911
local function PhoneCallAnim()
    loadAnimDict("cellphone@")
    local ped = PlayerPedId()
    CreateThread(function()
        NewPropWhoDis()
        playAnim = true
        while playAnim do
            if not IsEntityPlayingAnim(ped, "cellphone@", 'cellphone_text_to_call', 3) then
                TaskPlayAnim(ped, "cellphone@", 'cellphone_text_to_call', 3.0, 3.0, -1, 50, 0, false, false, false)
            end
            Wait(100)
        end
    end)
end

RegisterCommand('panic', function(source, args, rawCommand)
    if last ~= nil and (GetGameTimer() - last) < 30000 then
        QBCore.Functions.Notify("Wait 30 seconds to turn on again!", "error", 4500)
		return
	end
    local Player = QBCore.Functions.GetPlayerData()
    local jobName = Player.job.name
     if jobName == "police" then 
     else
        QBCore.Functions.Notify("You are not Law Enforcement to use the PANIC BUTTON!", "error", 4500)
     end
     playerCoords = GetEntityCoords(PlayerPedId())
     local Blip = AddBlipForRadius(playerCoords.x, playerCoords.y, playerCoords.z, 100.0)
    SetBlipRoute(Blip, true)
    SetBlipAlpha(Blip, 0)
    CreateThread(function()
        while Blip do
            SetBlipRouteColour(Blip, 76)
            Wait(Config.BlipTime * 1000)
            RemoveBlip(Blip)
        end
    end)
        local msg = rawCommand:sub(5)
        if string.len(msg) > 0 then
            if not exports['qb-policejob']:IsHandcuffed() then
                if HasPhone() then
                    local plyData = QBCore.Functions.GetPlayerData()
                    local currentPos = GetEntityCoords(PlayerPedId())
                    local locationInfo = getStreetandZone(currentPos)
                    QBCore.Functions.Notify('You used the Panic Button, the location was sent to all active units!', "success", 4500)
                    TriggerServerEvent("dispatch:server:notify",{
                        dispatchcodename = "alert20",
                        dispatchCode = "10-99",
                        firstStreet = locationInfo,
                        priority = 1,
                        name = PlayerData.job.grade.name..' '.. plyData.charinfo.firstname:sub(1, 1):upper() .. plyData.charinfo.firstname:sub(2) .. " " .. plyData.charinfo.lastname:sub(1, 1):upper() .. plyData.charinfo.lastname:sub(2) .. ' needs help',
                        origin = {
                            x = currentPos.x,
                            y = currentPos.y,
                            z = currentPos.z
                        },
                        dispatchMessage = ('Officer in danger'),
                        job = { "ambulance", "police" }
                    })
                else
                    QBCore.Functions.Notify("You can't call without a Phone!", "error", 4500)
                end
            else
                QBCore.Functions.Notify("You can't call police while handcuffed!", "error", 4500)
            end
        else
            QBCore.Functions.Notify('Please put a reason after the 911', "success")
        end
    end)

RegisterKeyMapping('panic', 'Turn on the Panic Button', 'keyboard', '')

-- Regular 911 call that goes straight to the Police
RegisterCommand('911', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    if string.len(msg) > 0 then
        if not exports['qb-policejob']:IsHandcuffed() then
            if HasPhone() then
                PhoneCallAnim()
                Wait(RandomNum(3,8) * 1000)
                playAnim = false
                local plyData = QBCore.Functions.GetPlayerData()
                local currentPos = GetEntityCoords(PlayerPedId())
                local locationInfo = getStreetandZone(currentPos)
                local gender = GetPedGender()
                TriggerServerEvent("dispatch:server:notify",{
                    dispatchcodename = "911call", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
                    dispatchCode = "911",
                    firstStreet = locationInfo,
                    priority = 2, -- priority
                    name = plyData.charinfo.firstname:sub(1,1):upper()..plyData.charinfo.firstname:sub(2).. " ".. plyData.charinfo.lastname:sub(1,1):upper()..plyData.charinfo.lastname:sub(2),
                    number = plyData.charinfo.phone,
                    origin = {
                        x = currentPos.x,
                        y = currentPos.y,
                        z = currentPos.z
                    },
                    dispatchMessage = "Incoming Call", -- message
                    information = msg,
                    job = {"police", "ambulance"} -- jobs that will get the alerts
                })
                Wait(1000)
                DeletePhone()
                StopEntityAnim(PlayerPedId(), 'cellphone_text_to_call', "cellphone@", 3)
            else
                QBCore.Functions.Notify("You can't call without a Phone!", "error", 4500)
            end
        else
            QBCore.Functions.Notify("You can't call police while handcuffed!", "error", 4500)
        end
    else
        QBCore.Functions.Notify('Please put a reason after the 911', "success")
    end
end)

RegisterCommand('911a', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    if string.len(msg) > 0 then
        if not exports['qb-policejob']:IsHandcuffed() then
            if HasPhone() then
                PhoneCallAnim()
                Wait(RandomNum(3,8) * 1000)
                playAnim = false
                local plyData = QBCore.Functions.GetPlayerData()
                local currentPos = GetEntityCoords(PlayerPedId())
                local locationInfo = getStreetandZone(currentPos)
                local gender = GetPedGender()
                TriggerServerEvent("dispatch:server:notify",{
                    dispatchcodename = "911call", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
                    dispatchCode = "911",
                    firstStreet = locationInfo,
                    priority = 2, -- priority
                    name = "Anonymous",
                    number = "Hidden Number",
                    origin = {
                        x = currentPos.x,
                        y = currentPos.y,
                        z = currentPos.z
                    },
                    dispatchMessage = "Incoming Anonymous Call", -- message
                    information = msg,
                    job = {"police", "ambulance"} -- jobs that will get the alerts
                })
                Wait(1000)
                DeletePhone()
                StopEntityAnim(PlayerPedId(), 'cellphone_text_to_call', "cellphone@", 3)
            else
                QBCore.Functions.Notify("You can't call without a Phone!", "error", 4500)
            end
        else
            QBCore.Functions.Notify("You can't call police while handcuffed!", "error", 4500)
        end
    else
        QBCore.Functions.Notify('Please put a reason after the 911', "success")
    end
end)

-- Regular 311 call that goes straight to the Police
RegisterCommand('311', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    if string.len(msg) > 0 then
        if not exports['qb-policejob']:IsHandcuffed() then
            if HasPhone() then
                PhoneCallAnim()
                Wait(RandomNum(3,8) * 1000)
                playAnim = false
                local plyData = QBCore.Functions.GetPlayerData()
                local currentPos = GetEntityCoords(PlayerPedId())
                local locationInfo = getStreetandZone(currentPos)
                local gender = GetPedGender()
                TriggerServerEvent("dispatch:server:notify",{
                    dispatchcodename = "311call", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
                    dispatchCode = "311",
                    firstStreet = locationInfo,
                    priority = 2, -- priority
                    name = plyData.charinfo.firstname:sub(1,1):upper()..plyData.charinfo.firstname:sub(2).. " ".. plyData.charinfo.lastname:sub(1,1):upper()..plyData.charinfo.lastname:sub(2),
                    number = plyData.charinfo.phone,
                    origin = {
                        x = currentPos.x,
                        y = currentPos.y,
                        z = currentPos.z
                    },
                    dispatchMessage = "Incoming Call", -- message
                    information = msg,
                    job = {"police", "ambulance"} -- jobs that will get the alerts
                })
                Wait(1000)
                DeletePhone()
                StopEntityAnim(PlayerPedId(), 'cellphone_text_to_call', "cellphone@", 3)
            else
                QBCore.Functions.Notify("You can't call without a Phone!", "error", 4500)
            end
        else
            QBCore.Functions.Notify("You can't call police while handcuffed!", "error", 4500)
        end
    else
        QBCore.Functions.Notify('Please put a reason after the 911', "success")
    end
end)

-- Regular 311 call that goes straight to the Police
RegisterCommand('311a', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    if string.len(msg) > 0 then
        if not exports['qb-policejob']:IsHandcuffed() then
            if HasPhone() then
                PhoneCallAnim()
                Wait(RandomNum(3,8) * 1000)
                playAnim = false
                local plyData = QBCore.Functions.GetPlayerData()
                local currentPos = GetEntityCoords(PlayerPedId())
                local locationInfo = getStreetandZone(currentPos)
                local gender = GetPedGender()
                TriggerServerEvent("dispatch:server:notify",{
                    dispatchcodename = "311call", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
                    dispatchCode = "311",
                    firstStreet = locationInfo,
                    priority = 2, -- priority
                    name = "Anonymous",
                    number = "Hidden Number",
                    origin = {
                        x = currentPos.x,
                        y = currentPos.y,
                        z = currentPos.z
                    },
                    dispatchMessage = "Incoming Call", -- message
                    information = msg,
                    job = {"police", "ambulance"} -- jobs that will get the alerts
                })
                Wait(1000)
                DeletePhone()
                StopEntityAnim(PlayerPedId(), 'cellphone_text_to_call', "cellphone@", 3)
            else
                QBCore.Functions.Notify("You can't call without a Phone!", "error", 4500)
            end
        else
            QBCore.Functions.Notify("You can't call police while handcuffed!", "error", 4500)
        end
    else
        QBCore.Functions.Notify('Please put a reason after the 911', "success")
    end
end)


Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/911', 'Send a message to the police.', {{ name="message", help="Message to police."}})
    TriggerEvent('chat:addSuggestion', '/911a', 'Send a message to the police anonymously.', {{ name="message", help="Message to police anonymous."}})
    TriggerEvent('chat:addSuggestion', '/311', 'Send a message to the EMS.', {{ name="message", help="Message to EMS."}})
    TriggerEvent('chat:addSuggestion', '/311a', 'Send a message to the EMS anonymously.', {{ name="message", help="Message to EMS anonymous."}})
    TriggerEvent('chat:addSuggestion', '/panic', 'Turn on Panic Button.')
end)
