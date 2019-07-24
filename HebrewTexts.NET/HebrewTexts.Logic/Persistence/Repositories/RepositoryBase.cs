using HebrewTexts.Logic.ListBuilder;
using IntelligentListBuilder.Interop.ToSql;
using SQL.GeneralSQLHelper.Generators;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace HebrewTexts.Logic.Persistence.Repositories
{
    /// <summary>
    /// מחלקת בסיס אבסטרקטית עבור רפוזיטורי של אובייקט
    /// </summary>
    public abstract class RepositoryBase<TEntity> : IDisposable where TEntity : class
    {

        #region Constructor

        /// <summary>
        /// constructor as a user entity
        /// </summary>
        /// <param name="user"></param>
        public RepositoryBase(AppUser user)
        {
            User = user;
            context = new DB(User).Entities;
        }

        #endregion


        #region Members

        /// <summary>
        /// the DbContext that working with
        /// </summary>
        protected readonly DbContext context;
        /// <summary>
        /// the user entity
        /// </summary>
        public readonly AppUser User;
        #endregion

        #region Read


        /// <summary>
        /// get entity by ID
        /// </summary>
        /// <param name="id">int id</param>
        /// <param name="eagerlyLoading">Eagerly loading the object?</param>
        /// <returns></returns>
        public virtual TEntity GetByID(int id, bool eagerlyLoading = false)
        {
            return context.Set<TEntity>().Find(id);
        }

        /// <summary>
        /// find entities by expressino
        /// </summary>
        /// <param name="predicate"></param>
        /// <returns></returns>
        public virtual IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>> predicate)
        {
            return context.Set<TEntity>().Where(predicate);
        }

        /// <summary>
        /// get all as IEnumerable
        /// </summary>
        /// <returns></returns>
        public virtual IEnumerable<TEntity> GetAll()
        {
            //TODO לבדוק למה הוא מעלה את כל הריליישנים ומבצע טעינה מזורזת ולא טעינה עצלה
            return context.Set<TEntity>().AsEnumerable();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="predicate"></param>
        /// <returns></returns>
        public virtual TEntity SingleOrDefault(Expression<Func<TEntity, bool>> predicate = null)
        {
            if (predicate == null)
            {
                return context.Set<TEntity>().FirstOrDefault();
            }
            return context.Set<TEntity>().SingleOrDefault(predicate);
        }



        /// <summary>
        /// this method is like get many but return a different object type
        /// see documentation in the GetMany method
        /// </summary>
        /// <param name="take"></param>
        /// <param name="skip"></param>
        /// <param name="viewID"></param>
        /// <param name="tableOrViewName"></param>
        /// <param name="instanceID"></param>
        /// <param name="orderByColumns"></param>
        /// <param name="whereCondition"></param>
        /// <param name="displayedOnly"></param>
        /// <param name="listBuilderCommands">ניתן לשלוח פקודות של ליסט בילדר אם רצונכם בכך
        /// באם יישלח תנאי וגם פקודות של ליסט בילדר ננסה לאחד את התנאים עם אופרטור 
        /// AND
        /// </param>
        /// <param name="pullSpecificColumns">
        ///  האם למשוך עמודות ספציפיות בלבד ממסד הנתונים
        /// עוזר לאסקיואל לעבודה קלה יותר ויותר
        /// וגם חוסך לכם תעבורת רשת מיותרת וכו
        /// אם תשאירו ריק הוא ימשוך את כל העמודות או את ברירת המחדל המוגדרת בתצוגה
        /// אתם לא חייבים למשוך את כל העמודות כדי להשתמש בפקודות סינון של בונה הרשימות
        /// אפשר להשתמש בפקודת סינון בעמודות שאתם לא מושכים אותם בסלקט
        /// </param>
        /// <returns></returns>
        public virtual List<Dictionary<string, dynamic>> GetManyAsDynamicObject(int take = 0, int skip = 0,
           int? viewID = null, string tableOrViewName = null, int instanceID = 0, bool displayedOnly = true,
           List<string> orderByColumns = null, string whereCondition = null,
           List<UnitFilterCommandToSql> listBuilderCommands = null, List<string> pullSpecificColumns = null)
        {

            #region ExecutiongSql
            {

                var sqlParams = new List<IDataParameter>();
                var sqlStatement = GenerateSqlForMany(sqlParams: out sqlParams
                    , take: take, skip: skip, viewID: viewID, tableOrViewName: tableOrViewName, instanceID: instanceID, displayedOnly: displayedOnly,
                    orderByColumns: orderByColumns, whereCondition: whereCondition,
                    listBuilderCommands: listBuilderCommands, pullSpecificColumns: pullSpecificColumns);


                var result = new List<Dictionary<string, dynamic>>();


                var db = new DB(user: User);
                result = db.SqlCommander.GetDictionaryListFromSql(sqlStatement: sqlStatement, paramters: sqlParams);

                #endregion

                //GeneralProperties.InsertDisplayValues(result);

                return result;
            }
        }


        /// <summary>
        /// פונקציה זו אחראית לספק אך ורק את משפט האסקיואל עבור קבלת ריבוי רשומות
        /// הסיבה שהפרדנו היא כי לפעמים ייתכן שנצטרך להשתמש באסקיואל בצורה שונה כגון להסטרים דאטה במקרה של רשומות רבות
        /// וכן לייצא פורמטים שונים כגון אקסל וכדומה
        /// לכן ביצענו כאן הפרדה נהדרת בנושא הזה
        /// </summary>
        /// <param name="sqlParams"></param>
        /// <param name="take"></param>
        /// <param name="skip"></param>
        /// <param name="viewID"></param>
        /// <param name="tableOrViewName"></param>
        /// <param name="instanceID"></param>
        /// <param name="displayedOnly"></param>
        /// <param name="orderByColumns"></param>
        /// <param name="whereCondition"></param>
        /// <param name="listBuilderCommands"></param>
        /// <param name="pullSpecificColumns">
        ///  האם למשוך עמודות ספציפיות בלבד ממסד הנתונים
        /// עוזר לאסקיואל לעבודה קלה יותר ויותר
        /// וגם חוסך לכם תעבורת רשת מיותרת וכו
        /// אם תשאירו ריק הוא ימשוך את כל העמודות או את ברירת המחדל המוגדרת בתצוגה
        /// אתם לא חייבים למשוך את כל העמודות כדי להשתמש בפקודות סינון של בונה הרשימות
        /// אפשר להשתמש בפקודת סינון בעמודות שאתם לא מושכים אותם בסלקט
        /// </param>
        /// <returns></returns>
        protected string GenerateSqlForMany(out List<IDataParameter> sqlParams, int take = 0, int skip = 0,
           int? viewID = null, string tableOrViewName = null, int instanceID = 0, bool displayedOnly = true,
           List<string> orderByColumns = null, string whereCondition = null,
           List<UnitFilterCommandToSql> listBuilderCommands = null, List<string> pullSpecificColumns = null)
        {

            #region GettingTableOrViewName

            if (string.IsNullOrWhiteSpace(tableOrViewName))
            {
                if (viewID != null)
                {
                    // tableOrViewName = UIRealizationViewRepository.GetViewNameByID(viewID: viewID);
                }
                else
                {
                    // tableOrViewName = context.GetTableName<TEntity>();
                }
            }
            //if passed viewName  we try to got the id
            // viewID = viewID ?? UIRealizationViewRepository.GetViewIDByName(viewName: tableOrViewName);
            #endregion

            #region GenerateSQL

            #region BaseSelect

            //var selectGenerator = new SelectGenerator(user: User, tableOrViewName: tableOrViewName);

            string sqlStatement = "";
            //sqlStatement = selectGenerator.GenerateForTableOrView(pullSpecificColumns: pullSpecificColumns);

            #endregion

            #region WhereClause

            var where = "";
            sqlParams = new List<IDataParameter>();


            //if where condition exists
            if (!string.IsNullOrWhiteSpace(whereCondition))
            {
                where +=
                    (string.IsNullOrWhiteSpace(where) ? "" : " and ") +
                    " (" + whereCondition + " ) ";
            }

            //if list builder commands exists
            if (listBuilderCommands != null)
            {
                //שיפוץ לליסט בילדר
                listBuilderCommands.Refactor();
                var tableNameOnly = tableOrViewName;
                //var listBuilderSqlGenerator = new ListBuilderSqlGenerator(User.ListBuilderClientConfig, tableNameOnly) { MainTableAlias = selectGenerator.MainTableAlias };
                ICollection<IDataParameter> sqlParamslistBuilder = new List<IDataParameter>();
                //var whereScriptByFilteringCommand = listBuilderSqlGenerator.GetSqlScriptWhereClause(commands: listBuilderCommands, outParamters: out sqlParamslistBuilder);
                //where +=
                //    (string.IsNullOrWhiteSpace(where) ? "" : " and ") +
                //    " (" + whereScriptByFilteringCommand + " ) ";
                //sqlParams.AddRange(sqlParamslistBuilder);
            }
            sqlStatement += (string.IsNullOrWhiteSpace(where) ? "" : " WHERE " + where);

            #endregion

            #region OrderByClause

            var sqlHelper = new SqlServerGeneratorHelper();

            if (orderByColumns != null)
            {

                //var parser = new OrderByClauseParser(user: User);

                for (int i = 0; i < orderByColumns.Count; i++)
                {
                    var rgxDirection = new Regex(@"((\s*asc\s*)|(\s*desc\s*))$", RegexOptions.IgnoreCase);
                    var directionOnly = rgxDirection.Match(orderByColumns[i]).Value;
                    var columnOnly = rgxDirection.Replace(orderByColumns[i], "", 1);

                    //orderByColumns[i] = parser.RealOrderBy(columnOnly) + directionOnly;
                }


            }

            #endregion


            #region LimitPart


            sqlStatement = sqlHelper.SetLimitForSelectStatement(selectStatement: sqlStatement, take: take, skip: skip, orderByColumns: orderByColumns);
            #endregion

            #endregion


            return sqlStatement;

        }

        public void Dispose()
        {
            throw new NotImplementedException();
        }



        #endregion

    }
}
