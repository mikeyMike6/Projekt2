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

namespace Projekt2._1.Pages
{
    /// <summary>
    /// Logika interakcji dla klasy ResetPasswordPage.xaml
    /// </summary>
    public partial class ResetPasswordPage : Page
    {
        public ChangePasswordModelClass changePasswordModel { get; set; } = new ChangePasswordModelClass();
        public ResetPasswordPage()
        {
            InitializeComponent();
            this.DataContext = changePasswordModel;
        }

        private void logInButton_Click(object sender, RoutedEventArgs e)
        {
            this.NavigationService.Navigate(new LoginPage());
        }

        private void ChangePasswordButton_Click(object sender, RoutedEventArgs e)
        {
            if (changePasswordModel.ChangePassword())
            {
                WpfMessageBox.Show("", "Hasło zostało zmienione", MessageBoxButton.OK);
                this.NavigationService.Navigate(new LoginPage());
            }
            else WpfMessageBox.Show("", "Podano nieprawidłowe dane", MessageBoxButton.OK);
        }
    }
}
