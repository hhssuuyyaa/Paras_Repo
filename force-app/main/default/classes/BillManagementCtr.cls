public class BillManagementCtr {
    
    public Bill__c billRecord {get;set;}
    public List<Bill__c> billRecords {get;set;}
    
    //COnstructor of a VF Page Controller automatically gets called when the page is loaded
    public BillManagementCtr() {
    	billRecord = new Bill__c();    
        billRecords = new List<Bill__c>();
        getBills();
    }
    
    public void createBill() {
    	INSERT billRecord;  
        if(billRecord.Id != null) {
            //INFO,ERROR,DEBUG
            /*
             * addMessage is a static method of the ApexPages framework class which takes in a single parameter as an Object 
             * of the inner class of ApexPages called message.
             * In the constructor of the message class there are two params where one is an ENUM type (severity in message class)
             * and another is a string
             */
        	ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'The Bill got created successfully!!!'));    
        }
        billRecord = new Bill__c();
        getBills();
    }
    
    public void getBills() {
        billRecords = [Select Id, Name, Customer__c, Credit_Card__c, Start_Date__c, End_Date__c,
                      	Due_Date__c, Amount_Swiped__c, Cash_Withdrawl__c, Total_Amount__c, Credit_Card_Number__c,
                        Total_Transactions__c FROM Bill__c order by Name desc];
    }

}