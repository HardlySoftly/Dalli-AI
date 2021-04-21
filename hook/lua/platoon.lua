YeOldePlatoonClass = Platoon
Platoon = Class(YeOldePlatoonClass) {
    --[[
      This is a copy paste of EngineerBuildAI that has then had a bunch of stuff ripped out, and a while loop added in near the bottom.

      I'll explain later.....
    ]]
    DalliEngineerMexAI = function(self)
        local aiBrain = self:GetBrain()
        local platoonUnits = self:GetPlatoonUnits()
        local armyIndex = aiBrain:GetArmyIndex()
        local x,z = aiBrain:GetArmyStartPos()
        local cons = self.PlatoonData.Construction
        local buildingTmpl, buildingTmplFile, baseTmpl, baseTmplFile

        -- Assist the primary engineer, which is contained in eng.
        local eng
        for k, v in platoonUnits do
            if not v.Dead and EntityCategoryContains(categories.ENGINEER, v) then --DUNCAN - was construction
                IssueClearCommands({v})
                if not eng then
                    eng = v
                else
                    IssueGuard({v}, eng)
                end
            end
        end

        -- Exit if eng is dead or no engineers.
        if not eng or eng.Dead then
            WaitTicks(1)
            self:PlatoonDisband()
            return
        end

        --DUNCAN - added
        if eng:IsUnitState('Building') or eng:IsUnitState('Upgrading') or eng:IsUnitState("Enhancing") then
           return
        end

        local FactionToIndex  = { UEF = 1, AEON = 2, CYBRAN = 3, SERAPHIM = 4, NOMADS = 5}
        local factionIndex = cons.FactionIndex or FactionToIndex[eng.factionCategory]

        buildingTmplFile = import(cons.BuildingTemplateFile or '/lua/BuildingTemplates.lua')
        baseTmplFile = import(cons.BaseTemplateFile or '/lua/BaseTemplates.lua')
        buildingTmpl = buildingTmplFile[(cons.BuildingTemplate or 'BuildingTemplates')][factionIndex]
        baseTmpl = baseTmplFile[(cons.BaseTemplate or 'BaseTemplates')][factionIndex]

        --LOG('*AI DEBUG: EngineerBuild AI ' .. eng.Sync.id)

        if self.PlatoonData.NeedGuard then
            eng.NeedGuard = true
        end

        -------- CHOOSE APPROPRIATE BUILD FUNCTION AND SETUP BUILD VARIABLES --------
        local reference = true
        local refName = false
        local buildFunction = AIBuildStructures.AIExecuteBuildStructure
        local closeToBuilder
        local relative
        local baseTmplList = {}

        -- if we have nothing to build, disband!
        if not cons.BuildStructures then
            WaitTicks(1)
            self:PlatoonDisband()
            return
        end

        table.insert(baseTmplList, baseTmpl)
        relative = true
        reference = true
        buildFunction = AIBuildStructures.AIExecuteBuildStructure

        if cons.BuildClose then
            closeToBuilder = eng
        end

        if cons.BuildStructures[1] == 'T1Resource' or cons.BuildStructures[1] == 'T2Resource' or cons.BuildStructures[1] == 'T3Resource' then
            relative = true
            closeToBuilder = eng
            local guards = eng:GetGuards()
            for k,v in guards do
                if not v.Dead and v.PlatoonHandle and aiBrain:PlatoonExists(v.PlatoonHandle) then
                    v.PlatoonHandle:PlatoonDisband()
                end
            end
        end

        --LOG("*AI DEBUG: Setting up Callbacks for " .. eng.Sync.id)
        self.SetupEngineerCallbacks(eng)

        -------- BUILD BUILDINGS HERE --------
        for baseNum, baseListData in baseTmplList do
            while true do
                for k, v in cons.BuildStructures do
                    if aiBrain:PlatoonExists(self) then
                        if not eng.Dead then
                            local cq = eng:GetCommandQueue()
                            local cQSize = table.getn(cq)
                            if cQSize > 0 then
                                WaitTicks(20)
                            else
                                local faction = SUtils.GetEngineerFaction(eng)
                                if aiBrain.CustomUnits[v] and aiBrain.CustomUnits[v][faction] then
                                    local replacement = SUtils.GetTemplateReplacement(aiBrain, v, faction, buildingTmpl)
                                    if replacement then
                                        buildFunction(aiBrain, eng, v, closeToBuilder, relative, replacement, baseListData, reference, cons.NearMarkerType)
                                    else
                                        buildFunction(aiBrain, eng, v, closeToBuilder, relative, buildingTmpl, baseListData, reference, cons.NearMarkerType)
                                    end
                                else
                                    buildFunction(aiBrain, eng, v, closeToBuilder, relative, buildingTmpl, baseListData, reference, cons.NearMarkerType)
                                end
                                local cq = eng:GetCommandQueue()
                                local cQSize = table.getn(cq)
                                if cQSize == 0 then
                                    WaitTicks(1)
                                    self:PlatoonDisband()
                                    return
                                end
                            end
                        else
                            if aiBrain:PlatoonExists(self) then
                                WaitTicks(1)
                                self:PlatoonDisband()
                                return
                            end
                        end
                    end
                end
            end
        end

        -- wait in case we're still on a base
        if not eng.Dead then
            local count = 0
            while eng:IsUnitState('Attached') and count < 2 do
                WaitSeconds(6)
                count = count + 1
            end
        end

        if not eng:IsUnitState('Building') then
            return self.ProcessBuildCommand(eng, false)
        end
    end,
}