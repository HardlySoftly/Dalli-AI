PlatoonTemplate {
    Name = 'DalliEngineerMexBuilder',
    Plan = 'DalliEngineerMexAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH1 - categories.COMMAND, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliEngineerPgenT1Builder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH1, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliEngineerPgenT2Builder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH2, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliEngineerPgenT3Builder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH3, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliEngineerLandFactoryT1Builder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER, 2, 4, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliEngineerAirFactoryT1Builder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliT1Raid',
    Plan = 'StrikeForceAI',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.INDIRECTFIRE - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 2, 10, 'attack', 'none' },
    },
}
PlatoonTemplate {
    Name = 'DalliT1Attack',
    Plan = 'StrikeForceAI',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 200, 'attack', 'none' },
    },
}
