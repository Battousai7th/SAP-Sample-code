## ALV List
```ABAP
PERFORM fo_build_layout.
PERFORM fo_build_event.
PERFORM fo_build_fieldcat.
PERFORM fo_display_list. 
*&---------------------------------------------------------------------*
*&      Form  FO_BUILD_LAYOUT
*&---------------------------------------------------------------------*
FORM fo_build_layout .
  gv_save = 'A'.
*  GS_LAYOUT-ZEBRA             = 'X'.
  gs_layout-colwidth_optimize = 'X'.
ENDFORM.                    " FO_BUILD_LAYOUT 
*&---------------------------------------------------------------------*
*&      Form  FO_BUILD_EVENT
*&---------------------------------------------------------------------*
FORM fo_build_event .
  REFRESH: gt_events.
  MOVE 'TOP_OF_PAGE'       TO gs_events-form.
  MOVE slis_ev_top_of_page TO gs_events-name.
  APPEND gs_events TO gt_events.
ENDFORM.                    " FO_BUILD_EVENT 
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
FORM top_of_page.
**  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
**    EXPORTING
**      i_logo             = 'ZAALOGO'
**      it_list_commentary = gt_header.

  IF p_badet = ''.  " Company Code level

  ELSE. " Business Area level
    CLEAR gt_hdr.
    READ TABLE gt_hdr WITH KEY bukrs = gt_item-bukrs
                               hkont = gt_item-hkont
                               gsber = gt_item-gsber.

    WRITE: /(13) 'GL Account:',
            (10) gt_hdr-hkont,
            (01) '-',
            (50) gt_hdr-txt50.
    WRITE:  90  'Opening Balance:',
            115(20) gt_hdr-daungay CURRENCY gt_hdr-waerslc,
                 gt_hdr-waerslc.
    WRITE: /(13) 'Company Code:',
            (04) gt_hdr-bukrs.
    WRITE:  95  'Total Debit:',
            115(20) gt_hdr-debit CURRENCY gt_hdr-waerslc,
                 gt_hdr-waerslc.
    WRITE: /(13) 'BusinessArea:',
            (10) gt_hdr-gsber.
    WRITE:  95 'Total Credit:',
            115(20) gt_hdr-credit CURRENCY gt_hdr-waerslc,
                gt_hdr-waerslc.
    WRITE: /(13) 'Date from:',
            (10) gt_hdr-datfr,
            (02) 'to',
            (10) gt_hdr-datto.
    WRITE:  90 'Ending Balance:',
            115(20) gt_hdr-cuoingay CURRENCY gt_hdr-waerslc,
                gt_hdr-waerslc.
  ENDIF.
*  NEW-PAGE.
ENDFORM.                    "TOP_OF_PAGE 
*&---------------------------------------------------------------------*
*&      Form  FO_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
FORM fo_build_fieldcat . 
ENDFORM.  
*&---------------------------------------------------------------------*
*&      Form  FO_DISPLAY_LIST
*&---------------------------------------------------------------------*
FORM fo_display_list .
  DATA: lt_sort TYPE slis_t_sortinfo_alv,
        ls_sort TYPE slis_sortinfo_alv.

  CLEAR ls_sort. REFRESH lt_sort.
  ls_sort-spos = '01'.
  ls_sort-fieldname = 'BUKRS'.
  ls_sort-up = 'X'.
  ls_sort-group = '*'.
*  ls_sort-subtot = 'X'.
  APPEND ls_sort TO lt_sort.

  IF p_badet = ''.  " CCode level
    ls_sort-spos = '02'.
    ls_sort-fieldname = 'HKONT'.
    ls_sort-up = 'X'.
    ls_sort-group = '*'.
*    ls_sort-subtot = 'X'.
    APPEND ls_sort TO lt_sort.
  ELSE.  " B.Area level
    ls_sort-spos = '02'.
    ls_sort-fieldname = 'HKONT'.
    ls_sort-up = 'X'.
    ls_sort-group = '*'.
*    ls_sort-subtot = 'X'.
    APPEND ls_sort TO lt_sort.

    ls_sort-spos = '03'.
    ls_sort-fieldname = 'GSBER'.
    ls_sort-up = 'X'.
    ls_sort-group = '*'.
*    ls_sort-subtot = 'X'.
    APPEND ls_sort TO lt_sort.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      i_callback_program       = gv_repid
      i_callback_pf_status_set = 'FO_PF_STATUS'
      i_callback_user_command  = 'FO_USER_COMMAND'
      is_layout                = gs_layout
      it_fieldcat              = gt_fieldcat
      it_sort                  = lt_sort
      i_save                   = gv_save
      it_events                = gt_events[]
    IMPORTING
      e_exit_caused_by_caller  = gv_exit_caused_by_caller
      es_exit_caused_by_user   = gs_exit_caused_by_user
    TABLES
      t_outtab                 = gt_item
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.

  ENDIF.

ENDFORM.
```
