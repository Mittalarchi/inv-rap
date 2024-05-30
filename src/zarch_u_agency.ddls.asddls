@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'agency data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zarch_u_agency as select from /dmo/agency as agency
 association[1] to I_Country as _country on $projection.CountryCode = _country.Country

{
   key agency_id as AgencyId,
   name as Name,
   street as Street,
   postal_code as PostalCode,
   city as City,
   country_code as CountryCode,
   phone_number as PhoneNumber,
   email_address as EmailAddress,
   web_address as WebAddress,
   attachment as Attachment,
   mime_type as MimeType,
   filename as Filename,
   _country

}
