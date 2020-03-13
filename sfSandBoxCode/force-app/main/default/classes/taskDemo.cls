public class taskDemo {
    public ApexPages.StandardController controller;
    public List<Opportunity> oppList{get; set;}
    public Account account{get; set;}
    public String accId{get;set;}

    public taskDemo(ApexPages.StandardController controller) {
        try{
            account = new Account();
            account = (Account)controller.getRecord();
            if(account.Id != null){
                oppList = [Select id,Name,Account.Name,Amount,StageName,CloseDate from 
                         Opportunity where AccountId =: account.Id];
                system.debug('Opportunities '+ oppList.size());    
            }
            else{
                oppList = new List<Opportunity>();
            }    
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage()));
        }

    }

    public void addRow(){
        oppList.add(new Opportunity());
    }

    public pageReference upsertAccount(){
        Pagereference pg = Page.taskDemo;//please update taskDemoPage with the name of your vf page.
        if(account.Name != null){
            upsert account;
            pg.getParameters().put('Id',account.Id);
            pg.setRedirect(true);
        }
        else{
            pg = null;
        }
        return pg;
    }

    public PageReference saveopp(){
        try{
            pageReference pg = Page.taskDemo;//please update taskDemoPage with the name of your vf page.
            if(account.Name != null){
                upsert account;
                pg.getParameters().put('Id',account.Id);
                List<Opportunity> con = new List<Opportunity>();

                for(Opportunity os : oppList)
                {   
                    os.AccountId = account.Id;
                    con.add(os);
                    system.debug('os record is='+os);
                }
                if(con != null){
                    upsert oppList;
                    system.debug('opp record is='+oppList);
                }
            }
            pg.setRedirect(true);
            return pg;            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
    }
}