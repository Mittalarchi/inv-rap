CLASS lhc_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES tt_travel_failed TYPE TABLE FOR FAILED zarch_i_m_travel1.
    TYPES tt_travel_reported TYPE TABLE FOR REPORTED zarch_i_m_travel1.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR travel RESULT result.
    METHODS createtravelbytemp FOR MODIFY
      IMPORTING keys FOR ACTION travel~createtravelbytemp RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR travel RESULT result.

    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION travel~accepttravel RESULT result.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION travel~rejecttravel RESULT result.
    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatecustomer.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatedates.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatestatus.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE travel.
          METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE Travel\_Booking.


ENDCLASS.

CLASS lhc_TRAVEL IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD createtravelbytemp.
* step1 "extract max travelid  in the ystem
    SELECT MAX( travel_id ) FROM /dmo/travel INTO @DATA(lv_travel_id).

*  step2" read the record data which need to be copied by eml.
    READ ENTITIES OF zarch_i_m_travel1 IN LOCAL MODE  "--localmode = means using BO with in the implememntation of same bo
    ENTITY travel
    FIELDS ( TravelId AgencyId CustomerId BeginDate TotalPrice CurrencyCode )
    WITH CORRESPONDING #( keys )    "keys -  default input parameter to tells which record selected by user on ui
    RESULT DATA(lt_result)
    FAILED failed
    REPORTED reported.   "--failed and reported are default output parameter


    "step3 increment the travel id by 1 and use EML TO INSERT NEW DATA
    DATA(lv_today) = cl_abap_context_info=>get_system_date(  ).

    DATA lt_create TYPE TABLE FOR CREATE zarch_i_m_travel1.  "TABLE TO CREATE NEW RECORD(bo type to add data)
    "--LOOPING EITH INDEX NO.
    lt_create = VALUE #( FOR row IN lt_result INDEX INTO idx
                         ( %cid = row-travelid
                         travelid  = lv_travel_id + idx
                         AgencyId = row-AgencyId
                         CustomerId = row-CustomerId
                         BeginDate = lv_today
                         EndDate  = lv_today + 30
                         BookingFee = row-BookingFee
                         TotalPrice = row-TotalPrice
                         CurrencyCode = row-CurrencyCode
                         Description = 'Auto created by copy'
                         Status = 'N'

                                )
                          ).


    "INSERT THE DATA USING EML INTO TRASACTION BUFFER
    MODIFY ENTITIES OF zarch_i_m_travel1 IN LOCAL MODE
ENTITY travel
CREATE FIELDS ( TravelId AgencyId CustomerId BeginDate TotalPrice CurrencyCode Description EndDate Status BookingFee )
WITH lt_create
MAPPED mapped
FAILED DATA(LT_failed)
REPORTED DATA(LT_reported).   "--failed and reported are default output parameter

*       BY USING THESE INTERNAL TABLE WILL RETURN THE DATA BACK TO FIELDS AND CREATED INSTANCES
    "BASE = IT IS USED FOR TYPE CASTING
    failed-travel = CORRESPONDING #( BASE ( failed-travel ) lt_failed-travel MAPPING TravelId = %cid  )   .
    reported-travel = CORRESPONDING #( BASE ( reported-travel ) lt_reported-travel MAPPING TravelId = %cid  )   .




*STEP4:  rEAD THE NEW CREATED DATA AND RETURN IN MAPPED STRUCTURE.

    READ ENTITIES OF zarch_i_m_travel1 IN LOCAL MODE
    ENTITY travel
    ALL FIELDS
    WITH CORRESPONDING #( mapped-travel )
    RESULT DATA(lt_READ_CREATED).

    "VALUE MAPPING TO OUTPUT STRUCTURE

    result = VALUE #( FOR key IN mapped-travel INDEX INTO indx
                         ( %cid_ref = keys[ KEY entity %key = key-%cid ]-%cid_ref
                         %key = key-%cid
                         %param-%tky = key-%tky   "--%TKY = INBUILT COMPLIER GENERATED PARAMETER EXIST(TO KNOW WHICH RECORD GETS AFFECTED
                          ) ).    "RECORD WILL DISPLAY NEXT TO EXISTING RECORD


    "MAPPING TO OUTPUT STRUCTURE TO CORREPSOND FEILDS TO DISPLAY DATA IN TABLE BCZ OF MASS COPY
    result = CORRESPONDING #( result FROM lt_read_created USING KEY
                   entity %key = %param-%key
                   MAPPING %param = %data EXCEPT * ).






  ENDMETHOD.

  METHOD get_instance_features.
    "WHEN RECORDS SELECTED THIS WILL TRIGGER

    "REDAING RECORDS
    READ ENTITIES OF zarch_i_m_travel1
  ENTITY travel
   FIELDS ( status )
   WITH CORRESPONDING #( keys )
  RESULT DATA(lt_result) FAILED failed.

    result = VALUE #( FOR ls_result IN lt_result (
                     %tky = ls_result-%tky

                     %features-%action-accepttravel = COND #( WHEN ls_result-status = 'A'
                                                              THEN if_abap_behv=>fc-o-disabled
                                                              ELSE if_abap_behv=>fc-o-enabled )
                    %features-%action-rejecttravel = COND #( WHEN ls_result-status = 'X'
                                                              THEN if_abap_behv=>fc-o-disabled
                                                              ELSE if_abap_behv=>fc-o-enabled )
                     )
                     ).

*//--DYNAMIC ACTION CONTROL(%features-%action-accepttravel)
*//%FIELD-TRAVELID = if_abap_behv=>FC-f-read_only  = TO MAKE FIELD GREY OUT IN DYNAMIC FIELD CONTROL
*       %FIELD-TRAVELID = if_abap_behv=>FC-f-read_only
  ENDMETHOD.

  METHOD accepttravel.
    "updating status field
    MODIFY ENTITIES OF zarch_i_m_travel1
    ENTITY travel
    UPDATE FIELDS ( Status )
    WITH VALUE #( FOR key IN keys ( %tky = key-%tky status = 'A' ) )
    FAILED failed
    REPORTED reported.

    "reading record in table
    READ ENTITIES OF zarch_i_m_travel1
    ENTITY travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    "reflecting back to result (using loops
    result = VALUE #( FOR travel IN lt_result ( %tky = travel-%tky %param = travel ) ).
ENDMETHOD.
    METHOD rejecttravel.

      MODIFY ENTITIES OF zarch_i_m_travel1
    ENTITY travel
    UPDATE FIELDS ( Status )
    WITH VALUE #( FOR key IN keys ( %tky = key-%tky status = 'X' ) )
    FAILED failed
    REPORTED reported.

      "reading record in table
      READ ENTITIES OF zarch_i_m_travel1
      ENTITY travel
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

      "reflecting back to result (using loops
      result = VALUE #( FOR travel IN lt_result ( %tky = travel-%tky %param = travel ) ).
      "%PARAM = HOLDS THE COMPLETE STRUCTURE VALUE
    ENDMETHOD.

  METHOD VALIDATECUSTOMER.

  "step1 : read the entity data customer id
      READ ENTITIES OF zarch_i_m_travel1 in LOCAL MODE
    ENTITY travel
     FIELDS ( CustomerId ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result)
    FAILED data(lt_failed).

    "step2:  mapped failed
    failed = CORRESPONDING #( DEEP lt_failed ).

    "step3: getting all the unique customer id to internal table
    data lt_customer TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    "looping discarding all the duplicated customer id
    lt_customer = CORRESPONDING #( lt_result DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).
    DELETE lt_customer WHERE customer_id is INITIAL.

    "step4:  select from customer master table and validating fetced info
    if lt_customer is NOT INITIAL.
    SELECT FROM /dmo/customer FIELDS customer_id
               FOR ALL ENTRIES IN @lt_customer
               WHERE customer_id = @lt_customer-customer_id
               into TABLE @data(lt_customer_db).
               endif.

               "step5:  loop at each travel record, chech if itab has that customerid
        LOOP at lt_result INTO DATA(ls_result).

        APPEND VALUE #( %tky = ls_result-%tky
                           %state_area = 'validate customer ' ) to reported-travel.

                           "step6: if not find throw error1
                           if ls_result-CustomerId is INITIAL.
                           APPEND VALUE #( %tky = ls_result-%tky ) to failed-travel.

         "step7: return the %tky, %stateare, %element. %msg
         APPEND VALUE #( %tky = ls_result-%tky
                           %state_area = 'validate customer '
                           %msg = new /dmo/cm_flight_messages(
                                                                textid = /dmo/cm_flight_messages=>enter_customer_id
                                                                severity = if_abap_behv_message=>severity-error )
                        %element-customerid = if_abap_behv=>mk-on ) TO reported-travel.   "--for showing red colour on input field if wrong(means highlighting)

"throwing error2 for customer not present in itab
      ELSEIF ls_result-customerid IS NOT INITIAL AND NOT line_exists( lt_customer_db[ customer_id = ls_result-customerid ] ).
        APPEND VALUE #(  %tky = ls_result-%tky ) TO failed-travel.

        APPEND VALUE #(  %tky                = ls_result-%tky
                         %state_area         = 'VALIDATE_CUSTOMER'
                         %msg                = NEW /dmo/cm_flight_messages(
                                                                customer_id = ls_result-CustomerId
                                                                textid = /dmo/cm_flight_messages=>customer_unkown
                                                                severity = if_abap_behv_message=>severity-error )
                         %element-customerid = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
     ENDLOOP.



  ENDMETHOD.

  METHOD VALIDATEDATES.
  READ ENTITIES OF zarch_i_m_travel1 IN LOCAL MODE
     ENTITY Travel
       FIELDS (  begindate enddate travelid )
       WITH CORRESPONDING #( keys )
     RESULT DATA(lt_travel)
     FAILED DATA(lt_failed).

    failed =  CORRESPONDING #( DEEP lt_failed  ).

    LOOP AT lt_travel INTO DATA(ls_travel).

      APPEND VALUE #(  %tky               = ls_travel-%tky
                       %state_area          = 'VALIDATE_DATES' ) TO reported-travel.
    " www.anubhavtrainings.com
      IF ls_travel-begindate IS INITIAL.
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #( %tky               = ls_travel-%tky
                        %state_area        = 'VALIDATE_DATES'
                         %msg                = NEW /dmo/cm_flight_messages(
                                                                textid = /dmo/cm_flight_messages=>enter_begin_date
                                                                severity = if_abap_behv_message=>severity-error )
                        %element-begindate = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
      IF ls_travel-enddate IS INITIAL.
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #( %tky               = ls_travel-%tky
                        %state_area        = 'VALIDATE_DATES'
                         %msg                = NEW /dmo/cm_flight_messages(
                                                                textid = /dmo/cm_flight_messages=>enter_end_date
                                                                severity = if_abap_behv_message=>severity-error )
                        %element-enddate   = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
      IF ls_travel-enddate < ls_travel-begindate AND ls_travel-begindate IS NOT INITIAL
                                                 AND ls_travel-enddate IS NOT INITIAL.
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #( %tky               = ls_travel-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW /dmo/cm_flight_messages(
                                                                textid = /dmo/cm_flight_messages=>begin_date_bef_end_date
                                                                begin_date = ls_travel-begindate
                                                                end_date   = ls_travel-enddate
                                                                severity = if_abap_behv_message=>severity-error )
                        %element-begindate = if_abap_behv=>mk-on
                        %element-enddate   = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
      IF ls_travel-begindate < cl_abap_context_info=>get_system_date( ) AND ls_travel-begindate IS NOT INITIAL.
        APPEND VALUE #( %tky               = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #( %tky               = ls_travel-%tky
                        %state_area        = 'VALIDATE_DATES'
                         %msg                = NEW /dmo/cm_flight_messages(
                                                                begin_date = ls_travel-begindate
                                                                textid = /dmo/cm_flight_messages=>begin_date_on_or_bef_sysdate
                                                                severity = if_abap_behv_message=>severity-error )
                        %element-begindate = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
      ENDLOOP.
  ENDMETHOD.

  METHOD VALIDATESTATUS.
    READ ENTITIES OF zarch_i_m_travel1 IN LOCAL MODE
    ENTITY Travel
    FIELDS (  status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_result)
    FAILED DATA(lt_failed).

        LOOP AT lt_travel_result INTO DATA(ls_travel_result).
          CASE ls_travel_result-status.
            WHEN 'O'.  " Open
            WHEN 'X'.  " Cancelled
            WHEN 'A'.  " Accepted
       when 'N'.
            WHEN OTHERS.

              APPEND VALUE #( %tky = ls_travel_result-%tky ) TO failed-travel.

              APPEND VALUE #( %tky = ls_travel_result-%tky
                              %msg = new_message_with_text(
                                       severity = if_abap_behv_message=>severity-error
                                       text     = 'Invalid Status'
                                     )
                              %element-status = if_abap_behv=>mk-on ) TO reported-travel.
          ENDCASE.
    " www.anubhavtrainings.com
        ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_create.
      " Mapping for already assigned travel IDs (e.g. during draft activation)
     mapped-travel = VALUE #( FOR entity IN entities WHERE ( travelid IS NOT INITIAL )
                                                          ( %cid      = entity-%cid
                                                            %is_draft = entity-%is_draft
                                                            %key      = entity-%key ) ).

    " This should be a number range. But for the demo purpose, avoiding the need to configure this in each and every system, we select the max value ...

    SELECT MAX( travel_id ) FROM /dmo/travel INTO @DATA(max_travel_id).
    SELECT MAX( travelid ) FROM zarch_dra_travel INTO @DATA(max_d_travel_id).  "//draft tabel

    IF max_d_travel_id > max_travel_id.  max_travel_id = max_d_travel_id.  ENDIF.

    " Mapping for newly assigned travel IDs
    mapped-travel = VALUE #( BASE mapped-travel FOR entity IN entities INDEX INTO i
                                                    USING KEY entity
                                                    WHERE ( travelid IS INITIAL )
                                                          ( %cid      = entity-%cid
                                                            %is_draft = entity-%is_draft
                                                            travelid  = max_travel_id + i ) ).
  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
        DATA: max_booking_id TYPE /dmo/booking_id.

"reading records
    READ ENTITIES OF zarch_i_m_travel1 IN LOCAL MODE
      ENTITY Travel BY \_Booking
        FIELDS ( bookingid )
          WITH CORRESPONDING #( entities )
          RESULT DATA(bookings)
          FAILED failed.


    LOOP AT entities INTO DATA(entity).
      CLEAR: max_booking_id.
      LOOP AT bookings INTO DATA(booking) USING KEY draft WHERE %is_draft = entity-%is_draft
                                                          AND   travelid  = entity-Travelid.
        IF booking-Bookingid > max_booking_id.
            max_booking_id = booking-Bookingid.
        ENDIF.
      ENDLOOP.
      " Map bookings that already have a BookingID.
      LOOP AT entity-%target INTO DATA(already_mapped_target) WHERE Bookingid IS NOT INITIAL.
        APPEND CORRESPONDING #( already_mapped_target ) TO mapped-booking.
        IF already_mapped_target-Bookingid > max_booking_id.
            max_booking_id = already_mapped_target-Bookingid.
        ENDIF.
      ENDLOOP.
      " Map bookings with new BookingIDs.
      LOOP AT entity-%target INTO DATA(target) WHERE Bookingid IS INITIAL.
        max_booking_id += 5.
        APPEND CORRESPONDING #( target ) TO mapped-booking ASSIGNING FIELD-SYMBOL(<mapped_booking>).
        <mapped_booking>-Bookingid = max_booking_id.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
