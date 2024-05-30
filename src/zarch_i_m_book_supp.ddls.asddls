@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds view for book supp'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zarch_i_m_book_Supp as select from /dmo/book_suppl as booksup
 association to parent zarch_i_m_booking1 as _booksup   --assosiation to booking parentt
 on $projection.TravelId = _booksup.TravelId and
 $projection.BookingId = _booksup.BookingId
 association[1] to zarch_i_m_travel1 as _travel on
 $projection.TravelId = _travel.TravelId
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
    supplement_id as SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    currency_code as CurrencyCode,
    _booksup,
    _travel
}
