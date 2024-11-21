@EndUserText.label: 'Projection View RAP for BookingSuppl'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_RAP_BOOKSUPPL as projection on ZI_RAP_BOOKSUPPL
{
    @EndUserText.label: 'Travel ID'
    key TravelId,
    @EndUserText.label: 'Booking ID'
    key BookingId,
    @EndUserText.label: 'Booking Supplement ID'
    key BookingSupplementId,
    @EndUserText.label: 'Supplement ID'
    SupplementId,
    @EndUserText.label: 'Price'
    Price,
    @EndUserText.label: 'Currency Code'
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Supplement,
    _SupplementText,
    _TravelRoot : redirected to ZC_RAP_TRAVEL,
    _BookingChild : redirected to parent ZC_RAP_BOOKING
}
