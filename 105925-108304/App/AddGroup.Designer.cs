namespace Routine_View_Forms
{
    partial class AddGroup
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            description = new TextBox();
            title = new TextBox();
            label2 = new Label();
            label1 = new Label();
            categoryRadio = new RadioButton();
            deadlineRadio = new RadioButton();
            importanceRadio = new RadioButton();
            label4 = new Label();
            Create = new Button();
            SuspendLayout();
            // 
            // description
            // 
            description.Location = new Point(300, 107);
            description.Name = "description";
            description.Size = new Size(200, 23);
            description.TabIndex = 22;
            // 
            // title
            // 
            title.Location = new Point(300, 61);
            title.Name = "title";
            title.Size = new Size(200, 23);
            title.TabIndex = 21;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(219, 61);
            label2.Name = "label2";
            label2.Size = new Size(66, 15);
            label2.TabIndex = 20;
            label2.Text = "Group title:";
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(206, 107);
            label1.Name = "label1";
            label1.Size = new Size(70, 15);
            label1.TabIndex = 19;
            label1.Text = "Description:";
            // 
            // categoryRadio
            // 
            categoryRadio.AutoSize = true;
            categoryRadio.Location = new Point(498, 152);
            categoryRadio.Name = "categoryRadio";
            categoryRadio.Size = new Size(73, 19);
            categoryRadio.TabIndex = 31;
            categoryRadio.TabStop = true;
            categoryRadio.Text = "Category";
            categoryRadio.UseVisualStyleBackColor = true;
            // 
            // deadlineRadio
            // 
            deadlineRadio.AutoSize = true;
            deadlineRadio.Location = new Point(403, 152);
            deadlineRadio.Name = "deadlineRadio";
            deadlineRadio.Size = new Size(70, 19);
            deadlineRadio.TabIndex = 30;
            deadlineRadio.TabStop = true;
            deadlineRadio.Text = "deadline";
            deadlineRadio.UseVisualStyleBackColor = true;
            // 
            // importanceRadio
            // 
            importanceRadio.AutoSize = true;
            importanceRadio.Location = new Point(300, 152);
            importanceRadio.Name = "importanceRadio";
            importanceRadio.Size = new Size(86, 19);
            importanceRadio.TabIndex = 28;
            importanceRadio.TabStop = true;
            importanceRadio.Text = "Importance";
            importanceRadio.UseVisualStyleBackColor = true;
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(219, 152);
            label4.Name = "label4";
            label4.Size = new Size(31, 15);
            label4.TabIndex = 27;
            label4.Text = "Type";
            label4.Click += label4_Click;
            // 
            // Create
            // 
            Create.Location = new Point(300, 192);
            Create.Name = "Create";
            Create.Size = new Size(221, 67);
            Create.TabIndex = 26;
            Create.Text = "Create Group";
            Create.UseVisualStyleBackColor = true;
            Create.Click += Create_Click;
            // 
            // AddGroup
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(categoryRadio);
            Controls.Add(deadlineRadio);
            Controls.Add(importanceRadio);
            Controls.Add(label4);
            Controls.Add(Create);
            Controls.Add(description);
            Controls.Add(title);
            Controls.Add(label2);
            Controls.Add(label1);
            Name = "AddGroup";
            Text = "AddGroup";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private TextBox description;
        private TextBox title;
        private Label label2;
        private Label label1;
        private RadioButton radioButton5;
        private RadioButton categoryRadio;
        private RadioButton deadlineRadio;
        private RadioButton importanceRadio;
        private Label label4;
        private Button Create;
    }
}