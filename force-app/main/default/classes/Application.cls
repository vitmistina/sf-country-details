public with sharing class Application extends fflib_Application {
    public static final fflib_Application.UnitOfWorkFactory unitOfWork = new fflib_Application.UnitOfWorkFactory(
        new List<SObjectType>{}
    );

    public static final fflib_Application.ServiceFactory service = new fflib_Application.ServiceFactory(
        new Map<Type, Type>{
            IRestcountriesClient.class => RestcountriesClientImpl.class,
            IRestcountriesService.class => RestcountriesServiceImpl.class,
            LeadOwnerCheckImplLenient.class => LeadOwnerCheckImplLenient.class
        }
    );

    public static final fflib_Application.SelectorFactory selector = new fflib_Application.SelectorFactory(
        new Map<SObjectType, Type>{
            CountryDetail__c.SObjectType => CountryDetailsSelector.class
        }
    );

    public static final fflib_Application.DomainFactory domain = new fflib_Application.DomainFactory(
        Application.Selector,
        new Map<SObjectType, Type>{
            Lead.SObjectType => Leads.Constructor.class
        }
    );
}
