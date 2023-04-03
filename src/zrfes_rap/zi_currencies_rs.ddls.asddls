@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Currencies'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_Currencies_RS
  as select from ZR_Currencies_RS
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @UI.lineItem: [{importance: #HIGH}]
      @EndUserText.label: 'Currency Key'
  key ID,
      @EndUserText.label: 'Currency'
      Name
}
