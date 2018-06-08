MODULE diasporadb;

IMPORT postgres, StringList, Strings := oocStrings, Out;

PROCEDURE getListOfPosts*(VAR userid: ARRAY OF CHAR; public : BOOLEAN): StringList.TStringList;
VAR
  cmd: ARRAY 128 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  cmd := "SELECT id from posts WHERE author_id='";
  Strings.Append(userid, cmd);
  IF public THEN
    Strings.Append("' AND type='StatusMessage' AND public='t';", cmd)
  ELSE
  Strings.Append("' AND type='StatusMessage' AND public='f';", cmd)
  END;
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  strs.Delete(strs, 0);
  strs.Delete(strs, 0);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  RETURN(strs);
END getListOfPosts;

PROCEDURE getListOfPrivatePosts*(VAR userid: ARRAY OF CHAR): StringList.TStringList;
VAR
  cmd: ARRAY 128 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  cmd := "SELECT id from posts WHERE author_id='";
  Strings.Append(userid, cmd);
  Strings.Append("' AND type='StatusMessage' AND public='f';", cmd);
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  strs.Delete(strs, 0);
  strs.Delete(strs, 0);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  RETURN(strs);
END getListOfPrivatePosts;


PROCEDURE getCreationTime*(postid: ARRAY OF CHAR; VAR time: ARRAY OF CHAR);
VAR
  cmd: ARRAY 256 OF CHAR;
  strs: StringList.TStringList;
  e: StringList.Node;
BEGIN
  cmd := "SELECT created_at from posts WHERE id='";
  Strings.Append(postid, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  strs := postgres.query(cmd);
  strs.Delete(strs, 0);
  strs.Delete(strs, 0);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  e := strs.Get(strs, strs.Count-1);
  Strings.Assign(e.obj(StringList.TString).str, time);
END getCreationTime;

PROCEDURE getText*(postid: ARRAY OF CHAR): StringList.TStringList;
VAR
  cmd: ARRAY 256 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  cmd := "SELECT text from posts WHERE id='";
  Strings.Append(postid, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  strs := postgres.query(cmd);
  strs.Delete(strs, 0);
  strs.Delete(strs, 0);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  RETURN(strs);
END getText;

PROCEDURE getRaw*(VAR username, userID: ARRAY OF CHAR);
VAR
  cmd: ARRAY 64 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  cmd := "SELECT id FROM users WHERE username='";
  Strings.Append(username, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
END getRaw;

PROCEDURE getUserID*(VAR username, userID: ARRAY OF CHAR);
VAR
  cmd: ARRAY 64 OF CHAR;
BEGIN
  cmd := "SELECT id FROM users WHERE username='";
  Strings.Append(username, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  postgres.queryL(cmd, userID);
END getUserID;



BEGIN
  postgres.setUser("diaspora");
  postgres.setDatabase("diaspora_production");


END diasporadb.
