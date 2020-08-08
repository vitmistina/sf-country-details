public with sharing class RestcountriesServiceImpl implements IRestcountriesService {
    @TestVisible
    private static final String CACHE_PATH = 'restcountriesHash';

    public static IRestcountriesService newInstance() {
        return (IRestcountriesService) Application.service.newInstance(
            IRestcountriesService.class
        );
    }

    public void updateCountryDetails() {
        //get countries from REST service
        RestcountriesCountryDTO countriesDTO = RestcountriesClientImpl.newInstance()
            .getAllCountries();

        //check platform cache for existing hash from previous update
        Blob cachedHash = (Blob) Cache.Org.get(CACHE_PATH);

        //compare hashes
        if (cachedHash == null || countriesDTO.hash != cachedHash) {
            fflib_ISObjectUnitOfWork uow = Application.unitOfWork.newInstance();

            // SOQL for existing CountryDetail records and map them by ISO3
            List<CountryDetail__c> countryDetailList = CountryDetailsSelector.newInstance()
                .getAllCountryDetails();
            Map<String, CountryDetail__c> countryDetailsByISO3 = mapCountryDetailsByISO3(
                countryDetailList
            );

            // process incoming countries
            for (
                RestcountriesCountryDTO.Country countryDTO : countriesDTO.countries
            ) {
                CountryDetail__c existingRecord = countryDetailsByISO3.get(
                    countryDTO.alpha3Code
                );

                if (existingRecord != null) {
                    uow.registerDirty(transform(existingRecord, countryDTO));
                } else {
                    uow.registerNew(
                        transform(new CountryDetail__c(), countryDTO)
                    );
                }
            }

            // conclude DML transaction
            uow.commitWork();
            // save new hash to cache
            Cache.Org.put(CACHE_PATH, countriesDTO.hash);
        }

        //TODO is delete untouched needed now?
    }

    private CountryDetail__c transform(
        CountryDetail__c existingRecord,
        RestcountriesCountryDTO.Country countryDTO
    ) {
        existingRecord.IsoCode2__c = countryDTO.alpha2Code;
        existingRecord.IsoCode3__c = countryDTO.alpha3Code;
        existingRecord.Capital__c = countryDTO.capital;
        existingRecord.Region__c = countryDTO.region;
        existingRecord.Subregion__c = countryDTO.subregion;
        existingRecord.RegionalBlocs__c = getBlocString(countryDTO);

        return existingRecord;
    }

    private String getBlocString(RestcountriesCountryDTO.Country countryDTO) {
        if (countryDTO.regionalBlocs == null)
            return null;
        Set<String> blocAcronyms = new Set<String>();
        for (
            RestcountriesCountryDTO.RegionalBlock blocDTO : countryDTO.regionalBlocs
        ) {
            blocAcronyms.add(blocDTO.acronym);
        }
        return String.join(new List<String>(blocAcronyms), ';');
    }

    private Map<String, CountryDetail__c> mapCountryDetailsByISO3(
        List<CountryDetail__c> countryDetails
    ) {
        Map<String, CountryDetail__c> output = new Map<String, CountryDetail__c>();
        for (CountryDetail__c record : countryDetails) {
            output.put(record.IsoCode3__c, record);
        }
        return output;
    }
}
