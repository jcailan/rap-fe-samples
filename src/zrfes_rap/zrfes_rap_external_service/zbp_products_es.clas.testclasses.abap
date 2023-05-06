*"* use this source file for your ABAP unit test classes
"! @testing SRVB:ZUI_PRODUCTS_ES_O2
CLASS ltc_product_entity DEFINITION FINAL FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      so_cut          TYPE REF TO lhc_zz_products_es,
      so_cds_mock     TYPE REF TO if_cds_test_environment,
      so_sql_mock     TYPE REF TO if_osql_test_environment,
      so_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
      st_product_mock TYPE TABLE OF zz_products_es.

    CLASS-METHODS:
      class_setup,
      class_teardown,
      get_client_proxy
        IMPORTING
          is_service_key         TYPE /iwbep/if_cp_client_proxy=>ty_s_service_key_v2
        RETURNING
          VALUE(ro_client_proxy) TYPE REF TO /iwbep/if_cp_client_proxy.

    METHODS:
      setup,
      teardown,
      get_products FOR TESTING.

ENDCLASS.

CLASS ltc_product_entity IMPLEMENTATION.

  METHOD class_setup.
    CREATE OBJECT so_cut FOR TESTING.

    so_client_proxy = get_client_proxy( VALUE #( service_id      = 'ZUI_PRODUCTS_ES_O2'
                                              service_version = '0001' )  ).

    so_cds_mock = cl_cds_test_environment=>create_for_multiple_cds( i_for_entities = VALUE #(
      ( i_for_entity = 'ZZ_PRODUCTS_ES' i_select_base_dependencies = abap_true )
    ) ).

    st_product_mock = VALUE #(
        ( id = '08C142FA01B0441DB01DEEAA3291F6F0' name = 'Bread' description = 'Whole grain bread' imageurl = '/assets/bread.jpg' releasedate = '1992-01-01T00:00:00Z' discontinueddate = ''
          price = '2.5' height = '5' width = '10' depth = '8' quantity = '20' unitofmeasure_id = 'EA' currency_id = 'USD' category_id = 'F' supplier_id = 'AEAD11FDE35B4F6FA37AE4A860AAAAD7' dimensionunit_id = 'CM' )
    ).
  ENDMETHOD.

  METHOD class_teardown.
    so_cds_mock->destroy( ).
  ENDMETHOD.

  METHOD setup.
    so_cds_mock->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD get_client_proxy.
    TRY.
        "cloud version
        DATA(class1) = 'CL_WEB_ODATA_CLIENT_FACTORY'.
        CALL METHOD (class1)=>create_v2_local_proxy
          EXPORTING
            is_service_key  = is_service_key
          RECEIVING
            ro_client_proxy = ro_client_proxy.
      CATCH cx_root.
        "do nothing
    ENDTRY.


    IF ro_client_proxy IS NOT BOUND.
      TRY.
          "on-premise version
          DATA(class2) = '/IWBEP/CL_CP_CLIENT_PROXY_FACT'.
          CALL METHOD (class2)=>create_v2_local_proxy
            EXPORTING
              is_service_key  = is_service_key
            RECEIVING
              ro_client_proxy = ro_client_proxy.
        CATCH cx_root.
          "do nothing
      ENDTRY.
    ENDIF.

    cl_abap_unit_assert=>assert_bound( msg = 'cannot get client proxy factory or service binding not active' act = ro_client_proxy ).
  ENDMETHOD.

  METHOD get_products.
    "Testing of a CDS custom entity is not supported
    "therefore, there's no point to have a test here
  ENDMETHOD.

ENDCLASS.
