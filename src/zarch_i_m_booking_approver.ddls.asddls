 @EndUserText.label: 'projection for booking approver'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo:{
typeName: 'BOOKING',
typeNamePlural: 'BOOKINGS',
title: {value: 'BookingId', label: 'BOOKING ID'},
description: { value: 'CarrierId', label: 'AIRLINE' }
}
@Metadata.allowExtensions: true
define view entity zarch_i_m_booking_approver as projection on zarch_i_m_booking1
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    /* Associations */
    _carrier,
    _conn,
    _customer,
    _TRAVEL: redirected to parent zarch_i_m_travel_approver,
    _booksup: redirected to composition child ZARCH_I_M_BK_SUP_APPROVER
}
