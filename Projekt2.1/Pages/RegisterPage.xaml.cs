using Caliburn.Micro;
using Projekt2._1.DbModel;
using Projekt2._1.Models;
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
using wpfNewUser.DatabaseOperation;

namespace Projekt2._1.Pages
{
    /// <summary>
    /// Logika interakcji dla klasy RegisterPage.xaml
    /// </summary>
    public partial class RegisterPage : Page
    {
        public RegisterModelClass RegisterUser { get; set; } = new RegisterModelClass();
        public RegisterPage()
        {
            InitializeComponent();

            this.DataContext = RegisterUser;
            
        }
        private void RegisterButton_Click(object sender, RoutedEventArgs e)
        {
            var successfullReg = RegisterUser.Registration();
            if (successfullReg) this.NavigationService.Navigate(new LoginPage());
        }

        private void logInButton_Click(object sender, RoutedEventArgs e)
        {
            this.NavigationService.Navigate(new LoginPage());
        }

        private void QuestionsComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (QuestionsComboBox.SelectedItem == null) return;
            var q = (SecurityQuestion)QuestionsComboBox.SelectedItem;;
            RegisterUser.Question = q;
        }
    }
}
