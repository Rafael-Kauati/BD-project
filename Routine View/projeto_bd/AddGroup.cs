using Microsoft.VisualBasic.ApplicationServices;
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
using static System.Windows.Forms.VisualStyles.VisualStyleElement.Button;

namespace Routine_View_Forms
{
    public partial class AddGroup : Form
    {
        static string connectionString = "data source=.\\SQLEXPRESS;integrated security=true;initial catalog=Routine View";
        private int userid;
        private Form2 form2;

        public AddGroup(int userid, Form2 form2)
        {
            InitializeComponent();
            this.userid = userid;
            this.form2 = form2; 
        }
        
        private void Create_Click(object sender, EventArgs e)
        {
            string Title = title.Text;
            string desc =  description.Text;
            string type = string.Empty;

            if (importanceRadio.Checked)
                type = "Importance";
            else if (deadlineRadio.Checked)
                type = "Deadline";
            else if (categoryRadio.Checked)
                type = "Category";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand("createTaskGroup", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@title", Title);
                    command.Parameters.AddWithValue("@description", desc);
                    command.Parameters.AddWithValue("@assoc_type", type);
                    command.Parameters.AddWithValue("@userid", this.userid);

                    command.ExecuteNonQuery();


                    /*
                     * @title varchar(50),
	                    @description varchar(100),
	                    @assoc_type varchar(20),
	                    @userid int
                     */
                }

                form2.loadTaskGroups();

                MessageBox.Show("Task Group created successfully.");
            }

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

    }
}
