/*
Author          : R.Hari Krishna(ratharik)
Created         : Nov 27,2019
Functionality   : Traverse Territories to get parent/child territory details
Github          : https://github.com/harveensj5/ReusableComponents

Modification History:
***************************************************************************************
Itrack#        Date        Author                             Change  
***************************************************************************************

***************************************************************************************
*/
public class traverseTerritories {
    // To get all sub territories.
    public static Set<ID> getAllSubTerritoryIds(Set<ID> territoryIds) {
        
        Set<ID> currentTerritoryIds = new Set<ID>();
        try {
            // get all of the territories underneath the passed territories
            for(Territory2 teritory :[SELECT Id,Name,ParentTerritory2Id FROM Territory2
                                      where ParentTerritory2Id IN :territoryIds AND ParentTerritory2Id != null] ) {
                                          currentTerritoryIds.add(teritory.Id);
                                      }
            
            // go fetch some more territories!
            if(currentTerritoryIds.size() > 0) {
                currentTerritoryIds.addAll(getAllSubTerritoryIds(currentTerritoryIds));
            }  
            
        }catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return currentTerritoryIds;
        
    }
    
    // To get all Parent territories.
    public static Set<ID> getParentTerritoryId(Set<ID> territoryIds) {
        
        Set<ID> currentTerritoryIds = new Set<ID>();        
        try{
            // get all of the parent territories.
            for(Territory2 teritory :[SELECT Id,Name,ParentTerritory2Id FROM Territory2 
                                      where Id IN: territoryIds]) {
                                          currentTerritoryIds.add(teritory.ParentTerritory2Id);
                                      }
            
            // go fetch some more territories!
            if(currentTerritoryIds.size() > 0) {
                currentTerritoryIds.addAll(getParentTerritoryId(currentTerritoryIds));
            } 
        }catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return currentTerritoryIds;
    }
    
    // To get all users from territories.
    public static Set<String> getTerrUsers(Set<ID> territoryIds) {
        
        Set<String> currentTerritoryUserIds = new Set<String>();        
        try {
            // get all of the parent territories.
            for(UserTerritory2Association userTeritory :[SELECT Id,IsActive,Territory2Id,UserId FROM UserTerritory2Association 
                                                         where IsActive = True 
                                                         AND Territory2Id IN: territoryIds 
                                                         AND User.Additional_User_Permissions__c INCLUDES ('SE User') 
                                                         AND User.IsActive = True 
                                                         LIMIT 50000]) {
                                                             currentTerritoryUserIds.add(userTeritory.UserId);
                                                         }      
        }catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return currentTerritoryUserIds;
    }
    
    // To get all users from territories.
    public static Set<Id> checkUsersBelongToTerr(Set<ID> territoryIdSet,Set<Id> userIdSet) {
        
        Set<Id> currentTerritoryUserIds = new Set<Id>();        
        try {
            // get all of the parent territories.
            for(UserTerritory2Association userTeritory :[SELECT Id,IsActive,Territory2Id,UserId FROM UserTerritory2Association 
                                                         where IsActive = True 
                                                         AND Territory2Id IN: territoryIdSet 
                                                         AND UserId IN: userIdSet
                                                         AND User.Additional_User_Permissions__c INCLUDES ('SE User') 
                                                         AND User.IsActive = True 
                                                         LIMIT 50000]) {
                                                             currentTerritoryUserIds.add(userTeritory.UserId);
                                                         }      
        }catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return currentTerritoryUserIds;
    }
    
    // To get all sub territories.
    public static Set<ID> getAllLevel4TerritoryIds(Set<ID> territoryIds) {
        
        Set<ID> level4TerritoryIds = new Set<ID>();
        Set<String> level4TerrNames = new Set<String>();
        
        try {
            // get all of the level 4 territory names from set of territories received 
            for(Territory2 teritory :[SELECT Id,Name,ParentTerritory2Id,Level_4_Territory__c FROM Territory2
                                      where Id IN :territoryIds AND ParentTerritory2Id != null
                                     AND Level_4_Territory__c != null] ) {
                                          level4TerrNames.add(teritory.Level_4_Territory__c);
                                      }
            
            //get Territory Ids for those level4TerrNames
            for(Territory2 teritory :[SELECT Level_4_Territory__c,Name,Id FROM Territory2
                                      WHERE Name IN : level4TerrNames
                                      ] ) {
                                          level4TerritoryIds.add(teritory.Id);
                                      }
            
        }catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return level4TerritoryIds;
        
    }
     
}