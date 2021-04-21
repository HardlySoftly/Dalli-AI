--[[
    File    :   /lua/AI/AIBuilders/DalliFactoryBuilders.lua
    Author  :   Softles
    Summary :
        Factory Builders for Dalli.
        If a factory is making units, that behaviour is controlled here.
        
        BuilderGroupName naming convention is "Dalli<ProducingUnit><ProducedUnitType><ProductionReason>Builders"
        BuilderName naming convention is "<BuilderGroupName><ProducedUnit>"
]]

local DBC = '/mods/DalliAI/lua/editor/DalliBuildConditions.lua'
local SBC = '/lua/editor/SorianBuildConditions.lua'

-- Engineer Builders
BuilderGroup {
    BuilderGroupName = 'DalliFactoryEngineerBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'DalliFactoryEngineerBuildersT1',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 4000,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'FactoryEngineerCoordinator', {} },
        },
        InstantCheck = false,
        BuilderType = 'All',
    }
}

-- Land Spam
BuilderGroup {
    BuilderGroupName = 'DalliFactoryT1LandSpamBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'DalliFactoryLandSpamBuildersT1Tank',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 1000,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'LandSpamCoordinator', {} },
        },
        InstantCheck = false,
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'DalliFactoryLandSpamBuildersT1Scout',
        PlatoonTemplate = 'T1LandScout',
        Priority = 1300,
        InstanceCount = 1,
        BuilderConditions = {
            { DBC, 'LandScoutCoordinator', {} },
        },
        InstantCheck = true,
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'DalliFactoryLandSpamBuildersT1Arty',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 1100,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'LandArtyCoordinator', {} },
        },
        InstantCheck = false,
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'DalliFactoryLandSpamBuildersT1AA',
        PlatoonTemplate = 'T1LandAA',
        Priority = 1200,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'LandAACoordinator', {} },
        },
        InstantCheck = false,
        BuilderType = 'All',
    },
}


