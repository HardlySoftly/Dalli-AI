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
        self:InitialiseLandFeatureManager()
        self:InitialiseLandProductionController()
        self:InitialiseAirProductionController()
        self:InitialiseBaseProductionController()
    end,

    InitialiseThreads = function(self)
        self:ForkThread(self.EconomyFeatureManagerThread)
        self:ForkThread(self.MapFeatureManagerThread)
        self:ForkThread(self.LandFeatureManagerThread)
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
            --indirect
            i1 = 0, i2 = 0, i3 = 0,
            --aa1
            a1 = 0, a2 = 0, a3 = 0,
        }
    end,

    LandProductionControllerFunction = function(self)
        self.lpc.t1 = 10000
        self.lpc.s1 = math.min(3,self.efm.mass.investment.land/200)+self.efm.mass.investment.land/2000 - self.lfm.t1.s + 1
        self.lpc.i1 = self.efm.mass.investment.land/100 - self.lfm.t1.i - 6
        self.lpc.a1 = self.efm.mass.investment.land/600 - self.lfm.t1.a - 2
    end,

    InitialiseAirProductionController = function(self)
    end,

    AirProductionControllerFunction = function(self)
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
            if self.efm.bp.engie.t1 > 4 then
                self.bpc.p1 = 1
                if self.efm.energy.income < self.efm.energy.spend+80 and self.efm.bp.engie.t1 > 8 then
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
        self.bpc.lf1 = math.min(self.bpc.lf1, self.efm.bp.engie.t1-3)
        engiesRequired.t1 = engiesRequired.t1 + self.bpc.lf1
        -- TODO: learn to spend mass on something that isn't a t1 land factory
        
        --[[
            Engineer production numbers.
            Since the engineer builders are higher priority than units, we need to go back and constrain the 'engiesRequired' numbers
            based on the amount of units we have on the field.  This is of most importance early on - we might want 10 engies for mex
            expansion, but we also need to think about building some raiders too.
         ]]
        self.bpc.e1 = math.min(engiesRequired.t1,2+self.efm.mass.investment.land/100) - self.efm.bp.engie.t1
        self.bpc.e2 = engiesRequired.t2
        self.bpc.e3 = engiesRequired.t3
    end,

    InitialiseLandFeatureManager = function(self)
        self.lfm = {
            -- scout, tank, indirect, anti-air
            t1 = { s = 0, t = 0, i = 0, a = 0, },
            t2 = { s = 0, t = 0, i = 0, a = 0, },
            t3 = { s = 0, t = 0, i = 0, a = 0, },
        }
    end,

    LandFeatureManagerThread = function(self)
        local i = 0
        local k = 0
        while self.aiBrain.Result ~= "defeat" do
            self:InitialiseLandFeatureManager()
            local units = self.aiBrain:GetListOfUnits(categories.MOBILE*categories.LAND,false,true)
            for _, unit in units do
                local isT1 = EntityCategoryContains(categories.TECH1,unit)
                local isT2 = EntityCategoryContains(categories.TECH2,unit)
                local isT3 = EntityCategoryContains(categories.TECH3,unit)
                local isScout = EntityCategoryContains(categories.SCOUT,unit)
                local isTank = EntityCategoryContains(categories.DIRECTFIRE,unit)
                local isArtillery = EntityCategoryContains(categories.INDIRECTFIRE,unit)
                local isAntiAir = EntityCategoryContains(categories.ANTIAIR,unit)
                if isT1 then
                    if isScout then self.lfm.t1.s = self.lfm.t1.s + 1
                    elseif isAntiAir then self.lfm.t1.a = self.lfm.t1.a + 1
                    elseif isArtillery then self.lfm.t1.i = self.lfm.t1.i + 1
                    elseif isTank then self.lfm.t1.t = self.lfm.t1.t + 1
                    end
                elseif isT2 then
                    if isScout then self.lfm.t2.s = self.lfm.t2.s + 1
                    elseif isArtillery then self.lfm.t2.i = self.lfm.t2.i + 1
                    elseif isAntiAir then self.lfm.t2.a = self.lfm.t2.a + 1
                    elseif isTank then self.lfm.t2.t = self.lfm.t2.t + 1
                    end
                elseif isT3 then
                    if isScout then self.lfm.t3.s = self.lfm.t3.s + 1
                    elseif isArtillery then self.lfm.t3.i = self.lfm.t3.i + 1
                    elseif isAntiAir then self.lfm.t3.a = self.lfm.t3.a + 1
                    elseif isTank then self.lfm.t3.t = self.lfm.t3.t + 1
                    end
                end
            end
            i = i+1
            k = k+1
            local logging = false
            if logging and k >=20 then
                k = 0
                LOG("====================  LOGGING LFM OUTPUT  ====================")
                LOG("self.lfm.t1 = { s = "..tostring(self.lfm.t1.s)..", t = "..tostring(self.lfm.t1.t)..", i = "..tostring(self.lfm.t1.i)..", a = "..tostring(self.lfm.t1.a).." }")
                LOG("self.lfm.t2 = { s = "..tostring(self.lfm.t2.s)..", t = "..tostring(self.lfm.t2.t)..", i = "..tostring(self.lfm.t2.i)..", a = "..tostring(self.lfm.t2.a).." }")
                LOG("self.lfm.t3 = { s = "..tostring(self.lfm.t3.s)..", t = "..tostring(self.lfm.t3.t)..", i = "..tostring(self.lfm.t3.i)..", a = "..tostring(self.lfm.t3.a).." }")
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
                land = 0,
                air = 0,
                engie = {t1=0, t2=0, t3=0},
            },
        }
    end,

    EconomyFeatureManagerThread = function(self)
        local i = 0
        local k = 0
        while self.aiBrain.Result ~= "defeat" do
            local units = self.aiBrain:GetListOfUnits(categories.SELECTABLE,true,true)
            local massIncome = 0
            local energyIncome = 0
            local massSpend = { total = 0, land = 0, air = 0, engie = 0, other = 0 }
            local energySpend = 0
            local massInvestment = { total = 0, land = 0, air = 0, base = 0, other = 0 }
            local energyInvestment = 0
            self.efm.bp.engie.t1 = 0
            self.efm.bp.engie.t2 = 0
            self.efm.bp.engie.t3 = 0
            for _, unit in units do
                -- Muh blueprint
                local unitBP = unit:GetBlueprint()
                local isEngie = EntityCategoryContains(categories.ENGINEER,unit)
                local isLandFac = EntityCategoryContains(categories.FACTORY*categories.LAND,unit)
                local isAirFac = EntityCategoryContains(categories.FACTORY*categories.AIR,unit)
                local isCom = EntityCategoryContains(categories.COMMAND,unit)
                local isLand = EntityCategoryContains(categories.LAND*categories.MOBILE - categories.ENGINEER,unit)
                local isAir = EntityCategoryContains(categories.AIR*categories.MOBILE,unit)
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