trigger Accounttocontactupdate on Account (after update) 
{
    // storing the new id of account in set
    set<id> getaccid= new set<id>();
    //intialise the variable
    for(account a:trigger.new)
    {
        getaccid.add(a.id);       
    }
    // querythe data
    list<contact> c= [select id,accountid from contact where accountid in:getaccid];
    list<contact> updatecontact =new list<contact>();
    for(account a: trigger.new){
        for(contact c1:c)
        {
          c1.Mailingstreet=a.Billingstreet;
          updatecontact.add(c1);
        }
        
    }
    update updatecontact; 
    
    

}