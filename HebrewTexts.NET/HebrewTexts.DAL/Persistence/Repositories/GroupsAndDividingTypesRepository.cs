using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.DAL.Persistence.Repositories
{
    public class GroupsAndDividingTypesRepository
    {

        public GroupsAndDividingTypesRepository()
        {
            context = new HebrewTextsEntities(connetion: HebrewTextsEntities.HebrewTextsConnectionStrings.Default);
        }

        public GroupsAndDividingTypesRepository(HebrewTextsEntities context)
        {
            this.context = context;
        }


        HebrewTextsEntities context;

        public int? GetTypeByKeyWord(string keyWordIndex)
        {
            return context.GroupsAndDividingTypes.Where(t => t.KeyWordIndex == keyWordIndex).FirstOrDefault()?.ID;
        }
        #region Groups Types

        /// <summary>
        /// מחזיר מזהה מסוג מסכת
        /// </summary>
        public int Masechet
        {
            get { return (int)GetTypeByKeyWord("Masechet"); }
        }

        /// <summary>
        /// מחזיר מזהה מסוג דף
        /// </summary>
        public int Daf
        {
            get { return (int)GetTypeByKeyWord("Daf"); }
        }
        /// <summary>
        /// מחזיר מזהה מסוג עמוד
        /// </summary>
        public int Amud
        {
            get { return (int)GetTypeByKeyWord("Amud"); }
        }
        /// <summary>
        /// מחזיר מזהה מסוג שורה
        /// </summary>
        public int Row
        {
            get { return (int)GetTypeByKeyWord("Row"); }
        }

        /// <summary>
        /// מחזיר מזהה מסוג משנה בתוך התלמוד
        /// </summary>
        public int MishnaInTalmud
        {
            get { return (int)GetTypeByKeyWord("MishnaInTalmud"); }
        }

        /// <summary>
        /// מחזיר מזהה מסוג שורה
        /// </summary>
        public int GmaraInTalmud
        {
            get { return (int)GetTypeByKeyWord("GmaraInTalmud"); }
        }


        /// <summary>
        /// מחזיר מזהה מסוג פרק
        /// </summary>
        public int Chapter
        {
            get { return (int)GetTypeByKeyWord("Chapter"); }
        }
        #endregion
    }
}
