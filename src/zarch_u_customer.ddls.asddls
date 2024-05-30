@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'customer activity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zarch_u_customer as select from /dmo/customer as customer 
association[1] to I_Country as _country on $projection.CountryCode = _country.Country
{
    key customer_id as CustomerId,
    first_name as FirstName,
    last_name as LastName,
    title as Title,
    street as Street,
    postal_code as PostalCode,
    city as City,
    country_code as CountryCode,
    phone_number as PhoneNumber,
    email_address as EmailAddress,
    _country
//    local_created_by as LocalCreatedBy,
//    local_created_at as LocalCreatedAt,
//    local_last_changed_by as LocalLastChangedBy,
//    local_last_changed_at as LocalLastChangedAt,
//    last_changed_at as LastChangedAt
}
