using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using WindowsFormsApp;

namespace Routine_View_Forms
{
    public partial class Form4 : Form
    {
        private Form2 form2 = null;
        static string connectionString = "data source=.\\SQLEXPRESS;integrated security=true;initial catalog=Routine View";
        private int userid = 0;
        private string tasktitle;
        public Form4(int userid, string tasktitle,Form2 form2)
        {
            InitializeComponent();
            this.userid = userid;
            this.tasktitle = tasktitle;
            this.form2 = form2;
        }


        //Update Task :
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
            //string mensagem = $"Tarefa criada com sucesso\n\nTítulo: {taskTitle}\nDescrição: {description}\nPrazo: {formattedDeadline}\nImportância: {importance}";
            updateTask(taskTitle,
               description,
               int.Parse(importance),
               DateTime.Parse(formattedDeadline),
               userid);

        }

        private void updateTask(string title, string description, int importance, DateTime deadline, int userID)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string query = @"UPDATE [Task]
                        SET Title = @title,
                            [Description] = @description,
                            Importance = @imp,
                            Deadline = @deadline
                        WHERE UserID = @UserID AND Title = @Currtitle";

                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@title", title);
                command.Parameters.AddWithValue("@description", description);
                command.Parameters.AddWithValue("@imp", importance);
                command.Parameters.AddWithValue("@deadline", deadline);
                command.Parameters.AddWithValue("@UserID", userID);
                command.Parameters.AddWithValue("@Currtitle", tasktitle);

                command.ExecuteNonQuery();

                MessageBox.Show("Task update executed successfully.");
            }

            form2.LoadDataFromDatabase("To do");
            form2.LoadDataFromDatabase("Doing");
            form2.LoadDataFromDatabase("Done");

            this.Close();
        }


        private void Form4_Load(object sender, EventArgs e)
        {

        }

        
    }
}
