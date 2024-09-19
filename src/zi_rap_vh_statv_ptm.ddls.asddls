@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help RAP for Delivery Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_RAP_VH_STATV_PTM
  as select from dd07t
{
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
  key valpos,
  
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.8       //Ti le filter = 80%
      ddtext     as Description,

      @Search.ranking: #LOW
      domvalue_l as Value
}
where
      dd07t.domname    = 'STATV'
  and dd07t.ddlanguage = abap.lang'E'
  and dd07t.as4local   = 'A'
