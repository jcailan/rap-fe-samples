@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Suppliers'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_Suppliers_RS
  as select from ZR_Suppliers_RS
{
      @UI.textArrangement: #TEXT_ONLY
      @UI.lineItem: [{importance: #HIGH}]
      @ObjectModel.text.element: ['Name']
      @EndUserText.label: 'Supplier'
  key ID,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @Semantics.name.fullName: true
      Name,
      @Semantics.organization.role: true
      'Supplier' as Role,
      Street,
      City,
      State,
      PostalCode,
      Country,
      @Semantics.eMail.address: true
      @Semantics.eMail.type:  [#WORK]
      Email,
      @Semantics.telephone.type:  [#WORK]
      Phone,
      @Semantics.telephone.type:  [#FAX]
      Fax
}
