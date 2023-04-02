@AbapCatalog.sqlViewName: 'ZVSUPPLIERS_RS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Suppliers CDS View'
define view ZR_Suppliers_RS
  as select from zasuppliers_rs
{
  key id          as ID,
      name        as Name,
      street      as Street,
      city        as City,
      state       as State,
      postal_code as PostalCode,
      country     as Country,
      email       as Email,
      phone       as Phone,
      fax         as Fax
}
