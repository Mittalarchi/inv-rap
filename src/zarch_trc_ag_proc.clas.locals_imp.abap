CLASS lhc_zarch_i_m_processor DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment_create FOR MODIFY
      IMPORTING entities FOR CREATE zarch_i_m_processor.

ENDCLASS.

CLASS lhc_zarch_i_m_processor IMPLEMENTATION.

  METHOD augment_create.
       DATA: travel_create TYPE TABLE FOR CREATE zarch_i_m_travel1.

    travel_create = CORRESPONDING #( entities ).
    LOOP AT travel_create ASSIGNING FIELD-SYMBOL(<travel>).
      <travel>-agencyid = '070012'.
      <travel>-status  = 'O'.
      <travel>-%control-agencyid = if_abap_behv=>mk-on.
      <travel>-%control-status = if_abap_behv=>mk-on.
    ENDLOOP.

    MODIFY AUGMENTING ENTITIES OF zarch_i_m_travel1 ENTITY Travel CREATE FROM travel_create.
  ENDMETHOD.

ENDCLASS.
