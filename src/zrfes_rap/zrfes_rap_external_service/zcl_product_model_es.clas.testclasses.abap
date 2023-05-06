*"* use this source file for your ABAP unit test classes
CLASS ltc_products_entity DEFINITION FINAL FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    TYPES tt_products_temp TYPE TABLE OF zsproducts_rs.

    CLASS-DATA:
      st_products TYPE zcl_product_model_es=>tt_products,
      so_util     TYPE REF TO zcl_rfes_util,
      so_helper   TYPE REF TO lcl_client_proxy_helper.

    CLASS-METHODS:
      class_setup,
      class_teardown.

    METHODS:
      get_products_mock
        RETURNING
          VALUE(rt_products) TYPE zcl_product_model_es=>tt_products,
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
    so_util = NEW zcl_rfes_util(  ).
    so_helper = NEW lcl_client_proxy_helper(  ).
  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD get_products_mock.
    DATA products_temp TYPE tt_products_temp.

    IF st_products IS INITIAL.
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
        <product>-id = so_util->convert_to_abap_uuid( CONV #( <product>-id ) ).
        <product>-supplier_id = so_util->convert_to_abap_uuid( CONV #( <product>-supplier_id ) ).
        <product>-description = so_util->condense_string( CONV #( <product>-description ) ).
        <product>-release_date = so_util->convert_to_abap_timestamp( CONV #( <product>-release_date ) ).
        <product>-discontinued_date = so_util->convert_to_abap_timestamp( CONV #( <product>-discontinued_date ) ).
        <product>-created_by = <product>-modified_by = cl_abap_context_info=>get_user_technical_name(  ).
        <product>-created_at = <product>-modified_at = |{ cl_abap_context_info=>get_system_date(  ) }{ cl_abap_context_info=>get_system_time(  ) }|.
      ENDLOOP.

      st_products = CORRESPONDING #( products_temp MAPPING imageurl = image_url ).
    ENDIF.

    RETURN st_products.
  ENDMETHOD.

  METHOD get_products.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DELETE products_mock FROM 6 TO lines( products_mock ).

    "configure mock
    DATA(mock) = so_helper->configure_query(
      iv_entity_set_name = 'PRODUCTS'
      it_data            = products_mock
      is_count_requested = abap_true
    ).

    TRY.
        "start the test
        so_helper->mo_cut->get_products(
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
    so_helper->verify_query_expectations( mock ).
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
    DATA(exception_mock) = NEW /iwbep/cx_gateway( ).

    "configure mock
    DATA(mock) = so_helper->configure_query(
      iv_entity_set_name = 'PRODUCTS'
      iv_search          = 'Lemon'
      io_exception       = exception_mock
    ).

    TRY.
        "start the test
        so_helper->mo_cut->get_products(
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
        so_helper->verify_query_expectations( mock ).
        cl_abap_unit_assert=>assert_equals(
          msg = 'should return exception'
          exp = exception_mock
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
    DATA(mock) = so_helper->configure_query(
      iv_entity_set_name = 'PRODUCTS'
      iv_filter_count    = lines( filters )
      it_data            = products_mock
      is_count_requested = abap_true
    ).

    TRY.
        "start the test
        so_helper->mo_cut->get_products(
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
    so_helper->verify_query_expectations( mock ).
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
    DATA(mock) = so_helper->configure_query(
      iv_entity_set_name = 'PRODUCTS'
      it_sort_order      = sort_order
      it_data            = products_mock
      is_count_requested = abap_true
    ).

    TRY.
        "start the test
        so_helper->mo_cut->get_products(
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
    so_helper->verify_query_expectations( mock ).
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
    DATA(mock) = so_helper->configure_select(
      iv_entity_set_name = 'PRODUCTS'
      it_data            = products_mock
    ).

    TRY.
        "start the test
        so_helper->mo_cut->if_rap_query_provider~select(
          io_request  = mock-in-request
          io_response = mock-in-response
        ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    so_helper->verify_select_expectations( mock ).
  ENDMETHOD.

  METHOD select_products_with_count.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DELETE products_mock FROM 6 TO lines( products_mock ).

    "configure mock
    DATA(mock) = so_helper->configure_select(
      iv_entity_set_name = 'PRODUCTS'
      it_data            = products_mock
      is_count_requested = abap_true
    ).

    TRY.
        "start the test
        so_helper->mo_cut->if_rap_query_provider~select(
          io_request  = mock-in-request
          io_response = mock-in-response
        ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    so_helper->verify_select_expectations( mock ).
  ENDMETHOD.

  METHOD select_products_with_search.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DELETE products_mock FROM 6 TO lines( products_mock ).
    DATA(exception_mock) = NEW /iwbep/cx_gateway( ).

    "configure mock
    DATA(mock) = so_helper->configure_select(
      iv_entity_set_name   = 'PRODUCTS'
      it_data              = products_mock
      iv_search_expression = 'Lemon'
      is_count_requested   = abap_true
      io_exception         = exception_mock
    ).

    TRY.
        "start the test
        so_helper->mo_cut->if_rap_query_provider~select(
          io_request  = mock-in-request
          io_response = mock-in-response
        ).
        cl_abap_unit_assert=>fail( 'should return exception, but didn''t' ).
      CATCH cx_root INTO DATA(exception).
        "do assertions
        so_helper->verify_select_expectations( mock ).
        cl_abap_unit_assert=>assert_equals(
          msg = 'should return exception'
          exp = exception_mock
          act = exception->previous
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_product.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DATA(product_mock) = products_mock[ 1 ].

    "configure mock
    DATA(mock) = so_helper->configure_read(
      iv_entity_set_name = 'PRODUCTS'
      is_key             = VALUE zcl_product_model_es=>ts_product( id = product_mock-id )
      is_data            = product_mock
    ).

    TRY.
        "start the test
        so_helper->mo_cut->get_product(
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
    so_helper->verify_read_expectations( mock ).
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
    product_mock-id = so_util->convert_to_abap_uuid( '16f86ef1-1525-4932-b1ce-d40661464c66' ).
    DATA(exception_mock) = NEW /iwbep/cx_cp_remote( ).

    "configure mock
    DATA(mock) = so_helper->configure_read(
      iv_entity_set_name = 'PRODUCTS'
      is_key             = product_mock
      is_data            = product_mock
      io_exception       = exception_mock
    ).

    TRY.
        "start the test
        so_helper->mo_cut->get_product(
          EXPORTING
            iv_key     = product_mock-id
          IMPORTING
            es_product = DATA(product)
            ev_etag    = DATA(etag)
        ).
        cl_abap_unit_assert=>fail( 'should return exception, but didn''t' ).
      CATCH cx_root INTO DATA(exception).
        "do assertions
        so_helper->verify_read_expectations( mock ).
        cl_abap_unit_assert=>assert_equals(
          msg = 'should return exception'
          exp = exception_mock
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
    DATA(mock) = so_helper->configure_create(
      iv_entity_set_name = 'PRODUCTS'
      is_data            = product_mock
    ).

    TRY.
        "start the test
        so_helper->mo_cut->create_product(
          EXPORTING
            is_product = product_mock
          IMPORTING
            es_product = DATA(product)
        ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    so_helper->verify_create_expectations( mock ).
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
    DATA(exception_mock) = NEW /iwbep/cx_cp_remote( ).

    "configure mock
    DATA(mock) = so_helper->configure_create(
      iv_entity_set_name = 'PRODUCTS'
      is_data            = product_mock
      io_exception       = exception_mock
    ).

    TRY.
        "start the test
        so_helper->mo_cut->create_product(
          EXPORTING
            is_product = product_mock
          IMPORTING
            es_product = DATA(product)
        ).
        cl_abap_unit_assert=>fail( 'should return exception, but didn''t' ).
      CATCH cx_root INTO DATA(exception).
        "do assertions
        so_helper->verify_create_expectations( mock ).
        cl_abap_unit_assert=>assert_equals(
          msg = 'should return exception'
          exp = exception_mock
          act = exception
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD update_product.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DATA(product_mock) = products_mock[ 1 ].

    "configure mock
    DATA(mock) = so_helper->configure_update(
      iv_entity_set_name     = 'PRODUCTS'
      is_key                 = VALUE zcl_product_model_es=>ts_product( id = product_mock-id )
      iv_etag                = 'dummy-etag'
      is_data                = product_mock
      it_provided_properties = VALUE #( ( CONV #( 'NAME' ) ) )
    ).

    TRY.
        "start the test
        so_helper->mo_cut->update_product(
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
    so_helper->verify_update_expectations( mock ).
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
    DATA(exception_mock) = NEW /iwbep/cx_cp_remote( ).

    "configure mock
    DATA(mock) = so_helper->configure_update(
      iv_entity_set_name     = 'PRODUCTS'
      is_key                 = VALUE zcl_product_model_es=>ts_product( id = product_mock-id )
      iv_etag                = 'dummy-etag'
      is_data                = product_mock
      it_provided_properties = VALUE #( ( CONV #( 'NAME' ) ) )
      io_exception           = exception_mock
    ).

    TRY.
        "start the test
        so_helper->mo_cut->update_product(
          EXPORTING
            is_product = product_mock
            iv_etag    = 'dummy-etag'
          IMPORTING
            ev_etag    = DATA(etag)
        ).
        cl_abap_unit_assert=>fail( 'should return exception, but didn''t' ).
      CATCH cx_root INTO DATA(exception).
        "do assertions
        so_helper->verify_update_expectations( mock ).
        cl_abap_unit_assert=>assert_equals(
          msg = 'should return exception'
          exp = exception_mock
          act = exception
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD delete_product.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DATA(product_mock) = products_mock[ 1 ].

    "configure mock
    DATA(mock) = so_helper->configure_delete(
      iv_entity_set_name = 'PRODUCTS'
      is_key             = VALUE zcl_product_model_es=>ts_product( id = product_mock-id )
    ).

    TRY.
        "start the test
        so_helper->mo_cut->delete_product( product_mock-id ).
      CATCH cx_root INTO DATA(exception).
        cl_abap_unit_assert=>fail( 'Unexpected exception occurred' ).
    ENDTRY.

    "do assertions
    so_helper->verify_delete_expectations( mock ).
  ENDMETHOD.

  METHOD delete_invalid_product.
    "prepare mock data
    DATA(products_mock) = get_products_mock(  ).
    DATA(product_mock) = products_mock[ 1 ].
    DATA(exception_mock) = NEW /iwbep/cx_cp_remote( ).

    "configure mock
    DATA(mock) = so_helper->configure_delete(
      iv_entity_set_name = 'PRODUCTS'
      is_key             = VALUE zcl_product_model_es=>ts_product( id = product_mock-id )
      io_exception       = exception_mock
    ).

    TRY.
        "start the test
        so_helper->mo_cut->delete_product( product_mock-id ).
        cl_abap_unit_assert=>fail( 'should return exception, but didn''t' ).
      CATCH cx_root INTO DATA(exception).
        "do assertions
        so_helper->verify_delete_expectations( mock ).
        cl_abap_unit_assert=>assert_equals(
          msg = 'should return exception'
          exp = exception_mock
          act = exception
        ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
