@isTest
private class BillListManagementTest {
    private @testSetup static void testData(){
        Customer__c cust = new Customer__c();
        cust.Name = 'Rohit Sharma';
        cust.Customer__c = '1212121212121212';
        cust.Email__c = 'rohitsharma@edureka.com';
        cust.Phone__c = '9090909090';
        INSERT cust;
        system.debug('Customer ID:'+cust.Name);
        
        Credit_card__c card = new Credit_card__c();
        card.Card_Limit__c = 122222.00;
        card.Card_Type__c ='Gold';
        card.Charges_per_trxm__c = 2;
        card.Monthly_Card_Fees__c = 100;
        INSERT card; 
        system.debug('Credit ID:'+card.Name);
        
        
        Bill__c bill = new Bill__c();
        bill.Customer__c = cust.ID;
        bill.Credit_Card__c = card.ID;
        bill.Amount_Swiped__c = 100;
    	bill.Cash_Withdrawl__c = 100;
        bill.Credit_Card_Number__c = '111111111111';
        bill.Start_Date__c = system.today().toStartOfMonth();
        bill.End_Date__c   = system.today().toStartOfMonth().addMonths(1).addDays(-1);
        bill.Total_Transactions__c = 10;
        bill.Due_Date__c = system.today();
        bill.Total_Amount__c = 0.0;
        INSERT bill;
        
        try{        
            Credit_card__c card2 = new Credit_card__c();
            card2.Card_Limit__c = 122222.00;
            card2.Card_Type__c ='Gold';
            INSERT card2; 
    
            
            Bill__c bill2 = new Bill__c();
            bill2.Customer__c = cust.ID;
            bill2.Credit_Card__c = card2.ID;
            bill2.Credit_Card_Number__c = '11111111111134';
            bill2.Start_Date__c = system.today();
            bill2.End_Date__c   = system.today();
            INSERT bill2;
		}
        catch(Exception e) {
           // System.assertEquals(true, (e.getMessage()).contains('The end date is not the end of the month, please check'));
        }       
    }
    
    private @isTest static void testCalculateBill(){
    	Bill__c bill2 = [Select ID, Name, Customer__c,Credit_Card__c,
                           Credit_Card_Number__c,Start_Date__c,
                           End_Date__c,Due_Date__c,Cash_Withdrawl__c,
                           Total_Transactions__c,Amount_Swiped__c,
                           Total_Amount__c 
                           from Bill__c 
                           where Credit_Card_Number__c = '111111111111'];
        bill2.Amount_Swiped__c = 200;
        UPDATE bill2;
        
        Bill__c bill3 = [Select ID, Name, Customer__c,Credit_Card__c,
                           Credit_Card_Number__c,Start_Date__c,
                           End_Date__c,Due_Date__c,Cash_Withdrawl__c,
                           Total_Transactions__c,Amount_Swiped__c,
                           Total_Amount__c 
                           from Bill__c 
                           where Credit_Card_Number__c = '111111111111'];
        System.assertEquals(200,bill3.Amount_Swiped__c);
        
        System.assertEquals(420,bill3.Total_Amount__c);
    }
}