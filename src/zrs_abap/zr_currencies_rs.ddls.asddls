@AbapCatalog.sqlViewName: 'ZVCURRENCIES_RS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Currencies CDS View'
define view ZR_Currencies_RS
  as select from zacurrencies_rs
{
  key id   as ID,
      name as Name
}
