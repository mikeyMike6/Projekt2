using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace Projekt2._1.ViewModel
{
    public class Movies : INotifyPropertyChanged
    {
        public int DiscId { get; set; }
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
        private int allDisc;
        public int AllDisc 
        {
            get
            {
                return allDisc;
            }
            set
            {
                allDisc = value;
                OnPropertyChanged("AllDisc");
            }
        }
        private int avaibleDisc;

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
        public int? AvaibleDisc 
        { 
            get
            {
                return avaibleDisc;
            }
            set
            {
                if (value == null) avaibleDisc = 0;
                else avaibleDisc = (int)value;
                OnPropertyChanged("AvaibleDisc");
            }
        }
        private bool canBeRent;
        public bool CanBeRent
        {
            set
            {
                canBeRent = value;
                OnPropertyChanged("CanBeRent");
            }
            get
            {
                if (avaibleDisc > 0) return true;
                else return false;
            }
        }
        public string Visiblity
        {
            get
            {
                if (CanBeRent) return "Visible";
                return "Hidden";
            }
        }
        private DateTime rentDate;
        public DateTime RentData 
        { 
            get
            {
                return rentDate;
            }
            set
            {
                rentDate = value;
            }
        }
        private DateTime returnData;
        public DateTime ReturnData
        {

            get
            {
                return returnData;
            }
            set
            {
                returnData = value;
            }
        }
        public string RentDataString 
        {
            get
            {
                return rentDate.ToString("d");
            }
        }
        public string ReturnDataSting
        {
            get
            {
                return returnData.ToString("d");
            }
        }
    }
}
