{****************************************************************************
*                                                                           *
*   This file is part of the LGenerics package.                             *
*                                                                           *
*   Copyright(c) 2018-2019 A.Koverdyaev(avk)                                *
*                                                                           *
*   This code is free software; you can redistribute it and/or modify it    *
*   under the terms of the Apache License, Version 2.0;                     *
*   You may obtain a copy of the License at                                 *
*     http://www.apache.org/licenses/LICENSE-2.0.                           *
*                                                                           *
*  Unless required by applicable law or agreed to in writing, software      *
*  distributed under the License is distributed on an "AS IS" BASIS,        *
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. *
*  See the License for the specific language governing permissions and      *
*  limitations under the License.                                           *
*                                                                           *
*****************************************************************************}
unit LGFunction;

{$MODE OBJFPC}{$H+}
{$INLINE ON}{$WARN 6058 off : }
{$MODESWITCH ADVANCEDRECORDS}
{$MODESWITCH NESTEDPROCVARS}

interface

uses

  SysUtils,
  LGUtils,
  {%H-}LGHelpers,
  LGAbstractContainer;

type

  generic TGMapping<X, Y> = class
  public
  type
    TMapFunc     = specialize TGMapFunc<X, Y>;
    TOnMap       = specialize TGOnMap<X, Y>;
    TNestMap     = specialize TGNestMap<X, Y>;
    TArrayX      = specialize TGArray<X>;
    IEnumerableX = specialize IGEnumerable<X>;
    IEnumerableY = specialize IGEnumerable<Y>;

  strict private
  type
    TArrayCursor = class abstract(specialize TGAutoEnumerable<Y>)
    protected
      FArray: TArrayX;
      FCurrIndex: SizeInt;
    public
      constructor Create(constref a: TArrayX);
      function  MoveNext: Boolean; override;
      procedure Reset; override;
    end;

    TEnumeratorX = specialize TGEnumerator<X>;

    TEnumCursor = class abstract(specialize TGAutoEnumerable<Y>)
    protected
      FEnum: TEnumeratorX;
    public
      constructor Create(e : TEnumeratorX);
      destructor Destroy; override;
      function  MoveNext: Boolean; override;
      procedure Reset; override;
    end;

    TArrayRegularMap = class(TArrayCursor)
    protected
      FMap: TMapFunc;
      function GetCurrent: Y; override;
    public
      constructor Create(constref a: TArrayX; aMap: TMapFunc);
    end;

    TArrayDelegatedMap = class(TArrayCursor)
    protected
      FMap: TOnMap;
      function GetCurrent: Y; override;
    public
      constructor Create(constref a: TArrayX; aMap: TOnMap);
    end;

    TArrayNestedMap = class(TArrayCursor)
    protected
      FMap: TNestMap;
      function GetCurrent: Y; override;
    public
      constructor Create(constref a: TArrayX; aMap: TNestMap);
    end;

    TEnumRegularMap = class(TEnumCursor)
    protected
      FMap: TMapFunc;
      function GetCurrent: Y; override;
    public
      constructor Create(e: IEnumerableX; aMap: TMapFunc);
    end;

    TEnumDelegatedMap = class(TEnumCursor)
    protected
      FMap: TOnMap;
      function GetCurrent: Y; override;
    public
      constructor Create(e: IEnumerableX; aMap: TOnMap);
    end;

    TEnumNestedMap = class(TEnumCursor)
    protected
      FMap: TNestMap;
      function GetCurrent: Y; override;
    public
      constructor Create(e: IEnumerableX; aMap: TNestMap);
    end;

  public
    class function Apply(const a: TArrayX; f: TMapFunc): IEnumerableY; static; inline;
    class function Apply(const a: TArrayX; f: TOnMap): IEnumerableY; static; inline;
    class function Apply(const a: TArrayX; f: TNestMap): IEnumerableY; static; inline;
    class function Apply(e: IEnumerableX; f: TMapFunc): IEnumerableY; static; inline;
    class function Apply(e: IEnumerableX; f: TOnMap): IEnumerableY; static; inline;
    class function Apply(e: IEnumerableX; f: TNestMap): IEnumerableY; static; inline;
  end;

  generic TGFolding<X, Y> = class
  public
  type
    IXEnumerable = specialize IGEnumerable<X>;
    TFold        = specialize TGFold<X, Y>;
    TOnFold      = specialize TGOnFold<X, Y>;
    TNestFold    = specialize TGNestFold<X, Y>;
    TOptional    = specialize TGOptional<Y>;

    class function Left(const a: array of X; f: TFold; constref y0: Y): Y; static;
    class function Left(const a: array of X; f: TFold): TOptional; static;
    class function Left(const a: array of X; f: TOnFold; constref y0: Y): Y; static;
    class function Left(const a: array of X; f: TOnFold): TOptional; static;
    class function Left(const a: array of X; f: TNestFold; constref y0: Y): Y; static;
    class function Left(const a: array of X; f: TNestFold): TOptional; static;
    class function Left(e: IXEnumerable; f: TFold; constref y0: Y): Y; static;
    class function Left(e: IXEnumerable; f: TFold): TOptional; static;
    class function Left(e: IXEnumerable; f: TOnFold; constref y0: Y): Y; static;
    class function Left(e: IXEnumerable; f: TOnFold): TOptional; static;
    class function Left(e: IXEnumerable; f: TNestFold; constref y0: Y): Y; static;
    class function Left(e: IXEnumerable; f: TNestFold): TOptional; static;
    class function Right(const a: array of X; f: TFold; constref y0: Y): Y; static;
    class function Right(const a: array of X; f: TFold): TOptional; static;
    class function Right(const a: array of X; f: TOnFold; constref y0: Y): Y; static;
    class function Right(const a: array of X; f: TOnFold): TOptional; static;
    class function Right(const a: array of X; f: TNestFold; constref y0: Y): Y; static;
    class function Right(const a: array of X; f: TNestFold): TOptional; static;
    class function Right(e: IXEnumerable; f: TFold; constref y0: Y): Y; static;
    class function Right(e: IXEnumerable; f: TFold): TOptional; static;
    class function Right(e: IXEnumerable; f: TOnFold; constref y0: Y): Y; static;
    class function Right(e: IXEnumerable; f: TOnFold): TOptional; static;
    class function Right(e: IXEnumerable; f: TNestFold; constref y0: Y): Y; static;
    class function Right(e: IXEnumerable; f: TNestFold): TOptional; static;
  end;

  generic TGUnboundGenerator<TState, TResult> = class(specialize TGEnumerable<TResult>)
  public
  type
    TGetNext = function(var aState: TState): TResult;

  private
  type
    TEnumerator = class(specialize TGAutoEnumerable<TResult>)
    private
      FOwner: TGUnboundGenerator;
    protected
      function GetCurrent: TResult; override;
    public
      constructor Create(aOwner: TGUnboundGenerator);
      function  MoveNext: Boolean; override;
      procedure Reset; override;
    end;

  var
    FState: TState;
    FGetNext: TGetNext;
  public
    constructor Create(constref aInitState: TState; aGetNext: TGetNext);
    function GetEnumerator: TSpecEnumerator; override;
  end;

  generic TGGenerator<TState, TResult> = class(specialize TGEnumerable<TResult>)
  public
  type
    TGetNext = function(var aState: TState; out aResult: TResult): Boolean;

  private
  type
    TEnumerator = class(specialize TGAutoEnumerable<TResult>)
    private
      FOwner: TGGenerator;
    protected
      function GetCurrent: TResult; override;
    public
      constructor Create(aOwner: TGGenerator);
      function  MoveNext: Boolean; override;
      procedure Reset; override;
    end;

  var
    FState: TState;
    FResult: TResult;
    FGetNext: TGetNext;
  public
    constructor Create(constref aInitState: TState; aGetNext: TGetNext);
    function GetEnumerator: TSpecEnumerator; override;
  end;

  { monadic regular function }
  generic TGMonadic<T, TResult> = function(constref v: T): TResult;
  { dyadic regular function }
  generic TGDyadic<T1, T2, TResult> = function(constref v1: T1; constref v2: T2): TResult;
  { triadic regular function }
  generic TGTriadic<T1, T2, T3, TResult> = function(constref v1: T1; constref v2: T2; constref v3: T3): TResult;

  generic TGDeferMonadic<T, TResult> = record
  public
  type
    TFun = specialize TGMonadic<T, TResult>;

  strict private
    FCall: TFun;
    FParam: T;
  public
    constructor Create(aFun: TFun; constref v: T);
    function Call: TResult; inline;
  end;

  generic TGDeferDyadic<T1, T2, TResult> = record
  public
  type
    TFun = specialize TGDyadic<T1, T2, TResult>;

  strict private
    FCall: TFun;
    FParam1: T1;
    FParam2: T2;
  public
    constructor Create(aFun: TFun; constref v1: T1; constref v2: T2);
    function Call: TResult; inline;
  end;

  generic TGDeferTriadic<T1, T2, T3, TResult> = record
  public
  type
    TFun = specialize TGTriadic<T1, T2, T3, TResult>;

  strict private
    FCall: TFun;
    FParam1: T1;
    FParam2: T2;
    FParam3: T3;
  public
    constructor Create(aFun: TFun; constref v1: T1; constref v2: T2; constref v3: T3);
    function Call: TResult; inline;
  end;

implementation
{$B-}{$COPERATORS ON}

{ TGMapping.TArrayCursor }

constructor TGMapping.TArrayCursor.Create(constref a: TArrayX);
begin
  inherited Create;
  FArray := a;
  FCurrIndex := -1;
end;

function TGMapping.TArrayCursor.MoveNext: Boolean;
begin
  Result := FCurrIndex < System.High(FArray);
  FCurrIndex += Ord(Result);
end;

procedure TGMapping.TArrayCursor.Reset;
begin
  FCurrIndex := -1;
end;

{ TGMapping.TEnumCursor }

constructor TGMapping.TEnumCursor.Create(e: TEnumeratorX);
begin
  inherited Create;
  FEnum := e;
end;

destructor TGMapping.TEnumCursor.Destroy;
begin
  FEnum.Free;
  inherited;
end;

function TGMapping.TEnumCursor.MoveNext: Boolean;
begin
  Result := FEnum.MoveNext;
end;

procedure TGMapping.TEnumCursor.Reset;
begin
  FEnum.Reset;
end;

{ TArrayRegularMap }

function TGMapping.TArrayRegularMap.GetCurrent: Y;
begin
  Result := FMap(FArray[FCurrIndex]);
end;

constructor TGMapping.TArrayRegularMap.Create(constref a: TArrayX; aMap: TMapFunc);
begin
  inherited Create(a);
  FMap := aMap;
end;

{ TArrayDelegatedMap }

function TGMapping.TArrayDelegatedMap.GetCurrent: Y;
begin
  Result := FMap(FArray[FCurrIndex]);
end;

constructor TGMapping.TArrayDelegatedMap.Create(constref a: TArrayX; aMap: TOnMap);
begin
  inherited Create(a);
  FMap := aMap;
end;

{ TGMapping.TArrayNestedMap }

function TGMapping.TArrayNestedMap.GetCurrent: Y;
begin
  Result := FMap(FArray[FCurrIndex]);
end;

constructor TGMapping.TArrayNestedMap.Create(constref a: TArrayX; aMap: TNestMap);
begin
  inherited Create(a);
  FMap := aMap;
end;

{ TEnumRegularMap }

function TGMapping.TEnumRegularMap.GetCurrent: Y;
begin
  Result := FMap(FEnum.Current);
end;

constructor TGMapping.TEnumRegularMap.Create(e: IEnumerableX; aMap: TMapFunc);
begin
  inherited Create(e.GetEnumerator);
  FMap := aMap;
end;

{ TEnumDelegatedMap }

function TGMapping.TEnumDelegatedMap.GetCurrent: Y;
begin
  Result := FMap(FEnum.Current);
end;

constructor TGMapping.TEnumDelegatedMap.Create(e: IEnumerableX; aMap: TOnMap);
begin
  inherited Create(e.GetEnumerator);
  FMap := aMap;
end;

{ TGMapping.TEnumNestedMap }

function TGMapping.TEnumNestedMap.GetCurrent: Y;
begin
  Result := FMap(FEnum.Current);
end;

constructor TGMapping.TEnumNestedMap.Create(e: IEnumerableX; aMap: TNestMap);
begin
  inherited Create(e.GetEnumerator);
  FMap := aMap;
end;

{ TGMapping }

class function TGMapping.Apply(const a: TArrayX; f: TMapFunc): IEnumerableY;
begin
  Result := TArrayRegularMap.Create(a, f);
end;

class function TGMapping.Apply(const a: TArrayX; f: TOnMap): IEnumerableY;
begin
  Result := TArrayDelegatedMap.Create(a, f);
end;

class function TGMapping.Apply(const a: TArrayX; f: TNestMap): IEnumerableY;
begin
  Result := TArrayNestedMap.Create(a, f);
end;

class function TGMapping.Apply(e: IEnumerableX; f: TMapFunc): IEnumerableY;
begin
  Result := TEnumRegularMap.Create(e, f);
end;

class function TGMapping.Apply(e: IEnumerableX; f: TOnMap): IEnumerableY;
begin
  Result := TEnumDelegatedMap.Create(e, f);
end;

class function TGMapping.Apply(e: IEnumerableX; f: TNestMap): IEnumerableY;
begin
  Result := TEnumNestedMap.Create(e, f);
end;

{ TGFolding }
{$PUSH}{$MACRO ON}
{$DEFINE FoldArray :=
  Result := y0;
  for v in a do
    Result := f(v, Result)
}
{$DEFINE ReduceArray :=
  if System.Length(a) > 0 then
    begin
      v := a[0];
      for I := 1 to System.High(a) do
        v := f(a[I], v);
      Result := v;
    end
}
class function TGFolding.Left(const a: array of X; f: TFold; constref y0: Y): Y;
var
  v: X;
begin
  FoldArray;
end;

class function TGFolding.Left(const a: array of X; f: TFold): TOptional;
var
  v: X;
  I: SizeInt;
begin
  ReduceArray;
end;

class function TGFolding.Left(const a: array of X; f: TOnFold; constref y0: Y): Y;
var
  v: X;
begin
  FoldArray;
end;

class function TGFolding.Left(const a: array of X; f: TOnFold): TOptional;
var
  v: X;
  I: SizeInt;
begin
  ReduceArray;
end;

class function TGFolding.Left(const a: array of X; f: TNestFold; constref y0: Y): Y;
var
  v: X;
begin
  FoldArray;
end;

class function TGFolding.Left(const a: array of X; f: TNestFold): TOptional;
var
  v: X;
  I: SizeInt;
begin
  ReduceArray;
end;
{$DEFINE FoldEnum :=
  Result := y0;
  for v in e do
    Result := f(v, Result)
}
{$DEFINE ReduceEnum :=
  with e.GetEnumerator do
    try
      if MoveNext then
        begin
          v := Current;
          while MoveNext do
            v := f(Current, v);
          Result := v;
        end;
    finally
      Free;
    end
}
class function TGFolding.Left(e: IXEnumerable; f: TFold; constref y0: Y): Y;
var
  v: X;
begin
  FoldEnum;
end;

class function TGFolding.Left(e: IXEnumerable; f: TFold): TOptional;
var
  v: X;
begin
  ReduceEnum;
end;

class function TGFolding.Left(e: IXEnumerable; f: TOnFold; constref y0: Y): Y;
var
  v: X;
begin
  FoldEnum;
end;

class function TGFolding.Left(e: IXEnumerable; f: TOnFold): TOptional;
var
  v: X;
begin
  ReduceEnum;
end;

class function TGFolding.Left(e: IXEnumerable; f: TNestFold; constref y0: Y): Y;
var
  v: X;
begin
  FoldEnum;
end;

class function TGFolding.Left(e: IXEnumerable; f: TNestFold): TOptional;
var
  v: X;
begin
  ReduceEnum;
end;
{$PUSH}{$MACRO ON}
{$DEFINE FoldArray :=
  Result := y0;
  for I := System.High(a) downto 0 do
    Result := f(a[I], Result)
}
{$DEFINE ReduceArray :=
  if System.Length(a) > 0 then
    begin
      I := System.High(a);
      v := a[I];
      for I := Pred(I) downto 0 do
        v := f(a[I], v);
      Result := v;
    end
}
class function TGFolding.Right(const a: array of X; f: TFold; constref y0: Y): Y;
var
  v: X;
  I: SizeInt;
begin
  FoldArray;
end;

class function TGFolding.Right(const a: array of X; f: TFold): TOptional;
var
  v: X;
  I: SizeInt;
begin
  ReduceArray;
end;

class function TGFolding.Right(const a: array of X; f: TOnFold; constref y0: Y): Y;
var
  v: X;
  I: SizeInt;
begin
  FoldArray;
end;

class function TGFolding.Right(const a: array of X; f: TOnFold): TOptional;
var
  v: X;
  I: SizeInt;
begin
  ReduceArray;
end;

class function TGFolding.Right(const a: array of X; f: TNestFold; constref y0: Y): Y;
var
  v: X;
  I: SizeInt;
begin
  FoldArray;
end;

class function TGFolding.Right(const a: array of X; f: TNestFold): TOptional;
var
  v: X;
  I: SizeInt;
begin
  ReduceArray;
end;
{$DEFINE FoldEnum :=
  Result := y0;
  for v in e.Reverse do
    Result := f(v, Result)
}
{$DEFINE ReduceEnum :=
  with e.Reverse.GetEnumerator do
    try
      if MoveNext then
        begin
          v := Current;
          while MoveNext do
            v := f(Current, v);
          Result := v;
        end;
    finally
      Free;
    end
}
class function TGFolding.Right(e: IXEnumerable; f: TFold; constref y0: Y): Y;
var
  v: X;
begin
  FoldEnum;
end;

class function TGFolding.Right(e: IXEnumerable; f: TFold): TOptional;
var
  v: X;
begin
  ReduceEnum;
end;

class function TGFolding.Right(e: IXEnumerable; f: TOnFold; constref y0: Y): Y;
var
  v: X;
begin
  FoldEnum;
end;

class function TGFolding.Right(e: IXEnumerable; f: TOnFold): TOptional;
var
  v: X;
begin
  ReduceEnum;
end;

class function TGFolding.Right(e: IXEnumerable; f: TNestFold; constref y0: Y): Y;
var
  v: X;
begin
  FoldEnum;
end;

class function TGFolding.Right(e: IXEnumerable; f: TNestFold): TOptional;
var
  v: X;
begin
  ReduceEnum;
end;
{$UNDEF FoldArray}{$UNDEF ReduceArray}{$UNDEF FoldEnum}{$UNDEF ReduceEnum}
{$POP}

{ TGUnboundGenerator.TEnumerator }

function TGUnboundGenerator.TEnumerator.GetCurrent: TResult;
begin
  Result := FOwner.FGetNext(FOwner.FState);
end;

constructor TGUnboundGenerator.TEnumerator.Create(aOwner: TGUnboundGenerator);
begin
  inherited Create;
  FOwner := aOwner;
end;

function TGUnboundGenerator.TEnumerator.MoveNext: Boolean;
begin
  Result := True;
end;

procedure TGUnboundGenerator.TEnumerator.Reset;
begin
end;

{ TGUnboundGenerator }

constructor TGUnboundGenerator.Create(constref aInitState: TState; aGetNext: TGetNext);
begin
  inherited Create;
  FState := aInitState;
  FGetNext := aGetNext;
end;

function TGUnboundGenerator.GetEnumerator: TSpecEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

{ TGGenerator.TEnumerator }

function TGGenerator.TEnumerator.GetCurrent: TResult;
begin
  Result := FOwner.FResult;
end;

constructor TGGenerator.TEnumerator.Create(aOwner: TGGenerator);
begin
  inherited Create;
  FOwner := aOwner;
end;

function TGGenerator.TEnumerator.MoveNext: Boolean;
begin
  Result := FOwner.FGetNext(FOwner.FState, FOwner.FResult);
end;

procedure TGGenerator.TEnumerator.Reset;
begin
end;

{ TGGenerator }

constructor TGGenerator.Create(constref aInitState: TState; aGetNext: TGetNext);
begin
  inherited Create;
  FState := aInitState;
  FGetNext := aGetNext;
  FResult := Default(TResult);
end;

function TGGenerator.GetEnumerator: TSpecEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

{ TGDeferMonadic }

constructor TGDeferMonadic.Create(aFun: TFun; constref v: T);
begin
  FCall := aFun;
  FParam := v;
end;

function TGDeferMonadic.Call: TResult;
begin
  Result := FCall(FParam);
end;

{ TGDeferDyadic }

constructor TGDeferDyadic.Create(aFun: TFun; constref v1: T1; constref v2: T2);
begin
  FCall := aFun;
  FParam1 := v1;
  FParam2 := v2;
end;

function TGDeferDyadic.Call: TResult;
begin
  Result := FCall(FParam1, FParam2);
end;

{ TGDeferTriadic }

constructor TGDeferTriadic.Create(aFun: TFun; constref v1: T1; constref v2: T2; constref v3: T3);
begin
  FCall := aFun;
  FParam1 := v1;
  FParam2 := v2;
  FParam3 := v3;
end;

function TGDeferTriadic.Call: TResult;
begin
  Result := FCall(FParam1, FParam2, FParam3);
end;

end.

