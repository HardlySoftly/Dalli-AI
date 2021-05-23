local IBC = '/lua/editor/InstantBuildConditions.lua'
local DBC = '/mods/DalliAI/lua/editor/DalliBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'

-- Commander Builders
BuilderGroup {
    BuilderGroupName = 'DalliConstCommanderBuilders',
    BuildersType = 'EngineerBuilder',
    -- The initial build order
    Builder {
        BuilderName = 'DalliConstCommanderBaseSetupBuilderBase',
        PlatoonTemplate = 'DalliConstCommanderBuilder',
        Priority = 10000,
        BuilderConditions = {
                { IBC, 'NotPreBuilt', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddBehaviors = { 'CommanderBehaviorSorian' },
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            aggroCDR = true,
            Construction = {
                BuildStructures = {
                    -- Standard BO
                    'T1LandFactory',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1Resource',
                    'T1Resource',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1LandFactory',
                }
            }
        }
    },
}

-- Engineer Builders
BuilderGroup {
    BuilderGroupName = 'DalliConstEngineerBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'DalliConstEngineerBuildersMex',
        PlatoonTemplate = 'DalliConstEngineerMexBuilder',
        Priority = 1000,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'EngineerMexCoordinator', {}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder { -- T1 Pgen
        BuilderName = 'DalliConstEngineerBuildersPgenT1',
        PlatoonTemplate = 'DalliConstEngineerPgenT1Builder',
        Priority = 1500,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'EngineerPgenCoordinatorT1', {}}
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1EnergyProduction',
                }
            }
        }
    },
    Builder { -- T2 Pgen
        BuilderName = 'DalliConstEngineerBuildersPgenT2',
        PlatoonTemplate = 'DalliConstEngineerPgenT2Builder',
        Priority = 1500,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'EngineerPgenCoordinatorT2', {}}
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2EnergyProduction',
                }
            }
        }
    },
    Builder { -- T3 Pgen
        BuilderName = 'DalliConstEngineerBuildersPgenT3',
        PlatoonTemplate = 'DalliConstEngineerPgenT3Builder',
        Priority = 1500,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'EngineerPgenCoordinatorT3', {}}
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3EnergyProduction',
                }
            }
        }
    },
    Builder { -- T1 Hydro
        BuilderName = 'DalliConstEngineerBuildersHydro',
        PlatoonTemplate = 'DalliConstEngineerHydroBuilder',
        Priority = 1,
        InstanceCount = 1,
        BuilderConditions = {
            --{ DBC, 'EngineerPgenCoordinator', {}}
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1HydroCarbon',
                }
            }
        }
    },
    Builder { -- T1 Land Fac
        BuilderName = 'DalliConstEngineerBuildersT1LandFactory',
        PlatoonTemplate = 'DalliConstEngineerLandFactoryT1Builder',
        Priority = 1300,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'EngineerLandFactoryCoordinator', {}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory',
                }
            }
        }
    },
    Builder { -- T1 Air Fac
        BuilderName = 'DalliConstEngineerBuildersT1AirFactory',
        PlatoonTemplate = 'DalliConstEngineerAirFactoryT1Builder',
        Priority = 1300,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'EngineerAirFactoryCoordinator', {}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1EnergyProduction',
                    'T1AirFactory',
                    'T1EnergyProduction',
                }
            }
        }
    },
}