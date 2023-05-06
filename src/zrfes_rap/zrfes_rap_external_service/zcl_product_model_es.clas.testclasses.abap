*"* use this source file for your ABAP unit test classes
CLASS ltc_products_entity DEFINITION FINAL FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    TYPES tt_products_temp TYPE TABLE OF zsproducts_rs.
    TYPES:
      BEGIN OF ts_query_out_mock,
        request        TYPE REF TO /iwbep/if_cp_request_read_list,
        response       TYPE REF TO /iwbep/if_cp_response_read_lst,
        filter_factory TYPE REF TO /iwbep/if_cp_filter_factory,
        filter_node    TYPE REF TO /iwbep/if_cp_filter_node,
      END OF ts_query_out_mock,

      BEGIN OF ts_query_in_mock,
        request  TYPE REF TO if_rap_query_request,
        response TYPE REF TO if_rap_query_response,
        paging   TYPE REF TO if_rap_query_paging,
        filter   TYPE REF TO if_rap_query_filter,
      END OF ts_query_in_mock,

      BEGIN OF ts_query_mock,
        in  TYPE ts_query_in_mock,
        out TYPE ts_query_out_mock,
      END OF ts_query_mock,

      BEGIN OF ts_read_mock,
        request  TYPE REF TO /iwbep/if_cp_request_read,
        response TYPE REF TO /iwbep/if_cp_response_read,
        resource TYPE REF TO /iwbep/if_cp_resource_list,
        entity   TYPE REF TO /iwbep/if_cp_resource_entity,
      END OF ts_read_mock,

      BEGIN OF ts_create_mock,
        request  TYPE REF TO /iwbep/if_cp_request_create,
        response TYPE REF TO /iwbep/if_cp_response_create,
        resource TYPE REF TO /iwbep/if_cp_resource_list,
      END OF ts_create_mock,

      BEGIN OF ts_update_mock,
        request  TYPE REF TO /iwbep/if_cp_request_update,
        response TYPE REF TO /iwbep/if_cp_response_update,
        resource TYPE REF TO /iwbep/if_cp_resource_list,
        entity   TYPE REF TO /iwbep/if_cp_resource_entity,
      END OF ts_update_mock,

      BEGIN OF ts_delete_mock,
        request  TYPE REF TO /iwbep/if_cp_request_delete,
        resource TYPE REF TO /iwbep/if_cp_resource_list,
        entity   TYPE REF TO /iwbep/if_cp_resource_entity,
      END OF ts_delete_mock.

    CLASS-DATA:
      mt_products TYPE zcl_product_model_es=>tt_products,
      mo_cut      TYPE REF TO zcl_product_model_es,
      mo_util     TYPE REF TO zcl_rfes_util.

    CLASS-METHODS:
      class_setup,
      class_teardown.

    METHODS:
      get_products_mock
        RETURNING
          VALUE(rt_products) TYPE zcl_product_model_es=>tt_products,
      configure_select
        IMPORTING
          iv_entity_set_name   TYPE string
          iv_top               TYPE int8 DEFAULT 5
          iv_skip              TYPE int8 DEFAULT 0
          iv_search_expression TYPE string OPTIONAL
          it_filters           TYPE if_rap_query_filter=>tt_name_range_pairs OPTIONAL
          it_sort_order        TYPE if_rap_query_request=>tt_sort_elements OPTIONAL
          it_data              TYPE STANDARD TABLE OPTIONAL
          is_count_requested   TYPE abap_bool DEFAULT abap_false
          io_exception         TYPE REF TO /iwbep/cx_gateway OPTIONAL
        RETURNING
          VALUE(rs_mock)       TYPE ts_query_mock,
      configure_query
        IMPORTING
          iv_entity_set_name TYPE string
          iv_search          TYPE string OPTIONAL
          iv_filter_count    TYPE i OPTIONAL
          it_sort_order      TYPE if_rap_query_request=>tt_sort_elements OPTIONAL
          it_data            TYPE STANDARD TABLE OPTIONAL
          is_count_requested TYPE abap_bool DEFAULT abap_false
          io_exception       TYPE REF TO /iwbep/cx_gateway OPTIONAL
        RETURNING
          VALUE(rs_mock)     TYPE ts_query_out_mock,
      configure_read
        IMPORTING
          iv_entity_set_name TYPE string
          is_key             TYPE data
          is_data            TYPE any OPTIONAL
          io_exception       TYPE REF TO /iwbep/cx_cp_remote OPTIONAL
        RETURNING
          VALUE(rs_mock)     TYPE ts_read_mock,
      configure_create
        IMPORTING
          iv_entity_set_name TYPE string
          is_data            TYPE any
          io_exception       TYPE REF TO /iwbep/cx_cp_remote OPTIONAL
        RETURNING
          VALUE(rs_mock)     TYPE ts_create_mock,
      configure_update
        IMPORTING
          iv_entity_set_name     TYPE string
          is_key                 TYPE data
          iv_etag                TYPE string
          is_data                TYPE any
          it_provided_properties TYPE /iwbep/if_cp_runtime_types=>ty_t_property_path OPTIONAL
          io_exception           TYPE REF TO /iwbep/cx_cp_remote OPTIONAL
        RETURNING
          VALUE(rs_mock)         TYPE ts_update_mock,
      configure_delete
        IMPORTING
          iv_entity_set_name TYPE string
          is_key             TYPE data
          io_exception       TYPE REF TO /iwbep/cx_cp_remote OPTIONAL
        RETURNING
          VALUE(rs_mock)     TYPE ts_delete_mock,
      verify_query_expectations
        IMPORTING
          is_mock TYPE ts_query_out_mock,
      verify_select_expectations
        IMPORTING
          is_mock TYPE ts_query_mock,
      verify_read_expectations
        IMPORTING
          is_mock TYPE ts_read_mock,
      verify_create_expectations
        IMPORTING
          is_mock TYPE ts_create_mock,
      verify_update_expectations
        IMPORTING
          is_mock TYPE ts_update_mock,
      verify_delete_expectations
        IMPORTING
          is_mock TYPE ts_delete_mock,
      get_products FOR TESTING RAISING cx_static_check,
      get_products_with_search FOR TESTING RAISING cx_static_check,
      get_products_with_filter FOR TESTING RAISING cx_static_check,
      get_products_with_sort_order FOR TESTING RAISING cx_static_check,
      select_products FOR TESTING RAISING cx_static_check,
      select_products_with_count FOR TESTING RAISING cx_static_check,
      select_products_with_search FOR TESTING RAISING cx_static_check,
      get_product FOR TESTING RAISING cx_static_check,
      get_invalid_product FOR TESTING RAISING cx_static_check,
      create_product FOR TESTING RAISING cx_static_check,
      create_invalid_product FOR TESTING RAISING cx_static_check,
      update_product FOR TESTING RAISING cx_static_check,
      update_invalid_product FOR TESTING RAISING cx_static_check,
      delete_product FOR TESTING RAISING cx_static_check,
      delete_invalid_product FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltc_products_entity IMPLEMENTATION.

  METHOD class_setup.
    mo_util = NEW zcl_rfes_util(  ).
  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD get_products_mock.
    DATA products_temp TYPE tt_products_temp.

    IF mt_products IS INITIAL.
      products_temp = VALUE #(
          ( id = '08c142fa-01b0-441d-b01d-eeaa3291f6f0' name = 'Bread' description = 'Whole grain bread' image_url = '/assets/bread.jpg' release_date = '1992-01-01T00:00:00Z' discontinued_date = ''
              price = '2.5' height = '5' width = '10' depth = '8' quantity = '20' unit_of_measure_id = 'EA' currency_id = 'USD' category_id = 'F' supplier_id = 'aead11fd-e35b-4f6f-a37a-e4a860aaaad7' dimension_unit_id = 'CM' )
          ( id = 'aa74747d-c297-4f0a-981a-8fb0ca92b756' name = 'Milk' description = 'Low fat milk' image_url = '/assets/milk.jpg' release_date = '1995-10-01T00:00:00Z' discontinued_date = ''
              price = '3.5' height = '5' width = '10' depth = '8' quantity = '15' unit_of_measure_id = 'EA' currency_id = 'USD' category_id = 'B' supplier_id = 'aead11fd-e35b-4f6f-a37a-e4a860aaaad7' dimension_unit_id = 'CM' )
          ( id = 'ea610da1-ea93-4258-85e1-099167d67bf9' name = 'Vint soda' description = 'Americana Variety - Mix of 6 flavors' image_url = '/assets/vint-soda.jpg' release_date = '2000-10-01T00:00:00Z' discontinued_date = ''
              price = '20.9' height = '5' width = '10' depth = '8' quantity = '8' unit_of_measure_id = 'EA' currency_id = 'USD' category_id = 'B' supplier_id = 'aead11fd-e35b-4f6f-a37a-e4a860aaaad7' dimension_unit_id = 'CM' )
          ( id = 'd97de1ec-7fd1-4c56-8e15-0246dc7a0cbf' name = 'Havina Cola' description = 'The Original Key Lime Cola' image_url = '/assets/havina-cola.jpg' release_date = '2005-10-01T00:00:00Z' discontinued_date = '2006-10-01T00:00:00Z'
              price = '19.9' height = '5' width = '10' depth = '8' quantity = '10' unit_of_measure_id = 'EA' currency_id = 'USD' category_id = 'B' supplier_id = 'aead11fd-e35b-4f6f-a37a-e4a860aaaad7' dimension_unit_id = 'CM' )
          ( id = '9e800613-7b96-4203-8817-f25fcc89dfbc' name = 'Fruit Punch' description = '"Mango flavor, 8.3 Ounce Cans (Pack of 24)"' image_url = '/assets/fruit-punch.png' release_date = '2003-01-05T00:00:00Z' discontinued_date = ''
              price = '22.99' height = '5' width = '10' depth = '8' quantity = '5' unit_of_measure_id = 'EA' currency_id = 'USD' category_id = 'B' supplier_id = 'aead11fd-e35b-4f6f-a37a-e4a860aaaad7' dimension_unit_id = 'CM' )
          ( id = 'fe613858-7385-4c1c-8f4e-b3439a5ec637' name = 'Cranberry Juice' description = '16-Ounce Plastic Bottles (Pack of 12)' image_url = '/assets/cranberry-juice.jpg' release_date = '2006-08-04T00:00:00Z' discontinued_date = ''
              price = '22.8' height = '5' width = '10' depth = '8' quantity = '12' unit_of_measure_id = 'EA' currency_id = 'USD' category_id = 'B' supplier_id = 'aead11fd-e35b-4f6f-a37a-e4a860aaaad7' dimension_unit_id = 'CM' )
          ( id = '06f86ef1-1525-4932-b1ce-d40661464c66' name = 'Pink Lemonade' description = '36 Ounce Cans (Pack of 3)' image_url = '/assets/pink-lemonade.jpg' release_date = '2006-11-05T00:00:00Z' discontinued_date = ''
              price = '18.8' height = '5' width = '10' depth = '8' quantity = '6' unit_of_measure_id = 'EA' currency_id = 'USD' category_id = 'B' supplier_id = 'aead11fd-e35b-4f6f-a37a-e4a860aaaad7' dimension_unit_id = 'CM' )
          ( id = '5ee16f77-171c-4f1e-b455-221a1530b242' name = 'DVD Player' description = '1080P Upconversion DVD Player' image_url = '/assets/dvd-player.jpg' release_date = '2006-11-15T00:00:00Z' discontinued_date = ''
              price = '35.88' height = '5' width = '10' depth = '8' quantity = '0' unit_of_measure_id = 'EA' currency_id = 'AUD' category_id = 'E' supplier_id = '6967edb4-cd83-4c8b-90ae-6894a71b398f' dimension_unit_id = 'CM' )
          ( id = '58a8c519-2aa6-4289-84c3-d79de5a67dd0' name = 'LCD HDTV' description = '42 inch 1080p LCD with Built-in Blu-ray Disc Player' image_url = '/assets/lcd-hdtv.jpg' release_date = '2008-05-08T00:00:00Z' discontinued_date = ''
              price = '1088.8' height = '5' width = '10' depth = '8' quantity = '0' unit_of_measure_id = 'EA' currency_id = 'AUD' category_id = 'E' supplier_id = '6967edb4-cd83-4c8b-90ae-6894a71b398f' dimension_unit_id = 'CM' )
          ( id = 'aa7d843f-c6c5-4bc9-846b-ddac07966f10' name = 'Lemonade' description = '"Classic, refreshing lemonade (Single bottle)"' image_url = '/assets/lemonade.jpg' release_date = '1970-01-01T00:00:00Z' discontinued_date = ''
              price = '1.01' height = '5' width = '10' depth = '8' quantity = '7' unit_of_measure_id = 'EA' currency_id = 'USD' category_id = 'B' supplier_id = '6967edb4-cd83-4c8b-90ae-6894a71b398f' dimension_unit_id = 'CM' )
          ( id = 'de411986-f74c-4082-83bc-2aa5c5a25aad' name = 'Coffee' description = 'Bulk size can of instant coffee' image_url = '/assets/coffee.jpg' release_date = '1982-12-31T00:00:00Z' discontinued_date = ''
              price = '6.99' height = '5' width = '10' depth = '8' quantity = '16' unit_of_measure_id = 'EA' currency_id = 'USD' category_id = 'B' supplier_id = '6967edb4-cd83-4c8b-90ae-6894a71b398f' dimension_unit_id = 'CM' )
      ).

      LOOP AT products_temp ASSIGNING FIELD-SYMBOL(<product>).
        <product>-id = mo_util->convert_to_abap_uuid( CONV #( <product>-id ) ).
        <product>-supplier_id = mo_util->convert_to_abap_uuid( CONV #( <product>-supplier_id ) ).
        <product>-description = mo_util->condense_string( CONV #( <product>-description ) ).
        <product>-release_date = mo_util->convert_to_abap_timestamp( CONV #( <product>-release_date ) ).
        <product>-discontinued_date = mo_util->convert_to_abap_timestamp( CONV #( <product>-discontinued_date ) ).
        <product>-created_by = <product>-modified_by = cl_abap_context_info=>get_user_technical_name(  ).
        <product>-created_at = <product>-modified_at = |{ cl_abap_context_info=>get_system_date(  ) }{ cl_abap_context_info=>get_system_time(  ) }|.
      ENDLOOP.

      mt_products = CORRESPONDING #( products_temp MAPPING imageurl = image_url ).
    ENDIF.

    RETURN mt_products.
  ENDMETHOD.

  METHOD configure_select.
    DATA products TYPE zcl_product_model_es=>tt_products.

    rs_mock-in-response ?= cl_abap_testdouble=>create( 'if_rap_query_response' ).
    rs_mock-in-request ?= cl_abap_testdouble=>create( 'if_rap_query_request' ).
    rs_mock-in-paging ?= cl_abap_testdouble=>create( 'if_rap_query_paging' ).
    rs_mock-in-filter ?= cl_abap_testdouble=>create( 'if_rap_query_filter' ).

    TRY.
        cl_abap_testdouble=>configure_call( rs_mock-in-paging )->returning( iv_top )->and_expect(  )->is_called_once(  ).
        rs_mock-in-paging->get_page_size( ).

        cl_abap_testdouble=>configure_call( rs_mock-in-paging )->returning( iv_skip )->and_expect(  )->is_called_once(  ).
        rs_mock-in-paging->get_offset( ).

        cl_abap_testdouble=>configure_call( rs_mock-in-filter )->returning( it_filters )->and_expect(  )->is_called_once(  ).
        rs_mock-in-filter->get_as_ranges( ).

        cl_abap_testdouble=>configure_call( rs_mock-in-request )->returning( rs_mock-in-filter )->and_expect(  )->is_called_once(  ).
        rs_mock-in-request->get_filter( ).

        cl_abap_testdouble=>configure_call( rs_mock-in-request )->returning( rs_mock-in-paging )->and_expect(  )->is_called_times( 2 ).
        rs_mock-in-request->get_paging( ).

        cl_abap_testdouble=>configure_call( rs_mock-in-request )->returning( it_sort_order )->and_expect(  )->is_called_once(  ).
        rs_mock-in-request->get_sort_elements( ).

        cl_abap_testdouble=>configure_call( rs_mock-in-request )->returning( iv_search_expression )->and_expect(  )->is_called_once(  ).
        rs_mock-in-request->get_search_expression( ).

        cl_abap_testdouble=>configure_call( rs_mock-in-request )->returning( is_count_requested )->and_expect(  )->is_called_times( COND #( WHEN io_exception IS NOT BOUND THEN 2 ELSE 1 ) ).
        rs_mock-in-request->is_total_numb_of_rec_requested( ).

        IF io_exception IS NOT BOUND.
          IF is_count_requested = abap_true.
            cl_abap_testdouble=>configure_call( rs_mock-in-response )->and_expect(  )->is_called_once(  ).
            rs_mock-in-response->set_total_number_of_records( iv_top ).
          ENDIF.

          cl_abap_testdouble=>configure_call( rs_mock-in-response )->ignore_all_parameters(  )->and_expect(  )->is_called_once(  ).
          rs_mock-in-response->set_data( it_data ).
        ENDIF.

        rs_mock-out = configure_query(
          iv_entity_set_name = iv_entity_set_name
          iv_search          = iv_search_expression
          iv_filter_count    = lines( it_filters )
          it_sort_order      = it_sort_order
          it_data            = it_data
          is_count_requested = is_count_requested
          io_exception       = io_exception
        ).

      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.
  ENDMETHOD.

  METHOD configure_query.
    DATA client_proxy_mock TYPE REF TO /iwbep/if_cp_client_proxy.
    DATA resource_mock TYPE REF TO /iwbep/if_cp_resource_list.
    DATA dummy_filters TYPE if_rap_query_filter=>tt_name_range_pairs.

    rs_mock-response ?= cl_abap_testdouble=>create( '/iwbep/if_cp_response_read_lst' ).
    rs_mock-request ?= cl_abap_testdouble=>create( '/iwbep/if_cp_request_read_list' ).
    IF iv_filter_count IS NOT INITIAL.
      rs_mock-filter_factory ?= cl_abap_testdouble=>create( '/iwbep/if_cp_filter_factory' ).
      rs_mock-filter_node ?= cl_abap_testdouble=>create( '/iwbep/if_cp_filter_node' ).
    ENDIF.
    resource_mock ?= cl_abap_testdouble=>create( '/iwbep/if_cp_resource_list' ).
    client_proxy_mock ?= cl_abap_testdouble=>create( '/iwbep/if_cp_client_proxy' ).
    mo_cut = NEW zcl_product_model_es( client_proxy_mock ).

    TRY.
        cl_abap_testdouble=>configure_call( client_proxy_mock )->returning( resource_mock ).
        client_proxy_mock->create_resource_for_entity_set( CONV #( iv_entity_set_name ) ).

        cl_abap_testdouble=>configure_call( resource_mock )->returning( rs_mock-request ).
        resource_mock->create_request_for_read( ).

        IF iv_filter_count IS NOT INITIAL.
          cl_abap_testdouble=>configure_call( rs_mock-request )->returning( rs_mock-filter_factory )->and_expect(  )->is_called_once(  ).
          rs_mock-request->create_filter_factory( ).

          APPEND INITIAL LINE TO dummy_filters ASSIGNING FIELD-SYMBOL(<filter>).
          cl_abap_testdouble=>configure_call( rs_mock-filter_factory )->returning( rs_mock-filter_node )->ignore_all_parameters(  )->and_expect(  )->is_called_times( iv_filter_count ).
          rs_mock-filter_factory->create_by_range( iv_property_path = <filter>-name it_range = <filter>-range  ).

          IF iv_filter_count > 1.
            cl_abap_testdouble=>configure_call( rs_mock-filter_node )->returning( rs_mock-filter_node )->and_expect(  )->is_called_times( iv_filter_count - 1 ).
            rs_mock-filter_node->and( rs_mock-filter_node ).
          ENDIF.
        ENDIF.

        IF it_sort_order IS NOT INITIAL.
          cl_abap_testdouble=>configure_call( rs_mock-request )->returning( rs_mock-request )->and_expect(  )->is_called_once(  ).
          rs_mock-request->set_orderby( CORRESPONDING #( it_sort_order MAPPING property_path = element_name ) ).
        ENDIF.

        IF iv_search IS NOT INITIAL.
          cl_abap_testdouble=>configure_call( rs_mock-request )->returning( rs_mock-request )->and_expect(  )->is_called_once(  ).
          rs_mock-request->set_search( iv_search ).
        ENDIF.

        IF io_exception IS BOUND.
          cl_abap_testdouble=>configure_call( rs_mock-request )->raise_exception( io_exception )->and_expect(  )->is_called_once(  ).
        ELSE.
          cl_abap_testdouble=>configure_call( rs_mock-request )->returning( rs_mock-response )->and_expect(  )->is_called_once(  ).
        ENDIF.
        rs_mock-request->execute( ).

        IF it_data IS NOT INITIAL AND io_exception IS NOT BOUND.
          cl_abap_testdouble=>configure_call( rs_mock-response )->set_parameter( name = 'et_business_data' value = it_data )->and_expect(  )->is_called_once(  ).
          rs_mock-response->get_business_data(  ).

          IF is_count_requested = abap_true.
            cl_abap_testdouble=>configure_call( rs_mock-response )->returning( lines( it_data ) )->and_expect(  )->is_called_once(  ).
            rs_mock-response->get_count(  ).
          ENDIF.
        ENDIF.

      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.
  ENDMETHOD.

  METHOD configure_read.
    DATA client_proxy_mock TYPE REF TO /iwbep/if_cp_client_proxy.

    rs_mock-response ?= cl_abap_testdouble=>create( '/iwbep/if_cp_response_read' ).
    rs_mock-request ?= cl_abap_testdouble=>create( '/iwbep/if_cp_request_read' ).
    rs_mock-resource ?= cl_abap_testdouble=>create( '/iwbep/if_cp_resource_list' ).
    rs_mock-entity ?= cl_abap_testdouble=>create( '/iwbep/if_cp_resource_entity' ).
    client_proxy_mock ?= cl_abap_testdouble=>create( '/iwbep/if_cp_client_proxy' ).
    mo_cut = NEW zcl_product_model_es( client_proxy_mock ).

    TRY.
        cl_abap_testdouble=>configure_call( client_proxy_mock )->returning( rs_mock-resource ).
        client_proxy_mock->create_resource_for_entity_set( CONV #( iv_entity_set_name ) ).

        cl_abap_testdouble=>configure_call( rs_mock-resource )->returning( rs_mock-entity )->and_expect(  )->is_called_once(  ).
        rs_mock-resource->navigate_with_key( is_key ).

        cl_abap_testdouble=>configure_call( rs_mock-entity )->returning( rs_mock-request )->and_expect(  )->is_called_once(  ).
        rs_mock-entity->create_request_for_read(  ).

        IF io_exception IS BOUND.
          cl_abap_testdouble=>configure_call( rs_mock-request )->raise_exception( io_exception )->and_expect(  )->is_called_once(  ).
        ELSE.
          cl_abap_testdouble=>configure_call( rs_mock-request )->returning( rs_mock-response )->and_expect(  )->is_called_once(  ).
        ENDIF.
        rs_mock-request->execute(  ).

        IF io_exception IS NOT BOUND.
          cl_abap_testdouble=>configure_call( rs_mock-response )->set_parameter( name = 'es_business_data' value = is_data )->and_expect(  )->is_called_once(  ).
          rs_mock-response->get_business_data(  ).

          cl_abap_testdouble=>configure_call( rs_mock-response )->returning( 'dummy-etag' )->and_expect(  )->is_called_once(  ).
          rs_mock-response->get_etag(  ).
        ENDIF.

      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.
  ENDMETHOD.

  METHOD configure_create.
    DATA client_proxy_mock TYPE REF TO /iwbep/if_cp_client_proxy.

    rs_mock-response ?= cl_abap_testdouble=>create( '/iwbep/if_cp_response_create' ).
    rs_mock-request ?= cl_abap_testdouble=>create( '/iwbep/if_cp_request_create' ).
    rs_mock-resource ?= cl_abap_testdouble=>create( '/iwbep/if_cp_resource_list' ).
    client_proxy_mock ?= cl_abap_testdouble=>create( '/iwbep/if_cp_client_proxy' ).
    mo_cut = NEW zcl_product_model_es( client_proxy_mock ).

    TRY.
        cl_abap_testdouble=>configure_call( client_proxy_mock )->returning( rs_mock-resource ).
        client_proxy_mock->create_resource_for_entity_set( CONV #( iv_entity_set_name ) ).

        cl_abap_testdouble=>configure_call( rs_mock-resource )->returning( rs_mock-request )->and_expect(  )->is_called_once(  ).
        rs_mock-resource->create_request_for_create(  ).

        cl_abap_testdouble=>configure_call( rs_mock-request )->returning( rs_mock-request )->and_expect(  )->is_called_once(  ).
        rs_mock-request->set_business_data( is_data ).

        IF io_exception IS BOUND.
          cl_abap_testdouble=>configure_call( rs_mock-request )->raise_exception( io_exception )->and_expect(  )->is_called_once(  ).
        ELSE.
          cl_abap_testdouble=>configure_call( rs_mock-request )->returning( rs_mock-response )->and_expect(  )->is_called_once(  ).
        ENDIF.
        rs_mock-request->execute(  ).

        IF io_exception IS NOT BOUND.
          cl_abap_testdouble=>configure_call( rs_mock-response )->set_parameter( name = 'es_business_data' value = is_data )->and_expect(  )->is_called_once(  ).
          rs_mock-response->get_business_data(  ).
        ENDIF.

      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.
  ENDMETHOD.

  METHOD configure_update.
    DATA client_proxy_mock TYPE REF TO /iwbep/if_cp_client_proxy.

    rs_mock-response ?= cl_abap_testdouble=>create( '/iwbep/if_cp_response_update' ).
    rs_mock-request ?= cl_abap_testdouble=>create( '/iwbep/if_cp_request_update' ).
    rs_mock-resource ?= cl_abap_testdouble=>create( '/iwbep/if_cp_resource_list' ).
    rs_mock-entity ?= cl_abap_testdouble=>create( '/iwbep/if_cp_resource_entity' ).
    client_proxy_mock ?= cl_abap_testdouble=>create( '/iwbep/if_cp_client_proxy' ).
    mo_cut = NEW zcl_product_model_es( client_proxy_mock ).

    TRY.
        cl_abap_testdouble=>configure_call( client_proxy_mock )->returning( rs_mock-resource ).
        client_proxy_mock->create_resource_for_entity_set( CONV #( iv_entity_set_name ) ).

        cl_abap_testdouble=>configure_call( rs_mock-resource )->returning( rs_mock-entity )->and_expect(  )->is_called_once(  ).
        rs_mock-resource->navigate_with_key( is_key ).

        cl_abap_testdouble=>configure_call( rs_mock-entity )->returning( rs_mock-request )->and_expect(  )->is_called_once(  ).
        rs_mock-entity->create_request_for_update( /iwbep/if_cp_request_update=>gcs_update_semantic-patch ).

        cl_abap_testdouble=>configure_call( rs_mock-request )->returning( rs_mock-request )->and_expect(  )->is_called_once(  ).
        rs_mock-request->set_if_match( iv_etag ).

        cl_abap_testdouble=>configure_call( rs_mock-request )->returning( rs_mock-request )->and_expect(  )->is_called_once(  ).
        rs_mock-request->request_no_business_data(  ).

        cl_abap_testdouble=>configure_call( rs_mock-request )->returning( rs_mock-request )->and_expect(  )->is_called_once(  ).
        rs_mock-request->set_business_data( is_business_data = is_data it_provided_property = it_provided_properties ).

        IF io_exception IS BOUND.
          cl_abap_testdouble=>configure_call( rs_mock-request )->raise_exception( io_exception )->and_expect(  )->is_called_once(  ).
        ELSE.
          cl_abap_testdouble=>configure_call( rs_mock-request )->returning( rs_mock-response )->and_expect(  )->is_called_once(  ).
        ENDIF.
        rs_mock-request->execute(  ).

        IF io_exception IS NOT BOUND.
          cl_abap_testdouble=>configure_call( rs_mock-response )->returning( 'dummy-etag' )->and_expect(  )->is_called_once(  ).
          rs_mock-response->get_etag(  ).
        ENDIF.

      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.
  ENDMETHOD.

  METHOD configure_delete.
    DATA client_proxy_mock TYPE REF TO /iwbep/if_cp_client_proxy.

    rs_mock-request ?= cl_abap_testdouble=>create( '/iwbep/if_cp_request_delete' ).
    rs_mock-resource ?= cl_abap_testdouble=>create( '/iwbep/if_cp_resource_list' ).
    rs_mock-entity ?= cl_abap_testdouble=>create( '/iwbep/if_cp_resource_entity' ).
    client_proxy_mock ?= cl_abap_testdouble=>create( '/iwbep/if_cp_client_proxy' ).
    mo_cut = NEW zcl_product_model_es( client_proxy_mock ).

    TRY.
        cl_abap_testdouble=>configure_call( client_proxy_mock )->returning( rs_mock-resource ).
        client_proxy_mock->create_resource_for_entity_set( CONV #( iv_entity_set_name ) ).

        cl_abap_testdouble=>configure_call( rs_mock-resource )->returning( rs_mock-entity )->and_expect(  )->is_called_once(  ).
        rs_mock-resource->navigate_with_key( is_key ).

        cl_abap_testdouble=>configure_call( rs_mock-entity )->returning( rs_mock-request )->and_expect(  )->is_called_once(  ).
        rs_mock-entity->create_request_for_delete(  ).

        IF io_exception IS BOUND.
          cl_abap_testdouble=>configure_call( rs_mock-request )->raise_exception( io_exception )->and_expect(  )->is_called_once(  ).
        ELSE.
          cl_abap_testdouble=>configure_call( rs_mock-request )->and_expect(  )->is_called_once(  ).
        ENDIF.
        rs_mock-request->execute(  ).

      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.
  ENDMETHOD.

  METHOD verify_query_expectations.
    cl_abap_testdouble=>verify_expectations( is_mock-request ).

    IF is_mock-response IS BOUND.
      cl_abap_testdouble=>verify_expectations( is_mock-response ).
    ENDIF.

    IF is_mock-filter_factory IS BOUND.
      cl_abap_testdouble=>verify_expectations( is_mock-filter_factory ).
      cl_abap_testdouble=>verify_expectations( is_mock-filter_node ).
    ENDIF.
  ENDMETHOD.

  METHOD verify_select_expectations.
    verify_query_expectations( is_mock-out ).
    cl_abap_testdouble=>verify_expectations( is_mock-in-request ).
    cl_abap_testdouble=>verify_expectations( is_mock-in-response ).
    cl_abap_testdouble=>verify_expectations( is_mock-in-paging ).
    cl_abap_testdouble=>verify_expectations( is_mock-in-filter ).
  ENDMETHOD.

  METHOD verify_read_expectations.
    cl_abap_testdouble=>verify_expectations( is_mock-request ).
    cl_abap_testdouble=>verify_expectations( is_mock-response ).
    cl_abap_testdouble=>verify_expectations( is_mock-resource ).
    cl_abap_testdouble=>verify_expectations( is_mock-entity ).
  ENDMETHOD.

  METHOD verify_create_expectations.
    cl_abap_testdouble=>verify_expectations( is_mock-request ).
    cl_abap_testdouble=>verify_expectations( is_mock-response ).
    cl_abap_testdouble=>verify_expectations( is_mock-resource ).
  ENDMETHOD.

  METHOD verify_update_expectations.
    cl_abap_testdouble=>verify_expectations( is_mock-request ).
    cl_abap_testdouble=>verify_expectations( is_mock-response ).
    cl_abap_testdouble=>verify_expectations( is_mock-resource ).
    cl_abap_testdouble=>verify_expectations( is_mock-entity ).
  ENDMETHOD.

  METHOD verify_delete_expectations.
    cl_abap_testdouble=>verify_expectations( is_mock-request ).
    cl_abap_testdouble=>verify_expectations( is_mock-resource ).
    cl_abap_testdouble=>verify_expectations( is_mock-entity ).
  ENDMETHOD.

  METHOD get_products.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DELETE products_mock FROM 6 TO lines( products_mock ).

    "configure mock
    DATA(mock) = configure_query(
      iv_entity_set_name = 'PRODUCTS'
      it_data            = products_mock
      is_count_requested = abap_true
    ).

    TRY.
        "start the test
        mo_cut->get_products(
          EXPORTING
            iv_top             = 5
            iv_skip            = 0
            is_count_requested = abap_true
          IMPORTING
            et_products        = DATA(products)
            ev_count           = DATA(count)
        ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    verify_query_expectations( mock ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'should return correct total record count'
      exp = 5
      act = count
    ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'should return correct number of records'
      exp = 5
      act = lines( products )
    ).
  ENDMETHOD.

  METHOD get_products_with_search.
    "configure mock
    DATA(mock) = configure_query(
      iv_entity_set_name = 'PRODUCTS'
      iv_search          = 'Lemon'
      io_exception       = NEW /iwbep/cx_gateway( )
    ).

    TRY.
        "start the test
        mo_cut->get_products(
          EXPORTING
            iv_top             = 5
            iv_skip            = 0
            is_count_requested = abap_true
            iv_search          = 'Lemon'
          IMPORTING
            et_products        = DATA(products)
            ev_count           = DATA(count)
        ).
        cl_abap_unit_assert=>fail( 'should return exception, but didn''t' ).
      CATCH cx_root INTO DATA(exception).
        "do assertions
        verify_query_expectations( mock ).
        cl_abap_unit_assert=>assert_bound(
          msg = 'should return exception'
          act = exception
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_products_with_filter.
    DATA filters TYPE if_rap_query_filter=>tt_name_range_pairs.
    APPEND INITIAL LINE TO filters ASSIGNING FIELD-SYMBOL(<filter>).
    <filter>-name = 'CATEGORY_ID'.
    <filter>-range = VALUE #( ( sign = 'I' option = 'EQ' low = 'B' ) ).
    APPEND INITIAL LINE TO filters ASSIGNING <filter>.
    <filter>-name = 'CURRENCY_ID'.
    <filter>-range = VALUE #( ( sign = 'I' option = 'EQ' low = 'USD' ) ).

    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DELETE products_mock WHERE category_id NE 'B' OR currency_id NE 'USD'.
    DELETE products_mock FROM 6 TO lines( products_mock ).

    "configure mock
    DATA(mock) = configure_query(
      iv_entity_set_name = 'PRODUCTS'
      iv_filter_count    = lines( filters )
      it_data            = products_mock
      is_count_requested = abap_true
    ).

    TRY.
        "start the test
        mo_cut->get_products(
          EXPORTING
            iv_top             = 5
            iv_skip            = 0
            is_count_requested = abap_true
            it_filters         = filters
          IMPORTING
            et_products        = DATA(products)
            ev_count           = DATA(count)
        ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    verify_query_expectations( mock ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'should return correct total record count'
      exp = 5
      act = count
    ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'should return correct number of records'
      exp = 5
      act = lines( products )
    ).
  ENDMETHOD.

  METHOD get_products_with_sort_order.
    DATA sort_order TYPE if_rap_query_request=>tt_sort_elements.
    APPEND INITIAL LINE TO sort_order ASSIGNING FIELD-SYMBOL(<sort>).
    <sort>-element_name = 'NAME'.
    <sort>-descending = abap_false.

    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    SORT products_mock BY name.
    DELETE products_mock FROM 6 TO lines( products_mock ).

    "configure mock
    DATA(mock) = configure_query(
      iv_entity_set_name = 'PRODUCTS'
      it_sort_order      = sort_order
      it_data            = products_mock
      is_count_requested = abap_true
    ).

    TRY.
        "start the test
        mo_cut->get_products(
          EXPORTING
            iv_top             = 5
            iv_skip            = 0
            is_count_requested = abap_true
            it_sort_order      = sort_order
          IMPORTING
            et_products        = DATA(products)
            ev_count           = DATA(count)
        ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    verify_query_expectations( mock ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'should return correct first record from sorted list'
      exp = 'Bread'
      act = products[ 1 ]-name
    ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'should return correct total record count'
      exp = 5
      act = count
    ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'should return correct number of records'
      exp = 5
      act = lines( products )
    ).
  ENDMETHOD.

  METHOD select_products.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DELETE products_mock FROM 6 TO lines( products_mock ).

    "configure mock
    DATA(mock) = configure_select(
      iv_entity_set_name = 'PRODUCTS'
      it_data            = products_mock
    ).

    TRY.
        "start the test
        mo_cut->if_rap_query_provider~select(
          io_request  = mock-in-request
          io_response = mock-in-response
        ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    verify_select_expectations( mock ).
  ENDMETHOD.

  METHOD select_products_with_count.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DELETE products_mock FROM 6 TO lines( products_mock ).

    "configure mock
    DATA(mock) = configure_select(
      iv_entity_set_name = 'PRODUCTS'
      it_data            = products_mock
      is_count_requested = abap_true
    ).

    TRY.
        "start the test
        mo_cut->if_rap_query_provider~select(
          io_request  = mock-in-request
          io_response = mock-in-response
        ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    verify_select_expectations( mock ).
  ENDMETHOD.

  METHOD select_products_with_search.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DELETE products_mock FROM 6 TO lines( products_mock ).

    "configure mock
    DATA(mock) = configure_select(
      iv_entity_set_name   = 'PRODUCTS'
      it_data              = products_mock
      iv_search_expression = 'Lemon'
      is_count_requested   = abap_true
      io_exception         = NEW /iwbep/cx_gateway( )
    ).

    TRY.
        "start the test
        mo_cut->if_rap_query_provider~select(
          io_request  = mock-in-request
          io_response = mock-in-response
        ).
        cl_abap_unit_assert=>fail( 'should return exception, but didn''t' ).
      CATCH cx_root INTO DATA(exception).
        "do assertions
        verify_select_expectations( mock ).
        cl_abap_unit_assert=>assert_bound(
          msg = 'should return exception'
          act = exception
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_product.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DATA(product_mock) = products_mock[ 1 ].

    "configure mock
    DATA(mock) = configure_read(
      iv_entity_set_name = 'PRODUCTS'
      is_key             = VALUE zcl_product_model_es=>ts_product( id = product_mock-id )
      is_data            = product_mock
    ).

    TRY.
        "start the test
        mo_cut->get_product(
          EXPORTING
            iv_key     = product_mock-id
          IMPORTING
            es_product = DATA(product)
            ev_etag    = DATA(etag)
        ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    verify_read_expectations( mock ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'should return the requested record'
      exp = product_mock
      act = product
    ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'should return the etag'
      exp = 'dummy-etag'
      act = etag
    ).
  ENDMETHOD.

  METHOD get_invalid_product.
    "prepare mock data
    DATA product_mock TYPE zcl_product_model_es=>ts_product.
    product_mock-id = mo_util->convert_to_abap_uuid( '16f86ef1-1525-4932-b1ce-d40661464c66' ).

    "configure mock
    DATA(mock) = configure_read(
      iv_entity_set_name = 'PRODUCTS'
      is_key             = product_mock
      is_data            = product_mock
      io_exception       = NEW /iwbep/cx_cp_remote( )
    ).

    TRY.
        "start the test
        mo_cut->get_product(
          EXPORTING
            iv_key     = product_mock-id
          IMPORTING
            es_product = DATA(product)
            ev_etag    = DATA(etag)
        ).
        cl_abap_unit_assert=>fail( 'should return exception, but didn''t' ).
      CATCH cx_root INTO DATA(exception).
        "do assertions
        verify_read_expectations( mock ).
        cl_abap_unit_assert=>assert_bound(
          msg = 'should return exception'
          act = exception
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD create_product.
    "prepare mock data
    DATA product_mock TYPE zcl_product_model_es=>ts_product.
    product_mock = VALUE #(
      name = 'Pearl Mik Tea'
      description = 'Milk tea with chewy pearls'
      category_id = 'B'
      unitofmeasure_id = 'EA'
      currency_id = 'USD'
    ).

    "configure mock
    DATA(mock) = configure_create(
      iv_entity_set_name = 'PRODUCTS'
      is_data            = product_mock
    ).

    TRY.
        "start the test
        mo_cut->create_product(
          EXPORTING
            is_product = product_mock
          IMPORTING
            es_product = DATA(product)
        ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    verify_create_expectations( mock ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'should return the requested record'
      exp = product_mock
      act = product
    ).
  ENDMETHOD.

  METHOD create_invalid_product.
    "prepare mock data
    DATA product_mock TYPE zcl_product_model_es=>ts_product.
    product_mock = VALUE #(
      name = 'Pearl Mik Tea'
      description = 'Milk tea with chewy pearls'
      category_id = 'B'
      unitofmeasure_id = 'EA'
      currency_id = 'USD'
    ).

    "configure mock
    DATA(mock) = configure_create(
      iv_entity_set_name = 'PRODUCTS'
      is_data            = product_mock
      io_exception       = NEW /iwbep/cx_cp_remote( )
    ).

    TRY.
        "start the test
        mo_cut->create_product(
          EXPORTING
            is_product = product_mock
          IMPORTING
            es_product = DATA(product)
        ).
        cl_abap_unit_assert=>fail( 'should return exception, but didn''t' ).
      CATCH cx_root INTO DATA(exception).
        "do assertions
        verify_create_expectations( mock ).
        cl_abap_unit_assert=>assert_bound(
          msg = 'should return exception'
          act = exception
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD update_product.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DATA(product_mock) = products_mock[ 1 ].

    "configure mock
    DATA(mock) = configure_update(
      iv_entity_set_name     = 'PRODUCTS'
      is_key                 = VALUE zcl_product_model_es=>ts_product( id = product_mock-id )
      iv_etag                = 'dummy-etag'
      is_data                = product_mock
      it_provided_properties = VALUE #( ( CONV #( 'NAME' ) ) )
    ).

    TRY.
        "start the test
        mo_cut->update_product(
          EXPORTING
            is_product = product_mock
            iv_etag    = 'dummy-etag'
          IMPORTING
            ev_etag    = DATA(etag)
        ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    verify_update_expectations( mock ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'should return the etag'
      exp = 'dummy-etag'
      act = etag
    ).
  ENDMETHOD.

  METHOD update_invalid_product.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DATA(product_mock) = products_mock[ 1 ].

    "configure mock
    DATA(mock) = configure_update(
      iv_entity_set_name     = 'PRODUCTS'
      is_key                 = VALUE zcl_product_model_es=>ts_product( id = product_mock-id )
      iv_etag                = 'dummy-etag'
      is_data                = product_mock
      it_provided_properties = VALUE #( ( CONV #( 'NAME' ) ) )
      io_exception           = NEW /iwbep/cx_cp_remote( )
    ).

    TRY.
        "start the test
        mo_cut->update_product(
          EXPORTING
            is_product = product_mock
            iv_etag    = 'dummy-etag'
          IMPORTING
            ev_etag    = DATA(etag)
        ).
        cl_abap_unit_assert=>fail( 'should return exception, but didn''t' ).
      CATCH cx_root INTO DATA(exception).
        "do assertions
        verify_update_expectations( mock ).
        cl_abap_unit_assert=>assert_bound(
          msg = 'should return exception'
          act = exception
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD delete_product.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DATA(product_mock) = products_mock[ 1 ].

    "configure mock
    DATA(mock) = configure_delete(
      iv_entity_set_name = 'PRODUCTS'
      is_key             = VALUE zcl_product_model_es=>ts_product( id = product_mock-id )
    ).

    TRY.
        "start the test
        mo_cut->delete_product( product_mock-id ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    verify_delete_expectations( mock ).
  ENDMETHOD.

  METHOD delete_invalid_product.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DATA(product_mock) = products_mock[ 1 ].

    "configure mock
    DATA(mock) = configure_delete(
      iv_entity_set_name = 'PRODUCTS'
      is_key             = VALUE zcl_product_model_es=>ts_product( id = product_mock-id )
      io_exception       = NEW /iwbep/cx_cp_remote( )
    ).

    TRY.
        "start the test
        mo_cut->delete_product( product_mock-id ).
        cl_abap_unit_assert=>fail( 'should return exception, but didn''t' ).
      CATCH cx_root INTO DATA(exception).
        "do assertions
        verify_delete_expectations( mock ).
        cl_abap_unit_assert=>assert_bound(
          msg = 'should return exception'
          act = exception
        ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
