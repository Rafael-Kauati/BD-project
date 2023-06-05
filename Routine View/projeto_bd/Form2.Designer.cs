using System.Drawing;
using System.Windows.Forms;

namespace WindowsFormsApp
{
    partial class Form2
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.DataGridView dataGridView1;

        // Outras propriedades e eventos do formulário

        private void InitializeComponent()
        {
            dataGridView1 = new DataGridView();
            dataGridView2 = new DataGridView();
            dataGridView3 = new DataGridView();
            button1 = new Button();
            label1 = new Label();
            label2 = new Label();
            label3 = new Label();
            button2 = new Button();
            button3 = new Button();
            UserName = new Label();
            ScoreLabel = new Label();
            CurrScore = new Label();
            label4 = new Label();
            taskGroup = new DataGridView();
            Tasks = new Label();
            label5 = new Label();
            visGroup = new Button();
            editTask = new Button();
            creatGroup = new Button();
            ((System.ComponentModel.ISupportInitialize)dataGridView1).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dataGridView2).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dataGridView3).BeginInit();
            ((System.ComponentModel.ISupportInitialize)taskGroup).BeginInit();
            SuspendLayout();
            // 
            // dataGridView1
            // 
            dataGridView1.ColumnHeadersHeight = 29;
            dataGridView1.Location = new Point(147, 97);
            dataGridView1.Name = "dataGridView1";
            dataGridView1.RowHeadersWidth = 51;
            dataGridView1.Size = new Size(579, 184);
            dataGridView1.TabIndex = 0;
            dataGridView1.CellContentClick += dataGridView1_CellContentClick;
            // 
            // dataGridView2
            // 
            dataGridView2.ColumnHeadersHeight = 29;
            dataGridView2.Location = new Point(147, 287);
            dataGridView2.Name = "dataGridView2";
            dataGridView2.RowHeadersWidth = 51;
            dataGridView2.Size = new Size(579, 175);
            dataGridView2.TabIndex = 1;
            dataGridView2.CellContentClick += dataGridView2_CellContentClick;
            // 
            // dataGridView3
            // 
            dataGridView3.ColumnHeadersHeight = 29;
            dataGridView3.Location = new Point(144, 468);
            dataGridView3.Name = "dataGridView3";
            dataGridView3.RowHeadersWidth = 51;
            dataGridView3.Size = new Size(582, 177);
            dataGridView3.TabIndex = 2;
            dataGridView3.CellContentClick += dataGridView3_CellContentClick;
            // 
            // button1
            // 
            button1.Location = new Point(18, 12);
            button1.Name = "button1";
            button1.Size = new Size(187, 63);
            button1.TabIndex = 3;
            button1.Text = "Create new Task";
            button1.UseVisualStyleBackColor = true;
            button1.Click += button1_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(18, 188);
            label1.Name = "label1";
            label1.Size = new Size(41, 15);
            label1.TabIndex = 5;
            label1.Text = "TO DO";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(15, 341);
            label2.Name = "label2";
            label2.Size = new Size(44, 15);
            label2.TabIndex = 6;
            label2.Text = "DOING";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(18, 550);
            label3.Name = "label3";
            label3.Size = new Size(39, 15);
            label3.TabIndex = 7;
            label3.Text = "DONE";
            // 
            // button2
            // 
            button2.Location = new Point(732, 167);
            button2.Name = "button2";
            button2.Size = new Size(160, 36);
            button2.TabIndex = 8;
            button2.Text = "Start Task";
            button2.UseVisualStyleBackColor = true;
            button2.Click += button2_Click;
            // 
            // button3
            // 
            button3.Location = new Point(732, 341);
            button3.Name = "button3";
            button3.Size = new Size(160, 36);
            button3.TabIndex = 9;
            button3.Text = "Done";
            button3.UseVisualStyleBackColor = true;
            button3.Click += button3_Click;
            // 
            // UserName
            // 
            UserName.AutoSize = true;
            UserName.Location = new Point(267, 36);
            UserName.Name = "UserName";
            UserName.Size = new Size(62, 15);
            UserName.TabIndex = 10;
            UserName.Text = "UserName";
            // 
            // ScoreLabel
            // 
            ScoreLabel.AutoSize = true;
            ScoreLabel.Location = new Point(374, 36);
            ScoreLabel.Name = "ScoreLabel";
            ScoreLabel.Size = new Size(45, 15);
            ScoreLabel.TabIndex = 11;
            ScoreLabel.Text = "Score : ";
            ScoreLabel.Click += label4_Click;
            // 
            // CurrScore
            // 
            CurrScore.AutoSize = true;
            CurrScore.Location = new Point(425, 36);
            CurrScore.Name = "CurrScore";
            CurrScore.Size = new Size(59, 15);
            CurrScore.TabIndex = 12;
            CurrScore.Text = "CurrScore";
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(223, 36);
            label4.Name = "label4";
            label4.Size = new Size(25, 15);
            label4.TabIndex = 13;
            label4.Text = "Hi !";
            label4.Click += label4_Click_1;
            // 
            // taskGroup
            // 
            taskGroup.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            taskGroup.Location = new Point(948, 97);
            taskGroup.Name = "taskGroup";
            taskGroup.RowTemplate.Height = 25;
            taskGroup.Size = new Size(462, 184);
            taskGroup.TabIndex = 14;
            // 
            // Tasks
            // 
            Tasks.AutoSize = true;
            Tasks.Location = new Point(413, 72);
            Tasks.Name = "Tasks";
            Tasks.Size = new Size(34, 15);
            Tasks.TabIndex = 15;
            Tasks.Text = "Tasks";
            Tasks.Click += label5_Click_1;
            // 
            // label5
            // 
            label5.AutoSize = true;
            label5.Location = new Point(1203, 72);
            label5.Name = "label5";
            label5.Size = new Size(75, 15);
            label5.TabIndex = 16;
            label5.Text = "Tasks Groups";
            // 
            // visGroup
            // 
            visGroup.Location = new Point(1086, 310);
            visGroup.Name = "visGroup";
            visGroup.Size = new Size(160, 36);
            visGroup.TabIndex = 17;
            visGroup.Text = "Visualize Group";
            visGroup.UseVisualStyleBackColor = true;
            visGroup.Click += visGroup_Click;
            // 
            // editTask
            // 
            editTask.Location = new Point(523, 24);
            editTask.Name = "editTask";
            editTask.Size = new Size(203, 38);
            editTask.TabIndex = 18;
            editTask.Text = "Edit task";
            editTask.UseVisualStyleBackColor = true;
            editTask.Visible = false;
            editTask.Click += editTask_Click;
            // 
            // creatGroup
            // 
            creatGroup.Location = new Point(948, 12);
            creatGroup.Name = "creatGroup";
            creatGroup.Size = new Size(187, 63);
            creatGroup.TabIndex = 19;
            creatGroup.Text = "Create new group";
            creatGroup.UseVisualStyleBackColor = true;
            creatGroup.Click += creatGroup_Click;
            // 
            // Form2
            // 
            ClientSize = new Size(1823, 863);
            Controls.Add(creatGroup);
            Controls.Add(editTask);
            Controls.Add(visGroup);
            Controls.Add(label5);
            Controls.Add(Tasks);
            Controls.Add(taskGroup);
            Controls.Add(label4);
            Controls.Add(CurrScore);
            Controls.Add(ScoreLabel);
            Controls.Add(UserName);
            Controls.Add(button3);
            Controls.Add(button2);
            Controls.Add(label3);
            Controls.Add(label2);
            Controls.Add(label1);
            Controls.Add(button1);
            Controls.Add(dataGridView3);
            Controls.Add(dataGridView2);
            Controls.Add(dataGridView1);
            Name = "Form2";
            Load += Form2_Load_1;
            ((System.ComponentModel.ISupportInitialize)dataGridView1).EndInit();
            ((System.ComponentModel.ISupportInitialize)dataGridView2).EndInit();
            ((System.ComponentModel.ISupportInitialize)dataGridView3).EndInit();
            ((System.ComponentModel.ISupportInitialize)taskGroup).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        private DataGridView dataGridView2;
        private DataGridView dataGridView3;
        private Button button1;
        private Label label1;
        private Label label2;
        private Label label3;
        private Button button2;
        private Button button3;
        private Label UserName;
        private Label ScoreLabel;
        private Label CurrScore;
        private Label label4;
        private DataGridView taskGroup;
        private Label Tasks;
        private Label label5;
        private Button visGroup;
        private Button editTask;
        private Button creatGroup;
    }
}