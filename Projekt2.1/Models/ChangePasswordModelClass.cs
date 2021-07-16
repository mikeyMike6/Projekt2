using Projekt2._1.DbModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using wpfNewUser.DatabaseOperation;

namespace Projekt2._1.Models
{
    public class ChangePasswordModelClass : RegisterModelClass
    {

        private int clientID;
        private SecurityQuestion question;
        private string enteredAnswer;

        public string EnteredAnswer
        {
            get { return enteredAnswer; }
            set 
            {
                enteredAnswer = value;
                OnPropertyChanged("EnteredAnswer");
            }
        }

        public override SecurityQuestion Question
        {
            get 
            {
                return question; 
            }
            set
            {
                question = value;
                OnPropertyChanged("Question");
            }
        }

        public int ClientID
        {
            get { return clientID; }
            set { clientID = value; }
        }
        private QuestionAndAnswerModel answer;

        public new QuestionAndAnswerModel Answer
        {
            get { return answer; }
            set { answer = value; }
        }


        public ChangePasswordModelClass()
        {
        }

        private void GetUserData()
        {
            var db = new DbCommands();

            int? userIDnull = db.GetUserID(this.Login);
            if(userIDnull != null)
            {
                ClientID = (int)userIDnull;
                this.Answer = db.GetUserSecurityAnswer(ClientID);
                int questionID;
                if (Answer != null)
                {
                    questionID = Answer.id_pytania;
                }
                else
                {
                    questionID = 1;
                }
                this.Question = db.GetUserSecurityQuestion(questionID);
                    
            }
            else
            {
                ClientID = -1;
            }
        }
        public override string LoginValidation()
        {
            DbCommands dbCommands = new DbCommands();

            string result = null;

            if (string.IsNullOrEmpty(this.Login))
                result = "Wprowadź nazwę swojego konta";
            else if (Login.Length > 20)
                result = "Wprowadzona nazwa użytkownika jest zbyt długa";
            else if (Login.Length < 3)
                result = "Wprowadzona nazwa użytkownika jest za krótka";
            else if (dbCommands.SearchIfUserExist(Login))
                GetUserData();
            else
                Question = null;
            return result;
        }
        public override string AnswerValidation()
        {
            string result = null;

            if (string.IsNullOrEmpty(this.EnteredAnswer))
                result = "Musisz odpowiedzieć na pytanie";
            else if (EnteredAnswer.ToLower() != Answer.odpowiedz.ToLower())
                result = "Nieprawidłowa odpowiedz";
            return result;
        }
        public override bool IsValid()
        {
            var loginValid = this.LoginValidation();
            var passValid = this.PasswordValidation();
            var repeatedPassValid = this.RepeatedPasswordValidation();
            var answerValid = this.AnswerValidation();
            var questionValid = this.QuestionValidation();

            var result = loginValid == null &&
                passValid == null &&
                repeatedPassValid == null &&
                answerValid == null &&
                questionValid == null;
            return result;
        }
        public bool ChangePassword()
        {
            if (this.IsValid())
            {
                var db = new DbCommands();
                if (db.ChangePassword(ClientID, Password)) return true;
            }
            return false;
        }
    }
}
