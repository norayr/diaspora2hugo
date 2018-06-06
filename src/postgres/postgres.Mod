MODULE postgres;

IMPORT Sys, Strings, oocStrings2, Out, pipes;

VAR
  user-, database-: Sys.string;
  queryStr-: Sys.string;

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
	  oocStrings2.InsertChar('\', i, s);
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

PROCEDURE query*(VAR cmd: ARRAY OF CHAR);
VAR
  f: pipes.Text;
  out: ARRAY 64 OF CHAR;
BEGIN
  constructQuery(cmd);
  Out.String(queryStr); Out.Ln;
  NEW(f);
  pipes.Popen(f, queryStr, 'r');
  REPEAT
    pipes.ReadLine(f, out);
    Out.String(out); Out.Ln;
    Out.Ln
  UNTIL f.eof;
END query;

BEGIN
  user := "postgres";
END postgres.
