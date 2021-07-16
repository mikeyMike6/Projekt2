using Caliburn.Micro;
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
    public class RegisterModelClass : LoginModelClass
    {
        public RegisterModelClass()
        {
            DbCommands db = new DbCommands();
            Questions = new BindableCollection<SecurityQuestion>(db.GetSecurityQuestions());
        }
        public BindableCollection<SecurityQuestion> Questions { get; set; }
        private string firstName;
        private string lastName;
        private string repeatedPassword;
        private string answer;
        private SecurityQuestion question;

        public virtual SecurityQuestion Question
        {
            get { return question; }
            set 
            {
                question = value;
                OnPropertyChanged("Question");
            }
        }

        public virtual string Answer
        {
            get { return answer; }
            set 
            {
                answer = value;
                OnPropertyChanged("Answer");
            }
        }


        public string RepeatedPassword
        {
            get { return repeatedPassword; }
            set 
            {
                repeatedPassword = value;
                OnPropertyChanged("RepeatedPassword");
                OnPropertyChanged("Password");
            }
        }


        public string LastName
        {
            get { return lastName; }
            set 
            {
                lastName = value;
                OnPropertyChanged("LastName");
            }
        }

        public string FirstName
        {
            get { return firstName; }
            set 
            {
                firstName = value;
                OnPropertyChanged("FirstName");
            }
        }
        public override string this[string columnName]
        {
            get
            {
                string result = null;

                switch (columnName)
                {
                    case "Login":
                        result = this.LoginValidation();
                        break;
                    case "Password":
                        result = this.PasswordValidation();
                        break;
                    case "RepeatedPassword":
                        result = this.RepeatedPasswordValidation();
                        break;
                    case "FirstName":
                        result = this.FirstNameValidation();
                        break;
                    case "LastName":
                        result = this.LastNameValidation();
                        break;
                    case "Answer":
                        result = this.AnswerValidation();
                        break;
                    case "Question":
                        result = this.QuestionValidation();
                        break;
                    default:
                        break;
                }
                if (ErrorCollection.ContainsKey(columnName))
                {
                    ErrorCollection[columnName] = result;
                }
                else if (result != null)
                    ErrorCollection.Add(columnName, result);

                OnPropertyChanged("ErrorCollection");
                return result;
            }
        }

        public virtual string QuestionValidation()
        {
            string result = null;

            if (Question == null)
                result = "Musisz wybrać pytanie";

            return result;
        }

        public virtual string AnswerValidation()
        {
            string result = null;

            if (string.IsNullOrEmpty(this.Answer))
                result = "Musisz odpowiedzieć na pytanie";

            return result;
        }

        public virtual string RepeatedPasswordValidation()
        {
            string result = null;

            if (string.IsNullOrEmpty(this.RepeatedPassword))
                result = "Powtórz hasło dla pewności";
            else if (RepeatedPassword != Password)
                result = "Hasła są różne";

            return result;
        }

        private string FirstNameValidation()
        {
            string result = null;

            if (string.IsNullOrEmpty(this.FirstName))
                result = "Wprowadź swoje imię";
            else if (FirstName.Length < 3)
                result = "Wprowadzone imię jest zbyt krótkie";
            else if (FirstName.Length > 20)
                result = "Wprowadzone imię jest zbyt długie";
            return result;
        }

        private string LastNameValidation()
        {
            string result = null;

            if (string.IsNullOrEmpty(this.LastName))
                result = "Wprowadź swoje nazwisko";
            else if (LastName.Length < 3)
                result = "Wprowadzone nazwisko jest zbyt krótkie";
            else if (LastName.Length > 20)
                result = "Wprowadzone nazwisko jest zbyt długie";
            return result;
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
                result = "Istnieje już użytkownik o takiej nazwie";
            return result;
        }
        public override bool IsValid()
        {
            var loginValid = this.LoginValidation();
            var passValid = this.PasswordValidation();
            var firstNameValid = this.FirstNameValidation();
            var lastNameValid = this.LastNameValidation();
            var repeatedPassValid = this.RepeatedPasswordValidation();
            var answerValid = this.AnswerValidation();
            var questionValid = this.QuestionValidation();

            var result = loginValid == null && 
                passValid == null &&
                firstNameValid == null &&
                lastNameValid == null &&
                repeatedPassValid == null &&
                answerValid == null &&
                questionValid == null;
            return result;
        }

        public bool Registration()
        {
            if (this.IsValid())
            {
                DbCommands dbCommands = new DbCommands();

                var userExist = dbCommands.SearchIfUserExist(Login);

                if (!userExist)
                {
                    var successRegister = dbCommands.Register(FirstName, LastName, Login, Password, Answer, Question.id_pytania);
                    if (!successRegister) return false;
                }
                return true;
            }
            return false;
        }
    }
}
