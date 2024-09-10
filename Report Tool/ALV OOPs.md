## ALV OOPs
```abap
* Internal Table
DATA: BEGIN OF it_alv OCCURS 0,
        matnr TYPE mara-matnr,
        maktx TYPE makt-maktx,
      END OF it_alv.

* ALV Container and Grid
DATA: alv_container TYPE REF TO cl_gui_custom_container,
      alv_grid      TYPE REF TO cl_gui_alv_grid,
      ok_code       LIKE sy-ucomm,
      fieldcat      TYPE lvc_t_fcat.

TABLES: mara.

* Selection Screen
SELECT-OPTIONS: s_matnr FOR mara-matnr.

START-OF-SELECTION.
  SELECT mara~matnr makt~maktx
    INTO CORRESPONDING FIELDS OF TABLE it_alv
    FROM mara
    INNER JOIN makt ON mara~matnr = makt~matnr
    WHERE mara~matnr IN s_matnr
      AND makt~spras = sy-langu.

  SORT it_alv ASCENDING BY matnr.

  IF it_alv[] IS INITIAL.
    MESSAGE s429(mo).
    EXIT.
  ENDIF.

  CALL SCREEN 100.

* Module STATUS_0100 (Output)
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

   IF alv_grid IS NOT BOUND. 
    CREATE OBJECT alv_container EXPORTING container_name = 'ALV_CONTAINER'.
    CREATE BJECT alv_grid EXPORTING i_parent = alv_container.
    PERFORM get_fieldcatalog.
   
    CALL METHOD alv_grid->set_table_for_first_display
       CHANGING
          it_outtab       = it_alv[]
          it_fieldcatalog = fieldcat[].
       IF sy-subrc = 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv1 sy-msgv1 sy-msgv1
   ENDIF.
   ELSE.
    CALL METHOD alv_grid->refresh_table_display
       EXCEPTIONS
          Finished = 1
       OTHERS   = 2.
ENDMODULE.

* Module USER_COMMAND_0100 (Input)
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

* Form GET_FIELDCATALOG - Set Up Columns/Headers
FORM get_fieldcatalog.
  DATA: ls_fcat TYPE lvc_s_fcat.

  REFRESH fieldcat.

  CLEAR ls_fcat.
  ls_fcat-reptext = 'Material Number'.
  ls_fcat-fieldname = 'MATNR'.
  ls_fcat-ref_table = 'IT_ALV'.
  ls_fcat-outputlen = '18'.
  APPEND ls_fcat TO fieldcat.

  CLEAR ls_fcat.
  ls_fcat-reptext = 'Material Description'.
  ls_fcat-fieldname = 'MAKTX'.
  ls_fcat-ref_table = 'IT_ALV'.
  ls_fcat-outputlen = '40'.
  APPEND ls_fcat TO fieldcat.
ENDFORM.
```
