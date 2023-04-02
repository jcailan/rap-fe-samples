@AbapCatalog.sqlViewName: 'ZVMONTHS_RS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Months CDS View'
define view ZR_Months_RS
  as select from zamonths_rs
{
  key id   as ID,
      name as Name,
      code as Code
}
