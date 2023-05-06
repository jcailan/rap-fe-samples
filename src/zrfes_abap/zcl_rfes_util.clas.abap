CLASS zcl_rfes_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS convert_to_abap_uuid
      IMPORTING
        iv_uuid        TYPE string
      RETURNING
        VALUE(rv_uuid) TYPE string.

    METHODS convert_to_abap_timestamp
      IMPORTING
        iv_timestamp        TYPE string
      RETURNING
        VALUE(rv_timestamp) TYPE string.

    METHODS condense_string
      IMPORTING
        iv_string        TYPE string
      RETURNING
        VALUE(rv_string) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rfes_util IMPLEMENTATION.

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
