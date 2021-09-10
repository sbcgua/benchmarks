report ztest_try_catch.

include ztest_benchmark.

class lcx definition inheriting from cx_static_check.
  public section.
    data aux type i.
endclass.

class lcl_app definition final.
  public section.

    methods raiser
      importing
        do_raise type abap_bool default abap_false
      raising
        lcx.

    methods no_try_catch raising lcx.
    methods with_try_catch.
    methods raise_it raising lcx.
    methods raise_it_with_hijack raising lcx.

    class-methods main.
    methods run
      importing
        iv_method type string.

    data mv_num_rounds type i.

endclass.

class lcl_app implementation.

  method raiser.
    if do_raise = abap_true.
      raise exception type lcx.
    endif.
  endmethod.

  method no_try_catch.

    do 1000 times.
      raiser( ).
    enddo.

  endmethod.

  method with_try_catch.

    data lx type ref to lcx.

    do 1000 times.
      try .
        raiser( ).
      catch lcx into lx.
        lx->get_text( ).
      endtry.
    enddo.

  endmethod.

  method raise_it.

    data lx type ref to lcx.
    data tmp type i.

    do 1000 times.
      try .
        raiser( abap_true ).
      catch lcx into lx.
        tmp = lx->aux.
      endtry.
    enddo.

  endmethod.

  method raise_it_with_hijack.

    data lx type ref to lcx.
    data tmp type i.

    do 1000 times.
      try.
        try.
          raiser( abap_true ).
        catch lcx into lx.
          lx->aux = 1.
          raise exception lx.
        endtry.
      catch lcx into lx.
        tmp = lx->aux.
      endtry.
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

    lo_app->mv_num_rounds = 2000.

    lo_app->run( 'no_try_catch' ).
    lo_app->run( 'with_try_catch' ).
    lo_app->run( 'raise_it' ).
    lo_app->run( 'raise_it_with_hijack' ).

  endmethod.

endclass.

start-of-selection.

  lcl_app=>main( ).
