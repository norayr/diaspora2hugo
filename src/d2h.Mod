MODULE d2h;
IMPORT Out, Platform,
       postgres, pipes;


PROCEDURE test;
  VAR
    cmd0, cmd1: ARRAY 5 OF CHAR;
	f: Platform.FileHandle;
	buf : ARRAY 5 OF CHAR;
	res : INTEGER;
	tmp : LONGINT;
BEGIN

  postgres.setUser("postgres");
  postgres.setDatabase("diaspora_production");
  postgres.constructQuery("SELECT id from posts WHERE author_id='1' AND type='StatusMessage' AND public='t';");

  Out.String(postgres.query); Out.Ln;

  cmd0 := "ls"; cmd1 := "r";
  f := pipes.Popen(cmd0, cmd1);
  tmp := 1;
  res := Platform.ReadBuf(f, buf, tmp);
  Out.Char(buf[0]); Out.Ln;
  Out.Char(buf[0]); Out.Ln;
  Out.Char(buf[0]); Out.Ln;
  Out.Char(buf[0]); Out.Ln;

END test;

BEGIN

END d2h.
