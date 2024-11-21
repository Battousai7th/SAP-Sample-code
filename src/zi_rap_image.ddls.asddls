@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View RAP for Travel Image'
define view entity ZI_RAP_IMAGE
  as select from zdb_rap_image
  association to parent ZR_RAP_TRAVEL as _TravelRoot on $projection.TravelId = _TravelRoot.TravelId
{
  key travel_id       as TravelId,
  key image_id        as ImageId,
      @Semantics.largeObject: {
          mimeType: 'MimeType',
          fileName: 'Filename',
          contentDispositionPreference: #INLINE,
          acceptableMimeTypes: ['image/*']
      }
      attachment      as Attachment,
      @Semantics.mimeType: true
      mimetype        as MimeType,
      filename        as FileName,
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      _TravelRoot // Make association public
}
