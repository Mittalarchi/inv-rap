//@AbapCatalog.sqlViewName: 'ZARXGIBP'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business partner basic interface'
define view entity zarxg_i_bp as select from zarch_dt_bpa
{
key bp_id as BpId,
bp_role as BpRole,
company as Company,
street as Street,
city as City,
country as Country,
region as Region
//created_by as CreatedBy,
//changed_by as ChangedBy,
//created_on as CreatedOn,
//changed_om as ChangedOm
    
}
