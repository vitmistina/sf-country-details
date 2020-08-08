@IsTest
private class RestcountriesServiceImpl_Test {
    private static Blob HASH_INCOMING = Blob.valueOf('incomingHash');

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
            .thenReturn(new RestcountriesCountryDTO(HASH_INCOMING, null));
        mocks.when(selectorMock.sObjectType())
            .thenReturn(CountryDetail__c.SObjectType);
        mocks.when(selectorMock.getAllCountryDetails()).thenReturn(null);
        mocks.stopStubbing();

        Application.service.setMock(IRestcountriesClient.class, clientMock);
        Application.selector.setMock(selectorMock);

        RestcountriesServiceImpl.newInstance().updateCountryDetails();

        ((ICountryDetailsSelector) mocks.verify(selectorMock, 1))
            .getAllCountryDetails();
    }
    @IsTest
    private static void nonmatchingCache() {
    }
    @IsTest
    private static void matchingCache() {
    }
}
