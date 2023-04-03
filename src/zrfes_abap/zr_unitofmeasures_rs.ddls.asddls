@AbapCatalog.sqlViewName: 'ZVUNITOFMEASU_RS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unit of Measures CDS View'
define view ZR_UnitOfMeasures_RS
  as select from zaunitofmeasu_rs
{
  key id   as ID,
      name as Name
}
