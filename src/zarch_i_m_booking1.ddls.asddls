@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'for managed scenario of booking'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zarch_i_m_booking1 as select from /dmo/booking as booking
composition[0..*] of zarch_i_m_book_Supp as _booksup    --comp child to supply and its not compulsary to have snack
association to parent zarch_i_m_travel1 as _TRAVEL on   ---this is for linking 
$projection.TravelId = _TRAVEL.TravelId
association[1..1] to zarch_u_customer as _customer on
$projection.CustomerId = _customer.CustomerId
association[1..1] to /DMO/I_Carrier as _carrier on
$projection.CarrierId = _carrier.AirlineID
association[1..1] to /DMO/I_Connection as _conn on
$projection.CarrierId = _conn.AirlineID and
$projection.ConnectionId = _conn.ConnectionID 
 
{
    key booking.travel_id as TravelId,
    key booking.booking_id as BookingId,
    booking.booking_date as BookingDate,
    booking.customer_id as CustomerId,
    booking.carrier_id as CarrierId,
    booking.connection_id as ConnectionId,
    booking.flight_date as FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    booking.flight_price as FlightPrice,
    booking.currency_code as CurrencyCode,
    _TRAVEL,
    _customer,
    _carrier,
    _conn,
    _booksup
}
