using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace OCLogInterpreter
{
    class LogFile
    {
        public List<Entry> m_entryList = new List<Entry>();

        public List<string> m_listOfPriorities = new List<string>();

        public void populatePriorities()
        {
            m_listOfPriorities.Clear();

            m_listOfPriorities.Add("");

            foreach (Entry e in m_entryList)
            {
                if (!m_listOfPriorities.Contains(e.m_priority))
                {
                    m_listOfPriorities.Add(e.m_priority);
                }
            }
        }

        public List<Entry> findEntriesByTimeDate(string filterTimeDate)
        {
            List<Entry> retList = new List<Entry>();

            foreach (Entry e in m_entryList)
            {
                if (e.m_dateTime.Contains(filterTimeDate))
                {
                    retList.Add(e);
                }
            }

            return retList;
        }

        public List<Entry> findEntriesByPriority(string filterPriority)
        {
            List<Entry> retList = new List<Entry>();

            foreach (Entry e in m_entryList)
            {
                if (e.m_priority.Contains(filterPriority))
                {
                    retList.Add(e);
                }
            }

            return retList;
        }

        public List<Entry> filterEntries(string filterPriority, string filterDateTime)
        {
            List<Entry> retList = new List<Entry>();

            foreach (Entry e in m_entryList)
            {
                if (e.m_priority.Contains(filterPriority) && e.m_dateTime.Contains(filterDateTime) )
                {
                    retList.Add(e);
                }
            }

            return retList;
        }

        public void loadFromFile(string path)
        {
            m_entryList.Clear();
            m_listOfPriorities.Clear();

            StreamReader sr = new StreamReader(path);

            try
            {
                while (!sr.EndOfStream)
                {
                    m_entryList.Add(Entry.unSerialize(sr.ReadLine()));
                }
                populatePriorities();
            }
            finally
            {
                sr.Close();
            }
        }

        public void exportAsCSV(string path)
        {
            StreamWriter sw = new StreamWriter(path);

            try
            {
                sw.WriteLine("Date/Time,Log Information,Priority");
                foreach (Entry e in m_entryList)
                {
                    sw.WriteLine(e.toCSVFormat());
                }
            }
            finally
            {
                sw.Close();
            }
        }
    }

    class Entry
    {
        public string m_dateTime = "";
        public string m_info = "";
        public string m_priority = "";

        public override string ToString()
        {
            return m_dateTime + ": " + m_priority;
        }

        public static Entry unSerialize(string data)
        {

            Entry newEntry = new Entry();

            int part = 0;

            char[] charrdata = data.ToCharArray();

            foreach (char c in charrdata)
            {
                if (c == '|')
                {
                    part++;
                }
                else
                {
                    switch (part)
                    {
                        case 1:
                            newEntry.m_dateTime += c;
                            break;
                        case 2:
                            newEntry.m_info += c;
                            break;
                        case 3:
                            newEntry.m_priority += c;
                            break;
                    }
                }
            }

            return newEntry;
        }

        public string toCSVFormat() {
            string retString = "\"" +
                   m_dateTime + "\",\"" +
                   m_info + "\",\"" +
                   m_priority + "\"";

            return retString;
        }
    }
}
