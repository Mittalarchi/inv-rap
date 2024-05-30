@EndUserText.label: 'booking processor projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo : {
typeName: 'BOOKING',
typeNamePlural: 'BOOKINGS',
title: {
    type: #STANDARD,
    value: 'BookingId'
}}
define view entity zarch_i_m_bookingprocess
  as projection on zarch_i_m_booking1
  
{
@UI.facet: [{ id: 'bookingdetail', label: 'booking details',
 type: #IDENTIFICATION_REFERENCE, purpose: #STANDARD }]
      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
  key TravelId,
      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
  key BookingId,
      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      BookingDate,
      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_CUSTOMER', element: 'CUSTOMERID'} }]
      CustomerId,
      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Carrier', element: 'airlineid'} }]
      CarrierId,
      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      --additonal value help
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Connection', element: 'ConnectionId'},
      additionalBinding: [{ localElement: 'FlightDate' , element: 'FlightDat'}, --additonal value help
      { localElement: 'CarrierId', element: 'airlineid'},
      { localElement: 'FlightPrice', element: 'Price'},
     { localElement: 'CurrencyCode', element: 'CurrencyCode'}  ] }
      ]
      ConnectionId,
      @UI.lineItem: [{ position: 70 }]
      @UI.identification: [{ position: 70 }]
            @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Connection', element: 'ConnectionId'},
      additionalBinding: [{ localElement: 'FlightDate' , element: 'FlightDat'}, --additonal value help
      { localElement: 'CarrierId', element: 'airlineid'},
      { localElement: 'FlightPrice', element: 'Price'},
     { localElement: 'CurrencyCode', element: 'CurrencyCode'}  ] }
      ]
      FlightDate,
      @UI.identification: [{ position: 80 }]
      @UI.lineItem: [{ position: 80 }]
      FlightPrice,
      @UI.lineItem: [{ position: 90 }]
      CurrencyCode,
      /* Associations */
      _carrier,
      _conn,
      _customer,
      _TRAVEL : redirected to parent zarch_i_m_processor
}
