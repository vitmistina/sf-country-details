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
        Leads domain = new Leads(
            new List<Lead>{
                new Lead(Country = 'PAN'),
                new Lead(Country = ''),
                new Lead()
            }
        );

        Set<String> result = domain.getQueriedValues();

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
        Id panamaId = fflib_IDGenerator.generate(CountryDetail__c.SObjectType);
        Id czechId = fflib_IDGenerator.generate(CountryDetail__c.SObjectType);

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
        mocks.when(
                selectorMock.getByCountryInLeads(
                    new Set<String>{ 'PAN', 'Czech Republic' }
                )
            )
            .thenReturn(
                new Map<String, CountryDetail__c>{
                    'PAN' => new CountryDetail__c(Id = panamaId),
                    'Czech Republic' => new CountryDetail__c(Id = czechId)
                }
            );
        mocks.stopStubbing();

        Application.unitOfWork.setMock(uowMock);
        Application.selector.setMock(selectorMock);

        domain.onAfterInsert();

        ((ICountryDetailsSelector) mocks.verify(selectorMock, 1))
            .getByCountryInLeads(new Set<String>{ 'PAN', 'Czech Republic' });
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
}
