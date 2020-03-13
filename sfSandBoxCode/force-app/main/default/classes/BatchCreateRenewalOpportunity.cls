global class BatchCreateRenewalOpportunity implements Database.Batchable<sObject>,Database.Stateful
{


     global Integer monthDay;
     global Integer numberOfToilets=0;
     global List<Opportunity> listOpps;
    
    
    //function to return the name of the month
    private String getMonthName(Integer month){
      String monthName='';
      if(month==1){monthName='January';}
      else if(month==2){monthName='February';}
      else if(month==3){monthName='March';}
      else if(month==4){monthName='April';}
      else if(month==5){monthName='May';}
      else if(month==6){monthName='June';}
      else if(month==7){monthName='July';}
      else if(month==8){monthName='August';}
      else if(month==9){monthName='September';}
      else if(month==10){monthName='October';}
      else if(month==11){monthName='November';}
      else if(month==12){monthName='December';}
      
      return monthName;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
       
        Integer tenMonthsAgo=Date.today().addMonths(-9).month();
        this.monthDay=tenMonthsAgo;
         
        // Update Sanergy Settings - renewal opportunity month number and run each month of the quarter
        Map<String, Sanergy_Settings__c> settings=Sanergy_Settings__c.getAll();
        String mDay;
        String [] franchiseTypesToIgnore = new String []{'Non-Commercial-School','Hybrid-School'};
        
        if(settings!=null && settings.get('renewal opportunity month number')!=null){
            mDay=settings.get('renewal opportunity month number').value__c;
        }
        else{
            mDay='-1';
        }
        
        //String mDay=settings.get('renewal opportunity month number').value__c==null? '-1': settings.get('renewal opportunity month number').value__c;
        
        String query = 'SELECT ID,Area__c,Opening_Date__c,Opportunity__r.AccountId,Opportunity__r.Specific_Financing_Method__c,Opportunity__r.Actual_Launch_Date__c FROM Toilet__c WHERE CALENDAR_MONTH(Opening_Date__c) ='+mDay+' AND Operational_Status__c=\'Open\' AND Location__r.Franchise_Type__c NOT IN :franchiseTypesToIgnore AND Area__c != \'mathare\' AND Is_Opex_Fee_For_Service__c = False';
        
        System.debug('QUERY: ' + query);
        this.monthDay=Integer.valueOf(mDay);
        
        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext BC, List<Toilet__c> toiletsForRenewal)
    {
       // Date renewalStartDate=Date.today().toStartOfMonth().addMonths(3).addDays(14);
       // Date renewalEndDate=renewalStartDate.addYears(1).addDays(-1);
       // this.numberOfToilets+=toiletsForRenewal.size();
        
        //create a renewal opportunity for each toilet
        List<Opportunity> renewalOpps=new List<Opportunity>();
        List<RecordType> RenewalrecordType=[SELECT ID
                                            FROM RecordType
                                            WHERE Name='Renewal Sale'];
        
         
        if(RenewalrecordType.size()>0){ 
                   Integer counter=0;
                   for(Toilet__c toilet:toiletsForRenewal){
                   
                       //condition to ensure that toilets bought with two-year plan do not create renewal opportunities
                        if((toilet.Opportunity__r.Specific_Financing_Method__c!=null && 
                           toilet.Opportunity__r.Specific_Financing_Method__c=='2 Year Loan' && 
                           toilet.Opportunity__r.Actual_Launch_Date__c>Date.today().addYears(-1))==false){
                           
                           
                           Date renewalStartDate=Date.newInstance(Date.today().month() > toilet.Opening_Date__c.month() ? (Date.today().year())+1:Date.today().year() ,                         //year
                                                                  toilet.Opening_Date__c.month(),     //month
                                                                  15);                                //day
                           Date renewalEndDate=renewalStartDate.addYears(1).addDays(-1);
                           
                             Opportunity opp=new Opportunity(
                                 RecordTypeId=RenewalrecordType.get(0).ID,
                                 AccountId=toilet.Opportunity__r.AccountId,
                                 CloseDate=renewalStartDate,
                                 Toilet__c=toilet.ID,
                                 StageName='Renewal - In Progress',
                                 Renewal_Start_Date__c=renewalStartDate,
                                 Renewal_End_Date__c=renewalEndDate,
                                 Name='x'
                              );
                  
                            renewalOpps.add(opp);     
                        }
                   }
            
                 System.debug(renewalOpps.size()); 
                 
                 this.numberOfToilets+=renewalOpps.size();
                 insert renewalOpps;
                 
                  String[] idArray=new List<String>();
                 //get array of IDs
                  for(Opportunity op:renewalOpps){
                       idArray.add(op.ID); 
                  }
                 
                 
                 //Get the Names of the Opportunities
                 this.listOpps=[SELECT Name,ID
                                FROM Opportunity
                                WHERE ID IN :idArray];
                 
                 
                
        }
        
        //send an email if recordTypeId not found
        else{
             
           
             String message='An error has occurred on the scheduled job that auto-creates renewal-sale opportunies on Salesforce. Error: "Renewal Sale recordType Id not found"';
             EmailSender email=new EmailSender(new String[]{'dev@saner.gy'},'Renewal-Sale Opportunity autocreation error',message);
             email.sendMessage();
        
        }
    }  
    global void finish(Database.BatchableContext BC){
       //send an email
       System.debug('No. of toilets= '+this.numberOfToilets);
       
         //loop through the opportunity records and create a report for them
         String reportString='<ol>';
         if(this.listOpps!=null){
             for(Opportunity op:this.listOpps){
             reportString+='<li><a href="https://sanergy.my.salesforce.com/'+op.ID+'">'+op.Name+'</a></li>';
             }
         }
         
         
       reportString+='</ol>';
         
       String message=this.numberOfToilets+' Renewal Opportunities for toilets opened in '+getMonthName(monthDay)+' have been created on Salesforce</br></br></br>'+reportString;
       EmailSender sender=new EmailSender(new String[]{'dev@saner.gy'},'Auto-Creation of Renewal Opportunities for toilets opened in '+getMonthName(monthDay),message);
       sender.sendMessage(true);
    }
}