MODULE postgres;

IMPORT Sys, Strings;

VAR
  user-, database-: Sys.string;
  query-: Sys.string;

PROCEDURE setUser*(s: ARRAY OF CHAR);
BEGIN
  user := s  
END setUser;

PROCEDURE setDatabase*(s: ARRAY OF CHAR);
BEGIN
  database := s
END setDatabase;

PROCEDURE constructQuery(s: ARRAY OF CHAR);
BEGIN
  query := "psql -U ";
  Strings.Append(user, query);
  Strings.Append(" -d ", query);
  Strings.Append(database, query);
  Strings.Append(' -c "', query);
  Strings.Append(s, query);
  Strings.Append('"', query);
END constructQuery;

BEGIN
  user := "postgres";
END postgres.
