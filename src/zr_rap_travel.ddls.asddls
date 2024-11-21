@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Interface View RAP for Travel'
define root view entity ZR_RAP_TRAVEL
  as select from /dmo/travel_m

  composition [0..*] of ZI_RAP_BOOKING             as _BookingChild
  composition [0..*] of ZI_RAP_IMAGE               as _ImageChild

  association [1] to /DMO/I_Agency                 as _Agency            on $projection.AgencyId = _Agency.AgencyID

  association [1] to /DMO/I_Customer               as _Customer          on $projection.CustomerId = _Customer.CustomerID

  association [1] to I_Currency                    as _Currency          on $projection.CurrencyCode = _Currency.Currency

  association [1] to /DMO/I_Overall_Status_VH_Text as _OverallStatusText on $projection.OverallStatus = _OverallStatusText.OverallStatus
{
  key travel_id       as TravelId,
      agency_id       as AgencyId,
      customer_id     as CustomerId,
      begin_date      as BeginDate,
      end_date        as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee     as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price     as TotalPrice,
      currency_code   as CurrencyCode,
      description     as Description,
      overall_status  as OverallStatus,
      case overall_status
        when 'A' then 3 -- 'Accepted'              |  3: green colour
        when 'O' then 2 -- 'Open'                  |  2: yellow colour
        when 'X' then 1 -- 'Rejected'              |  1: red colour
        else 0          -- 'Not Relevant'          |  0: unknown
      end             as OverallStatusCriticality, //Color of OverallStatus field
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      //    _association_name // Make association public
      _Agency,
      _Customer,
      _Currency,
      _OverallStatusText,
      _BookingChild,
      _ImageChild
}
