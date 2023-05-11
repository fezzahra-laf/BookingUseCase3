public with sharing class ReservationRequestTriggerHandler extends TriggerHandler{

    private List<Case> oldReservationList, newReservationList;
    private Map<Id, Case> oldReservationMap, newAReservationMap;
    
    public ReservationRequestTriggerHandler() {

        oldReservationList  = (List<Case>) Trigger.old;
        newReservationList  = (List<Case>) Trigger.new;
        oldReservationMap   = (Map<Id, Case>) Trigger.oldMap;
        newAReservationMap  = (Map<Id, Case>) Trigger.newMap;

    }

    public override void beforeInsert(){
        ReservationRequestTriggerHelper.checkConditions(newReservationList);
    }

    public override void afterUpdate() {
        ReservationRequestTriggerHelper.confirmReservation(oldReservationMap,newAReservationMap);
    }

}