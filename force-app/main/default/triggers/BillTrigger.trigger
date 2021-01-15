trigger BillTrigger on Bill__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            BillTriggerHandler.calculateBill(Trigger.new);
        }
        if(Trigger.isUpdate) {
        	BillTriggerHandler.calculateBill(Trigger.new);    
        }
        if(Trigger.isDelete) {
            
        }
    }
    
    if(Trigger.isAfter) {
    	if(Trigger.isInsert) {
            
        }
        if(Trigger.isUpdate) {
            
        }
        if(Trigger.isDelete) {
            
        }
        if(Trigger.isUndelete) {
            
        }
    }

}