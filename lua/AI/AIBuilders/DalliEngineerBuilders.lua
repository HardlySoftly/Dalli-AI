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
        PlatoonTemplate = 'CommanderBuilder',
        Priority = 10000,
        BuilderConditions = {
                { IBC, 'NotPreBuilt', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddBehaviors = { 'CommanderBehaviorSorian' },
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
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
            { DBC, 'EngineerPgenCoordinator', {}}
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1EnergyProduction',
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
}