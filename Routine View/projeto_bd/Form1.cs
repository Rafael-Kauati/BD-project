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
using WindowsFormsApp;
using Microsoft.VisualBasic.ApplicationServices;

namespace projeto_bd
{
    public partial class Form1 : Form
    {
        private SqlConnection cn;
        private string connectionString = "data source=.\\SQLEXPRESS;integrated security = true; initial catalog = Routine View";
        private Form2 form2;

        public Form2 Form2Instance
        {
            get { return form2; }
        }



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
            const bool boolinha = true;

            if (VerifyLogin(email,password))
            {
                //MessageBox.Show("Login successful!");
                int userid;
                string connectionString = "data source=.\\SQLEXPRESS;integrated security=true;initial catalog=Routine View";
                string query = "SELECT ID FROM [User] WHERE Password = @pass AND Email = @email";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@pass", password);
                        command.Parameters.AddWithValue("@email", email);

                        userid = (int)command.ExecuteScalar();
                        //userid = 10;
                    }
                }

                // Agora você tem o ID armazenado na variável 'userid' e pode utilizá-lo conforme necessário.



                // Abrir o Form2
                if (form2 == null || form2.IsDisposed)
                {
                    this.Hide();
                    form2 = new Form2(userid);
                    form2.Show();
                }
                else
                {
                    form2.BringToFront();
                }
            }
            else
            {
                MessageBox.Show("Invalid email or password!");
            }
        }

        private bool VerifyLogin(string email, string password)
        {
            int confirmation = 0;
            string query = "checkLogIn"; // Nome do procedimento armazenado
            using (SqlCommand cmd = new SqlCommand(query, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                // Parâmetros de entrada
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@password", password);

                // Parâmetro de saída
                SqlParameter confirmationParam = new SqlParameter("@confirmation", SqlDbType.Int);
                confirmationParam.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(confirmationParam);

                cmd.ExecuteNonQuery();

                // Obtém o valor de confirmação do parâmetro de saída
                confirmation = (int)confirmationParam.Value;

                // Retorna true se o login for verificado com sucesso (confirmation = 1)
                return confirmation == 1;
            }
        }
        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            cn.Close();
        }
    }
}
