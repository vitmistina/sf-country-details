public interface ICountryDetailsSelector extends fflib_ISObjectSelector {
    List<CountryDetail__c> getAllCountryDetails();
    Map<String, CountryDetail__c> getByCountryInLeads(
        Set<String> queriedValues
    );
}
