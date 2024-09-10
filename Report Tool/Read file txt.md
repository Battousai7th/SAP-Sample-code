## Sample code
```abap
  DATA: it_raw TYPE truxs_t_text_data.
  DATA: ls_excel TYPE ty_excel.
  DATA: lw_file_path TYPE string.
  DATA: lv_file_name   TYPE rlgrap-filename,
        lv_folder_path TYPE rlgrap-filename,
        lv_v_pres      TYPE string,
        lv_file_path   TYPE  rlgrap-filename,
        lv_file_text   TYPE string.

  REFRESH: gt_excel.
  REFRESH: gt_result.
  REFRESH: gt_alv.

  lw_file_path = p_file.
  TRANSLATE lw_file_path TO UPPER CASE.
  lv_file_path = lw_file_path.
  CALL FUNCTION 'SO_SPLIT_FILE_AND_PATH'
    EXPORTING
      full_name     = lv_file_path
    IMPORTING
      stripped_name = lv_file_name
      file_path     = lv_folder_path
    EXCEPTIONS
      x_error       = 1
      OTHERS        = 2.

  IF lw_file_path CS '.TXT'.
    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = lw_file_path
        filetype                = 'ASC'
        has_field_separator     = '#'
        read_by_line            = 'X'
*       dat_mode                = 'X'
        replacement             = ' '
      CHANGING
        data_tab                = gt_excel[]
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.

    IF sy-subrc NE 0.
      MESSAGE i000(0k) WITH 'Uploading Error => ' sy-subrc.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.
```
