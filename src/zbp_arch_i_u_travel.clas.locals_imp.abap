CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES tt_travel_failed TYPE TABLE FOR FAILED zarch_i_u_travel.
    TYPES tt_travel_reported TYPE TABLE FOR REPORTED zarch_i_u_travel.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR travel RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE travel.

    METHODS read FOR READ
      IMPORTING keys FOR READ travel RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK travel.
    METHODS set_book_status FOR MODIFY
      IMPORTING keys FOR ACTION travel~set_book_status RESULT result.

*      //MAP MESSAGES FROM OUR OLD TO RAP MESSAGES
      METHODS map_message
      IMPORTING
      cid TYPE string OPTIONAL
      travelid TYPE /dmo/travel_id OPTIONAL
      messages TYPE /dmo/t_message
      EXPORTING
      failed_added TYPE abap_bool
      CHANGING
      failed TYPE tt_travel_failed
      reported TYPE tt_travel_reported.

ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

  data : messages TYPE /dmo/t_message,
         travel_in type /dmo/travel,
           travel_out type /dmo/travel.

*     step1:      "loop at all data come from fiori app
LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel_create>).
"step 2: map the data which was received to input structure

travel_in = CORRESPONDING #( <travel_create> MAPPING FROM ENTITY USING CONTROL ).

*"step 3 imagine in your company you have old code- fm,class, report,etc.
"getting input field from ui and then ouput
/dmo/cl_flight_legacy=>get_instance(  )->create_travel(
  EXPORTING
    is_travel             = CORRESPONDING /dmo/s_travel_in( travel_in )
*    it_booking            =
*    it_booking_supplement =
*    iv_numbering_mode     = /dmo/if_flight_legacy=>numbering_mode-early
  IMPORTING
    es_travel             = travel_out
*    et_booking            =
*    et_booking_supplement =
    et_messages           = data(lt_message)
).

*for converting message if get
/dmo/cl_flight_legacy=>get_instance(  )->convert_messages(
  EXPORTING
    it_messages = lt_message
  IMPORTING
    et_messages = messages
).


"local function to pass messages to rap framework
map_message(
  EXPORTING
    cid          = <travel_create>-%cid
*    travelid     =
    messages     = messages
  IMPORTING
    failed_added = data(failed_add)
  CHANGING
    failed       = failed-travel
    reported     = reported-travel
).


*if there is no error creating travel id , means adding
*temporary key which is created can now be changed permanent travel id
if failed_add = abap_false.

INSERT VALUE #( %cid = <travel_create>-%cid
   travelid = travel_out-travel_id
 ) INTO table mapped-travel.
ENDIF.
ENDLOOP.



  ENDMETHOD.

  METHOD update.
     DATA: messages TYPE /dmo/t_message,
          travel   TYPE /dmo/travel,
          travelx  TYPE /dmo/s_travel_inx. "refers to x structure (> BAPIs)

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel_update>).

*      travel = CORRESPONDING #( <travel_update> MAPPING FROM ENTITY ).
*
*      travelx-travel_id = <travel_update>-TravelID.
*      travelx-_intx     = CORRESPONDING #( <travel_update> MAPPING FROM ENTITY ).
*

      call FUNCTION '/DMO/FLIGHT_TRAVEL_DELETE'
        EXPORTING
          iv_travel_id = <travel_update>-TravelID
        IMPORTING
          et_messages  = messages.


      "instead of this we can call function also

*      /dmo/cl_flight_legacy=>get_instance( )->update_travel(
*        EXPORTING
*          is_travel              = CORRESPONDING /dmo/s_travel_in( travel )
*          is_travelx             = travelx
*        IMPORTING
*           et_messages            =  data(lt_messages)
*      ).

*      /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages = lt_messages
*                                                        IMPORTING et_messages = messages ).


      map_message(
          EXPORTING
            cid       = <travel_update>-%cid_ref
            travelid = <travel_update>-travelid
            messages  = messages
          CHANGING
            failed    = failed-travel
            reported  = reported-travel
        ).

    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA: messages TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<travel_delete>).

*      /dmo/cl_flight_legacy=>get_instance( )->delete_travel(
*        EXPORTING
*          iv_travel_id = <travel_delete>-travelid
*        IMPORTING
*          et_messages  = data(lt_messages)
*      ).
*
*     /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages = lt_messages
*                                                        IMPORTING et_messages = messages ).

call FUNCTION '/DMO/FLIGHT_TRAVEL_DELETE'
  EXPORTING
    iv_travel_id = <travel_delete>-travelid
  IMPORTING
    et_messages  = messages
  .


      map_message(
          EXPORTING
            cid       = <travel_delete>-%cid_ref
            travelid = <travel_delete>-travelid
            messages  = messages
          CHANGING
            failed    = failed-travel
            reported  = reported-travel
        ).
  ENDLOOP.
  ENDMETHOD.

  METHOD read.
"WITHOUT READ UPDATE AND ACTION BUTTON WILL NOT WORK
      DATA: travel_out TYPE /dmo/travel,
          messages   TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<travel_to_read>) GROUP BY <travel_to_read>-%tky.


        /dmo/cl_flight_legacy=>get_instance( )->get_travel( EXPORTING iv_travel_id          = <travel_to_read>-travelid
                                                                      iv_include_buffer     = ABAP_FALSE
                                                      IMPORTING es_travel             = travel_out
                                                                et_messages           = DATA(lt_messages) ).

        /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages = lt_messages
                                                            IMPORTING et_messages = messages ).

      map_message(
          EXPORTING
            travelid        = <travel_to_read>-TravelID
            messages         = messages
          IMPORTING
            failed_added = DATA(failed_added)
          CHANGING
            failed           = failed-travel
            reported         = reported-travel
        ).

      IF failed_added = abap_false.
        INSERT CORRESPONDING #( travel_out MAPPING TO ENTITY ) INTO TABLE result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD map_message.
FAILED_ADDED = ABAP_FALSE.

LOOP AT messages INTO DATA(message).
if message-msgty = 'E' OR message-msgty = 'A'.
*//LOOP AT THE DATA COMMING FROM UI AND UPDATING CID AAND ALL FIELD AND PASSING TO FAILED AS INDICATOR
APPEND VALUE #( %CID = CID
                  TRAVELID = TRAVELID
                  %FAIL-CAUSE = /dmo/cl_travel_auxiliary=>get_cause_from_message(
                                  msgid        = message-msgid
                                  msgno        = message-msgno
*                                  is_dependend = abap_false
                                )  )
TO failed.
FAILED_ADDED = ABAP_TRUE.
ENDIF.


*//APPENDING MEW MESSAGE TO REPORTED WITH CID AND ALL
APPEND VALUE #( %MSG = new_message(
                         id       = message-msgid
                         number   = message-msgno
                         severity = if_abap_behv_message=>severity-error
                         v1       = message-msgv1
                         v2       = message-msgv2
                         v3       = message-msgv3
                         v4       = message-msgv4
                       )
                     %CID = CID
                       TRAVELID = travelid

                        ) TO REPORTED.

ENDLOOP.
  ENDMETHOD.

  METHOD set_book_status.
   DATA: messages                 TYPE /dmo/t_message,
          travel_out               TYPE /dmo/travel,
          travel_set_status_booked LIKE LINE OF result.

    CLEAR result.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<travel_set_status_booked>).

      DATA(travelid) = <travel_set_status_booked>-travelid.


      /dmo/cl_flight_legacy=>get_instance( )->set_status_to_booked( EXPORTING iv_travel_id = travelid
                                                                IMPORTING et_messages  = DATA(lt_messages) ).

      /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages  = lt_messages
                                                            IMPORTING et_messages  = messages ).

      map_message(
          EXPORTING
            travelid        = <travel_set_status_booked>-TravelID
            messages         = messages
          IMPORTING
            failed_added = DATA(failed_added)
          CHANGING
            failed           = failed-travel
            reported         = reported-travel
        ).

      IF failed_added = abap_false.

        /dmo/cl_flight_legacy=>get_instance( )->get_travel( EXPORTING iv_travel_id          = travelid
                                                                      iv_include_buffer     = ABAP_FALSE
                                                      IMPORTING es_travel             = travel_out ).

        travel_set_status_booked-travelid        = travelid.
        travel_set_status_booked-%param          = CORRESPONDING #( travel_out MAPPING TO ENTITY ).
        travel_set_status_booked-%param-travelid = travelid.   "%param = tell fiori ui , corresponding to which record data got changed
        APPEND travel_set_status_booked TO result.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.



ENDCLASS.

CLASS lsc_ZARCH_I_U_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZARCH_I_U_TRAVEL IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  "save the data from transfer buffer
  /dmo/cl_flight_legacy=>get_instance(  )->save(  ).
  ENDMETHOD.

  METHOD cleanup.
  "for cleaning buffer
   /dmo/cl_flight_legacy=>get_instance(  )->initialize(  ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
