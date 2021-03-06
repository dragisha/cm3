GENERIC MODULE Signal(R, SignalRep, V, VS, P);

IMPORT Range, Arithmetic AS Arith;

REVEAL
  T = SignalRep.T BRANDED OBJECT
      OVERRIDES
        init       := Init;
        initFL     := InitFL;
        fromArray  := FromArray;
        fromVector := FromVector;
        copy       := Copy;

        clip         := Clip;
        clipToArray  := ClipToArray;
        clipToVector := ClipToVector;
        slim         := Slim;

        getFirst  := GetFirst;
        getLast   := GetLast;
        getNumber := GetNumber;
        getRange  := GetRange;

        getData  := GetData;
        getValue := GetValue;

        equal  := Equal;
        isZero := IsZero;

        sum   := Sum;
        inner := Inner;

        upsample      := UpSample;
        downsample    := DownSample;
        wrapCyclic    := WrapCyclic;
        slice         := Slice;
        sliceRev      := SliceRev;
        interleave    := Interleave;
        interleaveRev := InterleaveRev;
        reverse       := Reverse;
        adjoint       := Conj;

        translate := Translate;
        scale     := Scale;
        negate    := Neg;
        raise     := Raise;

        translateD := TranslateD;
        scaleD     := ScaleD;

        alternate := Alternate;

        superpose     := Add;
        convolve      := Mul;
        autocorrelate := Autocorrelate;

        convolveDown  := ConvolveDown;
        upConvolve    := UpConvolve;
        convolveShort := ConvolveShort;
        extractPeaks  := ExtractPeaks;

        deconvolveMod    := DeconvolveMod;
        deconvolveModAll := DeconvolveModAll;
      END;


PROCEDURE Init (SELF: T; first: IndexType; number: SizeType): T =
  BEGIN
    SELF.data := NEW(V.T, number);
    SELF.first := first;
    VS.Clear(SELF.data^);
    (*FOR j := 0 TO LAST(SELF.data^) DO SELF.data[j] := R.Zero; END;*)
    RETURN SELF;
  END Init;

PROCEDURE InitFL (SELF: T; first, last: IndexType): T =
  BEGIN
    RETURN Init(SELF, first, last - first + 1);
  END InitFL;

PROCEDURE FromArray
  (SELF: T; READONLY arr: ARRAY OF R.T; first: IndexType): T =
  BEGIN
    SELF.data := NEW(V.T, NUMBER(arr));
    SELF.data^ := arr;
    SELF.first := first;
    RETURN SELF;
  END FromArray;

PROCEDURE FromVector (SELF: T; x: V.T; first: IndexType): T =
  BEGIN
    SELF.data := x;
    SELF.first := first;
    RETURN SELF;
  END FromVector;

PROCEDURE Copy (SELF: T): T =
  BEGIN
    RETURN NEW(T, first := SELF.first, data := V.Copy(SELF.data));
  END Copy;


PROCEDURE Clip (x: T; first: IndexType; size: SizeType): T =
  VAR z := NEW(T, data := NEW(V.T, size), first := first);
  BEGIN
    ClipToArray(x, first, z.data^);
    RETURN z;
  END Clip;

PROCEDURE ClipToArray (x: T; first: IndexType; VAR y: V.TBody) =
  VAR
    yStart                   := x.first - first;
    yStop                    := yStart + NUMBER(x.data^);
    xl, xr, yl, yr: CARDINAL;
  BEGIN
    IF yStart < 0 THEN
      xl := -yStart;
      yl := 0;
    ELSIF yStart < NUMBER(y) THEN
      xl := 0;
      yl := yStart;
    ELSE
      VS.Clear(y);
      RETURN;
    END;

    yStop := yStart + NUMBER(x.data^);
    IF yStop < 0 THEN
      VS.Clear(y);
      RETURN;
    ELSIF yStop < NUMBER(y) THEN
      xr := NUMBER(x.data^);
      yr := yStop;
    ELSE
      xr := NUMBER(y) - yStart;
      yr := NUMBER(y);
    END;

    VS.Clear(SUBARRAY(y, 0, yl));
    SUBARRAY(y, yl, yr - yl) := SUBARRAY(x.data^, xl, xr - xl);
    VS.Clear(SUBARRAY(y, yr, NUMBER(y) - yr));
  END ClipToArray;

PROCEDURE ClipToVector (x: T; first: IndexType; size: SizeType): V.T =
  VAR z := NEW(V.T, size);
  BEGIN
    ClipToArray(x, first, z^);
    RETURN z;
  END ClipToVector;

PROCEDURE Slim (x: T; ): T =
  VAR
    begin: CARDINAL := FIRST(x.data^);
    end  : CARDINAL := LAST(x.data^);
  BEGIN
    WITH data = x.data^ DO
      WHILE end >= 0 AND R.IsZero(data[end]) DO DEC(end); END;
      WHILE begin <= end AND R.IsZero(data[begin]) DO INC(begin); END;
      RETURN NEW(T).fromArray(
               SUBARRAY(data, begin, end + 1 - begin), x.first + begin);
    END;
  END Slim;

PROCEDURE GetFirst (SELF: T): IndexType =
  BEGIN
    RETURN SELF.first;
  END GetFirst;

PROCEDURE GetLast (SELF: T): IndexType =
  BEGIN
    RETURN SELF.first + LAST(SELF.data^);
  END GetLast;

PROCEDURE GetNumber (SELF: T): IndexType =
  BEGIN
    RETURN NUMBER(SELF.data^);
  END GetNumber;

PROCEDURE GetRange (SELF: T): Range.T =
  BEGIN
    RETURN Range.T{SELF.first, NUMBER(SELF.data^)};
  END GetRange;


PROCEDURE GetData (SELF: T): P.T =
  BEGIN
    RETURN SELF.data;
  END GetData;

PROCEDURE GetValue (SELF: T; pos: IndexType): R.T =
  BEGIN
    IF SELF.first <= pos AND pos < SELF.first + NUMBER(SELF.data^) THEN
      RETURN SELF.data[pos - SELF.first];
    ELSE
      RETURN R.Zero;
    END;
  END GetValue;


PROCEDURE IsZero (x: T): BOOLEAN =
  BEGIN
    RETURN V.IsZero(x.data);
  END IsZero;

PROCEDURE Equal (x, y: T): BOOLEAN =
  BEGIN
    RETURN V.Equal(x.data, y.data); (* this is nonsense but I haven't yet
                                       access to Vector Rep *)
    (*
        IF x.first > y.first THEN
          VAR z := y;
          BEGIN
            y := x;
            x := z;
          END;
        END;
        (**remaining cases:
          support(x)   [  ]         [   ]        [     ]
          support(y)       [  ]       [   ]        [ ]
        **)
        VAR
          xlast := x.first + NUMBER(x.data^);
          ylast := y.first + NUMBER(y.data^);
        BEGIN
          IF xlast <= y.first THEN
            RETURN V.IsZero(x.data) AND V.IsZero(y.data);
          ELSE
            VAR
              xHeadZero := VS.IsZero(SUBARRAY(x.data^, 0, y.first - x.first));
            BEGIN
              IF xlast <= ylast THEN
                RETURN xHeadZero
                         AND VS.IsZero(SUBARRAY(y.data^, xlast - y.first,
                                                ylast - xlast))
                         AND VS.Equal(SUBARRAY(x.data^, y.first - x.first,
                                               xlast - y.first),
                                      SUBARRAY(y.data^, 0, xlast - y.first));
              ELSE
                RETURN xHeadZero
                         AND VS.IsZero(SUBARRAY(x.data^, ylast - x.first,
                                                xlast - ylast))
                         AND VS.Equal(SUBARRAY(x.data^, y.first - x.first,
                                               NUMBER(y.data^)), y.data^);
              END;
            END;
          END;
        END
    *)
  END Equal;


PROCEDURE Sum (SELF: T): R.T =
  BEGIN
    RETURN VS.Sum(SELF.data^);
  END Sum;

PROCEDURE Inner (x, y: T): R.T =
  VAR
    first  := MAX(x.first, y.first);
    last   := MIN(x.getLast(), y.getLast());
    number := last - first + 1;
  BEGIN
    IF number > 0 THEN
      RETURN VS.Inner(SUBARRAY(x.data^, first - x.first, number),
                      SUBARRAY(y.data^, first - y.first, number));
    ELSE
      RETURN R.Zero;
    END;
  END Inner;


PROCEDURE Translate (SELF: T; dist: IndexType): T =
  BEGIN
    RETURN NEW(T, data := SELF.data, first := SELF.first + dist);
  END Translate;

PROCEDURE TranslateD (SELF: T; dist: IndexType) =
  BEGIN
    INC(SELF.first, dist);
  END TranslateD;

PROCEDURE UpSample (x: T; factor: ScalingType): T =
  VAR z := NEW(T).init(x.first * factor, LAST(x.data^) * factor + 1);
  BEGIN
    FOR i := 0 TO LAST(x.data^) DO z.data[i * factor] := x.data[i]; END;
    RETURN z;
  END UpSample;

PROCEDURE DownSample (x: T; factor: ScalingType): T =
  VAR
    z               := NEW(T);
    last: IndexType := x.getLast() DIV factor;
  BEGIN
    z.first := -((-x.first) DIV factor);
    (*
      z.data  := NEW(V.T, (LAST(x.data^)-((-x.first) MOD NUMBER(x.data^))) DIV factor);
    *)
    z.data := NEW(V.T, last - z.first + 1);
    FOR i := z.first TO z.getLast() DO
      z.data[i - z.first] := x.data[i * factor - x.first];
    END;
    RETURN z;
  END DownSample;

PROCEDURE WrapCyclic (x: T; length: ScalingType): V.T =
  VAR
    (*vector must be initialized with zeros*)
    z            := V.NewZero(length);
    j: IndexType := x.first MOD length;

  BEGIN
    FOR i := FIRST(x.data^) TO LAST(x.data^) DO
      z[j] := R.Add(z[j], x.data[i]);
      INC(j);
      IF j >= length THEN j := 0; END;
      (*
      j:=(j+1) MOD length;
      *)
    END;
    RETURN z;
  END WrapCyclic;

PROCEDURE Slice (x: T; num: ScalingType): REF SignalPP =
  VAR slice := NEW(REF SignalPP, num);
  BEGIN
    FOR j := 0 TO LAST(slice^) DO
      slice[j] := x.translate(-j).downsample(num);
    END;
    RETURN slice;
  END Slice;

PROCEDURE SliceRev (x: T; num: ScalingType): REF SignalPP =
  VAR slice := NEW(REF SignalPP, num);
  BEGIN
    FOR j := 0 TO LAST(slice^) DO
      slice[j] := x.translate(j).downsample(num);
    END;
    RETURN slice;
  END SliceRev;

PROCEDURE Interleave (x: T; READONLY slice: SignalPP): T =
  VAR
    first := NUMBER(slice) * slice[0].getFirst();
    last  := NUMBER(slice) * slice[0].getLast();
  BEGIN
    FOR j := 1 TO LAST(slice) DO
      first := MIN(first, j + NUMBER(slice) * slice[j].getFirst());
      last := MAX(last, j + NUMBER(slice) * slice[j].getLast());
    END;
    EVAL x.init(first, last + 1 - first);
    FOR j := 0 TO LAST(slice) DO
      VAR
        l    := j + NUMBER(slice) * slice[j].first - first;
        data := slice[j].data;
      BEGIN
        FOR k := 0 TO LAST(data^) DO
          x.data[l] := data[k];
          INC(l, NUMBER(slice));
        END;
      END;
    END;
    RETURN x;
  END Interleave;

(*convert slices from forward to backward order*)
PROCEDURE ReverseSlices (READONLY slice: SignalPP): REF SignalPP =
  VAR revSlice := NEW(REF SignalPP, NUMBER(slice));
  BEGIN
    revSlice[0] := slice[0];
    FOR i := 1 TO LAST(slice) DO
      revSlice[NUMBER(slice) - i] := slice[i].translate(1);
    END;
    RETURN revSlice;
  END ReverseSlices;

PROCEDURE InterleaveRev (x: T; READONLY slice: SignalPP): T =
  BEGIN
    RETURN Interleave(x, ReverseSlices(slice)^);
  END InterleaveRev;

PROCEDURE ReverseV (x: V.T): V.T =
  VAR
    z := NEW(V.T, NUMBER(x^));
    i := NUMBER(x^);
  BEGIN
    FOR j := FIRST(z^) TO LAST(z^) DO DEC(i); z[j] := x[i]; END;
    RETURN z;
  END ReverseV;

PROCEDURE Reverse (x: T): T =
  BEGIN
    RETURN NEW(T, first := -(x.first + LAST(x.data^)),
               data := ReverseV(x.data));
  END Reverse;

PROCEDURE Conj (x: T): T =
  VAR z := NEW(T);
  BEGIN
    z.data := NEW(V.T, NUMBER(x.data^));
    z.first := -GetLast(x);
    FOR j := FIRST(z.data^) TO LAST(z.data^) DO
      z.data[j] := R.Conj(x.data[LAST(x.data^) + FIRST(z.data^) - j]);
    END;
    RETURN z;
  END Conj;


PROCEDURE Scale (x: T; factor: R.T): T =
  BEGIN
    RETURN NEW(T, first := x.first, data := V.Scale(x.data, factor));
  END Scale;

PROCEDURE Neg (x: T): T =
  BEGIN
    RETURN NEW(T, first := x.first, data := V.Neg(x.data));
  END Neg;

PROCEDURE ScaleD (x: T; factor: R.T) =
  BEGIN
    FOR i := 0 TO LAST(x.data^) DO
      x.data[i] := R.Mul(x.data[i], factor);
    END;
  END ScaleD;

PROCEDURE Raise (x: T; offset: R.T; first: IndexType; number: SizeType):
  T =
  VAR
    zFirst := MIN(x.first, first);
    zLast  := MAX(x.first + NUMBER(x.data^), first + number) - 1;
    z      := NEW(T).initFL(zFirst, zLast);
  BEGIN
    WITH zdata = SUBARRAY(z.data^, x.first - z.first, NUMBER(x.data^)) DO
      zdata := x.data^;
    END;
    WITH zdata = SUBARRAY(z.data^, first - z.first, number) DO
      FOR i := 0 TO number - 1 DO zdata[i] := R.Add(zdata[i], offset); END;
    END;
    RETURN z;
  END Raise;


PROCEDURE Alternate (x: T): T =
  VAR
    z    := NEW(T).init(x.first, NUMBER(x.data^));
    sign := R.One;
  BEGIN
    IF x.first MOD 2 # 0 THEN sign := R.Neg(R.One); END;
    FOR i := 0 TO LAST(x.data^) DO
      z.data[i] := R.Mul(sign, x.data[i]);
      sign := R.Neg(sign);
    END;
    RETURN z;
  END Alternate;

<* UNUSED *>
PROCEDURE AlternateBool (x: T): T =
  VAR
    z    := NEW(T).init(x.first, NUMBER(x.data^));
    sign := x.first MOD 2 # 0;
  BEGIN
    FOR i := 0 TO LAST(x.data^) DO
      IF sign THEN
        z.data[i] := R.Neg(x.data[i]);
      ELSE
        z.data[i] := x.data[i];
      END;
      sign := NOT sign;
    END;
    RETURN z;
  END AlternateBool;

PROCEDURE DeconvolveMod (x, y: T; n: CARDINAL; ): QuotRem
  RAISES {Arith.Error} =
  BEGIN
    WITH xNumber = NUMBER(x.data^),
         yNumber = NUMBER(y.data^),
         yLead   = y.data[FIRST(y.data^)],
         yTrail  = y.data[LAST(y.data^)]   DO
      IF xNumber < yNumber THEN
        RETURN QuotRem{Zero, x};
      ELSE
        VAR
          r := V.Copy(x.data);
          q := NEW(V.T, xNumber - yNumber + 1);
        BEGIN
          FOR j := LAST(q^) TO n BY -1 DO
            WITH qj   = R.Div(r[j + yNumber - 1], yTrail),
                 rSub = SUBARRAY(r^, j, yNumber)           DO
              VS.Sub(rSub, rSub, V.Scale(y.data, qj)^);
              q[j] := qj;
            END;
          END;
          FOR j := 0 TO n - 1 DO
            WITH qj   = R.Div(r[j], yLead),
                 rSub = SUBARRAY(r^, j, yNumber) DO
              VS.Sub(rSub, rSub, V.Scale(y.data, qj)^);
              q[j] := qj;
            END;
          END;
          RETURN QuotRem{NEW(T).fromVector(q, x.first - y.first),
                         NEW(T).fromArray(
                           SUBARRAY(r^, n, yNumber - 1), x.first + n)};
        END;
      END;
    END;
  END DeconvolveMod;

PROCEDURE DeconvolveModAll (x, y: T; ): REF ARRAY OF QuotRem
  RAISES {Arith.Error} =
  BEGIN
    WITH xNumber = NUMBER(x.data^),
         yNumber = NUMBER(y.data^)  DO
      IF xNumber < yNumber THEN
        RETURN NIL;
      ELSE
        WITH n      = xNumber - yNumber + 1,
             qr0    = DeconvolveMod(x, y, 0),
             qr1    = DeconvolveMod(x, y, n),
             q0data = qr0.quot.data^,
             q1data = qr1.quot.data^,
             qrs    = NEW(REF ARRAY OF QuotRem, n + 1),
             (* it must be rNumber = yNumber-1 *)
             rNumber = NUMBER(qr0.rem.data^),
             res     = V.NewZero(xNumber)^    DO
          SUBARRAY(res, 0, rNumber) := qr0.rem.data^;
          (* interpolate between qr0 and qr1 *)
          qrs[0] := qr0;
          FOR j := 0 TO n - 1 DO
            WITH qrs_j1 = qrs[j + 1] DO
              qrs_j1.quot := Copy(qrs[j].quot);
              qrs_j1.quot.data[j] := q1data[j];
              (* the progressive updates will accumulate rounding errors
                 for non-accurate number types *)
              WITH resLoc = SUBARRAY(res, j, yNumber) DO
                VS.Add(resLoc, resLoc,
                       V.Scale(y.data, R.Sub(q0data[j], q1data[j]))^);
                qrs_j1.rem :=
                  NEW(T).fromArray(
                    SUBARRAY(resLoc, 1, rNumber), qr0.rem.first + j + 1);
              END;
            END;
          END;
          RETURN qrs;
        END;
      END;
    END;
  END DeconvolveModAll;

PROCEDURE Mul (x, y: T): T =
  BEGIN
    RETURN
      NEW(T, first := x.first + y.first, data := P.Mul(x.data, y.data));
  END Mul;

PROCEDURE Add (x, y: T): T =
  VAR
    first := MIN(x.getFirst(), y.getFirst());
    last  := MAX(x.getLast(), y.getLast());
    z     := NEW(T).initFL(first, last);

  BEGIN
    WITH zdata = SUBARRAY(z.data^, x.first - z.first, NUMBER(x.data^)) DO
      VS.Add(zdata, zdata, x.data^);
    END;
    WITH zdata = SUBARRAY(z.data^, y.first - z.first, NUMBER(y.data^)) DO
      VS.Add(zdata, zdata, y.data^);
    END;
    RETURN z;
  END Add;

(* inefficient, but I hope that no-one will need it *)
PROCEDURE Sub (x, y: T): T =
  BEGIN
    RETURN Add(x, Neg(y));
  END Sub;

PROCEDURE Autocorrelate (x: T): T =
  BEGIN
    RETURN x.adjoint().convolve(x);
  END Autocorrelate;


(*this implementation avoids unnecessary multipications but involves much
   memory management*)
PROCEDURE ConvolveDown (x, y: T; factor: ScalingType): T =
  VAR
    (*
    xlast := x.first + LAST(x.data^);
    ylast := y.first + LAST(y.data^);
    z := NEW(T).initFL(
           (-(x.first + y.first)) DIV factor, (xlast + ylast) DIV factor);
    *)
    sliceX := Slice(x, factor);
    sliceY := SliceRev(y, factor);
    (*This is different from starting with Zero since superposing with Zero
       may extend the support of the signal.*)
    z := sliceX[0].convolve(sliceY[0]);
  BEGIN
    FOR i := 1 TO factor - 1 DO
      z := z.superpose(sliceX[i].convolve(sliceY[i]));
    END;
    (* this will be approximately equal <*ASSERT
       z.equal(x.convolve(y).downsample(factor))*> *)
    RETURN z;
  END ConvolveDown;

PROCEDURE UpConvolve (x, y: T; factor: ScalingType): T =
  VAR
    xlast := x.first + LAST(x.data^);
    ylast := y.first + LAST(y.data^);
    z := NEW(T).initFL(x.first + y.first * factor, xlast + ylast * factor);
  BEGIN
    FOR i := FIRST(y.data^) TO LAST(y.data^) DO
      WITH zdata = SUBARRAY(z.data^, i * factor, NUMBER(x.data^)) DO
        VS.Add(zdata, zdata, V.Scale(x.data, y.data[i])^);
      END;
    END;
    (* this will be approximately equal <*ASSERT
       z.equal(x.convolve(y.upsample(factor)))*> *)
    RETURN z;
  END UpConvolve;

PROCEDURE ConvolveShort (x, y: T; ): T =
  VAR
    z := NEW(T, first := x.first,
             data := NEW(V.T, NUMBER(x.data^) - NUMBER(y.data^) + 1));
  BEGIN
    FOR i := 0 TO LAST(z.data^) DO
      WITH xdata = SUBARRAY(x.data^, i, NUMBER(y.data^)) DO
        VAR
          sum := R.Zero;
          k   := NUMBER(y.data^);
        BEGIN
          FOR j := 0 TO LAST(y.data^) DO
            DEC(k);
            sum := R.Add(sum, R.Mul(xdata[j], y.data[k]));
          END;
          z.data[i] := sum;
        END;
      END;
    END;
    RETURN z;
  END ConvolveShort;

PROCEDURE ExtractPeaks (x: T; factor: ScalingType; ): T =
  VAR
    xFirst := x.first;
    xLast  := x.first + LAST(x.data^);
    zFirst := xFirst + (-xFirst MOD factor);
    zLast  := xLast - xLast MOD factor;
    z      := NEW(T);
  BEGIN
    IF zFirst <= zLast THEN
      z := z.initFL(zFirst, zLast);
      (*z is already cleared, copy the peaks*)
      VAR i := zFirst - xFirst;
      BEGIN
        FOR j := FIRST(z.data^) TO LAST(z.data^) BY factor DO
          z.data[j] := x.data[i];
          INC(i, factor);
        END;
      END;
      <* ASSERT z.equal(x.downsample(factor).upsample(factor)) *>
      RETURN z;
    ELSE
      RETURN z.init(zFirst, 1);
    END;
  END ExtractPeaks;

BEGIN
  Zero := NEW(T).fromArray(ARRAY OF R.T{R.Zero});
  One := NEW(T).fromArray(ARRAY OF R.T{R.One});
END Signal.
