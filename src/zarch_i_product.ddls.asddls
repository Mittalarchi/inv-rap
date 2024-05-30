//@AbapCatalog.sqlViewName: 'ZARCHIPRODUCT'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'product basic interface'
define view entity zarch_i_product as select from zarch_dt_product
{
   key pro_id as ProId,
   name as Name,
   category as Category,
   price as Price,
   currency as Currency,
   discount as Discount
//   created_by as CreatedBy,
//   changed_by as ChangedBy,
//   created_on as CreatedOn,
//   changed_om as ChangedOm
}
