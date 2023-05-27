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
        public Form3()
        {
            InitializeComponent();
           
        }
        private void button1_Click(object sender, EventArgs e)
        {
            this.Hide();
            MessageBox.Show("Tarefa criada com sucesso");
        }

        private void label2_Click(object sender, EventArgs e)
        {
            // Nenhuma implementação necessária aqui, pode ser deixado vazio
        }
    }
}