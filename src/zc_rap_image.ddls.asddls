@EndUserText.label: 'Projection View RAP for Travel Image'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_RAP_IMAGE as projection on ZI_RAP_IMAGE
{
    key TravelId,
    key ImageId,
    Attachment,
    MimeType,
    FileName,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _TravelRoot : redirected to parent ZC_RAP_TRAVEL
}
