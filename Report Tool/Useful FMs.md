## Function Modules

**Lấy tên của Computer hiện tại:**
`DOC_GET_COMPUTER_NAME`

**Lấy text theo mã ID:**
`READ_TEXT`

**Lấy nhiều text theo mã ID:**
`READ_MULTIPLE_TEXTS`

**Function convert date bên ngoài/trong SAP:**
`CONVERT_DATE_TO_INTERNAL`;
`CONVERT_DATE_TO_EXTERNAL`

**Tìm table ngay trong Program:**
`GET_TABLE`

**Chuyển đổi ngày tháng năm sang dạng TEXT:**
`CONVERSION_EXIT_LDATE_OUTPUT`;
`CONVERSION_EXIT_SDATE_OUTPUT`

**Tháng tiếng anh:**
`CONVERSION_EXIT_VDATE_OUTPUT`

**Thêm/Bớt số 0 trước chuỗi:**
`CONVERSION_EXIT_ALPHA_INPUT`
`CONVERSION_EXIT_ALPHA_OUTPUT`

**Convert Ngày sang Kỳ:**
`DATE_TO_PERIOD_CONVERT

**Lấy ngày cuối cùng trong tháng:**
`RP_LAST_DAY_OF_MONTHS`;
`HR_JP_MONTH_BEGIN_END_DATE`

**Lấy ngày đầu/cuối của tháng:**
`OIL_MONTH_GET_FIRST_LAST`

**Tạo màn hình nhập liệu theo y/c USER:**
`CATSXT_SIMPLE_TEXT_EDITOR` 

**Lấy tên tháng từ ngày:**
`MONTH_NAMES_GET`

**Lấy tên viết tắt tháng (IN HOA) từ kiểu số:**
`ISP_GET_MONTH_NAME`;
`CONVERSION_EXIT_SDATE_OUTPUT`

**Tạo dynamic Where:**
`CRS_CREATE_WHERE_CONDITION`

**Record a file from an internal table:**
`GUI_DOWNLOAD`

**Upload a file to an internal table:**
`GUI_UPLOAD` 

**Xác định ngày trong tuần:**
`DATE_COMPUTE_DAY`
 
**Lấy thông tin ngày:**
`DAY_ATTRIBUTES_GET`;
`HR_IN_GET_DATE_COMPONENTS`

**Lấy lùi về theo từng tháng:**
`CCM_GO_BACK_MONTHS`

**Xác định ngày nghĩ lễ theo tham số nhập vào dựa vào Tcode OY05:**
`HOLIDAY_GET`

**Xác định ngày nhập vào có phải là ngày lễ hay không:**
`HOLIDAY_CHECK_AND_GET_INFO`

**Lấy thông tin PO14:**
`RH_READ_OBJECT`

**Tách length theo ký tự:**
`SWA_STRING_SPLIT`

**Call Web Browser:**
`CALL_BROWSER`

**Lấy tổng số ngày theo khoảng thời gian nhập:**
`ISU_NUMBER_DAYS_OF_RANGE` 

**Lấy số ngày/tuần/tháng/năm theo khoảng thời gian nhập:**
`HR_99S_INTERVAL_BETWEEN_DATES`

**Chuyển đổi nút tích hợp:**
`GET_DOMAENENTEXT` 

**Tính thuế line chứng từ FB03:**
`RECP_FI_TAX_CALCULATE`

**Đọc Text trong Domain:**
`GET_DOMAIN_VALUES`

**Lấy quý của năm:**
`HR_99S_GET_QUARTER`

**Xuất Icon:** 
`GET_DOMAENENTEXT` 

**Print Smart form to a desired local printer connected to your PC:**
`RSPO_FRONTEND_PRINTERS_FOR_DEV` 

**Default print settings through abap program:**
`SET_PRINT_PARAMETERS` 

**Lấy số ngày trong tháng:**
`NUMBER_OF_DAYS_PER_MONTH_GET`

**Convert số ra chữ:**
`SPELL_AMOUNT`

**Trả về các Object được gán cho User:**
`SUSR_USER_AUTH_FOR_OBJ_GET` 

**FM lấy lùi/ thêm n ngày:**
`RP_CALC_DATE_IN_INTERVAL`

- **Chuyển CHAR to DEC:**
`HRCM_AMOUNT_CONVERT_CURRENCY`;
`C14W_CHAR_number_CONVERSION`

- **Chuyển đổi Amount:**
```abap
DATA: AMOUNT_R Types BAPICURR_D	(DEC  23  4),
      DMBTR    Types DMBTR      (CURR 13  2)
  CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
    EXPORTING
      CURRENCY             = 'VND'
      AMOUNT_EXTERNAL      = GS_PRTFI-AMOUNT_R
      MAX_NUMBER_OF_DIGITS = 22
    IMPORTING
      AMOUNT_INTERNAL      = GS_BSEG-DMBTR.
```

- **Chuyển NUM -> STRING / STRING -> NUM:**
`HRCM_AMOUNT_TO_STRING_CONVERT`;
`HRCM_STRING_TO_AMOUNT_CONVERT`
```abap
    CALL FUNCTION 'HRCM_STRING_TO_AMOUNT_CONVERT'
      EXPORTING
        string              = lv_amount
        decimal_separator   = '.'
        thousands_separator = ','
        WAERS               = 'VND'
      IMPORTING
        betrg               = currencyamount-amt_doccur.
```

- **Chuyển FLOAT  to CHAR:**
`QSS0_FLTP_TO_CHAR_CONVERSION`
```abap
    CALL FUNCTION 'QSS0_FLTP_TO_CHAR_CONVERSION'
      EXPORTING
        i_number_of_digits = gs_data-stellen
        i_fltp_value       = gs_data-sollwert
      IMPORTING
        e_char_field       = lt_inspcharacteristic-target_val.
```

- **Cắt chuỗi tròn chữ theo chiều dài tối đa theo tham số:**
`RKD_WORD_WRAP`
![image](https://github.com/user-attachments/assets/bfd84a85-6a1d-4e1f-8dda-a680a75e1400)

