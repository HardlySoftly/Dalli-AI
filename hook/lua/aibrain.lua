YeOldeAIBrainClass = AIBrain
AIBrain = Class(YeOldeAIBrainClass) {
    -- Hook DalliAI, set self.Dalli = true
    OnCreateAI = function(self, planName)
        YeOldeAIBrainClass.OnCreateAI(self, planName)
        local per = ScenarioInfo.ArmySetup[self.Name].AIPersonality
        if string.find(per, 'dalli') then
            LOG('* DalliAI: OnCreateAI() found DalliAI  Name: ('..self.Name..') - personality: ('..per..') ')
            self.Dalli = true
            self.DalliBrain = CreateDalliBrain(self)
        end
    end,

    BaseMonitorThread = function(self)
        if not self.Dalli then
            return YeOldeAIBrainClass.BaseMonitorThread(self)
        end
        WaitTicks(10)
        -- We are leaving this forked thread here because we don't need it.
        KillThread(CurrentThread())
    end,

    ExpansionHelpThread = function(self)
        if not self.Dalli then
            return YeOldeAIBrainClass.ExpansionHelpThread(self)
        end
        WaitTicks(10)
        -- We are leaving this forked thread here because we don't need it.
        KillThread(CurrentThread())
    end,

    InitializeEconomyState = function(self)
        if not self.Dalli then
            return YeOldeAIBrainClass.InitializeEconomyState(self)
        end
    end,

    InitializeSkirmishSystems = function(self)
        if not self.Dalli then
            return YeOldeAIBrainClass.InitializeSkirmishSystems(self)
        end
        YeOldeAIBrainClass.InitializeSkirmishSystems(self)
        self.DalliBrain:InitialiseThreads()
    end,

    OnIntelChange = function(self, blip, reconType, val)
        if not self.Dalli then
            return YeOldeAIBrainClass.OnIntelChange(self, blip, reconType, val)
        end
    end,

    SetupAttackVectorsThread = function(self)
        if not self.Dalli then
            return YeOldeAIBrainClass.SetupAttackVectorsThread(self)
        end
        WaitTicks(10)
        -- We are leaving this forked thread here because we don't need it.
        KillThread(CurrentThread())
    end,

    ParseIntelThread = function(self)
        if not self.Dalli then
            return YeOldeAIBrainClass.ParseIntelThread(self)
        end
        WaitTicks(10)
        -- We are leaving this forked thread here because we don't need it.
        KillThread(CurrentThread())
    end,
}

DalliBrain = Class({
    Initialise = function(self, aiBrain)
        LOG('============ Initialising DalliBrain ============')
        self.aiBrain = aiBrain
        self:InitialiseEconomyFeatureManager()
        self:InitialiseMapFeatureManager()
        self:InitialiseUnitFeatureManager()
        self:InitialiseLandProductionController()
        self:InitialiseAirProductionController()
        self:InitialiseBaseProductionController()
    end,

    InitialiseThreads = function(self)
        self:ForkThread(self.EconomyFeatureManagerThread)
        self:ForkThread(self.MapFeatureManagerThread)
        self:ForkThread(self.UnitFeatureManagerThread)
        self:ForkThread(self.OperationsThread)
    end,

    OperationsThread = function(self)
        while self.aiBrain.Result ~= "defeat" do
            self:LandProductionControllerFunction()
            self:AirProductionControllerFunction()
            self:BaseProductionControllerFunction()
            WaitTicks(10)
        end
        -- And garbage collection
        WaitTicks(10)
        KillThread(CurrentThread())
    end,

    InitialiseLandProductionController = function(self)
        self.lpc = {
            -- scouts
            s1 = 0,
            -- tanks
            t1 = 0, t2 = 0, t3 = 0,
            -- indirect
            i1 = 0, i2 = 0, i3 = 0,
            -- aa1
            a1 = 0, a2 = 0, a3 = 0,
        }
    end,

    LandProductionControllerFunction = function(self)
        -- Tech 1
        self.lpc.t1 = 100
        self.lpc.t2 = 100
        self.lpc.t3 = 100
        self.lpc.s1 = math.min(3,self.efm.mass.investment.land/200)+self.efm.mass.investment.land/3000 - self.ufm.land.t1.s + 1
        self.lpc.i1 = self.ufm.land.t1.t + self.ufm.land.t2.t + self.ufm.land.t3.t - self.ufm.land.t1.i - 6
        if self.efm.bp.land.t2 + self.efm.bp.land.t3 > 0 then
            self.lpc.a1 = 0
            self.lpc.a2 = self.efm.mass.investment.land/1800 - self.ufm.land.t2.a
        else
            self.lpc.a1 = self.efm.mass.investment.land/600 - self.ufm.land.t1.a - 2
            self.lpc.a2 = 0
        end
    end,

    InitialiseAirProductionController = function(self)
        self.apc = {
            -- scouts
            s1 = 0,
            -- inties
            i1 = 0,
            -- bombers
            b1 = 0,
        }
    end,

    AirProductionControllerFunction = function(self)
        -- Tech 1
        self.apc.i1 = 1
        self.apc.s1 = math.min(1,self.efm.mass.investment.air/200)+self.efm.mass.investment.air/1000 - self.ufm.air.t1.s + 1
        self.apc.b1 = self.ufm.air.t1.i - self.ufm.air.t1.b - 1
    end,

    InitialiseBaseProductionController = function(self)
        self.bpc = {
            -- mex expansion numbers
            m1 = 0,
            -- pgen build numbers
            p1 = 0, p2 = 0, p3 = 0,
            --pgen assist amounts
            --pa1 = 0, pa2 = 0, pa3 = 0,
            -- engie numbers
            e1 = 0, e2 = 0, e3 = 0,
            -- land factory build numbers
            lf1 = 0, lf2 = 0, lf3 = 0,
            -- air factory build numbers
            af1 = 0, af2 = 0, af3 = 0,
            -- mex upgrade numbers
            mu1 = 0, mu2 = 0,
        }
    end,

    --[[
        This function is for controlling:
            1. Engineer tasks (e.g. making new mexes, new pgens, new factories, experimentals)
            2. Number of engies to build (since the info we need for that decision will be here)
            3. Unit investment amounts
            4. Mex upgrades
            5. Factory upgrades

        Layout as follows:
            1. Mex expansion targets (how many engies tgo allocate to this)
            2. Pgen construction targets (how many to be building, assists on these, the desired tech level of these)
            3. Buildpower targets (numbers of t1/t2/t3 engies desired)
            4. Remaining mass allocation between different priorites
                - Mex upgrades
                - Factory upgrades
                - Unit production
    ]]
    BaseProductionControllerFunction = function(self)
        local engiesRequired = { t1 = 4, t2 = 1, t3 = 1 }

        -- Mex expansion stuff, no more than 10 engies on this please
        self.bpc.m1 = math.min(self.mfm.mex.available,10)
        engiesRequired.t1 = engiesRequired.t1 + self.bpc.m1

        --[[
            Power generation stuff
            Strategy here is:
                1. Determine tech level.
                    - Constrained by engineer tech level
                    - For low amounts of power, we may still want to build lower tech level pgens.
                      e.g. if I have 100 income (maybe as a result of bombing raids) I probably want some t1/2 pgens before t3 pgens
                2. Determine pgen build numbers based on the strategy for that tech level
                3. Determine pgen build assist numbers (buildpower, not engie counts) for the given tech level / requirements
            Remember to update required engie numbers as we go
         ]]
        self.bpc.p1 = 0
        self.bpc.p2 = 0
        self.bpc.p3 = 0
        if self.efm.bp.engie.t3 > 0 and self.efm.energy.income > 1000 then
            -- We hit t3 eco bruh!
            -- We'll be building t3 pgens only
            if self.efm.energy.income < self.efm.energy.spend+1000  or self.efm.energy.income < self.efm.energy.spend*1.2 then
                self.bpc.p3 = 1
            end
        elseif self.efm.bp.engie.t2+self.efm.bp.engie.t3 > 0 and self.efm.energy.income > 300 then
            -- t2 not so bad yo
            -- We'll be building t2 pgens only
            if self.efm.energy.income < self.efm.energy.spend+500  or self.efm.energy.income < self.efm.energy.spend*1.2 then
                self.bpc.p2 = 1
            end
        else
            -- Peasants in da house
            -- We'll be building t1 pgens only.  Minimum requirements on engies so we're not wasting early engies on pgens
            if self.efm.bp.engie.t1 > 3 then
                self.bpc.p1 = 1
                if self.efm.energy.income < self.efm.energy.spend and self.efm.bp.engie.t1 > 6 then
                    self.bpc.p1 = 3
                elseif self.efm.energy.income < self.efm.energy.spend then
                    self.bpc.p1 = 2
                end
            end
        end
        engiesRequired.t1 = engiesRequired.t1 + self.bpc.p1
        -- TODO: some pgen assist logic, in particular to help with higher tier pgens
        -- TODO: some controls to prevent double dipping on building pgens (e.g. building second before effects of first come through)

        -- Cap mex engies to make sure we have a couple spare
        self.bpc.m1 = math.min(math.max(self.efm.bp.engie.t1-4,4),self.bpc.m1)

        -- Mass allocation stuff here
        self.bpc.lf1 = 0
        if self.efm.bp.engie.t1 >= 3 and self.efm.mass.storage > 200 then
            if self.efm.mass.income+(self.efm.mass.storage/300) >= self.efm.mass.spend.total+8 then
                self.bpc.lf1 = 3
            elseif self.efm.mass.income+(self.efm.mass.storage/300) >= self.efm.mass.spend.total+4 then
                self.bpc.lf1 = 2
            elseif self.efm.mass.income+(self.efm.mass.storage/300) >= self.efm.mass.spend.total then
                self.bpc.lf1 = 1
            end
        end
        -- Cap lf1 based on numbers of engies currently produced
        if self.efm.mass.income < self.efm.mass.spend.total+100 then
            self.bpc.lf1 = math.min(self.bpc.lf1, self.efm.bp.engie.t1-3)
        end
        -- Cap lf1 based on numbers of factories vs mexes
        local mexToLandFacRatio = 2.5
        self.bpc.lf1 = math.min(self.bpc.lf1, math.round((self.efm.bp.mex.total+self.bpc.m1)/mexToLandFacRatio)-self.efm.bp.land.total)
        local airRatio = 2
        local initLand = 2.5
        self.bpc.af1 = (self.efm.bp.land.total-initLand)/airRatio - self.efm.bp.air.total
        engiesRequired.t1 = engiesRequired.t1 + self.bpc.lf1 + self.bpc.af1

        -- Mass investment stuff
        local t2MexRate = 10
        local t3MexRate = 24
        local t2FacRate = 12
        local t3FacRate = 17
        -- Determine amount of mass to be investing with
        local basicMassThreshold
        if self.mfm.mex.available <= 2 then basicMassThreshold = 10
        elseif self.mfm.mex.available <= 6 then basicMassThreshold = 30
        else basicMassThreshold = 40 end
        local investRate = 0.3
        local investAmount = investRate * (self.efm.mass.income - basicMassThreshold)
        --LOG("Invest Amount: 0.3 * ("..tostring(self.efm.mass.income).." - "..tostring(basicMassThreshold)..") = "..tostring(investAmount))
        -- Determine what to invest in
        self.bpc.lf2 = 0
        self.bpc.lf3 = 0
        if investAmount > 0 then
            -- Deduct upgrades first
            if self.efm.bp.land.t3 > 0 then
                -- no upgrades required
            elseif self.efm.bp.land.t2 > 0 then
                -- T3 upgrade?
                if self.efm.mass.income > 100 or self.efm.bp.mex.t3 >= 2 then
                    self.bpc.lf3 = 1
                    investAmount = investAmount - t3FacRate
                end
            else
                -- T2 upgrade?
                if self.efm.bp.mex.t2 >= 2 then
                    self.bpc.lf2 = 1
                    investAmount = investAmount - t2FacRate
                end
            end
        end
        -- Distribute remaining mass to mex upgrades
        self.bpc.mu1 = 0
        self.bpc.mu2 = 0
        while investAmount > 0 do
            if self.efm.bp.mex.t2 + self.bpc.mu1 - self.bpc.mu2 > self.efm.bp.mex.t1 * 3 then
                -- invest in another t3 mex
                self.bpc.mu2 = self.bpc.mu2 + 1
                investAmount = investAmount - t3MexRate
            elseif self.efm.bp.mex.t1 > 0 then
                -- invest in another t2 mex
                self.bpc.mu1 = self.bpc.mu1 + 1
                investAmount = investAmount - t2MexRate
            else
                -- Nothing left to invest in =/
                investAmount = 0
            end
        end
        -- Now do a last check to add additional teching if we're really mex constrained (tiny maps)
        if self.bpc.mu1 == 0 and self.bpc.m1 <= 2 then
            self.bpc.mu1 = 1
        end
        --LOG("mu1/mu2/lf2/lf3 : "..tostring(self.bpc.mu1).."/"..tostring(self.bpc.mu2).."/"..tostring(self.bpc.lf2).."/"..tostring(self.bpc.lf3))

        --[[
            Engineer production numbers.
            Since the engineer builders are higher priority than units, we need to go back and constrain the 'engiesRequired' numbers
            based on the amount of units we have on the field.  This is of most importance early on - we might want 10 engies for mex
            expansion, but we also need to think about building some raiders too.
         ]]
        self.bpc.e1 = math.min(engiesRequired.t1,2+self.efm.mass.investment.land/100) - self.efm.bp.engie.t1
        self.bpc.e2 = engiesRequired.t2 - self.efm.bp.engie.t2
        self.bpc.e3 = engiesRequired.t3 - self.efm.bp.engie.t3
    end,

    InitialiseUnitFeatureManager = function(self)
        self.ufm = {
            land = {
                -- scout, tank, indirect, anti-air
                t1 = { s = 0, t = 0, i = 0, a = 0, },
                t2 = { s = 0, t = 0, i = 0, a = 0, },
                t3 = { s = 0, t = 0, i = 0, a = 0, },
            },
            air = {
                t1 = { s = 0, i = 0, b = 0 },
                t2 = { s = 0, i = 0, b = 0 },
                t3 = { s = 0, i = 0, b = 0 },
            },
        }
    end,

    UnitFeatureManagerThread = function(self)
        local i = 0
        local k = 0
        while self.aiBrain.Result ~= "defeat" do
            self:InitialiseUnitFeatureManager()
            local units = self.aiBrain:GetListOfUnits(categories.MOBILE*categories.LAND,false)
            for _, unit in units do
                local isT1 = EntityCategoryContains(categories.TECH1,unit)
                local isT2 = EntityCategoryContains(categories.TECH2,unit)
                local isT3 = EntityCategoryContains(categories.TECH3,unit)
                local isScout = EntityCategoryContains(categories.SCOUT,unit)
                local isTank = EntityCategoryContains(categories.DIRECTFIRE,unit)
                local isArtillery = EntityCategoryContains(categories.INDIRECTFIRE,unit)
                local isAntiAir = EntityCategoryContains(categories.ANTIAIR,unit)
                if isT1 then
                    if isScout then self.ufm.land.t1.s = self.ufm.land.t1.s + 1
                    elseif isAntiAir then self.ufm.land.t1.a = self.ufm.land.t1.a + 1
                    elseif isArtillery then self.ufm.land.t1.i = self.ufm.land.t1.i + 1
                    elseif isTank then self.ufm.land.t1.t = self.ufm.land.t1.t + 1
                    end
                elseif isT2 then
                    if isScout then self.ufm.land.t2.s = self.ufm.land.t2.s + 1
                    elseif isArtillery then self.ufm.land.t2.i = self.ufm.land.t2.i + 1
                    elseif isAntiAir then self.ufm.land.t2.a = self.ufm.land.t2.a + 1
                    elseif isTank then self.ufm.land.t2.t = self.ufm.land.t2.t + 1
                    end
                elseif isT3 then
                    if isScout then self.ufm.land.t3.s = self.ufm.land.t3.s + 1
                    elseif isArtillery then self.ufm.land.t3.i = self.ufm.land.t3.i + 1
                    elseif isAntiAir then self.ufm.land.t3.a = self.ufm.land.t3.a + 1
                    elseif isTank then self.ufm.land.t3.t = self.ufm.land.t3.t + 1
                    end
                end
            end
            local units = self.aiBrain:GetListOfUnits(categories.MOBILE*categories.AIR,false)
            for _, unit in units do
                local isT1 = EntityCategoryContains(categories.TECH1,unit)
                local isT2 = EntityCategoryContains(categories.TECH2,unit)
                local isT3 = EntityCategoryContains(categories.TECH3,unit)
                local isScout = EntityCategoryContains(categories.SCOUT,unit)
                local isBomber = EntityCategoryContains(categories.BOMBER,unit)
                local isIntie = EntityCategoryContains(categories.ANTIAIR,unit)
                if isT1 then
                    if isScout then self.ufm.air.t1.s = self.ufm.air.t1.s + 1
                    elseif isBomber then self.ufm.air.t1.b = self.ufm.air.t1.b + 1
                    elseif isIntie then self.ufm.air.t1.i = self.ufm.air.t1.i + 1
                    end
                elseif isT2 then
                    if isScout then self.ufm.air.t2.s = self.ufm.air.t2.s + 1
                    elseif isBomber then self.ufm.air.t2.b = self.ufm.air.t2.b + 1
                    elseif isIntie then self.ufm.air.t2.i = self.ufm.air.t2.i + 1
                    end
                elseif isT3 then
                    if isScout then self.ufm.air.t3.s = self.ufm.air.t3.s + 1
                    elseif isBomber then self.ufm.air.t3.b = self.ufm.air.t3.b + 1
                    elseif isIntie then self.ufm.air.t3.i = self.ufm.air.t3.i + 1
                    end
                end
            end
            WaitTicks(5)
        end
        -- And garbage collection
        WaitTicks(10)
        KillThread(CurrentThread())
    end,

    InitialiseMapFeatureManager = function(self)
        self.mfm = {
            mex = {
                available = 0,
                built = 0,
            }
        }
    end,

    MapFeatureManagerThread = function(self)
        local i = 0
        while self.aiBrain.Result ~= "defeat" do
            local mexMarkers =  AIUtils.AIGetMarkerLocations(self.aiBrain, 'Mass')
            -- v.Name, v.position => Mass 22,  (1: 412.5)  (2: 47.340000152588)  (3: 195.5)  (type: VECTOR3)
            self.mfm.mex.available = 0
            for _, v in mexMarkers do
                if self.aiBrain:CanBuildStructureAt('ueb1103', v.Position) then
                    self.mfm.mex.available = self.mfm.mex.available + 1
                end
            end
            --LOG('Dalli\'s MapFeatureManagerThread heartbeat... ('..tostring(i)..')')
            i = i+1
            WaitTicks(100)
        end
        -- And garbage collection
        WaitTicks(10)
        KillThread(CurrentThread())
    end,

    InitialiseEconomyFeatureManager = function(self)
        self.efm = {
            p = 0.2,
            q = 0.8,
            mass = {
                income = 0,
                spend = {
                    total = 0,
                    land = 0,
                    air = 0,
                    engie = 0,
                    other = 0,
                },
                investment = {
                    total = 0,
                    land = 0,
                    air = 0,
                    base = 0,
                    other = 0,
                },
                storage = 0,
            },
            energy = {
                income = 0,
                spend = 0,
                investment = 0,
                storage = 0,
            },
            bp = {
                land = {t1=0, t2=0, t3=0, total=0},
                air = {t1=0, t2=0, t3=0, total=0},
                engie = {t1=0, t2=0, t3=0},
                mex = {t1=0, t2=0, t3=0, total=0},
            },
        }
    end,

    EconomyFeatureManagerThread = function(self)
        local i = 0
        local k = 0
        while self.aiBrain.Result ~= "defeat" do
            local units = self.aiBrain:GetListOfUnits(categories.SELECTABLE,true)
            local massIncome = 0
            local energyIncome = 0
            local massSpend = { total = 0, land = 0, air = 0, engie = 0, other = 0 }
            local energySpend = 0
            local massInvestment = { total = 0, land = 0, air = 0, base = 0, other = 0 }
            local energyInvestment = 0
            self.efm.bp.mex.t1 = 0
            self.efm.bp.mex.t2 = 0
            self.efm.bp.mex.t3 = 0
            self.efm.bp.mex.total = 0
            self.efm.bp.engie.t1 = 0
            self.efm.bp.engie.t2 = 0
            self.efm.bp.engie.t3 = 0
            self.efm.bp.land.t1 = 0
            self.efm.bp.land.t2 = 0
            self.efm.bp.land.t3 = 0
            self.efm.bp.land.total = 0
            self.efm.bp.air.t1 = 0
            self.efm.bp.air.t2 = 0
            self.efm.bp.air.t3 = 0
            self.efm.bp.air.total = 0
            for _, unit in units do
                -- Muh blueprint
                local unitBP = unit:GetBlueprint()
                local isEngie = EntityCategoryContains(categories.ENGINEER,unit)
                local isLandFac = EntityCategoryContains(categories.FACTORY*categories.LAND,unit)
                local isAirFac = EntityCategoryContains(categories.FACTORY*categories.AIR,unit)
                local isCom = EntityCategoryContains(categories.COMMAND,unit)
                local isLand = EntityCategoryContains(categories.LAND*categories.MOBILE - categories.ENGINEER,unit)
                local isAir = EntityCategoryContains(categories.AIR*categories.MOBILE,unit)
                local isMex = EntityCategoryContains(categories.MASSEXTRACTION,unit)
                local isStructure = EntityCategoryContains(categories.STRUCTURE,unit)
                -- 1. Update income
                massIncome = massIncome + unit:GetProductionPerSecondMass()
                energyIncome = energyIncome + unit:GetProductionPerSecondEnergy()
                -- 2. Update spend + buildpower
                local mS = unit:GetConsumptionPerSecondMass()
                energySpend = energySpend + unit:GetConsumptionPerSecondEnergy()
                massSpend.total = massSpend.total + mS
                if isEngie then
                    massSpend.engie = massSpend.engie + mS
                elseif isLandFac then
                    massSpend.land = massSpend.land + mS
                elseif isAirFac then
                    massSpend.air = massSpend.air + mS
                else
                    massSpend.other = massSpend.other + mS
                end
                -- 3. Update investment
                if not isCom then
                    local mI = unitBP.Economy.BuildCostMass
                    massInvestment.total = massInvestment.total + mI
                    energyInvestment = energyInvestment + unitBP.Economy.BuildCostEnergy
                    if isLand then
                        massInvestment.land = massInvestment.land + mI
                    elseif isAir then
                        massInvestment.air = massInvestment.air + mI
                    elseif isStructure then
                        massInvestment.base = massInvestment.base + mI
                    else
                        massInvestment.other = massInvestment.other + mI
                    end

                    -- update bp
                    if isEngie then
                        if EntityCategoryContains(categories.TECH1,unit) then
                            self.efm.bp.engie.t1 = self.efm.bp.engie.t1 + 1
                        elseif EntityCategoryContains(categories.TECH2,unit) then
                            self.efm.bp.engie.t2 = self.efm.bp.engie.t2 + 1
                        elseif EntityCategoryContains(categories.TECH3,unit) then
                            self.efm.bp.engie.t3 = self.efm.bp.engie.t3 + 1
                        end
                    elseif isLandFac then
                        self.efm.bp.land.total = self.efm.bp.land.total + 1
                        if EntityCategoryContains(categories.TECH1,unit) then
                            self.efm.bp.land.t1 = self.efm.bp.land.t1 + 1
                        elseif EntityCategoryContains(categories.TECH2,unit) then
                            self.efm.bp.land.t2 = self.efm.bp.land.t2 + 1
                        elseif EntityCategoryContains(categories.TECH3,unit) then
                            self.efm.bp.land.t3 = self.efm.bp.land.t3 + 1
                        end
                    elseif isAirFac then
                        self.efm.bp.air.total = self.efm.bp.air.total + 1
                        if EntityCategoryContains(categories.TECH1,unit) then
                            self.efm.bp.air.t1 = self.efm.bp.air.t1 + 1
                        elseif EntityCategoryContains(categories.TECH2,unit) then
                            self.efm.bp.air.t2 = self.efm.bp.air.t2 + 1
                        elseif EntityCategoryContains(categories.TECH3,unit) then
                            self.efm.bp.air.t3 = self.efm.bp.air.t3 + 1
                        end
                    elseif isMex then
                        self.efm.bp.mex.total = self.efm.bp.mex.total + 1
                        if EntityCategoryContains(categories.TECH1,unit) then
                            self.efm.bp.mex.t1 = self.efm.bp.mex.t1 + 1
                        elseif EntityCategoryContains(categories.TECH2,unit) then
                            self.efm.bp.mex.t2 = self.efm.bp.mex.t2 + 1
                        elseif EntityCategoryContains(categories.TECH3,unit) then
                            self.efm.bp.mex.t3 = self.efm.bp.mex.t3 + 1
                        end
                    end
                end
            end
            -- Income
            self.efm.mass.income = self.efm.mass.income*self.efm.q + massIncome*self.efm.p
            self.efm.energy.income = self.efm.energy.income*self.efm.q + energyIncome*self.efm.p
            -- Spend
            self.efm.mass.spend.total = self.efm.mass.spend.total*self.efm.q + massSpend.total*self.efm.p
            self.efm.mass.spend.land = self.efm.mass.spend.land*self.efm.q + massSpend.land*self.efm.p
            self.efm.mass.spend.air = self.efm.mass.spend.air*self.efm.q + massSpend.air*self.efm.p
            self.efm.mass.spend.engie = self.efm.mass.spend.engie*self.efm.q + massSpend.engie*self.efm.p
            self.efm.mass.spend.other = self.efm.mass.spend.other*self.efm.q + massSpend.other*self.efm.p
            self.efm.energy.spend = self.efm.energy.spend*self.efm.q + energySpend*self.efm.p
            -- Investment
            self.efm.mass.investment = massInvestment
            self.efm.energy.investment = energyInvestment
            -- Storage
            self.efm.mass.storage = self.aiBrain:GetEconomyStored('MASS')
            self.efm.energy.storage = self.aiBrain:GetEconomyStored('ENERGY')
            -- Buildpower
            --TODO: self.efm.bp.land
            --TODO: self.efm.bp.air
            --LOG('Dalli\'s EconomyFeatureManagerThread heartbeat... ('..tostring(i)..')')
            i = i + 1
            k = k + 1
            local logging = false
            if k >= 20 and logging then
                k = 0
                -- Log stats because reasons
                LOG("====================  LOGGING EFM OUTPUT  ====================")
                LOG("=== MASS ===")
                local ls = "self.efm.mass: { income = "..tostring(self.efm.mass.income)..","
                LOG(ls)
                ls = "    spend = { total = "..tostring(self.efm.mass.spend.total)..", land = "..tostring(self.efm.mass.spend.land)..", air = "..tostring(self.efm.mass.spend.air)..", engie = "..tostring(self.efm.mass.spend.engie)..", other = "..tostring(self.efm.mass.spend.other).." }"
                LOG(ls)
                ls = "    investment = { total = "..tostring(self.efm.mass.investment.total)..", land = "..tostring(self.efm.mass.investment.land)..", air = "..tostring(self.efm.mass.investment.air)..", base = "..tostring(self.efm.mass.investment.base)..", other = "..tostring(self.efm.mass.investment.other).." }"
                LOG(ls)
                ls = "    storage = "..tostring(self.efm.mass.storage).." }"
                LOG(ls)
                LOG("=== ENERGY ===")
                ls = "self.efm.energy: { income = "..tostring(self.efm.energy.income)..", spend = "..tostring(self.efm.energy.spend)..", investment = "..tostring(self.efm.energy.investment)..", storage = "..tostring(self.efm.energy.storage).." }"
                LOG(ls)
                LOG("=== BUILDPOWER ===")
                ls = "self.efm.bp: { land = "..tostring(self.efm.bp.land)..", air = "..tostring(self.efm.bp.land)
                ls = ls..", engies = { t1 = "..tostring(self.efm.bp.engie.t1)..", t2 = "..tostring(self.efm.bp.engie.t2)..", t3 = "..tostring(self.efm.bp.engie.t3).." } }"
                LOG(ls)
            end
            WaitTicks(5)
        end
        -- And garbage collection
        WaitTicks(10)
        KillThread(CurrentThread())
    end,

    -- So much work to be able to reference 'self' in my own class...
    ForkThread = function(self, fn, ...)
        if fn then
            local thread = ForkThread(fn, self, unpack(arg))
            -- I'm sure the regular AIBrain doesn't mind taking out our garbage...
            self.aiBrain.Trash:Add(thread)
            return thread
        else
            return nil
        end
    end,
})

function CreateDalliBrain(aiBrain)
    local db = DalliBrain()
    db:Initialise(aiBrain)
    return db
end