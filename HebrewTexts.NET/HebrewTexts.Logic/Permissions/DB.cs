using HebrewTexts.DAL;
using SQL.GeneralSQLHelper.Commanders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static HebrewTexts.DAL.HebrewTextsEntities;

namespace HebrewTexts
{
    public class DB : IDisposable
    {
        /// <summary>
        /// a db by AppUser instance
        /// </summary>
        /// <param name="user"></param>
        public DB(AppUser user)
        {
            User = user;
        }
        AppUser User { get; set; }

        #region DatabaseCommanders

        /// <summary>
        /// קומנדר מוכן 
        /// </summary>
        public SQLServerCommander SqlCommander { get { return new SQLServerCommander(connectionString: User.ConnectionString); } }


        public HebrewTextsEntities Entities { get; private set; } = new HebrewTextsEntities(HebrewTextsConnectionStrings.Default);

        #endregion


        public void Dispose()
        {

        }
    }

}
