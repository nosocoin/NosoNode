unit NosoWallCon;

{
nosowallcon 1.0
Oct 30th, 2023
Stand alone unit to control wallet addresses file.
}

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, nosodebug,nosocrypto;

TYPE
  WalletData = Packed Record
    Hash : String[40]; // El hash publico o direccion
    Custom : String[40]; // En caso de que la direccion este personalizada
    PublicKey : String[255]; // clave publica
    PrivateKey : String[255]; // clave privada
    Balance : int64; // el ultimo saldo conocido de la direccion
    Pending : int64; // el ultimo saldo de pagos pendientes
    Score : int64; // estado del registro de la direccion.
    LastOP : int64;// tiempo de la ultima operacion en UnixTime.
    end;

Procedure ClearWalletArray();
Procedure InsertToWallArr(LData:WalletData);
Function GetWallArrIndex(Index:integer):WalletData;
Function LenWallArr():Integer;

function CreateNewWallet():Boolean;
Function SaveWalletToFile():boolean;
Function LoadWallet(wallet:String):Boolean;


var
  WalletArray     : array of walletData; // Wallet addresses
  FileWallet      : file of WalletData;
  WalletFilename  : string= 'NOSODATA'+DirectorySeparator+'wallet.pkw';
  CS_WalletFile   : TRTLCriticalSection;
  CS_WalletArray  : TRTLCriticalSection;

IMPLEMENTATION

Procedure ClearWalletArray();
Begin
  EnterCriticalSection(CS_WalletArray);
  setlength(WalletArray,0);
  LeaveCriticalSection(CS_WalletArray);
End;

Procedure InsertToWallArr(LData:WalletData);
Begin
  EnterCriticalSection(CS_WalletArray);
  Insert(LData,WalletArray,length(WalletArray));
  LeaveCriticalSection(CS_WalletArray);
End;

Function GetWallArrIndex(Index:integer):WalletData;
Begin
  EnterCriticalSection(CS_WalletArray);
  if Index <= Length(WalletArray)-1 then
    Result := WalletArray[Index]
  else result := Default(WalletData);
  LeaveCriticalSection(CS_WalletArray);
End;

Function LenWallArr():Integer;
Begin
  EnterCriticalSection(CS_WalletArray);
  Result := Length(WalletArray);
  LeaveCriticalSection(CS_WalletArray);
End;

// Creates a new wallet file with a new generated address
function CreateNewWallet():Boolean;
var
  NewAddress : WalletData;
  PubKey,PriKey : string;
Begin
  TRY
  if not fileexists (WalletFilename) then // Check to avoid delete an existing file
    begin
    ClearWalletArray;
    NewAddress := Default(WalletData);
    NewAddress.Hash:=GenerateNewAddress(PubKey,PriKey);
    NewAddress.PublicKey:=pubkey;
    NewAddress.PrivateKey:=PriKey;
    InsertToWallArr(NewAddress);
    SaveWalletToFile;
    end;
   EXCEPT on E:Exception do
      ToLog('events',TimeToStr(now)+'Error creating wallet file');
   END; {TRY}
End;

// Save the wallet array to the file
Function SaveWalletToFile():boolean;
var
  MyStream : TMemoryStream;
  Counter  : integer;
Begin
  MyStream:= TMemoryStream.Create;
  MyStream.Position:=0;
  EnterCriticalSection(CS_WalletArray);
  for Counter := 0 to length(WalletArray)-1 do
    begin
    MyStream.Write(WalletArray[counter],SizeOf(WalletData));
    end;
  LeaveCriticalSection(CS_WalletArray);
  EnterCriticalSection(CS_WalletFile);
  MyStream.SaveToFile(WalletFilename);
  LeaveCriticalSection(CS_WalletFile);
  MyStream.Free;
End;

Function LoadWallet(wallet:String):Boolean;
var
  MyStream    : TMemoryStream;
  ThisAddress : WalletData;
  Counter     : integer;
  Records     : integer;
Begin
  MyStream := TMemoryStream.Create;
  TRY
  if fileExists(wallet) then
    begin
    EnterCriticalSection(CS_WalletFile);
    MyStream.LoadFromFile(wallet);
    LeaveCriticalSection(CS_WalletFile);
    Records := MyStream.Size div sizeof(WalletData);
    MyStream.Position:=0;
    ClearWalletArray;
    For counter := 0 to records-1 do
      begin
      MyStream.Read(ThisAddress,Sizeof(WalletData));
      InsertToWallArr(ThisAddress);
      end;
    end;
  EXCEPT ON E:EXCEPTION do
    begin

    end;
  end;
  MyStream.Free;
End;

INITIALIZATION
InitCriticalSection(CS_WalletArray);
InitCriticalSection(CS_WalletFile);

FINALIZATION
DoneCriticalSection(CS_WalletArray);
DoneCriticalSection(CS_WalletFile);
END.




