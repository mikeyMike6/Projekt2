using Projekt2._1.Models;
using Projekt2._1.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using wpfNewUser.DatabaseOperation;

namespace Projekt2._1.ViewModel
{
    public class SettingsViewModel : ChangePasswordModelClass
    {
        private User user;

        public User User
        {
            get { return user; }
            set { user = value; }
        }

        public void UserLogin(int _userID)
        {
            var db = new DbCommands();
            this.User = db.GetUserById(_userID);
        }

        public override bool IsValid()
        {
            var passValid = this.PasswordValidation();
            var repeatedPassValid = this.RepeatedPasswordValidation();

            var result = passValid == null &&
                repeatedPassValid == null;
            return result;
        }

        public override bool ChangePassword()
        {
            if (this.IsValid())
            {
                var db = new DbCommands();
                if (db.ChangePassword(User.UserID, Password)) return true;
            }
            return false;
        }
    }
}
