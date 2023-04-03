@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Reviews Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ProductReviews_RS
  as select from ZR_ProductReviews_RS
  association to parent ZI_Products_RS as _Products on $projection.Product_ID = _Products.ID
{
  key ID,
      Name,
      Rating,
      Comments,
      Product_ID,
      CreatedBy,
      CreatedAt,
      ModifiedBy,
      ModifiedAt,

      _Products
}
