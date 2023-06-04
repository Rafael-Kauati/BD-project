using projeto_bd;
using System;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Data;
using Microsoft.VisualBasic.ApplicationServices;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.ListView;
using Routine_View_Forms;

namespace WindowsFormsApp
{

    public partial class Form2 : Form
    {
        static string connectionString = "data source=.\\SQLEXPRESS;integrated security=true;initial catalog=Routine View";
        private int userID = 0;
        private string[] taskGroupsNames;
        private string taskSelected;
        List<TaskGroupInfo> dadosList = new List<TaskGroupInfo>();


        private Form3 form3;
        private Form4 form4;
        private TaskGroup tg;

        public TaskGroup TaskGroupInstance { get { return tg; } }
        public Form3 Form3Instance
        {
            get { return form3; }
        }

        public Form4 Form4Instance
        {
            get { return form4; }
        }

        public Form2(int userID)
        {
            this.userID = userID;
            InitializeComponent();
            loadTaskGroups();
            GetUserName(userID);
            GetUserScore(userID);
            LoadDataFromDatabase("To do");
            LoadDataFromDatabase("Doing");
            LoadDataFromDatabase("Done");
        }


        public void GetUserScore(int userID)
        {
            string query = "SELECT [Score] FROM [User] where ID = @userID";
            int currUserScore = 0;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@userID", userID);
                    currUserScore = (int)command.ExecuteScalar();
                    CurrScore.Text = currUserScore.ToString();

                }
            }

        }

        public void GetUserName(int userID)
        {
            string query = "SELECT [Name] FROM [User] where ID = @userID";
            String currUserName = "";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@userID", userID);
                    currUserName = (string)command.ExecuteScalar();
                    UserName.Text = currUserName;

                }
            }

        }

        public void getTaskFromGroup(string groupTitle)
        {
            DataGridViewRow row = new DataGridViewRow();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // Criar o comando SQL para chamar a função getTaskGroup
                SqlCommand command = new SqlCommand("SELECT * FROM getTaskGroup(@TaskGroupTitle)", connection);

                // Definir o valor do parâmetro @TaskGroupTitle
                command.Parameters.AddWithValue("@TaskGroupTitle", groupTitle);

                // Criar um DataTable para armazenar os resultados da função
                DataTable dataTable = new DataTable();

                // Carregar os dados da função para o DataTable
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    adapter.Fill(dataTable);
                }

                // Definir o DataTable como a fonte de dados do DataGridView
                taskGroup.DataSource = dataTable;
            }
        }
        private void visGroup_Click(object sender, EventArgs e)
        {
            if (taskGroup.SelectedRows.Count > 0)
            {
                DataGridViewRow selectedRow = taskGroup.SelectedRows[0];
                //MessageBox.Show(selectedRow.Cells["Title"].Value.ToString());

                if (tg == null || tg.IsDisposed)
                {

                    tg = new TaskGroup(selectedRow.Cells["Title"].Value.ToString(), this);
                    tg.Show();
                }
                else
                {
                    tg.WindowState = FormWindowState.Normal;
                    tg.Focus();
                }

            }
        }

        public void loadTaskGroups()
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // Cria um SqlCommand para chamar a função getAllTaskGroups
                using (SqlCommand command = new SqlCommand("SELECT * FROM getAllTaskGroups(@userid)", connection))
                {

                    // Adiciona o parâmetro @userid ao comando
                    command.Parameters.AddWithValue("@userid", this.userID);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {

                            // Obtém os valores das colunas "Title", "Code" e "Assoc_code" da linha atual
                            TaskGroupInfo group = new TaskGroupInfo();
                            group.Title = reader.GetString(1);
                            group.Code = reader.GetInt32(0);
                            group.isFinished = reader.GetString(2);
                            group.criteria = reader.GetString(3);
                            dadosList.Add(group);

                            //taskGroupsNames = (string[])taskGroupsNames.Append(title);

                            // Faça o que desejar com os valores obtidos
                            //MessageBox.Show($"Title: {title}, Code: {code}, Assoc_code: {assocCode}");
                        }
                    }

                }
            }

            taskGroup.DataSource = dadosList;
        }



        public void LoadDataFromDatabase(string stackName)
        {
            string query = "SELECT TaskCode, TaskTitle, TaskDescription, TaskImportance, TaskDeadline FROM GetAllTasksInStack(@stackName, @userid)";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Parâmetro da função
                    command.Parameters.AddWithValue("@stackName", stackName);
                    command.Parameters.AddWithValue("@userid", userID);

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

        private void editTask_Click(object sender, EventArgs e)
        {
            if (form4 == null || form4.IsDisposed)
            {

                form4 = new Form4(this.userID , this.taskSelected, this);
                form4.Show();
            }
            else
            {
                form4.WindowState = FormWindowState.Normal;
                form4.Focus();
            }
        }

        private void dataGridView2_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dataGridView2.Rows[e.RowIndex];
                editTask.Visible = true;

                this.taskSelected = row.Cells[1].Value.ToString();
                MessageBox.Show(taskSelected.ToString());

            }
        }

        private void dataGridView3_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dataGridView3.Rows[e.RowIndex];
                editTask.Visible = true;

                this.taskSelected = row.Cells[1].Value.ToString();

            }
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dataGridView1.Rows[e.RowIndex];
                editTask.Visible = true;

                this.taskSelected = row.Cells[1].Value.ToString();
                MessageBox.Show(taskSelected.ToString());

            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (form3 == null || form3.IsDisposed)
            {

                form3 = new Form3(this, this.userID);
                form3.Show();
            }
            else
            {
                form3.WindowState = FormWindowState.Normal;
                form3.Focus();
            }
        }


        private void button2_Click(object sender, EventArgs e)
        {
            // Verificar se há alguma linha selecionada na tabela "TO DO"

            if (dataGridView1.SelectedRows.Count > 0)
            {
                // Obter a linha selecionada
                DataGridViewRow selectedRow = dataGridView1.SelectedRows[0];
                string taskName = selectedRow.Cells["TaskTitle"].Value.ToString();



                StartTask(taskName);
                GetUserName(this.userID);
                GetUserScore(this.userID);


                LoadDataFromDatabase("To do");
                LoadDataFromDatabase("Doing");
                LoadDataFromDatabase("Done");

                // Mover a linha selecionada da tabela "TO DO" para a tabela "DOING"
                //dataGridView1.Rows.Remove(selectedRow);
                //dataGridView2.Rows.Add(selectedRow);
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
                //MessageBox.Show(taskName);

                // Chamar a procedure "concludeTask" passando o nome da tarefa como parâmetro
                ConcludeTask(taskName);
                GetUserName(this.userID);
                GetUserScore(this.userID);

                LoadDataFromDatabase("To do");
                LoadDataFromDatabase("Doing");
                LoadDataFromDatabase("Done");


            }
        }

        public static void createTask(string title, string description, int importance, DateTime deadline, int userID)
        {

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand("createTask", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Parâmetros do procedimento armazenado
                        command.Parameters.AddWithValue("@Title", title);
                        command.Parameters.AddWithValue("@Description", description);
                        command.Parameters.AddWithValue("@Importance", importance);
                        command.Parameters.AddWithValue("@Deadline", deadline);
                        command.Parameters.AddWithValue("@UserID", userID);

                        command.ExecuteNonQuery();
                    }

                    Console.WriteLine("task created executed successfully.");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("An error occurred: " + ex.Message);
                }
            }
        }

        private void StartTask(string taskName)
        {

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand("startTask", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@taskname", taskName);

                    command.ExecuteNonQuery();
                }
            }
        }

        private void ConcludeTask(string taskName)
        {

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand("concludeTask", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@taskname", taskName);

                    command.ExecuteNonQuery();
                }
            }
        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void label4_Click_1(object sender, EventArgs e)
        {

        }


        private void Form2_Load(object sender, EventArgs e)
        {

        }
        private void Form2_Load_1(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void label5_Click_1(object sender, EventArgs e)
        {

        }


    }

}
