program ������Ḹ������ǥ;

uses
  Forms,
  cal20000_tojung_f in 'cal20000_tojung_f.pas' {Form1},
  calendar_unit in 'calendar_unit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
