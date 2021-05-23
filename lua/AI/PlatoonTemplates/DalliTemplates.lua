PlatoonTemplate {
    Name = 'DalliConstCommanderBuilder',
    Plan = 'DalliFuncEngineerBuildAI',
    GlobalSquads = {
        { categories.COMMAND, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstEngineerMexBuilder',
    Plan = 'DalliFuncEngineerMexAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH1 - categories.COMMAND, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstEngineerPgenT1Builder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH1, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstEngineerHydroBuilder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH1, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstEngineerPgenT2Builder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH2, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstEngineerPgenT3Builder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH3, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstEngineerLandFactoryT1Builder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER, 2, 4, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstEngineerAirFactoryT1Builder',
    Plan = 'EngineerBuildAI',
    GlobalSquads = {
        { categories.ENGINEER, 1, 1, 'support', 'None' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstT1Raid',
    Plan = 'DalliFuncLandAssaultAI',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND * categories.TECH1 - categories.INDIRECTFIRE - categories.SCOUT - categories.ENGINEER - categories.xsl0402, 1, 3, 'attack', 'none' },
    },
}
PlatoonTemplate {
    Name = 'DalliConstT1Hunt',
    Plan = 'HuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.ENGINEER - categories.xsl0402, 3, 5, 'attack', 'none' },
    },
}
PlatoonTemplate {
    Name = 'DalliConstT1Attack',
    Plan = 'DalliFuncLandAssaultAI',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.ENGINEER - categories.xsl0402, 10, 200, 'attack', 'none' },
    },
}
PlatoonTemplate {
    Name = 'DalliConstT1AirDefense',
    Plan = 'InterceptorAI',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.ANTIAIR - categories.BOMBER - categories.TRANSPORTFOCUS - categories.EXPERIMENTAL, 3, 100, 'attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstT1AirAttack',
    Plan = 'StrikeForceAI',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.BOMBER, 5, 100, 'attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstT1AirRaid',
    Plan = 'StrikeForceAI',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.BOMBER, 1, 1, 'attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstT1AirUnitBombing',
    Plan = 'StrikeForceAI',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.BOMBER, 1, 1, 'attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'DalliConstT2SupportLandFactoryUpgrade',
    Plan = 'UnitUpgradeAI',
    GlobalSquads = {
        { categories.LAND * categories.FACTORY * categories.TECH2 * categories.BUILTBYTIER2ENGINEER, 1, 1, 'support', 'none' },
    }
}
