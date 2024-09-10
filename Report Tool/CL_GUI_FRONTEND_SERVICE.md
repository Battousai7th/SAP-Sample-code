## GUI_DOWNLOAD (MIME)
```abap
FORM down_template .
  DATA: l_full_pathfile TYPE char255,
        l_local(255),
        l_local_s       TYPE string,
        l_ret,
        l_lines         TYPE i,
        i_lines         TYPE i,
        l_pos           TYPE i,
        l_tmp(10),
        c_pos(10).
  DATA: l_appfile TYPE rcgfiletr-ftappl,
        c_value   TYPE string.
  DATA: l_name(100),
        l_formula(100).
  DATA: output_name TYPE string,
        input_name  TYPE string.
  DATA: itab TYPE STANDARD TABLE OF x255.
  DATA:
    lt_query TYPE TABLE OF w3query,
    ls_query LIKE LINE OF lt_query,
    lt_html  TYPE TABLE OF w3html,
    lt_mime  TYPE TABLE OF w3mime,
    tab      TYPE c.  " tab character
  DATA:
    lw_retcode    TYPE w3param-ret_code,
    ls_type       TYPE w3param-cont_type,
         TYPE w3param-cont_len,
    ev_mime_type  TYPE string,
    ev_xmime_type TYPE xstring,
    filesize      TYPE i,
    ls_xtext      TYPE xstring.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Check Excel template ...'.

  PERFORM get_save_path_file USING input_name 'Template Asset Master Upload.xls'.
  IF input_name IS INITIAL.
    EXIT.
  ENDIF.
  tab = cl_abap_char_utilities=>horizontal_tab.

  ev_mime_type = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'.
  CLEAR ls_query.
  ls_query-name  = '_OBJECT_ID'.
  ls_query-value = 'ZMO_FI_5002_TEMP'.  " AI-TuanPTM 14.09.21

  APPEND ls_query TO lt_query.

  CALL FUNCTION 'WWW_GET_MIME_OBJECT'
    TABLES
      query_string        = lt_query[]
      html                = lt_html
      mime                = lt_mime
    CHANGING
      return_code         = lw_retcode
      content_type        = ls_type
      content_length      = ls_length
    EXCEPTIONS
      object_not_found    = 1
      parameter_not_found = 2
      OTHERS              = 3.

  l_local_s = input_name.
  l_appfile = l_full_pathfile.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      bin_filesize            = ls_length "filesize
      filename                = l_local_s
      filetype                = 'BIN'
    TABLES
      data_tab                = lt_mime[] "itab[]
*     FIELDNAMES              =
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc = 0.
*     MESSAGE 'Success'

  ENDIF.
ENDFORM.
```


## GUI_DOWNLOAD (CSV)
```abap
  IF it_tmp2[] IS NOT INITIAL.

    DATA(ls_header) = it_tmp2[ 1 ].
    DELETE it_tmp2[] INDEX 1.
    " ALV-objekt erzeugen
    cl_salv_table=>factory( IMPORTING r_salv_table = DATA(lo_salv)
                            CHANGING  t_table      = it_tmp2[] ).
    "set header texts
    DATA(lo_desc) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( ls_header ) ).

    LOOP AT lo_desc->get_components( ) ASSIGNING FIELD-SYMBOL(<fs_col>).
      ASSIGN COMPONENT sy-tabix OF STRUCTURE ls_header TO FIELD-SYMBOL(<fs_name>).
      IF sy-subrc = 0.
        DATA(lo_column) = lo_salv->get_columns( )->get_column( CONV lvc_fname( <fs_col>-name ) ).
        lo_column->set_long_text( CONV scrtext_l( <fs_name> ) ).
        lo_column->set_medium_text( CONV scrtext_m( <fs_name> ) ).
        lo_column->set_short_text( CONV scrtext_s( <fs_name> ) ).
      ENDIF.
    ENDLOOP.
* itab (data) -> xstring (bytes)
    DATA(lv_bin_data) = lo_salv->to_xml( xml_type = if_salv_bs_xml=>c_type_xlsx ).

* xstring (Bytes) -> RAW (iTab)
    cl_scp_change_db=>xstr_to_xtab( EXPORTING im_xstring = lv_bin_data
                                    IMPORTING ex_size    = DATA(lv_size)
                                              ex_xtab    = DATA(lt_raw_data) ).

    lv_filename = p_file.
    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        bin_filesize            = lv_size               
        filename                = lv_filename
*       codepage                = '8600'
        filetype                = 'BIN'                
      CHANGING
*       data_tab                = itab_csv[]       "CSV data     
        data_tab                = lt_raw_data      "RAW data 
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        not_supported_by_gui    = 22
        error_no_gui            = 23
        OTHERS                  = 24.
  ENDIF.
```

