public with sharing class TeamRespCIController {
    
    public string searchString{get;set;}
    
    public List<Team_Responsibility__c> TeamList{get;set;}
    public List<Team_Responsibility__c> TeamList1{get;set;}
    public List<Team_Responsibility__c> TeamList2{get;set;}
    public List<Team_Responsibility__c> OwnersList{get;set;}
    public BMCServiceDesk__BMC_BaseElement__c baseGeneralInfo{get;set;}
    public List<Team_Member__C> members{get;set;}
    public List<Team_Member__C> members1{get;set;}
    Public List<Team_Member__c> teamMemberResults{get;set;}
    public Map<String, List<Team_Member__c>> teamMap {get; set;}
    public Team_Responsibility__c trSearchCMDB {get;set;}
    
    public TeamRespCIController()
    {
        trSearchCMDB = new Team_Responsibility__c();
        trSearchCMDB.Configuration_Item_CI__c = System.currentPageReference().getParameters().get('AppName');
        //searchString= trSearchCMDB.Configuration_Item_CI__c;
    }
    
  
    public void doSearch()
    {
        searchString= trSearchCMDB.Configuration_Item_CI__c;
        teamMemberResults = [Select Assigned_Team__r.Name,Assigned_Team__r.Team_Lead__r.Name, Status__c, Phone_Number__c, Cell__c,Home_Phone__c, Assigned_Team__r.Team_Name__C, Team_Member_Name__c from Team_Member__c where Assigned_Team__c IN (select Assigned_Team__c from Team_Responsibility__C where Configuration_Item_CI__c =:searchString AND Configuration_Item_CI__r.BMCServiceDesk__MarkAsDeleted__c=:False AND Assigned_Team__r.Id <> NULL AND (Configuration_Item_CI__r.BMCServiceDesk__ClassName__c=:'Database_Instance' OR Configuration_Item_CI__r.BMCServiceDesk__ClassName__c=:'BMC_Application'OR Configuration_Item_CI__r.BMCServiceDesk__ClassName__c=:'BMC_ComputerSystem')) ORDER BY Status__c];
 		
        if(teamMemberResults.isEmpty())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Team Responsibility record found for this CI.'));
        }

        this.teamMap = new Map<String, List<Team_Member__c>>();
        
        for (Team_Member__c tr : teamMemberResults) 
        {
            String teamName = tr.Assigned_Team__r.Team_Name__C + ' - Team Lead : ' + tr.Assigned_Team__r.Team_Lead__r.Name;
            List<Team_Member__c> aTeamList = teamMap.get(teamName);
            
            if (aTeamList == null || aTeamList.isEmpty()) {                
                aTeamList = new List<Team_Member__c>();
            }
            aTeamList.add(tr);
            teamMap.put(teamName, aTeamList);
            
        }
        
    }
    
 
    public List<String> getTeams() 
    {
        if (teamMemberResults == null || teamMemberResults.isEmpty()) 
            return null;
        return new List<String>(this.teamMap.keySet());
        
    }
    
}