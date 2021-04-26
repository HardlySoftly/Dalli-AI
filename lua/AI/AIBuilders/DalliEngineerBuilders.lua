local IBC = '/lua/editor/InstantBuildConditions.lua'
local DBC = '/mods/DalliAI/lua/editor/DalliBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'

-- Commander Builders
BuilderGroup {
    BuilderGroupName = 'DalliCommanderBuilders',
    BuildersType = 'EngineerBuilder',
    -- The initial build order
    Builder {
        BuilderName = 'DalliCommanderBaseSetupBuilderBase',
        PlatoonTemplate = 'CommanderBuilderDalli',
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
    BuilderGroupName = 'DalliEngineerBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'DalliEngineerBuildersMex',
        PlatoonTemplate = 'DalliEngineerMexBuilder',
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
        BuilderName = 'DalliEngineerBuildersPgenT1',
        PlatoonTemplate = 'DalliEngineerPgenT1Builder',
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
        BuilderName = 'DalliEngineerBuildersPgenT2',
        PlatoonTemplate = 'DalliEngineerPgenT2Builder',
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
        BuilderName = 'DalliEngineerBuildersPgenT3',
        PlatoonTemplate = 'DalliEngineerPgenT3Builder',
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
        BuilderName = 'DalliEngineerBuildersHydro',
        PlatoonTemplate = 'DalliEngineerHydroBuilder',
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
        BuilderName = 'DalliEngineerBuildersT1LandFactory',
        PlatoonTemplate = 'DalliEngineerLandFactoryT1Builder',
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
        BuilderName = 'DalliEngineerBuildersT1AirFactory',
        PlatoonTemplate = 'DalliEngineerAirFactoryT1Builder',
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