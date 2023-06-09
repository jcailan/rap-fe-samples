CLASS zcl_product_model_es DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.

    TYPES ts_product TYPE za_products_es.
    TYPES tt_products TYPE TABLE OF ts_product WITH NON-UNIQUE KEY id.
    TYPES tr_product_id TYPE RANGE OF ts_product-id.

    METHODS constructor
      IMPORTING
        io_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy OPTIONAL.

    METHODS get_product
      IMPORTING
        iv_key     TYPE ts_product-id
      EXPORTING
        es_product TYPE ts_product
        ev_etag    TYPE string
      RAISING
        cx_web_http_client_error
        /iwbep/cx_gateway
        cx_http_dest_provider_error.

    METHODS get_products
      IMPORTING
        iv_search          TYPE string OPTIONAL
        it_filters         TYPE if_rap_query_filter=>tt_name_range_pairs OPTIONAL
        it_sort_order      TYPE if_rap_query_request=>tt_sort_elements OPTIONAL
        iv_top             TYPE i OPTIONAL
        iv_skip            TYPE i OPTIONAL
        is_count_requested TYPE abap_bool OPTIONAL
      EXPORTING
        et_products        TYPE tt_products
        ev_count           TYPE int8
      RAISING
        /iwbep/cx_cp_remote
        /iwbep/cx_gateway
        cx_web_http_client_error
        cx_http_dest_provider_error.

    METHODS create_product
      IMPORTING
        is_product TYPE ts_product
      EXPORTING
        es_product TYPE ts_product
      RAISING
        /iwbep/cx_cp_remote
        /iwbep/cx_gateway
        cx_web_http_client_error
        cx_http_dest_provider_error.

    METHODS update_product
      IMPORTING
        is_product TYPE ts_product
        iv_etag    TYPE string OPTIONAL
      EXPORTING
        ev_etag    TYPE string
      RAISING
        cx_web_http_client_error
        /iwbep/cx_gateway
        cx_http_dest_provider_error.

    METHODS delete_product
      IMPORTING
        iv_key TYPE ts_product-id
      RAISING
        cx_web_http_client_error
        /iwbep/cx_gateway
        cx_http_dest_provider_error.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy.

    METHODS get_proxy_client
      RETURNING
        VALUE(ro_proxy_client) TYPE REF TO /iwbep/if_cp_client_proxy
      RAISING
        cx_web_http_client_error
        /iwbep/cx_gateway
        cx_http_dest_provider_error.

ENDCLASS.



CLASS zcl_product_model_es IMPLEMENTATION.

  METHOD constructor.
    me->mo_client_proxy = io_client_proxy.
  ENDMETHOD.

  METHOD if_rap_query_provider~select.
    DATA(top) = io_request->get_paging( )->get_page_size( ).
    DATA(skip) = io_request->get_paging( )->get_offset( ).

    TRY.
        get_products(
          EXPORTING
            iv_search          = io_request->get_search_expression( )
            it_filters         = io_request->get_filter( )->get_as_ranges( )
            it_sort_order      = io_request->get_sort_elements( )
            iv_top             = CONV i( top )
            iv_skip            = CONV i( skip )
            is_count_requested = io_request->is_total_numb_of_rec_requested( )
          IMPORTING
            et_products        = DATA(products)
            ev_count           = DATA(count)
        ).

        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( count ).
        ELSE.
          io_response->set_total_number_of_records( lines( products ) ).
        ENDIF.
        io_response->set_data( products ).

      CATCH cx_root INTO DATA(exception).
        RAISE EXCEPTION NEW zcx_rap_query_provider( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_proxy_client.
    IF mo_client_proxy IS NOT BOUND.
      DATA(base_url) = CONV string( 'https://capfes-srv-sbx.cfapps.us10.hana.ondemand.com/' ).
      DATA(destination) = cl_http_destination_provider=>create_by_url( i_url = base_url ).
      DATA(http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = destination ).

      mo_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
        EXPORTING
          iv_service_definition_name = 'ZSC_PRODUCT_API_ES'
          io_http_client             = http_client
          iv_relative_service_root   = '/v2/product-api/' ).
    ENDIF.

    RETURN mo_client_proxy.
  ENDMETHOD.

  METHOD get_product.
    DATA request       TYPE REF TO /iwbep/if_cp_request_read.
    DATA response      TYPE REF TO /iwbep/if_cp_response_read.

    DATA(proxy_client) = get_proxy_client( ).
    DATA(key) = VALUE ts_product( id = iv_key ).
    DATA(entity) = proxy_client->create_resource_for_entity_set( 'PRODUCTS' )->navigate_with_key( key ).

    request = entity->create_request_for_read( ).
    response = request->execute( ).
    response->get_business_data( IMPORTING es_business_data = es_product ).
    ev_etag = response->get_etag( ).
  ENDMETHOD.

  METHOD get_products.
    DATA filter_factory TYPE REF TO /iwbep/if_cp_filter_factory.
    DATA filter_node TYPE REF TO /iwbep/if_cp_filter_node.
    DATA root_filter_node TYPE REF TO /iwbep/if_cp_filter_node.
    DATA sort_order TYPE /iwbep/if_cp_runtime_types=>ty_t_sort_order.
    DATA request  TYPE REF TO /iwbep/if_cp_request_read_list.
    DATA response TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA(proxy_client) = get_proxy_client( ).
    request = proxy_client->create_resource_for_entity_set( 'PRODUCTS' )->create_request_for_read( ).
    filter_factory = request->create_filter_factory( ).

    LOOP AT it_filters INTO DATA(filter).
      filter_node = filter_factory->create_by_range( iv_property_path = filter-name
                                                     it_range         = filter-range ).
      IF root_filter_node IS INITIAL.
        root_filter_node = filter_node.
      ELSE.
        root_filter_node = root_filter_node->and( filter_node ).
      ENDIF.
    ENDLOOP.

    IF it_sort_order IS NOT INITIAL.
      sort_order = CORRESPONDING #( it_sort_order MAPPING property_path = element_name ).
      request->set_orderby( sort_order ).
    ENDIF.

    IF root_filter_node IS NOT INITIAL.
      request->set_filter( root_filter_node ).
    ENDIF.

    IF iv_search IS NOT INITIAL.
      request->set_search( iv_search ).
    ENDIF.

    IF iv_top > 0 .
      request->set_top( iv_top ).
    ENDIF.

    request->set_skip( iv_skip ).

    IF is_count_requested = abap_true.
      request->request_count( ).
    ENDIF.

    response = request->execute( ).
    response->get_business_data( IMPORTING et_business_data = et_products ).

    IF is_count_requested = abap_true.
      ev_count = response->get_count(  ).
    ENDIF.

    LOOP AT et_products ASSIGNING FIELD-SYMBOL(<product>).
      IF <product>-imageurl IS NOT INITIAL.
        <product>-imageurl = |https://raw.githubusercontent.com/jcailan/cap-fe-samples/master{ <product>-imageurl }|.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD create_product.
    DATA request  TYPE REF TO /iwbep/if_cp_request_create.
    DATA response TYPE REF TO /iwbep/if_cp_response_create.

    DATA(proxy_client) = get_proxy_client( ).
    request = proxy_client->create_resource_for_entity_set( 'PRODUCTS' )->create_request_for_create( ).
    request->set_business_data( is_product ).

    response = request->execute( ).
    response->get_business_data( IMPORTING es_business_data = es_product ).
  ENDMETHOD.

  METHOD update_product.
    DATA request  TYPE REF TO /iwbep/if_cp_request_update.
    DATA response TYPE REF TO /iwbep/if_cp_response_update.
    DATA provided_properties TYPE /iwbep/if_cp_runtime_types=>ty_t_property_path.

    DATA(proxy_client) = get_proxy_client( ).
    DATA(key) = VALUE ts_product( id  = is_product-id ).
    DATA(entity) = proxy_client->create_resource_for_entity_set( 'PRODUCTS' )->navigate_with_key( key ).

    request = entity->create_request_for_update( /iwbep/if_cp_request_update=>gcs_update_semantic-patch ).
    request->set_if_match( iv_etag )->request_no_business_data( ).

    APPEND INITIAL LINE TO provided_properties ASSIGNING FIELD-SYMBOL(<property>).
    <property> = 'NAME'.

    request->set_business_data(
      is_business_data     = is_product
      it_provided_property = provided_properties
    ).

    response = request->execute( ).
    ev_etag = response->get_etag( ).
  ENDMETHOD.

  METHOD delete_product.
    DATA request  TYPE REF TO /iwbep/if_cp_request_delete.

    DATA(proxy_client) = get_proxy_client( ).
    DATA(key) = VALUE ts_product( id = iv_key ).
    DATA(resource) = proxy_client->create_resource_for_entity_set( 'PRODUCTS' )->navigate_with_key( key ).

    request = resource->create_request_for_delete( ).
    request->execute( ).
  ENDMETHOD.

ENDCLASS.
