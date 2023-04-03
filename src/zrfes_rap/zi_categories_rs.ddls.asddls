@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Categories'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_Categories_RS
  as select from ZR_Categories_RS
{
      @UI.textArrangement: #TEXT_ONLY
      @UI.lineItem: [{importance: #HIGH}]
      @ObjectModel.text.element: ['Name']
      @EndUserText.label: 'Category'
  key ID,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Name
}
