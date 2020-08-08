public with sharing class RestcountriesServiceImpl implements IRestcountriesService {
    @TestVisible
    private static final String CACHE_PATH = 'restcountriesHash';

    public static IRestcountriesService newInstance() {
        return (IRestcountriesService) Application.service.newInstance(IRestcountriesService.class);
    }

    public void updateCountryDetails() {
        RestcountriesCountryDTO countriesDTO = RestcountriesClientImpl.newInstance()
            .getAllCountries();
        Blob cachedHash;
        if (Cache.Org.contains(CACHE_PATH)) {
            cachedHash = (Blob) Cache.Org.get(CACHE_PATH);
        }

        if (countriesDTO.hash != cachedHash) {
            // query
            // get query result in map by ISO3
            // process countriesDTO.countries, registeringNew or registerDirty
            // uow.commitWork

            //TODO delete untouched?
        }
    }
}
