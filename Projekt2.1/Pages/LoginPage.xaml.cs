using Projekt2._1.Models;
using Projekt2._1.Pages;
using Projekt2._1.Pages.UserPages;
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

namespace Projekt2._1
{
    public partial class LoginPage : Page
    {
        public bool SuccesfulLogin { get; set; }
        public LoginModelClass LoginUser { get; set; } = new LoginModelClass();
        public LoginPage()
        {
            InitializeComponent();

            this.DataContext = LoginUser;
        }

        private void registerButton_Click(object sender, RoutedEventArgs e)
        {
            this.NavigationService.Navigate(new RegisterPage());
        }

        private void LoginButton_Click(object sender, RoutedEventArgs e)
        {
            SuccesfulLogin = LoginUser.LogIn();
            if (!SuccesfulLogin) InfoLabel.Content = "Spróbuj ponownie";
            else this.NavigationService.Navigate(new Homepage(LoginUser.GetUserId()));
        }

        private void resetPasswordButton_Click(object sender, RoutedEventArgs e)
        {
            this.NavigationService.Navigate(new ResetPasswordPage());
        }
    }
}
