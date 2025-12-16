{$h+}
{$mode objfpc}
program prep;
uses
  sysutils, base, csv;

const
  photofolder='photo/';

  maxinfiles=1000;
  maxauthors=200;
  maxpoints=maxinfiles;

type
  longtext = record
               a : array [1..20] of ansistring;
               n : integer;
             end;

  filerec = record n : string; t : longint end;
  authorrec = record
                name  : string;
                birth : string;
                txt   : longtext;
              end;
  pointrec = record
               id       : string;
               name     : string;
               era      : string;
               fn,ln    : string;
               bio      : longtext;
               year     : string;
               geometry : string;
               imgf     : string;
               teh      : string;
               format   : string;
               tags     : string;
               vlas     : string;
               vlink    : string;
               phcredit : string;
               desc1    :longtext;
               desc2    :longtext
             end;


var
  inpf     : array [0..maxinfiles] of filerec;
  inpfnum  : integer;

  author  : array [0..maxauthors] of authorrec;
  authors : integer;

  point  : array [0..maxpoints] of pointrec;
  points : integer;



  function sanitized (s:ansistring) : ansistring;
  var i : integer;
  begin
    sanitized := '';
    for i := 1 to length(s) do
     case s[i] of
       chr(13) : sanitized += '\n';
       chr(10) : sanitized += '\n';
       '/'     : sanitized += '\/';
       '"'     : if (i<length(s)) and (s[i+1]='"')
                 then sanitized += '\'
                 else sanitized += '"';
       else      sanitized += s[i]
     end
  end;

  function geomrevert (s:string) : string;
  var p,l : integer;
  begin
    p := pos ('\n',s); // trim two line entries
    if p>0
    then s := copy (s,1,p-1);

    l := length(s);
    p := pos (',',s);
    if p=0
    then geomrevert := s
    else geomrevert := trim(copy(s,p+1,l-p)) + ', ' + copy (s,1,p-1)
  end;

  procedure addfile (name:string);
  var l1 : byte;
  begin
    inpfnum := inpfnum+1;
    with inpf[inpfnum] do
    begin
      l1 := length(photofolder);
      n := copy (name,l1+1,length(name)-l1)
    end
  end;

  procedure sortfiles;
  var i,j : integer;

    function before (a,b:integer): boolean;
    begin
      before := copy(inpf[a].n,1,4) < copy(inpf[b].n,1,4)
    end;

  begin
    for i := 1 to inpfnum-1 do
      for j := i+1 to inpfnum do
        if before (j,i)
        then begin inpf[0] := inpf[i]; inpf[i] := inpf[j]; inpf[j] := inpf[0] end;
  end;

  function imgfile (s:string) : string;
  var i : integer;
  begin
    imgfile := '';
    for i := 1 to inpfnum do
      with inpf[i] do
        if copy(n,1,4)=s then imgfile := n
  end;

  function authorfind (fn,ln:string) : integer;
  var p,i : integer;
  begin
    p := 0;
    for i := 1 to authors do
      with author[i] do
        if fn+' '+ln = name
        then p := i;
    if p = 0
    then for i := 1 to authors do
           with author[i] do
             if ln+' '+fn = name
             then p := i;
    authorfind := p
  end;

  function parasplit (s:ansistring) : longtext;
  var
    p : integer;
  begin
    s := s+' ';
    with parasplit do
    begin
      n := 1;
      p := pos ('\n',s);
      while p<>0 do
      begin
        a[n] := trim(copy (s,1,p-1));
        n := n+1;
        s := copy (s,p+2,length(s)-p-1);
        p := pos ('\n',s)
      end;
      a[n] := trim(s);
      if a[n]=''
      then n := n-1
    end;
  end;

var
  cf : csvfile;
  f  : text;

  apos,i,j : integer;

begin

  inpfnum := 0;
  traverse (photofolder+'*.*', @addfile);
  sortfiles;
  //for i := 1 to inpfnum do writeln (i,' ! ',inpf[i].n);

  csvheadersstart ('headers.txt');
  authors := 0;
  csvreset (cf,'slikari.csv');
  while not cf.eot do
  begin
    csvget (cf);
    with cf.rec do
    begin
      authors := authors+1;
      with author[authors] do
      begin
        name  := col[1];
        birth := col[2];
        txt   := parasplit (sanitized(col[3]));
      end
    end
  end;
  csvclose (cf);
  with author[0] do
  begin
    name := 'not found';
    txt.n:= 1;
    txt.a[txt.n]:='No data';
  end;

  writeln ('processing points...');

  assign (f,'copyrenamed.sh');
  rewrite (f);
  points := 0;
  csvreset (cf,'points.csv');
  while not cf.eot do
  begin
    csvget (cf);
    with cf.rec do
    begin
      if (col[4]<>'') and (col[5]<>'')
      then begin
             with point[0] do
             begin
               id   := col[5];
               name := col[6];
               fn   := col[7];
               ln   := col[8];
               year := col[9];
               apos := authorfind (fn,ln);
               era  := author[apos].birth;
               bio  := author[apos].txt;

               teh    := col[10];
               format := col[11];
               tags   := sanitized(col[17]);

               vlas     := sanitized(col[12]);
               vlink    := col[13];
               phcredit := col[14];

               if apos=0 then writeln ('!! author not found : ',fn,' ',ln);
               imgf := imgfile (col[5]);
               geometry := geomrevert (col[4]);

               desc1 := parasplit (sanitized(col[15]));
               desc2 := parasplit (sanitized(col[16]));

               if imgf=''
               then writeln ('!! image not found  : ',col[5])
               else begin
                      writeln (f,'cp "photo/',imgf,'" ../../images/',col[5],'.jpg');
                      imgf := copy (imgf,1,4)+'.jpg'
                    end
             end;
             if point[0].imgf<>''
             then begin
                    points := points+1;
                    point[points] := point[0]
                  end
           end;
    end
  end;
  csvclose (cf);
  writeln (f,'exiftool photo/*.* >exif.txt');
  close (f);

  csvheadersstop;

  writeln ('outpug gjson...');
  assign (f,'../../poi.js');
  rewrite (f);

  writeln (f,'var gjson_poi = {');
  writeln (f,'"type": "FeatureCollection",');
  writeln (f,'"name": "data",');
  writeln (f,'"crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:OGC:1.3:CRS84" } },');
  writeln (f,'"features": [');

  for i := 1 to points do
    with point[i] do
    begin

      write (f,'{ "type": "Feature"');
      write (f,', "geometry": { "type": "Point", "coordinates": [',geometry,']}');
      write (f,', "properties": { "img": "images\/',imgf,'"');
      write (f,               ', "id": "'+id+'"');
      write (f,               ', "name": "'+name+'"');
      write (f,               ', "year": "'+year+'"');
      write (f,               ', "teh": "'+teh+'"');
      write (f,               ', "format": "'+format+'"');
      write (f,               ', "vlas": "'+vlas+'"');
      write (f,               ', "fn": "'+fn+'"');
      write (f,               ', "ln": "'+ln+'"');
      write (f,               ', "era": "'+era+'"');
      write (f,               ', "tags": "'+tags+'"');

      write (f,               ', "bio": [');
      for j := 1 to bio.n do begin write (f,'"'+bio.a[j],'"'); if j<bio.n then write (f,', '); end;
      write (f,                         ']');

      write (f,               ', "desc1": [');
      for j := 1 to desc1.n do begin write (f,'"'+desc1.a[j],'"'); if j<desc1.n then write (f,', '); end;
      write (f,                         ']');

      write (f,               ', "desc2": [');
      for j := 1 to desc2.n do begin write (f,'"'+desc2.a[j],'"'); if j<desc2.n then write (f,', '); end;
      write (f,                         ']');

      writeln (f,               '} }, ')

    end;

  writeln (f,']');
  writeln (f,'}');

  close (f)

end.
