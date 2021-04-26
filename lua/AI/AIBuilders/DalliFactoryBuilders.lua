local DBC = '/mods/DalliAI/lua/editor/DalliBuildConditions.lua'

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
            { DBC, 'FactoryEngineerCoordinatorT1', {} },
        },
        InstantCheck = false,
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'DalliFactoryEngineerBuildersT2',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 4100,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'FactoryEngineerCoordinatorT2', {} },
        },
        InstantCheck = false,
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'DalliFactoryEngineerBuildersT3',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 4200,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'FactoryEngineerCoordinatorT3', {} },
        },
        InstantCheck = false,
        BuilderType = 'All',
    }
}

-- Land Spam
BuilderGroup {
    BuilderGroupName = 'DalliFactoryLandSpamBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'DalliFactoryLandSpamBuildersT3Tank',
        PlatoonTemplate = 'T3LandBot',
        Priority = 1900,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'LandSpamCoordinatorT3', {} },
        },
        InstantCheck = false,
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'DalliFactoryLandSpamBuildersT2Tank',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 1001,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'LandSpamCoordinatorT2', {} },
        },
        InstantCheck = false,
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'DalliFactoryLandSpamBuildersT1Tank',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 1000,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'LandSpamCoordinatorT1', {} },
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
            { DBC, 'LandAACoordinatorT1', {} },
        },
        InstantCheck = false,
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'DalliFactoryLandSpamBuildersT2AA',
        PlatoonTemplate = 'T2LandAA',
        Priority = 1200,
        InstanceCount = 1000,
        BuilderConditions = {
            { DBC, 'LandAACoordinatorT2', {} },
        },
        InstantCheck = false,
        BuilderType = 'All',
    },
}
-- Air Spam
BuilderGroup {
    BuilderGroupName = 'DalliFactoryAirSpamBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'DalliFactoryAirSpamBuildersT1Scout',
        PlatoonTemplate = 'T1AirScout',
        Priority = 1300,
        InstanceCount = 1,
        BuilderConditions = {
            { DBC, 'AirScoutCoordinator', {} },
        },
        InstantCheck = true,
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'DalliFactoryAirSpamBuildersT1Bomber',
        PlatoonTemplate = 'T1AirBomber',
        Priority = 1200,
        BuilderConditions = {
            { DBC, 'AirBomberCoordinator', {} },
        },
        InstantCheck = true,
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'DalliFactoryAirSpamBuildersT1Intie',
        PlatoonTemplate = 'T1AirFighter',
        Priority = 1000,
        BuilderConditions = {
            { DBC, 'AirIntieCoordinator', {} },
        },
        InstantCheck = true,
        BuilderType = 'All',
    },
}

-- Hmm. Upgrades.
BuilderGroup {
    BuilderGroupName = 'DalliLandUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T1LandHQUpgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 3000,
        InstanceCount = 1,
        BuilderConditions = {
            { DBC, 'T1LandUpgradeCoordinator', {} },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2LandHQUpgrade',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 3000,
        InstanceCount = 1,
        BuilderConditions = {
            { DBC, 'T2LandUpgradeCoordinator', {} },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T1LandSupportUpgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 3000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9501', 'zab9501', 'zrb9501', 'zsb9501', 'znb9501' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { DBC, 'T1SupportLandUpgradeCoordinator', {} },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2LandSupportUpgrade',
        PlatoonTemplate = 'T2SupportLandFactoryUpgrade',
        Priority = 3000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { DBC, 'T2SupportLandUpgradeCoordinator', {} },
        },
        BuilderType = 'Any',
    },
}


