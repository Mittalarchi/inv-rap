CLASS zarch_amdp_price DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb.
  class-METHODS get_price
*  FOR PASSING PRODICT ID AND CALCULATING PRICE AND DISCOUNT
  IMPORTING
  VALUE(p_id) TYPE zarch_dte_id
  EXPORTING
  VALUE(e_price) TYPE int4
  VALUE(e_dis) TYPE int4.

  class-METHODS get_so FOR TABLE FUNCTION zarch_so_tf1.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZARCH_AMDP_PRICE IMPLEMENTATION.


  METHOD get_price BY DATABASE PROCEDURE FOR HDB LANGUAGE
       SQLSCRIPT OPTIONS READ-ONLY USING zarch_dt_product.

DECLARE lv_price, lv_dis INTEGER;
SELECT price, discount INTO lv_price, lv_dis FROM zarch_dt_product WHERE pro_id = :p_id;
e_price = :lv_price;
e_dis = ( :lv_price * ( 100 - :lv_dis ) /100 );

  ENDMETHOD.


  METHOD get_so BY DATABASE function FOR HDB LANGUAGE
  SQLSCRIPT OPTIONS READ-ONLY USING zarch_dt_so zarch_dt_si zarch_dt_product.
*  data: lv_price
lt_price = select hdr.client, hdr.order_no, item.Amount, ( item.amount * ( 100 - pro.discount ) / 100 ) as gross_amt
 from zarch_dt_so as hdr inner join zarch_dt_si as item on hdr.Sales_Id = item.item_id
        inner join zarch_dt_product as pro on item.product = pro.Pro_Id where hdr.client = :p_clnt;

        RETURN select client, order_no, sum ( Amount ) as gross_amt , sum ( gross_amt ) as gross_dis_Amt from :lt_price
        GROUP BY client, order_no;

  ENDMETHOD.
ENDCLASS.
