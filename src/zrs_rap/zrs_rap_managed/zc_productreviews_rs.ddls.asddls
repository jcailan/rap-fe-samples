@EndUserText.label: 'Product Reviews Consumption View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_ProductReviews_RS
  as projection on ZI_ProductReviews_RS
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

      _Products : redirected to parent ZC_Products_RS
}
