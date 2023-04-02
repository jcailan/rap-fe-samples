@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unit of Measures'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_UnitOfMeasures_RS
  as select from ZR_UnitOfMeasures_RS
{
      @UI.textArrangement: #TEXT_ONLY
      @UI.lineItem: [{importance: #HIGH}]
      @ObjectModel.text.element: ['Name']
      @EndUserText.label: 'Unit'
  key ID,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Name
}
