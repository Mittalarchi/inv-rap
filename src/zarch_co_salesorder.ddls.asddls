//@AbapCatalog.sqlViewName: 'ZARCHCOSALES'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'for sales consuption view'
define view entity zarch_co_salesorder as select from zarch_dt_so
association[1] to zarxg_i_bp as _businesspartner on
$projection.Buyer = _businesspartner.BpId
{
    key sales_id as SalesId,
    order_no as OrderNo,
    buyer as Buyer,
    gross_amt as GrossAmt,
    currency as Currency,
    created_by as CreatedBy,
    changed_by as ChangedBy,
    created_on as CreatedOn,
    changed_om as ChangedOm,
    _businesspartner 
      //if only this is use then loose coupling will form instead of joins but if we use (.)-then join will form
}   //and this is called adhoc assosiation (not good for performance)
