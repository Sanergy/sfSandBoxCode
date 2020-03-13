@isTest(seeAllData=true)
public class CreatePinFromSPRTest {
    static testMethod void CreatePinFromSPRTest (){
        
        
        //Get dim1                              
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1];
        System.debug('' + department);
        //Get dim2                                    
        List<FFA_Config_Object__c> dim2 = [SELECT Id,Name,Type__c,isActive__c 
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'dim2' 
                                           AND isActive__c = true LIMIT 1];
        
        //Get dim3                                   
        List<FFA_Config_Object__c> dim3 = [SELECT Id,Name,Type__c,isActive__c 
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'dim3' 
                                           AND isActive__c = true LIMIT 1];
        
        //Get dim4                                     
        List<FFA_Config_Object__c> dim4 = [SELECT Id,Name,Type__c,isActive__c 
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'dim4' 
                                           AND isActive__c = true LIMIT 1];
        
        //Get GLA
        List<FFA_Config_Object__c> gla = [SELECT Id,Name,Type__c,isActive__c 
                                          FROM FFA_Config_Object__c 
                                          WHERE Type__c = 'gla' 
                                          AND isActive__c = true LIMIT 1];
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT Id,Name,Type__c,isActive__c 
                                             FROM FFA_Config_Object__c 
                                             WHERE type__c='company' 
                                             AND isActive__c=true LIMIT 5];
        //Get employee
        List<Employee__c> employee = [SELECT Id,Name,Employee_Active__c,Work_Email__c 
                                      FROM Employee__c 
                                      WHERE id = 'aAsD0000000GmgM' LIMIT 1];     //James ID - need to make sure emp selected has a TL for thesharing reasons to work            
        
        //Get GLA for - Accounts Payable Control
        List<c2g__codaGeneralLedgerAccount__c> accountsPayableControlGLA = [SELECT Id,Name
                                                                            FROM c2g__codaGeneralLedgerAccount__c
                                                                            WHERE Name = '2000 - Accounts Payable Control'];
        
        //Get GLA for - Accounts Receivable Control
        List<c2g__codaGeneralLedgerAccount__c> accountsReceivableControlGLA = [SELECT Id,Name
                                                                               FROM c2g__codaGeneralLedgerAccount__c
                                                                               WHERE Name = '1200 - Accounts Receivable Control'];        
        
        
        //Get a vendor
        List<Account> vendor = [SELECT Id FROM Account WHERE RecordType.Name = 'Sanergy Vendor' LIMIT 1];
        
        //Get a vendor
        List<Account> FreshLife = [SELECT Id FROM Account WHERE Name = 'Fresh Life' LIMIT 1];  
        
         //Get Electronic Sanergy vendor
        List<Account> ElectronicSanergyVendor = [SELECT Id FROM Account WHERE RecordType.Name = 'Sanergy Vendor' AND c2g__CODAPaymentMethod__c = 'Electronic' LIMIT 1];
        
         //Get Electronic Freshlife vendor
      //List<Account> ElectronicFreshLifeVendor = [SELECT Id FROM Account WHERE RecordType.Name = 'Fresh Life Vendor' AND c2g__CODAPaymentMethod__c = 'Electronic' LIMIT 1];        
        
        //Get vendor type is USD
        List<Account> SanergyVendorUSD = [SELECT Id FROM Account WHERE RecordType.Name = 'Sanergy Vendor' AND CurrencyIsoCode = 'USD'];

        //Get vendor type is EUR
        List<Account> SanergyVendorEUR = [SELECT Id FROM Account WHERE CurrencyIsoCode = 'EUR'];
        
        //Get Record Type
        List<RecordType> type = [SELECT id,Name from RecordType where Name ='Sanergy Vendor'];
        
         //Get Company
         FFA_Config_Object__c company1 = [SELECT Id,Name,Type__c,isActive__c 
                                          FROM FFA_Config_Object__c 
                                          WHERE type__c = 'company' 
                                          AND isActive__c = true 
                                          AND Name = 'Sanergy Limited'
                                          LIMIT 1];

         //Get Company
         FFA_Config_Object__c company2 = [SELECT Id,Name,Type__c,isActive__c 
                                          FROM FFA_Config_Object__c 
                                          WHERE type__c = 'company' 
                                          AND isActive__c = true 
                                          AND Name = 'Fresh Life Initiative Limited'
                                          LIMIT 1];

         //Get Company
         FFA_Config_Object__c company3 = [SELECT Id,Name,Type__c,isActive__c 
                                          FROM FFA_Config_Object__c 
                                          WHERE type__c = 'company' 
                                          AND isActive__c = true 
                                          AND Name = 'Sanergy, Inc. (FP)'
                                          LIMIT 1]; 
         
         //Get Company
         FFA_Config_Object__c company4 = [SELECT Id,Name,Type__c,isActive__c 
                                          FROM FFA_Config_Object__c 
                                          WHERE type__c = 'company' 
                                          AND isActive__c = true 
                                          AND Name = 'Sanergy, Inc. (NP)'
                                          LIMIT 1];        
        
        //Create Account       
        Account ac = new Account();
        ac.Name = 'Nicki Minaj';
        ac.CurrencyIsoCode = 'KES';
        ac.c2g__CODAAccountTradingCurrency__c = 'KES';
        ac.Type = 'Vendor';
        ac.c2g__CODAPaymentMethod__c = 'Check';
        ac.RecordTypeId = type.get(0).Id;
        ac.rstk__Rootstock_Vendor__c=true;
        ac.c2g__CODAAccountsPayableControl__c = accountsPayableControlGLA.get(0).Id;
        ac.c2g__CODAAccountsReceivableControl__c = accountsReceivableControlGLA.get(0).Id;
        INSERT ac;
        
        //Create Special Procurement               
        Special_Procurement__c sp1 = new Special_Procurement__c();
        sp1.Requestor__c = 'aAsD0000000GmgM';
        sp1.Type__c = 'Cash Advance';
        sp1.Required_Date__c = date.today();
        sp1.Comments__c = 'Two tyres for Toyota Corolla';         
        sp1.Requesting_Department__c = department.get(0).Id;
        sp1.Vendor__c = vendor.get(0).Id;       
        sp1.Approval_Status__c = 'Approved By Team Lead';
        sp1.Dim_2__c = dim2.get(0).Id;
        sp1.Dim_3__c = dim3.get(0).Id;
        sp1.GLA__c = gla.get(0).Id;
        sp1.Scheduled_Payment_Date__c = date.today()+30;
        sp1.Grant__c = dim4.get(0).Id;
        sp1.Approve_Reconciliation__c = true;
        sp1.Requesting_Company__c = company1.Id;
        sp1.Payment_Method__c = 'Check';
        INSERT sp1;
        
        System.debug('SPR: ' + sp1.Requesting_Company__c);
        
       //Create  ElectronicSanergyVendor
       Special_Procurement__c spElectronicVendor = new Special_Procurement__c();
        spElectronicVendor.Requestor__c = 'aAsD0000000Gmhr';//Ani
        spElectronicVendor.Type__c = 'Cash Advance';
        spElectronicVendor.Required_Date__c = date.today();
        spElectronicVendor.Comments__c = 'Two tyres for Toyota Corolla';         
        spElectronicVendor.Requesting_Department__c = department.get(0).Id;
        spElectronicVendor.Vendor__c = ElectronicSanergyVendor.get(0).Id;       
        spElectronicVendor.Approval_Status__c = 'Approved By Team Lead';
        spElectronicVendor.Dim_2__c = dim2.get(0).Id;
        spElectronicVendor.Dim_3__c = dim3.get(0).Id;
        spElectronicVendor.GLA__c = gla.get(0).Id;
        spElectronicVendor.Grant__c = dim4.get(0).Id;
        spElectronicVendor.Scheduled_Payment_Date__c = date.today()+20;
        spElectronicVendor.Approve_Reconciliation__c = true;
        spElectronicVendor.Requesting_Company__c = company1.Id;
        spElectronicVendor.Payment_Method__c = 'Electronic';
        INSERT spElectronicVendor;
 
       //Create Sanergy Vendor USD
       Special_Procurement__c spVendorUSD = new Special_Procurement__c();
        spVendorUSD.Requestor__c = 'aAsD0000000Gmoa';//Lindsay
        spVendorUSD.Type__c = 'Cash Advance';
        spVendorUSD.Required_Date__c = date.today();
        spVendorUSD.Comments__c = 'Two tyres for Toyota Corolla';         
        spVendorUSD.Requesting_Department__c = department.get(0).Id;
        spVendorUSD.Vendor__c = SanergyVendorUSD.get(0).Id;       
        spVendorUSD.Approval_Status__c = 'Approved By Team Lead';
        spVendorUSD.Dim_2__c = dim2.get(0).Id;
        spVendorUSD.Dim_3__c = dim3.get(0).Id;
        spVendorUSD.Scheduled_Payment_Date__c = date.today()+28;
        spVendorUSD.GLA__c = gla.get(0).Id;
        spVendorUSD.Grant__c = dim4.get(0).Id;
        spVendorUSD.Approve_Reconciliation__c = true;
        spVendorUSD.Requesting_Company__c = company1.Id;
        spVendorUSD.Payment_Method__c = 'Check';
        INSERT spVendorUSD;
        
               //Create Sanergy Vendor EUR
       Special_Procurement__c spVendorEUR = new Special_Procurement__c();
        spVendorEUR.Requestor__c = 'aAsD0000000Gmgt';//Diana
        spVendorEUR.Type__c = 'Cash Advance';
        spVendorEUR.Required_Date__c = date.today();
        spVendorEUR.Comments__c = 'Two tyres for Toyota Corolla';         
        spVendorEUR.Requesting_Department__c = department.get(0).Id;
        spVendorEUR.Vendor__c = SanergyVendorEUR.get(0).Id;       
        spVendorEUR.Approval_Status__c = 'Approved By Team Lead';
        spVendorEUR.Dim_2__c = dim2.get(0).Id;
        spVendorEUR.Dim_3__c = dim3.get(0).Id;
        spVendorEUR.Scheduled_Payment_Date__c = date.today()+28;
        spVendorEUR.GLA__c = gla.get(0).Id;
        spVendorEUR.Grant__c = dim4.get(0).Id;
        spVendorEUR.Approve_Reconciliation__c = true;
        spVendorEUR.Requesting_Company__c = company1.Id;
        spVendorEUR.Payment_Method__c = 'Check';
        INSERT spVendorEUR;
        
            
            
        System.debug('SPR: ' + sp1.Requesting_Company__c);
        //Create Special Procurement               
        Special_Procurement__c sp2 = new Special_Procurement__c();
        sp2.Requestor__c = 'aAsD0000000GmtM';//Susan
        sp2.Type__c = 'Employee Reimbursement';
        sp2.Required_Date__c = date.today();
        sp2.Comments__c = 'Two tyres for Toyota Corollas';         
        sp2.Requesting_Department__c = department.get(0).Id;
        sp2.Vendor__c = FreshLife.get(0).Id; 
        sp2.Approval_Status__c = 'Approved By Team Lead';
        sp2.Dim_2__c = dim2.get(0).Id;
        sp2.Dim_3__c = dim3.get(0).Id;
        sp2.GLA__c = gla.get(0).Id;
        sp2.Grant__c = dim4.get(0).Id;
        sp2.Scheduled_Payment_Date__c = date.today()+29;
        sp2.Approve_Reconciliation__c = true;
        sp2.Requesting_Company__c = company2.Id;
        sp2.Payment_Method__c = 'Check';
        INSERT sp2;
        
        System.debug('SPR: ' + sp2.Requesting_Company__c);
        
        
        //Create Special Procurement               
        Special_Procurement__c sp3 = new Special_Procurement__c();
        sp3.Requestor__c = 'aAsD0000000GmtM';//Susan
        sp3.Type__c = 'Special Procurement';
        sp3.Required_Date__c = date.today();
        sp3.Comments__c = 'Two tyres for Toyota Corollas';         
        sp3.Requesting_Department__c = department.get(0).Id;
        sp3.Vendor__c = vendor.get(0).Id;
        sp3.Approval_Status__c = 'Approved By Team Lead';
        sp3.Dim_2__c = dim2.get(0).Id;
        sp3.Dim_3__c = dim3.get(0).Id;
        sp3.GLA__c = gla.get(0).Id;
        sp3.Grant__c = dim4.get(0).Id;
        sp3.Scheduled_Payment_Date__c = date.today()+27;
        sp3.Approve_Reconciliation__c = true;
        sp3.Requesting_Company__c = company3.Id;
        INSERT sp3;
        
        System.debug('SPR: ' + sp3.Requesting_Company__c);
        
        
        //Create Special Procurement               
        Special_Procurement__c sp4 = new Special_Procurement__c();
        sp4.Requestor__c = 'aAsD0000000Gmhr';//Ani
        sp4.Type__c = 'Cash Advance';
        sp4.Required_Date__c = date.today();
        sp4.Comments__c = 'Two tyres for Toyota Corollas';         
        sp4.Requesting_Department__c = department.get(0).Id;
        sp4.Vendor__c = vendor.get(0).Id;       
        sp4.Approval_Status__c = 'Approved By Team Lead';
        sp4.Dim_2__c = dim2.get(0).Id;
        sp4.Dim_3__c = dim3.get(0).Id;
        sp4.GLA__c = gla.get(0).Id;
        sp4.Scheduled_Payment_Date__c = date.today()+36;
        sp4.Grant__c = dim4.get(0).Id;
        sp1.Approve_Reconciliation__c = true;
        sp4.Requesting_Company__c = company4.Id;
        INSERT sp4;
        
        System.debug('SPR: ' + sp4.Requesting_Company__c);
        
        //Create SPR Reconciliations
        Renconciling_Object__c recon = new Renconciling_Object__c();
        recon.Special_Payment_Request__c  = sp4.Id;
        recon.CurrencyIsoCode = 'KES';
        insert recon;
        
        List<User> userFFA=[Select Name, ID  From User WHERE name='Temp RS Account'];
        if(userFFA.size()>0){
            System.runAs(userFFA.get(0)){
                
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(sp1);
        CreatePinFromSPR sprPin = new CreatePinFromSPR(controller);
        sprPin.CreatePin();
        
        ApexPages.Standardcontroller controller1 = new ApexPages.Standardcontroller(spElectronicVendor);
        CreatePinFromSPR sprPin1 = new CreatePinFromSPR(controller1);
        sprPin1.CreatePin();
        
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(spVendorUSD);
        CreatePinFromSPR sprPin2 = new CreatePinFromSPR(controller2);
        sprPin2.CreatePin();
        
         ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(sp2);
        CreatePinFromSPR sprPin3 = new CreatePinFromSPR(controller3);
        sprPin3.CreatePin();
        
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(spVendorEUR);
        CreatePinFromSPR sprPin4 = new CreatePinFromSPR(controller4);
        sprPin4.CreatePin();
        
        ApexPages.Standardcontroller controller5 = new ApexPages.Standardcontroller(SP3);
        CreatePinFromSPR sprPin5 = new CreatePinFromSPR(controller5);
        sprPin5.CreatePin();
        
        ApexPages.Standardcontroller controller6 = new ApexPages.Standardcontroller(SP4);
        CreatePinFromSPR sprPin6 = new CreatePinFromSPR(controller6);
        sprPin6.CreatePin();
            }
        }
    }
}