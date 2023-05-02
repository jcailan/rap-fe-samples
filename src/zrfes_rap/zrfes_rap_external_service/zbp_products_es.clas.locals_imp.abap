CLASS lhc_zz_products_es DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    METHODS set_model
      IMPORTING
        io_model TYPE REF TO zcl_product_model_es.

    METHODS get_model
      RETURNING
        VALUE(ro_model) TYPE REF TO zcl_product_model_es.

  PRIVATE SECTION.

    TYPES ts_product TYPE zz_products_es.
    TYPES tt_product_failed TYPE TABLE FOR FAILED zz_products_es.
    TYPES tt_product_reported TYPE TABLE FOR REPORTED zz_products_es.

    DATA mo_model TYPE REF TO zcl_product_model_es.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR products RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE products.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE products.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE products.

    METHODS read FOR READ
      IMPORTING keys FOR READ products RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK products.

    METHODS map_messages
      IMPORTING
        cid      TYPE string OPTIONAL
        id       TYPE ts_product-id OPTIONAL
        message  TYPE string OPTIONAL
      CHANGING
        failed   TYPE tt_product_failed
        reported TYPE tt_product_reported.

ENDCLASS.

CLASS lhc_zz_products_es IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA product TYPE zcl_product_model_es=>ts_product.
    DATA(model) = get_model( ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      TRY.
          model->create_product(
            EXPORTING
              is_product = CORRESPONDING #( <entity> )
            IMPORTING
              es_product = product
          ).
        CATCH cx_root INTO DATA(exception).
          map_messages(
            EXPORTING
              cid      = <entity>-%cid
              id       = <entity>-id
              message  = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( )
            CHANGING
              failed   = failed-products
              reported = reported-products
          ).
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA notification TYPE zcl_product_model_es=>ts_product.
    DATA(model) = get_model( ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      TRY.
          model->update_product( CORRESPONDING #( <entity> ) ).
        CATCH cx_root INTO DATA(exception).
          map_messages(
            EXPORTING
              cid      = <entity>-%cid_ref
              id       = <entity>-id
              message  = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( )
            CHANGING
              failed   = failed-products
              reported = reported-products
          ).
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA product TYPE zcl_product_model_es=>ts_product.
    DATA(model) = get_model( ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>) GROUP BY <key>-%tky.
      TRY.
          model->delete_product( <key>-id ).
        CATCH cx_root INTO DATA(exception).
          map_messages(
            EXPORTING
              id       = <key>-id
              message  = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( )
            CHANGING
              failed   = failed-products
              reported = reported-products
          ).
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    DATA product TYPE zcl_product_model_es=>ts_product.
    DATA(model) = get_model( ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>) GROUP BY <key>-%tky.
      TRY.
          model->get_product(
            EXPORTING
              iv_key     = <key>-id
            IMPORTING
              es_product = product
          ).

          INSERT CORRESPONDING #( product ) INTO TABLE result.
        CATCH cx_root INTO DATA(exception).
          map_messages(
            EXPORTING
              id       = <key>-id
              message  = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( )
            CHANGING
              failed   = failed-products
              reported = reported-products
          ).
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD map_messages.
    APPEND VALUE #(
      %cid        = cid
      id          = id
      %fail-cause = if_abap_behv=>cause-unspecific
    ) TO failed.
    APPEND VALUE #(
      %cid = cid
      id   = id
      %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text     = message
      )
    ) TO reported.
  ENDMETHOD.

  METHOD set_model.
    mo_model = io_model.
  ENDMETHOD.

  METHOD get_model.
    IF mo_model IS NOT BOUND.
      mo_model = NEW zcl_product_model_es( ).
    ENDIF.

    RETURN mo_model.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zz_products_es DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zz_products_es IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
