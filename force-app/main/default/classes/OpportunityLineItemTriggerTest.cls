@isTest
public class OpportunityLineItemTriggerTest {
    @isTest static void SalesOrderCreation()
    {
        //Test Data Creation
        Account acc= new Account();
        acc.Name='Seafarer';
        insert acc;
        
        Product2 prod = new Product2();
        prod.Name='Jackets Woolen';
        prod.IsActive=true;
        insert prod;
        
        Id pricebookId= Test.getStandardPricebookId();
        PriceBookEntry pbe=new PriceBookEntry();
        pbe.Pricebook2Id= pricebookId;
        pbe.Product2Id = prod.id;
        pbe.UnitPrice = 100.00;
        pbe.IsActive = true;
        insert pbe;
        
        Opportunity opp = new Opportunity();
        opp.AccountId=acc.id;
        opp.Name=acc.Name+'Test Opportunity';
        opp.StageName='Closed Won';
        opp.CloseDate=date.today();
        opp.Pricebook2Id =pbe.Pricebook2Id;
        insert opp;
        
        Sales_Order__c salesOrder= new Sales_Order__c();
        salesOrder.Sales_Order_ExtId__c= opp.id;
        salesOrder.Name= opp.Name;
        salesOrder.Account__c= opp.AccountId;
        insert salesOrder;
        
        OpportunityLineItem oli= new OpportunityLineItem();
        oli.OpportunityId = opp.id;
        //oli.PricebookEntryId = pbe.Pricebook2Id;
        oli.UnitPrice = pbe.UnitPrice;
        oli.Product2Id= prod.Id;
        oli.Quantity = 2;
        insert oli;
        
        
        
        
        
        
        List<OpportunityLineItem> oppUnsortList= new List<OpportunityLineItem>([select id, OpportunityId, UnitPrice, PricebookEntryId, Product2Id,Quantity from OpportunityLineItem]);
        Test.startTest();
        upsert oppUnsortList;
        Test.stopTest();
       
        
        
        
    }
    

}