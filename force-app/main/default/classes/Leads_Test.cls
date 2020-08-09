@IsTest
private class Leads_Test {
    @IsTest
    private static void selectRatingBehaviourAdmin() {
        ISObjectValidateBehaviour behaviour = new Leads(new List<Lead>())
            .selectRatingBehaviour();
        System.assertEquals(
            true,
            behaviour instanceof LeadsRatingCheckBehaviourLenient
        );
        System.assertEquals(
            false,
            behaviour instanceof LeadsRatingCheckBehaviourStrict
        );
    }

    @IsTest
    private static void selectRatingBehaviourSales() {
        //todo create sales user
        ISObjectValidateBehaviour behaviour = new Leads(new List<Lead>())
            .selectRatingBehaviour();
        System.assertEquals(
            false,
            behaviour instanceof LeadsRatingCheckBehaviourLenient
        );
        System.assertEquals(
            true,
            behaviour instanceof LeadsRatingCheckBehaviourStrict
        );
    }

    @IsTest
    private static void checkIsPerformedForNewRecords() {
        List<Lead> leadList = new List<Lead>{ new Lead(), new Lead() };

        Leads domain = new Leads(leadList);

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ISObjectValidateBehaviour behaviourMock = (ISObjectValidateBehaviour) mocks.mock(
            LeadsRatingCheckBehaviourLenient.class
        );

        Application.service.setMock(
            LeadsRatingCheckBehaviourLenient.class,
            behaviourMock
        );

        domain.onValidate();

        ((ISObjectValidateBehaviour) mocks.verify(behaviourMock, 1))
            .validate((List<SObject>) fflib_Match.anyList());
    }

    @IsTest
    private static void checkIsPerformedForChangedRecords() {
    }

    @IsTest
    private static void getQueriedValues() {
        List<Lead> leadList = new List<Lead>{
            new Lead(Country = 'PAN'),
            new Lead(Country = ''),
            new Lead()
        };
        Leads domain = new Leads(leadList);

        Set<String> result = domain.getQueriedValues(leadList);

        System.assertEquals(1, result.size());
    }

    @IsTest
    private static void beforeInsertTrigger() {
        Leads domain = new Leads(
            new List<Lead>{
                new Lead(Country = 'PAN'),
                new Lead(Country = 'Czech Republic'),
                new Lead(Country = ''),
                new Lead()
            }
        );
        Set<String> expectedSelectorInput = new Set<String>{
            'PAN',
            'Czech Republic'
        };

        Map<String, CountryDetail__c> expectedSelectorOutput = new Map<String, CountryDetail__c>{
            'PAN' => new CountryDetail__c(
                Id = fflib_IDGenerator.generate(CountryDetail__c.SObjectType)
            ),
            'Czech Republic' => new CountryDetail__c(
                Id = fflib_IDGenerator.generate(CountryDetail__c.SObjectType)
            )
        };

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ICountryDetailsSelector selectorMock = (ICountryDetailsSelector) mocks.mock(
            ICountryDetailsSelector.class
        );

        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType())
            .thenReturn(CountryDetail__c.SObjectType);
        mocks.when(selectorMock.getByCountryInLeads(expectedSelectorInput))
            .thenReturn(expectedSelectorOutput);
        mocks.stopStubbing();
        Application.selector.setMock(selectorMock);

        domain.onBeforeInsert();

        ((ICountryDetailsSelector) mocks.verify(selectorMock, 1))
            .getByCountryInLeads(expectedSelectorInput);
        for (Lead enhancedRecord : (List<Lead>) domain.Records) {
            if (expectedSelectorInput.contains(enhancedRecord.Country)) {
                System.assertNotEquals(null, enhancedRecord.CountryDetail__c);
            } else {
                System.assertEquals(null, enhancedRecord.CountryDetail__c);
            }
        }
    }

    @IsTest
    private static void beforeUpdateTrigger() {
        Id panamaLeadId = fflib_IDGenerator.generate(Lead.SObjectType);
        Id czechLeadId = fflib_IDGenerator.generate(Lead.SObjectType);
        Id panamaCountryId = fflib_IDGenerator.generate(
            CountryDetail__c.SObjectType
        );

        Leads domain = new Leads(
            new List<Lead>{
                new Lead(Id = panamaLeadId, Country = 'PAN'), // changed from empty
                new Lead(Id = czechLeadId, Country = 'Czech Republic') //stayed same
            }
        );

        domain.ExistingRecords = new Map<Id, Lead>{
            panamaLeadId => new Lead(Id = panamaLeadId, Country = ''), //changes to some value
            czechLeadId => new Lead(
                Id = czechLeadId,
                Country = 'Czech Republic'
            ) //stayed same
        };

        Set<String> expectedSelectorInput = new Set<String>{ 'PAN' };
        Map<String, CountryDetail__c> expectedSelectorOutput = new Map<String, CountryDetail__c>{
            'PAN' => new CountryDetail__c(Id = panamaCountryId)
        };

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ICountryDetailsSelector selectorMock = (ICountryDetailsSelector) mocks.mock(
            ICountryDetailsSelector.class
        );

        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType())
            .thenReturn(CountryDetail__c.SObjectType);
        mocks.when(selectorMock.getByCountryInLeads(expectedSelectorInput))
            .thenReturn(expectedSelectorOutput);
        mocks.stopStubbing();

        Application.selector.setMock(selectorMock);

        domain.onBeforeUpdate(domain.ExistingRecords);

        ((ICountryDetailsSelector) mocks.verify(selectorMock, 1))
            .getByCountryInLeads(expectedSelectorInput);
        for (Lead enhancedRecord : (List<Lead>) domain.Records) {
            if (expectedSelectorInput.contains(enhancedRecord.Country)) {
                System.assertEquals(
                    panamaCountryId,
                    enhancedRecord.CountryDetail__c
                );
            }
        }
    }
}
