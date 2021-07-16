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

namespace Projekt2._1.MVVM.View
{
    /// <summary>
    /// Logika interakcji dla klasy MoviesView.xaml
    /// </summary>
    public partial class MoviesView : UserControl
    {
        public MoviesView()
        {
            InitializeComponent();

            var db = new DbCommands();
            this.movieList.ItemsSource = db.GetAllMovies();
        }

        private void movieList_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            
        }
    }
}
