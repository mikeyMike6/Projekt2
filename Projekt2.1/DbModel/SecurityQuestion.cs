using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Projekt2._1.DbModel
{
    public class SecurityQuestion
    {
        public int id_pytania { get; set; }
        public string pytanie { get; set; }

        public override string ToString()
        {
            return id_pytania + ". " + pytanie;
        }
    }
}
