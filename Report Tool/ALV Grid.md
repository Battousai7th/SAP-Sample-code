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

### Brief Code
```abap
DATA: GT_FIELDCAT TYPE          LVC_T_FCAT,
      GS_FIELDCAT TYPE          LVC_S_FCAT,
      GS_LAYOUT   TYPE          LVC_S_LAYO,
      LT_FIELDCAT TYPE          LVC_T_FCAT WITH HEADER LINE.
  DEFINE M_FIELDCAT.
    GS_FIELDCAT-FIELDNAME  = &1.
    GS_FIELDCAT-SCRTEXT_L  = &2.
    GS_FIELDCAT-NO_ZERO    = &3.  "Xóa số 0 field amount trên ALV
    GS_FIELDCAT-STYLE      = &4.   "Format cột
    GS_FIELDCAT-QFIELDNAME = &5.
    GS_FIELDCAT-CFIELDNAME = &6. 
    GS_FIELDCAT-DECIMALS_O = &4. 
    APPEND GS_FIELDCAT to LT_FIELDCAT.
  END-OF-DEFINITION.
  M_FIELDCAT:
    'STT'          'Số thứ tự'                 '',
    'PERNR'        'Mã NV'                     '',
    'EMNAM'        'Tên NV'                    '',
    'MADOT'        'Mã đợt giao nhận'          ''.
  GS_LAYOUT-CWIDTH_OPT = 'X' .
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE' "Dựng hết Structure làm ALV
    EXPORTING
      I_STRUCTURE_NAME       = 'ZPY_ST_ZP18'
    CHANGING
      CT_FIELDCAT            = GT_FIELDCAT[]
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      PROGRAM_ERROR          = 2
      OTHERS                 = 3.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4 .
  ENDIF.

  LOOP AT GT_FIELDCAT ASSIGNING FIELD-SYMBOL(<FS_FIELDCAT>).
    READ TABLE LT_FIELDCAT WITH KEY FIELDNAME = <FS_FIELDCAT>-FIELDNAME.
    IF SY-SUBRC EQ 0.
      <FS_FIELDCAT>-REPTEXT = LT_FIELDCAT-SCRTEXT_L.
      <FS_FIELDCAT>-SCRTEXT_S = <FS_FIELDCAT>-SCRTEXT_M = <FS_FIELDCAT>-SCRTEXT_L = LT_FIELDCAT-SCRTEXT_L.
      <FS_FIELDCAT>-NO_ZERO = LT_FIELDCAT-NO_ZERO.
      <FS_FIELDCAT>-COL_POS = SY-TABIX.
    ELSE.
      <FS_FIELDCAT>-TECH = 'X'.
    ENDIF.
  ENDLOOP.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
*     I_CALLBACK_TOP_OF_PAGE = 'TOP_OF_PAGE'
      IS_LAYOUT_LVC      = GS_LAYOUT
      IT_FIELDCAT_LVC    = GT_FIELDCAT
      I_SAVE             = 'X'
    TABLES
      T_OUTTAB           = GT_ALV
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4 .
  ENDIF. 

*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display.

  DATA: lt_fieldcat TYPE lvc_t_fcat,
        ls_fieldcat LIKE LINE OF lt_fieldcat,
        ls_layout   TYPE lvc_s_layo.
*--------------------------------------------------------------------*
*  Create fieldcalogy
  DEFINE add_field.
    CLEAR ls_fieldcat.
    ls_fieldcat-fieldname = &1.
    ls_fieldcat-checkbox  = &2.
    ls_fieldcat-edit      = &3.
    ls_fieldcat-seltext   = &4.
    ls_fieldcat-reptext   = &4.
    ls_fieldcat-coltext   = &4.
    ls_fieldcat-no_zero   = 'X'.
    APPEND ls_fieldcat TO lt_fieldcat.
  END-OF-DEFINITION.
*--------------------------------------------------------------------*
  add_field  'SEL'    'X'  'X'  'Selection'.
  IF r_rb1 IS NOT INITIAL.
    add_field  'MATNR'  ''   ''   'Material'.
    add_field  'MAKTX'  ''   ''   'Material Decription'.
    add_field  'MEINS'  ''   ''   'Base UoM'.
  ELSE.
    add_field  'MBLNR'  ''   ''   'Material Doc'.
    add_field  'ZEILE'  ''   ''   'Item'.
    add_field  'MJAHR'  ''   ''   'Material Doc Year'.
    add_field  'WERK'   ''   ''   'Plant'.
    add_field  'MATNR'  ''   ''   'Material'.
    add_field  'MAKTX'  ''   ''   'Material Decription'.
    add_field  'CHARG'  ''   ''   'Batch'.
    add_field  'BWART'  ''   ''   'MvT'.
    add_field  'LGORT'  ''   ''   'Sloc'.
    add_field  'ERFMG'  ''   ''   'Qty in Unit of entry'.
    add_field  'ERFME'  ''   ''   'Unit of Entry'.
    add_field  'MEINS'  ''   ''   'Base UoM'.
    add_field  'BUDAT'  ''   ''   'Posting Date'.
    add_field  'EBELN'  ''   ''   'Purchase Order'.
    add_field  'EBELP'  ''   ''   'Line Item'.
    add_field  'AUFNR'  ''   ''   'Order No.'.
  ENDIF.

*--------------------------------------------------------------------*
 
  ls_layout-cwidth_opt  = 'X'.
  ls_layout-zebra       = 'X'.
  ls_layout-edit_mode   = 'X'.
  ls_layout-box_fname   = 'SEL'.  "Cột lề
  ls_layout-sel_mode    = 'X'.   "Cho phép giữ control vuốt cột lề
  ls_layout-no_rowmark  = 'X'.    "Ẩn Cột lề 

*  Display
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'SET_PF_STATUS'
      i_callback_user_command  = 'HANDLE_USER_COMMAND'
      is_layout_lvc            = ls_layout
      it_fieldcat_lvc          = lt_fieldcat
    TABLES
      t_outtab                 = gt_data
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM. 
```
