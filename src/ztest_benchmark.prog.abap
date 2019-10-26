class lcl_benchmark definition final.
  public section.
    methods constructor
      importing
        io_object type ref to object
        iv_method type string
        iv_times  type i.
    methods run.
    methods print.

  private section.
    data mo_object type ref to object.
    data mv_method type string.
    data mv_times type i.
    data mv_diff type p decimals 6.
endclass.

class lcl_benchmark implementation.

  method constructor.
    mo_object = io_object.
    mv_method = to_upper( iv_method ).
    mv_times = iv_times.
  endmethod.

  method run.
    data:
      lv_sta_time     type timestampl,
      lv_end_time     type timestampl.

    get time stamp field lv_sta_time.
    do mv_times times.
      call method mo_object->(mv_method).
    enddo.
    get time stamp field lv_end_time.
    mv_diff  = lv_end_time - lv_sta_time.

  endmethod.

  method print.
    write: /(30) mv_method, 'results', mv_diff  exponent 0.
    uline.
  endmethod.

endclass.
