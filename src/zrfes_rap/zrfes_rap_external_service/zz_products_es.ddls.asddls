@EndUserText.label: 'Products Custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PRODUCT_MODEL_ES'
@UI: {
    headerInfo: {
        typeName: 'Product',
        typeNamePlural: 'Products',
        imageUrl: 'imageUrl',
        title: {
            type: #STANDARD, value: 'name'
        },
        description: {
            value: 'description'
        }
    },
    presentationVariant: [{
        sortOrder: [{
            by: 'modifiedAt',
            direction: #DESC
        }],
        visualizations: [{
            type: #AS_LINEITEM
        }]
    }]
}
@Search.searchable: true
define root custom entity ZZ_Products_ES
{
      @UI.facet        : [{
        type           : #FIELDGROUP_REFERENCE,
        purpose        : #HEADER,
        position       : 10,
        targetQualifier: 'BasicData',
        label          : 'Basic Data'
      }, {
        type           : #DATAPOINT_REFERENCE,
        purpose        : #HEADER,
        position       : 30,
        targetQualifier: 'Price'
      }, {
        type           : #FIELDGROUP_REFERENCE,
        position       : 10,
        targetQualifier: 'GeneralInformation',
        label          : 'General Information'
      }]


      @UI.hidden       : true
  key ID               : sysuuid_x16;

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @UI.lineItem     : [{ position: 20, importance: #HIGH }]
      @UI.fieldGroup   : [{ qualifier: 'GeneralInformation', position: 10 }]
      @EndUserText.label: 'Product'
      name             : abap.string( 0 );


      @UI.lineItem     : [{ position: 30 }]
      @UI.fieldGroup   : [{ qualifier: 'GeneralInformation', position: 20 }]
      @EndUserText.label: 'Description'
      description      : abap.string( 0 );

      @Semantics.imageUrl: true
      @UI.lineItem     : [{ position: 10 }]
      @EndUserText.label: 'Image'
      imageUrl         : abap.string( 0 );

      @UI.fieldGroup   : [{ qualifier: 'BasicData', position: 20 }]
      @EndUserText.label: 'Release Date'
      releaseDate      : tzntstmpl;

      @EndUserText.label: 'Discontinued Date'
      discontinuedDate : tzntstmpl;

      @Semantics.amount.currencyCode: 'Currency_ID'
      @UI.lineItem     : [{ position: 50 }]
      @UI.fieldGroup   : [{ qualifier: 'GeneralInformation', position: 60 }]
      @UI.dataPoint    : { qualifier: 'Price', title: 'Price' }
      @EndUserText.label: 'Price'
      price            : abap.curr( 16, 2 );

      @Semantics.quantity.unitOfMeasure: 'DimensionUnit_ID'
      @UI.fieldGroup   : [{ qualifier: 'GeneralInformation', position: 30 }]
      @EndUserText.label: 'Height'
      height           : abap.dec( 16, 2 );

      @Semantics.quantity.unitOfMeasure: 'DimensionUnit_ID'
      @UI.fieldGroup   : [{ qualifier: 'GeneralInformation', position: 40 }]
      @EndUserText.label: 'Width'
      width            : abap.dec( 16, 2 );

      @Semantics.quantity.unitOfMeasure: 'DimensionUnit_ID'
      @UI.fieldGroup   : [{ qualifier: 'GeneralInformation', position: 50 }]
      @EndUserText.label: 'Depth'
      depth            : abap.dec( 16, 2 );

      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure_ID'
      @UI.lineItem     : [{ position: 60 }]
      @UI.fieldGroup   : [{ qualifier: 'GeneralInformation', position: 70 }]
      @EndUserText.label: 'Quantity'
      quantity         : abap.quan( 16, 2 );

      @EndUserText.label: 'Unit of Measure'
      @UI.fieldGroup   : [{ qualifier: 'GeneralInformation', position: 90 }]
      UnitOfMeasure_ID : abap.unit( 3 );

      @UI.selectionField: [ { position: 20 } ]
      @UI.fieldGroup   : [{ qualifier: 'GeneralInformation', position: 100 }]
      @EndUserText.label: 'Currency'
      Currency_ID      : abap.cuky;

      @UI.lineItem     : [{ position: 40 }]
      @UI.selectionField: [ { position: 10 } ]
      @UI.fieldGroup   : [{ qualifier: 'BasicData', position: 10 }, { qualifier: 'GeneralInformation', position: 80 }]
      @EndUserText.label: 'Category'
      Category_ID      : abap.char( 1 );

      @UI.hidden       : true
      Supplier_ID      : sysuuid_x16;

      @EndUserText.label: 'Dimension Unit'
      DimensionUnit_ID : abap.unit( 2 );

      @EndUserText.label: 'Created At'
      createdAt        : tzntstmpl;
      @EndUserText.label: 'Created By'
      createdBy        : abap.char( 255 );
      @EndUserText.label: 'Modified At'
      modifiedAt       : tzntstmpl;
      @EndUserText.label: 'Modified By'
      modifiedBy       : abap.char( 255 );
}
