(* Test First_readable_addr. *)

MODULE Main;

IMPORT F0, F1, F4095, F4096, F4095x8, F4096x8;

PROCEDURE F2(t: REF F0.T) =
BEGIN
  EVAL F0.F1(t);
  EVAL F1.F1(t);
  EVAL F4095.F1(t);
  EVAL F4096.F1(t);
  EVAL F4095x8.F1(t);
  EVAL F4096x8.F1(t);
END F2;

BEGIN
 F2(NEW(REF F0.T));
END Main.
