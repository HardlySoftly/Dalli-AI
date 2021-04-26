local DBC = '/mods/DalliAI/lua/editor/DalliBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'DalliMexUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'DalliT1MexUpgrade',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 10,
        Priority = 1,
        BuilderConditions = {
            { DBC, 'T1MexUpgradeCoordinator', {} },
        },
        FormRadius = 1000000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'DalliT2MexUpgrade',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 1,
        InstanceCount = 10,
        BuilderConditions = {
            { DBC, 'T2MexUpgradeCoordinator', {} },
        },
        FormRadius = 1000000,
        BuilderType = 'Any',
    },
}
