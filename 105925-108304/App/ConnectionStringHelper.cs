using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Routine_View_Forms
{
    public static class ConnectionStringHelper
    {
        //inserir no ID= o id do utilizador/owner 
        //inserir no Password= a palavra do utilizador/owner 
        public static string ConnectionString { get; } = "Data Source=mednat.ieeta.pt,8101;Initial Catalog=p10g6;User ID=p10g6;Password=Bd2504!;";
    }

}
