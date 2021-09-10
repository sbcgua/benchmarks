report ztest_cascade_append.

include ztest_benchmark.

class lcl_app definition final.
  public section.

    methods setter1
      importing
        depth type i default 0
      changing
        ct_nodes type zif_ajson=>ty_nodes_tt.

    methods setter2
      importing
        depth type i default 0
      changing
        ct_nodes type zif_ajson=>ty_nodes_tt.

    methods test_setter1.
    methods test_setter2.

    class-methods main.
    methods run
      importing
        iv_method type string.

    data mv_num_rounds type i.

endclass.

class lcl_app implementation.

  method setter1.

    check depth <= 3.

    append initial line to ct_nodes.
    append initial line to ct_nodes.

    setter1(
      exporting
        depth = depth + 1
      changing
        ct_nodes = ct_nodes ).

  endmethod.

  method setter2.

    check depth <= 3.

    append initial line to ct_nodes.
    append initial line to ct_nodes.

    data lt_nodes like ct_nodes.
    setter1(
      exporting
        depth = depth + 1
      changing
        ct_nodes = lt_nodes ).
    append lines of lt_nodes to ct_nodes.

  endmethod.


  method test_setter1.

    data lt_nodes type zif_ajson=>ty_nodes_tt.
    do 1000 times.
      setter1( changing ct_nodes = lt_nodes ).
    enddo.

  endmethod.

  method test_setter2.

    data lt_nodes type zif_ajson=>ty_nodes_tt.
    do 1000 times.
      setter2( changing ct_nodes = lt_nodes ).
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

    lo_app->run( 'test_setter1' ).
    lo_app->run( 'test_setter2' ).

  endmethod.

endclass.

start-of-selection.

  lcl_app=>main( ).
