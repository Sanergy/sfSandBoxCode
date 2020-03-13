public class CreateContractFromContractorAssignment {
    
      private ApexPages.StandardController standardController;
      public Casuals_Job_Assignment__c assignment {get; set;}
      public Contract__c contract {get; set;}
    
        public CreateContractFromContractorAssignment (ApexPages.StandardController standardController){
            this.standardController = standardController;
            
            this.assignment= (Casuals_Job_Assignment__c )standardController.getRecord();
            this.assignment=getData();
            
            this.contract=new Contract__c();
            contract.Account__c=assignment.Casual__r.account__c;
            contract.Contractor__c=assignment.Casual__c;
            contract.Designation__c=assignment.Casual_Job_Line_Item__r.Location_Dim_2__c;
            contract.Start_Date__c=assignment.Start_dDate__c;
            contract.End_Date__c=assignment.End_dDate__c;
            contract.Payment_Rate__c=assignment.Casual_Job_Line_Item__r.Rate__c;
            contract.Payment_Rate_Units__c=assignment.Casual_Job_Line_Item__r.Rate_Units__c;
            contract.Contract_Amount__c=assignment.Amount_Payable__c;
            
        }
                
        public Casuals_Job_Assignment__c getData() {
            List<Casuals_Job_Assignment__c> assignment=[SELECT Start_dDate__c,Amount_Payable__c, End_dDate__c, Casual_Job_Line_Item__r.Rate__c,
                                                        Casual_Job_Line_Item__r.Rate_Units__c,Casual_Job_Line_Item__r.Location_Dim_2__c,
                                                        Casual__c, Casual__r.name, Casual__r.ID_Number__c,Casual__r.account__c
                                                        FROM Casuals_Job_Assignment__c
                                                        WHERE id=:this.assignment.id ];
                                                        
            Casuals_Job_Assignment__c  conAssignment=null;
            
            if(assignment.size()>0){
                conAssignment=assignment.get(0);
            }
            return conAssignment;
        }
        
        public PageReference createContract(){
            if(contract!=null){
                contract.Job_Spec_Assignment__c=assignment.id;
                insert contract;
            }   
            
            return new PageReference('/' + assignment.Id);      
        }
        
             

}