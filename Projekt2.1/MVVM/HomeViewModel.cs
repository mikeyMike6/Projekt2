using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using wpfNewUser.DatabaseOperation;

namespace Projekt2._1.ViewModel
{
    public class HomeViewModel
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
    }
}
