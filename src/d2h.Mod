MODULE d2h;
IMPORT Out,
       postgres;




BEGIN
  postgres.setUser("postgres");
  postgres.setDatabase("diaspora_production");
  postgres.constructQuery("SELECT id from posts WHERE author_id='1' AND type='StatusMessage' AND public='t';");

  Out.String(postgres.query); Out.Ln;

END d2h.
