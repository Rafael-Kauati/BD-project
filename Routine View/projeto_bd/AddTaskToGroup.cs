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
    public partial class AddTaskToGroup : Form
    {
        private static string connectionString = "Data Source=mednat.ieeta.pt,8101;Initial Catalog=p10g6;User ID=p10g6;Password=Bd2504!;";

        private TaskGroup group = null;
        private string taskGroup;
        private int userid = 0;
        public string CurrtaskGroup;

        public AddTaskToGroup(string taskGroup, TaskGroup tg)
        {
            InitializeComponent();
            this.group = tg;
            this.CurrtaskGroup = taskGroup;
        }

        private void button1_Click(object sender, EventArgs e)
        {
        }

        private void button1_Click_1(object sender, EventArgs e)
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

            string mensagem = $"Tarefa criada com sucesso\n\nTítulo: {taskTitle}\nDescrição: {description}\nPrazo: {formattedDeadline}\nImportância: {importance}";
            createTask(taskTitle,
                description,
                int.Parse(importance),
                DateTime.Parse(formattedDeadline),
                10,
                CurrtaskGroup);
            group.getTaskFromGroup(CurrtaskGroup, "ToDo");
            group.getTaskFromGroup(CurrtaskGroup, "Done");

        }

        public static void createTask(string title, string description, int importance, DateTime deadline, int userID, string taskGroup)
        {

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string query = "INSERT INTO [Task] (Title, [Description], Importance, Deadline, [UserID]) VALUES (@title, @description, @Imp, @deadline, @userid)";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@title", title);
                command.Parameters.AddWithValue("@description", description);
                command.Parameters.AddWithValue("@Imp", importance);
                command.Parameters.AddWithValue("@deadline", deadline);
                command.Parameters.AddWithValue("@userid", userID);
                command.ExecuteNonQuery();

                using (SqlCommand command2 = new SqlCommand("addTaskToGroup", connection))
                {
                    command2.CommandType = CommandType.StoredProcedure;
                    command2.Parameters.AddWithValue("@TaskTitle", title);
                    command2.Parameters.AddWithValue("@TaskGroupTitle", taskGroup);
                    command2.ExecuteNonQuery();
                }

            }
        }
    }
}
