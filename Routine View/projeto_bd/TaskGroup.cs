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
using static System.Windows.Forms.AxHost;

namespace Routine_View_Forms
{
    public partial class TaskGroup : Form
    {
        static string connectionString = "data source=.\\SQLEXPRESS;integrated security=true;initial catalog=Routine View";
        private string group;
        private AddTaskToGroup adder;
        private Form2 f2;

        public AddTaskToGroup AddTaskToGroup { get { return adder; } }

        public TaskGroup(string group, Form2 fm2)
        {
            InitializeComponent();
            this.group = group;
            this.f2 = fm2;
            getTaskFromGroup(group, "ToDo");
            getTaskFromGroup(group, "Done");
        }

        public void getTaskFromGroup(string groupTitle, string state)
        {
            DataGridViewRow row = new DataGridViewRow();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // Criar o comando SQL para chamar a função getTaskGroup
                SqlCommand command = new SqlCommand("SELECT * FROM getTaskGroup(@TaskGroupTitle, @state)", connection);

                // Definir o valor do parâmetro @TaskGroupTitle
                command.Parameters.AddWithValue("@TaskGroupTitle", groupTitle);
                command.Parameters.AddWithValue("@state", state);

                // Criar um DataTable para armazenar os resultados da função
                DataTable dataTable = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter(command);


                adapter.Fill(dataTable);

                if (state == "ToDo")
                {
                    dataGridView1.DataSource = dataTable;
                }
                else if (state == "Done")
                {
                    dataGridView2.DataSource = dataTable;
                }
            }
        }
        
        private void button2_Click(object sender, EventArgs e)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand commandd = new SqlCommand("finishGroupTask", connection))
                {
                    commandd.CommandType = CommandType.StoredProcedure; 

                    commandd.Parameters.AddWithValue("@taskGroup", group);

                    commandd.ExecuteNonQuery();
                }

            }
            f2.loadTaskGroups();
            getTaskFromGroup(this.group, "ToDo");
            getTaskFromGroup(this.group, "Done");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();


                using (SqlCommand commandd = new SqlCommand("concludeTaskOfTheGroup", connection))
                {
                    commandd.CommandType = CommandType.StoredProcedure;
                    DataGridViewRow selectedRow = dataGridView1.SelectedRows[0];


                    commandd.Parameters.AddWithValue("@TaskTitle", selectedRow.Cells["TaskTitle"].Value.ToString());

                    commandd.ExecuteNonQuery();
                }

            }
            getTaskFromGroup(this.group, "ToDo");
            getTaskFromGroup(this.group, "Done");
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (adder == null || adder.IsDisposed)
            {

                adder = new AddTaskToGroup(group, this);
                adder.Show();
            }
            else
            {
                adder.WindowState = FormWindowState.Normal;
                adder.Focus();
            }

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        
    }
}
