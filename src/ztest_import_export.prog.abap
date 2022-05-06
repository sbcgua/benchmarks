report ztest_import_export.

include ztest_benchmark.

class lcl_app definition inheriting from lcl_runner_base final.
  public section.

    methods move.
    methods export_small.
    methods export_med.
    methods export_large.
    methods import_small.
    methods import_med.
    methods import_large.

    class-methods main.
    methods prepare.

    types:
      begin of ty_rec,
        key type string,
        str type string,
        xstr type xstring,
      end of ty_rec,
      tt_set type standard table of ty_rec with default key.

    data mt_large_data type tt_set.
    data mt_med_data type tt_set.

endclass.

class lcl_app implementation.

  method prepare.

    field-symbols <i> like line of mt_large_data.
    data lv_str type string.
    data lv_xstr type xstring.

    lv_str = repeat( val = 'a' occ = 100000 ).
    lv_xstr = cl_abap_codepage=>convert_to( source = lv_str ).

    append initial line to mt_med_data assigning <i>.
    <i>-str = lv_str.
    <i>-xstr = lv_xstr.

    do 10 times.
      append initial line to mt_large_data assigning <i>.
      <i>-key = |{ sy-index }|.
      <i>-str = lv_str.
      <i>-xstr = lv_xstr.
    enddo.

  endmethod.

  method move.

    data v like mt_large_data.

    do 10 times.
      v = mt_large_data.
    enddo.

  endmethod.

  method export_small.

    data lv_i type i value '10'.
    data lv_t type timestamp.
    get time stamp field lv_t.

    do 10 times.
      export int = lv_i ts = lv_t to memory id 'zbench:small'.
    enddo.

  endmethod.

  method export_med.

    do 10 times.
      export data = mt_med_data to memory id 'zbench:med'.
    enddo.

  endmethod.

  method export_large.

    do 10 times.
      export data = mt_large_data to memory id 'zbench:large'.
    enddo.

  endmethod.

  method import_small.

    data lv_i type i.
    data lv_t type timestamp.

    do 10 times.
      import int = lv_i ts = lv_t from memory id 'zbench:small'.
    enddo.

  endmethod.

  method import_med.

    data v like mt_med_data.

    do 10 times.
      import data = v from memory id 'zbench:med'.
    enddo.

  endmethod.

  method import_large.

    data v like mt_large_data.

    do 10 times.
      import data = v from memory id 'zbench:large'.
    enddo.

  endmethod.

  method main.

    data lo_app type ref to lcl_app.
    create object lo_app.

    lo_app->prepare( ).
    lo_app->mv_num_rounds = 100.

    lo_app->run( 'move' ).
    lo_app->run( 'export_small' ).
    lo_app->run( 'export_med' ).
    lo_app->run( 'export_large' ).
    lo_app->run( 'import_small' ).
    lo_app->run( 'import_med' ).
    lo_app->run( 'import_large' ).

  endmethod.

endclass.

start-of-selection.

  lcl_app=>main( ).
