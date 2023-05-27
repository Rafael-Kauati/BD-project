using projeto_bd;
using System;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Data;


namespace WindowsFormsApp
{
    public partial class Form2 : Form
    {
        private Form3 form3;
        public Form3 Form3Instance
        {
            get { return form3; }
        }
        public Form2()
        {
            InitializeComponent();
            LoadDataFromDatabase("To do");
            LoadDataFromDatabase("Doing");
            LoadDataFromDatabase("Done");
        }

        private void Form2_Load(object sender, EventArgs e)
        {

        }

        private void LoadDataFromDatabase(string stackName)
        {
            string connectionString = "data source=.\\;integrated security=true;initial catalog=Routine View";
            string query = "SELECT * FROM GetAllTasksInStack(@stackName)";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Parâmetro da função
                    command.Parameters.AddWithValue("@stackName", stackName);

                    // Crie um SqlDataAdapter e um DataTable
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();

                    // Preencha o DataTable com os resultados da consulta
                    adapter.Fill(dataTable);

                    // Atribua o DataTable como a fonte de dados da dataGridView1
                    if (stackName == "To do") { dataGridView1.DataSource = dataTable; }
                    else if (stackName == "Doing") { dataGridView2.DataSource = dataTable; }
                    else if (stackName == "Done") { dataGridView3.DataSource = dataTable; }

                }
            }
        }




        private void button1_Click(object sender, EventArgs e)
        {
            if (form3 == null || form3.IsDisposed)
            {

                form3 = new Form3();
                form3.Show();
            }
            else
            {
                form3.WindowState = FormWindowState.Normal;
                form3.Focus();
            }
        }

        private void dataGridView2_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void dataGridView3_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void Form2_Load_1(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            // Verificar se há alguma linha selecionada na tabela "TO DO"
            if (dataGridView1.SelectedRows.Count > 0)
            {
                // Obter a linha selecionada
                DataGridViewRow selectedRow = dataGridView1.SelectedRows[0];

                // Mover a linha selecionada da tabela "TO DO" para a tabela "DOING"
                dataGridView1.Rows.Remove(selectedRow);
                dataGridView2.Rows.Add(selectedRow);
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            // Verificar se há alguma linha selecionada na tabela "DOING"
            if (dataGridView2.SelectedRows.Count > 0)
            {
                // Obter a linha selecionada
                DataGridViewRow selectedRow = dataGridView2.SelectedRows[0];

                // Obter o valor do título da tarefa na coluna desejada
                string taskName = selectedRow.Cells["TaskTitle"].Value.ToString();

                // Chamar a procedure "concludeTask" passando o nome da tarefa como parâmetro
                ConcludeTask(taskName);
                dataGridView2.Refresh();
                dataGridView3.Refresh();

         
            }
        }

        private void ConcludeTask(string taskName)
        {
            string connectionString = "data source=.\\;integrated security=true;initial catalog=Routine View";
            string query = "concludeTask";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    // Parâmetro da procedure
                    command.Parameters.AddWithValue("@taskname", taskName);

                    command.ExecuteNonQuery();
                }
            }
        }


        // Outros métodos e eventos do formulário
    }
}
