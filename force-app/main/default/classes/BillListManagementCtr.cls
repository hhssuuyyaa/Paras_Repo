public class BillListManagementCtr {
    
    public List<BillWrapper> billWrapperList {get;set;}
    public List<Bill__c> billRecords{get;set;}
    public String searchText {get;set;}
    public Boolean readOnlyMode {get;set;}
    public Boolean editOnlyMode {get;set;}
    
    public BillListManagementCtr() {
        billWrapperList = new List<BillWrapper>();
        billRecords = new List<Bill__c>();
        getBills();
        readMode();	
    }
    
    public void editMode() {
    	readOnlyMode = false;
        editOnlyMode = true;    
    }
    
    public void readMode() {
    	readOnlyMode = true;
        editOnlyMode = false;    
    }
    
    public void updateBills() {
        try {
        	UPDATE billRecords;    
        } catch(Exception e) {
        	ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR,'Error Validation:' + e.getMessage()));    
        }
        getBills();
        readMode();
    }
   
    public void getBills() {
        String keyWord;
        if(searchText == null) {
            keyWord = '%%';
        } else {
            keyWord = '%' + searchText + '%';
        }
        billRecords = [Select Id, Name, Customer__c, Credit_Card__c, Start_Date__c, End_Date__c,
                      	Due_Date__c, Amount_Swiped__c, Cash_Withdrawl__c, Total_Amount__c, Credit_Card_Number__c,
                        Total_Transactions__c FROM Bill__c WHERE Name like :keyWord OR Credit_Card__r.Name like :keyWord order by Name desc];	
        billWrapperList = new List<BillWrapper>();
        for(Bill__c billRec : billRecords) {
        	BillWrapper obj = new BillWrapper(billRec, false);    
            billWrapperList.add(obj);
        }
    }
    
    public void deleteBills() {
        List<Bill__c> recordsToBeDeleted = new List<Bill__c>();
        for(BillWrapper wrap : billWrapperList) {
            if(wrap.selct == true) {
            	recordsToBeDeleted.add(wrap.bill);
            }
        }
        DELETE recordsToBeDeleted;	
        getBills();
        ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Records were deleted!!!'));
    }
    
    //I create a wrapper to attach the bill object record with a select checkbox, so that i use that in the UI
    public class BillWrapper {
        public Bill__c bill{get;set;}
        public Boolean selct{get;set;}
        
        public BillWrapper(Bill__c billInp, Boolean selectInp) {
            bill=billInp;
            selct=selectInp;
        }
    }
}