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
define view entity ZI_RAP_VH_STATV_PTM01
  as select from dd07t
{
  key domname,
  key ddlanguage,
  key as4local,
  
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
  key valpos,
  
  key as4vers,
  
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.8       //Ti le filter = 80%
      ddtext     as Description,
      
      domval_ld,
      domval_hd,
      
      @Search.ranking: #LOW
      domvalue_l as Value
}
where
      dd07t.domname    = 'STATV'
  and dd07t.as4local   = 'A'
