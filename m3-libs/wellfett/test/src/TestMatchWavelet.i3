INTERFACE TestMatchWavelet;

IMPORT LongRealBasic AS R;

IMPORT LongRealSignal AS S;
IMPORT LongRealDyadicFilterBank AS FB;

PROCEDURE Test ();

PROCEDURE TestMatchPatternSmooth (target: S.T;
                                  levels, smooth, vanishing,
                                    smallVanishing, translates: CARDINAL;
                                  smoothWeight: R.T):
  ARRAY [0 .. 1] OF FB.T;

END TestMatchWavelet.
