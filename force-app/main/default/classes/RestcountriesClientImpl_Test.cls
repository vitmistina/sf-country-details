@IsTest
private class RestcountriesClientImpl_Test {
    private static final String JSON_NEW = '[{"name":"Panama","topLevelDomain":[".pa"],"alpha2Code":"PA","alpha3Code":"PAN","callingCodes":["507"],"capital":"Panama City","altSpellings":["PA","Republic of Panama","República de Panamá"],"region":"Americas","subregion":"Central America","population":3814672,"latlng":[9.0,-80.0],"demonym":"Panamanian","area":75417.0,"gini":51.9,"timezones":["UTC-05:00"],"borders":["COL","CRI"],"nativeName":"Panamá","numericCode":"591","currencies":[{"code":"PAB","name":"Panamanian balboa","symbol":"B/."},{"code":"USD","name":"United States dollar","symbol":"$"}],"languages":[{"iso639_1":"es","iso639_2":"spa","name":"Spanish","nativeName":"Español"}],"translations":{"de":"Panama","es":"Panamá","fr":"Panama","ja":"パナマ","it":"Panama","br":"Panamá","pt":"Panamá","nl":"Panama","hr":"Panama","fa":"پاناما"},"flag":"https://restcountries.eu/data/pan.svg","regionalBlocs":[{"acronym":"CAIS","name":"Central American Integration System","otherAcronyms":["SICA"],"otherNames":["Sistema de la Integración Centroamericana,"]}],"cioc":"PAN"}]';
    private static final String JSON_CHANGED = '[{"name":"Panama","topLevelDomain":[".pnm"],"alpha2Code":"PA","alpha3Code":"PAN","callingCodes":["507"],"capital":"Panama City","altSpellings":["PA","Republic of Panama","República de Panamá"],"region":"Americas","subregion":"Central America","population":3814672,"latlng":[9.0,-80.0],"demonym":"Panamanian","area":75417.0,"gini":51.9,"timezones":["UTC-05:00"],"borders":["COL","CRI"],"nativeName":"Panamá","numericCode":"591","currencies":[{"code":"PAB","name":"Panamanian balboa","symbol":"B/."},{"code":"USD","name":"United States dollar","symbol":"$"}],"languages":[{"iso639_1":"es","iso639_2":"spa","name":"Spanish","nativeName":"Español"}],"translations":{"de":"Panama","es":"Panamá","fr":"Panama","ja":"パナマ","it":"Panama","br":"Panamá","pt":"Panamá","nl":"Panama","hr":"Panama","fa":"پاناما"},"flag":"https://restcountries.eu/data/pan.svg","regionalBlocs":[{"acronym":"CAIS","name":"Central American Integration System","otherAcronyms":["SICA"],"otherNames":["Sistema de la Integración Centroamericana,"]}],"cioc":"PAN"}]';

    @IsTest
    private static void allCountries() {
        Test.setMock(HttpCalloutMock.class, new MyCalloutMock());

        IRestcountriesClient client = RestcountriesClientImpl.newInstance();

        RestcountriesCountryDTO result = client.getAllCountries();

        System.assertNotEquals(null, result.hash);
        System.assertEquals(1, result.countries.size());
        RestcountriesCountryDTO.Country panama = result.countries.get(0);
        System.assertEquals('Panama', panama.name);
        System.assertEquals('PA', panama.alpha2Code);
        System.assertEquals('PAN', panama.alpha3Code);
        System.assertEquals('Panama City', panama.capital);
        System.assertEquals('Americas', panama.region);
        System.assertEquals('Central America', panama.subregion);
        System.assertEquals(1, panama.regionalBlocs.size());
        System.assertEquals('CAIS', panama.regionalBlocs.get(0).acronym);
    }

    @IsTest
    private static void hashCanDetectChange() {
        Test.setMock(HttpCalloutMock.class, new MyCalloutMock());

        IRestcountriesClient client = RestcountriesClientImpl.newInstance();

        RestcountriesCountryDTO result = client.getAllCountries();
        RestcountriesCountryDTO result2 = client.getAllCountries();

        System.assertNotEquals(result.hash, result2.hash);
    }

    @IsTest
    private static void hashCanDetectSameResponse() {
        Test.setMock(
            HttpCalloutMock.class,
            new MyCalloutMock().withAlwaysSameResponses()
        );

        IRestcountriesClient client = RestcountriesClientImpl.newInstance();

        RestcountriesCountryDTO result = client.getAllCountries();
        RestcountriesCountryDTO result2 = client.getAllCountries();

        System.assertEquals(result.hash, result2.hash);
    }

    private class MyCalloutMock implements HttpCalloutMock {
        private Integer callCount = 0;
        private Boolean hasAlwaysSameResponses = false;

        public MyCalloutMock withAlwaysSameResponses() {
            this.hasAlwaysSameResponses = true;
            return this;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            if (callCount == 0 || hasAlwaysSameResponses) {
                res.setBody(JSON_NEW);
            } else {
                res.setBody(JSON_CHANGED);
            }
            callCount++;

            return res;
        }
    }
}
