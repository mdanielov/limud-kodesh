using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.DAL
{
    public partial class HebrewTextsEntities
    {
        public enum HebrewTextsConnectionStrings { Default }

        public HebrewTextsEntities(HebrewTextsConnectionStrings connetion)
            : base(connectionStringsDic[connetion])
        {

        }

        static Dictionary<HebrewTextsConnectionStrings, string> connectionStringsDic = new Dictionary<HebrewTextsConnectionStrings, string>
        {
        { HebrewTextsConnectionStrings.Default,"metadata=res://*/HebrewTextsDataModel.csdl|res://*/HebrewTextsDataModel.ssdl|res://*/HebrewTextsDataModel.msl;provider=System.Data.SqlClient;provider connection string=\"data source=localhost;initial catalog=HebrewTexts;integrated security=True;MultipleActiveResultSets=True;App=EntityFramework\""}
    };



    }
}
