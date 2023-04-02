@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Products Interface View'
define root view entity ZI_Products_RS
  as select from ZR_Products_RS
  composition [0..*] of ZI_ProductReviews_RS as _Reviews
  composition [0..*] of ZI_SalesData_RS      as _SalesData
  association [0..1] to ZI_Categories_RS     as _Category      on $projection.Category_ID = _Category.ID
  association [0..1] to ZI_Suppliers_RS      as _Supplier      on $projection.Supplier_ID = _Supplier.ID
  association [0..1] to ZI_StockStatuses_RS  as _StockStatus   on $projection.StockStatus_ID = _StockStatus.ID
  association [0..1] to ZI_UnitOfMeasures_RS as _UnitOfMeasure on $projection.UnitOfMeasure_ID = _UnitOfMeasure.ID
  association [0..1] to ZI_AverageRating_RS  as _AverageRating on $projection.ID = _AverageRating.ID
{
  key ID,
      Name,
      Description,
      @Semantics.imageUrl: true
      ImageUrl,
      ReleaseDate,
      DiscontinuedDate,
      @Semantics.amount.currencyCode: 'Currency_ID'
      Price,
      @Semantics.quantity.unitOfMeasure: 'DimensionUnit_ID'
      Height,
      @Semantics.quantity.unitOfMeasure: 'DimensionUnit_ID'
      Width,
      @Semantics.quantity.unitOfMeasure: 'DimensionUnit_ID'
      Depth,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure_ID'
      Quantity,
      UnitOfMeasure_ID,
      Currency_ID,
      Category_ID,
      Supplier_ID,
      DimensionUnit_ID,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      ModifiedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      ModifiedAt,
      StockStatus_ID,
      _AverageRating.Rating as Rating,

      _Reviews,
      _SalesData,
      _Category,
      _Supplier,
      _StockStatus,
      _UnitOfMeasure,
      _AverageRating
}
