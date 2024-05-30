CLASS zarch_bo_rap_test_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    DATA: lv_TYPE TYPE c VALUE 'C'.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zarch_bo_rap_test_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    CASE lv_type.
      WHEN 'R'.
        READ ENTITIES OF zarch_i_u_travel
        ENTITY travel ALL FIELDS WITH
        VALUE #( ( TravelId = '70089' ) )
        RESULT DATA(lt_result)
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).
        IF lt_result IS NOT INITIAL.
          out->write(
            EXPORTING
              data   = lt_result
*    name   =
*  RECEIVING
*    output =
          ).
        ELSE.
          out->write(
            EXPORTING
              data   = lt_result
*    name   =
*  RECEIVING
*    output =
          ).
        ENDIF.
      WHEN 'C'.

        DATA(lv_des) = 'THIS IS ARCHIT CLASS'.
        DATA(lv_agency) = '07896'.
        DATA(lv_my_agency) = '098674'.

        SELECT SINGLE customer_id FROM /dmo/customer INTO @DATA(lt_cust).
        MODIFY ENTITIES OF zarch_i_u_travel
        ENTITY travel
        CREATE FIELDS ( travelid customerid AgencyId begindate description )
          WITH VALUE #( ( %cid = 'cid10'
          travelid = '46578'
              agencyid = lv_agency
              customerid = lt_cust
              description = lv_des
              begindate = cl_abap_context_info=>get_system_date( ) )
                 )
                 MAPPED DATA(lt_mapped)
                 FAILED lt_failed
                 REPORTED lt_reported
                 .

        COMMIT ENTITIES.
*
*         READ ENTITIES OF zarch_i_u_travel
*ENTITY TRAVEL ALL FIELDS WITH
*VALUE #( ( TravelId = lt_mapped-travel[ 1 ]-TravelId ) )
*RESULT LT_RESULT
*FAILED LT_FAILED
*REPORTED LT_REPORTED.
*


      WHEN 'U'.
        MODIFY ENTITIES OF zarch_i_u_travel
        ENTITY travel
        UPDATE FIELDS (  customerid  description )
          WITH VALUE #( (
          travelid = '46578'
              description =  'hello'
              customerid = lt_cust
              )
                 )

                 FAILED lt_failed
                 REPORTED lt_reported
                 .

        COMMIT ENTITIES.
      WHEN 'D'.
        MODIFY ENTITIES OF zarch_i_u_travel
  ENTITY travel
  DELETE
    FROM VALUE #( (
    travelid = '46578'

        )
           )

           FAILED lt_failed
           REPORTED lt_reported
           .

        COMMIT ENTITIES.
      WHEN 'A'.
*      -- FOR EXECUTING MADDI BUTTON
              MODIFY ENTITIES OF zarch_i_u_travel
  ENTITY travel
  EXECUTE set_book_status
    FROM VALUE #( (
    travelid = '46578'

        )
           )

           FAILED lt_failed
           REPORTED lt_reported
           .

        COMMIT ENTITIES.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
