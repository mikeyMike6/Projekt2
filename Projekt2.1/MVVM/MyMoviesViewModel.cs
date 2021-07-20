using Projekt2._1.ViewModel;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using wpfNewUser.DatabaseOperation;

namespace Projekt2._1.ViewModel
{
    public class MyMoviesViewModel : INotifyPropertyChanged
    {
        private User user;

        public User User
        {
            get { return user; }
            set { user = value; }
        }

        private List<Movies> movies;

        public List<Movies> Movies
        {
            get { return movies; }
            set 
            { 
                movies = value;
                OnPropertyChanged("Movies");
            }
        }
        public bool Return(int movieId)
        {
            return false;
        }

        public bool ReturnMovie(int discId)
        {
            var db = new DbCommands();
            if (db.ReturnDisc(discId))
                return true;
            return false;
        }

        public MyMoviesViewModel()
        {

        }

        public void GetMovieList()
        {
            var db = new DbCommands();
            this.movies = db.GetAllMoviesOfUserWithId(User.UserID);
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
    }
}

