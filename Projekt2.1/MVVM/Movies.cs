using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Projekt2._1.ViewModel
{
    public class Movies
    {
        public int movieID { get; set; }
        public string Title { get; set; }
        public string Genre { get; set; }
        public string Country { get; set; }
        public string Language { get; set; }
        public int Time { get; set; }
        public string Company { get; set; }
        public double Budget { get; set; }
        public string Poster { get; set; }
        public int? Sequel { get; set; }
        public int? Prequel { get; set; }
    }
}
