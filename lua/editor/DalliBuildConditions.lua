-- Engies
function EngineerMexCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('DalliConstEngineerMexBuilder')
    return count < aiBrain.DalliBrain.bpc.m1
end
function EngineerPgenCoordinatorT1(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('DalliConstEngineerPgenT1Builder')
    return count < aiBrain.DalliBrain.bpc.p1
end
function EngineerPgenCoordinatorT2(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('DalliConstEngineerPgenT2Builder')
    return count < aiBrain.DalliBrain.bpc.p2
end
function EngineerPgenCoordinatorT3(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('DalliConstEngineerPgenT3Builder')
    return count < aiBrain.DalliBrain.bpc.p3
end
function EngineerLandFactoryCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('DalliConstEngineerLandFactoryT1Builder')
    return count < aiBrain.DalliBrain.bpc.lf1
end
function EngineerAirFactoryCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('DalliConstEngineerAirFactoryT1Builder')
    return count < aiBrain.DalliBrain.bpc.af1
end
-- Factory generic
function FactoryEngineerCoordinatorT1(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1BuildEngineer')
    return count < aiBrain.DalliBrain.bpc.e1
end
function FactoryEngineerCoordinatorT2(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T2BuildEngineer')
    return count < aiBrain.DalliBrain.bpc.e2
end
function FactoryEngineerCoordinatorT3(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T3BuildEngineer')
    return count < aiBrain.DalliBrain.bpc.e3
end
-- Air
function AirIntieCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1AirFighter')
    return count < aiBrain.DalliBrain.apc.i1
end
function AirScoutCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1AirScout')
    return count < aiBrain.DalliBrain.apc.s1
end
function AirBomberCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1AirBomber')
    return count < aiBrain.DalliBrain.apc.b1
end
-- Land
function LandSpamCoordinatorT1(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1LandDFTank')
    return count < aiBrain.DalliBrain.lpc.t1
end
function LandSpamCoordinatorT2(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T2LandDFTank')
    return count < aiBrain.DalliBrain.lpc.t2
end
function LandSpamCoordinatorT3(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T3LandDFTank')
    return count < aiBrain.DalliBrain.lpc.t3
end
function LandScoutCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1LandScout')
    return count < aiBrain.DalliBrain.lpc.s1
end
function LandArtyCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1LandArtillery')
    return count < aiBrain.DalliBrain.lpc.i1
end
function LandAACoordinatorT1(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1LandAA')
    return count < aiBrain.DalliBrain.lpc.a1
end
function LandAACoordinatorT2(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T2LandAA')
    return count < aiBrain.DalliBrain.lpc.a2
end
function T1LandUpgradeCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1LandFactoryUpgrade')
    return count < aiBrain.DalliBrain.bpc.lf2
end
function T2LandUpgradeCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T2LandFactoryUpgrade')
    return count < aiBrain.DalliBrain.bpc.lf3
end
function T1SupportLandUpgradeCoordinator(aiBrain)
    local numHQFacs = table.getn(aiBrain:GetListOfUnits((categories.FACTORY*categories.LAND*categories.TECH2 + categories.FACTORY*categories.LAND*categories.TECH3) - categories.BUILTBYTIER3ENGINEER,false,true))
    local numT2Engies = table.getn(aiBrain:GetListOfUnits(categories.ENGINEER*categories.TECH2+categories.ENGINEER*categories.TECH3,false,true))
    return (numHQFacs > 0) and (numT2Engies > 0)
end
function T2SupportLandUpgradeCoordinator(aiBrain)
    local numHQFacs = table.getn(aiBrain:GetListOfUnits(categories.FACTORY*categories.LAND*categories.TECH3 - categories.BUILTBYTIER3ENGINEER,false,true))
    local numT3Engies = table.getn(aiBrain:GetListOfUnits(categories.ENGINEER*categories.TECH3,false,true))
    return (numHQFacs > 0) and (numT3Engies > 0)
end
-- Mexes
function T1MexUpgradeCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1MassExtractorUpgrade')
    return count < aiBrain.DalliBrain.bpc.mu1
end
function T2MexUpgradeCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T2MassExtractorUpgrade')
    return count < aiBrain.DalliBrain.bpc.mu2
end
