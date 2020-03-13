public class ProcurementRequestTracker{
    public List<PrWrapper> wrapperItems{get;set;}
    public List<Procurement_Tracking_Sheet__c> prLines;
    public List<Procurement_Tracking_Sheet__c> prLinesSave;
    Public List<PTS_Line_Item__c>prLineItems;
    public String selectValue{get;set;}
    //   public Boolean  ishide {get;set;}
    
    public ProcurementRequestTracker(){
        //searchText = '';
        getwrapperItems();
        getSelectItems();
        
    }
    
    /* public Boolean getisHide(){
if(selectValue == 'PENDING USER CLOSURE'){
ishide = false;
}
else {
ishide = true;
}
return  ishide;

}
*/
    public PageReference getwrapperItems(){
        system.debug('thePbtrtytyu'+ selectValue);
        wrapperItems = new List<PrWrapper>();
        User u =  [SELECT Email from User WHERE Id = :UserInfo.getUserId()];
        
        prLines = [ SELECT ID,Name,OwnerId,Requestor__c,Requestor__r.Work_Email__c,Requestor__r.Name,
                   Request_Date__c,Required_Date__c,Next_Step__c,Next_Step_Due_Date__c,Total_Amount__c,
                   (SELECT id,Name,Item__c,Specifications__c, Quantity__c,Qty_Delivered__c,Quantity_Remaining__c,
                    Estimate__c, Currency_Config__c, Total_Quote_Price__c, Quote_Currency__c,Status__c,Procurement_Tracking_Sheet__c,Procurement_Tracking_Sheet__r.Name,
                    Procurement_Tracking_Sheet__r.Requestor__c, Procurement_Tracking_Sheet__r.Requestor__r.name, Procurement_Tracking_Sheet__r.Request_Date__c,
                    Procurement_Tracking_Sheet__r.Required_Date__c,Procurement_Tracking_Sheet__r.Next_Step__c,
                    Procurement_Tracking_Sheet__r.Next_Step_Due_Date__c,Closed__c
                    FROM PTS_Line_Items__r
                    WHERE (Procurement_Tracking_Sheet__r.OwnerId = :UserInfo.getUserId()
                           OR Procurement_Tracking_Sheet__r.Requestor__r.Work_Email__c = :u.email)
                    ORDER BY status__c)
                   FROM Procurement_Tracking_Sheet__c
                   WHERE (OwnerId = :UserInfo.getUserId()
                          OR Requestor__r.Work_Email__c = :u.email)
                   ORDER BY Name DESC]; 
        
        if(selectValue == '' ){
            prLines = [ SELECT ID,Name,OwnerId,Requestor__c,Requestor__r.Work_Email__c,Requestor__r.Name,
                       Request_Date__c,Required_Date__c,Next_Step__c,Next_Step_Due_Date__c,Total_Amount__c,
                       (SELECT id,Name,Item__c,Specifications__c, Quantity__c,Qty_Delivered__c,Quantity_Remaining__c,
                        Estimate__c, Currency_Config__c, Total_Quote_Price__c, Quote_Currency__c,Status__c,Procurement_Tracking_Sheet__c,Procurement_Tracking_Sheet__r.Name,
                        Procurement_Tracking_Sheet__r.Requestor__c, Procurement_Tracking_Sheet__r.Requestor__r.name, Procurement_Tracking_Sheet__r.Request_Date__c,
                        Procurement_Tracking_Sheet__r.Required_Date__c,Procurement_Tracking_Sheet__r.Next_Step__c,
                        Procurement_Tracking_Sheet__r.Next_Step_Due_Date__c,Closed__c
                        FROM PTS_Line_Items__r
                        WHERE (Procurement_Tracking_Sheet__r.OwnerId = :UserInfo.getUserId()
                               OR Procurement_Tracking_Sheet__r.Requestor__r.Work_Email__c = :u.email)
                        AND Status__c != 'Received' 
                        AND Status__c != 'Cancelled'
                        ORDER BY status__c)
                       FROM Procurement_Tracking_Sheet__c
                       WHERE (OwnerId = :UserInfo.getUserId()
                              OR Requestor__r.Work_Email__c = :u.email)
                       ORDER BY Name DESC];
            
        }
        
        else if(selectValue == 'ALL'){
            prLines = [ SELECT ID,Name,OwnerId,Requestor__c,Requestor__r.Work_Email__c,Requestor__r.Name,
                       Request_Date__c,Required_Date__c,Next_Step__c,Next_Step_Due_Date__c,Total_Amount__c,
                       (SELECT id,Name,Item__c,Specifications__c, Quantity__c,Qty_Delivered__c,Quantity_Remaining__c,
                        Estimate__c, Currency_Config__c, Total_Quote_Price__c, Quote_Currency__c,Status__c,Procurement_Tracking_Sheet__c,Procurement_Tracking_Sheet__r.Name,
                        Procurement_Tracking_Sheet__r.Requestor__c, Procurement_Tracking_Sheet__r.Requestor__r.name, Procurement_Tracking_Sheet__r.Request_Date__c,
                        Procurement_Tracking_Sheet__r.Required_Date__c,Procurement_Tracking_Sheet__r.Next_Step__c,
                        Procurement_Tracking_Sheet__r.Next_Step_Due_Date__c,Closed__c
                        FROM PTS_Line_Items__r
                        WHERE (Procurement_Tracking_Sheet__r.OwnerId = :UserInfo.getUserId()
                               OR Procurement_Tracking_Sheet__r.Requestor__r.Work_Email__c = :u.email)
                        ORDER BY status__c)
                       FROM Procurement_Tracking_Sheet__c
                       WHERE (OwnerId = :UserInfo.getUserId()
                              OR Requestor__r.Work_Email__c = :u.email)
                       ORDER BY Name DESC];
            system.debug('thePpppppb'+ prLines);
            
        }
        else if(selectValue == 'PENDING USER CLOSURE'){
            system.debug('thePpppppb'+ selectValue);
            prLines = [ SELECT ID,Name,OwnerId,Requestor__c,Requestor__r.Work_Email__c,Requestor__r.Name,Count_PR_Line_Items_Waiting_User_Close__c,
                       Request_Date__c,Required_Date__c,Next_Step__c,Next_Step_Due_Date__c,Total_Amount__c,
                       (SELECT id,Name,Item__c,Specifications__c, Quantity__c,Qty_Delivered__c,Quantity_Remaining__c,
                        Estimate__c, Currency_Config__c, Total_Quote_Price__c, Quote_Currency__c,Status__c,Procurement_Tracking_Sheet__c,Procurement_Tracking_Sheet__r.Name,
                        Procurement_Tracking_Sheet__r.Requestor__c, Procurement_Tracking_Sheet__r.Requestor__r.name, Procurement_Tracking_Sheet__r.Request_Date__c,
                        Procurement_Tracking_Sheet__r.Required_Date__c,Procurement_Tracking_Sheet__r.Next_Step__c,
                        Procurement_Tracking_Sheet__r.Next_Step_Due_Date__c,Closed__c
                        FROM PTS_Line_Items__r
                        WHERE (Procurement_Tracking_Sheet__r.OwnerId = :UserInfo.getUserId()
                               OR Procurement_Tracking_Sheet__r.Requestor__r.Work_Email__c = :u.email)
                        AND Status__c = 'CLOSED'
                        AND Closed__c = false
                        ORDER BY status__c)
                       FROM Procurement_Tracking_Sheet__c
                       WHERE (OwnerId = :UserInfo.getUserId()
                              OR Requestor__r.Work_Email__c = :u.email)
                       ORDER BY Name DESC];
            
        }
        else if(selectValue == 'CLOSED'){
            prLines = [ SELECT ID,Name,OwnerId,Requestor__c,Requestor__r.Work_Email__c,Requestor__r.Name,Count_PR_Line_Items_Waiting_User_Close__c,
                       Request_Date__c,Required_Date__c,Next_Step__c,Next_Step_Due_Date__c,Total_Amount__c,Stage__c,Count_all_PR_Line_Items__c,
                       Count_PR_Line_Items_Fully__c,
                       (SELECT id,Name,Item__c,Specifications__c, Quantity__c,Qty_Delivered__c,Quantity_Remaining__c,
                        Estimate__c, Currency_Config__c, Total_Quote_Price__c, Quote_Currency__c,Status__c,Procurement_Tracking_Sheet__c,Procurement_Tracking_Sheet__r.Name,
                        Procurement_Tracking_Sheet__r.Requestor__c, Procurement_Tracking_Sheet__r.Requestor__r.name, Procurement_Tracking_Sheet__r.Request_Date__c,
                        Procurement_Tracking_Sheet__r.Required_Date__c,Procurement_Tracking_Sheet__r.Next_Step__c,
                        Procurement_Tracking_Sheet__r.Next_Step_Due_Date__c,Closed__c
                        FROM PTS_Line_Items__r
                        WHERE (Procurement_Tracking_Sheet__r.OwnerId = :UserInfo.getUserId()
                               OR Procurement_Tracking_Sheet__r.Requestor__r.Work_Email__c = :u.email)
                        AND Status__c = 'CLOSED'
                        AND Closed__c = true
                        ORDER BY status__c)
                       FROM Procurement_Tracking_Sheet__c
                       WHERE (OwnerId = :UserInfo.getUserId()
                              OR Requestor__r.Work_Email__c = :u.email)
                       AND Stage__c = 'CLOSED'
                       ORDER BY Name DESC];
            //    AND (Count_PR_Line_Items_Waiting_User_Close__c > 0)
        }
        
        for(Procurement_Tracking_Sheet__c line : prLines){
            PrWrapper wrapper = new PrWrapper(line);
            wrapperItems.add(wrapper);
        }
        
        return null;        
    }
    
    public List<SelectOption> getSelectItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('ALL','ALL'));
        options.add(new SelectOption('PENDING USER CLOSURE','PENDING USER CLOSURE'));
        options.add(new SelectOption('OPEN','OPEN'));
        options.add(new SelectOption('CLOSED','CLOSED'));
        return options;
        
    }
    
    public PageReference save(){
        
      //  for ( Procurement_Tracking_Sheet__c pr:prLines){
           // upsert pr.PTS_Line_Items__r;
        //}
        
        return new PageReference('/home/home.jsp');
    }
    
    public class PrWrapper{
        public Procurement_Tracking_Sheet__c prLine {get; set;}
        public Boolean selected {get; set;}
        
        public PrWrapper(Procurement_Tracking_Sheet__c line){
            this.prLine = line;
            selected = false;
            
        }
    } 
}