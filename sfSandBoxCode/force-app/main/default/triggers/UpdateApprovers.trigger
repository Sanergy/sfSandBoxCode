trigger UpdateApprovers on PTS_Line_Item__c (before insert) {
    /*for(PTS_Line_Item__c  ptsLine:Trigger.new){
        
        Procurement_Tracking_Sheet__c pts=[SELECT Team_Ld__c, Team_Ld__r.Team_Lead__c
                                           FROM Procurement_Tracking_Sheet__c 
                                           WHERE id=:ptsLine.Procurement_Tracking_Sheet__c];
                                           
        if(pts!=null){
            ptsLine.Approver__c=pts.Team_Ld__c;
            ptsLine.Quote_Approving_Director__c=pts.Team_Ld__r.Team_Lead__c;
        }
    }*/
}