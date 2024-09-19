@EndUserText.label: 'Projection View RAP for Sales Order Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['ItemLine']
define view entity ZC_RAP_SO_I_PTM
  as projection on ZI_RAP_SO_I_PTM
{
      @EndUserText.label: 'Sales Order'
  key SalesOrder,
      @EndUserText.label: 'Item No.'
  key ItemLine,
      @EndUserText.label: 'Item Notes'
      ItemNote,
      @ObjectModel.text.element:  [ 'ItemNote' ]        //==> Dem <ItemNote> ra phia truoc, <Product> de trong ngoac ()
      @EndUserText.label: 'Product'
      Product,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure : 'QuantityUnit'
      Quantity,
      @EndUserText.label: 'UoM'
      QuantityUnit,
      @EndUserText.label: 'Unit Price'
      @Semantics.amount.currencyCode : 'Currency'
      Price,
      _SalesOrder.Currency,
      @EndUserText.label: 'Currency Item'
      Currency as Currency_1,
      @Semantics.systemDate.createdAt: true
      CreatedDate,
      @Semantics.systemTime.createdAt: true
      CreatedTime,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      /* Associations */
      _SalesOrder : redirected to parent ZCR_RAP_SO_PTM
}
