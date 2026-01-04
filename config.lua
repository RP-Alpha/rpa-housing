Config = {}

--[[
    ==========================================
    PERMISSIONS
    ==========================================
    
    server.cfg examples:
    setr rpa_housing:admin "steam:110000123456789,license:abc123"
    setr rpa_housing:realtor "steam:110000987654321"
]]

-- Who can use housing admin commands (force evict, set ownership, etc.)
Config.AdminPermissions = {
    groups = {'admin', 'god'},
    resourceConvar = 'admin'
}

-- Who can sell houses to players (realtor job or admin)
Config.RealtorPermissions = {
    groups = {'admin', 'god'},
    jobs = {'realestate', 'realtor'},
    minGrade = 0,
    resourceConvar = 'realtor'
}

-- Who can break into houses (for police raids, etc.)
Config.RaidPermissions = {
    groups = {'admin', 'god'},
    jobs = {'police', 'bcso', 'sasp'},
    minGrade = 3,
    onDuty = true,
    resourceConvar = 'raid'
}

Config.Shells = {
    ['tier1'] = {
        model = 'shell_tier1' -- Requires a shell prop resource
    }
}

Config.Houses = {
    ['house_1'] = {
        label = "123 Grove St",
        coords = vector4(114.2, -1961.3, 21.3, 270.0),
        price = 100000,
        tier = 'tier1'
    }
}
