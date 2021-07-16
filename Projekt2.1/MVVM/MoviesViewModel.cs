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
        private List<Movies> movies;

        public List<Movies> Movies
        {
            get { return movies; }
            set { movies = value; }
        }

        public MoviesViewModel()
        {

            var db = new DbCommands();
            this.movies = db.GetAllMovies();
            MovieVM = new MovieViewModel();

            MovieViewCommand = new RelayCommand(o =>
            {
                CurrentView = MovieVM;
            });
        }
        public RelayCommand MovieViewCommand { get; set; }
        public MovieViewModel MovieVM { get; set; }
        private object _currentView;
        public object CurrentView
        {
            get { return _currentView; }
            set
            {
                _currentView = value;
                OnPropertyChanged();
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
    }
}
