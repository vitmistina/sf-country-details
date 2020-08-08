@IsTest
private class Leads_Test {
    @IsTest
    private static void checkIsPerformedForNewRecords() {
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
    private static void afterInsertTrigger() {
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
        Id panamaId = fflib_IDGenerator.generate(CountryDetail__c.SObjectType);
        Id czechId = fflib_IDGenerator.generate(CountryDetail__c.SObjectType);
        Map<String, CountryDetail__c> expectedSelectorOutput = new Map<String, CountryDetail__c>{
            'PAN' => new CountryDetail__c(Id = panamaId),
            'Czech Republic' => new CountryDetail__c(Id = czechId)
        };

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork) mocks.mock(
            fflib_ISObjectUnitOfWork.class
        );
        ICountryDetailsSelector selectorMock = (ICountryDetailsSelector) mocks.mock(
            ICountryDetailsSelector.class
        );

        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType())
            .thenReturn(CountryDetail__c.SObjectType);
        mocks.when(selectorMock.getByCountryInLeads(expectedSelectorInput))
            .thenReturn(expectedSelectorOutput);
        mocks.stopStubbing();

        Application.unitOfWork.setMock(uowMock);
        Application.selector.setMock(selectorMock);

        domain.onAfterInsert();

        ((ICountryDetailsSelector) mocks.verify(selectorMock, 1))
            .getByCountryInLeads(expectedSelectorInput);
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 2))
            .registerDirty(
                (SObject) fflib_Match.anyOf(
                    fflib_Match.sObjectWith(
                        new Map<Schema.SObjectField, Object>{
                            Lead.CountryDetail__c => panamaId
                        }
                    ),
                    fflib_Match.sObjectWith(
                        new Map<Schema.SObjectField, Object>{
                            Lead.CountryDetail__c => czechId
                        }
                    )
                )
            );

        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 1)).commitWork();
    }

    @IsTest
    private static void afterUpdateTrigger() {
        Id panamaLeadId = fflib_IDGenerator.generate(Lead.SObjectType);
        Id czechLeadId = fflib_IDGenerator.generate(Lead.SObjectType);
        Id panamaId = fflib_IDGenerator.generate(CountryDetail__c.SObjectType);

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
            'PAN' => new CountryDetail__c(Id = panamaId)
        };

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork) mocks.mock(
            fflib_ISObjectUnitOfWork.class
        );
        ICountryDetailsSelector selectorMock = (ICountryDetailsSelector) mocks.mock(
            ICountryDetailsSelector.class
        );

        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType())
            .thenReturn(CountryDetail__c.SObjectType);
        mocks.when(selectorMock.getByCountryInLeads(expectedSelectorInput))
            .thenReturn(expectedSelectorOutput);
        mocks.stopStubbing();

        Application.unitOfWork.setMock(uowMock);
        Application.selector.setMock(selectorMock);

        domain.onAfterInsert();

        ((ICountryDetailsSelector) mocks.verify(selectorMock, 1))
            .getByCountryInLeads(expectedSelectorInput);
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 1))
            .registerDirty(
                fflib_Match.sObjectWith(
                    new Map<Schema.SObjectField, Object>{
                        Lead.CountryDetail__c => panamaId
                    }
                )
            );

        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 1)).commitWork();
    }
}
