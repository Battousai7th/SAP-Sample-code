@EndUserText.label: 'Root Projection View RAP for Travel'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_RAP_TRAVEL
  provider contract transactional_query
  as projection on ZR_RAP_TRAVEL
{
      @EndUserText.label: 'Travel ID'
      @ObjectModel.text.element: [ 'Description' ]
  key TravelId,

      @Semantics.text: true
      _Agency.Name            as AgencyName, //Association field

      @EndUserText.label: 'Agency ID'
      @ObjectModel.text.element: [ 'AgencyName' ]
      AgencyId,

      @Semantics.text: true
      _Customer.LastName      as CustomerName,

      @EndUserText.label: 'Customer ID'
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,

      @EndUserText.label: 'Starting Date'
      BeginDate,

      @EndUserText.label: 'Ending Date'
      EndDate,

      @EndUserText.label: 'Booking Fee'
      BookingFee,

      @EndUserText.label: 'Total Price'
      TotalPrice,

      @EndUserText.label: 'Currency Code'
      CurrencyCode,

      @EndUserText.label: 'Description'
      Description,

      @Semantics.text: true
      _OverallStatusText.Text as OverallStatusText,

      @EndUserText.label: 'Overall Status'
      @ObjectModel.text.element: [ 'OverallStatusText' ]
      OverallStatus,

      OverallStatusCriticality, //Color of OverallStatus field

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      /* Associations */
      _Agency,
      _Currency,
      _Customer,
      _OverallStatusText,
      _BookingChild : redirected to composition child ZC_RAP_BOOKING,
      _ImageChild   : redirected to composition child ZC_RAP_IMAGE
}
