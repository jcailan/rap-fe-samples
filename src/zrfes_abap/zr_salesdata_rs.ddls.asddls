@AbapCatalog.sqlViewName: 'ZVSALESDATA_RS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Data CDS View'
define view ZR_SalesData_RS
  as select from zasalesdata_rs
{
  key id                as ID,
      delivery_date     as DeliveryDate,
      revenue           as Revenue,
      currency_id       as Currency_ID,
      product_id        as Product_ID,
      delivery_month_id as DeliveryMonth_ID
}
