using HebrewTexts.DAL;
using HebrewTexts.DAL.Persistence.Repositories;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Serialization;

namespace HebrewTexts.Import.EntitiesToImport.TalmudBavli
{

    public class TalmudBavliImporting
    {

        HebrewTextsEntities context = new HebrewTextsEntities(HebrewTextsEntities.HebrewTextsConnectionStrings.Default);

        /// <summary>
        /// יוצר עמוד בתלמוד בבלי מתוך אקסמל מוסכם
        /// </summary>
        /// <param name="xml"></param>
        /// <returns></returns>
        public static AmudTalmudBavli CreateFromXml(string xml)
        {

            AmudTalmudBavli amudTalmudBavli = new AmudTalmudBavli();
            var xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(xml);

            var meta = xmlDoc.GetElementsByTagName("meta")[0];

            amudTalmudBavli.Version = meta["version"].InnerText;
            amudTalmudBavli.BookPublishing = meta["bookPublishing"].InnerText;

            var masechet = xmlDoc.DocumentElement["masechet"];
            MasechetTalmudBavli masechetTalmudBavli = new MasechetTalmudBavli();

            masechetTalmudBavli.Name = masechet.Attributes["name"].Value;
            masechetTalmudBavli.SequenceNumber = int.Parse(masechet.Attributes["serial"].Value); //["sequenceNumber"].Value;
            var daf = masechet.GetElementsByTagName("daf")[0];
            var amudXML = daf.ChildNodes[0];
            amudTalmudBavli.AmudNumber = int.Parse(amudXML.Attributes["value"].Value);
            amudTalmudBavli.DafNumber = int.Parse(daf.Attributes["value"].Value);
            amudTalmudBavli.Masechet = masechetTalmudBavli;
            amudTalmudBavli.Rows = new List<RowInTalmudBavli>();
            string xpath = "root/masechet/daf/amud/row";
            var rows = xmlDoc.SelectNodes(xpath);


            var xDox = XDocument.Parse(xml);

            var rElements = xDox.Descendants("row");
            var result = rElements
                .Where(r => r.Attribute("isdata").Value == "1")
                .Select(e =>
            {
                var row = GetRow(e);
                row.InAmud = amudTalmudBavli;
                return row;
            });
            amudTalmudBavli.Rows = result.ToList();

            return amudTalmudBavli;
        }


        static RowInTalmudBavli GetRow(XElement rowXml)
        {
            var newRow = new RowInTalmudBavli();
            int wordCounter = 0;
            var content = "";
            foreach (var node in rowXml.Nodes())
                if (node.NodeType == XmlNodeType.Text)
                {
                    var txt = node.ToString();//.Trim();
                    wordCounter += txt.Split(' ').Where(w => !string.IsNullOrWhiteSpace(w)).Count();
                    content += txt;
                }
                else if (node.NodeType == XmlNodeType.Element)
                {
                    var el = (XElement)node;

                    if (el.Name == "StartMishna")
                        newRow.StartMishnaBeforePositionInContent = wordCounter + 1;
                    else if (el.Name == "EndMishna")
                        newRow.EndMishnaAfterPositionInContent = wordCounter;
                    else if (el.Name == "StartGemara")
                        newRow.StartGmaraBeforePositionInContent = wordCounter + 1;
                    else if (el.Name == "EndGemara")
                        newRow.EndGmaraAfterPositionInContent = wordCounter;
                }
            newRow.SequenceNumber = int.Parse(rowXml.Attribute("row_number").Value);
            newRow.Content = content;
            return newRow;
        }


        static ContentGroup talmudBavliGroup;
        ContentGroup TalmudBavliGroup
        {
            get
            {
                return talmudBavliGroup ?? (talmudBavliGroup = context.ContentGroups.Where(g => g.KeyWordIndex == "TalmudBavli" && g.GroupName == "תלמוד בבלי").First());
            }
        }

        public void ImportAmud(AmudTalmudBavli amudToImport)
        {


            #region Validations



            //if (!amudToImport.Masechet.IsValid)
            //{
            //    foreach (var msg in amudToImport.Masechet.ValidationsMessages.ToList())
            //    {
            //        throw new Exception("מסכת לא חוקית", new Exception(msg));
            //    }
            //}

            if (!amudToImport.IsValid)
            {
                foreach (var msg in amudToImport.ValidationsMessages.ToList())
                {
                    throw new Exception("עמוד לא חוקי", new Exception(msg));
                }
            }

            if (amudToImport.Rows.Any(r => !r.IsValid))
            {
                throw new Exception("נמצאו אחת או יותר שורות לא חוקיות",
                    new Exception(string.Join("/r", amudToImport.Rows.Where(r => !r.IsValid).Select(r => r.Content + "     ").ToArray())));
            }


            #endregion



            #region InitVersion

            //טיפול בגירסה

            var version = context.TextVersions.Where(v => v.Name == amudToImport.Version && v.BookPublishing == amudToImport.BookPublishing).FirstOrDefault();// 


            if (version == null)
            {
                version = new TextVersion
                {
                    Name = amudToImport.Version,
                    BookPublishing = amudToImport.BookPublishing
                };
                context.TextVersions.Add(version);
                context.SaveChanges();
            }

            #endregion



            #region InitGroups



            var groupsTypesRepo = new GroupsAndDividingTypesRepository();



            #region MasechetGroup


            //הגרופ של המסכת
            var MasechetGroup = context.ContentGroups
                .Where(g =>
                g.GroupName == amudToImport.Masechet.Name //שם המסכת צריך להיות זהה
                && g.GroupType == groupsTypesRepo.Masechet//זה צריך להיות גרופ מסוג מסכת
                && g.ParentGroupID == TalmudBavliGroup.GroupID//ההורה של הגרופ צריך להיות תלמוד בבלי
                ).SingleOrDefault();

            //אם לא נמצא גרופ מסכת הרי שעלינו ליצור אותו
            if (MasechetGroup == null)
            {
                MasechetGroup = new ContentGroup
                {
                    ParentGroupID = TalmudBavliGroup.GroupID,
                    GroupName = amudToImport.Masechet.Name,
                    GroupType = groupsTypesRepo.Masechet,
                    SequenceNumber = amudToImport.Masechet.SequenceNumber,
                    RootGroupID = TalmudBavliGroup.GroupID
                };
                context.ContentGroups.Add(MasechetGroup);
                context.SaveChanges();
            }

            #endregion


            #region ChapterGroup

            //הגרופ של הפרק
            var currentChapterGroup = context.ContentGroups
                .Where(g =>
                 g.GroupType == groupsTypesRepo.Chapter//זה צריך להיות גרופ מסוג פרק
                && g.ParentGroupID == MasechetGroup.GroupID//ההורה של הגרופ צריך להיות המסכת הנוכחית
                ).OrderByDescending(g => g.SequenceNumber) //הפרק האחרון שנצפה במסכת זו
                .FirstOrDefault();


            #endregion



            #region DafGroup


            //הגרופ של הדף
            var DafGroup = context.ContentGroups
              .Where(g =>
               g.SequenceNumber == amudToImport.DafNumber
               && //מספר הדף צריך להיות זהה
              g.GroupType == groupsTypesRepo.Daf//זה צריך להיות גרופ מסוג דף
              && g.ParentGroupID == MasechetGroup.GroupID// ההורה של הגרופ צריך להיות המסכת
              ).SingleOrDefault();

            if (DafGroup == null)
            {
                //אם לא נמצא יש ליצור
                DafGroup = new ContentGroup
                {
                    ParentGroupID = MasechetGroup.GroupID,
                    GroupType = groupsTypesRepo.Daf,
                    SequenceNumber = amudToImport.DafNumber,
                    RootGroupID = TalmudBavliGroup.GroupID
                };
                context.ContentGroups.Add(DafGroup);
                context.SaveChanges();
            }

            #endregion



            #region AmudGroup


            //הגרופ של העמוד 
            var AmudGroup = context.ContentGroups
               .Where(g =>
               g.GroupType == groupsTypesRepo.Amud//זה צריך להיות גרופ מסוג דף
               && g.ParentGroupID == DafGroup.GroupID//ההורה של הגרופ הוא דף
               ).SingleOrDefault();


            //אם לא נמצא יש ליצור
            if (AmudGroup == null)
            {
                //אם לא נמצא יש ליצור
                AmudGroup = new ContentGroup
                {
                    ParentGroupID = DafGroup.GroupID,
                    GroupType = groupsTypesRepo.Amud,
                    SequenceNumber = amudToImport.AmudNumber,
                    RootGroupID = TalmudBavliGroup.GroupID
                };
                context.ContentGroups.Add(AmudGroup);
                context.SaveChanges();
            }

            #endregion



            #endregion



            #region InsertRows


            //לעבור בלולאה על כל השורות
            foreach (var row in amudToImport.Rows)
            {


                //הגרופ של השורה
                var RowGroup = context.ContentGroups
               .Where(g =>
               g.GroupType == groupsTypesRepo.Row//זה צריך להיות גרופ מסוג עמוד
               && g.ParentGroupID == AmudGroup.GroupID//ההורה של הגרופ הוא עמוד
               && g.SequenceNumber == row.SequenceNumber
               ).SingleOrDefault();

                if (RowGroup == null)
                {
                    //אם לא נמצא יש ליצור
                    RowGroup = new ContentGroup
                    {
                        ParentGroupID = AmudGroup.GroupID,
                        GroupType = groupsTypesRepo.Row,
                        SequenceNumber = row.SequenceNumber,
                        RootGroupID = TalmudBavliGroup.GroupID
                    };
                    context.ContentGroups.Add(RowGroup);
                    context.SaveChanges();
                }


                #region LoopOfWords

                //יצירת תוכן השורה פשוט חלוקה למילים
                var words = row.Content.Split(' ').ToList();

                //התוכן שכבר קיים כעת בדטה בייס
                var currentContents = context.MainContents.Where(c => c.GroupID == RowGroup.GroupID).ToList();

                //אם עדיין לא נוצר כל תוכן יש להכניס אותו בלולאה
                if (currentContents.Count == 0)
                {
                    var i = 1;
                    foreach (var word in words)
                    {
                        currentContents.Add(new MainContent
                        {
                            Content = word,
                            GroupID = RowGroup.GroupID,
                            RootGroupID = TalmudBavliGroup.GroupID,
                            SequenceNumber = i,
                            VersionID = version.VersionID
                        });
                        i++;
                    }

                    context.MainContents.AddRange(currentContents);
                    context.SaveChanges();
                }
                else
                {
                    //אחרת יש לבדוק כל מילה אם קיימת ואם איננה קיימת ניתן להוסיף אותה
                    //אם מדובר באותה גירסה בדיוק או בגירסה אחרת
                    //למעשה כאן נכנס לתמונה הנושא של ניהול גירסאות וזהו מורכב ביותר
                    //לצורך כך בנינו פונקציה מיוחדת שתפקידה למזג גירסה חדשה לתוך הגירסה המרכזית והיא מקבלת למעשה ליסט של אובייקטי תוכן לאו דווקא רשומים בדטה בייס


                }

                #endregion


                #region HandelingAlternateGroups


                #region ChapterGroupHandling


                //אם מתחיל פרק בתוך השורה הנוכחית
                if (row.StartChapterBeforePositionInContent != null)
                {

                    // אם לא נמצא גרופ פרק הרי שעלינו ליצור אותו בפעם הראשונה
                    if (currentChapterGroup == null)
                    {
                        currentChapterGroup = new ContentGroup
                        {
                            ParentGroupID = MasechetGroup.GroupID,
                            GroupType = groupsTypesRepo.Chapter,
                            SequenceNumber = 1, //הואיל וזו פעם ראשונה שמוסיפים פרק חדש למסכת הנוכחית מן ההכרח שהוא הראשון
                            RootGroupID = TalmudBavliGroup.GroupID,
                            RoutePriority = 2//העדפת ניתוב תחת ההורה שזוהי בעצם המסכת צריכה להיות לפי דפים ראשית כל ואחר כך לפי פרקים
                        };

                        context.ContentGroups.Add(currentChapterGroup);
                        context.SaveChanges();
                    }
                    //אם כבר מצאנו פרק קיים הרי שמן ההכרח שהוא נוצר כבר וכבר עבר את התהליך הנוכחי של היצירה ואם כן מדובר בפרק חדש שבא אחריו
                    else
                    {
                        currentChapterGroup = new ContentGroup
                        {
                            ParentGroupID = MasechetGroup.GroupID,
                            GroupType = groupsTypesRepo.Chapter,
                            SequenceNumber = currentChapterGroup.SequenceNumber + 1, //מכיוון שזהו פרק חדש שמגיע אחרי פרק קודם יש להוסיף מספר אחד אחריו ברצף
                            RootGroupID = TalmudBavliGroup.GroupID,
                            RoutePriority = 2//העדפת ניתוב תחת ההורה שזוהי בעצם המסכת צריכה להיות לפי דפים ראשית כל ואחר כך לפי פרקים
                        };

                        context.ContentGroups.Add(currentChapterGroup);
                        context.SaveChanges();
                    }


                    //כעת בוודאי עלינו להוסיף את ההפניה לגרופ הנוכחי
                    var contentStart = currentContents.Where(c => c.SequenceNumber == row.StartChapterBeforePositionInContent).First();

                    var contentToAlternateGroup = new ContentToAlternateGroup
                    {
                        GroupID = currentChapterGroup.GroupID,
                        FromContentID = contentStart.MainContentID,
                        ToContentID = contentStart.MainContentID,
                        VersionID = version.VersionID
                    };
                    context.ContentToAlternateGroups.Add(contentToAlternateGroup);
                    context.SaveChanges();
                }

                //אם מסתיים פרק בשורה הנוכחית יש לסגור את הפרק האחרון שנפתח כך שנוכל בעצם לפתוח פרק חדש בהזדמנות הבאה
                if (row.EndChapterAfterPositionInContent != null)
                {
                    //חובה למצוא פרק פתוח אחרת הוא יזרוק שגיאה
                    //העובדה כי הפרק מסתיים ומתחיל באותה מילה אומרת לנו שהפרק הוא פתוח כלומר שהתחיל ועדיין לא סגרו אותו 
                    //לכן שמנו ערכים שווים בהתחלה ובסיום שלו
                    if (!context.ContentToAlternateGroups.Any(c => c.GroupID == currentChapterGroup.GroupID && c.FromContentID == c.ToContentID))
                    {
                        throw new Exception("לא נמצא פרק פתוח ראה בתיעוד");
                    }

                    var contentEnd = currentContents.Where(c => c.SequenceNumber == row.EndChapterAfterPositionInContent).First();

                    var contentToSuperGroup = context.ContentToAlternateGroups.First(c => c.GroupID == currentChapterGroup.GroupID);
                    contentToSuperGroup.ToContentID = contentEnd.MainContentID;
                    context.SaveChanges();
                }


                #endregion


                #region MishnaInTalmudGroupHandling

                #region StartMishna


                //אם מתחילה משנה בתוך השורה הנוכחית
                if (row.StartMishnaBeforePositionInContent != null)
                {
                    if (currentChapterGroup == null)
                    {
                        throw new Exception("לא ניתן להתחיל משנה אם אין פרק נוכחי קיים");
                    }

                    #region MishnaInTalmudGroup 

                    //כעת עלינו לכאורה ליצור גרופ חדש של משנה הואיל וזאת היא תחילת המשנה
                    //ואולם אם כבר קיים גרופ כזה שלא נסגר אות היא שאנו בבעיה לוגית

                    //לכן נבדוק תחילה אם קיים גרופ לא סגור של משנה
                    var openMishna = (from c in context.ContentToAlternateGroups
                                      join g in context.ContentGroups on c.GroupID equals g.GroupID
                                      where
                                        g.GroupType == groupsTypesRepo.MishnaInTalmud//זה צריך להיות גרופ מסוג משנה
                                        && g.ParentGroupID == currentChapterGroup.GroupID //ההורה של הגרופ צריך להיות הפרק הנוכחי
                                        && c.FromContentID == c.ToContentID //מדובר בגרופ פתוח
                                      select g);

                    if (openMishna != null && openMishna.Count() > 0)
                    {
                        throw new Exception("קיימת משנה פתוחה כבר מזהה הגרופ:" + openMishna.First().GroupID);
                    }

                    //בשלב הזה אנו סמוכים ובטוחים שאין לנו משנה פתוחה ולכן יש לפתוח משנה חדשה

                    //אולם לפני כן יש לאתר את המשנה האחרונה שנפתחה ומן הסתם גם נסגרה וזאת על מנת לשמור על רצף מספרי בין המשניות
                    var lastMishnaSequenceNumber = context.ContentGroups
                        .Where(g => g.GroupType == groupsTypesRepo.MishnaInTalmud
                                  && g.ParentGroupID == currentChapterGroup.GroupID)
                        .Max(g => g.SequenceNumber);

                    //יוצרים גרופ חדש של משנה
                    var MishnaInTalmudGroup = new ContentGroup
                    {
                        ParentGroupID = currentChapterGroup.GroupID,
                        GroupType = groupsTypesRepo.MishnaInTalmud,
                        SequenceNumber = lastMishnaSequenceNumber + 1, //הואיל וזו פעם ראשונה שמוסיפים משנה חדשה לפרק הנוכחי מן ההכרח שהוא הראשון
                        RootGroupID = currentChapterGroup.GroupID,//ההורה הוא הפרק הנוכחי
                        RoutePriority = 1//העדפת ניתוב תחת ההורה שזהו בעצם הפרק הוא העדפה ראשונה לפי משניות
                    };
                    context.ContentGroups.Add(MishnaInTalmudGroup);
                    context.SaveChanges();

                    #endregion


                    //כעת בוודאי עלינו להוסיף את ההפניה לגרופ הנוכחי
                    var contentStart = currentContents.Where(c => c.SequenceNumber == row.StartMishnaBeforePositionInContent).First();

                    var contentToSuperGroup = new ContentToAlternateGroup
                    {
                        GroupID = MishnaInTalmudGroup.GroupID,
                        FromContentID = contentStart.MainContentID,
                        ToContentID = contentStart.MainContentID,//מאתחלים אותו בתור סיום שזה הוא בעצמו
                        VersionID = version.VersionID
                    };
                    context.ContentToAlternateGroups.Add(contentToSuperGroup);
                    context.SaveChanges();
                }

                #endregion

                #region EndMishna



                //אם מסתיימת משנה בשורה הנוכחית יש לסגור את המשנה האחרונה שנפתחה כך שנוכל בעצם לפתוח משנה חדשה בהזדמנות הבאה
                if (row.EndMishnaAfterPositionInContent != null)
                {
                    //חובה למצוא משנה פתוחה אחרת הוא יזרוק שגיאה
                    //העובדה כי המשנה מסתיימת ומתחילה באותה מילה אומרת לנו שהמשנה הוא פתוחה כלומר שהתחילה ועדיין לא סגרו אותה 
                    //לכן שמנו ערכים שווים בהתחלה ובסיום שלה

                    //נאתר תחילה את המשנה האחרונה וזו צריכה להיות פתוחה
                    var lastMaishna = context.ContentGroups
                        .Where(g => g.GroupType == groupsTypesRepo.MishnaInTalmud && g.ParentGroupID == currentChapterGroup.GroupID)
                        .OrderByDescending(g => g.SequenceNumber).FirstOrDefault();

                    if (!context.ContentToAlternateGroups.Any(c => c.GroupID == lastMaishna.GroupID && c.FromContentID == c.ToContentID))
                    {
                        throw new Exception("לא נמצאה משנה פתוחה על מנת לסגור אותה כאן המשנה האחרונה שנמצאה היא סגורה");
                    }
                    else
                    {
                        //אם הכל בסדר הרי שזה הזמן לסגור את המשנה הנוכחית
                        var contentToAlternateGroup = context.ContentToAlternateGroups
                            .OrderByDescending(c => c.ContentGroup.SequenceNumber)
                            .First(c => c.GroupID == lastMaishna.GroupID && c.FromContentID == c.ToContentID);

                        //כעת בוודאי עלינו להוסיף את ההפניה לגרופ הנוכחי
                        var contentEnd = currentContents.Where(c => c.SequenceNumber == row.EndMishnaAfterPositionInContent).First();

                        contentToAlternateGroup.ToContentID = contentEnd.MainContentID;
                        context.SaveChanges();
                    }

                }

                #endregion

                #endregion


                #region GmaraInTalmudGroupHandling


                #region StartGmara


                //אם מתחילה משנה בתוך השורה הנוכחית
                if (row.StartGmaraBeforePositionInContent != null)
                {
                    if (currentChapterGroup == null)
                    {
                        throw new Exception("לא ניתן להתחיל גמרא אם אין פרק נוכחי קיים");
                    }

                    #region GmaraInTalmudGroup 

                    //כעת עלינו לכאורה ליצור גרופ חדש של גמרא הואיל וזאת היא תחילת הגמרא
                    //ואולם אם כבר קיים גרופ כזה שלא נסגר אות היא שאנו בבעיה לוגית

                    //לכן נבדוק תחילה אם קיים גרופ לא סגור של גמרא
                    var openGmara = (from c in context.ContentToAlternateGroups
                                     join g in context.ContentGroups on c.GroupID equals g.GroupID
                                     where
                                       g.GroupType == groupsTypesRepo.GmaraInTalmud//זה צריך להיות גרופ מסוג גמרא
                                       && g.ParentGroupID == currentChapterGroup.GroupID //ההורה של הגרופ צריך להיות הפרק הנוכחי
                                       && c.FromContentID == c.ToContentID //מדובר בגרופ פתוח
                                     select g);

                    if (openGmara != null && openGmara.Count() > 0)
                    {
                        throw new Exception("קיימת גמרא פתוחה כבר מזהה הגרופ:" + openGmara.First().GroupID);
                    }

                    //בשלב הזה אנו סמוכים ובטוחים שאין לנו גמרא פתוחה ולכן יש לפתוח גמרא חדשה

                    //אולם לפני כן יש לאתר את המשנה האחרונה שנפתחה ומן הסתם גם נסגרה וזאת על מנת לשמור על רצף מספרי בין הגמרות
                    var lastGmaraSequenceNumber = context.ContentGroups
                        .Where(g => g.GroupType == groupsTypesRepo.GmaraInTalmud
                                  && g.ParentGroupID == currentChapterGroup.GroupID)
                        .Max(g => g.SequenceNumber);

                    //יוצרים גרופ חדש של דמרא
                    var GmaraInTalmudGroup = new ContentGroup
                    {
                        ParentGroupID = currentChapterGroup.GroupID,
                        GroupType = groupsTypesRepo.GmaraInTalmud,
                        SequenceNumber = lastGmaraSequenceNumber + 1, //הואיל וזו פעם ראשונה שמוסיפים גמרא חדשה לפרק הנוכחי מן ההכרח שהוא הראשון
                        RootGroupID = currentChapterGroup.GroupID,//ההורה הוא הפרק הנוכחי
                        RoutePriority = 2//העדפת ניתוב תחת ההורה שזהו בעצם הפרק הוא העדפה שניה לפי גמרא
                    };
                    context.ContentGroups.Add(GmaraInTalmudGroup);
                    context.SaveChanges();

                    #endregion


                    //כעת בוודאי עלינו להוסיף את ההפניה לגרופ הנוכחי
                    var contentStart = currentContents.Where(c => c.SequenceNumber == row.StartGmaraBeforePositionInContent).First();

                    var contentToAlternateGroup = new ContentToAlternateGroup
                    {
                        GroupID = GmaraInTalmudGroup.GroupID,
                        FromContentID = contentStart.MainContentID,
                        ToContentID = contentStart.MainContentID,//מאתחלים אותו בתור סיום שזה הוא בעצמו
                        VersionID = version.VersionID
                    };
                    context.ContentToAlternateGroups.Add(contentToAlternateGroup);
                    context.SaveChanges();
                }

                #endregion

                #region EndGmara



                //אם מסתיימת משנה בשורה הנוכחית יש לסגור את המשנה האחרונה שנפתחה כך שנוכל בעצם לפתוח משנה חדשה בהזדמנות הבאה
                if (row.EndGmaraAfterPositionInContent != null)
                {
                    //חובה למצוא גמרא פתוחה אחרת הוא יזרוק שגיאה
                    //העובדה כי המשנה מסתיימת ומתחילה באותה מילה אומרת לנו שהגמרא הוא פתוחה כלומר שהתחילה ועדיין לא סגרו אותה 
                    //לכן שמנו ערכים שווים בהתחלה ובסיום שלה

                    //נאתר תחילה את הגמרא האחרונה וזו צריכה להיות פתוחה
                    var lastGmara = context.ContentGroups
                        .Where(g => g.GroupType == groupsTypesRepo.GmaraInTalmud && g.ParentGroupID == currentChapterGroup.GroupID)
                        .OrderByDescending(g => g.SequenceNumber).FirstOrDefault();

                    if (!context.ContentToAlternateGroups.Any(c => c.GroupID == lastGmara.GroupID && c.FromContentID == c.ToContentID))
                    {
                        throw new Exception("לא נמצאה גמרא פתוחה על מנת לסגור אותה כאן הגמרא האחרונה שנמצאה היא סגורה");
                    }
                    else
                    {
                        //אם הכל בסדר הרי שזה הזמן לסגור את הגמרא הנוכחית
                        var contentToAlternateGroup = context.ContentToAlternateGroups
                            .OrderByDescending(c => c.ContentGroup.SequenceNumber)
                            .First(c => c.GroupID == lastGmara.GroupID && c.FromContentID == c.ToContentID);

                        //כעת בוודאי עלינו להוסיף את ההפניה לגרופ הנוכחי
                        var contentEnd = currentContents.Where(c => c.SequenceNumber == row.EndGmaraAfterPositionInContent).First();

                        contentToAlternateGroup.ToContentID = contentEnd.MainContentID;
                        context.SaveChanges();
                    }

                }

                #endregion



                #endregion


                #endregion


            }

            #endregion


        }


        /// <summary>
        /// מייבא עמוד בתלמוד בבלי לטבלת 
        /// [Import].[TalmudBavliRawImport]
        /// </summary>
        /// <param name="amudToImport"></param>
        public void ImportAmudToRawTable(AmudTalmudBavli amudToImport)
        {

            #region Validations

            if (!amudToImport.IsValid && false)
            {
                foreach (var msg in amudToImport.ValidationsMessages.ToList())
                {
                    throw new Exception("עמוד לא חוקי", new Exception(msg));
                }
            }
            #endregion

            var masechetName = amudToImport.Masechet.ToString();

            var currentRow = context.TalmudBavliRawImports.Where(r => r.Masechet == masechetName
            && r.DafNumber == amudToImport.DafNumber
            && r.AmudNumber == amudToImport.AmudNumber).FirstOrDefault();

            if (currentRow != null)
            {
                return;
            }

            var rows = new List<TalmudBavliRawImport>();
            foreach (var row in amudToImport.Rows)
            {
                var newRow = new TalmudBavliRawImport
                {
                    Masechet = masechetName,
                    DafNumber = amudToImport.DafNumber,
                    AmudNumber = amudToImport.AmudNumber,
                    RowNumber = row.SequenceNumber,
                    Content = row.Content,
                    StartMishnaPosition = row.StartMishnaBeforePositionInContent,
                    EndMishnaPosition = row.EndMishnaAfterPositionInContent,
                    StartGemaraPosition = row.StartGmaraBeforePositionInContent,
                    EndGemaraPosition = row.EndGmaraAfterPositionInContent,
                    StartChapterName = row.StartChapterName
                };
                rows.Add(newRow);

            }
            context.TalmudBavliRawImports.AddRange(rows);
            context.SaveChanges();
        }


        public void UpdateRowsInRawTable(List<RowInTalmudBavli> rows)
        {

            if (rows.Any(r => r.InAmud == null))
            {
                throw new AggregateException("חייבת להיות הפניה לעמוד בכל השורות");
            }
            var rowsFromDB = context.TalmudBavliRawImports.ToList(); //.Where(r => r.RowNumber == 1).ToList();
            var totalToUpdate = new List<TalmudBavliRawImport>();
            foreach (var rowFromParm in rows)
            {
                var rowToUpdate = rowsFromDB.FirstOrDefault(r =>
                r.Masechet == rowFromParm.InAmud.Masechet.Name
                && r.DafNumber == rowFromParm.InAmud.DafNumber
                && r.AmudNumber == rowFromParm.InAmud.AmudNumber
                && r.RowNumber == rowFromParm.SequenceNumber
                );
                if (rowToUpdate != null && rowToUpdate.Content!=rowFromParm.Content)
                {
                    totalToUpdate.Add(rowToUpdate);
                    rowToUpdate.Content = rowFromParm.Content;
                    //rowToUpdate.StartMishnaPosition = rowFromParm.StartMishnaBeforePositionInContent;
                    //rowToUpdate.EndMishnaPosition = rowFromParm.EndMishnaAfterPositionInContent;
                    //rowToUpdate.StartGemaraPosition = rowFromParm.StartGmaraBeforePositionInContent;
                    //rowToUpdate.StartChapterName = rowFromParm.StartChapterName;
                }
            }
           
            context.SaveChanges();

        }


        public void RefactorRawImportTable()
        {

        }

        public static Dictionary<string, string> MasechtotKeyWord = new Dictionary<string, string> {
            {"ברכות","Berakhot" },
            {"שבת","Shabbat" },
            {"עירובין","Eruvin" },
            {"פסחים","Pesachim" },
            {"שקלים","Shekalim" },
            {"ראש השנה","RoshHashanah" },
            {"יומא","Yoma" },
            {"סוכה","Sukkah" },
            {"ביצה","Beitza" },
            {"תענית","Taanit" },
            {"מגילה","Megillah" },
            {"מועד קטן","MoedKatan" },
            {"חגיגה","Hagigah" },
            {"יבמות","Yevamot" },
            {"כתובות","Ketubot" },
            {"נדרים","Nedarim" },
            {"נזיר","Nazir" },
            {"סוטה","Sotah" },
            {"גיטין","Gittin" },
            {"קידושין","Kiddushin" },
            {"בבא קמא","BavaKamma" },
            {"בבא מציעא","BavaMetzia" },
            {"בבא בתרא","BavaBatra" },
            { "סנהדרין","Sanhedrin" },
            {"מכות","Makkot" },
            {"שבועות","Shevuot" },
            {"עבודה זרה","AvodahZarah" },
            {"הוריות","Horayot" },
            {"זבחים","Zevahim" },
            {"מנחות","Menachot" },
            { "חולין","Hullin" },
            {"בכורות","Bekhorot" },
            {"ערכין","Arakhin" },
            {"תמורה","Temurah" },
            {"כריתות","Keritot" },
            {"מעילה","Meilah" },
            {"נידה","Niddah" },
        };
        public void ImportFromRawToMainContent()
        {
            // ראשית יש ליצור את הגרופים המתאימים דהיינו מסכתות דפים עמודים ושורות
            // הגרופ של תלמוד בבלי נוצר כבר פעם אחת
            talmudBavliGroup = context.ContentGroups.Where(g => g.KeyWordIndex == "TalmudBavli").First();
            // ניצור גרופ לכל מסכת כל עוד וזה לא קיים
            var masechtotCounter = 1;
            var masechtotList = new List<ContentGroup>();

            var bookType = context.GroupsAndDividingTypes.First(t => t.KeyWordIndex == "Book");

            foreach (var masechet in MasechtotKeyWord)
            {
                // נעשה באמצעות סיקוול ישיר עדיף מאשר להתבחבש יתר על המדה
                var sql = @"
select distinct DafNumber,SUBSTRING(i.KeyWordIndex,1, CHARINDEX('.',i.KeyWordIndex,13)-1) as KeyWordIndexParentGroup
,Masechet
,'                                                               ' as KeyWordIndex
,0 as ParentGroupID
,DafNumber-1 AS SequenceNumber
into #pages
from Import.TalmudBavliRawImport i;
-- עדכון מזהה קבוצה
update p 
set p.ParentGroupID=g.GroupID,
p.KeyWordIndex=CONCAT(p.KeyWordIndexParentGroup,'.',p.DafNumber)
from #pages p join Contents.ContentGroups g
on p.KeyWordIndexParentGroup=g.KeyWordIndex;
DECLARE @GroupTypeDaf INT = (SELECT TOP 1 ID FROM Contents.GroupsAndDividingTypes where KeyWordIndex='Daf');
DECLARE @TalmudBavliRootGroup INT = (select top 1 GroupID from Contents.ContentGroups where KeyWordIndex='TalmudBavli');
-- כעת יש ליצור גרופים של דפים עבור כל מסכת כזו בתנאי שלא קיימים
-- insert Contents.ContentGroups(GroupName,GroupType,KeyWordIndex,ParentGroupID,RootGroupID,SequenceNumber)
SELECT NULL GroupName, @GroupTypeDaf as GroupType,p.KeyWordIndex,p.ParentGroupID,@TalmudBavliRootGroup AS RootGroupID,p.SequenceNumber
FROM  #pages p
LEFT JOIN Contents.ContentGroups g on p.KeyWordIndex=g.KeyWordIndex
WHERE g.GroupID IS NULL;

drop table  #pages;
";


                var currentMasechet = context.ContentGroups.FirstOrDefault(g => g.ParentGroupID == talmudBavliGroup.GroupID
                && g.GroupName == masechet.Key);
                var NotExistsInDatabase = (currentMasechet == null);
                if (NotExistsInDatabase)
                {
                    currentMasechet = new ContentGroup
                    {
                        GroupName = masechet.Key,
                        ParentGroupID = talmudBavliGroup.GroupID
                    };
                }
                currentMasechet.KeyWordIndex = $"{talmudBavliGroup.KeyWordIndex}.{masechet.Value}";
                currentMasechet.RootGroupID = talmudBavliGroup.GroupID;
                currentMasechet.SequenceNumber = masechtotCounter;
                currentMasechet.SequenceNumberByRootGroup = masechtotCounter;
                currentMasechet.GroupType = bookType.ID;
                if (NotExistsInDatabase)
                {
                    context.ContentGroups.Add(currentMasechet);
                }
                masechtotList.Add(currentMasechet);
                masechtotCounter++;
            }
            context.SaveChanges();


            var dafType = context.GroupsAndDividingTypes.First(t => t.KeyWordIndex == "Daf");

            // כעת יש להוסיף דפים לכל מסכת
            var pagesGroups = new List<ContentGroup>();
            foreach (var item in masechtotList)
            {
                var kwyWord = $"{item.KeyWordIndex}";
                // כמה דפים יש במסכת הזו?
                var pages = (int)context.TalmudBavliRawImports.Where(i => i.KeyWordIndex.StartsWith(kwyWord)).Max(i => i.DafNumber);
                var pagesRange = Enumerable.Range(2, pages - 1).ToList();
                // אם כל הדפים כבר קיימים הנה מה טוב
                var fromDB = context.ContentGroups.Where(g =>
                    g.ParentGroupID == item.GroupID && g.GroupType == dafType.ID).ToList();
                if (fromDB.Count==pagesRange.Count)
                {
                    continue;
                }
                
                foreach (var page in pagesRange)
                {
                    var currentPage = new ContentGroup
                    {
                        ParentGroupID = item.GroupID,
                        GroupType=dafType.ID,
                        KeyWordIndex=$"{item.KeyWordIndex}.{page}",
                        SequenceNumber=page,
                        RootGroupID = talmudBavliGroup.GroupID
                    };
                    pagesGroups.Add(currentPage);
                    context.ContentGroups.Add(currentPage);
                }
            }
            var count = pagesGroups.Count;



            // var rows = context.TalmudBavliRawImports.ToList();


        }

    }
}
