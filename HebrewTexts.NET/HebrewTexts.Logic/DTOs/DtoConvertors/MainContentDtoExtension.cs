using HebrewTexts.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Logic.DTOs.DtoConvertors
{
    /// <summary>
    /// הרחבה להמרת תוכל לדיטיאו
    /// </summary>
    public static class MainContentDtoExtension
    {
        /// <summary>
        /// המרה של אובייקט גרופ לאובייקט מכוון יואיי
        /// </summary>
        /// <param name="source"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public static IEnumerable<MainContentDto> ToDto(this IEnumerable<MainContent> source, AppUser user = null)
        {
            var result = new List<MainContentDto>();
            source.ToList().ForEach(c => result.Add(
                new MainContentDto
            {
                GroupID = c.GroupID,
                Content = c.Content,
                MainContentID = c.MainContentID
            }));
            
            return result;
        }

    }
}
