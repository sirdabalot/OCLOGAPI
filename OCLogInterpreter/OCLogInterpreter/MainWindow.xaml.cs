using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace OCLogInterpreter
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        LogFile lf;
        Microsoft.Win32.OpenFileDialog ofd;

        public MainWindow()
        {
            InitializeComponent();
            lf = new LogFile();
            ofd = new Microsoft.Win32.OpenFileDialog();

            EntriesView.ItemsSource = lf.m_entryList;
            PriorityFilterDD.ItemsSource = lf.m_listOfPriorities;
        }

        private void OpenLogFile(object sender, RoutedEventArgs e)
        {
            ofd.DefaultExt = ".log";
            ofd.Filter = "OpenComputers Log Files (.log)|*.log";
            bool? result = ofd.ShowDialog();

            if ( result == true )
            {
                lf.loadFromFile(ofd.FileName);
            }
            else
            {
                MessageBox.Show("Error opening file!");
            }

            refreshAllItems();
        }

        private void refreshAllItems()
        {
            EntriesView.Items.Refresh();
            PriorityFilterDD.Items.Refresh();
        }
        
        private void EntriesView_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            Entry selectedEntry = (Entry) EntriesView.SelectedItem;

            if (selectedEntry != null)
            {
                SelTimeDateLab.Content = "Date/Time: " + selectedEntry.m_dateTime;
                SelPriorityLab.Content = "Priority: " + selectedEntry.m_priority;
                SelInfoTB.Text = selectedEntry.m_info;
            }
        }

        private void RenewFilter(object sender, RoutedEventArgs e)
        {
            if (FilterCB != null)
            {
                if (FilterCB.IsChecked == true)
                {
                    EntriesView.ItemsSource = lf.filterEntries(PriorityFilterDD.Text, DateFilterTB.Text);
                }
                else
                {
                    EntriesView.ItemsSource = lf.m_entryList;
                }

                refreshAllItems();
            }
        }

        private void PriorityFilterDD_DropDownClosed(object sender, EventArgs e)
        {
            RenewFilter( sender, null );
        }

    }
}
