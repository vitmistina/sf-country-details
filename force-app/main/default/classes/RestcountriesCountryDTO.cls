public with sharing class RestcountriesCountryDTO {
    public List<Country> countries;
    public Blob hash;

    public RestcountriesCountryDTO() {
        countries = new List<Country>();
    }

    public class Country {
        public String name;
        public String alpha2Code;
        public String alpha3Code;
        public String capital;
        public String region;
        public String subregion;
        public List<RegionalBlock> regionalBlocs;
    }

    public class RegionalBlock {
        public String acronym;
    }
}
