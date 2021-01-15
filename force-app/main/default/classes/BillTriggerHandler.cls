public class BillTriggerHandler {
    
    /*
     * Trigger.newMap & Trigger.oldMap exist of the form Map<Id, sobject>
     * Trigger.new & Trigger.old exist of the form List<sobject>
     */
    public static void calculateBill(List<Bill__c> billList) {
        //STEP 1 - Calculate TOTAL AMOUNT
        //Let's first get card details in a map so that we can use that map for amount calclations
        Set<Id> creditCardIds = new Set<Id>();
        for(Bill__c bill : billList) {
            creditCardIds.add(bill.Credit_Card__c);
        }
       
        Map<Id, Credit_Card__c> creditCardMap = new Map<Id, Credit_Card__c>();
        for(Credit_Card__c card : [Select Id, Charges_per_trxm__c , Monthly_Card_Fees__c from Credit_Card__c
                                  			WHERE Id in :creditCardIds]) {
        	creditCardMap.put(card.Id, card);	   
        }
        
        //Calculate the bills
        for(Bill__c bill : billList) {
            if(bill.Total_Transactions__c == null){
                bill.Total_Transactions__c=0;
            }
            bill.Total_Amount__c = 
                creditCardMap.get(bill.Credit_Card__c).Monthly_Card_Fees__c +
                creditCardMap.get(bill.Credit_Card__c).Charges_per_trxm__c * bill.Total_Transactions__c + 
                bill.Amount_Swiped__c + bill.Cash_Withdrawl__c;
            
            //STEP 2 - VALIDATE START AND END DATE
            //Other date validations
            Date startDate = bill.Start_Date__c;
            Date endDate = bill.End_Date__c;
            //toStartOfMonth() is a method inside the framework Date class
            if(startDate != startDate.toStartOfMonth()) {
                bill.addError('The start date is not the start of the month, please check');
            }
            if(endDate != startDate.toStartOfMonth().addMonths(1).addDays(-1)) {
            	bill.addError('The end date is not the end of the month, please check');    
            }
            
            //STEP 3 - CALCULATING DUE DATE 
            bill.Due_Date__c = bill.End_Date__c + 10;
        }
    }
}