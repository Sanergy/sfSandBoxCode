//Get all Case Categories
@RestResource(urlMapping='/api/casecategory')
global with sharing class REST_CaseCategories {
    
    @HttpGet
    global static List<CaseCategory> getCaseCategory() {
        
        List<CaseCategory> caseCategories = new List<CaseCategory>();
        
        List<Ussd_Cate_C__c> ussdCaseCategories = [SELECT Id, Name, category_name__c, USSD_Row_Number__c
                                                   FROM Ussd_Cate_C__c ORDER BY USSD_Row_Number__c ASC];
        
        if(ussdCaseCategories != null && ussdCaseCategories.size()> 0){
            
            for(Ussd_Cate_C__c ussdCaseCategory : ussdCaseCategories){
                
                CaseCategory category = new CaseCategory();
                
                category.guid = ussdCaseCategory.Id;
                category.caseCategoryName = ussdCaseCategory.category_name__c;
                category.rowNumber = ussdCaseCategory.USSD_Row_Number__c;
                
                caseCategories.add(category);
            }
        }
        
        System.debug('CASE CATEGORIES: = ' + caseCategories);
        
        return caseCategories;
    }
    
    global class CaseCategory {        
        public String guid;
        public String caseCategoryName;
        public Decimal rowNumber;
    }  
    
}