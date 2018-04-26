using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;

namespace StartSilent
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Process process = new Process();

            process.StartInfo.FileName = "powershell.exe";

            process.StartInfo.Arguments = "-ExecutionPolicy Bypass -File c:\\ProgramData\\Upgrade\\Invoke-Reminder.ps1";

            process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;

            process.Start();
        }
    }
}
