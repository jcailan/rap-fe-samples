@AbapCatalog.sqlViewName: 'ZVSTOCKSTATUS_RS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Statuses CDS View'
define view ZR_StockStatuses_RS
  as select from zastockstatus_rs
{
  key id   as ID,
      name as Name
}
