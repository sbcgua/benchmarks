report ztest_misc.

include ztest_benchmark.

class lcl_app definition final inheriting from lcl_runner_base.
  public section.

    methods test_concat.
    methods test_join.
    methods test_join_s.
    methods test_pattern.
    class-methods main.
endclass.

class lcl_app implementation.

  method test_concat.

    data lv_s type string.
    data lv_t type string.
    do 1000 times.
      lv_t = sy-index.
      concatenate 'hello' 'world' lv_t into lv_s.
    enddo.

  endmethod.

  method test_join.

    data lv_s type string.
    do 1000 times.
      lv_s = 'hello' && 'world' && sy-index.
    enddo.

  endmethod.

  method test_join_s.

    data lv_s type string.
    do 1000 times.
      lv_s = `hello` && `world` && sy-index.
    enddo.

  endmethod.

  method test_pattern.

    data lv_s type string.
    do 1000 times.
      lv_s = |hello world { sy-index }|.
    enddo.

  endmethod.

  method main.

    data lo_app type ref to lcl_app.
    create object lo_app.

    lo_app->mv_num_rounds = 1000.

    lo_app->run( 'test_concat' ).
    lo_app->run( 'test_join' ).
    lo_app->run( 'test_join_s' ).
    lo_app->run( 'test_pattern' ).

  endmethod.

endclass.

start-of-selection.

  lcl_app=>main( ).
