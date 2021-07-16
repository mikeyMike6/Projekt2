using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;

namespace WpfApp9
{
    public class DapperHelper<T>
    {
        private readonly DynamicParameters Parameters = new DynamicParameters();
        public int ExecuteNonQuery(string connectionString, string commandText)
        {
            var connection = new SqlConnection(connectionString);
            return connection.ExecuteAsync(commandText, Parameters).Result;
        }
        public void AddParameter(string text1, string text2)
        {
            Parameters.Add(text1, text2);
        }
        public IEnumerable<T> ExecuteQuery(string connectionString, string commandText)
        {
            var connection = new SqlConnection(connectionString);
            var emp = connection.QueryAsync<T>(commandText, Parameters).Result.ToList();
            foreach (var e in emp)
            {
                yield return e;
            }
        }
    }
}
