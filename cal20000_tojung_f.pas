unit cal20000_tojung_f;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ComCtrls, StdCtrls, ExtCtrls, shellApi, Strutils, calendar_unit;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public

    panel_year  : array[1..10,1..21] of Tpanel  ;
    panel_month : array[1..2,1..15] of Tpanel  ;
    panel_date : array[1..14,1..31] of Tpanel  ;

    mess_y : array[1..100,1..4] of Tlabel ;
    mess_m : array[1..15,1..2] of Tlabel ;

    mess : array[1..42,1..4] of Tlabel ;
    { Public declarations }
  end;

const
  gan_su : array[0..9] of integer =
          (9,8,7,6,5,9,8,7,6,5);
  ji_tae : array[0..11] of integer =
          (11,13,10,10,13,9,9,13,12,12,13,11);
  ji_mon : array[0..11] of integer =
          (9,8,7,6,5,4,9,8,7,6,5,4);
  ji_day : array[0..11] of integer =
          (9,11,8,8,11,7,7,11,10,10,11,9);
  month_name : array[1..12] of string =
          ('ïáêÅ','ì£êÅ','ß²êÅ','ÞÌêÅ','çéêÅ',
           'ë»êÅ','öÒêÅ','ø¢êÅ','ÎúêÅ','ä¨êÅ','ä¨ìéêÅ','ä¨ì£êÅ');


var
  Form1: TForm1;
  edita,editb : Tedit ;
  updowna : Tupdown ;
  labela : Tlabel ;
  labelb : Tlabel ;
  starti : int64 ;
  start : boolean;
  preyear,premonth:int64;
  last_year : integer ;

  isyoonmonth : boolean;

implementation

{$R *.DFM}


procedure TForm1.Edit1Enter(Sender: TObject);
var
  i,j,f1: integer;
  fday,fd : int64 ;
  k,l,m : int64 ;
  present : tdatetime ;
  year,month,day, hour,min,sec,msec : int64;
  pyear,pmonth,pday,phour,pmin,psec,pmsec : word;

  y1,ym,y2,lyear,lyear1,ingiyear,midyear,outgiyear:integer;
  mo1,d1,h1,mi1 : smallint ;
  mom,dm,hm,mim : smallint ;
  mo2,d2,h2,mi2 : smallint ;
  ip,ipm,ip1 : extended;

  lmonth,lday:smallint;
  lmonth1,lday1:smallint;
  lmoonyun,largemonth:boolean;
  lmoonyun1,largemonth1:boolean;
  st : string ;
  so24:integer;
  so24year,so24month,so24day,so24hour:shortint;
  largenumber:shortint;
  lnp : boolean;
  inginame,ingimonth,ingiday,ingihour,ingimin : smallint;
  midname,midmonth,midday,midhour,midmin : smallint;
  outginame,outgimonth,outgiday,outgihour,outgimin : smallint;

  heighta : integer;

  monthlength,yearcount,month_count : integer ;
  month_info : array[1..13,1..5] of integer ;
  height: Tpanel;
begin

  starti := 1;
  start :=true;


  try
    year:=strtoint(edit1.Text);
  except
    on E: EConvertError do
    begin
      ShowMessage('¼ýÀÚ ³âµµ¸¦ ÀÔ·ÂÇÏ¼¼¿ä.');
      Edit1.Text:=inttostr(last_year);
      exit;
    end;
  end;


  if (year>9999) or (year<-9999) then
  begin

     st := '³âµµ´Â -9999ºÎÅÍ 9999³â±îÁö¸¸ ÀÔ·ÂÇÏ¼¼¿ä.';
     ShowMessage(st);
     Edit1.Text:=inttostr(last_year);
     exit;

  end;


  if year=last_year then exit;

  last_year:=year;

  fday:=getweekday(year,month,1)+1;
  fd := 0 ;


  k:=30;
  l:=3;


    sydtoso24yd(year,2,20,23,25,
                so24,so24year,so24month,so24day,so24hour);

    Label2.Caption:=ganji[so24year]+'Ò´ ÅäÁ¤ºñ°á Á¶°ßÇ¥';

  yearcount:=0;
  for i:=1 to 10 do
    for j:=1 to 21 do
    begin

      if ((i mod 2)=0) and (j=2) then
      begin
         yearcount:=yearcount-20;
      end;
      if (j<>1) then yearcount:=yearcount+1;

      if Panel_year[i,j]=nil then
        panel_year[i,j]:=tpanel.create(self);

      with panel_year[i,j] do
      begin
        parent :=self ;
        ParentBackground := false;
        color := clwhite;

        if (i=3) or (i=4) or (i=7) or (i=8) then
          color := clSkyBlue;// clSkyBlue;// clCream;// clBtnFace;// clyellow;

        hint := '42';

        heighta := form1.clientheight div 26  ;

        if (i mod 2)=1 then
            height := (form1.clientheight div 26)+6
         else
            height := (form1.clientheight div 26)-6;

        width := form1.clientwidth div 21 ;
        left := (j-1)*width + l;
        top := (i-1)*heighta + ((i+1) mod 2)*6  + k;

        OnClick:=Panel1Click;



        if (j=1) then
        begin
          font.Size := 9;
          if ((i mod 2)=1) then caption:='ßæÒ´'
                           else caption:='ß¾ÎÏ'
        end
        else
        if ((i mod 2)=1) then
        begin

          for f1 := 1 to 4 do
          begin
            mess_y[yearcount,f1].Free;
            mess_y[yearcount,f1]:=tlabel.create(self);
            mess_y[yearcount,f1].Parent:=panel_year[i,j];
            with mess_y[yearcount,f1] do
            begin
              if f1=1 then
              begin
                left := 1;
                top := 15;
                font.size := 10 ;
                caption:=inttostr(yearcount)
              end;
              if f1=2 then
              begin
                left := 1;
                top := 1;
                font.size := 8 ;
                caption:=inttostr(year+1-yearcount)
              end;
              if f1=3 then
              begin
                left := 25;
                top := 1;
                font.size := 9 ;
                if (so24year+1-yearcount)<0 then
                begin
                  if (so24year+1-yearcount)<-60 then
                    caption:=gan[(so24year+1-yearcount+120) mod 10]
                  else caption:=gan[(so24year+1-yearcount+60) mod 10]
                end
                else caption:=gan[(so24year+1-yearcount) mod 10]
              end;
              if f1=4 then
              begin
                left := 25;
                top := 16;
                font.size := 9 ;
                if (so24year+1-yearcount)<0 then
                begin
                  if (so24year+1-yearcount)<-60 then
                    caption:=ji[(so24year+1-yearcount+120) mod 12]
                  else caption:=ji[(so24year+1-yearcount+60) mod 12]
                end
                else caption:=ji[(so24year+1-yearcount) mod 12]
              end
            end
          end

        end
        else
        begin

             if ((yearcount+gan_su[so24year mod 10]+ji_tae[so24year mod 12])mod 8)=0 then caption:='8'
             else caption:=inttostr(((yearcount+gan_su[so24year mod 10]+ji_tae[so24year mod 12]) mod 8));

        end;


      end {with}
    end; { for j }


  isyoonmonth:= false;
  month_count:=0;
  for i := 1 to 12 do
  begin
    month_count:=month_count+1;
    begin
      j:=year;
      f1:=i+1;
      if i=12 then
      begin
        j:=j+1;
        f1:=1;
      end;
      solortolunar(j,f1,18,lyear,lmonth,lday,lmoonyun,largemonth);
      solortolunar(j,f1,25,lyear1,lmonth1,midday,lmoonyun1,largemonth1);
      sydtoso24yd(j,f1,18,23,25,so24,so24year,so24month,so24day,so24hour);

      if (lmoonyun=false) and lmoonyun1 then
      begin
        if lmoonyun1 then
        begin
          month_info[month_count,1]:=month_count;
          if largemonth then month_info[month_count,2]:=1
                        else month_info[month_count,2]:=0;
          month_info[month_count,3]:=so24month;
          month_info[month_count,4]:=0;

          if largemonth then l:=30
                        else l:=29;
          k:=(l+gan_su[so24month mod 10]+ji_mon[so24month mod 12]) mod 6;
          if k=0 then k:=6;
          month_info[month_count,5]:=k;

          j:=month_count+1;
          month_info[j,1]:=month_count;
          if largemonth1 then month_info[j,2]:=1
                         else month_info[j,2]:=0;
          month_info[j,3]:=so24month;
          month_info[j,4]:=1;

          if largemonth1 then l:=30
                         else l:=29;
          k:=(l+gan_su[so24month mod 10]+ji_mon[so24month mod 12]) mod 6;
          if k=0 then k:=6;
          month_info[j,5]:=k;



          isyoonmonth:=true;
        end;


      end
      else
      begin
        if isyoonmonth then j:=i+1
                       else j:=i;

        month_info[j,1]:=month_count;
        if largemonth then month_info[j,2]:=1
                      else month_info[j,2]:=0;
        month_info[j,3]:=so24month;
        month_info[j,4]:=0;

        if largemonth then l:=30
                      else l:=29;
        k:=(l+gan_su[so24month mod 10]+ji_mon[so24month mod 12]) mod 6;
        if k=0 then k:=6;
        month_info[j,5]:=k;
      end;

    end;
  end;


  k:=263;

  l:=3;

  if isyoonmonth then  monthlength:=14
                 else  monthlength:=13 ;



  for j:=1 to monthlength do
    for i:=1 to 2 do
    begin
      if panel_month[i,j]=nil then
        panel_month[i,j]:=tpanel.create(self);
      with panel_month[i,j] do
      begin
        parent :=self ;
        ParentBackground := false;
        color := clwhite;
        height := form1.clientheight div 16  ;
        width := form1.clientwidth div monthlength ;
        left := (j-1)*width + l;
        top := (i-1)*height + k;
        OnClick:=Panel1Click;


        begin
          visible := true ;
          hint := '42';
          font.Size := 10;
          if (j=1) and (i=1) then
          begin
             caption := 'ßæêÅ';
          end;


          if (j=1) and (i=2) then
          begin
             caption := 'ñéÎÏ';
          end;

          if ((i=1)) and (j<>1) then
          begin
             mess_m[j,1].Free;
             mess_m[j,1]:=tlabel.create(self);
             st := month_name[month_info[j-1,1]];

             if month_info[j-1,2]=1 then st:=st+'ÓÞ'
                                  else st:=st+'á³';
             with mess_m[j,1] do
             begin
               begin
                 parent:= panel_month[i,j];
                 left := 5;
                 top := 21;
                 font.size := 9 ;
                 caption:=st;
               end;
             end;

             mess_m[j,2].Free;
             mess_m[j,2]:=tlabel.create(self);
             if month_info[j-1,4]=1 then st:='ëÎ'
                                    else st:=ganji[month_info[j-1,3]];
             with mess_m[j,2] do
             begin
               begin
                 parent:= panel_month[i,j];
                 left := 5;
                 top := 7;
                 font.size := 9 ;
                 caption:=st;
               end;
             end;
          end;
          if ((i=2)) and (j<>1) then
          begin
             st:=inttostr(month_info[j-1,5]);
             caption:=st;
          end;
        end;
      end {with}
    end; { for j }

  if monthlength=13 then
  begin
    for j:=1 to 2 do
    begin
      if panel_month[j,14]<>nil then
          panel_month[j,14].Visible:=false;
    end;
  end;


  k:=342;
  l:=3;

  for i:=1 to monthlength do
    for j:=1 to 31 do
    begin
      if panel_date[i,j]=nil then
        panel_date[i,j]:=tpanel.create(self);
      with panel_date[i,j] do
      begin
        parent :=self ;
        ParentBackground := false;
        color := clwhite;
        if ((i<>1)) and ((i mod 2)=1) then color := clSkyBlue;

        height := form1.clientheight div 32  ;
        width := form1.clientwidth div 33 ;
        left := (j-1)*width + l + 50;

        if j=1 then
        begin
          width := width + 50;
          left := (j-1)*width + l
        end;

        top := (i-1)*height + k;
        OnClick:=Panel1Click;

        begin
          visible := true ;

          font.Size := 9;

          if (i=1) and (j=1) then caption:='ù»ÎÏ';
          if (i=1) and (j>1) then caption:=inttostr(j-1);

          if (j=1) and (i<>1) then
          begin

             st := month_name[month_info[i-1,1]];
             if month_info[i-1,4]=1 then st:='ëÎ'+st;

             lunartosolar(year,month_info[i-1,1],1,  (month_info[i-1,4]=1),  lyear,lmonth,lday);
             sydtoso24yd(lyear,lmonth,lday,0,0, so24,so24year,so24month,so24day,so24hour);

             hint := 'À½·Â'+inttostr(year)+'³â '+ inttostr(month_info[i-1,1])+'¿ù '+'1ÀÏ ' + #13
                      + '¾ç·Â'+inttostr(lyear)+'³â '+ inttostr(lmonth)+'¿ù '+inttostr(lday)+'ÀÏ '+ ganji[so24day];

             st:=st+' '+ ganji[so24day];

             caption:=st;
          end;

          if (i>1) and (j>1) then
          begin

            m:=so24day+j-2;
            if m>59 then m:=m-60;

            hint := ganji[m] + inttostr(m);

            f1:=(j-1+gan_su[m mod 10]+ji_day[m mod 12]) mod 3;
            if f1=0 then f1:=3;

            caption:=inttostr(f1);
            if (j=31) and  (month_info[i-1,2]=0) then caption:='';

          end;



        end;
      end {with}
    end; { for j }


  if monthlength=13 then
  begin
    for j:=1 to 31 do
    begin
      if panel_date[14,j]<>nil then
          panel_date[14,j].Visible:=false;
    end;
  end;

end;

procedure TForm1.Panel1Click(Sender: TObject);
var
  st : string ;
begin
    st := 'ÅäÁ¤ºñ°á ¸¸³âÁ¶°ßÇ¥ V0.90' + #13+#13;
    st := st + ' - ÀÌ ÇÁ·Î±×·¥Àº °øÂ¥ÀÔ´Ï´Ù. µ·¹Þ°í ÆÈ°Å³ª µ·ÁÖ°í »çÁö ¸¶¼¼¿ä.'+#13#13;
    st := st + '¸¸µç³¯Â¥ : 2010³â 2¿ù 19ÀÏ(À½·Â 1¿ù 6ÀÏ, ÙæìÙÒ´ ÌÒìÙêÅ ÌÒí­ìí)'+#13#13;
    st := st + '¸¸µç»ç¶÷ : °í¿µÃ¢(Email : fftkrr@gmail.com)'+#13#13;
    st := st + 'È¨ÆäÀÌÁö : http://afnmp3.homeip.net/~kohyc/calendar/index.cgi'+#13;
    st := st + '           °Ë»öÃ¢¿¡¼­ "ÁøÂ¥¸¸¼¼·Â" À» Ä¡¼¼¿ä.'+#13;

    messagedlg(st ,mtinformation,[mbok],0)
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#$D then
  begin
    Edit1Enter(Form1);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var

  present : tdatetime ;
  year : integer;

  pyear,pmonth,pday,phour,pmin,psec,pmsec : word;

begin

  present := now ;
  decodedate(present,pyear,pmonth,pday);
  decodetime(present,phour,pmin,psec,pmsec);

  year := pyear;
  Edit1.Text:=inttostr(year);

  Edit1Enter(Form1);

end;


procedure TForm1.Label3Click(Sender: TObject);
begin
  ShellExecute(0, 'Open', 'http://www.google.co.kr/search?complete=1&hl=ko&q=%EC%A7%84%EC%A7%9C%EB%A7%8C%EC%84%B8%EB%A0%A5&lr=&aq=f&oq=', Nil, Nil, SW_SHOW);
end;

end.
