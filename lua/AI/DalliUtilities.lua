function DalliFuncGetUnitsInRadius(pos,radius)
    local cornerDist = 1.4142*radius --math.sqrt(radius*radius + radius*radius)
    -- Diamond around units
    local units = GetUnitsInRect(Rect(pos[1]-cornerDist, pos[3]-cornerDist, pos[1]+cornerDist, pos[3]+cornerDist))
    if not units then
        return {}
    end
    -- Filter to actual circle
    local n = 0
    local ret = {}
    for _, unit in units do
        local unitPos = unit:GetPosition()
        local dist = VDist2(pos[1], pos[3], unitPos[1], unitPos[3])
        if dist < radius then
            n = n+1
            ret[n] = unit
        end
    end
    return ret
end

function DalliFuncGetAlliedUnits(armyIndex,units)
    local n = 0
    ret = {}
    for _, unit in units do
        if IsAlly(armyIndex,unit:GetArmy()) then
            n = n+1
            ret[n] = unit
        end
    end
    return ret
end

function DalliFuncGetEnemyUnits(armyIndex,units)
    local n = 0
    ret = {}
    for _, unit in units do
        if IsEnemy(armyIndex,unit:GetArmy()) then
            -- Check for intel
            local blip = unit:GetBlip(armyIndex)
            if blip and (blip:IsOnRadar(armyIndex) or blip:IsSeenEver(armyIndex)) then
                n = n+1
                ret[n] = unit
            end
        end
    end
    return ret
end

local DalliConstLandThreatTable = {}
function DalliFuncGetLandThreat(unit)
    if DalliConstLandThreatTable[unit.UnitId] then
        return DalliConstLandThreatTable[unit.UnitId]
    end
    local threat = 0
    if EntityCategoryContains(categories.COMMAND,unit) then
        threat = 20
    elseif EntityCategoryContains(categories.STRUCTURE,unit) then
        threat = 0
        if EntityCategoryContains(categories.DIRECTFIRE,unit) then
            threat = 5
        end
    elseif EntityCategoryContains(categories.ENGINEER,unit) then
        threat = 0
    elseif EntityCategoryContains(categories.LAND*categories.MOBILE,unit) then
        if EntityCategoryContains(categories.TECH1,unit) then
            threat = 1
        elseif EntityCategoryContains(categories.TECH2,unit) then
            threat = 3
        elseif EntityCategoryContains(categories.TECH3,unit) then
            threat = 6
        end
    end
    DalliConstLandThreatTable[unit.UnitId] = threat
    return threat
end

function DalliFuncGetLandWeightedLocation(units)
    local aggVector = {0, 0, 0}
    local num = 0
    for _, unit in units do
        local threat = DalliFuncGetLandThreat(unit)
        aggVector = VAdd(aggVector,VMult(unit:GetPosition(),threat))
        num = num+threat
    end
    if num == 0 then
        return {pos = aggVector, threat = 0}
    else
        return {pos = VMult(aggVector,1/num), threat = num}
    end
end

function DalliFuncGetFuturePos(p0,p1,speed)
    local delta = VDiff(p1,p0)
    local norm = math.sqrt(delta[1]*delta[1] + delta[2]*delta[2] + delta[3]*delta[3]) -- because VNormal(delta) is a bait and switch
    if norm == 0 then
        return p0
    end
    return VAdd(p0,VMult(delta,speed/norm))
end



