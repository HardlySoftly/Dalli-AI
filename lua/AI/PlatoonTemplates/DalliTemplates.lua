PlatoonTemplate {
    Name = 'CommanderBuilderDalli',
    Plan = 'EngineerBuildAIDalli',
    GlobalSquads = {
        { categories.COMMAND, 1, 1, 'support', 'None' },
    }
}
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
        { categories.ENGINEER * categories.TECH2, 3, 3, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliEngineerPgenT3Builder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH3, 3, 3, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliEngineerHydroBuilder',
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
        { categories.MOBILE * categories.LAND * categories.TECH1 - categories.INDIRECTFIRE - categories.SCOUT - categories.ENGINEER - categories.xsl0402, 1, 3, 'attack', 'none' },
    },
}
PlatoonTemplate {
    Name = 'DalliT1Hunt',
    Plan = 'HuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.ENGINEER - categories.xsl0402, 3, 5, 'attack', 'none' },
    },
}
PlatoonTemplate {
    Name = 'DalliT1Attack',
    Plan = 'StrikeForceAI',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.ENGINEER - categories.xsl0402, 10, 200, 'attack', 'none' },
    },
}
PlatoonTemplate {
    Name = 'DalliT1AirDefense',
    Plan = 'InterceptorAI',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.ANTIAIR - categories.BOMBER - categories.TRANSPORTFOCUS - categories.EXPERIMENTAL, 3, 100, 'attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'DalliT1AirAttack',
    Plan = 'StrikeForceAI',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.BOMBER, 5, 100, 'attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'DalliT1AirRaid',
    Plan = 'StrikeForceAI',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.BOMBER, 1, 1, 'attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'DalliT1AirUnitBombing',
    Plan = 'StrikeForceAI',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.BOMBER, 1, 1, 'attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'T2SupportLandFactoryUpgrade',
    Plan = 'UnitUpgradeAI',
    GlobalSquads = {
        { categories.LAND * categories.FACTORY * categories.TECH2 * categories.BUILTBYTIER2ENGINEER, 1, 1, 'support', 'none' },
    }
}
