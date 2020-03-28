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
      tsnu_pair type sorted table of ty_pair with non-unique key key,
      th_pair type hashed table of ty_pair with unique key key.

    types:
      begin of ty_long,
        key1 type char80,
        key2 type char80,
        key3 type char80,
        key4 type char80,
        val type char80,
      end of ty_long,
      tt_long type standard table of ty_long with default key,
      ts_long type sorted table of ty_long with unique key key1 key3 key4,
      th_long type hashed table of ty_long with unique key key1 key3 key4.


    methods prepare.
    methods run
      importing
        iv_method type string.

    methods std.
    methods std_bin.
    methods sorted.
    methods sorted_tk.
    methods sorted_nu.
    methods hashed.
    methods hashed_tk.

    methods long_std.
    methods long_std_bin.
    methods long_sorted.
    methods long_hashed.
    methods long_std_part.
    methods long_sorted_part.

    methods loop_all.
    methods loop_std.
    methods loop_sorted.
    methods loop_std_starting.
    methods loop_sorted_starting.

    class-methods main.

    data mt_std type tt_pair.
    data mt_sorted type ts_pair.
    data mt_sorted_nu type tsnu_pair.
    data mt_hashed type th_pair.
    data mt_lookups type tt_pair.

    data mt_long_std type tt_long.
    data mt_long_sorted type ts_long.
    data mt_long_hashed type th_long.
    data mt_long_lookups type tt_long.

    data mv_num_rounds type i.

endclass.

class lcl_app implementation.

  method prepare.

    data val type char80.
    field-symbols <i> like line of mt_std.

    do 125000 times.
      val = sy-index.
      append initial line to mt_std assigning <i>.
      <i>-key = val.
      <i>-val = val.
      if val mod 1000 = 0.
        append <i> to mt_lookups.
      endif.
    enddo.

    mt_sorted = mt_std.
    mt_sorted_nu = mt_std.
    mt_hashed = mt_std.

**********************************************************************

    data j like line of mt_long_std.

    do 50 times.
      j-key1 = sy-index.
      do 1 times.
        j-key2 = sy-index.
        do 50 times.
          j-key3 = sy-index.
          do 50 times.
            j-key4 = sy-index.
            j-val  = sy-index.
            append j to mt_long_std.
            if j-key1 mod 10 = 0 and j-key3 mod 10 = 0 and j-key4 mod 10 = 0.
              append j to mt_long_lookups.
            endif.
          enddo.
        enddo.
      enddo.
    enddo.

    mt_long_sorted = mt_long_std.
    mt_long_hashed = mt_Long_std.

  endmethod.

  method std.

    field-symbols <i> like line of mt_lookups.
    loop at mt_lookups assigning <i>.
      read table mt_std transporting no fields
        with key
          key = <i>-key.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method std_bin.

    field-symbols <i> like line of mt_lookups.
    loop at mt_lookups assigning <i>.
      read table mt_std transporting no fields
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

  method sorted_nu.

    field-symbols <i> like line of mt_lookups.
    loop at mt_lookups assigning <i>.
      read table mt_sorted_nu transporting no fields
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

  method long_std.

    field-symbols <i> like line of mt_long_lookups.
    loop at mt_long_lookups assigning <i>.
      read table mt_long_std transporting no fields
        with key
          key1 = <i>-key1
          key2 = <i>-key2
          key3 = <i>-key3
          key4 = <i>-key4.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method long_std_part.

    field-symbols <i> like line of mt_long_lookups.
    loop at mt_long_lookups assigning <i>.
      read table mt_long_std transporting no fields
        with key
          key1 = <i>-key1.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method long_std_bin.

    field-symbols <i> like line of mt_long_lookups.
    loop at mt_long_lookups assigning <i>.
      read table mt_long_std transporting no fields
        binary search
        with key
          key1 = <i>-key1
          key2 = <i>-key2
          key3 = <i>-key3
          key4 = <i>-key4.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method long_sorted.

    field-symbols <i> like line of mt_long_lookups.
    loop at mt_long_lookups assigning <i>.
      read table mt_long_sorted transporting no fields
        with key
          key1 = <i>-key1
          key2 = <i>-key2
          key3 = <i>-key3
          key4 = <i>-key4.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method long_sorted_part.

    field-symbols <i> like line of mt_long_lookups.
    loop at mt_long_lookups assigning <i>.
      read table mt_long_sorted transporting no fields
        with key
          key1 = <i>-key1.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method long_hashed.

    field-symbols <i> like line of mt_long_lookups.
    loop at mt_long_lookups assigning <i>.
      read table mt_long_hashed transporting no fields
        with key
          key1 = <i>-key1
          key2 = <i>-key2
          key3 = <i>-key3
          key4 = <i>-key4.
      assert sy-subrc = 0.
    endloop.

  endmethod.

  method loop_all.

    field-symbols <i> like line of mt_long_std.
    data ls_a like <i>-key1.
    loop at mt_long_std assigning <i>.
      ls_a = <i>-key1.
    endloop.

  endmethod.

  method loop_std.

    field-symbols <i> like line of mt_long_std.
    data ls_a like <i>-key1.
    loop at mt_long_std assigning <i> where key1 = '25'.
      ls_a = <i>-key1.
    endloop.

  endmethod.

  method loop_sorted.

    field-symbols <i> like line of mt_long_sorted.
    data ls_a like <i>-key1.
    loop at mt_long_sorted assigning <i> where key1 = '25'.
      ls_a = <i>-key1.
    endloop.

  endmethod.

  method loop_std_starting.

    field-symbols <i> like line of mt_long_std.
    data ls_a like <i>-key1.
    loop at mt_long_std assigning <i> where key1 cp '2*'.
      ls_a = <i>-key1.
    endloop.

  endmethod.

  method loop_sorted_starting.

    field-symbols <i> like line of mt_long_sorted.
    data ls_a like <i>-key1.
    loop at mt_long_sorted assigning <i> where key1 cp '2*'.
      ls_a = <i>-key1.
    endloop.

  endmethod.

  method run.

    data lo_benchmark type ref to lcl_benchmark.

    create object lo_benchmark
      exporting
        io_object = me
        iv_method = iv_method
        iv_times  = mv_num_rounds.

    lo_benchmark->run( ).
    lo_benchmark->print( ).

  endmethod.

  method main.

    data lo_app type ref to lcl_app.
    create object lo_app.

    lo_app->prepare( ).
    lo_app->mv_num_rounds = 10.

    lo_app->run( 'std' ).
    lo_app->run( 'std_bin' ).
    lo_app->run( 'sorted' ).
    lo_app->run( 'sorted_tk' ).
    lo_app->run( 'sorted_nu' ).
    lo_app->run( 'hashed' ).
    lo_app->run( 'hashed_tk' ).

    lo_app->run( 'long_std' ).
    lo_app->run( 'long_std_bin' ).
    lo_app->run( 'long_sorted' ).
    lo_app->run( 'long_hashed' ).
    " lo_app->run( 'long_std_part' ).
    lo_app->run( 'long_sorted_part' ).

    lo_app->run( 'loop_all' ).
    lo_app->run( 'loop_std' ).
    lo_app->run( 'loop_sorted' ).
    lo_app->run( 'loop_std_starting' ).
    lo_app->run( 'loop_sorted_starting' ).

  endmethod.

endclass.

start-of-selection.

  lcl_app=>main( ).
