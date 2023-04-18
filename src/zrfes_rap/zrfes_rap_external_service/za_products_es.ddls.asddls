/********** GENERATED on 04/17/2023 at 12:40:31 by CB9980000000**************/
@OData.entitySet.name: 'Products'
@OData.entityType.name: 'Products'
define root abstract entity ZA_PRODUCTS_ES
{
  key ID                  : sysuuid_x16;
      @OData.property.valueControl: 'createdAt_vc'
      createdAt           : tzntstmpl;
      createdAt_vc        : rap_cp_odata_value_control;
      @OData.property.valueControl: 'createdBy_vc'
      createdBy           : abap.char( 255 );
      createdBy_vc        : rap_cp_odata_value_control;
      @OData.property.valueControl: 'modifiedAt_vc'
      modifiedAt          : tzntstmpl;
      modifiedAt_vc       : rap_cp_odata_value_control;
      @OData.property.valueControl: 'modifiedBy_vc'
      modifiedBy          : abap.char( 255 );
      modifiedBy_vc       : rap_cp_odata_value_control;
      @OData.property.valueControl: 'name_vc'
      name                : abap.string( 0 );
      name_vc             : rap_cp_odata_value_control;
      @OData.property.valueControl: 'description_vc'
      description         : abap.string( 0 );
      description_vc      : rap_cp_odata_value_control;
      @OData.property.valueControl: 'imageUrl_vc'
      imageUrl            : abap.string( 0 );
      imageUrl_vc         : rap_cp_odata_value_control;
      @OData.property.valueControl: 'releaseDate_vc'
      releaseDate         : tzntstmpl;
      releaseDate_vc      : rap_cp_odata_value_control;
      @OData.property.valueControl: 'discontinuedDate_vc'
      discontinuedDate    : tzntstmpl;
      discontinuedDate_vc : rap_cp_odata_value_control;
      @OData.property.valueControl: 'price_vc'
      price               : abap.dec( 16, 2 );
      price_vc            : rap_cp_odata_value_control;
      @OData.property.valueControl: 'height_vc'
      height              : abap.dec( 16, 2 );
      height_vc           : rap_cp_odata_value_control;
      @OData.property.valueControl: 'width_vc'
      width               : abap.dec( 16, 2 );
      width_vc            : rap_cp_odata_value_control;
      @OData.property.valueControl: 'depth_vc'
      depth               : abap.dec( 16, 2 );
      depth_vc            : rap_cp_odata_value_control;
      @OData.property.valueControl: 'quantity_vc'
      quantity            : abap.dec( 16, 2 );
      quantity_vc         : rap_cp_odata_value_control;
      @OData.property.valueControl: 'UnitOfMeasure_ID_vc'
      UnitOfMeasure_ID    : abap.char( 3 );
      UnitOfMeasure_ID_vc : rap_cp_odata_value_control;
      @OData.property.valueControl: 'Currency_ID_vc'
      Currency_ID         : abap.char( 3 );
      Currency_ID_vc      : rap_cp_odata_value_control;
      @OData.property.valueControl: 'DimensionUnit_ID_vc'
      DimensionUnit_ID    : abap.char( 2 );
      DimensionUnit_ID_vc : rap_cp_odata_value_control;
      @OData.property.valueControl: 'Category_ID_vc'
      Category_ID         : abap.char( 1 );
      Category_ID_vc      : rap_cp_odata_value_control;
      @OData.property.valueControl: 'Supplier_ID_vc'
      Supplier_ID         : sysuuid_x16;
      Supplier_ID_vc      : rap_cp_odata_value_control;
      ETAG__ETAG          : abap.string( 0 );

}
