@EndUserText.label: 'Projection View RAP for Booking'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_RAP_BOOKING as projection on ZI_RAP_BOOKING
{
    @EndUserText.label: 'Travel ID'
    key TravelId,
    @EndUserText.label: 'Booking ID'
    key BookingId,
    @EndUserText.label: 'Booking Date'
    BookingDate,
    @EndUserText.label: 'Customer ID'
    CustomerId,
    @EndUserText.label: 'Carrier ID'
    CarrierId,
    @EndUserText.label: 'Connection ID'
    ConnectionId,
    @EndUserText.label: 'Flight Date'
    FlightDate,
    @EndUserText.label: 'Flight Price'
    FlightPrice,
    @EndUserText.label: 'Currency Code'
    CurrencyCode,
    @EndUserText.label: 'Booking Status'
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _BookingStatus,
    _Carrier,
    _Connection,
    _Customer,
    _TravelRoot : redirected to parent ZC_RAP_TRAVEL,
    _BookSupplChild : redirected to composition child ZC_RAP_BOOKSUPPL
}
