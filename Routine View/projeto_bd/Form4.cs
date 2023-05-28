using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
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
        private int userid = 0;
        public Form4(int userid, Form2 form2)
        {
            InitializeComponent();
            this.userid = userid;
            this.form2 = form2;
        }

        private void Form4_Load(object sender, EventArgs e)
        {

        }
    }
}
