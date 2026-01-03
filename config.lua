Config = {}

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
