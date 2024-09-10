## Add Logo
```abap
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

  DATA: LS_FM_NAME      TYPE RS38L_FNAM,
        LS_DOCPARAMS    TYPE SFPDOCPARAMS,
        LS_OUTPUTPARAMS TYPE SFPOUTPUTPARAMS.

  LS_OUTPUTPARAMS-NODIALOG = 'X'.
  LS_OUTPUTPARAMS-PREVIEW = 'X'.
  LS_OUTPUTPARAMS-DEST = 'PDF'.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      IE_OUTPUTPARAMS = LS_OUTPUTPARAMS
    EXCEPTIONS
      CANCEL          = 1
      USAGE_ERROR     = 2
      SYSTEM_ERROR    = 3
      INTERNAL_ERROR  = 4
      OTHERS          = 5.

  IF SY-SUBRC = 0.
    TRY.
*    Get the name of the generated function module
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            I_NAME     = 'ZFI_ADB_ZCM05'
          IMPORTING
            E_FUNCNAME = LS_FM_NAME.
      CATCH CX_FP_API_USAGE.
      CATCH CX_FP_API_REPOSITORY.
      CATCH CX_FP_API_INTERNAL.
    ENDTRY.
    LOOP AT GT_ADOBE INTO GS_ADOBE .
      CALL FUNCTION LS_FM_NAME
        EXPORTING
          /1BCDWB/DOCPARAMS = LS_DOCPARAMS
          DATA              = GS_ADOBE
        EXCEPTIONS
          USAGE_ERROR       = 1
          SYSTEM_ERROR      = 2
          INTERNAL_ERROR    = 3
          OTHERS            = 4.
      IF SY-SUBRC <> 0.
        MESSAGE TEXT-001 TYPE 'S' DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.
    ENDLOOP.
  ELSE.
    MESSAGE TEXT-001 TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

* Close the job
  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      USAGE_ERROR    = 1
      SYSTEM_ERROR   = 2
      INTERNAL_ERROR = 3
      OTHERS         = 4.
  IF SY-SUBRC <> 0.
    MESSAGE TEXT-001 TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
```
