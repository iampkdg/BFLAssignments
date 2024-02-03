/**************
 * Trigger on Contact 
 * 1. ContactTriggerHandlerMethod() ->
 *      This works on insertion of new contacts and calls ContactTriggerHandler.ContactTriggerHanlderMethod
***************/

trigger ContactTrigger on Contact (after insert) 
{
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            ContactTriggerHandler.ContactTriggerHanlderMethod(Trigger.new);
        }
        
    }
}
