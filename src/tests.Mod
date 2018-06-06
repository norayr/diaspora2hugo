MODULE tests;

IMPORT pipes, postgres, Out;

PROCEDURE test0;
  VAR
    cmd, out: ARRAY 64 OF CHAR;
    f: pipes.Text;
    ch : CHAR;
BEGIN

  postgres.setUser("postgres");
  postgres.setDatabase("diaspora_production");
  postgres.constructQuery("SELECT id from posts WHERE author_id='1' AND type='StatusMessage' AND public='t';");
  postgres.constructQuery("SELECT id from users WHERE username='norayr'");

  Out.String(postgres.queryStr); Out.Ln;

  cmd := "ls -al";
  NEW(f);
  pipes.Popen(f, cmd, 'r');
  REPEAT
    pipes.ReadLine(f, out);
    Out.String(out); Out.Ln;
    Out.Ln
  UNTIL f.eof;

  (*
  REPEAT
    pipes.Read(f, ch);
    Out.Char(ch); Out.Ln;
  UNTIL f.eof;
  *)
END test0;

BEGIN
  test0;
END tests.
