# QBCore Dispatch

Integrated with [ps-mdt](https://github.com/Project-Sloth/ps-mdt)

For all support questions, ask in our [Discord](https://discord.com/invite/projectsloth) support chat. Do not create issues on GitHub if you need help. Issues are for bug reporting and new features only.

# Installation
- Download ZIP
- Drag and drop resource into your server files
- Start resource through server.cfg
- Drag and drop sounds folder into interact-sound\client\html\sounds
- Restart your server.

# Preset Alert Exports.

- exports['ps-dispatch']:VehicleShooting(vehicle)

- exports['ps-dispatch']:Shooting()

- exports['ps-dispatch']:OfficerDown()

- exports['ps-dispatch']:SpeedingVehicle(vehicle)

- exports['ps-dispatch']:Fight()

- exports['ps-dispatch']:InjuriedPerson()

- exports['ps-dispatch']:DeceasedPerson()

- exports['ps-dispatch']:StoreRobbery(camId)

- exports['ps-dispatch']:FleecaBankRobbery(camId)

- exports['ps-dispatch']:PaletoBankRobbery(camId)

- exports['ps-dispatch']:PacificBankRobbery(camId)

- exports['ps-dispatch']:PrisonBreak()

- exports['ps-dispatch']:VangelicoRobbery(camId)

- exports['ps-dispatch']:HouseRobbery()

- exports['ps-dispatch']:DrugSale()

- exports['ps-dispatch']:ArtGalleryRobbery()

- exports['ps-dispatch']:HumaneRobery()

- exports['ps-dispatch']:TrainRobbery()

- exports['ps-dispatch']:VanRobbery()

- exports['ps-dispatch']:UndergroundRobbery()

- exports['ps-dispatch']:DrugBoatRobbery()

- exports['ps-dispatch']:UnionRobbery()

- exports['ps-dispatch']:YachtHeist()

- exports['ps-dispatch']:CarBoosting(vehicle)

- exports['ps-dispatch']:CarJacking(vehicle)

- exports['ps-dispatch']:VehicleTheft(vehicle)

- exports['ps-dispatch']:SuspiciousActivity()

- exports['ps-dispatch']:SignRobbery()

# Sample Preview

![image](https://github.com/0Akre/ps-dispatch/assets/142453915/52cfe971-2547-4eaf-9f8c-96070a6d4a18)


# Configuring Departments
1. Open config.lua and add all the jobs you want to use for the alerts

Config.AuthorizedJobs = {
    LEO = { -- this is for job checks which should only return true for police officers
        Jobs = {['police'] = true, ['fib'] = true, ['sheriff'] = true},
        Types = {['police'] = true, ['leo'] = true},
        ...
    },
    EMS = { -- this if for job checks which should only return true for ems workers
        Jobs = {['ambulance'] = true, ['fire'] = true},
        Types = {['ambulance'] = true, ['fire'] = true, ['ems'] = true},
        ...
    },
    ...
}

- Jobs is the list of jobs that will be checked for the department
- Types is the list of job types that will be checked for the department
- The Check and FirstResponder tables should not be edited
