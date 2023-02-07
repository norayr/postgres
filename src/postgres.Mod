MODULE postgres;

IMPORT Strings := oocStrings, Strings2 := oocStrings2, Out, pipes, lDefs, StringList, strutils;

VAR
  user-, database-: lDefs.string;
  queryStr-: lDefs.string;

PROCEDURE setUser*(s: ARRAY OF CHAR);
BEGIN
  user := s
END setUser;

PROCEDURE screen(VAR s: ARRAY OF CHAR);
VAR
  i: INTEGER;
BEGIN
  i := 0;
  REPEAT
    IF s[i] = "'" THEN
      Strings2.InsertChar('\', i, s);
      INC(i)
    END;
    INC(i)
  UNTIL i = Strings.Length(s);
END screen;

PROCEDURE setDatabase*(s: ARRAY OF CHAR);
BEGIN
  database := s
END setDatabase;

PROCEDURE constructQuery(s: ARRAY OF CHAR);
BEGIN
  queryStr := "psql -U ";
  Strings.Append(user, queryStr);
  Strings.Append(" -d ", queryStr);
  Strings.Append(database, queryStr);
  Strings.Append(' -c "', queryStr);
  (*screen(s);*)
  Strings.Append(s, queryStr);
  Strings.Append('"', queryStr);
END constructQuery;

PROCEDURE query*(VAR cmd: ARRAY OF CHAR): StringList.TStringList;
VAR
  f: pipes.Text;
  out: lDefs.string;
  strs: StringList.TStringList;
  l : LONGINT;
BEGIN
  constructQuery(cmd);
  Out.String(queryStr); Out.Ln;
  strs := StringList.Create();
  f := pipes.Popen(queryStr, 'r');
  REPEAT
    pipes.ReadLine(f, out);
    strutils.RemoveLeftChars(out, ' ');
    strutils.RemoveRightChars(out, ' ');
    l := strs.AddString(strs, out);
  UNTIL f.eof;
  RETURN strs
END query;

PROCEDURE queryL*(VAR cmd, rsp: ARRAY OF CHAR);
VAR
  f: pipes.Text;
  out: lDefs.string;
  strs: StringList.TStringList;
  e : StringList.Node;
  l : LONGINT;
BEGIN
  constructQuery(cmd);
  Out.String(queryStr); Out.Ln;
  NEW(f);
  strs := StringList.Create();
  f := pipes.Popen(queryStr, 'r');
  REPEAT
    pipes.ReadLine(f, out);
    l := strs.AddString(strs, out);
  UNTIL f.eof;
  e := strs.Get(strs, l-3);
  IF e # NIL THEN
    Strings.Assign((e.obj(StringList.TString).str^), rsp);
    strutils.RemoveLeftChars(rsp, ' ');
    strutils.RemoveRightChars(rsp, ' ');
    Out.String(rsp); Out.Ln
  END;
END queryL;

BEGIN
  user := "postgres";
END postgres.
