unit mpParser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MasterPaskalForm, mpGUI, mpRed, mpDisk, mpCripto, nosotime, mpblock, mpcoin,
  dialogs, fileutil, forms, idglobal, strutils, mpRPC, DateUtils, Clipbrd,translation,
  idContext, math, mpMN, MPSysCheck, nosodebug;

procedure ProcessLinesAdd(const ALine: String);
procedure OutgoingMsjsAdd(const ALine: String);
function OutgoingMsjsGet(): String;

Procedure ProcesarLineas();
function GetOpData(textLine:string):String;
Procedure ParseCommandLine(LineText:string);
Function GetCommand(LineText:String):String;
Function Parameter(LineText:String;ParamNumber:int64):String;
Procedure ShowNodes();
Procedure ShowBots();
Procedure ShowSlots();
Procedure ShowUser_Options();
function GetWalletBalance(): Int64;
Procedure ConnectTo(LineText:string);
Procedure ToTrayON();
Procedure ToTrayOFF();
Procedure ShowSumary();
Procedure AutoServerON();
Procedure AutoServerOFF();
Procedure AutoConnectON();
Procedure AutoConnectOFF();
Procedure ShowWallet();
Procedure ImportarWallet(LineText:string);
Procedure ExportarWallet(LineText:string);
Procedure ShowBlchHead(number:integer);
Procedure SetDefaultAddress(linetext:string);
Procedure ParseShowBlockInfo(LineText:string);
Procedure ShowBlockInfo(numberblock:integer);
Procedure showmd160(linetext:string);
Procedure CustomizeAddress(linetext:string);
Procedure Parse_SendFunds(LineText:string);
function SendFunds(LineText:string;showOutput:boolean=true):string;
Procedure Parse_SendGVT(LineText:string);
Function SendGVT(LineText:string;showOutput:boolean=true):string;
Procedure ShowHalvings();
Procedure GroupCoins(linetext:string);
Procedure SetServerPort(LineText:string);
Procedure Sha256(LineText:string);
Procedure TestParser(LineText:String);
Procedure DeleteBot(LineText:String);
Procedure showCriptoThreadinfo();
Procedure Parse_RestartNoso();
Procedure ShowNetworkDataInfo();
Procedure GetOwnerHash(LineText:string);
Procedure CheckOwnerHash(LineText:string);
Function CreateAppCode(Texto:string):string;
Function DecodeAppCode(Texto:string):string;
function AvailableUpdates():string;
Procedure RunUpdate(linea:string);
Procedure SendAdminMessage(linetext:string);
Procedure SetReadTimeOutTIme(LineText:string);
Procedure SetConnectTimeOutTIme(LineText:string);
Procedure RequestHeaders();
Procedure RequestSumary();
Procedure ShowOrderDetails(LineText:string);
Procedure ExportAddress(LineText:string);
Procedure ShowAddressInfo(LineText:string);
Procedure ShowAddressHistory(LineText:string);
Procedure ShowTotalFees();
function ShowPrivKey(linea:String;ToConsole:boolean = false):String;
Procedure TestNetwork(LineText:string);
Procedure ShowPendingTrxs();
Procedure WebWallet();
Procedure ExportKeys(linea:string);

// CONSULTING
Procedure ShowDiftory();
Function MainNetHashrate(blocks:integer = 100):int64;
Procedure ListGVTs();

// 0.2.1 DEBUG
Procedure ShowBlockPos(LineText:string);
Procedure showPosrequired(linetext:string);
Procedure ShowBlockMNs(LineText:string);
Procedure showgmts(LineText:string);
Procedure ShowSystemInfo(Linetext:string);

// EXCHANGE
Procedure PostOffer(LineText:String);

Procedure DebugTest(linetext:string);
Procedure DebugTest2(linetext:string);

implementation

uses
  mpProtocol;

// **************************
// *** CRITICIAL SECTIONS ***
// **************************

// Adds a line to ProcessLines thread safe
Procedure ProcessLinesAdd(const ALine: String);
Begin
EnterCriticalSection(CSProcessLines);
   TRY
   ProcessLines.Add(ALine);
   EXCEPT ON E:Exception do
      ToExcLog('Error on PROCESSLINESADD: '+E.Message);
   END; {TRY}
LeaveCriticalSection(CSProcessLines);
End;

// Adds a line to OutgoingMsjs thread safe
procedure OutgoingMsjsAdd(const ALine: String);
Begin
EnterCriticalSection(CSOutgoingMsjs);
   TRY
   OutgoingMsjs.Add(ALine);
   EXCEPT ON E:Exception do
      ToExcLog('Error on OutgoingMsjsAdd: '+E.Message);
   END{Try};
LeaveCriticalSection(CSOutgoingMsjs);
End;

// Gets a line from OutgoingMsjs thread safe
function OutgoingMsjsGet(): String;
var
  Linea : String;
Begin
Linea := '';
EnterCriticalSection(CSOutgoingMsjs);
TRY
Linea := OutgoingMsjs[0];
OutgoingMsjs.Delete(0);
EXCEPT ON E:Exception do
   ToExcLog('Error extracting outgoing line: '+E.Message);
END{Try};
LeaveCriticalSection(CSOutgoingMsjs);
result := linea;
End;

// Procesa las lineas de la linea de comandos
Procedure ProcesarLineas();
Begin
While ProcessLines.Count > 0 do
   begin
   ParseCommandLine(ProcessLines[0]);
   if ProcessLines.Count>0 then
     begin
     EnterCriticalSection(CSProcessLines);
     try
        ProcessLines.Delete(0);
     Except on E:Exception do
        begin
        ShowMessage ('Your wallet just exploded and we will close it for your security'+slinebreak+
                    'Error deleting line 0 from ProcessLines');
        halt(0);
        end;
     end;
     LeaveCriticalSection(CSProcessLines);
     end;
   end;
End;

// Elimina el encabezado de una linea de protocolo
function GetOpData(textLine:string):String;
var
  CharPos : integer;
Begin
charpos := pos('$',textline);
result := copy(textline,charpos,length(textline));
End;

Procedure ParseCommandLine(LineText:string);
var
  Command : String;
begin
Command :=GetCommand(Linetext);
if not AnsiContainsStr(HideCommands,Uppercase(command)) then AddToLog('Console','>> '+Linetext);
if UpperCase(Command) = 'VER' then AddToLog('console',ProgramVersion+SubVersion)
else if UpperCase(Command) = 'SERVERON' then StartServer()
else if UpperCase(Command) = 'SERVEROFF' then StopServer()
else if UpperCase(Command) = 'FORCESERVER' then ForceServer()
else if UpperCase(Command) = 'NODES' then ShowNodes()
else if UpperCase(Command) = 'BOTS' then ShowBots()
else if UpperCase(Command) = 'SLOTS' then ShowSlots()
else if UpperCase(Command) = 'CONNECT' then ConnectToServers()
else if UpperCase(Command) = 'DISCONNECT' then CerrarClientes()
else if UpperCase(Command) = 'OFFSET' then AddToLog('console','Server: '+NosoT_LastServer+SLINEBREAK+
  'Time offset seconds: '+IntToStr(NosoT_TimeOffset)+slinebreak+'Last update : '+TimeSinceStamp(NosoT_LastUpdate))
else if UpperCase(Command) = 'NEWADDRESS' then NuevaDireccion(linetext)
else if UpperCase(Command) = 'USEROPTIONS' then ShowUser_Options()
else if UpperCase(Command) = 'BALANCE' then AddToLog('console',Int2Curr(GetWalletBalance)+' '+CoinSimbol)
else if UpperCase(Command) = 'CONNECTTO' then ConnectTo(Linetext)
else if UpperCase(Command) = 'SUMARY' then ShowSumary()
else if UpperCase(Command) = 'AUTOSERVERON' then AutoServerON()
else if UpperCase(Command) = 'AUTOSERVEROFF' then AutoServerOFF()
else if UpperCase(Command) = 'AUTOCONNECTON' then AutoConnectON()
else if UpperCase(Command) = 'AUTOCONNECTOFF' then AutoConnectOFF()
else if UpperCase(Command) = 'SHOWWALLET' then ShowWallet()
else if UpperCase(Command) = 'IMPWALLET' then ImportarWallet(LineText)
else if UpperCase(Command) = 'EXPWALLET' then ExportarWallet(LineText)
else if UpperCase(Command) = 'RESUMEN' then ShowBlchHead(StrToIntDef(Parameter(Linetext,1),MyLastBlock))
else if UpperCase(Command) = 'SETDEFAULT' then SetDefaultAddress(LineText)
else if UpperCase(Command) = 'LBINFO' then ShowBlockInfo(MyLastBlock)
else if UpperCase(Command) = 'TIMESTAMP' then AddToLog('console',UTCTimeStr)
else if UpperCase(Command) = 'MD160' then showmd160(LineText)
else if UpperCase(Command) = 'UNDOBLOCK' then UndoneLastBlock()  // to be removed
else if UpperCase(Command) = 'CUSTOMIZE' then CustomizeAddress(LineText)
else if UpperCase(Command) = 'SENDTO' then Parse_SendFunds(LineText)
else if UpperCase(Command) = 'SENDGVT' then Parse_SendGVT(LineText)
else if UpperCase(Command) = 'HALVING' then ShowHalvings()
else if UpperCase(Command) = 'REBUILDSUMARY' then RebuildSumario(MyLastBlock)
else if UpperCase(Command) = 'REBUILDHEADERS' then BuildHeaderFile(MyLastBlock)
else if UpperCase(Command) = 'GROUPCOINS' then Groupcoins(linetext)
else if UpperCase(Command) = 'SETPORT' then SetServerPort(LineText)
else if UpperCase(Command) = 'SHA256' then Sha256(LineText)
else if UpperCase(Command) = 'MD5' then AddToLog('console',HashMD5String(Parameter(LineText,1)))
else if UpperCase(Command) = 'TOTRAYON' then ToTrayON()
else if UpperCase(Command) = 'TOTRAYOFF' then ToTrayOFF()
else if UpperCase(Command) = 'CLEAR' then form1.Memoconsola.Lines.clear
else if UpperCase(Command) = 'TP' then TestParser(LineText)
else if UpperCase(Command) = 'DELBOT' then DeleteBot(LineText)
else if UpperCase(Command) = 'CRIPTO' then showCriptoThreadinfo()
else if UpperCase(Command) = 'BLOCK' then ParseShowBlockInfo(LineText)
else if UpperCase(Command) = 'TESTNET' then TestNetwork(LineText)
else if UpperCase(Command) = 'RUNDIAG' then RunDiagnostico(LineText)
else if UpperCase(Command) = 'RESTART' then Parse_RestartNoso()
else if UpperCase(Command) = 'SND' then ShowNetworkDataInfo()
else if UpperCase(Command) = 'OSVERSION' then AddToLog('console',OsVersion)
else if UpperCase(Command) = 'DIRECTIVE' then SendAdminMessage(linetext)
else if UpperCase(Command) = 'MYHASH' then AddToLog('console',HashMD5File('noso.exe'))
else if UpperCase(Command) = 'ADDBOT' then AddNewBot(LineText)
else if UpperCase(Command) = 'SETRTOT' then SetReadTimeOutTIme(LineText)
else if UpperCase(Command) = 'SETCTOT' then SetConnectTimeOutTIme(LineText)
else if UpperCase(Command) = 'STATUS' then AddToLog('console',GetCurrentStatus(1))
else if UpperCase(Command) = 'OWNER' then GetOwnerHash(LineText)
else if UpperCase(Command) = 'CHECKOWNER' then CheckOwnerHash(LineText)
else if UpperCase(Command) = 'UPDATE' then RunUpdate(LineText)
else if UpperCase(Command) = 'RESTOREBLOCKCHAIN' then RestoreBlockChain()
else if UpperCase(Command) = 'RESTORESUMARY' then RestoreSumary(StrToIntDef(Parameter(LineText,1),0))
else if UpperCase(Command) = 'REQHEAD' then RequestHeaders()
else if UpperCase(Command) = 'REQSUM' then RequestSumary()
else if UpperCase(Command) = 'SAVEADV' then CreateADV(true)
else if UpperCase(Command) = 'ORDER' then ShowOrderDetails(LineText)
else if UpperCase(Command) = 'ORDERSOURCES' then AddToLog('console',GetOrderSources(Parameter(LineText,1)))
else if UpperCase(Command) = 'EXPORTADDRESS' then ExportAddress(LineText)
else if UpperCase(Command) = 'ADDRESS' then ShowAddressInfo(LineText)
else if UpperCase(Command) = 'HISTORY' then ShowAddressHistory(LineText)
else if UpperCase(Command) = 'TOTALFEES' then ShowTotalFees()
else if UpperCase(Command) = 'SUPPLY' then AddToLog('console','Current supply: '+Int2Curr(GetSupply(MyLastBlock)))
else if UpperCase(Command) = 'GMTS' then showgmts(LineText)
else if UpperCase(Command) = 'SHOWPRIVKEY' then ShowPrivKey(LineText, true)
else if UpperCase(Command) = 'SHOWPENDING' then ShowPendingTrxs()
else if UpperCase(Command) = 'WEBWAL' then WebWallet()
else if UpperCase(Command) = 'EXPKEYS' then ExportKeys(LineText)
else if UpperCase(Command) = 'CHECKUPDATES' then AddToLog('console',GetLastRelease)
else if UpperCase(Command) = 'ZIPSUMARY' then ZipSumary()
else if UpperCase(Command) = 'ZIPHEADERS' then ZipHeaders()
else if UpperCase(Command) = 'GETPOS' then AddToLog('console', GetPoSPercentage(StrToIntdef(Parameter(linetext,1),Mylastblock)).ToString )
else if UpperCase(Command) = 'GETMNS' then AddToLog('console', GetMNsPercentage(StrToIntdef(Parameter(linetext,1),Mylastblock)).ToString )
else if UpperCase(Command) = 'CLOSESTARTON' then WO_CloseStart := true
else if UpperCase(Command) = 'CLOSESTARTOFF' then WO_CloseStart := false
else if UpperCase(Command) = 'DT' then DebugTest(LineText)
else if UpperCase(Command) = 'TT' then DebugTest2(LineText)
else if UpperCase(Command) = 'BASE58SUM' then AddToLog('console',BMB58resumen(parameter(linetext,1)))
else if UpperCase(Command) = 'DECTO58' then AddToLog('console',BMDecTo58(parameter(linetext,1)))
else if UpperCase(Command) = 'HEXTO58' then AddToLog('console',BMHexTo58(parameter(linetext,1),58))
else if UpperCase(Command) = '58TODEC' then AddToLog('console',BM58ToDec(parameter(linetext,1)))
else if UpperCase(Command) = 'DECTOHEX' then AddToLog('console',BMDectoHex(parameter(linetext,1)))
else if UpperCase(Command) = 'NOSOHASH' then AddToLog('console',Nosohash(parameter(linetext,1)))
else if UpperCase(Command) = 'PENDING' then AddToLog('console',PendingRawInfo)
else if UpperCase(Command) = 'WEBSEED' then AddToLog('console',GetWebSeedNodes)
else if UpperCase(Command) = 'HEADER' then AddToLog('console',LastHeaders(StrToIntDef(parameter(linetext,1),-1)))
else if UpperCase(Command) = 'HEADSIZE' then AddToLog('console',GetHeadersSize.ToString)
else if UpperCase(Command) = 'CHECKSUM' then AddToLog('console',BMDecTo58(BMB58resumen(parameter(linetext,1))))

// CONSULTING
else if UpperCase(Command) = 'DIFTORY' then ShowDiftory()
else if UpperCase(Command) = 'NETRATE' then AddToLog('console','Average Mainnet hashrate: '+HashrateToShow(MainNetHashrate))
else if UpperCase(Command) = 'LISTGVT' then ListGVTs()
else if UpperCase(Command) = 'SYSTEM' then ShowSystemInfo(Linetext)
else if UpperCase(Command) = 'NOSOCFG' then AddToLog('console',GetNosoCFGString)
else if UpperCase(Command) = 'FUNDS' then AddToLog('console','Project funds: '+Int2curr(GetAddressAvailable('NpryectdevepmentfundsGE')))

// 0.2.1 DEBUG
else if UpperCase(Command) = 'BLOCKPOS' then ShowBlockPos(LineText)
else if UpperCase(Command) = 'POSSTACK' then showPosrequired(linetext)
else if UpperCase(Command) = 'BLOCKMNS' then ShowBlockMNs(LineText)
else if UpperCase(Command) = 'MYIP' then AddToLog('console',GetMiIP)
else if UpperCase(Command) = 'SHOWUPDATES' then AddToLog('console',StringAvailableUpdates)
else if UpperCase(Command) = 'CREATEAPPCODE' then AddToLog('console',CreateAppCode(parameter(linetext,1)))
else if UpperCase(Command) = 'DECODEAPPCODE' then AddToLog('console',DecodeAppCode(parameter(linetext,1)))
else if UpperCase(Command) = 'SETMODE' then SetCFGData(parameter(linetext,1),0)
else if UpperCase(Command) = 'ADDNODE' then AddCFGData(parameter(linetext,1),1)
else if UpperCase(Command) = 'DELNODE' then RemoveCFGData(parameter(linetext,1),1)
else if UpperCase(Command) = 'ADDPOOL' then AddCFGData(parameter(linetext,1),3)
else if UpperCase(Command) = 'DELPOOL' then RemoveCFGData(parameter(linetext,1),3)
else if UpperCase(Command) = 'RESTORECFG' then RestoreCFGData()
else if UpperCase(Command) = 'LOGSDATA' then AddToLog('console',GetLogsData)


// P2P
else if UpperCase(Command) = 'PEERS' then AddToLog('console','Server list: '+IntToStr(form1.ClientsCount)+'/'+IntToStr(GetIncomingConnections))

// RPC
else if UpperCase(Command) = 'SETRPCPORT' then SetRPCPort(LineText)
else if UpperCase(Command) = 'RPCON' then SetRPCOn()
else if UpperCase(Command) = 'RPCOFF' then SetRPCOff()

//EXCHANGE
else if UpperCase(Command) = 'POST' then PostOffer(LineText)

else AddToLog('console','Unknown command: '+Command);  // Unknow command
end;

// Obtiene el comando de una linea
Function GetCommand(LineText:String):String;
var
  Temp : String = '';
  ThisChar : Char;
  Contador : int64 = 1;
Begin
while contador <= Length(LineText) do
   begin
   ThisChar := Linetext[contador];
   if  ThisChar = ' ' then break
   else temp := temp+ ThisChar;
   contador := contador+1;
   end;
Result := Temp;
End;

// Devuelve un parametro del texto
Function Parameter(LineText:String;ParamNumber:int64):String;
var
  Temp : String = '';
  ThisChar : Char;
  Contador : int64 = 1;
  WhiteSpaces : int64 = 0;
  parentesis : boolean = false;
Begin
while contador <= Length(LineText) do
   begin
   ThisChar := Linetext[contador];
   if ((thischar = '(') and (not parentesis)) then parentesis := true
   else if ((thischar = '(') and (parentesis)) then
      begin
      result := '';
      exit;
      end
   else if ((ThisChar = ')') and (parentesis)) then
      begin
      if WhiteSpaces = ParamNumber then
         begin
         result := temp;
         exit;
         end
      else
         begin
         parentesis := false;
         temp := '';
         end;
      end
   else if ((ThisChar = ' ') and (not parentesis)) then
      begin
      WhiteSpaces := WhiteSpaces +1;
      if WhiteSpaces > Paramnumber then
         begin
         result := temp;
         exit;
         end;
      end
   else if ((ThisChar = ' ') and (parentesis) and (WhiteSpaces = ParamNumber)) then
      begin
      temp := temp+ ThisChar;
      end
   else if WhiteSpaces = ParamNumber then temp := temp+ ThisChar;
   contador := contador+1;
   end;
if temp = ' ' then temp := '';
Result := Temp;
End;

// muestra los nodos
Procedure ShowNodes();
var
  contador : integer = 0;
Begin
for contador := 0 to length(ListaNodos) - 1 do
   AddToLog('console',IntToStr(contador)+'- '+Listanodos[contador].ip+':'+Listanodos[contador].port+
   ' '+TimeSinceStamp(CadToNum(Listanodos[contador].LastConexion,0,'STI fails on shownodes')));
End;

// muestra los Bots
Procedure ShowBots();
var
  contador : integer = 0;
Begin
for contador := 0 to length(ListadoBots) - 1 do
   AddToLog('console',IntToStr(contador)+'- '+ListadoBots[contador].ip);
AddToLog('console',IntToStr(length(ListadoBots))+' bots registered.');  // bots registered
End;

// muestra la informacion de los slots
Procedure ShowSlots();
var
  contador : integer = 0;
Begin
AddToLog('console','Number Type ConnectedTo ChannelUsed LinesOnWait SumHash LBHash Offset ConStatus'); //Number Type ConnectedTo ChannelUsed LinesOnWait SumHash LBHash Offset ConStatus
for contador := 1 to MaxConecciones do
   begin
   if IsSlotConnected(contador) then
      begin
      AddToLog('console',IntToStr(contador)+' '+conexiones[contador].tipo+
      ' '+conexiones[contador].ip+
      ' '+BoolToStr(CanalCliente[contador].connected,true)+' '+IntToStr(LengthIncoming(contador))+
      ' '+conexiones[contador].SumarioHash+' '+conexiones[contador].LastblockHash+' '+
      IntToStr(conexiones[contador].offset)+' '+IntToStr(conexiones[contador].ConexStatus));
      end;
   end;
end;

// Muestras las opciones del usuario
Procedure ShowUser_Options();
Begin
AddToLog('console','Language    : '+WO_Language);
AddToLog('console','Server Port : '+MN_Port);
AddToLog('console','Wallet      : '+WalletFilename);
AddToLog('console','AutoServer  : '+BoolToStr(WO_AutoServer,true));
AddToLog('console','AutoConnect : '+BoolToStr(WO_AutoConnect,true));
AddToLog('console','To Tray     : '+BoolToStr(WO_ToTray,true));
End;

// devuelve el saldo en satoshis de la cartera
function GetWalletBalance(): Int64;
var
  contador : integer = 0;
  totalEnSumario : Int64 = 0;
Begin
for contador := 0 to length(Listadirecciones)-1 do
   begin
   totalEnSumario := totalEnSumario+Listadirecciones[contador].Balance;
   end;
result := totalEnSumario-MontoOutgoing;
End;

// Conecta a un server especificado
Procedure ConnectTo(LineText:string);
var
  Ip, Port : String;
Begin
Ip := Parameter(Linetext, 1);
Port := Parameter(Linetext, 2);
if StrToIntDef(Port,-1) = -1 then Port := '8080';
ConnectClient(ip,port);
End;

Procedure ToTrayON();
Begin
WO_ToTray := true;
//S_Options := true;
S_AdvOpt := true;
G_Launching := true;
form1.CB_WO_ToTray.Checked:=true;
G_Launching := false;
AddToLog('console','Minimize to tray is now '+'ACTIVE'); //GetNodes option is now  // INACTIVE
End;

Procedure ToTrayOFF();
Begin
WO_ToTray := false;
//S_Options := true;
S_AdvOpt := false;
G_Launching := true;
form1.CB_WO_ToTray.Checked:=false;
G_Launching := false;
AddToLog('console','Minimize to tray is now '+'INACTIVE'); //GetNodes option is now  // INACTIVE
End;

// muestra el sumario completo
Procedure ShowSumary();
var
  contador : integer = 0;
  TotalCoins : int64 = 0;
  EmptyAddresses : int64 = 0;
  NegAdds : integer = 0;
  ThisCustom : string;
  CustomsAdds : string = '';
  DuplicatedCustoms : string = ' ';
  DuplicatedCount : integer = 0;
  BiggerAmmount : int64 = 0;
  BiggerAddress : string = '';
  AsExpected : string = '';
  NotValid   : integer = 0;
  NotValidBalance : int64 = 0;
  NotValidStr     : string = '';
Begin
EnterCriticalSection(CSSumary);
For contador := 0 to length(ListaSumario)-1 do
   begin
   if not IsValidHashAddress(ListaSumario[contador].Hash) then
      begin
      Inc(NotValid);
      Inc(NotValidBalance,ListaSumario[contador].Balance);
      NotValidStr := NotValidStr+contador.ToString+'->'+ListaSumario[contador].Hash+slinebreak;
      end;
   if ListaSumario[contador].custom ='' then ThisCustom := 'NULL'
      else ThisCustom := ListaSumario[contador].custom;
   {
   AddToLog('console',ListaSumario[contador].Hash+' '+Int2Curr(ListaSumario[contador].Balance)+' '+
      ThisCustom+' '+
      IntToStr(ListaSumario[contador].LastOP)+' '+IntToStr(ListaSumario[contador].Score));
   EngineLastUpdate := UTCTime.ToInt64;
   }
   // Custom adds verification
   if ( (thiscustom <> 'NULL') and (AnsiContainsStr(CustomsAdds,' '+thiscustom+' ')) ) then
      begin
      DuplicatedCount +=1;
      DuplicatedCustoms := DuplicatedCustoms+thiscustom+' ';
      end
   else CustomsAdds := CustomsAdds+thiscustom+' ';

   if ListaSumario[contador].Balance < 0 then NegAdds+=1;
   TotalCOins := totalCoins+ ListaSumario[contador].Balance;
   if ListaSumario[contador].Balance = 0 then EmptyAddresses +=1;
   if ListaSumario[contador].Balance > BiggerAmmount then
      begin
      BiggerAmmount := ListaSumario[contador].Balance;
      BiggerAddress := ListaSumario[contador].Hash;
      end;
   end;
{
if NotValid>0 then
   begin
   AddToLog('console',Format('Not Valid: %d [%s]',[NotValid,Int2Curr(NotValidBalance)]));
   AddToLog('console',NotValidStr);
   end;
}
AddToLog('console',IntToStr(Length(ListaSumario))+' addresses.'); //addresses
AddToLog('console',IntToStr(EmptyAddresses)+' empty.'); //addresses
if NegAdds>0 then AddToLog('console','Possible issues: '+IntToStr(NegAdds));
if DuplicatedCount>2 then
   begin
   AddToLog('console','Duplicated alias: '+DuplicatedCount.ToString);
   AddToLog('console',DuplicatedCustoms);
   end;
if TotalCoins = GetSupply(MyLastBlock) then AsExpected := '✓'
else AsExpected := '✗ '+Int2curr(TotalCoins-GetSupply(MyLastBlock));
AddToLog('console',Int2Curr(Totalcoins)+' '+CoinSimbol+' '+AsExpected);
AddToLog('console','Bigger : '+BiggerAddress);
AddToLog('console','Balance: '+Int2curr(BiggerAmmount));
LeaveCriticalSection(CSSumary);
End;

Procedure AutoServerON();
Begin
WO_autoserver := true;
S_AdvOpt := true;
AddToLog('console','AutoServer option is now '+'ACTIVE');   //autoserver //active
End;

Procedure AutoServerOFF();
Begin
WO_autoserver := false;
S_AdvOpt := true;
AddToLog('console','AutoServer option is now '+'INACTIVE');   //autoserver //inactive
End;

Procedure AutoConnectON();
Begin
WO_AutoConnect := true;
S_AdvOpt := true;
AddToLog('console','Autoconnect option is now '+'ACTIVE');     //autoconnect // active
End;

Procedure AutoConnectOFF();
Begin
WO_AutoConnect := false;
S_AdvOpt := true;
AddToLog('console','Autoconnect option is now '+'INACTIVE');    //autoconnect // inactive
End;

// muestra las direcciones de la cartera
Procedure ShowWallet();
var
  contador : integer = 0;
Begin
for contador := 0 to length(ListaDirecciones)-1 do
   begin
   AddToLog('console',Listadirecciones[contador].Hash);
   end;
AddToLog('console',IntToStr(Length(ListaDirecciones))+' addresses.');
AddToLog('console',Int2Curr(GetWalletBalance)+' '+CoinSimbol);
End;

Procedure ExportarWallet(LineText:string);
var
  destino : string = '';
Begin
destino := Parameter(linetext,1);
destino := StringReplace(destino,'*',' ',[rfReplaceAll, rfIgnoreCase]);
if fileexists(destino+'.pkw') then
   begin
   AddToLog('console','Error: Can not overwrite existing wallets');
   exit;
   end;
if copyfile(WalletFilename,destino+'.pkw',[]) then
   begin
   AddToLog('console','Wallet saved as '+destino+'.pkw');
   end
else
   begin
   AddToLog('console','Failed');
   end;
End;

Procedure ImportarWallet(LineText:string);
var
  Cartera : string = '';
  CarteraFile : file of WalletData;
  DatoLeido : Walletdata;
  Contador : integer = 0;
  Nuevos: integer = 0;
Begin
Cartera := Parameter(linetext,1);
Cartera := StringReplace(Cartera,'*',' ',[rfReplaceAll, rfIgnoreCase]);
if not FileExists(cartera) then
   begin
   AddToLog('console','Specified wallet file do not exists.');//Specified wallet file do not exists.
   exit;
   end;
assignfile(CarteraFile,Cartera);
try
reset(CarteraFile);
seek(CarteraFile,0);
Read(CarteraFile,DatoLeido);
if not IsValidHashAddress(DatoLeido.Hash) then
   begin
   closefile(CarteraFile);
   AddToLog('console','The file is not a valid wallet');
   exit;
   end;
for contador := 0 to filesize(CarteraFile)-1 do
   begin
   seek(CarteraFile,contador);
   Read(CarteraFile,DatoLeido);
   if ((DireccionEsMia(DatoLeido.Hash) < 0) and (IsValidHashAddress(DatoLeido.Hash))) then
      begin
      setlength(ListaDirecciones,Length(ListaDirecciones)+1);
      ListaDirecciones[length(ListaDirecciones)-1] := DatoLeido;
      Nuevos := nuevos+1;
      end;
   end;
closefile(CarteraFile);
except on E:Exception  do
AddToLog('console','The file is not a valid wallet'); //'The file is not a valid wallet'
end;
if nuevos > 0 then
   begin
   OutText('Addresses imported: '+IntToStr(nuevos),false,2); //'Addresses imported: '
   UpdateWalletFromSumario;
   end
else AddToLog('console','No new addreses found.');  //'No new addreses found.'
End;

Procedure ShowBlchHead(number:integer);
var
  Dato: ResumenData;
  Found : boolean = false;
  StartBlock : integer = 0;
Begin
EnterCriticalSection(CSHeadAccess);
StartBlock := number - 10;
If StartBlock < 0 then StartBlock := 0;
TRY
assignfile(FileResumen,ResumenFilename);
reset(FileResumen);
Seek(FileResumen,StartBlock);
   REPEAT
   read(fileresumen, dato);
   if Dato.block= number then
      begin
      AddToLog('console',IntToStr(dato.block)+' '+copy(dato.blockhash,1,5)+' '+copy(dato.SumHash,1,5));
      Found := true;
      end;
   UNTIL ((Found) or (eof(FileResumen)) );
closefile(FileResumen);
EXCEPT ON E:Exception do
   AddToLog('console','Error: '+E.Message)
END;{TRY}
LeaveCriticalSection(CSHeadAccess);
End;

// Cambiar la primera direccion de la wallet
Procedure SetDefaultAddress(linetext:string);
var
  Numero: Integer;
  OldData, NewData: walletData;
Begin
Numero := StrToIntDef(Parameter(linetext,1),-1);
if ((Numero < 0) or (numero > length(ListaDirecciones)-1)) then
   OutText('Invalid address number.',false,2)  //'Invalid address number.'
else if numero = 0 then
   OutText('Address 0 is already the default.',false,2) //'Address 0 is already the default.'
else
   begin
   OldData := ListaDirecciones[0];
   NewData := ListaDirecciones[numero];
   ListaDirecciones[numero] := OldData;
   ListaDirecciones[0] := NewData;
   OutText('New default address: '+NewData.Hash,false,2); //'New default address: '
   S_Wallet := true;
   U_DirPanel := true;
   end;
End;

Procedure ParseShowBlockInfo(LineText:string);
var
  blnumber : integer;
Begin
blnumber := StrToIntDef(Parameter(linetext,1),-1);
if (blnumber < 0) or (blnumber>MylastBlock) then
   outtext('Invalid block number')
else ShowBlockInfo(blnumber);
End;

Procedure ShowBlockInfo(numberblock:integer);
var
  Header : BlockHeaderData;
Begin
if fileexists(BlockDirectory+IntToStr(numberblock)+'.blk') then
   begin
   Header := LoadBlockDataHeader(numberblock);
   AddToLog('console','Block info: '+IntToStr(numberblock));
   AddToLog('console','Hash  :       '+HashMD5File(BlockDirectory+IntToStr(numberblock)+'.blk'));
   AddToLog('console','Number:       '+IntToStr(Header.Number));
   AddToLog('console','Time start:   '+IntToStr(Header.TimeStart)+' ('+TimestampToDate(Header.TimeStart)+')');
   AddToLog('console','Time end:     '+IntToStr(Header.TimeEnd)+' ('+TimestampToDate(Header.TimeEnd)+')');
   AddToLog('console','Time total:   '+IntToStr(Header.TimeTotal));
   AddToLog('console','L20 average:  '+IntToStr(Header.TimeLast20));
   AddToLog('console','Transactions: '+IntToStr(Header.TrxTotales));
   AddToLog('console','Difficult:    '+IntToStr(Header.Difficult));
   AddToLog('console','Target:       '+Header.TargetHash);
   AddToLog('console','Solution:     '+Header.Solution);
   AddToLog('console','Last Hash:    '+Header.LastBlockHash);
   AddToLog('console','Next Diff:    '+IntToStr(Header.NxtBlkDiff));
   AddToLog('console','Miner:        '+Header.AccountMiner);
   AddToLog('console','Fees:         '+IntToStr(Header.MinerFee));
   AddToLog('console','Reward:       '+IntToStr(Header.Reward));
   end
else
   AddToLog('console','Block file do not exists: '+numberblock.ToString);
End;

Procedure showmd160(linetext:string);
var
  tohash : string;
Begin
tohash := Parameter(linetext,1);
AddToLog('console',HashMD160String(tohash));
End;

Procedure CustomizeAddress(linetext:string);
var
  address, AddAlias, TrfrHash, OrderHash, CurrTime : String;
  cont : integer;
  procesar : boolean = true;
Begin
address := Parameter(linetext,1);
AddAlias := Parameter(linetext,2);
if DireccionEsMia(address)<0 then
   begin
   AddToLog('console','Invalid address');  //'Invalid address'
   procesar := false;
   end;
if ListaDirecciones[DireccionEsMia(address)].Custom <> '' then
   begin
   AddToLog('console','Address already have a custom alias'); //'Address already have a custom alias'
   procesar := false;
   end;
if ( (length(AddAlias)<5) or (length(AddAlias)>40) ) then
   begin
   OutText('Alias must have between 5 and 40 chars',false,2); //'Alias must have between 5 and 40 chars'
   procesar := false;
   end;
if IsValidHashAddress(addalias) then
   begin
   AddToLog('console','Alias can not be a valid address'); //'Alias can not be a valid address'
   procesar := false;
   end;
if ListaDirecciones[DireccionEsMia(address)].Balance < Customizationfee then
   begin
   AddToLog('console','Insufficient balance'); //'Insufficient balance'
   procesar := false;
   end;
if AddressAlreadyCustomized(Address) then
   begin
   AddToLog('console','Address already have a custom alias'); //'Address already have a custom alias'
   procesar := false;
   end;
if AliasAlreadyExists(addalias) then
   begin
   AddToLog('console','Alias already exists');
   procesar := false;
   end;
for cont := 1 to length(addalias) do
   begin
   if pos(addalias[cont],CustomValid)=0 then
      begin
      AddToLog('console','Invalid character in alias: '+addalias[cont]);
      info('Invalid character in alias: '+addalias[cont]);
      procesar := false;
      end;
   end;
if procesar then
   begin
   CurrTime := UTCTimeStr;
   TrfrHash := GetTransferHash(CurrTime+Address+addalias);
   OrderHash := GetOrderHash('1'+currtime+TrfrHash);
   AddCriptoOp(2,'Customize this '+address+' '+addalias+'$'+ListaDirecciones[DireccionEsMia(address)].PrivateKey,
           ProtocolLine(9)+    // CUSTOM
           OrderHash+' '+  // OrderID
           '1'+' '+        // OrderLines
           'CUSTOM'+' '+   // OrderType
           CurrTime+' '+   // Timestamp
           'null'+' '+     // reference
           '1'+' '+        // Trxline
           ListaDirecciones[DireccionEsMia(address)].PublicKey+' '+    // sender
           ListaDirecciones[DireccionEsMia(address)].Hash+' '+    // address
           AddAlias+' '+   // receiver
           IntToStr(Customizationfee)+' '+  // Amountfee
           '0'+' '+                         // amount trfr
           '[[RESULT]] '+//GetStringSigned('Customize this '+address+' '+addalias,ListaDirecciones[DireccionEsMia(address)].PrivateKey)+' '+
           TrfrHash);      // trfrhash
   StartCriptoThread();
   end;
End;

// Incluye una solicitud de envio de fondos a la cola de transacciones cripto
Procedure Parse_SendFunds(LineText:string);
Begin
AddCriptoOp(3,linetext,'');
StartCriptoThread();
End;

// Ejecuta una orden de transferencia
function SendFunds(LineText:string;showOutput:boolean=true):string;
var
  Destination, amount, reference : string;
  monto, comision : int64;
  montoToShow, comisionToShow : int64;
  contador : integer;
  Restante : int64;
  ArrayTrfrs : Array of orderdata;
  currtime : string;
  TrxLinea : integer = 0;
  OrderHashString : String;
  OrderString : string;
  AliasIndex : integer;
  Procesar : boolean = true;
  ResultOrderID : String = '';
  CoinsAvailable : int64;
Begin
result := '';
BeginPerformance('SendFunds');
Destination := Parameter(Linetext,1);
amount       := Parameter(Linetext,2);
reference    := Parameter(Linetext,3);
if ((Destination='') or (amount='')) then
   begin
   if showOutput then AddToLog('console','Invalid parameters.'); //'Invalid parameters.'
   Procesar := false;
   end;
if not IsValidHashAddress(Destination) then
   begin
   AliasIndex:=AddressSumaryIndex(Destination);
   if AliasIndex<0 then
      begin
      if showOutput then AddToLog('console','Invalid destination.'); //'Invalid destination.'
      Procesar := false;
      end
   else Destination := ListaSumario[aliasIndex].Hash;
   end;
monto := StrToInt64Def(amount,-1);
if reference = '' then reference := 'null';
if monto<=10 then
   begin
   if showOutput then AddToLog('console','Invalid ammount.'); //'Invalid ammount.'
   Procesar := false;
   end;
if procesar then
   begin
   Comision := GetFee(Monto);
   montoToShow := Monto;
   comisionToShow := Comision;
   Restante := monto+comision;
   if WO_Multisend then CoinsAvailable := ListaDirecciones[0].Balance-GetAddressPendingPays(ListaDirecciones[0].Hash)
   else CoinsAvailable := GetWalletBalance;
   if Restante > CoinsAvailable then
      begin
      if showOutput then AddToLog('console','Insufficient funds. Needed: '+Int2curr(Monto+comision));//'Insufficient funds. Needed: '
      Procesar := false;
      end;
   end;
// empezar proceso
if procesar then
   begin
   currtime := UTCTimeStr;
   Setlength(ArrayTrfrs,0);
   Contador := 0;
   OrderHashString := currtime;
   while monto > 0 do
      begin
      BeginPerformance('SendFundsVerify');
      if ListaDirecciones[contador].Balance-GetAddressPendingPays(ListaDirecciones[contador].Hash) > 0 then
         begin
         trxLinea := TrxLinea+1;
         Setlength(ArrayTrfrs,length(arraytrfrs)+1);
         ArrayTrfrs[length(arraytrfrs)-1]:= SendFundsFromAddress(ListaDirecciones[contador].Hash,
                                            Destination,monto, comision, reference, CurrTime,TrxLinea);
         comision := comision-ArrayTrfrs[length(arraytrfrs)-1].AmmountFee;
         monto := monto-ArrayTrfrs[length(arraytrfrs)-1].AmmountTrf;
         OrderHashString := OrderHashString+ArrayTrfrs[length(arraytrfrs)-1].TrfrID;
         end;
      Contador := contador +1;
      EndPerformance('SendFundsVerify');
      end;
   for contador := 0 to length(ArrayTrfrs)-1 do
      begin
      ArrayTrfrs[contador].OrderID:=GetOrderHash(IntToStr(trxLinea)+OrderHashString);
      ArrayTrfrs[contador].OrderLines:=trxLinea;
      end;
   ResultOrderID := GetOrderHash(IntToStr(trxLinea)+OrderHashString);
   if showOutput then AddToLog('console','Send to: '+Destination+slinebreak+
                    'Send '+Int2Curr(montoToShow)+' fee '+Int2Curr(comisionToShow)+slinebreak+
                    'Order ID: '+ResultOrderID);
   result := ResultOrderID;

   OrderString := GetPTCEcn+'ORDER '+IntToStr(trxLinea)+' $';
   for contador := 0 to length(ArrayTrfrs)-1 do
      begin
      OrderString := orderstring+GetStringfromOrder(ArrayTrfrs[contador])+' $';
      end;
   Setlength(orderstring,length(orderstring)-2);
   OutgoingMsjsAdd(OrderString);
   EndPerformance('SendFunds');
   end // End procesar
else
   begin
   if showOutput then AddToLog('console','Syntax: sendto {destination} {ammount} {reference}');
   end;
End;

// Process a GVT sending
Procedure Parse_SendGVT(LineText:string);
Begin
AddCriptoOp(6,linetext,'');
StartCriptoThread();
End;

Function SendGVT(LineText:string;showOutput:boolean=true):string;
var
  GVTNumber   : integer;
  GVTOwner    : string;
  Destination : string = '';
  AliasIndex  : integer;
  Procesar    : boolean = true;
  OrderTime   : string = '';
  TrfrHash    : string = '';
  OrderHash   : string = '';
  ResultStr   : string = '';
  Signature   : string = '';
  GVTNumStr   : string = '';
  StrTosign   : String = '';
Begin
result := '';
BeginPerformance('SendGVT');
GVTNumber:= StrToIntDef(Parameter(Linetext,1),-1);
Destination := Parameter(Linetext,2);
if ( (GVTnumber<0) or (GVTnumber>length(ArrGVTs)-1) ) then
   begin
   if showOutput then AddToLog('console','Invalid GVT number');
   exit;
   end;
GVTNumStr := ArrGVTs[GVTnumber].number;
GVTOwner := ArrGVTs[GVTnumber].owner;
If DireccionEsMia(GVTOwner)<0 then
   begin
   if showOutput then AddToLog('console','You do not own that GVT');
   exit;
   end;
if GetAddressAvailable(GVTOwner)<Customizationfee then
   begin
   if showOutput then AddToLog('console','Inssuficient funds');
   exit;
   end;
if not IsValidHashAddress(Destination) then
   begin
   AliasIndex:=AddressSumaryIndex(Destination);
   if AliasIndex<0 then
      begin
      if showOutput then AddToLog('console','Invalid destination.'); //'Invalid destination.'
      Exit;
      end
   else Destination := ListaSumario[aliasIndex].Hash;
   end;
if GVTOwner=Destination then
   begin
   if showOutput then AddToLog('console','Can not transfer GVT to same address');
   exit;
   end;
// TEMP FILTER
if GVTOwner<>ListaDirecciones[0].Hash then
   begin
   if showOutput then AddToLog('console','Actually only project GVTs can be transfered');
   exit;
   end;
OrderTime := UTCTimeStr;
TrfrHash := GetTransferHash(OrderTime+GVTOwner+Destination);
OrderHash := GetOrderHash('1'+OrderTime+TrfrHash);
StrTosign := 'Transfer GVT '+GVTNumStr+' '+Destination+OrderTime;
Signature := GetStringSigned(StrTosign,ListaDirecciones[DireccionEsMia(GVTOwner)].PrivateKey);
ResultStr := ProtocolLine(21)+ // sndGVT
             OrderHash+' '+  // OrderID
             '1'+' '+        // OrderLines
             'SNDGVT'+' '+   // OrderType
             OrderTime+' '+   // Timestamp
             GVTNumStr+' '+     // reference
             '1'+' '+        // Trxline
             ListaDirecciones[DireccionEsMia(GVTOwner)].PublicKey+' '+    // sender
             ListaDirecciones[DireccionEsMia(GVTOwner)].Hash+' '+        // address
             Destination+' '+   // receiver
             IntToStr(Customizationfee)+' '+  // Amountfee
             '0'+' '+                         // amount trfr
             Signature+' '+
             TrfrHash;      // trfrhash
OutgoingMsjsAdd(ResultStr);
if showoutput then
   begin
   AddToLog('console','GVT '+GVTNumStr+' transfered from '+ListaDirecciones[DireccionEsMia(GVTOwner)].Hash+' to '+Destination);
   AddToLog('console','Order: '+OrderHash);
   //AddToLog('console',StrToSign);
   end;
EndPerformance('SendGVT');
End;

// Muestra la escala de halvings
Procedure ShowHalvings();
var
  contador : integer;
  texto : string;
  block1, block2 : integer;
  reward : int64;
  MarketCap : int64 = 0;
Begin
for contador := 0 to HalvingSteps do
   begin
   block1 := BlockHalvingInterval*(contador);
   if block1 = 0 then block1 := 1;
   block2 := (BlockHalvingInterval*(contador+1))-1;
   reward := InitialReward div StrToInt64(BMExponente('2',IntToStr(contador)));
   MarketCap := marketcap+(reward*BlockHalvingInterval);
   Texto :='From block '+IntToStr(block1)+' until '+IntToStr(block2)+': '+Int2curr(reward); //'From block '+' until '
   AddToLog('console',Texto);
   end;
AddToLog('console','And then '+int2curr(0)); //'And then '
MarketCap := MarketCap+PremineAmount-InitialReward; // descuenta una recompensa inicial x bloque 0
AddToLog('console','Final supply: '+int2curr(MarketCap)); //'Final supply: '
End;

// Muestra y procesa el monto a agrupar en la direccion principal
Procedure GroupCoins(linetext:string);
var
  cont : integer;
  proceder : string = '';
  Total : int64 = 0;
Begin
Proceder := Parameter(linetext,1);
if length(listaDirecciones)>0 then
  for cont := 1 to length(listaDirecciones)-1 do
    Total += GetAddressBalance(ListaDirecciones[cont].Hash);
AddToLog('console','Coins to group: '+Int2curr(Total)+' '+Coinsimbol); //'Coins to group: '
if uppercase(Proceder) = 'DO' then
   begin
   if Total = 0 then
     AddToLog('console','You do not have coins to group.') //'You do not have coins to group.'
   else
     ProcessLinesAdd('SENDTO '+Listadirecciones[0].Hash+' '+IntToStr(GetMaximunToSend(Total)));
   end;
End;

// cambia el puerto de escucha
Procedure SetServerPort(LineText:string);
var
  NewPort:string = '';
Begin
AddToLog('console','Deprecated');
Exit;
NewPort := parameter(linetext,1);
if ((StrToIntDef(NewPort,0) < 1) or (StrToIntDef(NewPort,0)>65535)) then
   begin
   AddToLog('console','Invalid Port');
   end
else
   begin
   MN_Port := NewPort;
   OutText('New listening port: '+NewPort,false,2);
   end;
End;

// regresa el sha256 de una cadena
Procedure Sha256(LineText:string);
var
  TextToSha : string = '';
Begin
TextToSha :=  parameter(linetext,1);
AddToLog('console',HashSha256String(TextToSha));
End;

// prueba la lectura de parametros de la linea de comandos
Procedure TestParser(LineText:String);
var
  contador : integer = 1;
  continuar : boolean;
  parametro : string;
Begin
AddToLog('console',Parameter(linetext,0));
continuar := true;
repeat
   begin
   parametro := Parameter(linetext,contador);
   if parametro = '' then continuar := false
   else
     begin
     AddToLog('console',inttostr(contador)+' '+parametro);
     contador := contador+1;
     end;
   end;
until not continuar
End;

// Borra la IP enviada de la lista de bots si existe
Procedure DeleteBot(LineText:String);
var
  IPBot : String;
  contador : integer;
  IPDeleted : boolean = false;
Begin
IPBot := Parameter(linetext,1);
if IPBot = '' then
   begin
   AddToLog('console','Invalid IP');
   end
else if uppercase(IPBot) = 'ALL' then
   begin
   SetLength(ListadoBots,0);
   LastBotClear := UTCTimeStr;
   S_BotData := true;
   AddToLog('console','All bots deleted');
   end
else
   begin
   for contador := 0 to length(ListadoBots)-1 do
      begin
      if ListadoBots[contador].ip = IPBot then
         begin
         Delete(ListadoBots,Contador,1);
         S_BotData := true;
         AddToLog('console',IPBot+' deleted from bot list');
         IPDeleted := true;
         end;
      end;
   if not IPDeleted then AddToLog('console','IP do not exists in Bot list');
   end;
End;

Procedure showCriptoThreadinfo();
Begin
AddToLog('console',Booltostr(CriptoThreadRunning,true)+' '+intToStr(length(ArrayCriptoOp)));
End;

Procedure Parse_RestartNoso();
Begin
RestartNosoAfterQuit := true;
CerrarPrograma();
End;

// Muestra la informacion de la red
// Este procedimiento debe amppliarse para que muestre la informacion solicitada
Procedure ShowNetworkDataInfo();
Begin
AddToLog('console','Network last block');
AddToLog('console','Value: '+NetLastBlock.Value);
AddToLog('console','Count: '+IntToStr(NetLastBlock.Count));
AddToLog('console','Percent: '+IntToStr(NetLastBlock.porcentaje));
AddToLog('console','Slot: '+IntToStr(NetLastBlock.slot));
End;

Procedure GetOwnerHash(LineText:string);
var
  direccion, currtime : string;
Begin
direccion := parameter(linetext,1);
if ( (DireccionEsMia(direccion)<0) or (direccion='') ) then
  begin
  AddToLog('console','Invalid address');
  end
else
   begin
   currtime := UTCTimeStr;
   AddToLog('console',direccion+' owner cert'+slinebreak+
      EncodeCertificate(ListaDirecciones[DireccionEsMia(direccion)].PublicKey+':'+currtime+':'+GetStringSigned('I OWN THIS ADDRESS '+direccion+currtime,ListaDirecciones[DireccionEsMia(direccion)].PrivateKey)));
   end;
End;

Procedure CheckOwnerHash(LineText:string);
var
  data, pubkey, direc,firmtime,firma : string;
Begin
BeginPerformance('CheckOwnerHash');
data := parameter(LineText,1);
data := DecodeCertificate(Data);
data := StringReplace(data,':',' ',[rfReplaceAll, rfIgnoreCase]);
pubkey := Parameter(data,0);
firmtime := Parameter(data,1);
firma := Parameter(data,2);
direc := GetAddressFromPublicKey(pubkey);
if ListaSumario[AddressSumaryIndex(direc)].custom <> '' then direc := ListaSumario[AddressSumaryIndex(direc)].custom;
if VerifySignedString('I OWN THIS ADDRESS '+direc+firmtime,firma,pubkey) then
   AddToLog('console',direc+' verified '+TimeSinceStamp(StrToInt64(firmtime))+' ago.')
else AddToLog('console','Invalid verification');
EndPerformance('CheckOwnerHash');
End;

Function CreateAppCode(Texto:string):string;
Begin
result := UPPERCASE(XorEncode(HashSha256String('nosoapp'),Texto));
End;

Function DecodeAppCode(Texto:string):string;
Begin
result := XorDecode(HashSha256String('nosoapp'), texto);
End;

// devuelve una cadena con los updates disponibles
function AvailableUpdates():string;
var
  updatefiles : TStringList;
  contador : integer = 0;
  version : string;
Begin
Result := '';
updatefiles := TStringList.Create;
FindAllFiles(updatefiles, UpdatesDirectory, '*.zip', false);
while contador < updatefiles.Count do
   begin
   version :=copy(updatefiles[contador],18,8);
   Result := result+version+' ';
   Inc(contador);
   end;
updatefiles.Free;
Result := Trim(Result);
End;

// Manual update the app
Procedure RunUpdate(linea:string);
var
  Tversion : string;
  TArch    : string;
  overRule : boolean = false;
Begin
Tversion := parameter(linea,1);
if Tversion = '' then Tversion := Parameter(GetLastRelease,0);
TArch    := Uppercase(parameter(linea,2));
if TArch = '' then TArch := GetOS;
AddToLog('console',Format('Trying upgrade to version %s (%s)',[TVersion,TArch]));
if ansicontainsstr(linea,' /or') then overRule := true;
Application.ProcessMessages;
if ( (Tversion = ProgramVersion+Subversion) and (not overRule) ) then
   begin
   AddToLog('console','Version '+TVersion+' already installed');
   exit;
   end;
if GetLastVerZipFile(Tversion,TArch) then
   begin
   AddToLog('console','Version '+Tversion+' downloaded');
   if UnZipUpdateFromRepo(Tversion,TArch) then
     begin
     AddToLog('console','Unzipped !');
     {$IFDEF WINDOWS}Trycopyfile('NOSODATA/UPDATES/Noso.exe','nosonew');{$ENDIF}
     {$IFDEF UNIX}Trycopyfile('NOSODATA/UPDATES/Noso','Nosonew');{$ENDIF}
     CreateLauncherFile(true);
     RunExternalProgram(RestartFilename);
     cerrarprograma();
     end
   end
else
   begin
   AddToLog('console','Update Failed');
   end
End;

Procedure SendAdminMessage(linetext:string);
var
  mensaje,currtime, firma, hashmsg : string;
Begin
if (DireccionEsMia(AdminHash)<0) then AddToLog('console','Only the Noso developers can do this.') //Only the Noso developers can do this
else
   begin
   mensaje := copy(linetext,11,length(linetext));
   //Mensaje := parameter(linetext,1);
   currtime := UTCTimeStr;
   firma := GetStringSigned(currtime+mensaje,ListaDirecciones[DireccionEsMia(AdminHash)].PrivateKey);
   hashmsg := HashMD5String(currtime+mensaje+firma);
   mensaje := StringReplace(mensaje,' ','_',[rfReplaceAll, rfIgnoreCase]);
   OutgoingMsjsAdd(GetPTCEcn+'ADMINMSG '+currtime+' '+mensaje+' '+firma+' '+hashmsg);
   mensaje := StringReplace(mensaje,'_',' ',[rfReplaceAll, rfIgnoreCase]);
   AddToLog('console','Directive sent: '+mensaje);
   end;
End;

Procedure SetReadTimeOutTIme(LineText:string);
var
  newvalue : integer;
Begin
newvalue := StrToIntDef(parameter(LineText,1),-1);
if newvalue < 0 then AddToLog('console','ReadTimeOutTime= '+IntToStr(ReadTimeOutTIme))
else
  begin
  ReadTimeOutTIme := newvalue;
  AddToLog('console','ReadTimeOutTime set to '+IntToStr(newvalue));
  end;
End;

Procedure SetConnectTimeOutTIme(LineText:string);
var
  newvalue : integer;
Begin
newvalue := StrToIntDef(parameter(LineText,1),-1);
if newvalue < 0 then AddToLog('console','ConnectTimeOutTime= '+IntToStr(ConnectTimeOutTIme))
else
  begin
  ConnectTimeOutTIme := newvalue;
  AddToLog('console','ConnectTimeOutTime set to '+IntToStr(newvalue));
  end;
End;

Procedure RequestHeaders();
Begin
PTC_SendLine(NetResumenHash.Slot,ProtocolLine(7));
End;

Procedure RequestSumary();
Begin
PTC_SendLine(NetResumenHash.Slot,ProtocolLine(6));
End;

Procedure ShowOrderDetails(LineText:string);
var
  orderid : string;
  orderdetails : string;
  ThisOrderdata : TOrderGroup;
Begin
orderid := parameter(LineText,1);
ThisOrderdata := GetOrderDetails(orderid);
if thisorderdata.AmmountTrf<=0 then
  AddToLog('console','Order not found')
else
  begin
  AddToLog('console','Time     : '+TimestampToDate(ThisOrderdata.TimeStamp));
  if ThisOrderdata.Block = -1 then AddToLog('console','Block: Pending')
  else AddToLog('console','Block    : '+IntToStr(ThisOrderdata.Block));
  AddToLog('console','Type     : '+ThisOrderdata.OrderType);
  AddToLog('console','Trfrs    : '+IntToStr(ThisOrderdata.OrderLines));
  AddToLog('console','sender   : '+ThisOrderdata.sender);
  AddToLog('console','Receiver : '+ThisOrderdata.receiver);
  AddToLog('console','Ammount  : '+Int2curr(ThisOrderdata.AmmountTrf));
  AddToLog('console','Fee      : '+Int2curr(ThisOrderdata.AmmountFee));
  AddToLog('console','Reference: '+ThisOrderdata.reference);
  end;
End;

// Exports a single address credentials of the wallet
Procedure ExportAddress(LineText:string);
var
  addresshash : string;
  newfile : file of WalletData;
  Data : WalletData;
Begin
addresshash := parameter(LineText,1);
if DireccionEsMia(addresshash) >= 0 then
  begin
  Assignfile(newfile,'tempwallet.pkw');
  rewrite(newfile);
  Data := ListaDirecciones[DireccionEsMia(addresshash)];
  write(newfile,data);
  closefile(newfile);
  AddToLog('console','Address exported to tempwallet.pkw');
  end
else AddToLog('console','Address not found in wallet');
End;

// Shows all the info of a specified address
Procedure ShowAddressInfo(LineText:string);
var
  addtoshow : string;
  sumposition : integer;
  onsumary, pending : int64;
Begin
addtoshow := parameter(LineText,1);
sumposition := AddressSumaryIndex(addtoshow);
if sumposition<0 then
   AddToLog('console','Address do not exists in sumary.')
else
   begin
   onsumary := GetAddressBalance(addtoshow);
   pending := GetAddressPendingPays(addtoshow);
   AddToLog('console','Address  : '+ListaSumario[sumposition].Hash+' ('+IntToStr(sumposition)+')'+slinebreak+
                    'Alias    : '+ListaSumario[sumposition].Custom+slinebreak+
                    'Sumary   : '+Int2curr(onsumary)+slinebreak+
                    'Incoming : '+Int2Curr(GetAddressIncomingpays(ListaSumario[sumposition].Hash))+slinebreak+
                    'Outgoing : '+Int2curr(pending)+slinebreak+
                    'Available: '+int2curr(onsumary-pending));
   end;
End;

// Shows transaction history of the specified address
Procedure ShowAddressHistory(LineText:string);
var
  BlockCount : integer;
  addtoshow : string;
  counter,contador2 : integer;
  Header : BlockHeaderData;
  ArrTrxs : BlockOrdersArray;
  incomingtrx : integer = 0; minedblocks : integer = 0;inccoins : int64 = 0;
  outgoingtrx : integer = 0; outcoins : int64 = 0;
  inbalance : int64;
  ArrayPos    : BlockArraysPos;
  PosReward   : int64;
  PosCount    : integer;
  CounterPos  : integer;
  PosPAyments : integer = 0;
  PoSEarnings : int64 = 0;
  TransSL : TStringlist;
  MinedBlocksStr : string = '';
Begin
BlockCount := StrToIntDef(Parameter(Linetext,2),0);
if BlockCount = 0 then BlockCount := SecurityBlocks-1;
if BlockCount >= MyLastBlock then BlockCount := MyLastBlock-1;
TransSL := TStringlist.Create;
addtoshow := parameter(LineText,1);
for counter := MyLastBlock downto MyLastBlock- BlockCount do
   begin
   if counter mod 10 = 0 then
      begin
      info('History :'+IntToStr(Counter));
      application.ProcessMessages;
      end;
   Header := LoadBlockDataHeader(counter);
   if Header.AccountMiner= addtoshow then // address is miner
     begin
     minedblocks +=1;
     MinedBlocksStr := MinedBlocksStr+Counter.ToString+' ';
     inccoins := inccoins + header.Reward+header.MinerFee;
     end;
   ArrTrxs := GetBlockTrxs(counter);
   if length(ArrTrxs)>0 then
      begin
      for contador2 := 0 to length(ArrTrxs)-1 do
         begin
         if ArrTrxs[contador2].Receiver = addtoshow then // incoming order
            begin
            incomingtrx += 1;
            inccoins := inccoins+ArrTrxs[contador2].AmmountTrf;
            transSL.Add(IntToStr(Counter)+'] '+ArrTrxs[contador2].sender+'<-- '+Int2curr(ArrTrxs[contador2].AmmountTrf));
            end;
         if ArrTrxs[contador2].sender = addtoshow then // outgoing order
            begin
            outgoingtrx +=1;
            outcoins := outcoins + ArrTrxs[contador2].AmmountTrf + ArrTrxs[contador2].AmmountFee;
            transSL.Add(IntToStr(Counter)+'] '+ArrTrxs[contador2].Receiver+'--> '+Int2curr(ArrTrxs[contador2].AmmountTrf));
            end;
         end;
      end;
   SetLength(ArrTrxs,0);
   if counter >= PoSBlockStart then
      begin
      ArrayPos := GetBlockPoSes(counter);
      PosReward := StrToIntDef(Arraypos[length(Arraypos)-1].address,0);
      SetLength(ArrayPos,length(ArrayPos)-1);
      PosCount := length(ArrayPos);
      for counterpos := 0 to PosCount-1 do
         begin
         if ArrayPos[counterPos].address = addtoshow then
           begin
           PosPAyments +=1;
           PosEarnings := PosEarnings+PosReward;
           end;
         end;
      SetLength(ArrayPos,0);
      end;
   end;
inbalance := GetAddressBalance(addtoshow);
AddToLog('console','Last block : '+inttostr(MyLastBlock));
AddToLog('console','Address    : '+addtoshow);
AddToLog('console','INCOMINGS');
AddToLog('console','  Mined        : '+IntToStr(minedblocks));
AddToLog('console','  Mined blocks : '+MinedBlocksStr);
AddToLog('console','  Transactions : '+IntToStr(incomingtrx));
AddToLog('console','  Coins        : '+Int2Curr(inccoins));
AddToLog('console','  PoS Payments : '+IntToStr(PosPAyments));
AddToLog('console','  PoS Earnings : '+Int2Curr(PosEarnings));
AddToLog('console','OUTGOINGS');
AddToLog('console','  Transactions : '+IntToStr(outgoingtrx));
AddToLog('console','  Coins        : '+Int2Curr(outcoins));
AddToLog('console','TOTAL  : '+Int2Curr(inccoins-outcoins+PoSearnings));
AddToLog('console','SUMARY : '+Int2Curr(inbalance));
AddToLog('console','');
AddToLog('console','Transactions');
While TransSL.Count >0 do
   begin
   AddToLog('console',TransSL[0]);
   TransSL.Delete(0);
   end;
TransSL.Free;
End;

// Shows the total fees paid in the whole blockchain
Procedure ShowTotalFees();
var
  counter : integer;
  Header : BlockHeaderData;
  totalcoins : int64 = 0;
Begin
for counter := 1 to MyLastBlock do
   begin
   Header := LoadBlockDataHeader(counter);
   totalcoins := totalcoins+ header.MinerFee;
   if counter mod 1000 = 0 then
     Begin
     info('TOTAL FEES '+counter.ToString);
     application.ProcessMessages;
     end;
   end;
AddToLog('console','Blockchain total fees: '+Int2curr(totalcoins));
AddToLog('console','Block average        : '+Int2curr(totalcoins div MyLastBlock));
End;

// *******************
// *** DEBUG 0.2.1 ***
// *******************

Procedure ShowBlockPos(LineText:string);
var
  number : integer;
  ArrayPos : BlockArraysPos;
  PosReward : int64;
  PosCount, counterPos : integer;
Begin
number := StrToIntDef(parameter(linetext,1),0);
if ((number < PoSBlockStart) or (number > MyLastBlock))then
   begin
   AddToLog('console','Invalid block number: '+number.ToString);
   end
else
   begin
   ArrayPos := GetBlockPoSes(number);
   PosReward := StrToIntDef(Arraypos[length(Arraypos)-1].address,0);
   SetLength(ArrayPos,length(ArrayPos)-1);
   PosCount := length(ArrayPos);
   for counterpos := 0 to PosCount-1 do
      AddToLog('console',ArrayPos[counterPos].address+': '+int2curr(PosReward));
   AddToLog('console','Block:   : '+inttostr(number));
   AddToLog('console','Addresses: '+IntToStr(PosCount));
   AddToLog('console','Reward   : '+int2curr(PosReward));
   AddToLog('console','Total    : '+int2curr(PosCount*PosReward));
   SetLength(ArrayPos,0);
   end;
End;

Procedure ShowBlockMNs(LineText:string);
var
  number : integer;
  ArrayMNs : BlockArraysPos;
  MNsReward : int64;
  MNsCount, counterMNs : integer;
Begin
number := StrToIntDef(parameter(linetext,1),0);
if ((number < MNBlockStart) or (number > MyLastBlock))then
   begin
   AddToLog('console','Invalid block number: '+number.ToString);
   end
else
   begin
   ArrayMNs := GetBlockMNs(number);
   MNsReward := StrToIntDef(ArrayMNs[length(ArrayMNs)-1].address,0);
   SetLength(ArrayMNs,length(ArrayMNs)-1);
   MNSCount := length(ArrayMNs);
   for counterMNs := 0 to MNsCount-1 do
      AddToLog('console',ArrayMNs[counterMNs].address);
   AddToLog('console','MNs Block : '+inttostr(number));
   AddToLog('console','Addresses : '+IntToStr(MNsCount));
   AddToLog('console','Reward    : '+int2curr(MNsReward));
   AddToLog('console','Total     : '+int2curr(MNsCount*MNsReward));
   SetLength(ArrayMNs,0);
   end;
End;

Procedure showPosrequired(linetext:string);
var
  PosRequired : int64;
  contador : integer;
  Cantidad : integer = 0;
  TotalStacked : int64 =0;
Begin
PosRequired := (GetSupply(MyLastBlock+1)*PosStackCoins) div 10000;
for contador := 0 to length(ListaSumario)-1 do
      begin
      if listasumario[contador].Balance >= PosRequired then
         begin
         Cantidad +=1;
         AddToLog('console',listasumario[contador].Hash+': '+Int2curr(listasumario[contador].Balance));
         TotalStacked := TotalStacked +listasumario[contador].Balance;
         end;
      end;
AddToLog('console','Pos At block          : '+inttostr(Mylastblock));
AddToLog('console','PoS required Stake    : '+Int2Curr(PosRequired));
AddToLog('console','Current PoS addresses : '+inttostr(Cantidad));
AddToLog('console','Total Staked          : '+Int2Curr(TotalStacked));
End;

Procedure showgmts(LineText:string);
var
  monto: int64;
  gmts, fee : int64;
Begin
monto := StrToInt64Def(Parameter(LineText,1),0);
gmts := GetMaximunToSend(monto);
fee := monto-gmts;
if fee<MinimunFee then fee := MinimunFee;
if monto <= MinimunFee then
   begin
   gmts := 0;
   fee  := 0;
   end;
AddToLog('console','Ammount         : '+Int2Curr(monto));
AddToLog('console','Maximun to send : '+Int2Curr(gmts));
AddToLog('console','Fee paid        : '+Int2Curr(fee));
if gmts+fee = monto then AddToLog('console','✓ Match')
else AddToLog('console','✗ Error')
End;

Procedure ShowDiftory();
var
  counter : integer;
  Header : BlockHeaderData;
  highDiff : integer = 0;
  highblock : integer = 0;
Begin
for counter := 1 to MyLastBlock do
   begin
   Header := LoadBlockDataHeader(counter);
   if counter mod 100 = 0 then
      begin
      info ('Difftory '+counter.ToString);
      application.ProcessMessages;
      end;
   //AddToLog('console',inttostr(counter)+','+IntToStr(Header.Difficult));
   if Header.Difficult > HighDiff then
      begin
      HighDiff := Header.Difficult;
      highblock := counter;
      end;
   end;
AddToLog('console','Highest ever: '+IntToStr(HighDiff)+' on block '+highblock.ToString);
End;

// List all GVTs owners
Procedure ListGVTs();
var
  counter : integer;
Begin
AddToLog('console','Existing: '+Length(arrgvts).ToString);
for counter := 0 to length(arrgvts)-1 do
   AddToLog('console',Format('%.2d %s',[counter,arrgvts[counter].owner]));
UpdateMyGVTsList
End;

Function MainNetHashrate(blocks:integer = 100):int64;
var
  counter : integer;
  TotalRate : double = 0;
  Header : BlockHeaderData;
  ThisBlockDiff : string;
  ThisBlockValue : integer;
  TotalBlocksCalculated : integer = 100;
  ResultStr : string = '';
Begin
TotalBlocksCalculated := blocks;
For counter:= MyLastblock downto Mylastblock-(TotalBlocksCalculated-1) do
   begin
   Header := LoadBlockDataHeader(counter);
   ThisBlockDiff := Parameter(Header.Solution,1);
   ThisBlockValue := GetDiffHashrate(ThisBlockDiff);
   TotalRate := TotalRate+(ThisBlockValue/100);
   ResultStr := ResultStr+Format('[%s]-',[FormatFloat('0.00',ThisBlockValue/100)]);
   end;
//AddToLog('console',ResultStr);
TotalRate := TotalRate/TotalBlocksCalculated;
//AddToLog('console',format('Average: %s',[FormatFloat('0.00',TotalRate)]));
TotalRate := Power(16,TotalRate);
Result := Round(TotalRate/575);
End;

function ShowPrivKey(linea:String;ToConsole:boolean = false):String;
var
  addtoshow : string;
  sumposition : integer;
Begin
result := '';
addtoshow := parameter(linea,1);
sumposition := DireccionEsMia(addtoshow);
if sumposition<0 then
   begin
   if ToConsole then AddToLog('console',rs1504);
   end
else
   begin
   result := ListaDirecciones[sumposition].PrivateKey;
   end;
if ToConsole then AddToLog('console',Result);
End;

Procedure TestNetwork(LineText:string);
var
  numero : integer;
  monto : integer;
  contador : integer;
Begin
numero := StrToIntDef(Parameter(linetext,1),0);
if ((numero <1) or (numero >2000)) then
  Outtext('Range must be 1-1000')
else
  begin
  Randomize;
  for contador := 1 to numero do
     begin
     Monto := 100000+contador;
     ProcesslinesAdd('SENDTO devteam_donations '+IntToStr(Monto)+' '+contador.ToString);
     end;
  end;
End;

Procedure ShowPendingTrxs();
Begin

End;

Procedure WebWallet();
var
  contador : integer;
  ToClipboard : String = '';
Begin
for contador := 0 to length(ListaDirecciones)-1 do
   begin
   ToClipboard := ToClipboard+(Listadirecciones[contador].Hash)+',';
   end;
Setlength(ToClipboard,length(ToClipboard)-1);
Clipboard.AsText := ToClipboard;
AddToLog('console','Web wallet data copied to clipboard');
End;

Procedure ExportKeys(linea:string);
var
  sumposition : integer;
  addtoshow : string = '';
  Resultado : string = '';
Begin
addtoshow := parameter(linea,1);
sumposition := DireccionEsMia(addtoshow);
if sumposition<0 then
   begin
   AddToLog('console',rs1504);
   end
else
   begin
   Resultado := ListaDirecciones[sumposition].PublicKey+' '+ListaDirecciones[sumposition].PrivateKey;
   Clipboard.AsText := Resultado;
   AddToLog('console',rs1505);
   end;
end;

Procedure PostOffer(LineText:String);
var
  FromAddress : String = '';
  Amount : int64 = 0;
  Market : String = '';
  Price : int64;
  TotalPost : int64;
  PAyAddress : String = '';
  Duration : int64;
  FeeTotal : int64;
  FeeTramos : int64;

  ErrorCode : integer = 0;
  errorMessage : string = '';
Begin
FromAddress := Parameter(LineText,1);
if UPPERCASE(FromAddress) = 'DEF' then FromAddress := ListaDirecciones[0].Hash;
if UPPERCASE(Parameter(linetext,2)) = 'MAX' then Amount := GetMaximunToSend(GetAddressAvailable(FromAddress))
else Amount := StrToInt64Def(Parameter(linetext,2),0);
Market := UpperCase(Parameter(LineText,3));
Price := StrToInt64Def(Parameter(linetext,4),0);
TotalPost := amount*price div 100000000;
PayAddress := Parameter(LineText,5);
Duration := StrToInt64Def(Parameter(LineText,6),100);
if duration > 1000 then duration := 1000;
Feetramos := duration div 100; if duration mod 100 > 0 then feetramos +=1;
FeeTotal := GetFee(amount)*feetramos;


if FromAddress = '' then ErrorCode := -1
else if direccionEsMia(FromAddress) < 0 then ErrorCode := 1
else if ((amount = 0) or (amount+GetFee(amount)>GetAddressAvailable(FromAddress))) then ErrorCode := 2
else if not AnsiContainsStr(AvailableMarkets,market) then ErrorCode := 3
else if price <= 0 then ErrorCode := 4;

if errorcode =-1 then ErrorMessage := 'post {address} {ammount} {market} {price} {payaddress}'+
   ' {duration}';
if errorcode = 1 then ErrorMessage := 'Invalid Address';
if errorcode = 2 then ErrorMessage := 'Invalid Ammount';
if errorcode = 3 then ErrorMessage := 'Invalid market';
if errorcode = 4 then ErrorMessage := 'Invalid price';

If ErrorMessage <> '' then AddToLog('console',ErrorMessage)
else
   begin
   AddToLog('console','Post Exchange Offer');
   AddToLog('console','From Address: '+FromAddress);
   AddToLog('console','Ammount     : '+Int2Curr(amount)+' '+CoinSimbol);
   AddToLog('console','Market      : '+Market);
   AddToLog('console','Price       : '+Int2Curr(price)+' '+Market);
   AddToLog('console','Total       : '+Int2Curr(TotalPost)+' '+Market);
   AddToLog('console','Pay to      : '+PayAddress);
   AddToLog('console','Duration    : '+IntToStr(Duration)+' blocks');
   AddToLog('console','Fee         : ('+IntToStr(Feetramos)+') '+Int2Curr(FeeTotal)+' '+CoinSimbol);

   end;

End;

Procedure DebugTest(linetext:string);
var
  Texto : string;
Begin
{
if Myconstatus<3 then
  begin
  AddToLog('console','Must be synced');
  exit;
  end;
Texto := GetMNsFileData;
if AnsiContainsStr(Texto,MN_Funds) then AddToLog('console',MN_Funds+' got MN Reward on block '+MyLastBlock.ToString)
else AddToLog('console',MN_Funds+' not paid')
}
AddToLog('console',GetDiffHashrate('0000001').ToString);
End;

Procedure DebugTest2(linetext:string);
var
  total   : integer;
  verifis : integer;
  counter : integer;
Begin
Total := Length(ArrayMNsData);
verifis := (total div 10)+3;
AddToLog('console','Masternodes  : '+IntToStr(total));
AddToLog('console','Verificators : '+IntToStr(verifis));
for counter := 0 to verifis-1 do
   AddToLog('console',format('%s %s %d',[ArrayMNsData[counter].ipandport,copy(arrayMNsData[counter].address,1,5),ArrayMNsData[counter].age]));
End;

Procedure ShowSystemInfo(Linetext:string);
var
  DownSpeed : int64;
  Param     : string;
Begin
if MyConStatus > 0 then exit;
Param := Uppercase(Parameter(Linetext,1));
if param = 'POWER' then
  AddToLog('console',Format('Processing       : %d Trx/s',[Sys_HashSpeed]))
else if param = 'MEM' then
  AddToLog('console',Format('Available memory : %d MB',[AllocateMem]))
else if param = 'DOWNSPEED' then
  AddToLog('console',Format('Download speed   : %d Kb/s',[TestDownloadSpeed]))
else AddToLog('console','Invalid parameter: '+Param+slinebreak+'Use: power, mem or downspeed');
End;

END. // END UNIT

