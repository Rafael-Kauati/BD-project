using projeto_bd;
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

namespace projeto_bd
{
    public partial class Form3 : Form
    {
       

        public int usrid = 0;
        private Form2 form2; // Variável para armazenar a referência do Form2
        private object userid1;

        public Form3(Form2 form2, int userid)
                {
                    this.form2 = form2; // Armazena a referência recebida no construtor
                    this.usrid = userid;
                    InitializeComponent();

                }

        
        private void button1_Click(object sender, EventArgs e)
        {
            string taskTitle = textBox1.Text;
            string description = textBox2.Text;
            DateTime deadline = dateTimePicker1.Value;

            string formattedDeadline = deadline.ToString("yyyy-MM-dd HH:mm:ss");

            string importance = string.Empty;

            if (radioButton1.Checked)
                importance = "1";
            else if (radioButton2.Checked)
                importance = "2";
            else if (radioButton3.Checked)
                importance = "3";
            else if (radioButton4.Checked)
                importance = "4";
            else if (radioButton5.Checked)
                importance = "5";

            // Faça o que precisar com os valores obtidos das caixas de texto, do DateTimePicker e do radio input
            // Por exemplo, você pode exibi-los em uma caixa de mensagem:
            string mensagem = $"Tarefa criada com sucesso\n\nTítulo: {taskTitle}\nDescrição: {description}\nPrazo: {formattedDeadline}\nImportância: {importance}";
            createTask(taskTitle, 
                description, 
                int.Parse(importance),
                DateTime.Parse(formattedDeadline), 
                10);

            form2.LoadDataFromDatabase("To do");
            form2.LoadDataFromDatabase("Doing");
            form2.LoadDataFromDatabase("Done");
            //MessageBox.Show(mensagem);

            // Ou você pode passar os valores para outra função ou realizar outras operações desejadas.
        }


        public static void createTask(string title, string description, int importance, DateTime deadline, int userID)
        {
            string connectionString = "data source=.\\SQLEXPRESS;integrated security=true;initial catalog=Routine View";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                    connection.Open();


                        string query = "INSERT INTO [Task] (Title, [Description], Importance, Deadline,   [UserID]) VALUES (@title, @description, @Imp, @deadline, @userid)";
                        SqlCommand commandd = new SqlCommand(query, connection);
                        commandd.Parameters.AddWithValue("@title", title);
                        commandd.Parameters.AddWithValue("@description", description);
                        commandd.Parameters.AddWithValue("@Imp", importance);
                        commandd.Parameters.AddWithValue("@deadline", deadline);
                        commandd.Parameters.AddWithValue("@userid", userID);
                        commandd.ExecuteNonQuery();


                    MessageBox.Show("task created executed successfully.");
               
            }
        }

    }
}