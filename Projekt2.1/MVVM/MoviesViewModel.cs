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
            set { movies = value; }
        }
        public bool RentMovie(int movieId)
        {
            var db = new DbCommands();
            var discId = db.GetDiscIdForMovieWithId(movieId);
            var success = db.RentMovie(discId, User.UserID);
            if (success)
            {
                this.movies = db.GetAllMovies();
                var movies = this.Movies.Where(x => x.movieID == movieId).ToList();
                var movie = movies[0];
                var index = Movies.IndexOf(movie);
                Movies.RemoveAt(index);
                OnPropertyChanged("Movies");
                return true;
            }
            return false;
        }

        public MoviesViewModel()
        {
            var db = new DbCommands();
            this.movies = db.GetAllMovies();
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
    }
}
