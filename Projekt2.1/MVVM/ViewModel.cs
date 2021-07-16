using Projekt2._1.HelperModels;
using Projekt2._1.MVVM;
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
    public class ViewModelClass : INotifyPropertyChanged
    {
        public ViewModelClass()
        {
            HomeVM = new HomeViewModel();
            SettingsVM = new SettingsViewModel();
            MyMoviesVM = new MyMoviesViewModel();
            MoviesVM = new MoviesViewModel();

            HomeViewCommand = new RelayCommand(o =>
            {
                HomeVM.User = this.User;
                CurrentView = HomeVM;
            });
            SettingsViewCommand = new RelayCommand(o =>
            {
                CurrentView = SettingsVM;
            });
            MyMoviesViewCommand = new RelayCommand(o =>
            {
                CurrentView = MyMoviesVM;
            });
            MoviesViewCommand = new RelayCommand(o =>
            {
                CurrentView = MoviesVM;
            });
        }
        public RelayCommand HomeViewCommand { get; set; }
        public RelayCommand MyMoviesViewCommand { get; set; }
        public RelayCommand MoviesViewCommand { get; set; }
        public RelayCommand SettingsViewCommand { get; set; }
        public HomeViewModel HomeVM { get; set; }
        public SettingsViewModel SettingsVM { get; set; }
        public MoviesViewModel MoviesVM { get; set; }
        public MyMoviesViewModel MyMoviesVM { get; set; }

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

        private User user;
        public User User
        {
            get { return user; }
            set { user = value; }
        }
        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
        public void UserLogin(int _userID)
        {
            var db = new DbCommands();
            this.User = db.GetUserById(_userID);
        }
    }
}
