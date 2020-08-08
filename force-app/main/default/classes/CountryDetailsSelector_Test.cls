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
}
