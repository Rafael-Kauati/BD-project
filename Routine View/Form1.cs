using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace projeto_bd
{
    public partial class Form1 : Form
    {
        private SqlConnection cn;
        private string connectionString = "data source=.\\;integrated security=true;initial catalog=Routine View";

        public Form1()
        {
            InitializeComponent();
            cn = new SqlConnection(connectionString);
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            cn.Open();
        }

        private void LoginBtn_click(object sender, EventArgs e)
        {
            string email = EmailBox.Text;
            string password = PasswordBox.Text;

            if (VerifyLogin(email, password))
            {
                MessageBox.Show("Login successful!");
            }
            else
            {
                MessageBox.Show("Invalid email or password!");
            }
        }

        private bool VerifyLogin(string email, string password)
        {
            string query = "SELECT COUNT(*) FROM [User] WHERE Email = @Email AND Password = @Password";
            using (SqlCommand cmd = new SqlCommand(query, cn))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password);
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            cn.Close();
        }
    }
}
