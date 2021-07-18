using Projekt2._1.DbModel;
using Projekt2._1.ViewModel;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using WpfApp9;

namespace wpfNewUser.DatabaseOperation
{
    public class DbCommands
    {

        private string DefaultLanguage = ConfigurationManager.AppSettings.Get("DefaultLanguage");
        private string ConnectionString = ConfigurationManager.ConnectionStrings["AppConnectionString"].ConnectionString;
        public bool Register(string firstName, string lastName, string login, string password, string answer, int questionID)
        {
            var command = "DECLARE	@responseMessage BIT " +

            "EXEC dbo.dodajUzytkownika " +
            "@pLogin = @login, " +
            "@pPassword = @pass, " +
            "@pFirstName = @first, " +
            "@pLastName = @last, " +
            "@pQuestion = @question, " +
            "@pResponse = @response, " +
            "@responseMessage = @responseMessage OUTPUT " +
            "SELECT  @responseMessage as 'responseMessage'";
            var dHelper = new DapperHelper<DbResponse>();
            dHelper.AddParameter("login", login);
            dHelper.AddParameter("pass", password);
            dHelper.AddParameter("first", firstName);
            dHelper.AddParameter("last", lastName);
            dHelper.AddParameter("response", answer);
            dHelper.AddParameter("question", questionID.ToString());

            var logIn = dHelper.ExecuteQuery(ConnectionString, command).ToList()[0];
            if ((bool)logIn.responseMessage)
                return true;
            return false;
        }
        public bool? LogIn(string login, string password)
        {
            var command = "DECLARE	@responseMessage BIT " +

                         "EXEC dbo.LogowanieUzytkownika " +
                         "@pLoginName = @login, " +
                         "@pPassword = @pass, " +
                         "@responseMessage = @responseMessage OUTPUT " +
                         "SELECT  @responseMessage as 'responseMessage'";
            var dHelper = new DapperHelper<DbResponse>();
            dHelper.AddParameter("login", login);
            dHelper.AddParameter("pass", password);

            var logIn = dHelper.ExecuteQuery(ConnectionString, command).ToList()[0];
            return logIn.responseMessage;
        }
        public bool SearchIfUserExist(string login)
        {
            var command = "SELECT id_klienta, LoginName FROM Uzytkownicy WHERE LoginName = @login";

            var dbHelper = new DapperHelper<UserDbModel>();
            dbHelper.AddParameter("login", login);

            var user = dbHelper.ExecuteQuery(ConnectionString, command).ToList();
            if (user.Count > 0)
                return true;
            return false;
        }
        public List<SecurityQuestion> GetSecurityQuestions()
        {
            var command = "SELECT * FROM PytaniaWeryfikujace";

            var dbHelper = new DapperHelper<SecurityQuestion>();
            return dbHelper.ExecuteQuery(ConnectionString, command).ToList();
        }
        public QuestionAndAnswerModel GetUserSecurityAnswer(int clientID)
        {
            var command = "SELECT * FROM PytaniaIOdpowiedzi WHERE id_klienta = @id ";

            var db = new DapperHelper<QuestionAndAnswerModel>();
            db.AddParameter("id", clientID.ToString());
            var tmp = db.ExecuteQuery(ConnectionString, command).ToList();
            if (tmp.Count < 1) return null;
            else return tmp[0];
        }
        public SecurityQuestion GetUserSecurityQuestion(int questionID)
        {
            var command = "SELECT * FROM PytaniaWeryfikujace WHERE id_pytania = @id ";

            var db = new DapperHelper<SecurityQuestion>();
            db.AddParameter("id", questionID.ToString());
            return db.ExecuteQuery(ConnectionString, command).ToList()[0];
        }
        public int GetUserID(string login)
        {
            var command = "SELECT * FROM Uzytkownicy WHERE LoginName = @login ";

            var db = new DapperHelper<UserDbModel>();
            db.AddParameter("login", login);

            return db.ExecuteQuery(ConnectionString, command).ToList()[0].id_klienta;
        }
        public bool ChangePassword(int clientID, string password)
        {
            var command = "UPDATE dbo.Uzytkownicy " +
                          "SET PasswordHash = HASHBYTES('SHA2_512', @pPassword) " +
                          "WHERE id_klienta = @id ";

            var db = new DapperHelper<UserDbModel>();
            db.AddParameter("id", clientID.ToString());
            db.AddParameter("pPassword", password);
            var rows = db.ExecuteNonQuery(ConnectionString, command);
            if (rows > 0) return true;
            return false;
        }
        public User GetUserById(int userID)
        {
            var command = "select u.id_klienta UserID, LoginName LoginName, Imie FirstName, Nazwisko LastName " +
                "from Uzytkownicy u join Klienci k on u.id_klienta = k.id_klienta " +
                "where u.id_klienta = @id";

            var db = new DapperHelper<User>();
            db.AddParameter("id", userID.ToString());
            return db.ExecuteQuery(ConnectionString, command).ToList()[0];
        }
        public List<Movies> GetAllMovies()
        {
            var command = "select tab.id_filmu movieID, f.Tytul_filmu Title, sf.Gatunek Genre, " +
                "sf.Kraj_produkcji Country, sf.Jezyk Language, sf.Czas_trwania Time, " +
                " sf.Wytwornia Company, sf.Budzet Budget, pf.Plakat Poster, sf.Sequel Sequel, " +
                "sf.Prequel Prequel, tab.wszystkie AllDisc, tab.dostepne AvaibleDisc from Szczegoly_Filmu " +
                "SF join ((select tab1.id_filmu, tab1.wszystkie, tab2.dostepne from (select F.id_filmu, " +
                "count(id_plyty) wszystkie  from Filmy F left join plyty P on P.id_filmu = F.id_filmu group" +
                " by f.id_filmu) as tab1 left join (select F.id_filmu, count(id_plyty) dostepne  from Filmy F " +
                "left join plyty P on P.id_filmu = F.id_filmu where p.Status = 1 group by f.id_filmu) " +
                "as tab2 on tab1.id_filmu = tab2.id_filmu)) as tab on SF.id_filmu = tab.id_filmu join" +
                " filmy f on f.id_filmu = sf.id_filmu join PlakatyFilmowe pf on pf.id_filmu = sf.id_filmu";

            var db = new DapperHelper<Movies>();
            return db.ExecuteQuery(ConnectionString, command).ToList();
        }
        public bool RentMovie(int discId, int clientId)
        {
            var command = "insert into Wypozyczenia values (@discId, @clientId, getdate(), null) ";

            var db = new DapperHelper<Movies>();
            db.AddParameter("discId", discId.ToString());
            db.AddParameter("clientId", clientId.ToString());

            var tmp = db.ExecuteNonQuery(ConnectionString, command);
            if (tmp < 1)
                return false;
            return true;
        }

        public int GetDiscIdForMovieWithId(int movieId)
        {
            var command = "select top 1 p.id_plyty DiscId, p.id_filmu " +
                "MovieId from Plyty p join Filmy f on p.id_filmu = f.id_filmu " +
                "where p.id_filmu=@id and status = 1";

            var db = new DapperHelper<DiscDb>();
            db.AddParameter("id", movieId.ToString());

            return db.ExecuteQuery(ConnectionString, command).ToList()[0].DiscId;
        }

        public List<Movies> GetAllMoviesOfUserWithId(int clientId)
        {
            var command = "select p.id_plyty DiscId, f.id_filmu movieId, f.Tytul_filmu Title, " +
                " pf.Plakat Poster, " +
                " w.Data_wypozyczenia RentData, w.Data_zwrotu ReturnData from Klienci k " +
                " join Wypozyczenia w on k.id_klienta=w.id_klienta " +
                " join Plyty p on p.id_plyty=w.id_plyty " +
                " join Filmy f on f.id_filmu=p.id_filmu " +
                " join Szczegoly_Filmu sf on sf.id_filmu = f.id_filmu " +
                " join PlakatyFilmowe pf on pf.id_filmu = f.id_filmu " +
                " where w.id_klienta = @id";

            var db = new DapperHelper<Movies>();
            db.AddParameter("id", clientId.ToString());

            return db.ExecuteQuery(ConnectionString, command).ToList();
        }
    }
}
