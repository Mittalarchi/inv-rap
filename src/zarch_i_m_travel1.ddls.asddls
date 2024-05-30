@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'root entity for RAP BUSINESS OBJECT  TREE'
define root view entity zarch_i_m_travel1 as select from /dmo/travel as TRAVEL
composition[1..*] of zarch_i_m_booking1 as _BOOKING --we need to link it with the child node to consider this as root 
association[0..1] to zarch_u_agency  as _AGENCY on
$projection.AgencyId = _AGENCY.AgencyId
association[0..1] to zarch_u_customer  as _CUSTOMER on
$projection.CustomerId = _CUSTOMER.CustomerId
association[0..1] to I_Currency  as _CURRENCY on
$projection.CurrencyCode = _CURRENCY.Currency

{
    key TRAVEL.travel_id as TravelId,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'zarch_u_agency', element: 'agencyid' } }]
    TRAVEL.agency_id as AgencyId,
     @Consumption.valueHelpDefinition: [{ entity: { name: 'zarch_u_customer', element: 'CustomerId' } }]
    TRAVEL.customer_id as CustomerId,
    TRAVEL.begin_date as BeginDate,
    TRAVEL.end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TRAVEL.booking_fee as BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TRAVEL.total_price as TotalPrice,
    TRAVEL.currency_code as CurrencyCode,
    TRAVEL.description as Description,
    TRAVEL.status as Status,
    @Semantics.user.createdBy: true
    TRAVEL.createdby as Createdby,
    @Semantics.systemDateTime.createdAt: true
    TRAVEL.createdat as Createdat,
    @Semantics.user.lastChangedBy: true
    TRAVEL.lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    TRAVEL.lastchangedat as Lastchangedat,
    _BOOKING,
    _AGENCY,
    _CUSTOMER,
    _CURRENCY
    
     // Make association public
}
