## Insert/Delete/Copy row

```abap
*&---------------------------------------------------------------------*
*& ZUS_SDN_ALVGRID_EDITABLE_8A
*&
*&---------------------------------------------------------------------*
*& Thread: Insert a row in ALV
*& <a class="jive_macro jive_macro_thread" href="" __jive_macro_name="thread" modifiedtitle="true" __default_attr="1105097"></a>
*&
*& Thread: Blanking values on ALV Grid Row Duplicate
*& <a class="jive_macro jive_macro_thread" href="" __jive_macro_name="thread" modifiedtitle="true" __default_attr="1057161"></a>
*&
*& Thread: Delete line event in ALV
*& <a class="jive_macro jive_macro_thread" href="" __jive_macro_name="thread" modifiedtitle="true" __default_attr="945471"></a>
*&---------------------------------------------------------------------*
REPORT  zus_sdn_alvgrid_editable_8a.
TYPES: BEGIN OF ty_s_outtab.
INCLUDE TYPE knb1.
TYPES: END OF ty_s_outtab.
TYPES: ty_t_outtab    TYPE STANDARD TABLE OF ty_s_outtab
                      WITH DEFAULT KEY.
DATA:
  gd_okcode        TYPE ui_func,
  gd_repid         TYPE syst-repid,
*
  gt_fcat          TYPE lvc_t_fcat,
  go_docking       TYPE REF TO cl_gui_docking_container,
  go_grid          TYPE REF TO cl_gui_alv_grid.
DATA:
  gt_outtab        TYPE ty_t_outtab.
*----------------------------------------------------------------------*
*       CLASS lcl_eventhandler DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_eventhandler DEFINITION.
PUBLIC SECTION.
    CLASS-DATA:
      mt_sel_rows     TYPE lvc_t_row.
CLASS-METHODS:
      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING
          e_object
          sender,
handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING
          e_ucomm
          sender.
ENDCLASS.                    "lcl_eventhandler DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_eventhandler IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_eventhandler IMPLEMENTATION.
METHOD handle_toolbar.
* define local data
    DATA: ls_button     TYPE stb_button.
LOOP AT e_object->mt_toolbar INTO ls_button.
      CASE ls_button-function.
        when cl_gui_alv_grid=>MC_FC_LOC_INSERT_ROW.
          ls_button-function = 'INSERT_ROW'.
          MODIFY e_object->mt_toolbar FROM ls_button INDEX syst-tabix.
WHEN cl_gui_alv_grid=>mc_fc_loc_delete_row.
          ls_button-function = 'DELETE_ROW'.
          MODIFY e_object->mt_toolbar FROM ls_button INDEX syst-tabix.
WHEN cl_gui_alv_grid=>mc_fc_loc_copy_row OR
             cl_gui_alv_grid=>mc_fc_loc_copy.
          ls_button-function = 'COPY_ROW'.
          MODIFY e_object->mt_toolbar FROM ls_button INDEX syst-tabix.
        WHEN OTHERS.
          CONTINUE.
      ENDCASE.
ENDLOOP.
ENDMETHOD.                    "handle_toolbar

METHOD handle_user_command.
* define local data
    DATA: lt_rows       TYPE lvc_t_row,
          ls_row        TYPE lvc_s_row.
REFRESH: mt_sel_rows.
CASE e_ucomm.
      when 'INSERT_ROW'.
WHEN 'DELETE_ROW'.
WHEN 'COPY_ROW'.
WHEN OTHERS.
        RETURN.
    ENDCASE.
"   User wants to delete or copy rows => store them in class attribute
    "   and trigger PAI afterwards where we actually delete /copy the rows
    "   and do the recalculations (in case of deletion)
    CALL METHOD sender->get_selected_rows
      IMPORTING
        et_index_rows = mt_sel_rows
*        et_row_no     =
        .
*   Trigger PAI
    CALL METHOD cl_gui_cfw=>set_new_ok_code
      EXPORTING
        new_code = e_ucomm
*      IMPORTING
*        rc       =
        .
ENDMETHOD.                    "user_command
ENDCLASS.                    "lcl_eventhandler IMPLEMENTATION

PARAMETERS:
  p_bukrs      TYPE bukrs  DEFAULT '2000'  OBLIGATORY.
START-OF-SELECTION.
SELECT  * FROM  knb1 INTO CORRESPONDING FIELDS OF TABLE gt_outtab
         UP TO 15 ROWS
         WHERE  bukrs  = p_bukrs.
PERFORM init_controls.
SET HANDLER:
    lcl_eventhandler=>handle_toolbar      FOR go_grid,
    lcl_eventhandler=>handle_user_command FOR go_grid.
" Used to replace standard toolbar function code with custom FC
  go_grid->set_toolbar_interactive( ).
* Link the docking container to the target dynpro
  gd_repid = syst-repid.
  CALL METHOD go_docking->link
    EXPORTING
      repid                       = gd_repid
      dynnr                       = '0100'
*      CONTAINER                   =
    EXCEPTIONS
      OTHERS                      = 4.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
* ok-code field = GD_OKCODE
  CALL SCREEN '0100'.
END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
*  SET TITLEBAR 'xxx'.
**      CALL METHOD go_grid1->refresh_table_display
***        EXPORTING
***          IS_STABLE      =
***          I_SOFT_REFRESH =
**        EXCEPTIONS
**          FINISHED       = 1
**          others         = 2
**              .
**      IF sy-subrc <> 0.
***       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***                  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**      ENDIF.
ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
CASE gd_okcode.
    WHEN 'BACK' OR
         'END'  OR
         'CANC'.
      SET SCREEN 0. LEAVE SCREEN.
WHEN 'INSERT_ROW'.
      perform INSERT_ROW.
WHEN 'DELETE_ROW'.
      PERFORM delete_rows.
WHEN 'COPY_ROW'.
      PERFORM copy_rows.
WHEN OTHERS.
  ENDCASE.
CLEAR: gd_okcode.
CALL METHOD go_grid->refresh_table_display
*      EXPORTING
*        IS_STABLE      =
*        I_SOFT_REFRESH =
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2
          .
  IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCATALOG_KNB1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcatalog_knb1 .
* define local data
  DATA:
    ls_fcat        TYPE lvc_s_fcat.
CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE              =
      i_structure_name             = 'KNB1'
*     I_CLIENT_NEVER_DISPLAY       = 'X'
*     I_BYPASSING_BUFFER           =
*     I_INTERNAL_TABNAME           =
    CHANGING
      ct_fieldcat                  = gt_fcat
    EXCEPTIONS
      inconsistent_interface       = 1
      program_error                = 2
      OTHERS                       = 3.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
* Only non-key fields are editable
  ls_fcat-edit = 'X'.
  MODIFY gt_fcat FROM ls_fcat
    TRANSPORTING edit
    WHERE ( key NE 'X' ).
ENDFORM.                    " BUILD_FIELDCATALOG_KNB1
*&---------------------------------------------------------------------*
*&      Form  INIT_CONTROLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_controls .
* Create docking container
  CREATE OBJECT go_docking
    EXPORTING
      parent = cl_gui_container=>screen0
      ratio  = 90
    EXCEPTIONS
      OTHERS = 6.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
* Create ALV grid
  CREATE OBJECT go_grid
    EXPORTING
      i_parent = go_docking
    EXCEPTIONS
      OTHERS   = 5.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
* Build fieldcatalog and set hotspot for field KUNNR
  PERFORM build_fieldcatalog_knb1.
* Display data
  CALL METHOD go_grid->set_table_for_first_display
    CHANGING
      it_outtab       = gt_outtab
      it_fieldcatalog = gt_fcat
    EXCEPTIONS
      OTHERS          = 4.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.                    " INIT_CONTROLS
*&---------------------------------------------------------------------*
*&      Form  delete_rows
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM delete_rows .
* define local data
  DATA: ls_row    TYPE lvc_s_row.
SORT lcl_eventhandler=>mt_sel_rows BY index DESCENDING. " !!!
LOOP AT lcl_eventhandler=>mt_sel_rows INTO ls_row.
    DELETE gt_outtab INDEX ls_row-index.
  ENDLOOP.
" After deleting rows do RE-CALCULATION
*  perform RECALCULATION.
ENDFORM.                    " delete_rows
*&---------------------------------------------------------------------*
*&      Form  COPY_ROWS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM copy_rows .
* define local data
  DATA: ld_next   TYPE i,
        ls_row    TYPE lvc_s_row,
        ls_outtab TYPE ty_s_outtab.
SORT lcl_eventhandler=>mt_sel_rows BY index DESCENDING. " !!!
LOOP AT lcl_eventhandler=>mt_sel_rows INTO ls_row.
    READ TABLE gt_outtab INTO ls_outtab INDEX ls_row-index.
CLEAR: ls_outtab-akont. " In your case: clear GUID
    ld_next = ls_row-index + 1.
    INSERT ls_outtab INTO gt_outtab INDEX ld_next.
  ENDLOOP.
ENDFORM.                    " COPY_ROWS
*&---------------------------------------------------------------------*
*&      Form  INSERT_ROW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form INSERT_ROW .
* define local data
  DATA: ld_value1  type SPOP-VARVALUE1,
        ls_outtab  TYPE ty_s_outtab.
CALL FUNCTION 'POPUP_TO_GET_ONE_VALUE'
    EXPORTING
      textline1            = 'Enter Value (4 Chars):'
*     TEXTLINE2            = ' '
*     TEXTLINE3            = ' '
      titel                = 'Enter Value'
      valuelength          = 4
    IMPORTING
*     ANSWER               =
      VALUE1               = ld_value1
    EXCEPTIONS
      TITEL_TOO_LONG       = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ls_outtab-kunnr = ld_value1.
  ls_outtab-bukrs = ld_value1.
append ls_outtab to gt_outtab.
endform.                    " INSERT_ROW
```  


## Handle Toolbar (Add Button)
For adding a button on the toolbar, you will need to handle the **TOOLBAR** event of the class **CL_GUI_ALV_GRID**. 
 + This event has a parameter E_OBJECT which is an object reference to the class **CL_ALV_EVENT_TOOLBAR_SET**. 
 + Using this object you can access an internal table **MT_BUTTON** in the class **CL_ALV_EVENT_TOOLBAR_SET**. 
 + Append the Function Code, Icon and Text to this internal table.

```abap
*&---------------------------------------------------------------------*
*& TOP
*&---------------------------------------------------------------------*
DATA: go_container TYPE REF TO cl_gui_custom_container, "Container
         go_grid        TYPE REF TO cl_gui_alv_grid. "Grid

*&---------------------------------------------------------------------*
*& CLASS
*&---------------------------------------------------------------------*
CLASS gcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS: handle_toolbar
      FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING e_object e_interactive.

    METHODS: handle_user_command
      FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING e_ucomm.
ENDCLASS. "lcl_event_handler DEFINITION

CLASS gcl_event_handler IMPLEMENTATION.

  METHOD: handle_toolbar.
    PERFORM handle_toolbar USING e_object.
  ENDMETHOD.

  METHOD: handle_user_command.
    PERFORM handle_user_command USING e_ucomm.
  ENDMETHOD.

ENDCLASS. "lcl_event_handler IMPLEMENTATION
*&---------------------------------------------------------------------*
*& Declare Instance after create CLASS
*&---------------------------------------------------------------------*
DATA: go_event_handler TYPE REF TO gcl_event_handler.

*&---------------------------------------------------------------------*
*& Module STATUS_9000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_9000 OUTPUT.

  IF go_grid IS INITIAL.
    SET PF-STATUS 'ZSTATUS_9000'. "GUI Status
    SET TITLEBAR 'ZTITLE_9000'.   "Title
* Creating Docking Container and grid
    PERFORM create_object.
* Filling the fieldcatalog table
    PERFORM build_fieldcat.
* Registering edit
    PERFORM register_edit.
* Displaying the output
    PERFORM display_output.

    CREATE OBJECT go_event_handler .
    SET HANDLER go_event_handler->handle_toolbar FOR go_grid.
    SET HANDLER go_event_handler->handle_user_command FOR go_grid.

    CALL METHOD go_grid->set_ready_for_input  " go_grid->set_ready_for_input( i_ready_for_input = 1 ).
      EXPORTING
        i_ready_for_input = 1.
  ELSE.
    CALL METHOD go_grid->refresh_table_display
      EXCEPTIONS
        finished = 1
        OTHERS   = 2.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* -->P_E_OBJECT text
*----------------------------------------------------------------------*
FORM handle_toolbar USING i_object TYPE REF TO cl_alv_event_toolbar_set.
  DATA: ls_toolbar TYPE stb_button.

  CLEAR ls_toolbar.
  MOVE 'CHECK' TO ls_toolbar-function.
  MOVE icon_okay TO ls_toolbar-icon.
  MOVE 'Check' TO ls_toolbar-text.
  MOVE 'Check' TO ls_toolbar-quickinfo.
  MOVE ' ' TO ls_toolbar-disabled.
  APPEND ls_toolbar TO i_object->mt_toolbar.

ENDFORM. " HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* -->P_E_UCOMM text
*----------------------------------------------------------------------*
FORM handle_user_command USING i_ucomm TYPE syucomm.

  DATA:lt_rows TYPE lvc_t_row,
       w_row   TYPE lvc_s_row.

*GET selected row
    CALL METHOD grid1->get_selected_rows
      IMPORTING
        et_index_rows = lt_rows.

    READ TABLE lt_rows INTO w_row INDEX 1.
    READ TABLE i_vbak INTO w_vbak INDEX w_row-index.

  CASE i_ucomm.
    WHEN 'CHECK'.
      MESSAGE i000(zf) WITH 'Check Button!'.
    WHEN OTHERS.
  ENDCASE.

    CALL METHOD o_alvgrid->refresh_table_display
      EXPORTING
        is_stable = ls_stable.

    CALL METHOD cl_gui_cfw=>flush.

ENDFORM. " HANDLE_USER_COMMAND
```
