@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View RAP for Booking'
define view entity ZI_RAP_BOOKING as select from /dmo/booking_m

composition[0..*] of ZI_RAP_BOOKSUPPL as _BookSupplChild

association to parent ZR_RAP_TRAVEL as _TravelRoot
    on $projection.TravelId = _TravelRoot.TravelId
    
association[1..1] to /DMO/I_Customer as _Customer on
    $projection.CustomerId = _Customer.CustomerID
    
association[1..1] to /DMO/I_Carrier as _Carrier on
    $projection.CarrierId = _Carrier.AirlineID
    
association[1..1] to /DMO/I_Connection as _Connection on
    $projection.CarrierId = _Connection.AirlineID and
    $projection.ConnectionId = _Connection.ConnectionID
    
association[1..1] to /DMO/I_Booking_Status_VH as _BookingStatus on
    $projection.BookingStatus = _BookingStatus.BookingStatus
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    booking_date as BookingDate,
    customer_id as CustomerId,
    carrier_id as CarrierId,
    connection_id as ConnectionId,
    flight_date as FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    flight_price as FlightPrice,
    currency_code as CurrencyCode,
    booking_status as BookingStatus,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
//    _association_name // Make association public
    _Customer,
    _Carrier,
    _Connection,
    _BookingStatus,
    _TravelRoot,
    _BookSupplChild
}
