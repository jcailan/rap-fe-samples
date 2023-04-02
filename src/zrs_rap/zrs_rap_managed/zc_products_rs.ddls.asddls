@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Products Consumption View'
@Metadata.allowExtensions: true
define root view entity ZC_Products_RS
  as projection on ZI_Products_RS
{
  key ID,
      Name,
      Description,
      ImageUrl,
      ReleaseDate,
      DiscontinuedDate,
      Price,
      Height,
      Width,
      Depth,
      Quantity,
      UnitOfMeasure_ID,
      Currency_ID,
      @ObjectModel.text.element: ['CategoryName']
      Category_ID,
      _Category.Name    as CategoryName,
      @ObjectModel.text.element: ['SupplierName']
      Supplier_ID,
      _Supplier.Name    as SupplierName,
      DimensionUnit_ID,
      CreatedBy,
      CreatedAt,
      ModifiedBy,
      ModifiedAt,
      @ObjectModel.text.element: ['StatusName']
      StockStatus_ID,
      _StockStatus.Name as StatusName,
      Rating,

      _Reviews   : redirected to composition child ZC_ProductReviews_RS,
      _SalesData : redirected to composition child ZC_SalesData_RS,
      _Category,
      _Supplier,
      _StockStatus
}
