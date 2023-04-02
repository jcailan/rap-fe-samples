@AbapCatalog.sqlViewName: 'ZVCATEGORIES_RS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Categories CDS View'
define view ZR_Categories_RS
  as select from zacategories_rs
{
  key id   as ID,
      name as Name
}
