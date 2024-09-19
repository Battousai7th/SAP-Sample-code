CLASS zcl_rap_salesorder_ptm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    METHODS create_so_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
              o TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS zcl_rap_salesorder_ptm IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    o = out.

    create_so_data(  ).
  ENDMETHOD.


  METHOD create_so_data.
    DATA: lt_so_rap    TYPE TABLE FOR CREATE zr_rap_so_ptm,
          ls_so_rap    TYPE STRUCTURE FOR CREATE zr_rap_so_ptm,
*          lt_so_it_rap TYPE TABLE FOR CREATE zi_rap_so_i_ptm,
*          ls_so_it_rap TYPE STRUCTURE FOR CREATE zi_rap_so_i_ptm,
          lt_so_it_rap TYPE TABLE FOR CREATE zr_rap_so_ptm\_salesorderitems,
          ls_so_it_rap TYPE STRUCTURE FOR CREATE zr_rap_so_ptm\_salesorderitems,
          lt_target    TYPE TABLE FOR CREATE zr_rap_so_ptm\\salesorderitems.        "For Target table

*   Get SO data
    SELECT
        ( 'SO' && '_' && vbeln ) AS ssid,
        vbeln,
        audat,
        bstnk,
        kunnr,
        waerk,
        netwr,
        cmps_te,              "Life cycle status
        gbstk,                "Billing status
        lfstk,                "Delivery status
        pay_method,
        cmpsd,
        erdat,
        erzet,
        ernam,
        upd_tmstmp,
        last_changed_by_user
        FROM vbak
        ORDER BY ssid
        INTO TABLE @DATA(lt_vbak).

    IF lt_vbak[] IS NOT INITIAL.
      DATA lv_id TYPE int2.

      lt_so_rap = VALUE #( FOR ls_vbak IN lt_vbak ( %cid            = ls_vbak-ssid
                                                    salesorder      = ls_vbak-vbeln
                                                    orderdate       = ls_vbak-audat
                                                    note            = ls_vbak-bstnk
                                                    soldtoparty     = ls_vbak-kunnr
                                                    currency        = ls_vbak-waerk
                                                    taxamount       = ls_vbak-netwr
                                                    lifecyclestatus = ls_vbak-cmps_te
                                                    billingstatus   = ls_vbak-gbstk
                                                    deliverystatus  = ls_vbak-lfstk
                                                    paymentmethod   = ls_vbak-pay_method
                                                    paymentterm     = ls_vbak-cmpsd
                                                    createddate     = ls_vbak-erdat
                                                    createdtime     = ls_vbak-erzet
                                                    createdby       = ls_vbak-ernam
                                                    lastchangedat   = ls_vbak-upd_tmstmp
                                                    lastchangedby   = ls_vbak-last_changed_by_user
                                                    %control =  VALUE #(  salesorder      = if_abap_behv=>mk-on
                                                                          orderdate       = if_abap_behv=>mk-on
                                                                          note            = if_abap_behv=>mk-on
                                                                          soldtoparty     = if_abap_behv=>mk-on
                                                                          currency        = if_abap_behv=>mk-on
                                                                          taxamount       = if_abap_behv=>mk-on
                                                                          lifecyclestatus = if_abap_behv=>mk-on
                                                                          billingstatus   = if_abap_behv=>mk-on
                                                                          deliverystatus  = if_abap_behv=>mk-on
                                                                          paymentmethod   = if_abap_behv=>mk-on
                                                                          paymentterm     = if_abap_behv=>mk-on
                                                                          createddate     = if_abap_behv=>mk-on
                                                                          createdtime     = if_abap_behv=>mk-on
                                                                          createdby       = if_abap_behv=>mk-on
                                                                          lastchangedat   = if_abap_behv=>mk-on
                                                                          lastchangedby   = if_abap_behv=>mk-on  ) ) ).
    ENDIF.

*   Get SO Items data
    SELECT
        concat( 'SO_I_', concat( vbeln, CAST( posnr AS CHAR ) ) ) AS ssid,
        vbeln,
        posnr,
        bstkd_ana,
        matnr,
        kwmeng,
        vrkme,
        netpr,
        waerk,
        erdat,
        erzet,
        ernam
        FROM vbap
        ORDER BY ssid
        INTO TABLE @DATA(lt_vbap).

*    Filter Target value
    IF lt_vbap[] IS NOT INITIAL.
      lt_target = VALUE #( FOR ls_vbap IN lt_vbap ( %cid          = ls_vbap-ssid
                                                    salesorder    = ls_vbap-vbeln
                                                    itemline      = ls_vbap-posnr
                                                    itemnote      = ls_vbap-bstkd_ana
                                                    product       = ls_vbap-matnr
                                                    quantity      = ls_vbap-kwmeng
                                                    quantityunit  = ls_vbap-vrkme
                                                    price         = ls_vbap-netpr
                                                    currency      = ls_vbap-waerk
                                                    createddate   = ls_vbap-erdat
                                                    createdtime   = ls_vbap-erzet
                                                    createdby     = ls_vbap-ernam
                                                    %control =  VALUE #(  itemline      = if_abap_behv=>mk-on
                                                                          itemnote      = if_abap_behv=>mk-on
                                                                          product       = if_abap_behv=>mk-on
                                                                          quantity      = if_abap_behv=>mk-on
                                                                          quantityunit  = if_abap_behv=>mk-on
                                                                          price         = if_abap_behv=>mk-on
                                                                          currency      = if_abap_behv=>mk-on
                                                                          createddate   = if_abap_behv=>mk-on
                                                                          createdtime   = if_abap_behv=>mk-on
                                                                          createdby     = if_abap_behv=>mk-on  ) ) ).

      LOOP AT lt_vbak INTO DATA(ls_vbak1).
        DATA(lt_temp) = lt_target[].
        DELETE lt_temp WHERE salesorder NE ls_vbak1-vbeln.

        ls_so_it_rap-%cid_ref = ls_vbak1-ssid.
        ls_so_it_rap-%target  = lt_temp[].

        APPEND ls_so_it_rap TO lt_so_it_rap.
        CLEAR ls_so_it_rap.
      ENDLOOP.

*     Call EML to Create Entity for SO Header and SO Items data
      MODIFY ENTITIES OF zr_rap_so_ptm
        ENTITY salesorder
        CREATE FROM lt_so_rap
        CREATE BY \_salesorderitems
        FROM lt_so_it_rap
        FAILED DATA(ls_failed)
        REPORTED DATA(ls_reported)
        MAPPED DATA(ls_mapped).

      IF ls_failed IS INITIAL.
        COMMIT ENTITIES
            RESPONSE OF zr_rap_so_ptm
            FAILED DATA(ls_failed1)
            REPORTED DATA(ls_reported2).
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
