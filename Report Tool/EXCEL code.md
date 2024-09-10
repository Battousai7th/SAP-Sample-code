## Tools && OLE (for SAP & FIORI)
```abap
  DATA:
    lt_ranges          TYPE soi_range_list,
    lt_sheets          TYPE soi_sheets_table,
    lt_data            TYPE soi_generic_table,
    lt_rawdata         TYPE truxs_t_text_data,
    lv_sheet_name      TYPE soi_field_name,
    lv_document_url    TYPE c LENGTH 256,
    lv_index           TYPE char2,
    lv_col             TYPE char30,
    lo_ref_container   TYPE REF TO cl_gui_custom_container,
    lo_ref_control     TYPE REF TO i_oi_container_control,
    lo_ref_document    TYPE REF TO i_oi_document_proxy,
    lo_ref_spreadsheet TYPE REF TO i_oi_spreadsheet,
    lo_ref_error       TYPE REF TO i_oi_error,
    retcode            TYPE soi_ret_string.
  DATA:
    lt_data_text TYPE TABLE OF zstl1003_pouploadc,
    ls_data_text TYPE          zstl1003_pouploadc.
  DATA: lv_line_no TYPE i,
        lw_cnt     TYPE p,
        lw_num_flg TYPE char1,
        ls_mast    TYPE mast.
  DATA: lw_temp_50 TYPE char50.

  lv_sheet_name = 'Open PO Template'.
*  lv_file = p_fname.

  CALL METHOD c_oi_container_control_creator=>get_container_control
    IMPORTING
      control = lo_ref_control
      error   = lo_ref_error.
  IF lo_ref_error->has_failed = 'X'.
    CALL METHOD lo_ref_error->raise_message
      EXPORTING
        type = 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  CREATE OBJECT lo_ref_container
    EXPORTING
*     parent                      =
      container_name              = 'CONT'
*     style                       =
*     lifetime                    = lifetime_default
*     repid                       =
*     dynnr                       =
*     no_autodef_progid_dynnr     =
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE e001(00) WITH 'Error while creating container'.
  ENDIF.

  CALL METHOD lo_ref_control->init_control
    EXPORTING
      r3_application_name  = 'EXCEL CONTAINER'
      inplace_enabled      = 'X'
      parent               = lo_ref_container
    IMPORTING
      error                = lo_ref_error
    EXCEPTIONS
      javabeannotsupported = 1
      OTHERS               = 2.
  IF lo_ref_error->has_failed = 'X'.
    CALL METHOD lo_ref_error->raise_message
      EXPORTING
        type = 'E'.
  ENDIF.

  CALL METHOD lo_ref_control->get_document_proxy
    EXPORTING
      document_type  = 'Excel.sheet'
    IMPORTING
      document_proxy = lo_ref_document
      error          = lo_ref_error.
  IF lo_ref_error->has_failed = 'X'.
    CALL METHOD lo_ref_error->raise_message
      EXPORTING
        type = 'E'.
  ENDIF.

  CONCATENATE 'FILE://' p_fname INTO lv_document_url.

  CALL METHOD lo_ref_document->open_document
    EXPORTING
      document_title = 'Excel'
      document_url   = lv_document_url
      no_flush       = 'X'
      open_inplace   = 'X'
    IMPORTING
      error          = lo_ref_error.
  IF lo_ref_error->has_failed = 'X'.
    CALL METHOD lo_ref_error->raise_message
      EXPORTING
        type = 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  CALL METHOD lo_ref_document->get_spreadsheet_interface
    EXPORTING
      no_flush        = ' '
    IMPORTING
      error           = lo_ref_error
      sheet_interface = lo_ref_spreadsheet.

  IF lo_ref_error->has_failed = 'X'.
    CALL METHOD lo_ref_error->raise_message
      EXPORTING
        type = 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  CALL METHOD lo_ref_spreadsheet->get_sheets
    EXPORTING
      no_flush = ' '
    IMPORTING
      sheets   = lt_sheets
      error    = lo_ref_error.
  IF lo_ref_error->has_failed = 'X'.
    CALL METHOD lo_ref_error->raise_message
      EXPORTING
        type = 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.
  CALL METHOD lo_ref_spreadsheet->select_sheet
    EXPORTING
      name  = lv_sheet_name
    IMPORTING
      error = lo_ref_error.
  IF lo_ref_error->has_failed = 'X'.
    EXIT.
    CALL METHOD lo_ref_error->raise_message
      EXPORTING
        type = 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.
  CALL METHOD lo_ref_spreadsheet->set_selection
    EXPORTING
      top     = 1
      left    = 1
      rows    = p_rows
      columns = p_cols.

  CALL METHOD lo_ref_spreadsheet->insert_range
    EXPORTING
      name     = 'Test'
      rows     = p_rows
      columns  = p_cols
      no_flush = ''
    IMPORTING
      error    = lo_ref_error.
  IF lo_ref_error->has_failed = 'X'.
    EXIT.
    CALL METHOD lo_ref_error->raise_message
      EXPORTING
        type = 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  DATA: lt_rangesdef TYPE soi_dimension_table.
  lt_rangesdef = VALUE #( ( row = 1 column = 1 rows = p_rows columns = p_cols ) ).

  CALL METHOD lo_ref_spreadsheet->get_ranges_data
    EXPORTING
      rangesdef = lt_rangesdef
    IMPORTING
      contents  = lt_data
      error     = lo_ref_error
    CHANGING
      ranges    = lt_ranges.

  " Remove ranges not to be processed else the data keeps on adding up
  CALL METHOD lo_ref_spreadsheet->delete_ranges
    EXPORTING
      ranges = lt_ranges.

  " Close document
  CALL METHOD lo_ref_document->close_document
    IMPORTING
      error = lo_ref_error.
  IF lo_ref_error->has_failed = 'X'.
    CALL METHOD lo_ref_error->raise_message
      EXPORTING
        type = 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  " Release document
  CALL METHOD lo_ref_document->release_document
    IMPORTING
      error = lo_ref_error.
  IF lo_ref_error->has_failed = 'X'.
    CALL METHOD lo_ref_error->raise_message
      EXPORTING
        type = 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  DELETE lt_data WHERE value IS INITIAL OR value = space.

  LOOP AT lt_data INTO DATA(ls_data).
    lv_index = ls_data-column.
    CONCATENATE 'COL' lv_index INTO lv_col RESPECTING BLANKS.
    ASSIGN COMPONENT lv_col OF STRUCTURE gs_data_excel TO FIELD-SYMBOL(<lf_value>).
    IF <lf_value> IS ASSIGNED.
      <lf_value> = ls_data-value.
      UNASSIGN: <lf_value>.
    ENDIF.

    AT END OF row.
      APPEND gs_data_excel TO gt_data_excel.
      CLEAR:gs_data_excel.
    ENDAT.
  ENDLOOP.
```

