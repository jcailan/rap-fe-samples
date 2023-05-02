*"* use this source file for your ABAP unit test classes
CLASS ltc_test_handler DEFINITION FINAL FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
        class_under_test TYPE REF TO zcl_product_model_es.

    CLASS-METHODS:
      class_setup,
      class_teardown.

    METHODS:
      get_products FOR TESTING.

ENDCLASS.

CLASS ltc_test_handler IMPLEMENTATION.

  METHOD class_setup.
    DATA client_proxy_stub TYPE REF TO /iwbep/if_cp_client_proxy.
    DATA resource_stub TYPE REF TO /iwbep/if_cp_resource_list.
    DATA read_request_stub TYPE REF TO /iwbep/if_cp_request_read_list.
    DATA read_response_stub TYPE REF TO /iwbep/if_cp_response_read_lst.
    DATA products_mock TYPE zcl_product_model_es=>tt_products.

    products_mock = VALUE #(
        ( id = '08C142FA01B0441DB01DEEAA3291F6F0' name = 'Bread' description = 'Whole grain bread' imageurl = '/assets/bread.jpg' releasedate = '19920101000000' discontinueddate = ''
          price = '2.5' height = '5' width = '10' depth = '8' quantity = '20' unitofmeasure_id = 'EA' currency_id = 'USD' category_id = 'F' supplier_id = 'AEAD11FDE35B4F6FA37AE4A860AAAAD7' dimensionunit_id = 'CM' )
    ).

    read_response_stub ?= cl_abap_testdouble=>create( '/iwbep/if_cp_response_read_lst' ).
    read_request_stub ?= cl_abap_testdouble=>create( '/iwbep/if_cp_request_read_list' ).
    resource_stub ?= cl_abap_testdouble=>create( '/iwbep/if_cp_resource_list' ).
    client_proxy_stub ?= cl_abap_testdouble=>create( '/iwbep/if_cp_client_proxy' ).
    class_under_test = NEW zcl_product_model_es( client_proxy_stub ).

    TRY.
        cl_abap_testdouble=>configure_call( read_response_stub )->set_parameter( name = 'et_business_data' value = products_mock ).
        read_response_stub->get_business_data(  ).

        cl_abap_testdouble=>configure_call( read_response_stub )->returning( 1 ).
        read_response_stub->get_count(  ).

        cl_abap_testdouble=>configure_call( read_request_stub )->returning( read_response_stub ).
        read_request_stub->execute( ).

        cl_abap_testdouble=>configure_call( resource_stub )->returning( read_request_stub ).
        resource_stub->create_request_for_read( ).

        cl_abap_testdouble=>configure_call( client_proxy_stub )->returning( resource_stub ).
        client_proxy_stub->create_resource_for_entity_set( 'PRODUCTS' ).

      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.
  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD get_products.

    TRY.
        class_under_test->get_products(
          EXPORTING
            iv_top             = 5
            iv_skip            = 0
            is_count_requested = abap_true
          IMPORTING
            et_products        = DATA(products)
            ev_count           = DATA(count)
        ).
      CATCH cx_root INTO DATA(exception).
        "do nothing
    ENDTRY.

    cl_abap_unit_assert=>assert_equals( exp = 1 act = count ).
  ENDMETHOD.

ENDCLASS.
