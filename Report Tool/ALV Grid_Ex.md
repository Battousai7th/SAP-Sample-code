## Color
![image](https://github.com/user-attachments/assets/732f9c74-107f-4a47-b028-a44a0779c023)

```abap
  DATA: LS_CELLTAB TYPE LVC_S_STYL,
        LT_CELLTAB TYPE LVC_T_STYL,
        LS_CELLCOLOR  TYPE LVC_S_SCOL,
        LT_CELLCOLOR TYPE LVC_T_SCOL. 

    ls_style-fieldname  = 'SO_TIEN'.
    ls_style-style      = '00000121'.
    INSERT ls_style INTO TABLE lt_style.
    ls_cellcolor-color-col = '6'.  "color code 1-7, if outside rage defaults to 7 (Theo dãi màu từ 1 -> 7, 3 là màu vàng, 7 là màu da)
    ls_cellcolor-color-int = '0'.  "text colour
    ls_cellcolor-color-inv = '1'.  "background colour
    ls_cellcolor-fname     = 'SO_TIEN'.
    INSERT ls_cellcolor INTO TABLE lt_cellcolor.
    gs_data_group-cell_style = lt_style.
    gs_data_group-cell_color = lt_cellcolor. 

FORM BUILD_LAYOUT .
  gs_layout-cwidth_opt = 'X'.
  gs_layout-zebra      = 'X'.
  gs_layout-stylefname = 'CELL_STYLE'.
  gs_layout-ctab_fname = 'CELL_COLOR'.
ENDFORM.            "BUILD_LAYOUT
```
- **Lưu ý**: Không thể dùng cùng với `AT LAST, AT END, ...`
[alvgrid_cellcolor](https://www.trailsap.com/dev/abap/reporting/alv/?topic=alvgrid_cellcolor)

- **Another Example**
```abap
DATA: gs_color    TYPE lvc_s_scol.

  LOOP AT lt_file_tmp INTO ls_file.
    gs_color-fname = 'TYPE'.       "Tên cột cần tô
    IF ls_file-type <> 'E'.        
      gs_color-color-col = '5'.  "Xanh
      gs_color-color-int = '0'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO ls_file-color.
      CLEAR gs_color.
    ELSE.
      gs_color-color-col = '6'.   "Đỏ
      gs_color-color-int = '0'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO ls_file-color.
      CLEAR gs_color.
    ENDIF.

    APPEND ls_file TO lt_file.
    CLEAR ls_file.
  ENDLOOP.
```

- Đối với **REUSE_ALV_GRID_DISPLAY**
```abap
    DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
          gs_fieldcat TYPE slis_fieldcat_alv.

    CLEAR gs_fieldcat.
    gs_fieldcat-fieldname  = 'MESS_DESC'.
    gs_fieldcat-seltext_m  = TEXT-006.
    gs_fieldcat-emphasize  = 'C500'.
    APPEND gs_fieldcat TO gt_fieldcat.
```

- **Bảng màu theo dòng**

![image](https://github.com/user-attachments/assets/9d117331-20b8-41f7-aec2-c10c30c839c2)

- **Table color**

![image](https://github.com/user-attachments/assets/0b02519c-cc1c-4823-aac7-06d04ec4ea3a)
![image](https://github.com/user-attachments/assets/ce86f510-556a-49cd-8a0e-201419473783)


## Double Click vào Cell chỉ định theo line
```abap
*&---------------------------------------------------------------------*
*&      Form  SET_USER_COMMAND
*&---------------------------------------------------------------------*
FORM SET_USER_COMMAND USING U_UCOMM      LIKE SY-UCOMM
                            RS_SELFIELD  TYPE SLIS_SELFIELD.
  CASE U_UCOMM.
    WHEN '&IC1'.
      BREAK ABAPLEADER.
      PERFORM F_DOUBLE_CLICK_CELL USING RS_SELFIELD.
      RETURN.
    WHEN OTHERS.
      RETURN.
  ENDCASE.
ENDFORM.  
*&---------------------------------------------------------------------*
*& Form F_DOUBLE_CLICK_CELL
*&---------------------------------------------------------------------*
*& Double click cell
*&---------------------------------------------------------------------* 
FORM F_DOUBLE_CLICK_CELL USING RS_SELFIELD  TYPE SLIS_SELFIELD.
  CLEAR: <GFS_LINE>.
  FIELD-SYMBOLS: <FS_MATNR> TYPE ANY.

  CHECK RS_SELFIELD-TABINDEX > 0.      "Vị trí ô dòng trong Internal Table
  IF RS_SELFIELD-FIELDNAME = 'LABST'. 
     SET PARAMETER ID 'BLN' FIELD LS_OUTPUT-BELNR_THUTIEN.  " Tham số chuyền vào
     SET PARAMETER ID 'BUK' FIELD LS_OUTPUT-BUKRS.
     SET PARAMETER ID 'GJR' FIELD LS_OUTPUT-BUDAT+0(4).  
    CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.           " Call Màn hình FB03
  ELSE.                               
        *&------
  ENDIF.
```

## Refresh ALV GRID and keep position and current cell
[refresh-alv-grid-and-keep-position-and-current-cell](https://abapblog.com/articles/tricks/22-refresh-alv-grid-and-keep-position-and-current-cell)

```abap
DATA: d_repid    LIKE sy-repid,
      t_fieldcat TYPE lvc_t_fcat,
      s_fieldcat TYPE lvc_s_fcat,
      x_layout   TYPE lvc_s_layo,
      go_grid    TYPE REF TO cl_gui_alv_grid.
*     Begin of Refresh ALV after commit sucessful
      DATA: ls_stable TYPE lvc_s_stbl.
 
      ls_stable-row = 'X'.
      ls_stable-col = 'X'.
 
      "Get changed things on ALV screen
      IF go_grid IS INITIAL.
        CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
          IMPORTING
            e_grid = go_grid.
      ENDIF.
 
      CALL METHOD go_grid->refresh_table_display
        EXPORTING
          is_stable      = ls_stable
          i_soft_refresh = 'X'.
*     End of refresh ALV
```
