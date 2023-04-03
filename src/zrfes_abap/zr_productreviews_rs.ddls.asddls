@AbapCatalog.sqlViewName: 'ZVPRODREVIEWS_RS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Reviews CDS View'
define view ZR_ProductReviews_RS
  as select from zaprodreviews_rs
{
  key id          as ID,
      name        as Name,
      rating      as Rating,
      comments    as Comments,
      product_id  as Product_ID,
      created_by  as CreatedBy,
      created_at  as CreatedAt,
      modified_by as ModifiedBy,
      modified_at as ModifiedAt
}
