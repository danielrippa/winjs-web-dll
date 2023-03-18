unit ChakraWeb;

{$mode delphi}

interface

  uses ChakraTypes;

  function GetJsValue: TJsValue;

implementation

  uses
    Chakra, ChakraUtils, ChakraWebUtils, Win32Web;

  function WebGetContent(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    aURL: WideString;
    Response: WideString;
  begin
    CheckParams('getContent', Args, ArgCount, [jsString], 1);
    aURL := JsStringAsString(Args^);

    Result := CreateObject;

    SetProperty(Result, 'statusCode', IntAsJsNumber(HttpGetString(aURL, Response)));
    SetProperty(Result, 'responseString', StringAsJsString(Response));
  end;

  function WebGetFile(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    aURL: WideString;
    aFileName: WideString;
  begin
    CheckParams('getFile', Args, ArgCount, [jsString, jsString], 2);
    aURL := JsStringAsString(Args^); Inc(Args);
    aFileName := JsStringAsString(Args^);

    Result := IntAsJsNumber(HttpGetFile(aURL, aFileName));
  end;

  function WebGetConnectionState(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := CreateObject;

    with GetInternetConnectionState do begin
      SetProperty(Result, 'connectionName', StringAsJsString(ConnectionName));
      SetProperty(Result, 'isConnected', BooleanAsJsBoolean(IsConnected));
      SetProperty(Result, 'isConfigured', BooleanAsJsBoolean(IsConfigured));
      SetProperty(Result, 'isLan', BooleanAsJsBoolean(IsLan));
      SetProperty(Result, 'isOffline', BooleanAsJsBoolean(IsOffline));
      SetProperty(Result, 'isProxy', BooleanAsJsBoolean(IsProxy));
    end;
  end;

  function GetJsValue;
  begin
    Result := CreateObject;

    SetFunction(Result, 'getConnectionState', WebGetConnectionState);
    SetFunction(Result, 'getContent', WebGetContent);
    SetFunction(Result, 'getFile', WebGetFile);
  end;

end.