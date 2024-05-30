//@AbapCatalog.sqlViewName: 'ZARCHCOSALESDET'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'for sales item consumption'
define view entity zarch_co_salesdetail as select from zarch_dt_si
association[0..1] to zarch_dt_product as _product on $projection.Product = _product.pro_id
association[0..1] to zarch_co_salesorder as _saleheader on $projection.OrderId = _saleheader.SalesId
{
key item_id as ItemId,
order_id as OrderId,
product as Product,
@Semantics.amount.currencyCode: 'Currency'
amount as Amount,
currency as Currency,
quan as Quan,
unit as Unit,
created_by as CreatedBy,
changed_by as ChangedBy,
created_on as CreatedOn,
changed_om as ChangedOm,
_product,
_saleheader
}
