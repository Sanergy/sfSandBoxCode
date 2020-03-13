global class EvergrowSalesPlanningDashboard{
    
    public List<OpportunityWrapper> oppWrapper {get;set;}
    public String [] selectedContacts{get;set;}
    
    private Map<Id,AggregateResult> rolledUpResults;
    
    private List<Contact> farmstarSalesAgents;
   
    //Constructor
    public EvergrowSalesPlanningDashboard(){   
        selectedContacts = new String []{};     
        getOpportunities();
    }
    
    private void getOpportunities(){
        
        Date startOfYear = Date.newInstance( Date.today().year(), 1, 1);
        oppWrapper = new List<OpportunityWrapper>(); 
        rolledUpResults = new Map<Id,AggregateResult>([SELECT AccountId Id, SUM(Purchased_Product_Weight_Kgs__c) sumPurchased, 
                                                      SUM(Target_Sales_Volume__c) sumTarget
                                                      FROM Opportunity
                                                      WHERE RecordType.Name LIKE '%Agricultural Product Sales%'
                                                      AND CreatedDate >= :startOfYear
                                                      AND AccountId != null
                                                      GROUP BY AccountId ]);      
        
        farmstarSalesAgents  = [SELECT name, id FROM Contact
                                WHERE RecordType.Name = 'Farmstar Sales Agents'
                                Order by Name ASC];
                                
        List<Opportunity> AgSalesOpportunity = [SELECT Account.Name,AccountId,id,StageName, Name,Phone_Number__c,Territory_Pocket__c,
                                                Priority__c, Crop_Evergrow_will_be_Used_On__c, Planned_Planting_Date__c,Next_Planting_Crop__c, 
                                                Next_Sale_Target__c,Primary_Salesperson__c,Very_Next_Step__c,Very_Next_Step_Date__c,CloseDate
                                                FROM Opportunity
                                                WHERE RecordType.Name LIKE '%Agricultural Product Sales%'
                                                AND Primary_Salesperson__c IN :selectedContacts
                                                ORDER BY CreatedDate DESC
                                                LIMIT 300];
                                                
        for(Opportunity op : AgSalesOpportunity  ){
            OpportunityWrapper opWrapper =  new OpportunityWrapper(op);
            opWrapper.annualTarget = rolledUpResults.get(op.accountId) == null? null : (Decimal)rolledUpResults.get(op.accountId).get('sumTarget');
            opWrapper.annualActual = rolledUpResults.get(op.accountId) == null? null : (Decimal)rolledUpResults.get(op.accountId).get('sumPurchased');
            
            oppWrapper.add(opWrapper);
        }
    }
    
    public List<SelectOption> getContacts() {
        List<SelectOption> options = new List<SelectOption>();
        
        //Without Primary Salespeople   
        options.add(new SelectOption('', '--none--'));
        
        for(Contact  c : farmstarSalesAgents){
            options.add(new SelectOption(c.id, c.name));
        }
                
        return options;
    }

    public void refresh(){
        getOpportunities();
    }
    
    public Decimal getOppListSize(){
        return this.oppWrapper.size();
    }
    
    public void save(){    
        List<Opportunity> oppList = new List<Opportunity>();
        
         for(OpportunityWrapper ow : getSelected()){
             oppList.add(ow.opp);
         }
         
         try{
             update oppList;
             getOpportunities();
         }catch(Exception e){
             getOpportunities();
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
         }
         
    }
    
    public PageReference cancel(){    
        return new PageReference('/home/home.jsp');
    }
    
    private List<OpportunityWrapper> getSelected(){
        List<OpportunityWrapper> selected = new List<OpportunityWrapper>();
        
        for(OpportunityWrapper ow : this.oppWrapper){
            if(ow.selected == true){
                selected.add(ow);
            }
        }
        
        return selected;
    }
    
    public class OpportunityWrapper{
        public Opportunity opp {get; set;}
        public Boolean selected {get; set;}
        public Decimal annualTarget {get; set;}
        public Decimal annualActual {get; set;}
        
        public OpportunityWrapper(Opportunity op){
            this.opp = op;
        }
    }
}