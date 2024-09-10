## ALV Grid
```abap
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .
  PERFORM BUILD_FIELDCAT.
  PERFORM BUILD_LAYOUT. 
  
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      I_CALLBACK_PROGRAM          = SY-REPID
      I_CALLBACK_PF_STATUS_SET    = 'SET_PF_STATUS'
      I_CALLBACK_HTML_TOP_OF_PAGE = 'HTML_TOP_OF_PAGE'
      I_CALLBACK_USER_COMMAND     = 'HANDLE_USER_COMMAND'
      IS_LAYOUT_LVC               = GS_LAYOUT
      IT_FIELDCAT_LVC             = GT_FIELDCAT
      I_SAVE                      = 'A'
    TABLES
      T_OUTTAB                    = GT_RECL_DISP
    EXCEPTIONS
      PROGRAM_ERROR               = 1
      OTHERS                      = 2.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form BUILD_FIELDCAT
*&---------------------------------------------------------------------*
FORM BUILD_LAYOUT .
  CLEAR: GS_LAYOUT.
  GS_LAYOUT-CWIDTH_OPT = 'X'.
  GS_LAYOUT-STYLEFNAME = 'CELLTAB'.
  GS_LAYOUT-INFO_FNAME = 'COLOR'.
ENDFORM.            "BUILD_LAYOUT

*&---------------------------------------------------------------------*
*& Form BUILD_FIELDCAT
*&---------------------------------------------------------------------*
FORM BUILD_FIELDCAT .
  CHECK GT_FIELDCAT[] IS INITIAL.
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      I_STRUCTURE_NAME       = 'ZFI_ST_KCCP_DISP'
    CHANGING
      CT_FIELDCAT            = GT_FIELDCAT[]
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      PROGRAM_ERROR          = 2
      OTHERS                 = 3.

  LOOP AT GT_FIELDCAT ASSIGNING <FS_FIELDCAT>.
    CASE <FS_FIELDCAT>-FIELDNAME.
      WHEN 'SACCT'.
        <FS_FIELDCAT>-COL_POS = 1.
      WHEN 'DACCT'.
        <FS_FIELDCAT>-COL_POS = 2.
      WHEN 'DCOST'.
        <FS_FIELDCAT>-COL_POS = 3.
      WHEN 'OACCT'.
        <FS_FIELDCAT>-COL_POS = 4.
      WHEN 'OCOST'.
        <FS_FIELDCAT>-COL_POS = 5.
      WHEN 'PRCTR'.
        <FS_FIELDCAT>-COL_POS = 6.
      WHEN 'HANG_SO'.
        <FS_FIELDCAT>-COL_POS = 7.
      WHEN 'DMBTR'.
        <FS_FIELDCAT>-COL_POS = 8.
      WHEN 'WAERS'.
        <FS_FIELDCAT>-COL_POS = 9.
      WHEN 'MANDT'.
        <FS_FIELDCAT>-TECH = 'X'.
      WHEN 'RULTY' OR 'BUKRS' OR 'AENAM' OR 'AEDAT' OR 'AEZET'.
        <FS_FIELDCAT>-NO_OUT = 'X'.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form SET PF-STATUS
*&---------------------------------------------------------------------*
FORM SET_PF_STATUS USING RT_EXTAB TYPE SLIS_T_EXTAB.
  SET PF-STATUS 'ZSTANDARD_FULLSCREEN'.
ENDFORM.
```
