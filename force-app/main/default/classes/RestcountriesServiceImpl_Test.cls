@IsTest
private class RestcountriesServiceImpl_Test {
    private static Blob HASH_INCOMING = Blob.valueOf('matchyMatchyHash');
    private static Blob HASH_MATCHING = Blob.valueOf('matchyMatchyHash');
    private static Blob HASH_NON_MATCHING = Blob.valueOf('staleOldHash');

    @IsTest
    private static void emptyCache() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IRestcountriesClient clientMock = (IRestcountriesClient) mocks.mock(
            IRestcountriesClient.class
        );

        ICountryDetailsSelector selectorMock = (ICountryDetailsSelector) mocks.mock(
            ICountryDetailsSelector.class
        );

        mocks.startStubbing();
        mocks.when(clientMock.getAllCountries())
            .thenReturn(
                new RestcountriesCountryDTO(
                    HASH_INCOMING,
                    new List<RestcountriesCountryDTO.Country>()
                )
            );
        mocks.when(selectorMock.sObjectType())
            .thenReturn(CountryDetail__c.SObjectType);
        mocks.when(selectorMock.getAllCountryDetails())
            .thenReturn(new List<CountryDetail__c>());
        mocks.stopStubbing();

        Application.service.setMock(IRestcountriesClient.class, clientMock);
        Application.selector.setMock(selectorMock);

        RestcountriesServiceImpl.newInstance().updateCountryDetails();

        ((ICountryDetailsSelector) mocks.verify(selectorMock, 1))
            .getAllCountryDetails();
    }

    @IsTest
    private static void processList() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IRestcountriesClient clientMock = (IRestcountriesClient) mocks.mock(
            IRestcountriesClient.class
        );

        ICountryDetailsSelector selectorMock = (ICountryDetailsSelector) mocks.mock(
            ICountryDetailsSelector.class
        );

        fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork) mocks.mock(
            fflib_ISObjectUnitOfWork.class
        );

        mocks.startStubbing();
        mocks.when(clientMock.getAllCountries())
            .thenReturn(
                new RestcountriesCountryDTO(
                    HASH_INCOMING,
                    new List<RestcountriesCountryDTO.Country>{
                        new RestcountriesCountryDTO.Country(
                            'Panama',
                            'PA',
                            'PAN',
                            'New Panama',
                            'Americas',
                            'Central America',
                            null
                        ),
                        new RestcountriesCountryDTO.Country(
                            'Czechia',
                            'CZ',
                            'CZE',
                            'Prague',
                            'Europe',
                            'Central Eastern Europe',
                            new List<RestcountriesCountryDTO.RegionalBlock>{
                                new RestcountriesCountryDTO.RegionalBlock('EU')
                            }
                        )
                    }
                )
            );
        mocks.when(selectorMock.sObjectType())
            .thenReturn(CountryDetail__c.SObjectType);
        mocks.when(selectorMock.getAllCountryDetails())
            .thenReturn(
                new List<CountryDetail__c>{
                    new CountryDetail__c(
                        Id = fflib_IDGenerator.generate(
                            CountryDetail__c.SObjectType
                        ),
                        IsoCode3__c = 'PAN'
                    )
                }
            );
        mocks.stopStubbing();

        Application.service.setMock(IRestcountriesClient.class, clientMock);
        Application.selector.setMock(selectorMock);
        Application.unitOfWork.setMock(uowMock);

        RestcountriesServiceImpl.newInstance().updateCountryDetails();

        ((ICountryDetailsSelector) mocks.verify(selectorMock, 1))
            .getAllCountryDetails();

        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 1))
            .registerNew(
                fflib_Match.sObjectOfType(CountryDetail__c.SObjectType)
            );
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 1))
            .registerDirty(
                fflib_Match.sObjectOfType(CountryDetail__c.SObjectType)
            );
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 1)).commitWork();
    }
    @IsTest
    private static void nonmatchingCache() {
        Cache.Org.put(RestcountriesServiceImpl.CACHE_PATH, HASH_MATCHING);

        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IRestcountriesClient clientMock = (IRestcountriesClient) mocks.mock(
            IRestcountriesClient.class
        );

        ICountryDetailsSelector selectorMock = (ICountryDetailsSelector) mocks.mock(
            ICountryDetailsSelector.class
        );

        mocks.startStubbing();
        mocks.when(clientMock.getAllCountries())
            .thenReturn(
                new RestcountriesCountryDTO(
                    HASH_INCOMING,
                    new List<RestcountriesCountryDTO.Country>()
                )
            );
        mocks.when(selectorMock.sObjectType())
            .thenReturn(CountryDetail__c.SObjectType);
        mocks.when(selectorMock.getAllCountryDetails())
            .thenReturn(new List<CountryDetail__c>());
        mocks.stopStubbing();

        Application.service.setMock(IRestcountriesClient.class, clientMock);
        Application.selector.setMock(selectorMock);

        RestcountriesServiceImpl.newInstance().updateCountryDetails();

        ((ICountryDetailsSelector) mocks.verify(selectorMock, 1))
            .getAllCountryDetails();
    }

    @IsTest
    private static void matchingCache() {
        Cache.Org.put(RestcountriesServiceImpl.CACHE_PATH, HASH_MATCHING);

        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IRestcountriesClient clientMock = (IRestcountriesClient) mocks.mock(
            IRestcountriesClient.class
        );

        ICountryDetailsSelector selectorMock = (ICountryDetailsSelector) mocks.mock(
            ICountryDetailsSelector.class
        );

        mocks.startStubbing();
        mocks.when(clientMock.getAllCountries())
            .thenReturn(
                new RestcountriesCountryDTO(
                    HASH_INCOMING,
                    new List<RestcountriesCountryDTO.Country>()
                )
            );
        mocks.when(selectorMock.sObjectType())
            .thenReturn(CountryDetail__c.SObjectType);
        mocks.when(selectorMock.getAllCountryDetails())
            .thenReturn(new List<CountryDetail__c>());
        mocks.stopStubbing();

        Application.service.setMock(IRestcountriesClient.class, clientMock);
        Application.selector.setMock(selectorMock);

        RestcountriesServiceImpl.newInstance().updateCountryDetails();

        ((ICountryDetailsSelector) mocks.verify(selectorMock, 0))
            .getAllCountryDetails();
    }
}
