local DBC = '/mods/DalliAI/lua/editor/DalliBuildConditions.lua'

-- Engineer Builders
BuilderGroup {
    BuilderGroupName = 'DalliConstFactoryEngineerBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'DalliConstFactoryEngineerBuildersT1',
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
        BuilderName = 'DalliConstFactoryEngineerBuildersT2',
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
        BuilderName = 'DalliConstFactoryEngineerBuildersT3',
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
    BuilderGroupName = 'DalliConstFactoryLandSpamBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'DalliConstFactoryLandSpamBuildersT3Tank',
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
        BuilderName = 'DalliConstFactoryLandSpamBuildersT2Tank',
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
        BuilderName = 'DalliConstFactoryLandSpamBuildersT1Tank',
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
        BuilderName = 'DalliConstFactoryLandSpamBuildersT1Scout',
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
        BuilderName = 'DalliConstFactoryLandSpamBuildersT1Arty',
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
        BuilderName = 'DalliConstFactoryLandSpamBuildersT1AA',
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
        BuilderName = 'DalliConstFactoryLandSpamBuildersT2AA',
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
    BuilderGroupName = 'DalliConstFactoryAirSpamBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'DalliConstFactoryAirSpamBuildersT1Scout',
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
        BuilderName = 'DalliConstFactoryAirSpamBuildersT1Bomber',
        PlatoonTemplate = 'T1AirBomber',
        Priority = 1200,
        BuilderConditions = {
            { DBC, 'AirBomberCoordinator', {} },
        },
        InstantCheck = true,
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'DalliConstFactoryAirSpamBuildersT1Intie',
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
    BuilderGroupName = 'DalliConstLandUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'DalliConstT1LandHQUpgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 3000,
        InstanceCount = 1,
        BuilderConditions = {
            { DBC, 'T1LandUpgradeCoordinator', {} },
        },
        FormRadius = 1000000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'DalliConstT2LandHQUpgrade',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 3000,
        InstanceCount = 1,
        BuilderConditions = {
            { DBC, 'T2LandUpgradeCoordinator', {} },
        },
        FormRadius = 1000000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'DalliConstT1LandSupportUpgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 3000,
        InstanceCount = 1,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9501', 'zab9501', 'zrb9501', 'zsb9501', 'znb9501' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { DBC, 'T1SupportLandUpgradeCoordinator', {} },
        },
        FormRadius = 1000000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'DalliConstT2LandSupportUpgrade',
        PlatoonTemplate = 'DalliConstT2SupportLandFactoryUpgrade',
        Priority = 3000,
        InstanceCount = 1,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { DBC, 'T2SupportLandUpgradeCoordinator', {} },
        },
        FormRadius = 1000000,
        BuilderType = 'Any',
    },
}


