using HebrewTexts.DAL;
using HebrewTexts.Logic.DTOs;
using SQL.GeneralSQLHelper.Commanders;
using SQL.GeneralSQLHelper.Generators;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Logic.UIServices.Search
{
    public class AutoCompleteContent
    {
        /// <summary>
        /// קבל השלמה אוטומטית לחיפוש לפי הקלדה של מילים
        /// </summary>
        /// <param name="input"></param>
        /// <param name="offset"></param>
        /// <param name="limit"></param>
        /// <returns></returns>
        public List<List<MainContentDto>> GetByInput(string input, int offset = 0, int limit = 10, int distanceBetweenWords = 0)
        {

            #region BuildingSQL


            #region WorkingVariables

            var words = input.Split(' ').ToList();
            var sql = "";
            var sqlParameters = new List<SqlParameter>();
            var selectParst = new List<string>();
            var fromParst = new Dictionary<int, string>();

            var whereParts = new List<string>();

            #endregion


            #region ConventionsVariables

            var tableAliasPrefix = "mc";


            #endregion


            #region BuildPartsOfSelectAndWhereClauses

            var wordsCount = words.Count;

            for (int i = 1; i <= wordsCount; i++)
            {
                sqlParameters.Add(new SqlParameter("@PWord" + i, words[i - 1]));
                //כינוי נוכחי שניתן לטבלה באיטרציה הנוכחית
                var currentTableAlias = tableAliasPrefix + i;
                if (i == 1 )
                {
                    //החלק של הסלקט רלוונטי רק לאיטרציה הראשונה והאחרונה מכיוון שהוא צריך רק להצביע על התוכן הראשון והאחרון של התוצאה
                    //משיכת התוצאות בפועל מתבצעת לאחר מכן
                    selectParst.Add(" " + currentTableAlias + ".SequenceNumberByRootGroup as FromSequenceNumber ," + currentTableAlias + ".RootGroupID , Row_number() over(order by " + currentTableAlias + ".RootGroupID) as ResultID ");
                }
                else if (i==wordsCount)
                {
                    //במילה האחרונה יש רק לציין את הסיקוונס של המילה
                    selectParst.Add(" " + currentTableAlias + ".SequenceNumberByRootGroup as ToSequenceNumber ");
                }

                #region BuildFromClauseWithJoin

                //בניית החלק של from
                var previousTableAlias = tableAliasPrefix + (i - 1);

                var currentFromPart = ((i == 1) ? " " : " join ");//בראשון אין צורך לעשות join רק מהשני ואילך
                currentFromPart += " Contents.MainContent as " + currentTableAlias + " ";
                currentFromPart += ((i == 1) ? " " : " on  " + previousTableAlias + ".RootGroupID= " + currentTableAlias + ".RootGroupID and (" + currentTableAlias + ".SequenceNumberByRootGroup between (" + previousTableAlias + ".SequenceNumberByRootGroup+1) and (" + previousTableAlias + ".SequenceNumberByRootGroup+" + (distanceBetweenWords + 1) + ")) ");

                fromParst.Add(i, currentFromPart);

                //TODO לבצע בתוך לולאה

                #endregion

                //בניית החלק של התנאי
                whereParts.Add(" " + tableAliasPrefix + i + ".Content " + ((i < wordsCount) ? "=@PWord" + i : " like @PWord" + i + " + '%' "));//במילים הראשונות אין צורך בלייק אבל במילה האחרונה יכול להיות שהוא לא הקליד אותה עד הסוף

            }

            var fromClause = string.Join(Environment.NewLine, fromParst.Select(p => p.Value).ToList());


            #endregion


            #region BuildFullSQLStatement


            sql = "SELECT " + string.Join(",", selectParst) + Environment.NewLine
                + " FROM " + Environment.NewLine
                + fromClause
                + " WHERE " + Environment.NewLine + string.Join(" and ", whereParts);

            var sqlGenerator = new SqlServerGeneratorHelper();
            sql = sqlGenerator.SetLimitForSelectStatement(selectStatement: sql, take: limit, skip: offset, orderByColumns: new List<string> { "mc1.RootGroupID" });

            //לעטוף את ה SQL בתוצאות הסופיות
            sql = " select mcResults.MainContentID, mcResults.Content ,r.FromSequenceNumber,r.ToSequenceNumber ,r.ResultID from  Contents.MainContent mcResults join ( " + sql + ") as r on mcResults.RootGroupID = r.RootGroupID where SequenceNumberByRootGroup between (r.FromSequenceNumber - 2) and (r.ToSequenceNumber + 2) order by mcResults.SequenceNumberByRootGroup";

            #endregion


            #endregion

            #region RunSql

            //var context = new HebrewTextsEntities(HebrewTextsEntities.HebrewTextsConnectionStrings.Default);
            var sqlCommander = new SQLServerCommander(@"Server=.\SQLEXPRESS;Database=HebrewTexts;Trusted_Connection=True;");
            var sqlResult = sqlCommander.GetDictionaryListFromSql(sqlStatement: sql, paramters: sqlParameters.ToArray());

            #endregion

            #region ParsingDataBaseResults
            
            var result = new List<List<MainContentDto>>();

            var grp = sqlResult
                  .GroupBy(r => r["ResultID"], r => r);
            foreach (var item in grp)
            {
                result.Add(
                    item
                    .Select(r => new MainContentDto { MainContentID = (int)r["MainContentID"], Content = r["Content"] })
                .ToList());
            }
                

            #endregion


            return result;
        }

    }
}
