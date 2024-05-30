CLASS zarch_amdp_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZARCH_AMDP_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*FOR CALLING AMDP CLASS
  data : lv_price TYPE int4, lv_dis type int4.
  zarch_amdp_price=>get_price(
    EXPORTING
      p_id    = '8E4F46B9355F1EDF84A21C8354239FEB'
    IMPORTING
      e_price = lv_price
      e_dis   = lv_dis
  ).

*//FOR OUTPUT DISPLAY
  out->write(
    EXPORTING
      data   = |price { lv_price } discount { lv_dis }|
*      name   =
*    RECEIVING
*      output =
  ).
  ENDMETHOD.
ENDCLASS.
