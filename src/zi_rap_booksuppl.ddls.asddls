@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View RAP for BookingSupplement'
define view entity ZI_RAP_BOOKSUPPL as select from /dmo/booksuppl_m

association to parent ZI_RAP_BOOKING as _BookingChild on
    $projection.TravelId = _BookingChild.TravelId and
    $projection.BookingId = _BookingChild.BookingId 

association[1..1] to ZR_RAP_TRAVEL as _TravelRoot on
    $projection.TravelId = _TravelRoot.TravelId
    
association[1..1] to /DMO/I_Supplement as _Supplement on
    $projection.SupplementId = _Supplement.SupplementID
    
association[1..*] to /DMO/I_SupplementText as _SupplementText on
    $projection.SupplementId = _SupplementText.SupplementID
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
    supplement_id as SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    currency_code as CurrencyCode,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
//    _association_name // Make association public
    _Supplement,
    _SupplementText,
    _TravelRoot,
    _BookingChild
}
