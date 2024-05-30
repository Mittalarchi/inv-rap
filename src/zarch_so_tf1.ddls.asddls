@EndUserText.label: 'for cds table function'

define table function zarch_so_tf1

with parameters
@Environment.systemField: #CLIENT
 p_clnt : abap.clnt

returns {
  client : abap.clnt;
   order_no : abap.int4;
   gross_amt : abap.int4;
   gross_dis_amt : abap.int4;
  
}
implemented by method ZARCH_AMDP_PRICE=>get_so;