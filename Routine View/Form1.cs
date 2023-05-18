using Microsoft.VisualBasic;
using System.Data;
using System.Data.SqlClient;

namespace Routine_View
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private SqlDataReader reader;
        private SqlConnection cn;
        private SqlCommand cmd;
        private int currentContact;
        private bool adding;

        private SqlConnection getSGBDConnection()
        {
            return new SqlConnection("data source=.\\SQLEXPRESS;integrated security=true;initial catalog=Routine View");
        }

        private bool verifySGBDConnection()
        {
            if (cn == null)
                cn = getSGBDConnection();

            if (cn.State != ConnectionState.Open)
                cn.Open();

            return cn.State == ConnectionState.Open;
        }

        private void LoginHandler()
        {
            if (!verifySGBDConnection())
                return;

            //MessageBox.Show("CN sucess ! (1)");

            //System.Console.WriteLine("CN sucess ! (2)");

            String content = "";
            cmd = new SqlCommand("SELECT * FROM [User]", cn);
            reader = cmd.ExecuteReader();

            while( reader.Read())
            {
                content += reader["Name"].ToString();
            }
            cn.Close();

            MessageBox.Show(content);

        }

        String Email, Password;

        private void LoginBtn_click(object sender, System.EventArgs e)
        {
            Email = EmailBox.Text;
            Password = PasswordBox.Text;
            LoginHandler();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            /**/
            cn = getSGBDConnection();
            //MessageBox.Show("CN sucess ! (1)");
            //System.Console.WriteLine("CN sucess ! (1)");
        }
    }
}