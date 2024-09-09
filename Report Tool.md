## Blocks of code
```ABAP
*&---------------------------------------------------------------------*
*& Form OUTPUT_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
FORM output_alv .
  DATA: lr_column  TYPE REF TO cl_salv_column_table,
        lr_columns TYPE REF TO cl_salv_columns_table,
        lt_fields  TYPE ddfields.

  CALL FUNCTION 'CATSXT_GET_DDIC_FIELDINFO'
    EXPORTING
      im_structure_name = 'ZST_LO_4007_ALV'
    IMPORTING
      ex_ddic_info      = lt_fields
    EXCEPTIONS
      failed            = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
    MESSAGE 'No fieldcatalog' TYPE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = DATA(lo_salv)
        CHANGING
          t_table      = gt_data ).

      lo_salv->set_screen_status( pfstatus      = 'ZSTATUS_1000'
                                  report        = sy-repid
                                  set_functions = lo_salv->c_functions_all ).

      LOOP AT lt_fields INTO DATA(ls_fieldnam).
        lo_salv->get_columns( )->get_column( ls_fieldnam-fieldname )->set_fixed_header_text( 'L' ).
        " Start AI-TuanPTM 04.10.21 Update
        IF ls_fieldnam-fieldname eq 'MKSP'.
          lo_salv->get_columns( )->get_column( ls_fieldnam-fieldname )->set_long_text( 'Lock' ).
        ENDIF.
        IF ls_fieldnam-fieldname eq 'ELPRO' or
           ls_fieldnam-fieldname eq 'ALORT' or
           ls_fieldnam-fieldname eq 'SERKZ' or
           ls_fieldnam-fieldname eq 'MDV01'.
          lo_salv->get_columns( )->get_column( ls_fieldnam-fieldname )->SET_VISIBLE( '' ).
        ENDIF.
        " End AI-TuanPTM 04.10.21
      ENDLOOP.

      lo_salv->get_columns( )->set_optimize( ).
      lo_salv->display( ).
    CATCH cx_salv_data_error.
    CATCH cx_salv_msg.
    CATCH cx_salv_not_found.
  ENDTRY.
ENDFORM.
```

