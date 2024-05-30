@EndUserText.label: 'processor scenario cds projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI.headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travel',
    description : { value: 'Description' },
    title : {value: 'TravelId' }

}

@Search.searchable: true
define root view entity zarch_i_m_processor
  as projection on zarch_i_m_travel1
{
      @Search.defaultSearchElement: true
      @UI.facet: [{

          id: 'Details',
          purpose: #STANDARD,
      type: #IDENTIFICATION_REFERENCE,
      label: 'Travel Details',position: 10
      }
           ,{

          id: 'Bookings',
          purpose: #STANDARD,
      type: #LINEITEM_REFERENCE,
      label: 'Booking Details',position: 20,
      targetElement: '_BOOKING'    --this is refering below in fields to booking child node( _BOOKING : redirected to composition child zarch_i_m_bookingprocess,)
      }]
      @UI: {selectionField: [{ position:  10 }],
      lineItem: [{ position: 10 }],
      identification: [{ position: 10 }]
      }
      @ObjectModel.text.element: [ 'Description' ]
  key TravelId,
      @Search.defaultSearchElement: true
      @UI: {selectionField: [{ position:  20 }],
      lineItem: [{ position: 20 }],
      identification: [{ position: 20 }]
      }
      _AGENCY.Name as agencyname,       --these are added to get names as description(means text showing on ui)
      _CUSTOMER.LastName as customername,
      @ObjectModel.text.element: [ 'agencyname' ]
      AgencyId,
      @Search.defaultSearchElement: true
      @UI: {selectionField: [{ position:  30 }],
      lineItem: [{ position: 30 }],
      identification: [{ position: 30 }]
      }
      @ObjectModel.text.element: [ 'customername' ]
      CustomerId,
      @UI.identification: [{ position: 40 }]
      BeginDate,
      @UI.identification: [{ position: 50 }]
      EndDate,
      @UI.identification: [{ position: 60 }]
      BookingFee,
      @UI.identification: [{ position: 70 }]
      TotalPrice,
      @UI.identification: [{ position: 80 }]
      CurrencyCode,
      @UI.identification: [{ position: 90 }]
      Description,
      @UI.identification: [{ position: 100 }]
      @UI: { lineItem: [{ position: 40 , importance: #HIGH},
      { type: #FOR_ACTION , dataAction: 'createtravelbytemp', label: 'copy travel' }] 
      }
      Status,
      @UI.identification: [{ position: 110 }]
      Createdby,
      @UI.identification: [{ position: 120 }]
      Createdat,
      Lastchangedby,
      Lastchangedat,
      /* Associations */
      _AGENCY,
      _BOOKING : redirected to composition child zarch_i_m_bookingprocess,
      _CURRENCY,
      _CUSTOMER
}
