function EngineerMexCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('DalliEngineerMexBuilder')
    return count < aiBrain.DalliBrain.bpc.m1
end
function EngineerPgenCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('DalliEngineerPgenT1Builder')
    return count < aiBrain.DalliBrain.bpc.p1
end
function EngineerLandFactoryCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('DalliEngineerLandFactoryT1Builder')
    return count < aiBrain.DalliBrain.bpc.lf1
end
function LandSpamCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1LandDFTank')
    return count < aiBrain.DalliBrain.lpc.t1
end
function LandScoutCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1LandScout')
    return count < aiBrain.DalliBrain.lpc.s1
end
function LandArtyCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1LandArtillery')
    return count < aiBrain.DalliBrain.lpc.i1
end
function LandAACoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1LandAA')
    return count < aiBrain.DalliBrain.lpc.a1
end
function FactoryEngineerCoordinator(aiBrain)
    local count = aiBrain:GetNumPlatoonsTemplateNamed('T1BuildEngineer')
    return count < aiBrain.DalliBrain.bpc.e1
end
