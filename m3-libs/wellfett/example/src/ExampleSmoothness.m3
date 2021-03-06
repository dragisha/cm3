MODULE ExampleSmoothness;

IMPORT LongRealBasic                AS R,
       LongRealComplex              AS C,
       LongRealComplexTrans         AS CT,
       LongRealVector               AS V,
       LongRealVectorFast           AS VFs,
       LongRealVectorTrans          AS VT,
       LongRealVectorComplex        AS VC,
       LongRealComplexVector        AS CV,
       LongRealComplexVectorBasic   AS CVB,
       LongRealComplexVectorSupport AS CVS,
       LongRealComplexVectorTrans   AS CVT,
       LongRealComplexVectorFmtLex  AS CVF,
       LongRealComplexInterpolation AS CVIp,
       LongRealSignal               AS S,
       LongRealComplexSignal        AS CS,
       LongRealComplexScaledSignal  AS ComplexScaledSignal,
       LongRealBSplineWavelet       AS BSpline,
       LongRealFmtLex               AS RF,
       LongRealSignalFmtLex         AS SF,
       LongRealRefinableFunction    AS Refn,
       LongRealFFTW                 AS FFT,
       LongRealIntegerPower         AS RIntPow,
       Integer32IntegerPower        AS IIntPow,
       LongRealPLPlot               AS PL;

IMPORT IO, Fmt, Wr, Thread;
IMPORT Arithmetic AS Arith;

PROCEDURE SpecNorm (x: CV.T; rsize: CARDINAL; ): R.T =
  BEGIN
    IF rsize MOD 2 = 0 THEN
      RETURN
        R.Two * CVT.Norm2Sqr(x) - CT.AbsSqr(x[0]) - CT.AbsSqr(x[LAST(x^)]);
    ELSE
      RETURN R.Two * CVT.Norm2Sqr(x) - CT.AbsSqr(x[0]);
    END;
  END SpecNorm;

<* UNUSED *>
PROCEDURE PlotReal (s: S.T; l: CARDINAL; ) =
  <* FATAL Arith.Error *>        (*MulPower cannot fail for integers*)
  VAR
    unit  := IIntPow.MulPower(1, 2, l);
    grid  := R.One / FLOAT(unit, R.T);
    left  := FLOAT(s.getFirst(), R.T) * grid;
    right := FLOAT(s.getLast(), R.T) * grid;
  BEGIN
    PL.SetFGColorDiscr(1);
    PL.SetEnvironment(
      left, right, VFs.Min(s.getData()^), VFs.Max(s.getData()^));
    PL.SetFGColorDiscr(2);
    PL.PlotLines(
      V.ArithSeq(s.getNumber(), FLOAT(s.getFirst(), R.T) * grid, grid)^,
      s.getData()^);
  END PlotReal;


PROCEDURE PlotComplex (READONLY s: ARRAY OF ComplexScaledSignal.T; ) =
  CONST magnify = 1.0D0;

  VAR
    v           := NEW(REF ARRAY OF VC.T, NUMBER(s));
    left, right := NEW(V.T, NUMBER(s));
    min, max    := R.Zero;
    color       := 2;

  BEGIN
    FOR i := FIRST(s) TO LAST(s) DO
      left[i] := ComplexScaledSignal.First(s[i]);
      right[i] := ComplexScaledSignal.Last(s[i]);
      v[i] := VC.Split(s[i].signal.getData()^);
      min := MIN(min, VFs.Min(v[i].re^));
      min := MIN(min, VFs.Min(v[i].im^));
      max := MAX(max, VFs.Max(v[i].re^));
      max := MAX(max, VFs.Max(v[i].im^));
    END;
    PL.SetFGColorDiscr(1);
    PL.SetEnvironment(
      VFs.Min(left^), VFs.Max(right^), min / magnify, max / magnify);
    FOR i := FIRST(s) TO LAST(s) DO
      WITH abscissa = V.ArithSeq(
                        s[i].signal.getNumber(), left[i], s[i].resolution)^ DO
        PL.SetFGColorDiscr(color);
        PL.PlotLines(abscissa, v[i].im^);
        PL.SetFGColorDiscr(color);
        PL.PlotLines(abscissa, v[i].re^);
        INC(color);
      END;
    END;
  END PlotComplex;

(* Test FFT, check equivalence of Euclidean norm in the signal space and in
   the frequency space. *)
PROCEDURE BSplineNorm () =
  VAR x: ARRAY [1 .. 7], [0 .. 6] OF S.T;
  BEGIN
    FOR n := FIRST(x) TO LAST(x) DO
      WITH mask = BSpline.GeneratorMask(n),
           xn   = x[n]                      DO
        xn[0] := mask;
        FOR l := 1 TO LAST(xn) DO
          xn[l] := Refn.Refine(xn[l - 1], mask);
        END;
        IO.Put(Fmt.FN("spline order %s\n", ARRAY OF TEXT{Fmt.Int(n)}));
        FOR l := FIRST(xn) TO LAST(xn) DO
          VAR
            padded  := xn[l].clipToVector(0, xn[l].getNumber() * 2);
            spec    := FFT.DFTR2C1D(padded^);
            absspec := V.New(NUMBER(spec^));
          BEGIN
            FOR k := FIRST(absspec^) TO LAST(absspec^) DO
              absspec[k] := CT.Abs(spec[k]);
            END;
            IO.Put(
              Fmt.FN(
                "  Euclidean norm %s (spec %s), Sum norm %s, support [%s,%s]\n",
                ARRAY OF
                  TEXT{Fmt.LongReal(VT.Norm2Sqr(xn[l].getData()) * FLOAT(
                                      NUMBER(padded^), R.T)),
                       Fmt.LongReal(SpecNorm(spec, NUMBER(padded^))),
                       Fmt.LongReal(VT.Norm1(xn[l].getData())),
                       Fmt.Int(xn[l].getFirst()), Fmt.Int(xn[l].getLast())}));

            (*PlotReal(absspec, l);*)
          END;
        END;
      END;
    END;
  END BSplineNorm;



PROCEDURE MulVecC
  (VAR (*OUT*) z: ARRAY OF C.T; READONLY x, y: ARRAY OF C.T; ) =
  BEGIN
    <* ASSERT NUMBER(y) = 2 * (NUMBER(x) - 1) *>
    <* ASSERT NUMBER(y) = NUMBER(z) *>
    FOR i := FIRST(x) TO LAST(x) DO z[i] := C.Mul(x[i], y[i]); END;
    FOR i := FIRST(x) + 1 TO LAST(x) - 1 DO
      z[NUMBER(z) - i] := C.Mul(C.Conj(x[i]), y[NUMBER(z) - i]);
    END;
  END MulVecC;

(* stretch (the length of) the signal by a factor of 2, remember that there
   must be a spare value at the end of the input, thus a signal of length
   (n+1) is transformed to one of length (2n+1) *)
PROCEDURE UpSample2Linear (READONLY x: ARRAY OF C.T; ): REF ARRAY OF C.T =
  VAR z := NEW(CV.T, 2 * NUMBER(x) - 1);
  BEGIN
    FOR i := FIRST(x) TO LAST(x) - 1 DO
      z[2 * i] := x[i];
      z[2 * i + 1] := C.Scale(C.Add(x[i], x[i + 1]), R.Half);
    END;
    z[LAST(z^)] := x[LAST(x)];
    RETURN z;
  END UpSample2Linear;

(* geometric average *)
PROCEDURE UpSample2Geom (READONLY x: ARRAY OF C.T; ): REF ARRAY OF C.T =
  VAR z := NEW(CV.T, 2 * NUMBER(x) - 1);
  BEGIN
    FOR i := FIRST(x) TO LAST(x) - 1 DO
      z[2 * i] := x[i];
      z[2 * i + 1] := CT.SqRt(C.Mul(x[i], x[i + 1]));
    END;
    z[LAST(z^)] := x[LAST(x)];
    RETURN z;
  END UpSample2Geom;

(* square average *)
<* UNUSED *>
PROCEDURE UpSample2Quad (READONLY x: ARRAY OF C.T; ): REF ARRAY OF C.T =
  VAR z := NEW(CV.T, 2 * NUMBER(x) - 1);
  BEGIN
    FOR i := FIRST(x) TO LAST(x) - 1 DO
      z[2 * i] := x[i];
      z[2 * i + 1] := CT.SqRt(
                        C.Scale(C.Add(C.Square(x[i]), C.Square(x[i + 1])),
                                R.Half));
    END;
    z[LAST(z^)] := x[LAST(x)];
    RETURN z;
  END UpSample2Quad;

(* interpolate piecewise cubic *)
<* UNUSED *>
PROCEDURE UpSample2Cubic (READONLY x: ARRAY OF C.T; ): REF ARRAY OF C.T =
  VAR
    z := NEW(CV.T, 2 * NUMBER(x) - 1);
    y := V.ArithSeq(NUMBER(x), R.Zero, R.One);
  BEGIN
    FOR i := FIRST(x) TO LAST(x) - 1 DO
      z[2 * i] := x[i];
      z[2 * i + 1] := CVIp.CubicHermite(y^, x, FLOAT(i, R.T) + R.Half);
    END;
    z[LAST(z^)] := x[LAST(x)];
    RETURN z;
  END UpSample2Cubic;

(* interpolate piecewise cubic *)
PROCEDURE UpSample2Fourier (READONLY x: ARRAY OF C.T; ): REF ARRAY OF C.T =
  VAR
    pair := VC.Split(x);
    s    := FFT.DFTR2C1D(pair.re^);
    sl   := CV.NewZero(NUMBER(s^) * 2);
    k    := R.One / FLOAT(NUMBER(x), R.T);
  BEGIN
    SUBARRAY(sl^, 0, NUMBER(s^)) := CV.Scale(s, C.T{k, R.Zero})^;
    WITH (* we must extend to an even number of samples to get an exact
            doubling *) zr = FFT.DFTC2R1D(sl^, 0)^,
                        z  = CV.New(NUMBER(zr) - 1) (* ignore last value *) DO
      FOR i := FIRST(z^) TO LAST(z^) DO
        z[i].re := zr[i];
        z[i].im := R.Zero;
      END;
      RETURN z;
    END;
  END UpSample2Fourier;

CONST UpSample2 = UpSample2Fourier;


PROCEDURE ExampleMask (num: [0 .. 6]; ): S.T =
  BEGIN
    CASE num OF
      (* A mask close to the one of the hat function. *)
    | 0 =>
        RETURN NEW(S.T).fromArray(
                 ARRAY OF R.T{0.25D0, 0.5D0, 0.25D0}, -1).autocorrelate();
    | 1 =>
        RETURN NEW(S.T).fromArray(
                 ARRAY OF R.T{0.26D0, 0.5D0, 0.24D0}, -1).autocorrelate();
    | 2 =>
        RETURN NEW(S.T).fromArray(
                 ARRAY OF R.T{0.3D0, 0.5D0, 0.2D0}, -1).autocorrelate();
    | 3 =>
        RETURN NEW(S.T).fromArray(
                 ARRAY OF R.T{0.23D0, 0.54D0, 0.23D0}, -1).autocorrelate();
    | 4 =>
        RETURN
          NEW(S.T).fromArray(ARRAY OF R.T{0.5D0, 0.5D0}).autocorrelate();
    | 5 =>
        RETURN
          NEW(S.T).fromArray(ARRAY OF R.T{0.2D0, 0.8D0}).autocorrelate();
    | 6 =>
        RETURN
          NEW(S.T).fromArray(ARRAY OF R.T{0.23D0, 0.54D0, 0.23D0}, -1);
    END;
  END ExampleMask;

PROCEDURE FourierDecay () =
  VAR
    mask                := ExampleMask(2);
    generator           := mask;
    twopow   : CARDINAL := 1;

  BEGIN
    FOR l := 0 TO 12 DO
      IO.Put(Fmt.FN("number of levels: %s\n", ARRAY OF TEXT{Fmt.Int(l)}));
      (*PlotReal(generator, l);*)
      VAR
        minsize := generator.getNumber() * 2;
        (*round up to the next multiple of twopow*)
        newsize   := minsize + (-minsize) MOD twopow;
        bandWidth := newsize DIV twopow;
        genSpec   := FFT.DFTR2C1D(generator.wrapCyclic(newsize)^);

        (*quite a random start filter*)
        refnMask := NEW(S.T).fromArray(
                      ARRAY OF R.T{-0.3D0, 1.85D0, -0.55D0}, -1);

      <* FATAL Arith.Error *>    (* V.Sub and MulPower cannot fail *)
      BEGIN

        IF l > 1 THEN
          VAR
            rep: CARDINAL := 2;
            maskSpec := FFT.DFTR2C1D(mask.wrapCyclic(bandWidth)^);
            band := CV.FromArray(
                      SUBARRAY(genSpec^, bandWidth, bandWidth + 1));
            bandWrapped := band;
            (* the frequency band mapped back to time domain *)
            bandMask := NEW(S.T).fromVector(FFT.DFTC2R1D(band^, 0)).scale(
                          0.5D0);
            curBandWidth           := bandWidth;
            decaySpec              := CV.New(NUMBER(genSpec^));
            k           : CARDINAL := l - 1;
            (* we like to compare our naive interpolations with an
               interpolation found by transforming a generator that is zero
               padded to the double length *)
            genDoubSpec := FFT.DFTR2C1D(generator.wrapCyclic(newsize * 2)^);
            bandDoub := band;    (* initialize it with something different
                                    from NIL *)
          BEGIN
            (*PlotComplex(ARRAY OF CS.T{NEW(CS.T).fromVector(maskSpec)},
               0);*)

            (*CVS.Clear(SUBARRAY(decaySpec^, 0, bandWidth));*)
            SUBARRAY(decaySpec^, 0, bandWidth) :=
              SUBARRAY(genSpec^, 0, bandWidth);
            LOOP
              WITH genBand = SUBARRAY(genSpec^, curBandWidth, curBandWidth),
                   (*remove spare value at the end*)
                   decayBand     = SUBARRAY(band^, 0, curBandWidth),
                   decayBandDoub = SUBARRAY(bandDoub^, 0, curBandWidth),
                   sum           = CVS.Sum(genBand).re,
                   decaySum      = CVS.Sum(decayBand).re,
                   decayDoubSum  = CVS.Sum(decayBandDoub).re,
                   wrappedSum = CVS.Sum(
                                  SUBARRAY(bandWrapped^, 0, bandWidth)).re DO
                SUBARRAY(decaySpec^, curBandWidth, curBandWidth) :=
                  decayBand;
                IO.Put(
                  Fmt.FN(
                    "%s: sum (%s)\n   %s <-> %s <-> %s <-> %s <-> %s\n",
                    ARRAY OF
                      TEXT{
                      Fmt.Int(k),
                      (*RF.Fmt(CVT.Norm2(CVB.Sub(decayBand, genBand))),*)
                      RF.Fmt(sum / decaySum), RF.Fmt(sum),
                      RF.Fmt(decayDoubSum), RF.Fmt(decaySum),
                      RF.Fmt(wrappedSum), RF.Fmt(bandMask.getValue(0))}));
                IO.Put(
                  Fmt.FN(
                    "diff: upsampled %s, Fourier interpolated %s\n",
                    ARRAY OF
                      TEXT{
                      RF.Fmt(CVT.Norm2(CVB.Sub(genBand, decayBand))),
                      RF.Fmt(CVT.Norm2(CVB.Sub(genBand, decayBandDoub)))}));
                DEC(k);
              END;
              IF k = 0 THEN EXIT END;
              (* upsample the last frequency band *)
              WITH bandNew = UpSample2(band^),
                   res     = RIntPow.MulPower(R.One, R.Half, l - k) DO
                (*band := UpSample2(band^);*)
                bandDoub :=
                  CV.FromArray(SUBARRAY(genDoubSpec^, curBandWidth * 2,
                                        curBandWidth * 2 + 1));
                PlotComplex(ARRAY OF
                              ComplexScaledSignal.T{
                              ComplexScaledSignal.T{
                                NEW(CS.T).fromVector(band), res * 2.0D0},
                              ComplexScaledSignal.T{
                                NEW(CS.T).fromVector(bandNew), res},
                              ComplexScaledSignal.T{
                                NEW(CS.T).fromVector(bandDoub), res},
                              ComplexScaledSignal.T{
                                NEW(CS.T).fromVector(maskSpec).scale(
                                  C.T{CVT.NormInf(band), R.Zero}), res}});
                (* IO.Put(Fmt.FN( "diff upsampled - Fourier interpolated:
                   %s\n", ARRAY OF TEXT{RF.Fmt(CVT.Norm2(CV.Sub(band,
                   bandDoub)))})); *)
                band := bandNew;
              END;

              (* multiply the upsampled band with the filter mask's
                 symbol *)
              FOR i := 0 TO rep - 1 DO
                WITH bandSpec = SUBARRAY(band^, bandWidth * i, bandWidth) DO
                  MulVecC(bandSpec, maskSpec^, bandSpec);
                END;
                WITH bandSpec = SUBARRAY(
                                  bandDoub^, bandWidth * i, bandWidth) DO
                  MulVecC(bandSpec, maskSpec^, bandSpec);
                END;
              END;
              <* ASSERT LAST(band^) = bandWidth * rep *>
              band[LAST(band^)] := C.Mul(maskSpec[0], band[LAST(band^)]);
              bandDoub[LAST(band^)] :=
                C.Mul(maskSpec[0], bandDoub[LAST(band^)]);

              (* alternative way: upsample and wrap frequency band *)
              WITH bandWrappedNew = UpSample2(bandWrapped^) DO
                bandWrapped := NEW(CV.T, NUMBER(bandWrapped^));
                CVS.Add(
                  bandWrapped^,
                  SUBARRAY(bandWrappedNew^, 0, NUMBER(bandWrapped^)),
                  SUBARRAY(
                    bandWrappedNew^, bandWidth, NUMBER(bandWrapped^)));
              END;
              WITH bandSpec = SUBARRAY(bandWrapped^, 0, bandWidth) DO
                MulVecC(bandSpec, maskSpec^, bandSpec);
              END;
              bandWrapped[LAST(bandWrapped^)] :=
                C.Mul(maskSpec[0], bandWrapped[LAST(bandWrapped^)]);

              (* second alternative: perform convolution in time domain *)
              bandMask := bandMask.convolveDown(mask, 2).scale(0.5D0);

              (* IO.Put(Fmt.FN("diff upsampled - Fourier interpolated" & "
                 after multiplication: %s\n", ARRAY OF
                 TEXT{RF.Fmt(CVT.Norm2( CVB.Sub( bandDoub^, SUBARRAY(
                 genSpec^, curBandWidth * 2, curBandWidth * 2 +
                 1))))})); *)

              rep := rep * 2;
              curBandWidth := curBandWidth * 2;
            END;
            (*
            PlotComplex(ARRAY OF
                          CS.T{NEW(CS.T).fromVector(genSpec),
                               NEW(CS.T).fromVector(decaySpec)}, l);
            *)
          END;
        END;

        (* High frequencies are equivalent to negative frequencies and must
           not be considered here.  They also don't appear in the spectrum
           as generated by FFTW. *)
        FOR k := 2 TO l DO
          WITH sum  = CVS.Sum(SUBARRAY(genSpec^, bandWidth, bandWidth)).re,
               bias = refnMask.getValue(0)                                  DO
            IO.Put(Fmt.FN("%s: (%s) %s <-> %s\n",
                          ARRAY OF
                            TEXT{Fmt.Int(k), RF.Fmt(sum / bias),
                                 RF.Fmt(sum), RF.Fmt(bias)}));
          END;
          refnMask := refnMask.convolveDown(mask, 2);
          bandWidth := bandWidth * 2;
        END;
      END;
      generator := Refn.Refine(generator, mask);
      twopow := twopow * 2;
    END;
  END FourierDecay;


(* Compare two different kinds of upsampling: 1.  interpolate a frequency
   spectrum, 2.  take the frequency spectrum of the signal padded by
   zeros *)
PROCEDURE TestUpsampleA () =
  CONST vec0 = ARRAY OF R.T{1.4D0, 0.3D0, -0.7D0, 0.2D0, -0.1D0, -0.5D0};
  VAR
    vec1 := V.NewZero(NUMBER(vec0) * 2);
    spec0, spec1, specLinIp, specGeomIp: CV.T;
  <* FATAL Thread.Alerted, Wr.Failure *>
  BEGIN
    SUBARRAY(vec1^, 0, NUMBER(vec0)) := vec0;
    spec0 := FFT.DFTR2C1D(vec0);
    spec1 := FFT.DFTR2C1D(vec1^);
    specLinIp := UpSample2Linear(spec0^);
    specGeomIp := UpSample2Geom(spec0^);
    IO.Put(Fmt.F("Original:\n%s\n" & "Fourier interpolated:\n%s\n"
                   & "Linearly interpolated:\n%s\n"
                   & "Geometrically interpolated:\n%s\n", CVF.Fmt(spec0),
                 CVF.Fmt(spec1), CVF.Fmt(specLinIp), CVF.Fmt(specGeomIp)));
  END TestUpsampleA;

(* Compare two different kinds of upsampling: 1.  interpolate a complex
   signal, 2.  Fourier transform the signal to real data, extend with
   zeros, transform back *)
PROCEDURE TestUpsampleB () =
  CONST
    spec0 = ARRAY OF
              C.T{C.T{1.4D0, 0.0D0}, C.T{0.3D0, -0.7D0},
                  C.T{0.2D0, -0.1D0}, C.T{-0.5D0, 0.0D0}};
  VAR
    spec1                            := CV.NewZero(NUMBER(spec0) + 1);
    vec0, vec1, vec0up, vec1up: V.T;
    spec0up, spec1up          : CV.T;
    k0, k1                    : R.T;

  <* FATAL Thread.Alerted, Wr.Failure *>
  BEGIN
    SUBARRAY(spec1^, 0, NUMBER(spec0)) := spec0;
    vec0 := FFT.DFTC2R1D(spec0, 0);
    vec1 := FFT.DFTC2R1D(spec1^, 0);
    vec0up := V.NewZero(NUMBER(vec0^) * 2);
    vec1up := V.NewZero(NUMBER(vec1^) * 2);
    k0 := R.Two / FLOAT(NUMBER(vec0up^), R.T);
    k1 := R.Two / FLOAT(NUMBER(vec1up^), R.T);
    SUBARRAY(vec0up^, 0, NUMBER(vec0^)) := V.Scale(vec0, k0)^;
    SUBARRAY(vec1up^, 0, NUMBER(vec1^)) := V.Scale(vec1, k1)^;
    spec0up := FFT.DFTR2C1D(vec0up^);
    spec1up := FFT.DFTR2C1D(vec1up^);
    IO.Put(Fmt.F("Original:\n%s\n" & "Fourier interpolated short:\n%s\n"
                   & "Fourier interpolated long:\n%s\n",
                 CVF.Fmt(CV.FromArray(spec0)), CVF.Fmt(spec0up),
                 CVF.Fmt(spec1up)));
  END TestUpsampleB;

PROCEDURE Run () =
  BEGIN
    PL.Init();
    CASE 1 OF
    | 0 => BSplineNorm();
    | 1 => FourierDecay();
    | 2 => TestUpsampleA();
    | 3 => TestUpsampleB();
    ELSE
      <* ASSERT FALSE *>
    END;
    PL.Exit();
  END Run;

BEGIN
END ExampleSmoothness.
