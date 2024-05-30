@EndUserText.label: 'projection for travel approver'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo:{
typeName: 'TRAVEL',
typeNamePlural: 'TRAVELS',
title: {value: 'TravelId', label: 'TRAVELID'},
description: { value: 'Description', label: 'Description' }
}
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity zarch_i_m_travel_approver as projection on zarch_i_m_travel1
{
key TravelId,
@Search.defaultSearchElement: true
@Consumption.valueHelpDefinition: [{entity : { element: 'AgencyId', name: 'zarch_u_agency' } }] 
@ObjectModel.text.element: [ 'AGENCYNAME' ]   --FOR ADDING NAMES
AgencyId,
@Search.defaultSearchElement: true
@Consumption.valueHelpDefinition: [{entity : { element: 'CustomerId', name: 'zarch_u_customer' } }] 
@ObjectModel.text.element: [ 'CUSTOMERNAME' ]
CustomerId,
_AGENCY.Name as AGENCYNAME,   --ADHOC ASSOSIATIONS
_CUSTOMER.FirstName as CUSTOMERNAME,
BeginDate,

EndDate,
BookingFee,
TotalPrice,
CurrencyCode,
Description,
Status,
Createdby,
Createdat,
Lastchangedby,
Lastchangedat,
/* Associations */
_AGENCY,
_BOOKING : redirected to composition child zarch_i_m_booking_approver,
_CURRENCY,
_CUSTOMER
}
