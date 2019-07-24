using HebrewTexts.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Logic.DTOs
{
    /// <summary>
    /// זהו קלאס שאחראי להמיר סוג קונטנט גרופ לסוג די טיאו
    /// </summary>
    public static class ContentGroupDtoExtension
    {
        /// <summary>
        /// המרה של אובייקט גרופ לאובייקט מכוון יואיי
        /// </summary>
        /// <param name="source"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public static IEnumerable<ContentGroupDto> ToDto(this IEnumerable<ContentGroup> source,AppUser user = null)
        {
            var result = new List<ContentGroupDto>();
            AutoMapper.Mapper.Map(source, result);
            //source.ToList().ForEach(g=> result.Add(new ContentGroupDto { GroupID=g.GroupID,
            //    GroupName =g.GroupName,
            //GroupType = g.GroupType}));
            SetExpandedProperties(result,user);
            return result;
        }

        private static IEnumerable<ContentGroupDto> SetExpandedProperties(IEnumerable<ContentGroupDto> dtos, AppUser user)
        {
            var db = new DB(user);
            var listOfTypes = dtos.Select(g => g.GroupType).Distinct().ToList();
            var types = db.Entities.GroupsAndDividingTypes.Where(t => listOfTypes.Contains(t.ID)).ToList();
            types.ForEach(t => dtos.Where(g => g.GroupType == t.ID).ToList()
            .ForEach(g => { g.GroupTypeDisplay = t.Name; g.GroupTypeKeyWord = t.KeyWordIndex; })
            );
            // כעת נגדיר פרופרטיז של יואיי
            dtos.Where(g => g.GroupTypeKeyWord == "Book").ToList().ForEach(g => g.AllowReadingDirectly = true);
            dtos.Where(g => g.GroupTypeKeyWord == "Chapter").ToList().ForEach(g => {
                g.GoReadingDirectly = true;
                g.GroupName = (g.SequenceNumber ?? 1).ToAlphabetNumbers();
            }
            );
            dtos.Where(g => g.GroupTypeKeyWord == "Parashah"|| g.GroupTypeKeyWord == "WeeklyTorahPortion")
                .ToList().ForEach(g => {
                g.GoReadingDirectly = true;
            }
);
            

            return dtos;
        }
        /// <summary>
        /// https://stackoverflow.com/questions/30675226/convert-number-to-string-using-hebrew-letters
        /// </summary>
        /// <param name="num"></param>
        /// <returns></returns>
        static string ToAlphabetNumbers(this int num)
        {
            if (num <= 0)
                throw new ArgumentOutOfRangeException();
            StringBuilder ret = new StringBuilder(new string('ת', num / 400));
            num %= 400;
            if (num >= 100)
            {
                ret.Append("קרש"[num / 100 - 1]);
                num %= 100;
            }
            switch (num)
            {
                // Avoid letter combinations from the Tetragrammaton
                case 16:
                    ret.Append("טז");
                    break;
                case 15:
                    ret.Append("טו");
                    break;
                default:
                    if (num >= 10)
                    {
                        ret.Append("כלמנסעפצי"[num / 10 - 1]);
                        num %= 10;
                    }
                    if (num > 0)
                        ret.Append("אבגדהוזחט"[num - 1]);
                    break;
            }
            return ret.ToString();
        }

    }
}
