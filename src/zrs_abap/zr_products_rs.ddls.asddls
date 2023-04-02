@AbapCatalog.sqlViewName: 'ZVPRODUCTS_RS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Products CDS View'
define view ZR_Products_RS
  as select from zaproducts_rs
{
  key id                                                                                  as ID,
      name                                                                                as Name,
      description                                                                         as Description,
      concat('https://raw.githubusercontent.com/jcailan/cap-fe-samples/master',image_url) as ImageUrl,
      release_date                                                                        as ReleaseDate,
      discontinued_date                                                                   as DiscontinuedDate,
      price                                                                               as Price,
      height                                                                              as Height,
      width                                                                               as Width,
      depth                                                                               as Depth,
      quantity                                                                            as Quantity,
      unit_of_measure_id                                                                  as UnitOfMeasure_ID,
      currency_id                                                                         as Currency_ID,
      category_id                                                                         as Category_ID,
      supplier_id                                                                         as Supplier_ID,
      dimension_unit_id                                                                   as DimensionUnit_ID,
      created_by                                                                          as CreatedBy,
      created_at                                                                          as CreatedAt,
      modified_by                                                                         as ModifiedBy,
      modified_at                                                                         as ModifiedAt,

      case
        when quantity >= 8 then 3
        when quantity > 0 then 2
        else 1
      end                                                                                 as StockStatus_ID
}
