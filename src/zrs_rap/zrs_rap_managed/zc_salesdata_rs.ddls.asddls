@EndUserText.label: 'Sales Data Consumption View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_SalesData_RS
  as projection on ZI_SalesData_RS
{
  key ID,
      DeliveryDate,
      Revenue,
      Currency_ID,
      Product_ID,
      @ObjectModel.text.element: ['MonthName']
      DeliveryMonth_ID,
      MonthName,
      MonthCode,

      /* Associations */
      _Products : redirected to parent ZC_Products_RS
}
