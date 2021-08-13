report ztest_json2.

include ztest_benchmark.


class lcl_app definition final.
  public section.

    methods plain_obj.
    methods deep_obj.
    methods array.

    methods plain_obj_aj.
    methods deep_obj_aj.
    methods array_aj.

    class-methods main.
    methods prepare.
    methods run
      importing
        iv_method type string.

    data mv_num_rounds type i.

    data mv_plain_obj type string.
    data mv_deep_obj type string.
    data mv_array type string.

    types:
      begin of ty_fragment,
        string type string,
        number type i,
        float type f,
      end of ty_fragment,
      tt_fragment type standard table of ty_fragment with default key,
      begin of ty_plain.
        include type ty_fragment.
        types:
        boolean type abap_bool,
        false type abap_bool,
        null type string,
        date type string, " ??? TODO
        str1 type string,
        str2 type string,
      end of ty_plain,
      begin of ty_deep1.
        include type ty_fragment.
        types: deep type ty_fragment,
      end of ty_deep1,
      begin of ty_deep2.
        include type ty_fragment.
        types: deep type ty_deep1,
      end of ty_deep2,
      begin of ty_deep3.
        include type ty_fragment.
        types: deep type ty_deep2,
      end of ty_deep3.

endclass.

class lcl_app implementation.

  method prepare.
    mv_plain_obj =
      '{' &&
      '  "string": "abc",' &&
      '  "number": 123,' &&
      '  "float": 123.45,' &&
      '  "boolean": true,' &&
      '  "false": false,' &&
      '  "null": null,' &&
      '  "date": "2020-03-15",' &&
      '  "str1": "hello",' &&
      '  "str2": "world"' &&
      '}'.

    mv_deep_obj =
      '{' &&
      '    "string": "abc",' &&
      '    "number": 123,' &&
      '    "float": 123.45,' &&
      '    "deep" : {' &&
      '        "string": "abc",' &&
      '        "number": 223,' &&
      '        "float": 123.45,' &&
      '        "deep" : {' &&
      '            "string": "abc",' &&
      '            "number": 323,' &&
      '            "float": 123.45,' &&
      '            "deep" : {' &&
      '                "string": "abc",' &&
      '                "number": 423,  ' &&
      '                "float": 123.45 ' &&
      '            }' &&
      '        }' &&
      '    }' &&
      '}'.

    mv_array = '['.
    do 10 times.
      if sy-index <> 1.
        mv_array = mv_array && `, `.
      endif.
      mv_array = mv_array &&
        '{' &&
        '    "string": "abc", ' &&
        '    "number": 123,   ' &&
        '    "float": 123.45  ' &&
        '}'.
    enddo.
    mv_array = mv_array && ']'.


  endmethod.

  method plain_obj.

    data lo_json type ref to zif_ajson.
    data ls_target type ty_plain.
    lo_json = zcl_ajson=>parse( mv_plain_obj ).
    lo_json->to_abap( importing ev_container = ls_target ).

  endmethod.

  method deep_obj.

    data lo_json type ref to zif_ajson.
    data ls_target type ty_deep3.
    lo_json = zcl_ajson=>parse( mv_deep_obj ).
    lo_json->to_abap( importing ev_container = ls_target ).

  endmethod.

  method array.

    data lo_json type ref to zif_ajson.
    data ls_target type tt_fragment.
    lo_json = zcl_ajson=>parse( mv_array ).
    lo_json->to_abap( importing ev_container = ls_target ).

  endmethod.

  method plain_obj_aj.

    data lo_json type ref to zcl_json.
    create object lo_json.

    data ls_target type ty_plain.
    lo_json->decode(
      exporting
        json = mv_plain_obj
      changing
        value = ls_target ).

  endmethod.

  method deep_obj_aj.

    data lo_json type ref to zcl_json.
    create object lo_json.

    data ls_target type ty_deep3.
    lo_json->decode(
      exporting
        json = mv_deep_obj
      changing
        value = ls_target ).

  endmethod.

  method array_aj.

    data lo_json type ref to zcl_json.
    create object lo_json.

    data ls_target type tt_fragment.
    lo_json->decode(
      exporting
        json = mv_array
      changing
        value = ls_target ).

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
    lo_app->mv_num_rounds = 1000.

    lo_app->run( 'plain_obj' ).
    lo_app->run( 'deep_obj' ).
    lo_app->run( 'array' ).

    lo_app->run( 'plain_obj_aj' ).
    lo_app->run( 'deep_obj_aj' ).
    lo_app->run( 'array_aj' ).

  endmethod.

endclass.

start-of-selection.

  lcl_app=>main( ).
