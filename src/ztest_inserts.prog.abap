report ztest_inserts.

include ztest_benchmark.

class lcl_app definition final.
  public section.

    methods append_last.
    methods insert_first.

    methods fill_table.
    methods delete_last.
    methods delete_first.
    methods delete_first_w_check.

    class-methods main.
    methods run
      importing
        iv_method type string.

    data mv_num_rounds type i.
    data mt_tab type string_table.

endclass.

class lcl_app implementation.

  method fill_table.

    clear mt_tab.
    data str type string.
    do 1000 times.
      str = |abcdefg123456789-{ sy-index }|.
      append str to mt_tab.
    enddo.

  endmethod.

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

  method delete_last.

    data lt_tab type string_table.
    data lv_size type i.
    lt_tab = mt_tab.

    do 1000 times.
      lv_size = lines( lt_tab ).
      delete lt_tab index lv_size.
    enddo.

  endmethod.

  method delete_first.

    data lt_tab type string_table.
    lt_tab = mt_tab.

    do 1000 times.
      delete lt_tab index 1.
    enddo.

  endmethod.

  method delete_first_w_check.

    data lt_tab type string_table.
    lt_tab = mt_tab.

    while lines( lt_tab ) > 0.
      delete lt_tab index 1.
    endwhile.

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

    lo_app->fill_table( ).
    lo_app->run( 'delete_last' ).
    lo_app->run( 'delete_first' ).
    lo_app->run( 'delete_first_w_check' ).

  endmethod.

endclass.

start-of-selection.

  lcl_app=>main( ).
