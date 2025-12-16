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
  filerec = record n : string; t : longint end;
  authorrec = record
                name  : string;
                birth : string;
                txt   : ansistring;
              end;
  pointrec = record
               id       : string;
               name     : string;
               fn,ln    : string;
               bio      : ansistring;
               geometry : string;
               imgf     : string
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
       chr(13) : sanitized += '/n';
       chr(10) : sanitized += '/n';
       '"' : sanitized += '/"';
       else sanitized += s[i]
     end
  end;

  function geomrevert (s:string) : string;
  var p,l : integer;
  begin
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

var
  cf : csvfile;
  f  : text;

  apos,i : integer;

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
        name := col[1];
        birth := col[2];
        txt := col[3]
      end
    end
  end;
  csvclose (cf);
  with author[0] do
  begin
    name := 'not found';
    txt  := 'No data'
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
               apos := authorfind (fn,ln);
               bio := sanitized(author[apos].txt);

               if apos=0 then writeln ('!! author not found : ',fn,' ',ln);
               imgf := imgfile (col[5]);
               geometry := geomrevert (col[4]);
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
      write (f,               ', "name": "'+name+'"');
      write (f,               ', "id": "'+id+'"');
      write (f,               ', "fn": "'+fn+'"');
      write (f,               ', "ln": "'+ln+'"');
      write (f,               ', "bio": "'+bio+'"');
      writeln (f,               '} }, ')

    end;

  writeln (f,']');
  writeln (f,'}');

  close (f)

end.
