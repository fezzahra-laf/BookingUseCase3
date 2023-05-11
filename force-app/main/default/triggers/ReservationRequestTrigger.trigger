trigger ReservationRequestTrigger on Case (before insert, after update) {
    new ReservationRequestTriggerHandler().run();
}