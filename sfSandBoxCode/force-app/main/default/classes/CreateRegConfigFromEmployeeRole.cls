public class CreateRegConfigFromEmployeeRole{
  //create standard constructor
  	private ApexPages.StandardController controller;
      
    //getters and setters for the Reg_config variable
    public Reg_Config__c regConfig {get; set;}
    
    //getters and setters for the Employee Role variable
    public Employee_Role__c empRole {get; set;}
     
    public List<RegConfigWrapper> wrpRegCon {get;set;}
    public List<Reg_Config__c> regConRecords {get; set;}
    public List<Reg_Config__c> regConfigRecords {get; set;}
    List<Reg_Mapping__c> existingRegMap = new List<Reg_Mapping__c>();

    public CreateRegConfigFromEmployeeRole(ApexPages.StandardController controller) {
        empRole = (Employee_Role__c)controller.getRecord();

        //declare counter
        integer outerLoopCounter = 0;
        //Get DISCTINCT list of REG Configs
        AggregateResult[] agRegConfigOptions = [SELECT REG_Code__c,Reg_Factor__c, Guiding_Question__c
                                                FROM Reg_Config__c 
                                                GROUP BY Reg_Factor__c,REG_Code__c,Guiding_Question__c 
                                                ORDER  BY Reg_Code__c ASC ];
        wrpRegCon = new List<RegConfigWrapper>();

      
        //Loop through the list and add to display
        if(agRegConfigOptions != null && agRegConfigOptions.size() > 0){
            //get the Reg Mapping values that have already been set for the role if any exists
            
            existingRegMap = 
                [
                    SELECT id, Name, Reg_Factor__c, Reg_Factor__r.Guiding_Question__c
                    FROM Reg_Mapping__c
                    WHERE Employee_Role__c = : empRole.id
                ];
            for(AggregateResult aggRes : agRegConfigOptions){
                regConfigRecords = new List<Reg_Config__c>();
                regConRecords = new List<Reg_Config__c>();
                
                for(Reg_Config__c c : [SELECT REG_Code__c, Guiding_Question__c, Level__c, Level_Description__c, Name,
                                       Reg_Factor__c FROM Reg_Config__c WHERE REG_Code__c =:  String.valueOf(agRegConfigOptions[outerLoopCounter].get('REG_Code__c')) ORDER  BY Reg_Code__c ASC ])
                {
                    regConRecords.add(c);
                }
                
                RegConfigWrapper wrpRegConItem = new RegConfigWrapper(regConRecords, existingRegMap);
                wrpRegCon.add(wrpRegConItem);
                
                outerLoopCounter +=1;
            }
            
        }   
    }   

             
    public PageReference createRegMap(){
        string regFactorID ='';
        boolean dontSaveRegMapRecords = false;
        
        system.debug('wrpRegCon = ' + wrpRegCon );
        //Get all Reg configs
        List<Reg_Config__c> allRegConfigs = [SELECT id, REG_Code__c,Reg_Factor__c, Guiding_Question__c, Level__c
                                             FROM Reg_Config__c 
                                             ORDER BY Reg_Code__c ASC, Name ]; 
        List<Reg_Mapping__c> regMapToSave = new List<Reg_Mapping__c>();                
        
        for(RegConfigWrapper wrp : wrpRegCon){
            dontSaveRegMapRecords = false; //set default
            if(wrp.regConfigLevel != '' && wrp.regConfigLevel != '--'){
                //loop through list to get GUID for matching level/Factor
                for(Reg_Config__c c : allRegConfigs){
                    if(c.Reg_Factor__c == wrp.regConfigFactor && c.Level__c == wrp.regConfigLevel){
                        regFactorID = c.id;
                        break;
                    }
                }
                system.debug('regFactorID = ' + regFactorID);
                if(regFactorID != NULL && regFactorID != ''){
                    //add record to save
                    regMapToSave.add(
                        new Reg_Mapping__c (
                            Employee_Role__c = empRole.Id,
                            Reg_Factor__c = regFactorID
                        )
                    ); 
                }
                
                
            }else
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Level not provided for "' + wrp.regConfigFactor + '"');
                ApexPages.addmessage(msg);
               // regMapToSave.clear();
                dontSaveRegMapRecords = true;
            }
            system.debug('regConfigFactor = ' + wrp.regConfigFactor + ' regConfigLevel = ' + wrp.regConfigLevel);
        }
        if(dontSaveRegMapRecords == false){
            DELETE existingRegMap; //Delete existing mapped records
            INSERT regMapToSave;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'Records successfully updated');
            ApexPages.addmessage(msg);
            
            //return to same VF page and refresh
            PageReference pageRef = new PageReference('/apex/CreateRegConfigFromEmplyeeRole');
            pageRef.getParameters().put('Id',empRole.Id);
            pageRef.setRedirect(true);
            return pageRef;
        }else
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'No Reg Mapping records were Updated');
            ApexPages.addmessage(msg);
        }
        
   		return null;     
    }
       
    public class RegConfigWrapper{
        public List <Reg_Config__c> regConfigList {get; set;}
        public List <Reg_Mapping__c> roleRegMap {get; set;}
        public List<RegConfigItemWrapper> regConfigItems {get;set;}
        public String regConfigGUID {get; set;}
        public String regConfigLevel {get; set;}
        public String regConfigFactor {get; set;}
        public String regConfigGuiding {get; set;}
        
        public RegConfigWrapper(List<Reg_Config__c> regCon, List <Reg_Mapping__c> regMapList){
            regConfigList = regCon;
            roleRegMap = regMapList;
            regConfigItems = new List<RegConfigItemWrapper>();
            if(regConfigList != NULL && regConfigList.size()>0){
                //populate list of Items
                
                for(Reg_Config__c rc : regConfigList){
                    regConfigGUID = rc.id;//Set default
                    regConfigFactor = rc.Reg_Factor__c; //Set default
                    regConfigGuiding = rc.Guiding_Question__c; //Set default
                    
                    //loop through Reg Map and flag if existing reg map found
                    for (Reg_Mapping__c r: roleRegMap){
                        if(r.Reg_Factor__c == rc.id){
                            regConfigLevel = rc.Level__c;
                        }
                    }
                    regConfigItems.add(new RegConfigItemWrapper(rc, roleRegMap));
                }
                system.debug ('regConfigList ==' + regConfigList);
            }
        }
    }
    
    public class RegConfigItemWrapper{
        public Reg_Config__c regConfigItemList {get; set;}
        public Boolean selectedRecord {get; set;}
        public String regConfigName {get; set;}
        public String regConfigFactor {get; set;}
        public String regConfigLevel {get; set;}
        public String regConfigDesc {get; set;}
        public String regConfigID {get; set;}
        public String regConfigRowStyle {get; set;}
        
        public RegConfigItemWrapper(Reg_Config__c regCon, List<Reg_Mapping__c> roleRegMap){
            regConfigItemList = regCon;
            if(regConfigItemList != NULL ){
                regConfigID = regConfigItemList.id;
                regConfigName = regConfigItemList.Name;
                regConfigFactor = regConfigItemList.Reg_Factor__c;
                regConfigLevel = regConfigItemList.Level__c;
                regConfigDesc = regConfigItemList.Level_Description__c;
                
                selectedRecord = FALSE;
                regConfigRowStyle = 'background:white;font-weight: normal;';
                //loop through Reg Map and flag if existing reg map found
                for (Reg_Mapping__c r: roleRegMap){
                    if(r.Reg_Factor__c == regConfigItemList.id){
                        selectedRecord = TRUE;
                        regConfigRowStyle = 'background:#e5f5cb;font-weight: bold;'; //Highlight selected row
                    }
                }
            }
        }
    }
  
}