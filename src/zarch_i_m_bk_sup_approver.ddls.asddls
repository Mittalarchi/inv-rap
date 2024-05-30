@EndUserText.label: 'projection on booking supplement'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity zarch_i_m_bk_sup_approver as projection on zarch_i_m_book_Supp
{

@Search.defaultSearchElement: true
    key TravelId,
    @Search.defaultSearchElement: true
    key BookingId,
    @Search.defaultSearchElement: true
    key BookingSupplementId,
    SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    CurrencyCode,
    /* Associations */
    _booksup : redirected to parent zarch_i_m_booking_approver,
    _travel
}
