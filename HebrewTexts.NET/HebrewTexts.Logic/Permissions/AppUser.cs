using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts
{
    /// <summary>
    /// יוזר של המערכת
    /// </summary>
    public class AppUser
    {
        /// <summary>
        ///  הקונקשן סטרינג של היוזר הזה
        /// </summary>
        public string ConnectionString = "Server=localhost;Database=HebrewTexts;Trusted_Connection=True;";
        /// <summary>
        /// קבל יוזר עבור טסטים
        /// </summary>
        /// <returns></returns>
        public static AppUser GetForTests() { return new AppUser(); }
    }
}
