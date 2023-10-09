trigger updateEmployeNumber on Employe__c (before insert,before delete) {
    Set<Id> orgIds = new Set<Id>();
    if(trigger.isInsert){
        for(Employe__c emp: trigger.new){
            if(emp.Organisation__c != null){
                orgIds.add(emp.Organisation__c);
            }
        }
    }
    if(trigger.isDelete){
        for(Employe__c emp: trigger.old){
            if(emp.Organisation__c != null){
                orgIds.add(emp.Organisation__c);
            }
        }
    }
    List<Employe__c> emplyList = [SELECT Id, Name,Organisation__c,Employe_Number__c, EmployeNumberOldValue__c FROM Employe__c WHere Organisation__c IN:orgIds Order by EmployeNumberOldValue__c desc];
    Map<Id,List<Employe__c>> orgIdToEmpList = new Map<Id,List<Employe__c>>();
    for(Employe__c emp:emplyList){
        if(!orgIdToEmpList.containsKey(emp.Organisation__c)){
            orgIdToEmpList.put(emp.Organisation__c,new List<Employe__c>{emp});
        }else{
            orgIdToEmpList.get(emp.Organisation__c).add(emp);
        }
    }
    if(trigger.isInsert){
        for(Employe__c em:trigger.new){ 
            Employe__c empToInsert = new Employe__c();
            if(orgIdToEmpList.containsKey(em.Organisation__c)){
                if(orgIdToEmpList.get(em.Organisation__c) != null){
                    Integer num = Integer.valueOf(emplyList[0].EmployeNumberOldValue__c.remove('Student-'))+1;
                    em.Id = em.Id;
                    em.Employe_Number__c= String.valueOf('Student-')+num;
                    em.EmployeNumberOldValue__c = em.Employe_Number__c;
            }else{
                    em.Employe_Number__c = 'Student-1';
                    em.EmployeNumberOldValue__c=   em.Employe_Number__c;  
                }
            }else{
                em.Employe_Number__c = 'Student-1';
                em.EmployeNumberOldValue__c=   em.Employe_Number__c; 
            }
        }
    }
    if(trigger.isDelete){
        List<Employe__c> updateList = new List<Employe__c>();
        for(Employe__c emp:trigger.old){
            if(orgIdToEmpList.containsKey(emp.Organisation__c) && orgIdToEmpList.get(emp.Organisation__c).size() >1 ){
                for(Employe__c empNew :orgIdToEmpList.get(emp.organisation__c)){
                    Employe__c emp1 = new Employe__c();
                    emp1.Id = empNew.Id;
                    emp1.EmployeNumberOldValue__c = emplyList[0].Employe_Number__c;
                    updateList.add(emp1);
                }
                
            }
        }
        if(!updateList.isEmpty()){
            update updateList;
        }   
    } 
}