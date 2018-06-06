MODULE postgres;

IMPORT Sys, Strings, Out, pipes;

VAR
  user-, database-: Sys.string;
  queryStr-: Sys.string;

PROCEDURE setUser*(s: ARRAY OF CHAR);
BEGIN
  user := s  
END setUser;

PROCEDURE setDatabase*(s: ARRAY OF CHAR);
BEGIN
  database := s
END setDatabase;

PROCEDURE constructQuery*(s: ARRAY OF CHAR);
BEGIN
  queryStr := "psql -U ";
  Strings.Append(user, queryStr);
  Strings.Append(" -d ", queryStr);
  Strings.Append(database, queryStr);
  Strings.Append(' -c "', queryStr);
  Strings.Append(s, queryStr);
  Strings.Append('"', queryStr);
END constructQuery;

PROCEDURE query*(VAR cmd: ARRAY OF CHAR);
VAR
  f: pipes.Text;
  out: ARRAY 64 OF CHAR;
BEGIN
  constructQuery(cmd);
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
