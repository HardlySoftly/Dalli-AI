BuilderGroup {
    BuilderGroupName = 'DalliT1Platoons',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'DalliT1LandScout',
        PlatoonTemplate = 'T1LandScoutForm',
        Priority = 400,
        InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
        },        
        BuilderConditions = { },
    },
    Builder {
        BuilderName = 'DalliT1Raiding',
        PlatoonTemplate = 'DalliT1Raid',
        Priority = 300,
        InstanceCount = 3,
        BuilderType = 'Any',
        BuilderData = {
            NeverGuardBases = true,
            NeverGuardEngineers = true,
        },        
        BuilderConditions = { },
    },
    Builder {
        BuilderName = 'DalliT1Attack',
        PlatoonTemplate = 'DalliT1Attack',
        Priority = 200,
        InstanceCount = 200,
        BuilderType = 'Any',
        BuilderData = {
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
        },        
        BuilderConditions = { },
    },
}