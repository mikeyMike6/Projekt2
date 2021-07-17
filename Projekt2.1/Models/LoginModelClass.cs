using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using wpfNewUser.DatabaseOperation;

namespace Projekt2._1.Models
{
    public class LoginModelClass : INotifyPropertyChanged, IDataErrorInfo
    {
        public Dictionary<string, string> ErrorCollection { get; private set; } = new Dictionary<string, string>();

        private string login;
        private string password;
        public virtual string Login
        {
            get { return login; }
            set 
            { 
                login = value;
                OnPropertyChanged("Login");
            }
        }

        public virtual string Password
        {
            get { return password; }
            set 
            { 
                password = value;
                OnPropertyChanged("Password");
                OnPropertyChanged("RepeatedPassword");
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
        public string Error => throw new NotImplementedException();

        public virtual string this[string columnName]
        {
            get
            {
                string result = null;

                switch(columnName)
                {
                    case "Login":
                        result = this.LoginValidation();
                        break;
                    case "Password":
                        result = this.PasswordValidation();
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
        public virtual bool IsValid()
        {
            var loginValid = this.LoginValidation();
            var passValid = this.PasswordValidation();

            var result = loginValid == null && passValid == null;
            return result;
        }

        protected virtual string PasswordValidation()
        {
            string result = null;

            if (string.IsNullOrEmpty(this.Password))
                result = "Hasło";
            else if (Password.Length < 3)
                result = "Za krótkie";
            else if (Password.Length > 20)
                result = "Za długie";
            return result;
        }

        public virtual string LoginValidation()
        {
            string result = null;

            if (string.IsNullOrEmpty(this.Login))
                result = "Login";
            else if (Login.Length > 20)
                result = "Za długi";
            else if (Login.Length < 3)
                result = "Za krótki";
            return result;
        }

        public bool LogIn()
        {
            if(this.IsValid())
            {
                DbCommands db = new DbCommands();

                var loginResponse = db.LogIn(Login, Password);
                if(loginResponse == null)
                {
                    return false;
                }
                if(!(bool)loginResponse)
                {
                    return false;
                }
                if ((bool)loginResponse)
                {
                    return true;
                }

            }
            return false;
        }
        public int GetUserId()
        {
            var db = new DbCommands();
            return db.GetUserID(Login);
        }
    }
}
