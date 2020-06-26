report ztest_json.

include ztest_benchmark.


class lcl_app definition inheriting from lcl_runner_base final.
  public section.

    methods describe.
    methods describe_w_comp.
    methods describe_smart.

    class-methods main.
    methods prepare.

    types:
      begin of ty_fragment,
        string type string,
        number type i,
        float type f,
      end of ty_fragment,
      tt_fragment type standard table of ty_fragment with default key,
      begin of ty_struc.
        include type ty_fragment.
        types:
        boolean type abap_bool,
        false type abap_bool,
        null type string,
        date type string,
        str1 type string,
        str2 type string,
        tab type tt_fragment,
        struc type ty_fragment,
      end of ty_struc.

endclass.

class lcl_app implementation.

  method prepare.
  endmethod.

  method describe.

    data ls_target type ty_struc.
    data lo_struc type ref to cl_abap_structdescr.
    lo_struc ?= cl_abap_typedescr=>describe_by_data( ls_target ).

    field-symbols <c> like line of lo_struc->components.
    loop at lo_struc->components assigning <c>.
    endloop.

  endmethod.

  method describe_smart.

    data ls_target type ty_struc.
    data lo_struc type ref to cl_abap_structdescr.
    data lo_type type ref to cl_abap_typedescr.
    lo_struc ?= cl_abap_typedescr=>describe_by_data( ls_target ).

    field-symbols <c> like line of lo_struc->components.
    loop at lo_struc->components assigning <c>.

      if <c>-type_kind = 'C' and <c>-length = 2.
        lo_type = lo_struc->get_component_type( <c>-name ).
      endif.

    endloop.

  endmethod.

  method describe_w_comp.

    data ls_target type ty_struc.
    data lo_struc type ref to cl_abap_structdescr.
    lo_struc ?= cl_abap_typedescr=>describe_by_data( ls_target ).

    data lt_comps type cl_abap_structdescr=>component_table.
    field-symbols <c> like line of lt_comps.

    lt_comps = lo_struc->get_components( ).
    loop at lt_comps assigning <c>.
    endloop.

  endmethod.

  method main.

    data lo_app type ref to lcl_app.
    create object lo_app.

    lo_app->prepare( ).
    lo_app->mv_num_rounds = 1000.

    lo_app->run( 'describe' ).
    lo_app->run( 'describe_smart' ).
    lo_app->run( 'describe_w_comp' ).

  endmethod.

endclass.

start-of-selection.

  lcl_app=>main( ).
