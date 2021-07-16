using Projekt2._1.MVVM;
using Projekt2._1.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Projekt2._1.Pages.UserPages
{
    /// <summary>
    /// Logika interakcji dla klasy Homepage.xaml
    /// </summary>
    public partial class Homepage : Page
    {
        public ViewModelClass ViewModel { get; set; } = new ViewModelClass();
        public Homepage(int loggedUserId)
        {
            this.ViewModel.UserLogin(loggedUserId);
            this.DataContext = ViewModel;

            InitializeComponent();
        }

        private void RadioButton_Checked(object sender, RoutedEventArgs e)
        {
            this.NavigationService.Navigate(new LoginPage());
        }
    }
}
