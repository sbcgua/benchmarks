REPORT ZTEST102.

include ztest_benchmark.


class lcl_app definition final.
  public section.

    types:
      begin of ty_pair,
        key type char80,
        val type char80,
      end of ty_pair,
      tt_pair type standard table of ty_pair with default key,
      ts_pair type sorted table of ty_pair with unique key key,
      th_pair type hashed table of ty_pair with unique key key.

    methods prepare.
    methods run
      importing
        iv_method type string.

    methods std.
    methods std_bin.
    methods sorted.
    methods sorted_tk.
    methods hashed.
    methods hashed_tk.
    class-methods main.

    data mt_std type tt_pair.
    data mt_sorted type ts_pair.
    data mt_hashed type th_pair.
    data mt_lookups type tt_pair.

endclass.

class lcl_app implementation.

  method prepare.

    data val type char80.
    field-symbols <i> like line of mt_std.

    do 100000 times.
      val = sy-index.
      append initial line to mt_std assigning <i>.
      <i>-key = val.
      <i>-val = val.
      if val mod 200 = 0.
        append <i> to mt_lookups.
      endif.
    enddo.

    mt_sorted = mt_std.
    mt_hashed = mt_std.

  endmethod.

  method std.

    field-symbols <i> like line of mt_lookups.
    loop at mt_lookups assigning <i>.
      read table mt_lookups transporting no fields
        with key
          key = <i>-key.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method std_bin.

    field-symbols <i> like line of mt_lookups.
    loop at mt_lookups assigning <i>.
      read table mt_lookups transporting no fields
        binary search
        with key
          key = <i>-key.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method sorted.

    field-symbols <i> like line of mt_lookups.
    loop at mt_lookups assigning <i>.
      read table mt_sorted transporting no fields
        with key
          key = <i>-key.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method sorted_tk.

    field-symbols <i> like line of mt_lookups.
    loop at mt_lookups assigning <i>.
      read table mt_sorted transporting no fields
        with table key
          key = <i>-key.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method hashed.

    field-symbols <i> like line of mt_lookups.
    loop at mt_lookups assigning <i>.
      read table mt_hashed transporting no fields
        with key
          key = <i>-key.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method hashed_tk.

    field-symbols <i> like line of mt_lookups.
    loop at mt_lookups assigning <i>.
      read table mt_hashed transporting no fields
        with key
          key = <i>-key.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method run.

    data lo_benchmark type ref to lcl_benchmark.
    data lv_times type i value 100.

    create object lo_benchmark
      exporting
        io_object = me
        iv_method = iv_method
        iv_times  = lv_times.

    lo_benchmark->run( ).
    lo_benchmark->print( ).

  endmethod.

  method main.

    data lo_app type ref to lcl_app.
    create object lo_app.
    lo_app->prepare( ).
    lo_app->run( 'std' ).
    lo_app->run( 'std_bin' ).
    lo_app->run( 'sorted' ).
    lo_app->run( 'sorted_tk' ).
    lo_app->run( 'hashed' ).
    lo_app->run( 'hashed_tk' ).

  endmethod.

endclass.

start-of-selection.

  lcl_app=>main( ).
