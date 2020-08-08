@IsTest
private class CountryDetailsSelector_Test {
    @IsTest
    private static void getAllCountryDetails() {
        List<CountryDetail__c> countryDetailList = new List<CountryDetail__c>();

        for (Integer i = 0; i < 300; i++) {
            countryDetailList.add(
                new CountryDetail__c(
                    Name = String.valueOf(i),
                    IsoCode3__c = String.valueOf(i)
                )
            );
        }

        insert countryDetailList;

        ICountryDetailsSelector selector = CountryDetailsSelector.newInstance();
        List<CountryDetail__c> result = selector.getAllCountryDetails();
        System.assertEquals(300, result.size());
    }

    @IsTest
    private static void getByCountryInLeads() {
        insert new List<CountryDetail__c>{
            new CountryDetail__c(
                Name = 'Czech Republic',
                IsoCode2__c = 'CZ',
                IsoCode3__c = 'CZE'
            ),
            new CountryDetail__c(
                Name = 'Panama',
                IsoCode2__c = 'PA',
                IsoCode3__c = 'PAN'
            ),
            new CountryDetail__c(
                Name = 'Austria',
                IsoCode2__c = 'AT',
                IsoCode3__c = 'ATR'
            ),
            new CountryDetail__c(
                Name = 'Slovakia',
                IsoCode2__c = 'SK',
                IsoCode3__c = 'SVK'
            )
        };

        ICountryDetailsSelector selector = CountryDetailsSelector.newInstance();
        Map<String, CountryDetail__c> result = selector.getAllCountryDetails(
            new Set<String>{ 'Czech Republic', 'PA', 'SVK', 'Gibberish' }
        );
        System.assertEquals(9, result.keySet().size());
    }
}
