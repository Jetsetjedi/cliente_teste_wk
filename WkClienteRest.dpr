program WkClienteRest;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {FormList},
  Pessoa in 'cli_classes\Pessoa.pas',
  Endereco_Integracao in 'cli_classes\Endereco_Integracao.pas',
  Cadastro in 'cli_classes\Cadastro.pas',
  uWKUtils in 'uWKUtils.pas',
  Endereco in 'cli_classes\Endereco.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormList, FormList);
  Application.Run;
end.
