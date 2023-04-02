@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Data Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SalesData_RS
  as select from ZR_SalesData_RS
  association        to parent ZI_Products_RS as _Products on $projection.Product_ID = _Products.ID
  association [0..1] to ZI_Months_RS          as _Months   on $projection.DeliveryMonth_ID = _Months.ID
{
  key ID,
      DeliveryDate,
      @Semantics.amount.currencyCode: 'Currency_ID'
      Revenue,
      Currency_ID,
      Product_ID,
      DeliveryMonth_ID,
      _Months.Name as MonthName,
      _Months.Code as MonthCode,

      _Products,
      _Months
}
