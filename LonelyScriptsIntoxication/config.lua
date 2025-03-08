Config = {}
Config.DrunkVehicleTick = 800
Config.MinSpeedForEffects = 1.0

Config.DrunkLevels = {
    [1] = {
        timecycle = "spectator5", -- The Visual Drunk Effect in question
        timecycleStrength = 0.7, -- The "visual drunk effect" strength
        shakeIntensity = 1.0,
        screenEffect = "DrugsDrivingIn",
        swerveChance = 65,
        handbrakeChance = 10,
        invertChance = 5,
        swerveDuration = 200,
        invertDuration = 500,
    },
    [2] = {
        timecycle = "spectator5", -- The Visual Drunk Effect in question
        timecycleStrength = 0.85,  -- The "visual drunk effect" strength
        shakeIntensity = 1.5,
        screenEffect = "MP_race_crash",
        swerveChance = 75,
        handbrakeChance = 12,
        invertChance = 5,
        swerveDuration = 400,
        invertDuration = 500,
    },
    [3] = {
        timecycle = "spectator5", -- The Visual Drunk Effect in question
        timecycleStrength = 1.1,  -- The "visual drunk effect" strength
        shakeIntensity = 1.5,
        screenEffect = "DMT_flight_intro",
        swerveChance = 80,
        handbrakeChance = 15,
        invertChance = 5,
        swerveDuration = 600,
        invertDuration = 500,
    },
}
