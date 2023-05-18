using System.Data.SqlClient;
/*
private void TestDBConnection(string dbServer, string dbName, string userName, string userPass)
{
    SqlConnection cn = new SqlConnection("Data Source = " + dbServer + " ;" +
    "Initial Catalog = " + dbName + "; uid = " + userName + ";" +
    "password = " + userPass);
    try
    {
        cn.Open();
        if (cn.State == ConnectionState.Open)
            MsgBox("Successful connection to database " + cn.Database +
            " on the " + cn.DataSource +
            " server", MsgBoxStyle.OkOnly, "Connection Test");
    }
    catch (Exception ex)
    {
        Interaction.MsgBox("FAILED TO OPEN CONNECTION TO DATABASE DUE TO THE FOLLOWING ERROR" +
        Constants.vbCrLf + ex.Message, MsgBoxStyle.Critical, "Connection Test");
    }
    if (cn.State == ConnectionState.Open)
        cn.Close();
}

void MsgBox(object value, object okOnly, string v)
{
    throw new NotImplementedException();
}

static void HasRows(SqlConnection connection)
{
    SqlCommand cmd = new SqlCommand(
    "SELECT CategoryID, CategoryName FROM Categories;", connection);
    connection.Open();
    SqlDataReader reader = cmd.ExecuteReader();
    if (reader.HasRows)
    {
        while (reader.Read())
        {
            Console.WriteLine("{0}\t{1}", reader.GetInt32(0), reader.GetString(1));
        }
    }
    else { Console.WriteLine("No rows found."); }
    connection.Close();
}
*/