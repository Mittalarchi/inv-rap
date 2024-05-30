//@AbapCatalog.sqlViewName: 'ZARCHCOCOUNT'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'country wise sales'
define view entity zarch_co_salescountrywise
  as select from zarch_co_salesdetail
{

  key _saleheader._businesspartner.Country,
      //key _product.name,
      @Semantics.amount.currencyCode: 'Currency'
      sum( _saleheader.GrossAmt ) as totalamt,
      _saleheader.Currency

}
group by
  _saleheader._businesspartner.Country,
  _saleheader.Currency
