trigger InsertAccountonContactInsertion on Contact (after insert) {
    List<Account> acclist  = new List<Account>();
    for (Contact con:trigger.new){
        acclist.add(new Account(Name = con.LastName));
    }
    
    if(!acclist.isEmpty()){
        insert acclist;
    }
    
    List<Contact> conlist = new List<Contact>();
    for(Account acc:acclist){
        for(Contact con:trigger.new){
            Contact c = new Contact();
            C.id = con.Id;
            c.AccountId = acc.Id;
            conlist.add(c); 
        }
    }
    if(!conlist.isEmpty()){
        update conlist;
    }

}