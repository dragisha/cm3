GENERIC INTERFACE ComplexFmtLex(RF,C);
(*Copyright (c) 1996, m3na project

Abstract: Formatting and parsing complex numbers

1/1/96  Harry George    Initial version
2/17/96 Harry George    Converted from Objects to ADT's
3/23/96 Harry George    Incorporated Warren Smith's implementations
*)

(*FROM NADefinitions IMPORT Error;*)
FROM FmtLexSupport IMPORT Precedence;

(*==========================*)
TYPE
  T = C.T;
  FmtStyle = RECORD elemStyle := RF.FmtStyle{}; END;
  TexStyle = RECORD elemStyle := RF.TexStyle{}; END;

(*
PROCEDURE Lex(str:TEXT):C.T RAISES {Error};
        (*reads after the "COMPLEX{" in COMPLEX{re:=<r>; im:=<r>},
        thru the "}"*)
*)

PROCEDURE Fmt (READONLY x : T; READONLY style := FmtStyle{}) : TEXT;
        (*outputs as "COMPLEX{re:=<r>; im:=<r>}"
        Uses simple F.Real if x.im=0.0.*)

PROCEDURE Tex (READONLY x : T; READONLY style := TexStyle{}; within := Precedence.sum) : TEXT;

(*==========================*)
END ComplexFmtLex.
