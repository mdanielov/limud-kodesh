using Microsoft.VisualStudio.TestTools.UnitTesting;
using HebrewTexts.Logic.Persistence.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Logic.Persistence.Repositories.Tests
{
    [TestClass()]
    public class ContentGroupsRepositoryTests
    {
        [TestMethod()]
        public void GetAncestorsTest()
        {
            var repo = new ContentGroupsRepository(AppUser.GetForTests());
            var result = repo.GetAncestors(40);
        }
    }
}