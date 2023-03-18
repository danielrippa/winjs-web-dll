unit Win32Web;

{$mode delphi}

interface

  type

    TInternetConnection = record
      ConnectionName: String;
      IsConnected: Boolean;
      IsConfigured: Boolean;
      IsLan: Boolean;
      IsModem: Boolean;
      IsOffline: Boolean;
      IsProxy: Boolean;
    end;

  function GetInternetConnectionState: TInternetConnection;

implementation

  uses Windows, WinInet;

  function GetInternetConnectionState;
  var
    State: DWord;
    NameLength: Integer;
    Name: Array[0..128] of Char;
  begin

    NameLength := SizeOf(Name);
    FillChar(Name, NameLength, 0);

    with Result do begin

      IsConnected := InternetGetConnectedStateEx(@State, Name, NameLength, 0);
      ConnectionName := Name;

      IsConfigured := (State and INTERNET_CONNECTION_CONFIGURED) = INTERNET_CONNECTION_CONFIGURED;
      IsLan        := (State and INTERNET_CONNECTION_LAN)        = INTERNET_CONNECTION_LAN;
      IsModem      := (State and INTERNET_CONNECTION_MODEM)      = INTERNET_CONNECTION_MODEM;
      IsOffline    := (State and INTERNET_CONNECTION_OFFLINE)    = INTERNET_CONNECTION_OFFLINE;
      IsProxy      := (State and INTERNET_CONNECTION_PROXY)      = INTERNET_CONNECTION_PROXY;

    end;

  end;

end.