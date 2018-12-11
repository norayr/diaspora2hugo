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
 photoFull, photoScaled: ARRAY 128 OF CHAR;
 testPid: ARRAY 12 OF CHAR;
BEGIN
  testPid := "3389030";
  (*testPid := "455122");*)
  parseArgs(username);
  diasporadb.getUserID(username, userID);
  postIDs := diasporadb.getListOfPosts(userID, FALSE);
  list(postIDs);
  text := diasporadb.getText(testPid);
  list(text);
  tags := StringList.Create();
  tags := diasporaPost.findTags(text);
  list(tags);
  diasporadb.getCreationTime(testPid, time);
  Out.String(time); Out.Ln;
  time[10] := 'T';
  Strings.Append("+04:00", time);
  Out.String(time); Out.Ln;
  IF diasporadb.getPhotoLinksByPostId(testPid, photoFull, photoScaled) THEN
    Out.String(photoFull); Out.Ln;
    Out.String(photoScaled); Out.Ln;
  ELSE
    Out.String("post has no photo"); Out.Ln
  END;
END main;

BEGIN
  main;
END d2h.
