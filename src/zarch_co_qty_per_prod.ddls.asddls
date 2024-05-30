@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'for quant per product'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zarch_co_qty_per_prod as select from zarch_co_salesdetail
{
key _product.name,
@Semantics.quantity.unitOfMeasure: 'unit'
sum(Quan) as totalquan,
Unit
    
}group by Unit, _product.name
