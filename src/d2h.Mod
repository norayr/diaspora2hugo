MODULE d2h;
IMPORT Out, Args, Strings := oocStrings,
       StringList,
       diasporadb,
	   diasporaPost;

PROCEDURE list(VAR s : StringList.TStringList);
VAR e : StringList.Node;
       i : INTEGER;
    L : StringList.TList;
BEGIN
   NEW(e);
   i := 0;
   NEW(L);
   L := s;
   REPEAT
      e := s.Get(L, i);
      IF e # NIL THEN Out.String (e.obj(StringList.TString).str); Out.Ln END;
      (*Out.String (e.string); Out.Ln;*)
      INC(i);
   UNTIL i = s.Count;
END list;



PROCEDURE help;
BEGIN
  Out.String("usage:"); Out.Ln;
  Out.String("./d2h username"); Out.Ln;
  Out.Ln;
END help;

PROCEDURE parseArgs(VAR u: ARRAY OF CHAR);
BEGIN
 IF Args.argc > 1 THEN
   Args.Get(1, u)
 ELSE
   help;
   HALT(1)
 END
END parseArgs;

PROCEDURE main;
 VAR userID: ARRAY 5 OF CHAR;
 username: ARRAY 16 OF CHAR;
 postIDs, text, tags: StringList.TStringList;
 time: ARRAY 32 OF CHAR;
BEGIN
  parseArgs(username);
  diasporadb.getUserID(username, userID);
  postIDs := diasporadb.getListOfPosts(userID, FALSE);
  list(postIDs);
  text := diasporadb.getText("455122");
  list(text);
  tags := StringList.Create();
  tags := diasporaPost.findTags(text);
  list(tags);
  diasporadb.getCreationTime("455122", time);
  Out.String(time); Out.Ln;
  time[10] := 'T';
  Strings.Append("+04:00", time);
  Out.String(time); Out.Ln;
END main;

BEGIN
  main;
END d2h.
