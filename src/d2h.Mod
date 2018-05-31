MODULE d2h;
IMPORT Out, Platform,
       postgres, pipes;


PROCEDURE test;
  VAR
    cmd, out: ARRAY 64 OF CHAR;
	f: pipes.Text;
    ch : CHAR;
BEGIN

  postgres.setUser("postgres");
  postgres.setDatabase("diaspora_production");
  postgres.constructQuery("SELECT id from posts WHERE author_id='1' AND type='StatusMessage' AND public='t';");

  Out.String(postgres.query); Out.Ln;

  cmd := "ls -al";
  NEW(f);
  pipes.Popen(f, cmd, 'r');
  REPEAT
    pipes.ReadLine(f, out);
    Out.String(out); Out.Ln;
  UNTIL f.eof;
  (*
  REPEAT
    pipes.Read(f, ch);
    Out.Char(ch); Out.Ln;
  UNTIL f.eof;
  *)
END test;

BEGIN
  test
END d2h.
