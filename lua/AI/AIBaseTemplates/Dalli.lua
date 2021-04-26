BaseBuilderTemplate {
    BaseTemplateName = 'Dalli',
    Builders = {
        -- Commander Builders
        'DalliCommanderBuilders',
        -- Engineer Builders
        'DalliEngineerBuilders',
        -- Mex Upgrade Builders
        'DalliMexUpgradeBuilders',
        -- Factory Builders
        'DalliFactoryEngineerBuilders',
        'DalliFactoryLandSpamBuilders',
        'DalliFactoryAirSpamBuilders',
        'DalliLandUpgradeBuilders',
        --'DalliAirFactoryUpgradeBuilders',
        -- Platoon Builders
        'DalliT1Platoons',
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
            return 1, 'Dalli'
        end
        if per != 'dalli' then
            return 1, 'Dalli'
        else
            return 9000, 'Dalli'
        end
    end,
}