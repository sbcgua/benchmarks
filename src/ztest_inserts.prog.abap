report ztest_inserts.

include ztest_benchmark.

class lcl_app definition final.
  public section.

    methods append_last.
    methods insert_first.

    class-methods main.
    methods run
      importing
        iv_method type string.

    data mv_num_rounds type i.

endclass.

class lcl_app implementation.

  method append_last.

    data lt_tab type string_table.
    data str type string.
    do 1000 times.
      str = |abcdefg123456789-{ sy-index }|.
      append str to lt_tab.
    enddo.

  endmethod.

  method insert_first.

    data lt_tab type string_table.
    data str type string.
    do 1000 times.
      str = |abcdefg123456789-{ sy-index }|.
      insert str into lt_tab index 1.
    enddo.

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

    lo_app->mv_num_rounds = 1000.

    lo_app->run( 'append_last' ).
    lo_app->run( 'insert_first' ).

  endmethod.

endclass.

start-of-selection.

  lcl_app=>main( ).
