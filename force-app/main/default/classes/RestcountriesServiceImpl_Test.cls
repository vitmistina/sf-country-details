@IsTest
private class RestcountriesServiceImpl_Test {
    private static Blob HASH_INCOMING = Blob.valueOf('incomingHash');

    @IsTest
    private static void emptyCache() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IRestcountriesClient clientMock = (IRestcountriesClient) mocks.mock(
            IRestcountriesClient.class
        );

        mocks.startStubbing();
        mocks.when(clientMock.getAllCountries())
            .thenReturn(new RestcountriesCountryDTO(HASH_INCOMING, null));
        mocks.stopStubbing();

        Application.service.setMock(IRestcountriesClient.class, clientMock);

        RestcountriesServiceImpl.newInstance().updateCountryDetails();
    }
    @IsTest
    private static void nonmatchingCache() {
    }
    @IsTest
    private static void matchingCache() {
    }
}
