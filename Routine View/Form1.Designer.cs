namespace Routine_View
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
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
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            EmailBox = new TextBox();
            PasswordBox = new TextBox();
            LoginBtn = new Button();
            SuspendLayout();
            // 
            // EmailBox
            // 
            EmailBox.Location = new Point(127, 197);
            EmailBox.Name = "EmailBox";
            EmailBox.Size = new Size(126, 23);
            EmailBox.TabIndex = 2;
            EmailBox.Text = "Email";
            // 
            // PasswordBox
            // 
            PasswordBox.Location = new Point(433, 197);
            PasswordBox.Name = "PasswordBox";
            PasswordBox.Size = new Size(126, 23);
            PasswordBox.TabIndex = 3;
            PasswordBox.Text = "Password";
            // 
            // LoginBtn
            // 
            LoginBtn.Location = new Point(281, 286);
            LoginBtn.Name = "LoginBtn";
            LoginBtn.Size = new Size(75, 23);
            LoginBtn.TabIndex = 4;
            LoginBtn.Text = "login";
            LoginBtn.UseVisualStyleBackColor = true;
            LoginBtn.Click += LoginBtn_click;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(LoginBtn);
            Controls.Add(PasswordBox);
            Controls.Add(EmailBox);
            Name = "Form1";
            Text = "Form1";
            Load += Form1_Load;
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private TextBox EmailBox;
        private TextBox PasswordBox;
        private Button LoginBtn;
    }
}