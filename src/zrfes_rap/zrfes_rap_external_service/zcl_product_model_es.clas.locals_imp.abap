*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_client_proxy_helper DEFINITION FINAL FOR TESTING
  CREATE PUBLIC.

  PUBLIC SECTION.

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

    DATA mo_cut TYPE REF TO zcl_product_model_es.

    METHODS:
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
          is_mock TYPE ts_delete_mock.

ENDCLASS.

CLASS lcl_client_proxy_helper IMPLEMENTATION.

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

ENDCLASS.
