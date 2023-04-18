CLASS zcl_data_generator_rs DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

    TYPES tt_categories TYPE TABLE OF zacategories_rs.
    TYPES tt_currencies TYPE TABLE OF zacurrencies_rs.
    TYPES tt_dimenunits TYPE TABLE OF zadimensnunit_rs.
    TYPES tt_months TYPE TABLE OF zamonths_rs.
    TYPES tt_products TYPE TABLE OF zaproducts_rs.
    TYPES tt_statuses TYPE TABLE OF zastockstatus_rs.
    TYPES tt_suppliers TYPE TABLE OF zasuppliers_rs.
    TYPES tt_unit_of_measures TYPE TABLE OF zaunitofmeasu_rs.
    TYPES tt_reviews TYPE TABLE OF zaprodreviews_rs.
    TYPES tt_sales_data TYPE TABLE OF zasalesdata_rs.

    TYPES ts_products_temp TYPE zsproducts_rs.
    TYPES tt_products_temp TYPE TABLE OF ts_products_temp.
    TYPES tt_suppliers_temp TYPE TABLE OF zssuppliers_rs.
    TYPES tt_reviews_temp TYPE TABLE OF zsprodreviews_rs.
    TYPES tt_sales_data_temp TYPE TABLE OF zssalesdata_rs.

    METHODS convert_to_abap_uuid
      IMPORTING
        iv_uuid        TYPE ts_products_temp-id
      RETURNING
        VALUE(rv_uuid) TYPE ts_products_temp-id.

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS convert_to_abap_timestamp
      IMPORTING
        iv_timestamp        TYPE ts_products_temp-release_date
      RETURNING
        VALUE(rv_timestamp) TYPE ts_products_temp-release_date.

    METHODS condense_string
      IMPORTING
        iv_string        TYPE ts_products_temp-description
      RETURNING
        VALUE(rv_string) TYPE ts_products_temp-description.

ENDCLASS.



CLASS zcl_data_generator_rs IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA categories TYPE tt_categories.
    DATA currencies TYPE tt_currencies.
    DATA dimension_units TYPE tt_dimenunits.
    DATA months TYPE tt_months.
    DATA products TYPE tt_products.
    DATA products_temp TYPE tt_products_temp.
    DATA statuses TYPE tt_statuses.
    DATA suppliers TYPE tt_suppliers.
    DATA suppliers_temp TYPE tt_suppliers_temp.
    DATA unit_of_measures TYPE tt_unit_of_measures.
    DATA reviews TYPE tt_reviews.
    DATA reviews_temp TYPE tt_reviews_temp.
    DATA sales_data TYPE tt_sales_data.
    DATA sales_data_temp TYPE tt_sales_data_temp.

    out->write( 'Generate data for RAP Samples' ).

    categories = VALUE #(
        ( id = 'F' name = 'Food' )
        ( id = 'B' name = 'Beverages' )
        ( id = 'E' name = 'Electronics' )
    ).

    DELETE FROM zacategories_rs.
    INSERT zacategories_rs FROM TABLE @categories.
    out->write( |Categories: { sy-dbcnt } data inserted successfully!| ).

    currencies = VALUE #(
        ( id = 'USD' name = 'US Dollar' )
        ( id = 'AUD' name = 'Australian Dollar' )
    ).

    DELETE FROM zacurrencies_rs.
    INSERT zacurrencies_rs FROM TABLE @currencies.
    out->write( |Currencies: { sy-dbcnt } data inserted successfully!| ).

    dimension_units = VALUE #(
        ( id = 'MM' name = 'Millimeter' )
        ( id = 'CM' name = 'Centimeter' )
        ( id = 'M' name = 'Meter' )
    ).

    DELETE FROM zadimensnunit_rs.
    INSERT zadimensnunit_rs FROM TABLE @dimension_units.
    out->write( |Dimension Units: { sy-dbcnt } data inserted successfully!| ).

    "source: (.*),(.*),(.*)
    "target: ( id = '$1' name = '$2' code = '$3' )

    months = VALUE #(
        ( id = '01' name = 'January' code = 'Jan' )
        ( id = '02' name = 'February' code = 'Feb' )
        ( id = '03' name = 'March' code = 'Mar' )
        ( id = '04' name = 'April' code = 'Apr' )
        ( id = '05' name = 'May' code = 'May' )
        ( id = '06' name = 'June' code = 'Jun' )
        ( id = '07' name = 'July' code = 'Jul' )
        ( id = '08' name = 'August' code = 'Aug' )
        ( id = '09' name = 'September' code = 'Sep' )
        ( id = '10' name = 'October' code = 'Oct' )
        ( id = '11' name = 'November' code = 'Nov' )
        ( id = '12' name = 'December' code = 'Dec' )
    ).

    DELETE FROM zamonths_rs.
    INSERT zamonths_rs FROM TABLE @months.
    out->write( |Months: { sy-dbcnt } data inserted successfully!| ).

    "source: ([a-z0-9-]*),([a-zA-Z ]*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*)
    "target: ( id = '$1' name = '$2' description = '$3' image_url = '$4' release_date = '$5' discontinued_date = '$6' price = '$7' height = '$8' width = '$9' depth = '$10' quantity = '$11' unit_of_measure_id = '$12' currency_id = '$13'
    "          category_id = '$14' supplier_id = '$15' dimension_unit_id = '$16' )

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
      <product>-id = convert_to_abap_uuid( <product>-id ).
      <product>-supplier_id = convert_to_abap_uuid( <product>-supplier_id ).
      <product>-description = condense_string( <product>-description ).
      <product>-release_date = convert_to_abap_timestamp( <product>-release_date ).
      <product>-discontinued_date = convert_to_abap_timestamp( <product>-discontinued_date ).
      <product>-created_by = <product>-modified_by = cl_abap_context_info=>get_user_technical_name(  ).
      <product>-created_at = <product>-modified_at = |{ cl_abap_context_info=>get_system_date(  ) }{ cl_abap_context_info=>get_system_time(  ) }|.
    ENDLOOP.

    products = CORRESPONDING #( products_temp ).
    DELETE FROM zaproducts_rs.
    INSERT zaproducts_rs FROM TABLE @products.
    out->write( |Products: { sy-dbcnt } data inserted successfully!| ).

    "source: (.*),(.*)
    "target: ( id = '$1' name = '$2' )

    statuses = VALUE #(
        ( id = '1' name = 'Out of Stock' )
        ( id = '2' name = 'Limited Stock' )
        ( id = '3' name = 'In Stock' )
    ).

    DELETE FROM zastockstatus_rs.
    INSERT zastockstatus_rs FROM TABLE @statuses.
    out->write( |Statuses: { sy-dbcnt } data inserted successfully!| ).

    "source: (.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*)
    "target: ( id = '$1' name = '$2' street = '$3' city = '$4' state = '$5' postal_code = '$6' country = '$7' email = '$8' phone = '$9' fax = '$10' )

    suppliers_temp = VALUE #(
        ( id = 'aead11fd-e35b-4f6f-a37a-e4a860aaaad7' name = 'Exotic Liquids' street = 'NE 228th' city = 'Sammamish' state = 'WA' postal_code = '98074' country = 'USA' email = 'exotic.liquids@email.com' phone = '0622734567' fax = '0622734004' )
        ( id = '6967edb4-cd83-4c8b-90ae-6894a71b398f' name = 'Tokyo Traders' street = 'NE 40th' city = 'Redmond' state = 'WA' postal_code = '98052' country = 'USA' email = 'tokyo.traders@email.com' phone = '0622734567' fax = '0622734004' )
    ).

    LOOP AT suppliers_temp ASSIGNING FIELD-SYMBOL(<suppliers>).
      <suppliers>-id = convert_to_abap_uuid( <suppliers>-id ).
    ENDLOOP.

    suppliers = CORRESPONDING #( suppliers_temp ).
    DELETE FROM zasuppliers_rs.
    INSERT zasuppliers_rs FROM TABLE @suppliers.
    out->write( |Suppliers: { sy-dbcnt } data inserted successfully!| ).

    "source: (.*),(.*)
    "target: ( id = '$1' name = '$2' )

    unit_of_measures = VALUE #(
        ( id = 'EA' name = 'Piece' )
        ( id = 'PAK' name = 'Pack' )
    ).

    DELETE FROM zaunitofmeasu_rs.
    INSERT zaunitofmeasu_rs FROM TABLE @unit_of_measures.
    out->write( |Unit of Measures: { sy-dbcnt } data inserted successfully!| ).

    "source: ([a-z0-9-]*),([a-z0-9-]*),([0-9-:TZ\.]*),([a-zA-Z ]*),([0-9]*),(.*)
    "target: ( id = '$1' product_id = '$2' name = '$4' rating = '$5' comments = '$6' )

    reviews_temp = VALUE #(
        ( id = '4b107c38-e44f-48b0-ab75-b28b38aba8f4' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' name = 'Patton Fuller' rating = '5'
            comments = '"Great product\nAfter trying the product, I really like it. It is really fragrant and taste good."' )
        ( id = '5d8e4b7e-9f06-4b70-af5e-be395e909689' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' name = 'Patty Paul' rating = '5'
            comments = '"Taste like usual milk tea.. But the flavour is not bad. May consider trying it again in the future!!\nTaste like usual milk tea.. But the flavour is not bad. May consider trying it again in the future!!"' )
        ( id = '9d03cfaa-61a4-4f2c-b4b7-505a8cd7aee2' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' name = 'Winifred Buck' rating = '4'
            comments = '"The milk tea is nice to drink and very fragrant. The taste is good."' )
        ( id = '88cb4fc0-1ee4-4c60-b38b-d96c50488cb4' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' name = 'Gamble Miranda' rating = '3'
            comments = '"Nice fragrance\nI like the fragrance of the milk tea. Love it.. slightly too sweet though"' )
        ( id = '9ec80443-d403-4ea8-ba89-588fcc035f6e' product_id = '08c142fa-01b0-441d-b01d-eeaa3291f6f0' name = 'Gamble Miranda' rating = '4'
            comments = '"Nice fragrance\nI like the fragrance of the milk tea. Love it.. slightly too sweet though"' )
        ( id = '2f386a79-2752-46a3-98c1-3e9c08455943' product_id = 'aa74747d-c297-4f0a-981a-8fb0ca92b756' name = 'Gamble Miranda' rating = '3'
            comments = '"Nice fragrance\nI like the fragrance of the milk tea. Love it.. slightly too sweet though"' )
        ( id = '067b0465-0d5d-48ad-9cb9-a2f8a369ff18' product_id = 'ea610da1-ea93-4258-85e1-099167d67bf9' name = 'Gamble Miranda' rating = '3'
            comments = '"Nice fragrance\nI like the fragrance of the milk tea. Love it.. slightly too sweet though"' )
        ( id = 'eac2f4f7-0124-4391-932a-9c9228dc5281' product_id = 'd97de1ec-7fd1-4c56-8e15-0246dc7a0cbf' name = 'Gamble Miranda' rating = '3'
            comments = '"Nice fragrance\nI like the fragrance of the milk tea. Love it.. slightly too sweet though"' )
        ( id = '59103574-c7c3-48aa-8efa-22735ca61d80' product_id = '9e800613-7b96-4203-8817-f25fcc89dfbc' name = 'Gamble Miranda' rating = '3'
            comments = '"Nice fragrance\nI like the fragrance of the milk tea. Love it.. slightly too sweet though"' )
        ( id = '8f8e383f-a7e5-4aa3-8fc2-fc2f2030020c' product_id = 'fe613858-7385-4c1c-8f4e-b3439a5ec637' name = 'Gamble Miranda' rating = '3'
            comments = '"Nice fragrance\nI like the fragrance of the milk tea. Love it.. slightly too sweet though"' )
        ( id = '2af384ad-e431-48f3-8dc6-b687b7a036f3' product_id = '5ee16f77-171c-4f1e-b455-221a1530b242' name = 'Gamble Miranda' rating = '5'
            comments = '"Nice fragrance\nI like the fragrance of the milk tea. Love it.. slightly too sweet though"' )
        ( id = '3ffee035-ca62-4043-9dcc-e620d7a43484' product_id = '58a8c519-2aa6-4289-84c3-d79de5a67dd0' name = 'Gamble Miranda' rating = '3'
            comments = '"Nice fragrance\nI like the fragrance of the milk tea. Love it.. slightly too sweet though"' )
        ( id = 'cc8a817a-2f7f-4df4-8e75-03c1e520f2c1' product_id = 'aa7d843f-c6c5-4bc9-846b-ddac07966f10' name = 'Gamble Miranda' rating = '5'
            comments = '"Nice fragrance\nI like the fragrance of the milk tea. Love it.. slightly too sweet though"' )
        ( id = '5ebc14ce-80e5-40bb-a13f-cb6a61e90446' product_id = 'de411986-f74c-4082-83bc-2aa5c5a25aad' name = 'Gamble Miranda' rating = '1'
            comments = '"Nice fragrance\nI like the fragrance of the milk tea. Love it.. slightly too sweet though"' )
    ).

    LOOP AT reviews_temp ASSIGNING FIELD-SYMBOL(<reviews>).
      <reviews>-id = convert_to_abap_uuid( <reviews>-id ).
      <reviews>-product_id = convert_to_abap_uuid( <reviews>-product_id ).
      <reviews>-comments = condense_string( <reviews>-comments ).
      <reviews>-created_by = <reviews>-modified_by = cl_abap_context_info=>get_user_technical_name(  ).
      <reviews>-created_at = <reviews>-modified_at = |{ cl_abap_context_info=>get_system_date(  ) }{ cl_abap_context_info=>get_system_time(  ) }|.
    ENDLOOP.

    reviews = CORRESPONDING #( reviews_temp ).
    DELETE FROM zaprodreviews_rs.
    INSERT zaprodreviews_rs FROM TABLE @reviews.
    out->write( |Reviews: { sy-dbcnt } data inserted successfully!| ).

    "source: (.*),(.*)
    "target: ( id = '$1' name = '$2' )

    sales_data_temp = VALUE #(
        ( id = '81beb13e-16e1-4a8d-8e3b-e8e2008b1d3f' delivery_date = '2020-01-15T00:00:00Z' revenue = '5057.20' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '01' )
        ( id = 'da4f60f1-0923-4eb7-9ff5-966cd61f4d28' delivery_date = '2020-02-15T00:00:00Z' revenue = '2425.20' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '02' )
        ( id = 'b4924884-93f8-43ed-a3ff-29771b048efa' delivery_date = '2020-03-15T00:00:00Z' revenue = '3534.40' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '03' )
        ( id = '6a6e915b-4c5d-4cdd-acf7-44cafef6e89e' delivery_date = '2020-04-15T00:00:00Z' revenue = '3365.20' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '04' )
        ( id = '2b4bfc83-9bca-4d1b-809c-2636aa61eb00' delivery_date = '2020-05-15T00:00:00Z' revenue = '3083.20' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '05' )
        ( id = '259ee9d8-8550-43f0-b09f-1459f3ad5649' delivery_date = '2020-06-15T00:00:00Z' revenue = '5057.20' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '06' )
        ( id = '2584ecfa-b291-4e7e-b155-473513e38a11' delivery_date = '2020-07-15T00:00:00Z' revenue = '3327.60' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '07' )
        ( id = 'f5587904-3747-412f-9f50-bcb080596f42' delivery_date = '2020-08-15T00:00:00Z' revenue = '4418.00' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '08' )
        ( id = 'dbaaeab4-95af-4266-ac99-f124b68536af' delivery_date = '2020-09-15T00:00:00Z' revenue = '3572.00' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '09' )
        ( id = 'ba34e966-c511-4e55-9835-ced695a00316' delivery_date = '2020-10-15T00:00:00Z' revenue = '5170.00' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '10' )
        ( id = '4004142f-a791-4580-afd8-c2ab43728c53' delivery_date = '2020-11-15T00:00:00Z' revenue = '1992.80' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '11' )
        ( id = '4139f4a5-4a4c-4fac-afe4-605a31e241c0' delivery_date = '2020-12-15T00:00:00Z' revenue = '1880.00' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '12' )
        ( id = '4f47e8a2-c9f6-42c8-bb0a-f5df3001aa94' delivery_date = '2020-12-10T00:00:00Z' revenue = '2256.00' product_id = '06f86ef1-1525-4932-b1ce-d40661464c66' currency_id = 'USD' delivery_month_id = '12' )
    ).

    LOOP AT sales_data_temp ASSIGNING FIELD-SYMBOL(<data>).
      <data>-id = convert_to_abap_uuid( <data>-id ).
      <data>-product_id = convert_to_abap_uuid( <data>-product_id ).
      <data>-delivery_date = convert_to_abap_timestamp( <data>-delivery_date ).
    ENDLOOP.

    sales_data = CORRESPONDING #( sales_data_temp ).
    DELETE FROM zasalesdata_rs.
    INSERT zasalesdata_rs FROM TABLE @sales_data.
    out->write( |Sales Data: { sy-dbcnt } data inserted successfully!| ).

  ENDMETHOD.


  METHOD convert_to_abap_uuid.
    rv_uuid = to_upper( iv_uuid ).
    rv_uuid = replace( val = rv_uuid sub = '-' occ = 0 with = '' ).
    RETURN rv_uuid.
  ENDMETHOD.

  METHOD convert_to_abap_timestamp.
    rv_timestamp = replace( val = iv_timestamp sub = '-' occ = 0 with = '' ).
    rv_timestamp = replace( val = rv_timestamp sub = ':' occ = 0 with = '' ).
    rv_timestamp = replace( val = rv_timestamp sub = 'T' occ = 0 with = '' ).
    rv_timestamp = replace( val = rv_timestamp sub = 'Z' occ = 0 with = '' ).
    RETURN rv_timestamp.
  ENDMETHOD.

  METHOD condense_string.
    rv_string = replace( val = iv_string sub = '"' occ = 0 with = '' ).
    RETURN rv_string.
  ENDMETHOD.

ENDCLASS.
