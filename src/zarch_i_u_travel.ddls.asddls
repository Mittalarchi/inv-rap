@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'root view for travel unmanaged scenarios'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity zarch_i_u_travel as select from /dmo/travel as travel
association[1] to zarch_u_agency as _agency on $projection.AgencyId = _agency.AgencyId
association[1] to zarch_u_customer as _customer on $projection.CustomerId = _customer.CustomerId
association[1] to I_Currency as _currency on $projection.CurrencyCode = _currency.Currency
association[1] to /DMO/I_Travel_Status_VH as _travelstat on $projection.Status = _travelstat.TravelStatus

{

    key travel_id as TravelId,
    agency_id as AgencyId,
    customer_id as CustomerId,
    begin_date as BeginDate,
    end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    booking_fee as BookingFee,
     @Semantics.amount.currencyCode: 'CurrencyCode'
    total_price as TotalPrice,
    currency_code as CurrencyCode,
    description as Description,
    
    --CASE STATEMENT IS ADD TO SHOW COLOR ICON , AND CRITICALITY IS A VIRTUAL FIELD(LINKED TO ANNO)  AND WE HAVE TO LINK IN MDE FOR SHOWING ICON AND COLOR
    case status
    when 'N' then 3 ---GREEN
    when 'B' then 2 -- YELLOW
    when 'X' then 1 --RED
    else 0 end as CRITICALITY,
    status as Status,
    _travelstat._Text[Language = 'E'].Text as STATU,  // "FOR SHOWING TEXT IN STATUS FIELD
    createdby as Createdby,
    createdat as Createdat,
    lastchangedby as Lastchangedby,
    lastchangedat as Lastchangedat,
    _agency,
    _customer,
    _currency,
    _travelstat
    
}
