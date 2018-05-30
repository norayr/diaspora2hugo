MODULE postgres;

IMPORT Sys, Strings;

VAR
  user, database: Sys.string;

PROCEDURE setUser*(VAR s: ARRAY OF CHAR);
BEGIN
  user := s  
END setUser;

PROCEDURE setDatabase*(VAR s: ARRAY OF CHAR);
BEGIN
  database := s
END setDatabase;

PROCEDURE constructQuery(VAR s: ARRAY OF CHAR);
  VAR
    query: Sys.string;
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
