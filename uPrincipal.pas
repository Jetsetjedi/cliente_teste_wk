unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.ScrollBox, FMX.Memo,System.JSON,REST.Json,
  REST.Types, System.Classes, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, FMX.Layouts, FMX.Grid,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageBin,
  FireDAC.Phys.TDBXDef, FireDAC.Phys, FireDAC.Phys.TDBXBase, FireDAC.Phys.TDBX,
  IdThreadComponent, IdBaseComponent,Vcl.Dialogs;

type
  TFormList = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    MRetget: TMemo;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    Panel1: TPanel;
    grid_lista_pessoa: TStringGrid;
    Panel2: TPanel;
    Label2: TLabel;
    Edt_pnome: TEdit;
    Label3: TLabel;
    Edt_snome: TEdit;
    Label4: TLabel;
    Edt_doc: TEdit;
    Label5: TLabel;
    Edt_natural: TEdit;
    Label6: TLabel;
    Lbl_dtacad: TLabel;
    Btn_post: TButton;
    Button1: TButton;
    Btn_put: TButton;
    Btn_get: TButton;
    Btn_del: TButton;
    Btn_post_list: TButton;
    Btn_fechar: TButton;
    col_id_pessoa: TStringColumn;
    col_pnome: TStringColumn;
    col_snome: TStringColumn;
    Label9: TLabel;
    FDM_wk_lista_local: TFDMemTable;
    FDM_wk_lista_localidpessoa: TIntegerField;
    FDM_wk_lista_localpnome: TStringField;
    FDM_wk_lista_localsnome: TStringField;
    FDM_wk_lista_localdoc: TStringField;
    FDM_wk_lista_localnatureza: TIntegerField;
    FDM_wk_lista_localdta_registro: TStringField;
    FDM_enderecos: TFDMemTable;
    FDM_temp_end: TFDMemTable;
    FDM_temp_endid_endereco: TIntegerField;
    FDM_temp_enduf: TStringField;
    FDM_temp_endcidade: TStringField;
    FDM_temp_endbairro: TStringField;
    FDM_temp_endlougradouro: TStringField;
    FDM_temp_endnumero: TIntegerField;
    FDM_temp_endcomplemento: TStringField;
    FDM_enderecosidendereco: TIntegerField;
    FDM_enderecosidpessoa: TIntegerField;
    FDM_enderecosdscep: TStringField;
    Label1: TLabel;
    Edt_id: TEdit;
    Label7: TLabel;
    edt_cep: TEdit;
    Layout_data_end: TScaledLayout;
    Lbl_idend: TLabel;
    Lbl_uf: TLabel;
    Lbl_cidade: TLabel;
    lbl_bairro: TLabel;
    lbl_lougradouro: TLabel;
    Lbl_numero: TLabel;
    Lbl_complento: TLabel;
    Lbl_cep: TLabel;
    Op_list_cad_csv: TOpenDialog;
    FDM_cadastros: TFDMemTable;
    FDM_cadastroscep: TStringField;
    FDM_cadastrosprinome: TStringField;
    FDM_cadastrossegunome: TStringField;
    FDM_cadastrosdocnum: TStringField;
    FDM_cadastrosnatureza: TIntegerField;
    thr_send_data: TIdThreadComponent;
    FDM_wk_lista_localcep: TStringField;
    procedure Btn_getClick(Sender: TObject);
    procedure Btn_postClick(Sender: TObject);
    procedure Btn_putClick(Sender: TObject);
    procedure Btn_delClick(Sender: TObject);
    procedure Btn_fecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Btn_post_listClick(Sender: TObject);
    procedure thr_send_dataRun(Sender: TIdThreadComponent);
    procedure thr_send_dataTerminate(Sender: TIdThreadComponent);

  private
      procedure CarregarRESTClient;
      function listapessoas(qtd:integer):Boolean;
      Function ValidarCEP(const CEP: string): string;
  end;

var
  FormList: TFormList;
  JSON : TJSONArray;
  ArquivoCSV: TextFile;
  nome_file:string;
implementation

{$R *.fmx}

  uses
     Pessoa,Endereco_Integracao,Cadastro,uWKUtils;

{ TForm1 }



procedure TFormList.Btn_fecharClick(Sender: TObject);
begin
 Close;
end;

// Get lista all
procedure TFormList.Btn_getClick(Sender: TObject);
var
  vPessoa: TPessoa;
  vJSONObject: TJSONObject; // listar
  vJSONPair: TJSONPair;
  vJSONarray: TJSONArray;
  lst_nj: Boolean;
begin
  // listar ninja
  lst_nj := listapessoas(100);
  Exit;

//  Self.CarregarRESTClient;
//  RESTRequest1.Resource := '/pessoas';
//  RESTRequest1.Method := TRESTRequestmethod.rmGET;
//  RESTRequest1.Execute;
//
//  vJSONObject := RESTResponse1.JSONValue as TJSONObject;
//  vJSONPair := vJSONObject.Get(0);
//  vJSONarray := vJSONPair.JSONValue as TJSONArray;
//
//  vPessoa := TJson.JsonToObject<TPessoa>(vJSONarray.Get(0).ToJSON);
//  try
//    Edt_id.Text := vPessoa.idpessoa.ToString;
//    Edt_pnome.Text := vPessoa.nmprimeiro;
//    Edt_doc.Text := vPessoa.nmsegundo;
//    Edt_snome.Text := vPessoa.nmsegundo;
//    Edt_natural.Text := vPessoa.flnatureza.ToString;
//  finally
//    vPessoa.Free;
//  end;

end;

function TFormList.listapessoas(qtd: integer): Boolean;
var
  cJSONObject: TJSONObject;
  cJSONPair: TJSONPair;
  cJSONarray_p, cJSONarray_e, p, e: TJSONArray;
  Data: string;
  cEnd_integracao: TEnderecoIntegracao;
  i, j: integer;
  vPessoa: TPessoa;

begin
  i := 0;
  Result := False;
  Self.CarregarRESTClient;

  // carrega pessoas
  RESTRequest1.Resource := '/Listarpessoas/{all}';
  RESTRequest1.Params.AddUrlSegment('all', IntToStr(qtd));
  RESTRequest1.Execute;
  cJSONObject := RESTResponse1.JSONValue as TJSONObject;
  cJSONPair := cJSONObject.Get(0);
  p := cJSONPair.JSONValue as TJSONArray;
  cJSONarray_p := p.Get(0) as TJSONArray;

  FDM_wk_lista_local.Open;
  FDM_wk_lista_local.First;

  for i := 0 to cJSONarray_p.Count - 1 do
  begin
    vPessoa := TJson.JsonToObject<TPessoa>(cJSONarray_p.Get(i).ToJSON);
    FDM_wk_lista_local.Append;
    FDM_wk_lista_localidpessoa.AsInteger := vPessoa.idpessoa;
    FDM_wk_lista_localpnome.AsString := vPessoa.nmprimeiro;
    FDM_wk_lista_localsnome.AsString := vPessoa.nmsegundo;
    FDM_wk_lista_localdoc.AsString := vPessoa.dsdocumento;
    FDM_wk_lista_localnatureza.AsInteger := vPessoa.flnatureza;
    FDM_wk_lista_localdta_registro.AsDateTime := vPessoa.dtregistro;
  end;
  FDM_wk_lista_local.Post;
  FDM_wk_lista_local.First;
  grid_lista_pessoa.RowCount := FDM_wk_lista_local.RecordCount;
  i := 0;
  while not FDM_wk_lista_local.Eof do
  begin
    grid_lista_pessoa.Cells[0, i] :=
      IntToStr(FDM_wk_lista_localidpessoa.AsInteger);
    grid_lista_pessoa.Cells[1, i] := FDM_wk_lista_localpnome.AsString;
    grid_lista_pessoa.Cells[2, i] := FDM_wk_lista_localsnome.AsString;
    inc(i);
    FDM_wk_lista_local.Next;
  end;

end;



Function TFormList.ValidarCEP(const CEP: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(CEP) do
    if CEP[i] in ['0' .. '9'] then
      Result := Result + CEP[i];
  if Length(Result) <> 8 then
    raise Exception.Create('CEP inv�lido.')
  else
    Result := Copy(Result, 1, 2) + '.' + Copy(Result, 3, 3) + '-' +
      Copy(Result, 6, 3);
end;


//inclus�o
procedure TFormList.Btn_postClick(Sender: TObject);
var
  vPessoa: TPessoa;
  vCadastro: TCadastro;
  vJSONObject, bJSONObject: TJSONObject;
  vJSONPair: TJSONPair;
  cJSONArray: TJSONArray;
  LocTest_cep: Boolean;
  CEP: string;
  i: integer;
begin
  if (edt_cep.Text = '') or (edt_cep.Text = '00000000') then
  begin
    ShowMessage('Digite um CEP valido!');
    edt_cep.SetFocus;
    Exit
  end;

  if (Edt_pnome.Text = '') or (Edt_snome.Text = '') or (Edt_doc.Text = '') or
    (Edt_natural.Text = '') then
  begin
    ShowMessage('Preencha todos os campos!');
    Edt_pnome.SetFocus;
    Exit
  end;

  CEP := ValidarCEP(edt_cep.Text);
  vPessoa := TPessoa.Create;

  try
    vPessoa.idpessoa := StrToInt(Edt_id.Text);
    vPessoa.CEP := edt_cep.Text;
    vPessoa.nmprimeiro := Edt_pnome.Text; // 'Antunes santos';
    vPessoa.nmsegundo := Edt_snome.Text;
    vPessoa.dsdocumento := Edt_doc.Text;
    vPessoa.flnatureza := StrToInt(Edt_natural.Text);
    vPessoa.dtregistro := Now;
    vJSONObject := TJson.ObjectToJsonObject(vPessoa);

    Self.CarregarRESTClient;

    RESTRequest1.Resource := '/pessoas';
    RESTRequest1.Method := TRESTRequestmethod.rmPOST;
    RESTRequest1.AddBody(vJSONObject.ToString,
      ContentTypeFromString('application/json'));
    RESTRequest1.Execute;
    RESTRequest1.ClearBody;

    bJSONObject := RESTResponse1.JSONValue as TJSONObject;
    vJSONPair := bJSONObject.Get(0);
    cJSONArray := vJSONPair.JSONValue as TJSONArray;
    vCadastro := TJson.JsonToObject<TCadastro>(cJSONArray.Get(0).ToJSON);

    Edt_id.Text := IntToStr(vCadastro.id_cad);
    Edt_pnome.Text := vCadastro.cnmprimeiro;
    Edt_snome.Text := vCadastro.cnmsegundo;
    Edt_doc.Text := ''; // vCadastro.cdocumento;
    Edt_natural.Text := IntToStr(vCadastro.cflnatureza);

    Lbl_idend.Text := IntToStr(vCadastro.id_cad);
    Lbl_uf.Text := TrocaCaracterEspecial(vCadastro.cuf, True);
    Lbl_cep.Text := ValidarCEP(TrocaCaracterEspecial(vCadastro.cdscep, True));
    Lbl_dtacad.Text := DateToStr(Now); // vCadastro.cdtregistro;
    Lbl_cidade.Text := TrocaCaracterEspecial(vCadastro.ccidade, True);
    lbl_bairro.Text := TrocaCaracterEspecial(vCadastro.cbairro, True);
    Lbl_numero.Text := '0'; // vCadastro.
    lbl_lougradouro.Text := TrocaCaracterEspecial(vCadastro.clougradouro, True);
    Lbl_complento.Text := TrocaCaracterEspecial(vCadastro.ccomplemento, True);

  finally
    vPessoa.Free;
  end;

end;

// envia lista contento dados para cadastro
procedure TFormList.Btn_post_listClick(Sender: TObject);
begin
  if Op_list_cad_csv.Execute then
  begin

    if FileExists(Op_list_cad_csv.FileName) then
    begin
      AssignFile(ArquivoCSV, Op_list_cad_csv.FileName);
      Reset(ArquivoCSV);
      thr_send_data.Active := True;
    end
    else
    begin
      ShowMessage('Erro com o Arquivo');
    end;

  end;

end;

procedure TFormList.thr_send_dataRun(Sender: TIdThreadComponent);
var
  Linha: String;
  vCadastro: TCadastro;
  vJSONObject, bJSONObject: TJSONObject;
  vJSONPair: TJSONPair;
  cJSONArray: TJSONArray;
begin

  try
    FDM_wk_lista_local.Active := True;
    while not Eoln(ArquivoCSV) do
    begin
      Readln(ArquivoCSV, Linha);
      MRetget.Lines.Add(Linha);
      // instancia request

      Self.CarregarRESTClient;
      RESTRequest1.Resource := '/ListaDados/{dados}';
      RESTRequest1.Params.AddUrlSegment('dados', Linha);
      RESTRequest1.Execute;

      // instacia response
      bJSONObject := RESTResponse1.JSONValue as TJSONObject;
      vJSONPair := bJSONObject.Get(0);
      cJSONArray := vJSONPair.JSONValue as TJSONArray;
      vCadastro := TJson.JsonToObject<TCadastro>(cJSONArray.Get(0).ToJSON);

      FDM_wk_lista_local.Append;
      FDM_wk_lista_localidpessoa.AsInteger := vCadastro.id_cad;
      FDM_wk_lista_localcep.AsString := vCadastro.cdscep;
      FDM_wk_lista_localpnome.AsString := vCadastro.cnmprimeiro;
      FDM_wk_lista_localsnome.AsString := vCadastro.cnmsegundo;
      FDM_wk_lista_localdoc.AsString := vCadastro.cdocumento;
      FDM_wk_lista_localnatureza.AsInteger := vCadastro.cflnatureza;
      // FDM_wk_lista_localdta_registro.AsDateTime:=StrToDateTime(vCadastro.cdtregistro);
      Lbl_idend.Text := IntToStr(vCadastro.id_cad);

      // Lbl_uf.Text := TrocaCaracterEspecial(vCadastro.cuf, True);
      // Lbl_cep.Text := ValidarCEP(TrocaCaracterEspecial(vCadastro.cdscep, True));
      // Lbl_dtacad.Text := DateToStr(Now); // vCadastro.cdtregistro;
      // Lbl_cidade.Text := TrocaCaracterEspecial(vCadastro.ccidade, True);
      // lbl_bairro.Text := TrocaCaracterEspecial(vCadastro.cbairro, True);
      // Lbl_numero.Text := '0'; // vCadastro.
      // lbl_lougradouro.Text := TrocaCaracterEspecial(vCadastro.clougradouro, True);
      // Lbl_complento.Text := TrocaCaracterEspecial(vCadastro.ccomplemento, True);
    end;
    FDM_wk_lista_local.Post;
    CloseFile(ArquivoCSV);
    thr_send_data.Terminate;
  except
    raise Exception.Create('Erro ao processar o Arquivo !.');
  end;
end;

procedure TFormList.thr_send_dataTerminate(Sender: TIdThreadComponent);
begin
 ShowMessage('Lista de nome: '+Op_list_cad_csv.FileName+ ' Processado com Sucesso!');
 ShowMessage('Para carregar a lista completa use o bot�o "Get - Listar todo Cadastro" :) ')
end;

//alterar data
procedure TFormList.Btn_putClick(Sender: TObject);
var
  uPessoa: TPessoa;
  uCadastro: TCadastro;
  uJsonobject, bJSONObject: TJSONObject;
  uJSONPair: TJSONPair;
  uJSONArray: TJSONArray;
begin
  if (edt_cep.Text = '') or (edt_cep.Text = '00000000') then
  begin
    ShowMessage('Digite um CEP valido!');
    edt_cep.SetFocus;
    Exit
  end;

  if (Edt_pnome.Text = '') or (Edt_snome.Text = '') or (Edt_doc.Text = '') or
    (Edt_natural.Text = '') then
  begin
    ShowMessage('Preencha todos os campos!');
    Edt_pnome.SetFocus;
    Exit
  end;

  uPessoa := TPessoa.Create;
  try
    uPessoa.idpessoa := StrToInt(Edt_id.Text);
    uPessoa.CEP := edt_cep.Text;
    uPessoa.nmprimeiro := Edt_pnome.Text; // 'Antunes santos';
    uPessoa.nmsegundo := Edt_snome.Text;
    uPessoa.dsdocumento := Edt_doc.Text;
    uPessoa.flnatureza := StrToInt(Edt_natural.Text);
    uPessoa.dtregistro := Now;
    uJsonobject := TJson.ObjectToJsonObject(uPessoa);

    Self.CarregarRESTClient;

    RESTRequest1.Resource := '/pessoas';
    RESTRequest1.Method := TRESTRequestmethod.rmPUT;
    RESTRequest1.AddBody(uJsonobject.ToString,
      ContentTypeFromString('application/json'));
    RESTRequest1.Execute;
    RESTRequest1.ClearBody;

    uJsonobject := RESTResponse1.JSONValue as TJSONObject;
    uJSONPair := uJsonobject.Get(0);
    uJSONArray := uJSONPair.JSONValue as TJSONArray;
    uCadastro := TJson.JsonToObject<TCadastro>(uJSONArray.Get(0).ToJSON);

    Edt_id.Text := IntToStr(uCadastro.id_cad);
    Edt_pnome.Text := uCadastro.cnmprimeiro.Replace('"', '');
    Edt_snome.Text := uCadastro.cnmsegundo.Replace('"', '');
    Edt_doc.Text := uCadastro.cdocumento.Replace('"', '');
    Edt_natural.Text := IntToStr(uCadastro.cflnatureza);
    Lbl_idend.Text := IntToStr(uCadastro.id_cad);
    Lbl_uf.Text := TrocaCaracterEspecial(uCadastro.cuf.Replace('"', ''), True);
    Lbl_cep.Text :=
      ValidarCEP(TrocaCaracterEspecial(uCadastro.cdscep.Replace('"',
      ''), True));
    Lbl_dtacad.Text := DateToStr(Now); // vCadastro.cdtregistro;
    Lbl_cidade.Text := TrocaCaracterEspecial(uCadastro.ccidade.Replace('"',
      ''), True);
    lbl_bairro.Text := TrocaCaracterEspecial(uCadastro.cbairro.Replace('"',
      ''), True);
    Lbl_numero.Text := '0'; // vCadastro.
    lbl_lougradouro.Text := TrocaCaracterEspecial
      (uCadastro.clougradouro.Replace('"', ''), True);
    Lbl_complento.Text := TrocaCaracterEspecial
      (uCadastro.ccomplemento.Replace('"', ''), True);
    ShowMessage('Dados Alterados com Suecesso !');
  finally
    uPessoa.Free;
  end;
end;

procedure TFormList.CarregarRESTClient;
begin
  RESTClient1.ResetToDefaults;
  RESTResponse1.ResetToDefaults;
  RESTRequest1.ClearBody;
  RESTClient1.BaseURL := 'http://localhost:1717/datasnap/rest/TSM/';
  MRetget.Text := EmptyStr;

end;

procedure TFormList.FormShow(Sender: TObject);
begin
 Lbl_dtacad.Text:=DateToStr(Now);
 edt_cep.SetFocus;
end;

procedure TFormList.Btn_delClick(Sender: TObject);
begin
  if (Edt_id.Text = '') or (Edt_id.Text = '0') then
  begin
    ShowMessage('Digite um ID cadastrado valido !');
    Edt_id.SetFocus;
    Exit
  end;

  Self.CarregarRESTClient;
  RESTRequest1.Resource := '/pessoas/{idpessoa}';
  RESTRequest1.Method := TRESTRequestmethod.rmDELETE;
  RESTRequest1.Params.AddUrlSegment('idpessoa', Edt_id.Text);
  RESTRequest1.Execute;
  ShowMessage('Cadastro de ID Numero:  ' + Edt_id.Text +
    '  Excluido com sucesso!');
end;

end.
