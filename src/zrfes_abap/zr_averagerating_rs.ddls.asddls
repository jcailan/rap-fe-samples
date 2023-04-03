@AbapCatalog.sqlViewName: 'ZVAVGRATING_RS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Average Rating CDS View'
define view ZR_AverageRating_RS
  as select from zaprodreviews_rs
{
  key product_id                    as ID,
      avg(rating as abap.dec(10,2)) as Rating
}
group by
  product_id
