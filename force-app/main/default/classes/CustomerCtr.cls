public class CustomerCtr {
    public Customer__C	customerRecord {get;set;}
    public List<Customer__C> customerRecords {get;set;}
    
    public CustomerCtr(){
        customerRecord = new Customer__C();
        customerRecords = new List<Customer__C>();
        getCustomers();
    }
    
    public void createCustomer(){
        INSERT customerRecord;
        customerRecord = new Customer__C();
        getCustomers();
    }
        
    public void getCustomers(){
        customerRecords = [Select Name,Phone__C,Email__C,Customer__C From Customer__C order by Name desc];
    }
}