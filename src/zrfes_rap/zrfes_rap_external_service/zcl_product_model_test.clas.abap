CLASS zcl_product_model_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_operation TYPE string VALUE 'Q'.

ENDCLASS.

CLASS zcl_product_model_test IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA product TYPE zcl_product_model_es=>ts_product.
    DATA products TYPE zcl_product_model_es=>tt_products.
    DATA filters TYPE if_rap_query_filter=>tt_name_range_pairs.
    DATA etag TYPE string.

    DATA(util) = NEW zcl_rfes_util( ).
    DATA(model) = NEW zcl_product_model_es(  ).

    TRY.
        CASE mv_operation.
          WHEN 'R'.
            model->get_product(
              EXPORTING
                iv_key     = CONV #( util->convert_to_abap_uuid( '06f86ef1-1525-4932-b1ce-d40661464c66' ) )
              IMPORTING
                es_product = product
                ev_etag    = etag
            ).
            out->write( product ).
            out->write( |ETAG: { etag }| ).

          WHEN 'Q'.
            model->get_products(
              EXPORTING
                it_filters  = filters
                iv_top      = 5
                iv_skip     = 0
              IMPORTING
                et_products = products
            ).
            out->write( products ).

          WHEN 'C'.
            model->create_product(
              EXPORTING
                is_product = VALUE #(
                  name = 'Pearl Mik Tea'
                  description = 'Milk tea with chewy pearls'
                  category_id = 'B'
                  unitofmeasure_id = 'EA'
                  currency_id = 'USD'
                )
              IMPORTING
                es_product = product
            ).
            out->write( product ).

          WHEN 'U'.
            model->update_product(
              EXPORTING
                is_product = VALUE #(
                  id = CONV #( util->convert_to_abap_uuid( '06f86ef1-1525-4932-b1ce-d40661464c66' ) )
                  name = 'Pink Lemonade (edited)'
                )
                iv_etag    = ''
              IMPORTING
                ev_etag    = etag
            ).
            out->write( |ETAG: { etag }| ).

          WHEN 'D'.
            model->delete_product(
              EXPORTING
                iv_key = CONV #( util->convert_to_abap_uuid( '00000000-0000-0000-0000-000000000000' ) )
            ).
            out->write( 'Entity was deleted' ).
        ENDCASE.

      CATCH cx_root INTO DATA(exception).
        out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
