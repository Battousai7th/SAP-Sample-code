## SALV Extend
```ABAP
*&---------------------------------------------------------------------*
*& A L V   V A R I A B L E - I N C L U D E TOP
*&---------------------------------------------------------------------*
DATA: gr_table       TYPE REF TO cl_salv_table.

*&---------------------------------------------------------------------*
*&  E N D - O F - S E L E C T I O N                                    *
*&---------------------------------------------------------------------* 
  TRY.
      lcl_report=>display_alv( ).
    CATCH lcx_error INTO lcl_report=>ref_cx.
      lcl_report=>ref_cx->message_like( ).
      LEAVE LIST-PROCESSING.
  ENDTRY.
*----------------------------------------------------------------------*
* CLASS lcx_report DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_report DEFINITION FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS:
      display_alv
        RAISING lcx_error.
    CLASS-DATA:
      ref_cx TYPE REF TO lcx_error,
      it_alv TYPE tty_alv.          "Custom Table Type creation

  PRIVATE SECTION.
    CLASS-DATA:
      ref_report TYPE REF TO lcl_report.
    METHODS:
      set_function,
      set_layout,
      set_pfstatus,
      set_events,
      set_header,
      set_columns,
      set_sorts,
      set_aggregations
        CHANGING
          co_alv TYPE REF TO cl_salv_table.

ENDCLASS.
*----------------------------------------------------------------------*
* CLASS lcx_error DEFINITION
*----------------------------------------------------------------------*
CLASS lcx_error DEFINITION INHERITING FROM cx_salv_msg FINAL.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        im_v_msgid LIKE sy-msgid        im_v_msgty LIKE sy-msgty
        im_v_msgno LIKE sy-msgno        im_v_msgv1 TYPE simple OPTIONAL
        im_v_msgv2 TYPE simple OPTIONAL im_v_msgv3 TYPE simple OPTIONAL
        im_v_msgv4 TYPE simple OPTIONAL.
    METHODS message.
    METHODS message_like.
ENDCLASS.
*----------------------------------------------------------------------*
* CLASS lcx_report IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_report IMPLEMENTATION.
  METHOD display_alv.

    DATA: lref_display   TYPE REF TO cl_salv_display_settings.

    IF it_alv IS INITIAL.
      "No data found
      RAISE EXCEPTION TYPE lcx_error
        EXPORTING
          im_v_msgid = 'ZFIAR'
          im_v_msgty = 'E'
          im_v_msgno = '999'
          im_v_msgv1 = sy-msgv1
          im_v_msgv2 = sy-msgv2
          im_v_msgv3 = sy-msgv3
          im_v_msgv4 = sy-msgv4.
    ENDIF.

    TRY.

        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = gr_table
          CHANGING
            t_table      = it_alv ).

      CATCH cx_salv_msg.                                "#EC NO_HANDLER
    ENDTRY.
    DATA lv_title_text TYPE text70.
    lv_title_text = | Average Rent Roll Report - Month { s_spmon-low+4(2) }.{ s_spmon-low(4) } |.
    lref_display = gr_table->get_display_settings( ).
    lref_display->set_list_header( lv_title_text ).

    ref_report->set_function( ).
    ref_report->set_layout( ).
    ref_report->set_header( ).
    ref_report->set_columns( ).
    ref_report->set_sorts( ).
    ref_report->set_events( ).

    ref_report->set_aggregations( CHANGING co_alv = gr_table ).
    gr_table->display( ).

  ENDMETHOD.
  "-----------------------------------------------------------------------------------------------------
  "-----------------------------------------------------------------------------------------------------
  METHOD set_function.


    DATA(lref_func) = gr_table->get_functions( ).


*    lref_func->set_default( ).
    lref_func->set_all( ).
    lref_func->set_export_localfile( abap_true ).
    lref_func->set_export_spreadsheet( abap_true ).

  ENDMETHOD.                " set_function

  METHOD set_layout.

    DATA: lref_layout TYPE REF TO cl_salv_layout,
          lf_variant  TYPE slis_vari,
          ls_key      TYPE salv_s_layout_key.

    ls_key-report = sy-repid.
*
*    IF rb_open IS NOT INITIAL.
*      ls_key-handle = 'LAY1'.
*    ELSEIF rb_clear IS NOT INITIAL.
*      ls_key-handle = 'LAY2'.
*    ENDIF.
*
*    IF rb_open IS NOT INITIAL.
*      lref_layout   = gr_table->get_layout( ).
*    ELSEIF rb_clear IS NOT INITIAL.
*      lref_layout   = gr_table_clear->get_layout( ).
*    ENDIF.
*
*    lref_layout->set_key( ls_key ).
*    lref_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
*    lref_layout->set_default( abap_true ).

  ENDMETHOD.                " set_layout

  METHOD set_header.

*    DATA:
*      lref_header TYPE REF TO cl_salv_form_layout_grid,
*      lref_grid   TYPE REF TO cl_salv_form_layout_grid,
*      lref_layout TYPE REF TO cl_salv_form_layout_data_grid,
*      lref_info   TYPE REF TO cl_salv_form_header_info,
*      lref_label  TYPE REF TO cl_salv_form_label.
*
*    lref_header = NEW cl_salv_form_layout_grid( ).
*
*    lref_grid = lref_header->create_grid(
*      row    = 5
*      column = 1 ).
*
*    lref_grid->create_header_information(
*      row    = 1
*      column = 1
*      text   = 'Average Rent Roll Report' ).
*
*    lref_grid->create_text(
*      row    = 2
*      column = 1
*      text   = |Month/Fiscal Year : { s_spmon-low }| ).
*
*      gr_table->set_top_of_list( lref_header ).


  ENDMETHOD.                " set_header

  METHOD set_columns.

    DATA: lv_stext     TYPE scrtext_s,
          lv_mtext     TYPE scrtext_m,
          lv_ltext     TYPE scrtext_l,
          lv_field     TYPE lvc_fname,
          lv_field_max TYPE lvc_fname,
          lv_field_min TYPE lvc_fname,
          lv_no_out    TYPE char1,
          lv_period    TYPE mcs0-spmon,
          lv_name      TYPE char10,
          lv_name_max  TYPE string,
          lv_name_min  TYPE string,
          lv_col       TYPE n LENGTH 2,
          lv_length    TYPE lvc_outlen,
          lv_optimize  TYPE sap_bool,
          lv_decimals  TYPE char6 VALUE 2.

    DATA:
      lref_columns TYPE REF TO cl_salv_columns_table,
      lref_column  TYPE REF TO cl_salv_column_table.

    lref_columns = gr_table->get_columns( ).


    lref_columns->set_optimize( if_salv_c_bool_sap=>true ).
    lref_columns->set_key_fixation( if_salv_c_bool_sap=>true ).

    DEFINE mc_set_field.
      lv_field = &1.
      lv_stext = &2.
      lv_mtext = &2.
      lv_ltext = &2.
      lv_no_out = &3.
      lv_length = &4.
      lv_optimize = &5.

       TRY.
          lref_column = CAST #( lref_columns->get_column( lv_field ) ).
          lref_column->set_short_text( lv_stext ).
          lref_column->set_medium_text( lv_mtext ).
          lref_column->set_long_text( lv_ltext ).
          lref_column->set_sign( abap_true ).
          lref_column->set_fixed_header_text( 'L' ).
          lref_column->set_output_length( lv_length ).
          lref_column->set_optimized( lv_optimize ).

      IF lv_no_out = 'X'.
        lref_column->set_visible( if_salv_c_bool_sap=>false ). " No Show
        lref_column->set_technical( if_salv_c_bool_sap=>true ).
      ELSE.
        lref_column->set_visible( if_salv_c_bool_sap=>true ). " Show
      ENDIF.

        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.

    END-OF-DEFINITION.

    " --- Show column
    mc_set_field:
          'BUKRS'      'Company Code'           ''   ''   abap_true ,
          'SWENR'      'Business Entity'        ''   ''   abap_true ,
          'SGENR'      'Building'               ''   ''   abap_true .

*    IF rb_floor EQ 'X'.
*      mc_set_field:
*          'SSTOCKW'     'Floor'                 ''   ''   abap_true,
*          'XSTOCKL'     'Floor Description'     ''   ''   abap_true.
*    ELSE.
    mc_set_field:
        'SSTOCKW'     'Floor'                 'X'   ''   abap_true,
        'XSTOCKL'     'Floor Description'     'X'   ''   abap_true.

*    ENDIF.

    mc_set_field:
          'SNUNR'        'Usage Type'           ''   ''   abap_true,
          'XMBEZ'        'Usage Type Description'    ''   ''   abap_true,
          'MEASVALUE'    'Net Rentable(M2)'     ''   ''   abap_true,
          'OCCSVALUE'    'Occupancy(M2)'        ''   ''   abap_true,
          'OCCSVPASS'    'Occupancy(M2),Year - 1'    ''   ''   abap_true,
          'OCCSMPASS'    'Occupancy(M2),Month - 1'   ''   ''   abap_true,
          'OCCSPERCT'    '% Occupancy'          ''   ''   abap_true,
          'VACANTVAL'    'Vacant(M2)'           ''   ''   abap_true,
          'VACANTPER'    '% Vacant'             ''   ''   abap_true,
          'ARRBVALUE'    'ARR(Baht)'            ''   ''   abap_true,
          'ARRYTDVAL'    'ARR YTD(Baht)'        ''   ''   abap_true,
          'ARRYOYVAL'    'ARR YOY(Baht)'        ''   ''   abap_true,
          'ARRYOYPER'    '% ARR YOY'            ''   ''   abap_true,
          'ARRMOMVAL'    'ARR MOM(Baht)'        ''   ''   abap_true,
          'ARRMOMPER'    '% ARR MOM'            ''   ''   abap_true.

*-->Begin of CR01
    mc_set_field:
      'OCCSPPASS'    'Occupancy(M2),YTD'    'X'   ''   abap_true.
*<--End of CR01

  ENDMETHOD.                " set_columns

  METHOD set_sorts.

    DATA: lref_columns TYPE REF TO cl_salv_sorts.
    DATA: lv_index TYPE i.

    " --- get sorts object
    lref_columns = gr_table->get_sorts( ).

*    TRY .

*        ADD 1 TO lv_index.
*
*        lref_columns->add_sort(
*        columnname = 'MBLNR'
*        position   = lv_index
*        sequence   = if_salv_c_sort=>sort_up
*        subtotal     = 'X'
**        group        = '1' " 1 Page Break / 2 Under Line
*        ).

*      CATCH cx_salv_data_error
*            cx_salv_not_found
*            cx_salv_existing.
*
*    ENDTRY.
  ENDMETHOD.                " set_sort

  METHOD set_events.

    DATA: lref_event   TYPE REF TO cl_salv_events_table.

    " --- Get events object
*    lref_event = go_alv->get_event( ).
*    SET HANDLER on_linked_click FOR lref_event.

  ENDMETHOD.                " SET_EVENTS


ENDCLASS.
```
