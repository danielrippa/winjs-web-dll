unit ChakraWebUtils;

{$mode delphi}

interface

  uses
    ChakraTypes;

  function HttpGetString(aURL: WideString; var Response: WideString): Integer;
  function HttpGetFile(aUrl: WideString; aFileName: WideString): Integer;

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

  function HttpGetFile;
  var
    Client: TFpHttpClient;
  begin

    try

      try

        Client := GetHttpClient;
        Client.Get(aURL, aFileName);

        Result := Client.ResponseStatusCode;

      except
        on e: Exception do ThrowError(e.Message, []);

      end;

    finally
      Client.Free;
    end;
  end;

  initialization

    InitSSLInterface;

end.