using Projekt2._1.HelperModels;
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
    public class MoviesViewModel : INotifyPropertyChanged
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
        public bool RentMovie(int movieId)
        {
            var db = new DbCommands();
            var discId = db.GetDiscIdForMovieWithId(movieId);
            var success = db.RentMovie(discId, User.UserID);
            if (success)
            {
                GetMovieList();

                return true;
            }
            return false;
        }

        public MoviesViewModel()
        {
            GetMovieList();
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }

        public void GetMovieList()
        {
            var db = new DbCommands();
            this.movies = db.GetAllMovies();
        }
    }
}
