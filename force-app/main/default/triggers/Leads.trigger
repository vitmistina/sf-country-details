trigger Leads on Lead (after delete, after insert, after update, before delete, before insert, before update) {
  // Creates Domain class instance and calls apprpoprite overideable methods according to Trigger state
	fflib_SObjectDomain.triggerHandler(Leads.class);
}