unit ChakraWebUtils;

{$mode delphi}

interface

  uses
    ChakraTypes;

  function HttpGetString(aURL: WideString; var Response: WideString): Integer;
  function HttpGetFile(aUrl: WideString; aFileName: WideString; ProgressCallback: TJsValue): Integer;
  function HttpGetContentLength(aURL: WideString; var ContentLength: Integer): Integer;

implementation

  uses
    Chakra, ChakraUtils, FpHttpClient, OpenSSL, OpenSSLSockets, SysUtils, ChakraErr;

  function GetHttpClient: TFpHttpClient;
  begin

    Result := TFpHttpClient.Create(Nil);
    Result.AllowRedirect := True;

  end;

  function HttpGetString;
  var
    Client: TFpHttpClient;
  begin
    try

      try

        Client := GetHttpClient;
        Response := Client.Get(aURL);

        Result := Client.ResponseStatusCode;

      except
        on E: Exception do ThrowError(e.Message, []);

      end;

    finally
      Client.Free;
    end;
  end;

  type

    TDataReceiver = class
      private
        FProgressCallback: TJsValue;
      public
        constructor Create(aProgressCallback: TJsValue);
        procedure DataReceived(Sender: TObject; const ContentLength, CurrentPos: Int64);
    end;

  constructor TDataReceiver.Create;
  begin
    FProgressCallback := aProgressCallback;
  end;

  procedure TDataReceiver.DataReceived;
  var
    Args: Array of TJsValue;
    ArgCount: Word;
  begin
    ArgCount := 3;
    Args := [Undefined, IntAsJsNumber(ContentLength), IntAsJsNumber(CurrentPos)];

    CallFunction(FProgressCallback, @Args[0], ArgCount);
  end;

  function HttpGetFile;
  var
    Client: TFpHttpClient;
    DataReceiver: TDataReceiver;
  begin

    try

      try

        Client := GetHttpClient;
        DataReceiver := TDataReceiver.Create(ProgressCallback);

        Client.OnDataReceived := DataReceiver.DataReceived;
        Client.Get(aURL, aFileName);

        Result := Client.ResponseStatusCode;

      except
        on e: Exception do ThrowError(e.Message, []);

      end;

    finally
      DataReceiver.Free;
      Client.Free;
    end;
  end;

  function HttpGetContentLength;
  var
    Client: TFpHttpClient;
    I: Integer;
  begin
    try

      try

        Client := GetHttpClient;

        Client.HttpMethod('HEAD', aURL, Nil, []);

        with Client.ResponseHeaders do begin
          for I := 0 to Pred(Count) do begin
            if LowerCase(Names[I]) = 'content-length' then begin

              ContentLength := StrToInt64(ValueFromIndex[I]);
              Result := Client.ResponseStatusCode;
              Break;

            end;
          end;
        end;

      except
        on E: Exception do ThrowError(E.Message, []);

      end;

    finally
      Client.Free;
    end;

  end;

  initialization

    InitSSLInterface;

end.