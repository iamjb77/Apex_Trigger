trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) 
{
    List<Task> tasklist= new List<Task>();
    for(opportunity opp: trigger.new){
        if(opp.StageName == 'Closed Won'){
            Task tobj= new Task();
            tobj.Subject= 'Follow Up Test Task';
            tobj.WhatId= opp.Id;
            tasklist.add(tobj);           
        }
    }
    if(tasklist.size()>0){
         insert tasklist;
       }
   

}