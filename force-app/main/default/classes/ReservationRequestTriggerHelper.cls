public with sharing class ReservationRequestTriggerHelper {

    public static void checkConditions(List<Case> reservations){

        Map<Id, List<Case>> accountReservationsMap = new Map<Id, List<Case>>();

        for(Case reservation : reservations){
            if(reservation.AccountId == null){
                reservation.addError(Label.ReservationWithoutAccount);
            }
            else{
                if(accountReservationsMap.containsKey(reservation.AccountId)){
                    accountReservationsMap.get(reservation.AccountId).add(reservation);
                }
                else{
                    accountReservationsMap.put(reservation.AccountId, new List<Case>{reservation});
                }
            } 
        }

        List<Account> accountsContacts = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN: accountReservationsMap.keyset()];
        for(Account account : accountsContacts){

            Integer contactsSize = account.Contacts.size();
            for(Case reservation : accountReservationsMap.get(account.id)){

                if(contactsSize == 0){
                    reservation.addError(Label.NoContactInfo);
                }else{
                    switch on reservation.Origin {
                        when 'Web' {
                            if(contactsSize >= 2 ){
                                reservation.addError(Label.OnlyOneAttendeeForWeb);
                            }
                        }
                        when 'Phone'{
                            if(contactsSize >= 4 ){
                                reservation.addError(Label.OnlyThreeAttendeeForPhone);
                            }
                        }
                    } 
                }
            }
        }   

    }

    public static void confirmReservation(Map<Id,Case> oldReservations, Map<Id,Case> newReservations){

        Set<Id>  reservationsAccounts= new Set<Id>();

        for(Id reservationId : newReservations.keySet()){

            if(oldReservations.get(reservationId).Status != newReservations.get(reservationId).Status &&  newReservations.get(reservationId).Status == 'Closed' && newReservations.get(reservationId).AccountId != null){
                reservationsAccounts.add(newReservations.get(reservationId).AccountId);
            }

        } 

        ExternalSystemService.registerAttendees(reservationsAccounts);
    
    }
        
}