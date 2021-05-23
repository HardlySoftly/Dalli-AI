BaseBuilderTemplate {
    BaseTemplateName = 'DalliConstBTN',
    Builders = {
        -- Commander Builders
        'DalliConstCommanderBuilders',
        -- Engineer Builders
        'DalliConstEngineerBuilders',
        -- Mex Upgrade Builders
        'DalliConstMexUpgradeBuilders',
        -- Factory Builders
        'DalliConstFactoryEngineerBuilders',
        'DalliConstFactoryLandSpamBuilders',
        'DalliConstFactoryAirSpamBuilders',
        'DalliConstLandUpgradeBuilders',
        --'DalliAirFactoryUpgradeBuilders',
        -- Platoon Builders
        'DalliConstPlatoons',
    },
    NonCheatBuilders = {
        -- I'm so good I don't need to cheat
    },
    BaseSettings = {

    },
    ExpansionFunction = function(aiBrain, location, markerType)
        -- Expanding is for casuals (and people who know how this works, which I don't...)
        return 0
    end,

    FirstBaseFunction = function(aiBrain)
        local per = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if not per then 
            return 1, 'DalliConstBTN'
        end
        if per != 'DalliConstAIKey' then
            return 1, 'DalliConstBTN'
        else
            return 9000, 'DalliConstBTN'
        end
    end,
}