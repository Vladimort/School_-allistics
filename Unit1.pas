unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    EditMass: TEdit;
    Label1: TLabel;
    EditK: TEdit;
    EditSpeed: TEdit;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
  n=200;

var
  Form1: TForm1;
  c,m,k,x1,V1,x2,V2,x3,V3,x4,V4:real;
  t,x,V:array[0..n] of real;
  j:integer;

implementation

{$R *.dfm}
function F(t:real):real;
begin
 F:=1;
end;
function f1(t,x,V:real):real;
begin
 f1:=v;
end;
function f2(t,x,V:real):real;
begin
 f2:=(F(t)-c*V-k*x)/m;
end;
procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
 dt,a,b:real;
 xmin, xmax, Vmin, Vmax:real;
begin
 m:=StrToFloat(EditMass.Text);
 k:=StrToFloat(EditK.Text);
 c:=StrToFloat(EditSpeed.Text);
 for i:=0 to n do
  a:=0;
  b:=10;
  dt:=(b-a)/n;
  x[0]:=1;
  V[0]:=0;
  t[0]:=0;
  xmin:=x[0];
  xmax:=x[0];
  Vmin:=V[0];
  Vmax:=V[0];
   for i:=1 to n do
    begin
     x1:=dt*f1(t[i-1],x[i-1],v[i-1]);
     v1:=dt*f2(t[i-1],x[i-1],V[i-1]);
     x2:=dt*f1(t[i-1]+dt/2,x[i-1]+x1/2,v[i-1]+v1/2);
     v2:=dt*f2(t[i-1]+dt/2,x[i-1]+x1/2,v[i-1]+v1/2);
     x3:=dt*f1(t[i-1]+dt/2,x[i-1]+x2/2,v[i-1]+v2/2);
     v3:=dt*f2(t[i-1]+dt/2,x[i-1]+x2/2,v[i-1]+v2/2);
     x4:=dt*f1(t[i-1]+dt,x[i-1]+x3,v[i-1]+v3);
     v4:=dt*f2(t[i-1]+dt,x[i-1]+x3,v[i-1]+v3);
     x[i]:=x[i-1]+(x1+2*x2+2*x3+x4)/6;
     V[i]:=V[i-1]+(V1+2*V2+2*V3+V4)/6;
     t[i]:=t[i-1]+dt;
     if x[i]<xmin then xmin:=x[i];
     if x[i]>xmax then xmax:=x[i];
     if V[i]<Vmin then Vmin:=V[i];
     if V[i]>Vmax then Vmax:=V[i];
    end;
  Series1.Clear;
  Series2.Clear;
  j:=0;
  Timer1.Enabled:=True;
  Chart1.BottomAxis.Automatic:=false;
  Chart1.BottomAxis.Minimum:=0;
  Chart1.BottomAxis.Maximum:=b;
  Chart1.LeftAxis.Automatic:=false;
  Chart1.RightAxis.Automatic:=false;
  if CheckBox1.Checked
   then begin
    Series1.VertAxis:=aRightAxis;
    Chart1.LeftAxis.Minimum:=xmin;
    Chart1.LeftAxis.Maximum:=xmax;
    Chart1.RightAxis.Minimum:=Vmin;
    Chart1.RightAxis.Maximum:=Vmax;
   end else
   begin
    Series1.VertAxis:=aLeftAxis;
    if xmin<Vmin then Chart1.LeftAxis.Minimum:=xmin
                 else Chart1.LeftAxis.Minimum:=Vmin;
    if xmax>Vmax then Chart1.LeftAxis.Maximum:=xmax
                 else Chart1.LeftAxis.Maximum:=Vmax;
   end;
{
  for i:=0 to n do
   begin
    Series1.AddXY(t[i],V[i],'',clRed);
    Series2.AddXY(t[i],x[i],'',clGreen);
   end
}
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    Series1.AddXY(t[j],V[j],'',clRed);
    Series2.AddXY(t[j],x[j],'',clGreen);
    j:=j+1;
    if j>n Then Timer1.Enabled:=false;
end;

end.
