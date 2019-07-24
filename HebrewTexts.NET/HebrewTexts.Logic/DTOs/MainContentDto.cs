using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Logic.DTOs
{
    /// <summary>
    /// יחידת תוכן
    /// </summary>
    public class MainContentDto
    {

        /// <summary>
        /// מזהה של תוכן ראשי
        /// </summary>
        public long MainContentID { get; set; }

        /// <summary>
        /// מזהה קבוצת תוכן
        /// </summary>
        public int GroupID { get; set; }

        /// <summary>
        /// התוכן עצמו
        /// </summary>
        public string Content { get; set; }

        /// <summary>
        /// תוכן ארוך יותר
        /// </summary>
        public string LargeContent { get; set; }

    }
}
