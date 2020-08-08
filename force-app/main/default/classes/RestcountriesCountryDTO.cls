public with sharing class RestcountriesCountryDTO {
    public List<Country> countries;
    public Blob hash;

    public RestcountriesCountryDTO() {
        countries = new List<Country>();
    }

    public RestcountriesCountryDTO(Blob hash, List<Country> countries) {
        this.hash = hash;
        this.countries = countries;
    }

    public class Country {
        public String name;
        public String alpha2Code;
        public String alpha3Code;
        public String capital;
        public String region;
        public String subregion;
        public List<RegionalBlock> regionalBlocs;

        public Country(
            String name,
            String alpha2Code,
            String alpha3Code,
            String capital,
            String region,
            String subregion,
            List<RegionalBlock> regionalBlocs
        ) {
            this.name = name;
            this.alpha2Code = alpha2Code;
            this.alpha3Code = alpha3Code;
            this.capital = capital;
            this.region = region;
            this.subregion = subregion;
            this.regionalBlocs = regionalBlocs;
        }
    }

    public class RegionalBlock {
        public String acronym;

        public RegionalBlock(String acronym){
            this.acronym=acronym;
        }
    }
}
