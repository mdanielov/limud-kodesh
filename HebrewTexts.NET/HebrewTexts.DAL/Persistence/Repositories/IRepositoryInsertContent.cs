using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.DAL.Persistence.Repositories
{
    interface IRepositoryInsertContent
    {
        void InsertPart(string bookName,int page,int rowNumber, string content);

    }
}
